export type CropRect = {
    x: number;
    y: number;
    width: number;
    height: number;
  };
  
  export type IdCardQualityMetrics = {
    width: number;
    height: number;
    averageBrightness: number;
    sharpness: number;
  };
  
  export type IdCardValidationResult =
    | { ok: true; metrics: IdCardQualityMetrics }
    | { ok: false; reasons: string[]; metrics: IdCardQualityMetrics };
  
  export type IdCardExtraction = {
    firstName: string | null;
    lastName: string | null;
    fullName: string | null;
    documentNumber: string | null;
    dateOfBirth: string | null;
    nationality: string | null;
    expiryDate: string | null;
    rawText: string | null;
  };
  