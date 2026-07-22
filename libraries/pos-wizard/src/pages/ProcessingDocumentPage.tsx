type ProcessingDocumentPageProps = {
  onNext: () => void;
  onBack: () => void;
};

const ProcessingDocumentPage = ({
  onNext,
  onBack,
}: ProcessingDocumentPageProps) => {
  return (
    <section>
      <h2>Process document</h2>
      <p>The document will be uploaded and processed with OCR.</p>

      <button type="button" onClick={onBack}>
        Back
      </button>

      <button type="button" onClick={onNext}>
        Continue
      </button>
    </section>
  );
};

export default ProcessingDocumentPage;
