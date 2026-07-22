type ContactFormPageProps = {
  onNext: () => void;
  onBack: () => void;
};

const ContactFormPage = ({
  onNext,
  onBack,
}: ContactFormPageProps) => {
  return (
    <section>
      <h2>Contact details</h2>
      <p>Review and complete the extracted information.</p>

      <button type="button" onClick={onBack}>
        Back
      </button>

      <button type="button" onClick={onNext}>
        Continue
      </button>
    </section>
  );
};

export default ContactFormPage;