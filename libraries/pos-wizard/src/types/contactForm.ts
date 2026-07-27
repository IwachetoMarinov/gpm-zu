export type ContactFormData = {
  firstName: string;
  lastName: string;
  fullName: string;
  documentNumber: string;
  dateOfBirth: string;
  nationality: string;
  expiryDate: string;
  issueDate: string;
  residentialAddress: string;
  documentType: string;
  issuingCountry: string;
};

export const createEmptyContactForm = (): ContactFormData => ({
  firstName: "",
  lastName: "",
  fullName: "",
  documentNumber: "",
  dateOfBirth: "",
  nationality: "",
  expiryDate: "",
  issueDate: "",
  residentialAddress: "",
  documentType: "",
  issuingCountry: "",
});
