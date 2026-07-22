import { blobToCanvas } from "./blobToCanvas";
import {
  NORMALIZED_CARD_HEIGHT,
  NORMALIZED_CARD_WIDTH,
} from "./idCardFieldLayout";

/**
 * Stretch the captured/cropped card into a fixed ID-1 canvas so field ROIs are stable.
 */
export const normalizeIdCardImage = async (
  imageBlob: Blob,
): Promise<HTMLCanvasElement> => {
  const source = await blobToCanvas(imageBlob);
  const canvas = document.createElement("canvas");
  canvas.width = NORMALIZED_CARD_WIDTH;
  canvas.height = NORMALIZED_CARD_HEIGHT;

  const context = canvas.getContext("2d");
  if (!context) {
    throw new Error(
      "Unable to create a canvas context for ID card normalization.",
    );
  }

  context.imageSmoothingEnabled = true;
  context.imageSmoothingQuality = "high";
  context.fillStyle = "#ffffff";
  context.fillRect(0, 0, canvas.width, canvas.height);
  context.drawImage(source, 0, 0, canvas.width, canvas.height);

  return canvas;
};
