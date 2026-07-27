import { useState } from "react";

import { createContactFromWizard } from "../services/createContactFromWizard";
import type { ContactFormData } from "../types/contactForm";
import type { IdCardExtraction } from "../types/idCardCapture";

type ConfirmationPageProps = {
  contactForm: ContactFormData;
  idCardExtraction: IdCardExtraction | null;
  idCardImage: Blob | null;
  onConfirmSuccess: (contactId: number, contactName: string) => void;
  onBack: () => void;
};

const SUMMARY_FIELDS: Array<{
  key: keyof ContactFormData;
  label: string;
}> = [
  { key: "fullName", label: "Full name" },
  { key: "documentNumber", label: "Document number" },
  { key: "dateOfBirth", label: "Date of birth" },
  { key: "nationality", label: "Nationality" },
  { key: "issueDate", label: "Issue date" },
  { key: "expiryDate", label: "Expiry date" },
  { key: "documentType", label: "Document type" },
  { key: "issuingCountry", label: "Issuing country" },
  { key: "residentialAddress", label: "Residential address" },
];

const ConfirmationPage = ({
  contactForm,
  idCardExtraction,
  idCardImage,
  onConfirmSuccess,
  onBack,
}: ConfirmationPageProps) => {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitError, setSubmitError] = useState<string | null>(null);

  const handleCreateContact = async () => {
    setIsSubmitting(true);
    setSubmitError(null);

    try {
      const result = await createContactFromWizard({
        ...contactForm,
        rawText: idCardExtraction?.rawText ?? null,
        idCardImage,
      });

      onConfirmSuccess(result.contactId, result.contactName);
    } catch (error) {
      const message =
        error instanceof Error
          ? error.message
          : "Unable to create the Contact. Please try again.";
      setSubmitError(message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <section>
      <header>
        <h2>Confirm contact</h2>
        <p>Review all information before creating the Contact in vTiger.</p>
      </header>

      <dl className="contact-form__summary">
        {SUMMARY_FIELDS.map(({ key, label }) => (
          <div key={key}>
            <dt>{label}</dt>
            <dd>{contactForm[key] || "—"}</dd>
          </div>
        ))}
      </dl>

      {idCardExtraction?.rawText ? (
        <details>
          <summary>OCR raw text</summary>
          <pre className="id-camera__raw-text">{idCardExtraction.rawText}</pre>
        </details>
      ) : null}

      {submitError ? (
        <p className="contact-form__form-error" role="alert">
          {submitError}
        </p>
      ) : null}

      <div className="wizard-actions">
        <button type="button" onClick={onBack} disabled={isSubmitting}>
          Back
        </button>
        <button
          type="button"
          onClick={() => {
            void handleCreateContact();
          }}
          disabled={isSubmitting}
        >
          {isSubmitting ? "Creating contact…" : "Create Contact"}
        </button>
      </div>
    </section>
  );
};

export default ConfirmationPage;
