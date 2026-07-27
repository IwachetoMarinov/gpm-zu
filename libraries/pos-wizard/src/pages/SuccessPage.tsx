type SuccessPageProps = {
  contactId: number | null;
  contactName: string | null;
};

const SuccessPage = ({ contactId, contactName }: SuccessPageProps) => {
  return (
    <section>
      <h2>Contact created</h2>
      <p>
        {contactName
          ? `${contactName} was created successfully.`
          : "The Contact was created successfully."}
      </p>
      {contactId ? (
        <p>
          <a href={`index.php?module=Contacts&view=Detail&record=${contactId}`}>
            Open contact in vTiger
          </a>
        </p>
      ) : null}
    </section>
  );
};

export default SuccessPage;
