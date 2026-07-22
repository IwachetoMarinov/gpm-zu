import { useState } from "react";
import "./App.css";

import UploadDocumentPage from "./pages/UploadDocumentPage";
import ProcessingDocumentPage from "./pages/ProcessingDocumentPage";
import ContactFormPage from "./pages/ContactFormPage";
import ConfirmationPage from "./pages/ConfirmationPage";
import SuccessPage from "./pages/SuccessPage";

import type { WizardStep } from "./types/wizard";

function App() {
  const [currentStep, setCurrentStep] = useState<WizardStep>("upload");

  if (currentStep === "processing") {
    return (
      <ProcessingDocumentPage
        onBack={() => setCurrentStep("upload")}
        onNext={() => setCurrentStep("form")}
      />
    );
  }

  if (currentStep === "form") {
    return (
      <ContactFormPage
        onBack={() => setCurrentStep("processing")}
        onNext={() => setCurrentStep("confirmation")}
      />
    );
  }

  if (currentStep === "confirmation") {
    return (
      <ConfirmationPage
        onBack={() => setCurrentStep("form")}
        onConfirm={() => setCurrentStep("success")}
      />
    );
  }

  if (currentStep === "success") {
    return <SuccessPage />;
  }

  return <UploadDocumentPage onNext={() => setCurrentStep("processing")} />;
}

export default App;
