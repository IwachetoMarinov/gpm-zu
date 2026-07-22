import { useId, useRef } from "react";
import type { ChangeEvent } from "react";

import { IdCardImageReview } from "./IdCardImageReview";
import { useIdCardImageFlow } from "../hooks/useIdCardImageFlow";

const ACCEPTED_IMAGE_TYPES = new Set([
  "image/jpeg",
  "image/jpg",
  "image/png",
  "image/webp",
]);

export const IdCardUpload = () => {
  const inputRef = useRef<HTMLInputElement | null>(null);
  const headingId = useId();
  const statusId = useId();
  const validationId = useId();
  const extractionErrorId = useId();
  const inputId = useId();

  const {
    previewUrl,
    isValidating,
    isExtracting,
    extraction,
    extractionError,
    validationErrors,
    isReviewing,
    isAccepted,
    hasValidationErrors,
    reset,
    submitImage,
    confirmAndExtract,
  } = useIdCardImageFlow({ logPrefix: "[ID upload]" });

  const handleFileChange = async (event: ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    event.target.value = "";

    if (!file) {
      return;
    }

    if (
      !ACCEPTED_IMAGE_TYPES.has(file.type) &&
      !file.type.startsWith("image/")
    ) {
      return;
    }

    await submitImage(file);
  };

  const handleChooseFile = () => {
    inputRef.current?.click();
  };

  const handleReset = () => {
    reset();
    if (inputRef.current) {
      inputRef.current.value = "";
    }
  };

  return (
    <section className="id-camera" aria-labelledby={headingId}>
      <header className="id-camera__header">
        <h2 id={headingId}>Upload your ID card</h2>
        <p>
          1) Choose a clear photo of your ID. 2) We check image quality. 3)
          Review and confirm — then extraction runs with a fully local browser
          OCR model (same as camera capture).
        </p>
      </header>

      <input
        ref={inputRef}
        id={inputId}
        type="file"
        className="visually-hidden"
        accept="image/jpeg,image/png,image/webp,image/jpg"
        onChange={(event) => {
          void handleFileChange(event);
        }}
        disabled={isValidating || isExtracting}
      />

      {!isReviewing && !isAccepted ? (
        <div className="id-camera__upload-panel" aria-busy={isValidating}>
          <p id={statusId} className="id-camera__upload-status" role="status">
            {isValidating
              ? "Checking uploaded image quality…"
              : "No image selected yet. Choose an ID card photo to continue."}
          </p>
          <div className="id-camera__controls">
            <button
              type="button"
              className="id-camera__button"
              onClick={handleChooseFile}
              disabled={isValidating}
              aria-describedby={statusId}
            >
              {isValidating ? "Checking image…" : "Choose ID image"}
            </button>
          </div>
        </div>
      ) : null}

      {hasValidationErrors && !isReviewing && !isAccepted ? (
        <div id={validationId} className="id-camera__error" role="alert">
          <p className="id-camera__error-title">Photo needs another try:</p>
          <ul className="id-camera__error-list">
            {validationErrors.map((reason) => (
              <li key={reason}>{reason}</li>
            ))}
          </ul>
        </div>
      ) : null}

      {(isReviewing || isAccepted) && previewUrl ? (
        <IdCardImageReview
          previewUrl={previewUrl}
          isAccepted={isAccepted}
          isExtracting={isExtracting}
          extraction={extraction}
          extractionError={extractionError}
          validationErrors={validationErrors}
          validationId={validationId}
          extractionErrorId={extractionErrorId}
          caption="Uploaded ID card image"
          reviewingCopy="Confirm if the uploaded ID looks clear, or choose another image."
          onConfirm={() => {
            void confirmAndExtract();
          }}
          onReset={handleReset}
          resetLabel="Choose another image"
          extraActions={
            <button
              type="button"
              className="id-camera__button id-camera__button--secondary"
              onClick={handleChooseFile}
              disabled={isValidating || isExtracting}
            >
              Replace file
            </button>
          }
        />
      ) : null}
    </section>
  );
};
