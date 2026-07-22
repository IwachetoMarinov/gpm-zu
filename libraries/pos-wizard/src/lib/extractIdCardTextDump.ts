import { canvasToBlob } from "./blobToCanvas";
import { normalizeIdCardImage } from "./normalizeIdCardImage";
import type { IdCardExtraction } from "../types/idCardCapture";
import { loadPaddleOcrService } from "../services/loadPaddleOcrService";

const VTIGER_AJAX_URL = "index.php";
const CONTACTS_MODULE = "Contacts";
const EXTRACT_ACTION = "ExtractIdCardTextDump";

type VtigerAjaxResponse = {
  success: boolean;
  result?: Partial<IdCardExtraction>;
  error?: {
    message?: string;
    code?: string;
  };
};

type VtigerAppRequest = {
  request: {
    post: (params: { data: FormData }) => Promise<[unknown, unknown]>;
  };
};

const getCsrfFormFields = (): Record<string, string> => {
  const win = window as Window & {
    csrfMagicToken?: string;
    csrfMagicName?: string;
  };

  if (win.csrfMagicToken && win.csrfMagicName) {
    return { [win.csrfMagicName]: win.csrfMagicToken };
  }

  const tokenInput = document.querySelector<HTMLInputElement>(
    'input[name="__vtrftk"]',
  );
  if (tokenInput?.value) {
    return { __vtrftk: tokenInput.value };
  }

  return {};
};

const postVtigerAction = async (formData: FormData): Promise<unknown> => {
  const win = window as Window & { app?: VtigerAppRequest };

  if (win.app?.request?.post) {
    const [err, data] = await win.app.request.post({ data: formData });
    if (err) {
      throw err instanceof Error ? err : new Error(String(err));
    }
    return data;
  }

  const response = await fetch(VTIGER_AJAX_URL, {
    method: "POST",
    body: formData,
    credentials: "same-origin",
  });

  if (!response.ok) {
    throw new Error(`vTiger request failed (${response.status})`);
  }

  const payload = (await response.json()) as VtigerAjaxResponse;

  if (!payload.success) {
    throw new Error(payload.error?.message ?? "vTiger request failed");
  }

  return payload.result;
};

const toExtraction = (result: unknown): IdCardExtraction => {
  const data = (result ?? {}) as Partial<IdCardExtraction>;

  return {
    firstName: data.firstName ?? null,
    lastName: data.lastName ?? null,
    fullName: data.fullName ?? null,
    documentNumber: data.documentNumber ?? null,
    dateOfBirth: data.dateOfBirth ?? null,
    nationality: data.nationality ?? null,
    expiryDate: data.expiryDate ?? null,
    rawText: data.rawText ?? null,
  };
};

/**
 * Sends the normalized ID image to vTiger via index.php (Contacts/ExtractIdCardTextDump).
 */
export const extractIdCardTextDump = async (
  imageBlob: Blob,
): Promise<IdCardExtraction> => {
  const card = await normalizeIdCardImage(imageBlob);
  //   const normalizedBlob = await canvasToBlob(card, "image/jpeg");

  //   const formData = new FormData();
  //   formData.append("module", CONTACTS_MODULE);
  //   formData.append("action", EXTRACT_ACTION);
  //   formData.append("file", normalizedBlob, "id-card.jpg");

  //   const csrfFields = getCsrfFormFields();
  //   for (const [name, value] of Object.entries(csrfFields)) {
  //     formData.append(name, value);
  //   }
  // const result = await postVtigerAction(formData);

  const service = await loadPaddleOcrService();
  const ocrResult = await service.recognize(card, {
    flatten: false,
  });

  console.log("[PaddleOCR]", ocrResult);

  const formData = new FormData();

  formData.append("module", "Contacts");
  formData.append("action", "ExtractIdCardTextDump");
  formData.append("requestMode", "ajax");
  formData.append("__vtrftk", (window as Window & { csrfMagicToken?: string }).csrfMagicToken ?? "");
  formData.append("rawText", ocrResult.text);
  
  const result = await postVtigerAction(formData);
  
  console.log("PHP response:", result);

  return toExtraction(result);
};
