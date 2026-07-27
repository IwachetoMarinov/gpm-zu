import type { IdCardExtraction } from "../types/idCardCapture";

type GenerateResponse = {
  result: IdCardExtraction;
};

export const generateLlmResponse = async (
  prompt: string,
): Promise<IdCardExtraction> => {
  const response = await fetch("http://127.0.0.1:3001/generate", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ prompt }),
  });

  const data = (await response.json()) as GenerateResponse | { error: string };

  if (!response.ok) {
    throw new Error(
      "error" in data ? data.error : "Failed to generate LLM response.",
    );
  }

  if (!("result" in data) || !data.result) {
    throw new Error("The LLM service returned an empty extraction result.");
  }

  return data.result;
};
