import type {
  IdCardQualityMetrics,
  IdCardValidationResult,
} from "../types/idCardCapture";

const MIN_WIDTH = 240;
const MIN_HEIGHT = 150;
const MIN_BRIGHTNESS = 45;
const MAX_BRIGHTNESS = 210;
const MIN_SHARPNESS = 40;
const ANALYSIS_MAX_DIMENSION = 640;

const toGrayscaleLuminance = (
  red: number,
  green: number,
  blue: number,
): number => {
  return 0.299 * red + 0.587 * green + 0.114 * blue;
};

const computeAverageBrightness = (imageData: ImageData): number => {
  const { data } = imageData;
  let total = 0;
  const pixelCount = data.length / 4;

  for (let index = 0; index < data.length; index += 4) {
    total += toGrayscaleLuminance(
      data[index] ?? 0,
      data[index + 1] ?? 0,
      data[index + 2] ?? 0,
    );
  }

  return pixelCount === 0 ? 0 : total / pixelCount;
};

const computeSharpness = (imageData: ImageData): number => {
  const { data, width, height } = imageData;

  if (width < 3 || height < 3) {
    return 0;
  }

  const grayscale = new Float32Array(width * height);

  for (let index = 0, pixel = 0; index < data.length; index += 4, pixel += 1) {
    grayscale[pixel] = toGrayscaleLuminance(
      data[index] ?? 0,
      data[index + 1] ?? 0,
      data[index + 2] ?? 0,
    );
  }

  let sum = 0;
  let sumSquares = 0;
  let sampleCount = 0;

  for (let y = 1; y < height - 1; y += 1) {
    for (let x = 1; x < width - 1; x += 1) {
      const center = grayscale[y * width + x] ?? 0;
      const up = grayscale[(y - 1) * width + x] ?? 0;
      const down = grayscale[(y + 1) * width + x] ?? 0;
      const left = grayscale[y * width + (x - 1)] ?? 0;
      const right = grayscale[y * width + (x + 1)] ?? 0;
      const laplacian = Math.abs(4 * center - up - down - left - right);

      sum += laplacian;
      sumSquares += laplacian * laplacian;
      sampleCount += 1;
    }
  }

  if (sampleCount === 0) {
    return 0;
  }

  const mean = sum / sampleCount;
  return sumSquares / sampleCount - mean * mean;
};

const readImageForValidation = async (
  blob: Blob,
): Promise<{
  fullWidth: number;
  fullHeight: number;
  analysisImageData: ImageData;
}> => {
  const bitmap = await createImageBitmap(blob);
  const fullWidth = bitmap.width;
  const fullHeight = bitmap.height;
  const longestSide = Math.max(fullWidth, fullHeight);
  const scale =
    longestSide > ANALYSIS_MAX_DIMENSION
      ? ANALYSIS_MAX_DIMENSION / longestSide
      : 1;
  const analysisWidth = Math.max(1, Math.round(fullWidth * scale));
  const analysisHeight = Math.max(1, Math.round(fullHeight * scale));

  const canvas = document.createElement("canvas");
  canvas.width = analysisWidth;
  canvas.height = analysisHeight;

  const context = canvas.getContext("2d");
  if (!context) {
    bitmap.close();
    throw new Error("Unable to read image data for validation.");
  }

  context.drawImage(bitmap, 0, 0, analysisWidth, analysisHeight);
  bitmap.close();

  return {
    fullWidth,
    fullHeight,
    analysisImageData: context.getImageData(
      0,
      0,
      analysisWidth,
      analysisHeight,
    ),
  };
};

export const validateIdCardImage = async (
  blob: Blob,
): Promise<IdCardValidationResult> => {
  const { fullWidth, fullHeight, analysisImageData } =
    await readImageForValidation(blob);
  const averageBrightness = computeAverageBrightness(analysisImageData);
  const sharpness = computeSharpness(analysisImageData);

  const metrics: IdCardQualityMetrics = {
    width: fullWidth,
    height: fullHeight,
    averageBrightness,
    sharpness,
  };

  const reasons: string[] = [];

  if (fullWidth < MIN_WIDTH || fullHeight < MIN_HEIGHT) {
    reasons.push(
      "The ID card looks too small in the frame. Move closer and try again.",
    );
  }

  if (averageBrightness < MIN_BRIGHTNESS) {
    reasons.push("The photo is too dark. Improve lighting and try again.");
  } else if (averageBrightness > MAX_BRIGHTNESS) {
    reasons.push(
      "The photo is too bright or washed out. Reduce glare and try again.",
    );
  }

  if (sharpness < MIN_SHARPNESS) {
    reasons.push(
      "The photo looks blurry. Hold the camera steady and try again.",
    );
  }

  if (reasons.length > 0) {
    return { ok: false, reasons, metrics };
  }

  return { ok: true, metrics };
};
