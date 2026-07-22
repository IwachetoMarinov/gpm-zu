import type { ReactNode } from "react";

import type { IdCardExtraction } from "../types/idCardCapture";

type IdCardImageReviewProps = {
  previewUrl: string;
  isAccepted: boolean;
  isExtracting: boolean;
  extraction: IdCardExtraction | null;
  extractionError: string | null;
  validationErrors: string[];
  validationId: string;
  extractionErrorId: string;
  caption: string;
  reviewingCopy: string;
  onConfirm: () => void;
  onReset: () => void;
  resetLabel: string;
  extraActions?: ReactNode;
};

export const IdCardImageReview = ({
  previewUrl,
  isAccepted,
  isExtracting,
  extraction,
  extractionError,
  validationErrors,
  validationId,
  extractionErrorId,
  caption,
  reviewingCopy,
  onConfirm,
  onReset,
  resetLabel,
  extraActions,
}: IdCardImageReviewProps) => {
  const hasValidationErrors = validationErrors.length > 0;

  return (
    <>
      <div className="id-camera__review" aria-live="polite">
        <h3 className="id-camera__review-title">
          {isAccepted ? "Photo confirmed" : "Review ID photo"}
        </h3>
        <p className="id-camera__review-copy">
          {isAccepted
            ? isExtracting
              ? "Photo confirmed. Running local PaddleOCR, then Qwen field extraction…"
              : "This ID photo is saved for the next step."
            : reviewingCopy}
        </p>

        <figure className="id-camera__crop-figure">
          <div className="id-camera__crop-frame">
            <img
              src={previewUrl}
              alt="ID card photo for review"
              className="id-camera__preview"
            />
          </div>
          <figcaption className="id-camera__crop-caption">{caption}</figcaption>
        </figure>
      </div>

      {hasValidationErrors ? (
        <div id={validationId} className="id-camera__error" role="alert">
          <p className="id-camera__error-title">Photo needs another try:</p>
          <ul className="id-camera__error-list">
            {validationErrors.map((reason) => (
              <li key={reason}>{reason}</li>
            ))}
          </ul>
        </div>
      ) : null}

      {isAccepted ? (
        <p className="id-camera__success" role="status">
          {isExtracting
            ? "Local OCR + Qwen extraction in progress (first model load may take a while)…"
            : extraction
              ? "Extraction finished. Check fields, rawText, and the browser console."
              : "ID photo confirmed."}
        </p>
      ) : null}

      {extractionError ? (
        <p id={extractionErrorId} className="id-camera__error" role="alert">
          {extractionError}
        </p>
      ) : null}

      {extraction ? (
        <div className="id-camera__extraction" aria-live="polite">
          <h3 className="id-camera__review-title">Extracted ID fields</h3>
          <dl className="id-camera__extraction-list">
            <div>
              <dt>First name</dt>
              <dd>{extraction.firstName ?? "—"}</dd>
            </div>
            <div>
              <dt>Last name</dt>
              <dd>{extraction.lastName ?? "—"}</dd>
            </div>
            <div>
              <dt>Full name</dt>
              <dd>{extraction.fullName ?? "—"}</dd>
            </div>
            <div>
              <dt>Document number</dt>
              <dd>{extraction.documentNumber ?? "—"}</dd>
            </div>
            <div>
              <dt>Date of birth</dt>
              <dd>{extraction.dateOfBirth ?? "—"}</dd>
            </div>
            <div>
              <dt>Nationality</dt>
              <dd>{extraction.nationality ?? "—"}</dd>
            </div>
            <div>
              <dt>Expiry date</dt>
              <dd>{extraction.expiryDate ?? "—"}</dd>
            </div>
          </dl>
          {extraction.rawText ? (
            <pre className="id-camera__raw-text">{extraction.rawText}</pre>
          ) : null}
        </div>
      ) : null}

      <div className="id-camera__controls">
        {!isAccepted ? (
          <button
            type="button"
            className="id-camera__button"
            onClick={onConfirm}
            disabled={isExtracting}
          >
            Confirm photo
          </button>
        ) : null}
        <button
          type="button"
          className="id-camera__button id-camera__button--secondary"
          onClick={onReset}
          disabled={isExtracting}
        >
          {resetLabel}
        </button>
        {extraActions}
      </div>
    </>
  );
};
