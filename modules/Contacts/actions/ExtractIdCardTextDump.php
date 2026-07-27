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
     * Receives OCR text or creates a Contact from POS wizard fields.
     */
    public function process(Vtiger_Request $request)
    {
        $response = new Vtiger_Response();

        try {
            $operation = trim((string) $request->get('operation'));

            if ($operation === 'createContact') {
                $response->setResult($this->createContactFromWizard($request));
                $response->emit();
                return;
            }

            $rawText = trim((string) $request->get('rawText'));

            if ($rawText === '') {
                throw new InvalidArgumentException(
                    'The extracted ID card text is missing.'
                );
            }

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

    /**
     * @return array<string, mixed>
     */
    private function createContactFromWizard(Vtiger_Request $request): array
    {
        $fields = $this->readWizardFields($request);
        $this->assertRequiredWizardFields($fields);

        $currentUser = Users_Record_Model::getCurrentUserModel();
        $recordModel = Vtiger_Record_Model::getCleanInstance('Contacts');
        $recordModel->set('mode', '');
        $recordModel->set('firstname', $fields['firstName']);
        $recordModel->set('lastname', $fields['lastName']);
        $recordModel->set('birthday', $fields['dateOfBirth']);
        $recordModel->set('mailingstreet', $fields['residentialAddress']);
        $recordModel->set(
            'mailingcountry',
            $fields['issuingCountry'] !== '' ? $fields['issuingCountry'] : $fields['nationality']
        );
        $recordModel->set('description', $this->buildContactDescription($fields));
        $recordModel->set('assigned_user_id', $currentUser->getId());

        $recordModel->save();

        $contactId = (int) $recordModel->getId();

        if ($contactId <= 0) {
            throw new RuntimeException('The Contact could not be created.');
        }

        return [
            'contactId' => $contactId,
            'contactName' => trim($fields['firstName'] . ' ' . $fields['lastName']),
        ];
    }

    /**
     * @return array<string, string>
     */
    private function readWizardFields(Vtiger_Request $request): array
    {
        return [
            'firstName' => trim((string) $request->get('firstName')),
            'lastName' => trim((string) $request->get('lastName')),
            'fullName' => trim((string) $request->get('fullName')),
            'documentNumber' => trim((string) $request->get('documentNumber')),
            'dateOfBirth' => trim((string) $request->get('dateOfBirth')),
            'nationality' => trim((string) $request->get('nationality')),
            'issueDate' => trim((string) $request->get('issueDate')),
            'expiryDate' => trim((string) $request->get('expiryDate')),
            'residentialAddress' => trim((string) $request->get('residentialAddress')),
            'documentType' => trim((string) $request->get('documentType')),
            'issuingCountry' => trim((string) $request->get('issuingCountry')),
            'rawText' => trim((string) $request->getRaw('rawText')),
        ];
    }

    /**
     * @param array<string, string> $fields
     */
    private function assertRequiredWizardFields(array $fields): void
    {
        $requiredKeys = [
            'firstName',
            'lastName',
            'fullName',
            'documentNumber',
            'dateOfBirth',
            'nationality',
            'issueDate',
            'expiryDate',
            'residentialAddress',
            'documentType',
            'issuingCountry',
        ];

        foreach ($requiredKeys as $key) {
            if ($fields[$key] === '') {
                throw new InvalidArgumentException(
                    sprintf('The field "%s" is required.', $key)
                );
            }
        }
    }

    /**
     * @param array<string, string> $fields
     */
    private function buildContactDescription(array $fields): string
    {
        $lines = [
            'POS Wizard ID card registration',
            'Full name: ' . $fields['fullName'],
            'Document number: ' . $fields['documentNumber'],
            'Document type: ' . $fields['documentType'],
            'Date of birth: ' . $fields['dateOfBirth'],
            'Nationality: ' . $fields['nationality'],
            'Issue date: ' . $fields['issueDate'],
            'Expiry date: ' . $fields['expiryDate'],
            'Issuing country: ' . $fields['issuingCountry'],
            'Residential address: ' . $fields['residentialAddress'],
        ];

        if ($fields['rawText'] !== '') {
            $lines[] = '';
            $lines[] = 'OCR raw text:';
            $lines[] = $fields['rawText'];
        }

        return implode(PHP_EOL, $lines);
    }
}
