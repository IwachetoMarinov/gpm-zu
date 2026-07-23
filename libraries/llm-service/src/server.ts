import cors from "cors";
import express, { type Request, type Response } from "express";
import { existsSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import {
  getLlama,
  LlamaChatSession,
  type LlamaContext,
  type LlamaModel,
} from "node-llama-cpp";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

const PORT = 3001;
const HOST = "127.0.0.1";

const MODEL_PATH = path.resolve(
  __dirname,
  "../models/qwen2.5-1.5b-instruct-q5_k_m.gguf",
);

const CONTEXT_SIZE = 2048;
const MAX_TOKENS = 256;
const TEMPERATURE = 0;

const ID_CARD_EXTRACTION_SYSTEM_PROMPT = `You extract identity-document fields from OCR text.
Return ONLY valid JSON with this exact shape:
{
  "firstName": string | null,
  "lastName": string | null,
  "fullName": string | null,
  "documentNumber": string | null,
  "dateOfBirth": string | null,
  "nationality": string | null,
  "issueDate": string | null,
  "expiryDate": string | null,
  "residentialAddress": string | null,
  "documentType": string | null,
  "issuingCountry": string | null
}
Rules:
- Use null when a field is missing or unclear.
- Prefer Latin transliteration when both scripts appear.
- Dates must be YYYY-MM-DD when possible.
- documentNumber is the passport or national ID number.
- documentType examples: "passport", "national_id", "residence_permit" (use null if unclear).
- issuingCountry is the country that issued the document (may differ from nationality).
- residentialAddress only when clearly present on the document; otherwise null.
- Do not invent values.
- Do not wrap the JSON in markdown.`;

type IdCardExtraction = {
  firstName: string | null;
  lastName: string | null;
  fullName: string | null;
  documentNumber: string | null;
  dateOfBirth: string | null;
  nationality: string | null;
  issueDate: string | null;
  expiryDate: string | null;
  residentialAddress: string | null;
  documentType: string | null;
  issuingCountry: string | null;
  rawText: string;
};

type GenerateRequestBody = {
  prompt?: unknown;
};

type LocalLlmRuntime = {
  model: LlamaModel;
  context: LlamaContext;
  prompt: (
    systemPrompt: string,
    userMessage: string,
  ) => Promise<string>;
};

let runtimePromise: Promise<LocalLlmRuntime> | null = null;
let promptQueue: Promise<void> = Promise.resolve();

let isModelReady = false;
let isGenerating = false;

app.use(
  cors({
    origin: [
      "http://localhost",
      "http://localhost:5173",
      "http://127.0.0.1",
      "http://127.0.0.1:5173",
    ],
  }),
);

app.use(express.json({ limit: "1mb" }));

const extractJsonObject = (content: string): string => {
  const fencedJson = content.match(
    /```(?:json)?\s*([\s\S]*?)```/i,
  );

  if (fencedJson?.[1]) {
    return fencedJson[1].trim();
  }

  const start = content.indexOf("{");
  const end = content.lastIndexOf("}");

  if (start === -1 || end === -1 || end <= start) {
    throw new Error("The model did not return a JSON object.");
  }

  return content.slice(start, end + 1);
};

const isRecord = (
  value: unknown,
): value is Record<string, unknown> => {
  return typeof value === "object" && value !== null;
};

const readNullableString = (
  record: Record<string, unknown>,
  key: string,
): string | null => {
  const value = record[key];

  if (typeof value !== "string") {
    return null;
  }

  const trimmed = value.trim();

  return trimmed === "" ? null : trimmed;
};

const parseIdCardExtractionJson = (
  content: string,
  rawText: string,
): IdCardExtraction => {
  const jsonText = extractJsonObject(content);
  const parsed: unknown = JSON.parse(jsonText);

  if (!isRecord(parsed)) {
    throw new Error(
      "The model returned JSON that is not an object.",
    );
  }

  return {
    firstName: readNullableString(parsed, "firstName"),
    lastName: readNullableString(parsed, "lastName"),
    fullName: readNullableString(parsed, "fullName"),
    documentNumber: readNullableString(
      parsed,
      "documentNumber",
    ),
    dateOfBirth: readNullableString(parsed, "dateOfBirth"),
    nationality: readNullableString(parsed, "nationality"),
    issueDate: readNullableString(parsed, "issueDate"),
    expiryDate: readNullableString(parsed, "expiryDate"),
    residentialAddress: readNullableString(
      parsed,
      "residentialAddress",
    ),
    documentType: readNullableString(
      parsed,
      "documentType",
    ),
    issuingCountry: readNullableString(
      parsed,
      "issuingCountry",
    ),
    rawText,
  };
};

const createRuntime = async (): Promise<LocalLlmRuntime> => {
  if (!existsSync(MODEL_PATH)) {
    throw new Error(`LLM model not found at ${MODEL_PATH}`);
  }

  console.log("[Local LLM] Loading model...", {
    modelPath: MODEL_PATH,
    gpu: "auto",
  });

  const startedAt = Date.now();

  /*
   * "auto" allows node-llama-cpp to use an available GPU
   * backend instead of forcing slow CPU-only inference.
   */
  const llama = await getLlama({
    gpu: "auto",
  });

  const model = await llama.loadModel({
    modelPath: MODEL_PATH,
  });

  const context = await model.createContext({
    contextSize: CONTEXT_SIZE,
  });

  console.log("[Local LLM] Model ready", {
    loadMs: Date.now() - startedAt,
    contextSize: CONTEXT_SIZE,
  });

  const runtime: LocalLlmRuntime = {
    model,
    context,

    prompt: async (
      systemPrompt: string,
      userMessage: string,
    ): Promise<string> => {
      const run = promptQueue.then(async () => {
        const promptStartedAt = Date.now();

        /*
         * A fresh session is created for every request.
         *
         * This prevents previous ID-card requests from remaining
         * in the chat history and slowing down later requests.
         */
        const session = new LlamaChatSession({
          contextSequence: context.getSequence(),
          systemPrompt,
          autoDisposeSequence: true,
        });

        try {
          const content = await session.prompt(userMessage, {
            maxTokens: MAX_TOKENS,
            temperature: TEMPERATURE,
          });

          console.log("[Local LLM] Prompt finished", {
            promptMs: Date.now() - promptStartedAt,
            outputLength: content.length,
            maxTokens: MAX_TOKENS,
          });

          return content;
        } finally {
          await session.dispose();
        }
      });

      /*
       * Preserve the request queue even when one request fails.
       */
      promptQueue = run.then(
        () => undefined,
        () => undefined,
      );

      return run;
    },
  };

  return runtime;
};

const loadLocalLlmRuntime =
  async (): Promise<LocalLlmRuntime> => {
    if (!runtimePromise) {
      runtimePromise = createRuntime()
        .then((runtime) => {
          isModelReady = true;

          console.log("[Local LLM] Service ready");

          return runtime;
        })
        .catch((error: unknown) => {
          runtimePromise = null;
          isModelReady = false;

          throw error;
        });
    }

    return runtimePromise;
  };

app.get(
  "/health",
  (_request: Request, response: Response) => {
    response.json({
      status: "ok",
      modelReady: isModelReady,
      generating: isGenerating,
    });
  },
);

app.post(
  "/generate",
  async (
    request: Request<
      Record<string, never>,
      unknown,
      GenerateRequestBody
    >,
    response: Response,
  ) => {
    const rawText =
      typeof request.body?.prompt === "string"
        ? request.body.prompt.trim()
        : "";

    if (
      rawText === "" ||
      rawText === "(no text recognized)"
    ) {
      response.status(400).json({
        error:
          "Cannot run field extraction without OCR text.",
      });

      return;
    }

    if (!isModelReady) {
      response.status(503).json({
        error: "The LLM model is still loading.",
      });

      return;
    }

    isGenerating = true;

    try {
      console.log(
        "[Local LLM] Extracting ID fields from OCR text...",
        {
          rawTextLength: rawText.length,
        },
      );

      const runtime = await loadLocalLlmRuntime();

      const assistantContent = await runtime.prompt(
        ID_CARD_EXTRACTION_SYSTEM_PROMPT,
        `OCR text from an identity document:\n\n${rawText}`,
      );

      console.log(
        "[Local LLM] Raw model response:",
        assistantContent,
      );

      const extraction = parseIdCardExtractionJson(
        assistantContent,
        rawText,
      );

      console.log(
        "[Local LLM] Parsed extraction:",
        extraction,
      );

      response.json({
        result: extraction,
      });
    } catch (error: unknown) {
      console.error(
        "[Local LLM] ID extraction failed:",
        error,
      );

      const message =
        error instanceof Error
          ? error.message
          : "Unknown LLM extraction error.";

      response.status(500).json({
        error: message,
      });
    } finally {
      isGenerating = false;
    }
  },
);

app.listen(PORT, HOST, () => {
  console.log(
    `LLM service running at http://${HOST}:${PORT}`,
  );
});

loadLocalLlmRuntime().catch((error: unknown) => {
  console.error(
    "[Local LLM] Failed to initialize:",
    error,
  );
});