const ID_CARD_TEXT_DUMP_URL = "http://127.0.0.1:8000/v1/id-cards/text-dump";

/**
 * POST ID card image as multipart form-data field `file`, with Auth0 Bearer token.
 * Do not set Content-Type manually — the browser adds the multipart boundary.
 */
export const postIdCardTextDump = async (
  imageBlob: Blob,
): Promise<Response> => {
  const formData = new FormData();
  const filename = imageBlob.type === "image/png" ? "image.png" : "image.jpg";
  formData.append("file", imageBlob, filename);

  return fetch(ID_CARD_TEXT_DUMP_URL, {
    method: "POST",
    body: formData,
  });
};
