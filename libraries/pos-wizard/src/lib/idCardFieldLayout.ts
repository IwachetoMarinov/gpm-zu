import type { CropRect } from "../types/idCardCapture";

/** ISO/IEC 7810 ID-1 aspect (~1.586), used as the local OCR coordinate space. */
export const NORMALIZED_CARD_WIDTH = 1000;
export const NORMALIZED_CARD_HEIGHT = 630;

export type IdCardFieldKey =
  | "lastName"
  | "firstName"
  | "nationality"
  | "dateOfBirth"
  | "expiryDate"
  | "documentNumber";

export type IdCardFieldMode = "text" | "digits";

export type IdCardFieldDefinition = {
  key: IdCardFieldKey;
  mode: IdCardFieldMode;
  /** Relative rect in normalized card space (0–1). */
  rect: {
    x: number;
    y: number;
    width: number;
    height: number;
  };
};

/**
 * EU national ID visual-zone layout (photo left, fields right).
 * Tuned for French CNI-style cards; relative coords stay stable after normalize.
 */
export const EU_ID_FIELD_LAYOUT: readonly IdCardFieldDefinition[] = [
  {
    key: "lastName",
    mode: "text",
    rect: { x: 0.36, y: 0.2, width: 0.58, height: 0.08 },
  },
  {
    key: "firstName",
    mode: "text",
    rect: { x: 0.36, y: 0.3, width: 0.58, height: 0.08 },
  },
  {
    key: "nationality",
    mode: "text",
    rect: { x: 0.48, y: 0.4, width: 0.14, height: 0.07 },
  },
  {
    key: "dateOfBirth",
    mode: "digits",
    rect: { x: 0.62, y: 0.4, width: 0.32, height: 0.07 },
  },
  {
    key: "expiryDate",
    mode: "digits",
    rect: { x: 0.36, y: 0.66, width: 0.22, height: 0.08 },
  },
  {
    key: "documentNumber",
    mode: "digits",
    rect: { x: 0.58, y: 0.66, width: 0.36, height: 0.08 },
  },
] as const;

export const toPixelCropRect = (
  relative: IdCardFieldDefinition["rect"],
  cardWidth = NORMALIZED_CARD_WIDTH,
  cardHeight = NORMALIZED_CARD_HEIGHT,
): CropRect => {
  const x = Math.round(relative.x * cardWidth);
  const y = Math.round(relative.y * cardHeight);
  const width = Math.max(1, Math.round(relative.width * cardWidth));
  const height = Math.max(1, Math.round(relative.height * cardHeight));

  return {
    x: Math.min(x, cardWidth - 1),
    y: Math.min(y, cardHeight - 1),
    width: Math.min(width, cardWidth - x),
    height: Math.min(height, cardHeight - y),
  };
};
