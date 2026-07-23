import path from "node:path";
import { fileURLToPath } from "node:url";
import { getLlama, LlamaChatSession } from "node-llama-cpp";

const currentFilePath = fileURLToPath(import.meta.url);
const currentDirectory = path.dirname(currentFilePath);

const modelPath = path.resolve(
  currentDirectory,
  "../models/qwen2.5-1.5b-instruct-q5_k_m.gguf",
);

console.log("Loading model from:", modelPath);

console.time("Load llama");

const llama = await getLlama({
  gpu: false,
});

console.timeEnd("Load llama");

console.time("Load model");

const model = await llama.loadModel({
  modelPath,
});

console.timeEnd("Load model");

console.time("Create context");

const context = await model.createContext({
  contextSize: 2048,
});

console.timeEnd("Create context");

const session = new LlamaChatSession({
  contextSequence: context.getSequence(),
});

console.time("Prompt");
const response = await session.prompt("Reply with only the word READY.", {
  temperature: 0,
  maxTokens: 20,
});

console.timeEnd("Prompt");

console.time("Second prompt");

const secondResponse = await session.prompt(
  "Reply with only the word SECOND.",
  {
    temperature: 0,
    maxTokens: 20,
  },
);

console.timeEnd("Second prompt");

console.log("Second response:", secondResponse);

console.log("Model response:", response);

await context.dispose();
await model.dispose();
await llama.dispose();
