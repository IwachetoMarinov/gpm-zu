import { IdCameraCapture } from "../components/IdCameraCapture";
import { IdCardUpload } from "../components/IdCardUploadForm";

type UploadDocumentPageProps = {
  onNext: () => void;
};

const UploadDocumentPage = ({ onNext }: UploadDocumentPageProps) => {
  return (
    <section>
      <IdCameraCapture />

      <IdCardUpload />

      <button type="button" onClick={onNext}>
        Continue
      </button>
    </section>
  );
};

export default UploadDocumentPage;
