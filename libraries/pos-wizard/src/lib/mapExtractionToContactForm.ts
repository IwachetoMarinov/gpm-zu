import type { ContactFormData } from "../types/contactForm";
import { createEmptyContactForm } from "../types/contactForm";
import type { IdCardExtraction } from "../types/idCardCapture";

const toFormValue = (value: string | null | undefined): string =>
  value?.trim() ?? "";

export const mapExtractionToContactForm = (
  extraction: IdCardExtraction,
): ContactFormData => {
  const form = createEmptyContactForm();

  form.firstName = toFormValue(extraction.firstName);
  form.lastName = toFormValue(extraction.lastName);
  form.fullName = toFormValue(extraction.fullName);
  form.documentNumber = toFormValue(extraction.documentNumber);
  form.dateOfBirth = toFormValue(extraction.dateOfBirth);
  form.nationality = toFormValue(extraction.nationality);
  form.expiryDate = toFormValue(extraction.expiryDate);
  form.issueDate = toFormValue(extraction.issueDate);
  form.residentialAddress = toFormValue(extraction.residentialAddress);
  form.documentType = toFormValue(extraction.documentType);
  form.issuingCountry = toFormValue(extraction.issuingCountry);

  if (!form.fullName && (form.firstName || form.lastName)) {
    form.fullName = [form.firstName, form.lastName].filter(Boolean).join(" ");
  }

  return form;
};
