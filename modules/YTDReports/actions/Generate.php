<?php

class YTDReports_Generate_Action extends Vtiger_Action_Controller
{
    public function checkPermission(Vtiger_Request $request)
    {
        return true;
    }

    public function process(Vtiger_Request $request)
    {
        $contactId = $request->get('contact_id');

        require_once 'modules/YTDReports/services/YTDReportService.php';

        $result = YTDReportService::generateForContact($contactId);

        $response = new Vtiger_Response();
        $response->setResult([
            'success' => true,
            'result' => $result,
        ]);
        $response->emit();
    }
}