export type VtigerAjaxResponse<T = unknown> = {
  success: boolean;
  result?: T;
  error?: {
    message?: string;
    code?: string;
  };
};

type VtigerAppRequest = {
  request: {
    post: (params: { data: FormData }) => Promise<[unknown, unknown]>;
  };
};

export const VTIGER_AJAX_URL = "index.php";
export const CONTACTS_MODULE = "Contacts";
export const EXTRACT_ID_CARD_ACTION = "ExtractIdCardTextDump";

export const getCsrfFormFields = (): Record<string, string> => {
  const win = window as Window & {
    csrfMagicToken?: string;
    csrfMagicName?: string;
  };

  if (win.csrfMagicToken && win.csrfMagicName) {
    return { [win.csrfMagicName]: win.csrfMagicToken };
  }

  const tokenInput = document.querySelector<HTMLInputElement>(
    'input[name="__vtrftk"]',
  );
  if (tokenInput?.value) {
    return { __vtrftk: tokenInput.value };
  }

  return {};
};

export const appendVtigerActionFields = (
  formData: FormData,
  action: string,
  module: string = CONTACTS_MODULE,
): void => {
  formData.append("module", module);
  formData.append("action", action);
  formData.append("requestMode", "ajax");

  for (const [name, value] of Object.entries(getCsrfFormFields())) {
    formData.append(name, value);
  }
};

export const postVtigerAction = async <T = unknown>(
  formData: FormData,
): Promise<T> => {
  const win = window as Window & { app?: VtigerAppRequest };

  if (win.app?.request?.post) {
    const [err, data] = await win.app.request.post({ data: formData });
    if (err) {
      throw err instanceof Error ? err : new Error(String(err));
    }

    const payload = data as VtigerAjaxResponse<T> | T;

    if (
      payload &&
      typeof payload === "object" &&
      "success" in payload &&
      typeof (payload as VtigerAjaxResponse<T>).success === "boolean"
    ) {
      const ajaxPayload = payload as VtigerAjaxResponse<T>;
      if (!ajaxPayload.success) {
        throw new Error(ajaxPayload.error?.message ?? "vTiger request failed");
      }
      return ajaxPayload.result as T;
    }

    return payload as T;
  }

  const response = await fetch(VTIGER_AJAX_URL, {
    method: "POST",
    body: formData,
    credentials: "same-origin",
  });

  if (!response.ok) {
    throw new Error(`vTiger request failed (${response.status})`);
  }

  const payload = (await response.json()) as VtigerAjaxResponse<T>;

  if (!payload.success) {
    throw new Error(payload.error?.message ?? "vTiger request failed");
  }

  return payload.result as T;
};
