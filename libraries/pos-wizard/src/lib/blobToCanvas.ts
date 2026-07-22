export const blobToCanvas = async (blob: Blob) : Promise<HTMLCanvasElement> => {
    const bitmap = await createImageBitmap(blob);
    const canvas = document.createElement("canvas");
    canvas.width = bitmap.width;
    canvas.height = bitmap.height;
  
    const context = canvas.getContext("2d");
    if (!context) {
      bitmap.close();
      throw new Error("Unable to create a 2D canvas context for the ID image.");
    }
  
    context.drawImage(bitmap, 0, 0);
    bitmap.close();
    return canvas;
  }
  
  export const canvasToBlob = (canvas: HTMLCanvasElement, type = "image/png") : Promise<Blob> => {
    return new Promise((resolve, reject) => {
      canvas.toBlob((blob) => {
        if (!blob) {
          reject(new Error("Failed to encode the processed ID image."));
          return;
        }
        resolve(blob);
      }, type);
    });
  }
  