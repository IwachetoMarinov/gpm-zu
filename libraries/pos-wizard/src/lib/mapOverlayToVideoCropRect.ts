import type { CropRect } from "../types/idCardCapture";

export const mapOverlayToVideoCropRect = (
  video: HTMLVideoElement,
  overlay: HTMLElement,
): CropRect => {
  const videoRect = video.getBoundingClientRect();
  const overlayRect = overlay.getBoundingClientRect();

  const elementWidth = video.clientWidth;
  const elementHeight = video.clientHeight;
  const intrinsicWidth = video.videoWidth;
  const intrinsicHeight = video.videoHeight;

  if (
    elementWidth === 0 ||
    elementHeight === 0 ||
    intrinsicWidth === 0 ||
    intrinsicHeight === 0
  ) {
    return { x: 0, y: 0, width: 0, height: 0 };
  }

  const scale = Math.max(
    elementWidth / intrinsicWidth,
    elementHeight / intrinsicHeight,
  );
  const displayedWidth = intrinsicWidth * scale;
  const displayedHeight = intrinsicHeight * scale;
  const offsetX = (elementWidth - displayedWidth) / 2;
  const offsetY = (elementHeight - displayedHeight) / 2;

  const relativeX = overlayRect.left - videoRect.left;
  const relativeY = overlayRect.top - videoRect.top;

  const x = Math.floor((relativeX - offsetX) / scale);
  const y = Math.floor((relativeY - offsetY) / scale);
  const width = Math.floor(overlayRect.width / scale);
  const height = Math.floor(overlayRect.height / scale);

  const clampedX = Math.min(Math.max(0, x), intrinsicWidth);
  const clampedY = Math.min(Math.max(0, y), intrinsicHeight);
  const clampedWidth = Math.min(Math.max(0, width), intrinsicWidth - clampedX);
  const clampedHeight = Math.min(
    Math.max(0, height),
    intrinsicHeight - clampedY,
  );

  return {
    x: clampedX,
    y: clampedY,
    width: clampedWidth,
    height: clampedHeight,
  };
};
