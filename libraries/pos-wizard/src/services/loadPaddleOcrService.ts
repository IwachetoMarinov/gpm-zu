import {
  getDefaultWebExecutionProviders,
  isWebGpuAvailable,
  PaddleOcrService,
} from "ppu-paddle-ocr/web";
import * as ort from "onnxruntime-web";

let paddleServicePromise: Promise<PaddleOcrService> | null = null;

const PADDLE_ASSET_BASE_URL = import.meta.env.DEV
  ? "http://localhost:5173/models/paddleocr"
  : `${window.location.origin}/vtiger-gpm-zu/libraries/pos-wizard/dist/models/paddleocr`;

const LOCAL_LATIN_MODEL = {
  detection: `${PADDLE_ASSET_BASE_URL}/detection/PP-OCRv5_mobile_det_infer.onnx`,
  recognition: `${PADDLE_ASSET_BASE_URL}/recognition/latin_PP-OCRv5_mobile_rec_infer.onnx`,
  charactersDictionary: `${PADDLE_ASSET_BASE_URL}/recognition/ppocrv5_latin_dict.txt`,
};

/**
 * Creates and caches the browser-based PaddleOCR service.
 *
 * Uses locally hosted detection, recognition, and dictionary assets.
 * WebGPU is preferred when available, with WASM used as a fallback.
 */
export const loadPaddleOcrService = (): Promise<PaddleOcrService> => {
  if (!paddleServicePromise) {
    paddleServicePromise = (async () => {
      /*
       * We will make these WASM files local in the next step.
       * For now, keep the existing runtime path so OCR can be tested.
       */
      if (!ort.env.wasm.wasmPaths) {
        ort.env.wasm.wasmPaths =
          "https://cdn.jsdelivr.net/npm/onnxruntime-web/dist/";
      }

      const webGpuAvailable = await isWebGpuAvailable();
      const executionProviders = await getDefaultWebExecutionProviders();

      console.log("[PaddleOCR] Initializing service", {
        webGpuAvailable,
        executionProviders,
        model: LOCAL_LATIN_MODEL,
      });

      const service = new PaddleOcrService({
        model: LOCAL_LATIN_MODEL,
        session: {
          executionProviders,
          graphOptimizationLevel: "all",
        },
        debugging: {
          verbose: true,
          debug: false,
        },
      });

      await service.initialize();

      console.log("[PaddleOCR] Service ready");

      return service;
    })().catch((error: unknown) => {
      paddleServicePromise = null;
      throw error;
    });
  }

  return paddleServicePromise;
};
