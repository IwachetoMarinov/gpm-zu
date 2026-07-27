import { useState } from "react";
import "./App.css";

import UploadDocumentPage from "./pages/UploadDocumentPage";
import ContactFormPage from "./pages/ContactFormPage";
import ConfirmationPage from "./pages/ConfirmationPage";
import SuccessPage from "./pages/SuccessPage";

import { mapExtractionToContactForm } from "./lib/mapExtractionToContactForm";
import type { ContactFormData } from "./types/contactForm";
import { createEmptyContactForm } from "./types/contactForm";
import type { IdCardExtraction } from "./types/idCardCapture";
import type { WizardStep } from "./types/wizard";

function App() {
  const [currentStep, setCurrentStep] = useState<WizardStep>("upload");
  const [contactForm, setContactForm] = useState<ContactFormData>(
    createEmptyContactForm(),
  );
  const [idCardExtraction, setIdCardExtraction] =
    useState<IdCardExtraction | null>(null);
  const [idCardPreviewUrl, setIdCardPreviewUrl] = useState<string | null>(
    null,
  );
  const [idCardImage, setIdCardImage] = useState<Blob | null>(null);
  const [createdContactId, setCreatedContactId] = useState<number | null>(null);
  const [createdContactName, setCreatedContactName] = useState<string | null>(
    null,
  );

  const handleExtractionComplete = (
    extraction: IdCardExtraction,
    previewUrl: string | null,
    imageBlob: Blob | null,
  ) => {
    setIdCardExtraction(extraction);
    setIdCardPreviewUrl(previewUrl);
    setIdCardImage(imageBlob);
    setContactForm(mapExtractionToContactForm(extraction));
    setCurrentStep("form");
  };

  const handleContactFormChange = (
    field: keyof ContactFormData,
    value: string,
  ) => {
    setContactForm((current) => ({
      ...current,
      [field]: value,
    }));
  };

  const handleContactCreated = (contactId: number, contactName: string) => {
    setCreatedContactId(contactId);
    setCreatedContactName(contactName);
    setCurrentStep("success");
  };

  if (currentStep === "form") {
    return (
      <ContactFormPage
        contactForm={contactForm}
        idCardPreviewUrl={idCardPreviewUrl}
        onFieldChange={handleContactFormChange}
        onBack={() => setCurrentStep("upload")}
        onNext={() => setCurrentStep("confirmation")}
      />
    );
  }

  if (currentStep === "confirmation") {
    return (
      <ConfirmationPage
        contactForm={contactForm}
        idCardExtraction={idCardExtraction}
        idCardImage={idCardImage}
        onBack={() => setCurrentStep("form")}
        onConfirmSuccess={handleContactCreated}
      />
    );
  }

  if (currentStep === "success") {
    return (
      <SuccessPage
        contactId={createdContactId}
        contactName={createdContactName}
      />
    );
  }

  return (
    <UploadDocumentPage onExtractionComplete={handleExtractionComplete} />
  );
}

export default App;
