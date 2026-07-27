import type { ContactFormData } from "../types/contactForm";
import {
  appendVtigerActionFields,
  EXTRACT_ID_CARD_ACTION,
  postVtigerAction,
} from "../lib/vtigerRequest";

export type CreateContactFromWizardPayload = ContactFormData & {
  rawText?: string | null;
  idCardImage?: Blob | null;
};

export type CreateContactFromWizardResult = {
  contactId: number;
  contactName: string;
};

export const createContactFromWizard = async (
  payload: CreateContactFromWizardPayload,
): Promise<CreateContactFromWizardResult> => {
  const formData = new FormData();

  appendVtigerActionFields(formData, EXTRACT_ID_CARD_ACTION);
  formData.append("operation", "createContact");

  for (const [key, value] of Object.entries(payload) as Array<
    [keyof CreateContactFromWizardPayload, string | Blob | null | undefined]
  >) {
    if (key === "idCardImage") {
      continue;
    }

    if (typeof value === "string" && value.trim() !== "") {
      formData.append(key, value);
    }
  }

  if (payload.rawText?.trim()) {
    formData.append("rawText", payload.rawText.trim());
  }

  if (payload.idCardImage) {
    const filename =
      payload.idCardImage.type === "image/png" ? "id-card.png" : "id-card.jpg";
    formData.append("idCardImage", payload.idCardImage, filename);
  }

  return postVtigerAction<CreateContactFromWizardResult>(formData);
};
