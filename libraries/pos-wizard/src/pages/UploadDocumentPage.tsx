import { IdCameraCapture } from "../components/IdCameraCapture";
import { IdCardUpload } from "../components/IdCardUploadForm";
import { useIdCardImageFlow } from "../hooks/useIdCardImageFlow";
import type { IdCardExtraction } from "../types/idCardCapture";

type UploadDocumentPageProps = {
  onExtractionComplete: (
    extraction: IdCardExtraction,
    previewUrl: string | null,
    imageBlob: Blob | null,
  ) => void;
};

const UploadDocumentPage = ({
  onExtractionComplete,
}: UploadDocumentPageProps) => {
  const flow = useIdCardImageFlow({ logPrefix: "[ID wizard]" });

  const canContinue =
    flow.extraction !== null && !flow.isExtracting && !flow.extractionError;

  const handleContinue = () => {
    if (!flow.extraction) {
      return;
    }

    onExtractionComplete(flow.extraction, flow.previewUrl, flow.imageBlob);
  };

  return (
    <section>
      <header>
        <h1>Register contact</h1>
        <p>
          Scan or upload an ID card. After OCR finishes, continue to review and
          edit the extracted details.
        </p>
      </header>

      <IdCameraCapture flow={flow} />
      <IdCardUpload flow={flow} />

      <div className="wizard-actions">
        <button
          type="button"
          onClick={handleContinue}
          disabled={!canContinue}
        >
          {flow.isExtracting
            ? "Extracting fields…"
            : canContinue
              ? "Continue to contact form"
              : "Confirm ID photo to continue"}
        </button>
      </div>
    </section>
  );
};

export default UploadDocumentPage;
