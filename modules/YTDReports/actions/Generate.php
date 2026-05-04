<?php

include_once 'modules/Contacts/cron/CronHelpers.php';
include_once 'modules/Contacts/cron/ActivitySummaryService.php';
include_once 'modules/Contacts/cron/StatementOfHoldingsService.php';

class YTDReports_Generate_Action extends Vtiger_Action_Controller
{
    public function checkPermission(Vtiger_Request $request)
    {
        return true;
    }

    public function process(Vtiger_Request $request)
    {
        $contactId = $request->get('contact_id');

        $response = new Vtiger_Response();

        if (!$contactId) {
            $response->setError('Missing contact_id');
            $response->emit();
            return;
        }

        // Get client_id from contact
        $contactRecord = Vtiger_Record_Model::getInstanceById($contactId, 'Contacts');
        $client_id = $contactRecord->get('cf_898');

        if (!$client_id) {
            $response->setError('Client ID not found');
            $response->emit();
            return;
        }

        // Build date range (previous month)
        $date_range = Contacts_CronHelpers::buildMonthlyDateRange();

        // Run your services (same as cron)
        $activityService = new Contacts_ActivitySummaryService();
        $activityService->generateAndStoreForClient(strval($client_id), $date_range);

        $holdingsService = new Contacts_StatementOfHoldingsService();
        $holdingsService->processClient(strval($client_id), $date_range);

        $response->setResult([
            'success' => true,
            'message' => 'YTD Reports generated successfully'
        ]);

        $response->emit();
    }
}
