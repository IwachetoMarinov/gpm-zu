import type { CropRect } from "../types/idCardCapture";

const canvasToJpegBlob = (
  canvas: HTMLCanvasElement,
  quality = 0.92,
): Promise<Blob | undefined> => {
  return new Promise((resolve) => {
    canvas.toBlob(
      (blob) => {
        resolve(blob ?? undefined);
      },
      "image/jpeg",
      quality,
    );
  });
};

export const cropVideoFrameToBlob = async (
  video: HTMLVideoElement,
  cropRect: CropRect,
): Promise<Blob | undefined> => {
  if (cropRect.width < 1 || cropRect.height < 1) {
    return undefined;
  }

  const canvas = document.createElement("canvas");
  canvas.width = cropRect.width;
  canvas.height = cropRect.height;

  const context = canvas.getContext("2d");
  if (!context) {
    return undefined;
  }

  context.drawImage(
    video,
    cropRect.x,
    cropRect.y,
    cropRect.width,
    cropRect.height,
    0,
    0,
    cropRect.width,
    cropRect.height,
  );

  return canvasToJpegBlob(canvas);
};
