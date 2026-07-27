import type { ContactFormData } from "../types/contactForm";
import {
  getContactFormFieldErrors,
  isContactFormValid,
  type ContactFormField,
} from "../lib/validateContactForm";

type ContactFormPageProps = {
  contactForm: ContactFormData;
  idCardPreviewUrl: string | null;
  onFieldChange: (field: ContactFormField, value: string) => void;
  onNext: () => void;
  onBack: () => void;
};

const FORM_FIELDS: Array<{
  key: ContactFormField;
  label: string;
  type?: string;
}> = [
  { key: "firstName", label: "First name" },
  { key: "lastName", label: "Last name" },
  { key: "fullName", label: "Full name" },
  { key: "documentNumber", label: "Document number" },
  { key: "dateOfBirth", label: "Date of birth", type: "date" },
  { key: "nationality", label: "Nationality" },
  { key: "issueDate", label: "Issue date", type: "date" },
  { key: "expiryDate", label: "Expiry date", type: "date" },
  { key: "documentType", label: "Document type" },
  { key: "issuingCountry", label: "Issuing country" },
  { key: "residentialAddress", label: "Residential address" },
];

const ContactFormPage = ({
  contactForm,
  idCardPreviewUrl,
  onFieldChange,
  onNext,
  onBack,
}: ContactFormPageProps) => {
  const fieldErrors = getContactFormFieldErrors(contactForm);
  const isFormValid = isContactFormValid(fieldErrors);

  return (
    <section className="contact-form">
      <header>
        <h2>Contact details</h2>
        <p>
          Review the information extracted from the ID card and correct anything
          that looks wrong. All fields are required.
        </p>
      </header>

      {idCardPreviewUrl ? (
        <figure className="contact-form__preview">
          <img src={idCardPreviewUrl} alt="Confirmed ID card" />
          <figcaption>Confirmed ID photo</figcaption>
        </figure>
      ) : null}

      {!isFormValid ? (
        <p className="contact-form__form-error" role="alert">
          Please fill in all required fields before continuing.
        </p>
      ) : null}

      <form
        className="contact-form__grid"
        onSubmit={(event) => {
          event.preventDefault();
          if (!isFormValid) {
            return;
          }
          onNext();
        }}
        noValidate
      >
        {FORM_FIELDS.map(({ key, label, type = "text" }) => {
          const error = fieldErrors[key];
          const fieldClassName = error
            ? "contact-form__field contact-form__field--invalid"
            : "contact-form__field";
          const controlClassName = error
            ? "contact-form__control contact-form__control--invalid"
            : "contact-form__control";

          return (
            <label key={key} className={fieldClassName}>
              <span className="contact-form__label">{label}</span>
              {key === "residentialAddress" ? (
                <textarea
                  className={controlClassName}
                  value={contactForm[key]}
                  onChange={(event) => onFieldChange(key, event.target.value)}
                  rows={3}
                  aria-invalid={Boolean(error)}
                  aria-describedby={error ? `${key}-error` : undefined}
                  required
                />
              ) : (
                <input
                  className={controlClassName}
                  type={type}
                  value={contactForm[key]}
                  onChange={(event) => onFieldChange(key, event.target.value)}
                  aria-invalid={Boolean(error)}
                  aria-describedby={error ? `${key}-error` : undefined}
                  required
                />
              )}
              {error ? (
                <span
                  id={`${key}-error`}
                  className="contact-form__field-error"
                  role="alert"
                >
                  {error}
                </span>
              ) : null}
            </label>
          );
        })}

        <div className="wizard-actions">
          <button type="button" onClick={onBack}>
            Back
          </button>
          <button type="submit" disabled={!isFormValid}>
            Continue
          </button>
        </div>
      </form>
    </section>
  );
};

export default ContactFormPage;
