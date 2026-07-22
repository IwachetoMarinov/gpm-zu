<?php

class Contacts_ExtractIdCardTextDump_Action extends Vtiger_Action_Controller
{
    /**
     * Allows authenticated vTiger users to execute this action.
     */
    public function checkPermission(Vtiger_Request $request)
    {
        $moduleName = $request->getModule();

        if (!Users_Privileges_Model::isPermitted($moduleName, 'CreateView')) {
            throw new AppException(vtranslate('LBL_PERMISSION_DENIED'));
        }
    }

    /**
     * Receives OCR text extracted in the browser.
     */
    public function process(Vtiger_Request $request)
    {
        $response = new Vtiger_Response();

        try {
            $rawText = trim((string) $request->get('rawText'));

            if ($rawText === '') {
                throw new InvalidArgumentException(
                    'The extracted ID card text is missing.'
                );
            }

            /*
             * Temporary response.
             *
             * In the next step, this text will be sent to the local
             * llama.cpp server for structured field extraction.
             */
            $response->setResult([
                'success' => true,
                'rawText' => $rawText,
                'textLength' => strlen($rawText),
            ]);
        } catch (Throwable $exception) {
            $response->setError(
                400,
                $exception->getMessage()
            );
        }

        $response->emit();
    }
}
