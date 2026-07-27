import type { ContactFormData } from "../types/contactForm";

export type ContactFormField = keyof ContactFormData;

export type ContactFormFieldErrors = Partial<
  Record<ContactFormField, string>
>;

export const getContactFormFieldErrors = (
  contactForm: ContactFormData,
): ContactFormFieldErrors => {
  const errors: ContactFormFieldErrors = {};

  for (const [key, value] of Object.entries(contactForm) as Array<
    [ContactFormField, string]
  >) {
    if (!value.trim()) {
      errors[key] = "This field is required.";
    }
  }

  return errors;
};

export const isContactFormValid = (
  errors: ContactFormFieldErrors,
): boolean => Object.keys(errors).length === 0;
