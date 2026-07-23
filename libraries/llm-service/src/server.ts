import cors from "cors";
import express, { type Request, type Response } from "express";
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
const port = 3001;

const modelPath = path.resolve(
  __dirname,
  "../models/qwen2.5-1.5b-instruct-q5_k_m.gguf",
);

let model: LlamaModel | null = null;
let context: LlamaContext | null = null;
let isModelReady = false;
let isGenerating = false;

app.use(
  cors({
    origin: "http://localhost:5173",
  }),
);

app.use(express.json({ limit: "1mb" }));

const initializeModel = async (): Promise<void> => {
  console.log("Loading LLM model...");
  console.time("LLM initialization");

  const llama = await getLlama({
    gpu: false,
  });

  model = await llama.loadModel({
    modelPath,
  });

  context = await model.createContext({
    contextSize: 2048,
  });

  console.log("Warming up LLM...");
  console.time("LLM warm-up");

  const warmupSession = new LlamaChatSession({
    contextSequence: context.getSequence(),
  });

  await warmupSession.prompt("Reply with only the word READY.", {
    temperature: 0,
    maxTokens: 20,
  });

  console.timeEnd("LLM warm-up");
  console.timeEnd("LLM initialization");

  isModelReady = true;

  console.log("LLM is ready.");
};

app.get("/health", (_request: Request, response: Response) => {
  response.json({
    status: "ok",
    modelReady: isModelReady,
    generating: isGenerating,
  });
});

app.post("/generate", async (request: Request, response: Response) => {
  const prompt =
    typeof request.body?.prompt === "string"
      ? request.body.prompt.trim()
      : "";

  if (!prompt) {
    response.status(400).json({
      error: "Prompt is required.",
    });

    return;
  }

  if (!isModelReady || !context) {
    response.status(503).json({
      error: "The LLM model is still loading.",
    });

    return;
  }

  if (isGenerating) {
    response.status(429).json({
      error: "The LLM is currently processing another request.",
    });

    return;
  }

  isGenerating = true;

  try {
    console.log("Generating response...");
    console.time("Prompt");

    const session = new LlamaChatSession({
      contextSequence: context.getSequence(),
    });

    const result = await session.prompt(prompt, {
      temperature: 0,
      maxTokens: 512,
    });

    console.timeEnd("Prompt");

    response.json({
      result: result.trim(),
    });
  } catch (error) {
    console.error("LLM generation failed:", error);

    response.status(500).json({
      error: "Failed to generate the LLM response.",
    });
  } finally {
    isGenerating = false;
  }
});

app.listen(port, "127.0.0.1", () => {
  console.log(`LLM service running at http://127.0.0.1:${port}`);
});

initializeModel().catch((error: unknown) => {
  console.error("Failed to initialize LLM:", error);
  process.exit(1);
});