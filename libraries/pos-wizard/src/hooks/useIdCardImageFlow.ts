import { useEffect, useState } from "react";
import { extractIdCardTextDump } from "../lib/extractIdCardTextDump";
import { validateIdCardImage } from "../lib/validateIdCardImage";
import type { IdCardExtraction } from "../types/idCardCapture";

type UseIdCardImageFlowOptions = {
  logPrefix?: string;
};

export type IdCardImageFlow = ReturnType<typeof useIdCardImageFlow>;

export const useIdCardImageFlow = (options: UseIdCardImageFlowOptions = {}) => {
  const logPrefix = options.logPrefix ?? "[ID image]";

  const [imageBlob, setImageBlob] = useState<Blob | null>(null);
  const [previewUrl, setPreviewUrl] = useState<string | null>(null);
  const [isValidating, setIsValidating] = useState(false);
  const [isConfirmed, setIsConfirmed] = useState(false);
  const [isExtracting, setIsExtracting] = useState(false);
  const [extraction, setExtraction] = useState<IdCardExtraction | null>(null);
  const [extractionError, setExtractionError] = useState<string | null>(null);
  const [validationErrors, setValidationErrors] = useState<string[]>([]);

  useEffect(() => {
    if (!imageBlob) {
      setPreviewUrl(null);
      return;
    }

    const objectUrl = URL.createObjectURL(imageBlob);
    setPreviewUrl(objectUrl);
    console.log(`${logPrefix} Preview object URL:`, objectUrl);

    return () => {
      URL.revokeObjectURL(objectUrl);
    };
  }, [imageBlob, logPrefix]);

  const reset = () => {
    setImageBlob(null);
    setIsConfirmed(false);
    setIsExtracting(false);
    setExtraction(null);
    setExtractionError(null);
    setValidationErrors([]);
  };

  const submitImage = async (blob: Blob) => {
    setIsValidating(true);
    setValidationErrors([]);
    setIsConfirmed(false);
    setExtraction(null);
    setExtractionError(null);

    try {
      console.log(`${logPrefix} Image blob:`, {
        type: blob.type,
        sizeBytes: blob.size,
        sizeKb: Number((blob.size / 1024).toFixed(1)),
      });

      const validation = await validateIdCardImage(blob);
      console.log(`${logPrefix} Validation result:`, validation);

      if (!validation.ok) {
        console.warn(`${logPrefix} Validation failed:`, validation.reasons);
        setValidationErrors(validation.reasons);
        setImageBlob(null);
        return false;
      }

      console.log(`${logPrefix} Validation passed. Showing review step.`);
      setImageBlob(blob);
      return true;
    } catch (error) {
      console.error(`${logPrefix} Validate error:`, error);
      setValidationErrors([
        "Unable to validate the ID image. Please try again.",
      ]);
      setImageBlob(null);
      return false;
    } finally {
      setIsValidating(false);
    }
  };

  const confirmAndExtract = async () => {
    if (!imageBlob) {
      return;
    }

    console.log(`${logPrefix} Image confirmed:`, {
      type: imageBlob.type,
      sizeBytes: imageBlob.size,
      previewUrl,
    });

    setIsConfirmed(true);
    setIsExtracting(true);
    setExtraction(null);
    setExtractionError(null);

    try {
      const result = await extractIdCardTextDump(imageBlob);

      console.log(`${logPrefix} PaddleOCR text-dump result:`, result);
      setExtraction(result);
    } catch (error) {
      const message =
        error instanceof Error
          ? error.message
          : "Local PaddleOCR failed. Please try again.";
      console.error(`${logPrefix} Extraction failed:`, error);
      setExtractionError(message);
    } finally {
      setIsExtracting(false);
    }
  };

  const isReviewing = imageBlob !== null && previewUrl !== null && !isConfirmed;
  const isAccepted = imageBlob !== null && previewUrl !== null && isConfirmed;

  return {
    imageBlob,
    previewUrl,
    isValidating,
    isConfirmed,
    isExtracting,
    extraction,
    extractionError,
    validationErrors,
    isReviewing,
    isAccepted,
    hasValidationErrors: validationErrors.length > 0,
    reset,
    submitImage,
    confirmAndExtract,
    setValidationErrors,
  };
};
