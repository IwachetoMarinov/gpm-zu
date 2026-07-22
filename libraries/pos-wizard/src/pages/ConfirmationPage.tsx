type ConfirmationPageProps = {
  onConfirm: () => void;
  onBack: () => void;
};

const ConfirmationPage = ({
  onConfirm,
  onBack,
}: ConfirmationPageProps) => {
  return (
    <section>
      <h2>Confirm contact</h2>
      <p>Review all information before creating the Contact.</p>

      <button type="button" onClick={onBack}>
        Back
      </button>

      <button type="button" onClick={onConfirm}>
        Create Contact
      </button>
    </section>
  );
};

export default ConfirmationPage;