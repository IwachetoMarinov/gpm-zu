import { useId, useRef } from "react";

import { IdCardImageReview } from "./IdCardImageReview";
import { useCamera } from "../hooks/useCamera";
import { useIdCardImageFlow } from "../hooks/useIdCardImageFlow";
import { mapOverlayToVideoCropRect } from "../lib/mapOverlayToVideoCropRect";

export const IdCameraCapture = () => {
  const {
    videoRef,
    isOpening,
    isActive,
    error,
    openCamera,
    closeCamera,
    captureImage,
  } = useCamera();

  const frameRef = useRef<HTMLDivElement | null>(null);
  const statusId = useId();
  const errorId = useId();
  const validationId = useId();
  const extractionErrorId = useId();

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
    setValidationErrors,
  } = useIdCardImageFlow({ logPrefix: "[ID capture]" });

  const handleOpenCamera = async () => {
    reset();
    await openCamera();
  };

  const handleCaptureImage = async () => {
    const video = videoRef.current;
    const frame = frameRef.current;

    if (!video || !frame) {
      setValidationErrors([
        "The camera preview is not ready yet. Wait a moment and try again.",
      ]);
      return;
    }

    const cropRect = mapOverlayToVideoCropRect(video, frame);
    console.log("[ID capture] Crop region (video pixels):", cropRect);
    console.log("[ID capture] Video size:", {
      videoWidth: video.videoWidth,
      videoHeight: video.videoHeight,
      clientWidth: video.clientWidth,
      clientHeight: video.clientHeight,
    });

    const imageBlob = await captureImage(cropRect);
    if (!imageBlob) {
      console.warn("[ID capture] No image blob returned from capture.");
      return;
    }

    await submitImage(imageBlob);
  };

  const handleRetakeImage = () => {
    console.log("[ID capture] Retake requested. Clearing captured image.");
    reset();
  };

  const handleCloseCamera = () => {
    console.log("[ID capture] Camera closed. Clearing capture state.");
    reset();
    closeCamera();
  };

  const showLivePreview = isActive && !isReviewing && !isAccepted;

  return (
    <section className="id-camera" aria-labelledby="id-camera-heading">
      <header className="id-camera__header">
        <h2 id="id-camera-heading">Scan your ID card</h2>
        <p>
          1) Open the camera and align your ID in the dashed guide. 2) Capture —
          we crop to that guide and check quality. 3) Review the cropped photo
          and confirm before continuing.
        </p>
      </header>

      <div
        className="id-camera__viewport"
        aria-busy={isOpening || isValidating}
        aria-describedby={
          error ? errorId : hasValidationErrors ? validationId : statusId
        }
      >
        {isOpening ? (
          <p id={statusId} className="id-camera__status" role="status">
            Requesting camera access…
          </p>
        ) : null}

        {isValidating ? (
          <p
            id={statusId}
            className="id-camera__status id-camera__status--processing"
            role="status"
          >
            Capturing, cropping to the guide, and checking quality…
          </p>
        ) : null}

        {!isOpening &&
        !isValidating &&
        !isActive &&
        !isReviewing &&
        !isAccepted ? (
          <p id={statusId} className="id-camera__status">
            Camera is closed. Choose “Open camera” to begin.
          </p>
        ) : null}

        {showLivePreview && !isValidating ? (
          <p id={statusId} className="visually-hidden">
            Live preview active. Align your ID card inside the frame, then
            capture.
          </p>
        ) : null}

        <div
          className={
            showLivePreview
              ? "id-camera__stage"
              : "id-camera__stage id-camera__stage--hidden"
          }
        >
          <video
            ref={videoRef}
            className="id-camera__video"
            autoPlay
            playsInline
            muted
            aria-label="Live camera preview for ID card capture"
          />
          <div className="id-camera__overlay" aria-hidden="true">
            <div ref={frameRef} className="id-camera__frame">
              <span className="id-camera__frame-label">Align ID card here</span>
            </div>
          </div>
        </div>
      </div>

      {error ? (
        <p id={errorId} className="id-camera__error" role="alert">
          {error}
        </p>
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
          caption="Cropped to ID-card guide"
          reviewingCopy="This is only the area inside the dashed guide. Confirm if it looks clear, or retake."
          onConfirm={() => {
            void confirmAndExtract();
          }}
          onReset={handleRetakeImage}
          resetLabel="Retake image"
          extraActions={
            <button
              type="button"
              className="id-camera__button id-camera__button--secondary"
              onClick={handleCloseCamera}
              disabled={isExtracting}
            >
              Close camera
            </button>
          }
        />
      ) : null}

      <div className="id-camera__controls">
        {!isActive && !isReviewing && !isAccepted ? (
          <button
            type="button"
            className="id-camera__button"
            onClick={() => {
              void handleOpenCamera();
            }}
            disabled={isOpening}
            aria-describedby={statusId}
          >
            {isOpening ? "Opening camera…" : "Open camera"}
          </button>
        ) : null}

        {showLivePreview ? (
          <>
            <button
              type="button"
              className="id-camera__button"
              onClick={() => {
                void handleCaptureImage();
              }}
              disabled={isValidating || isOpening}
            >
              {isValidating ? "Cropping & checking…" : "Capture image"}
            </button>
            <button
              type="button"
              className="id-camera__button id-camera__button--secondary"
              onClick={handleCloseCamera}
            >
              Close camera
            </button>
          </>
        ) : null}
      </div>
    </section>
  );
};
