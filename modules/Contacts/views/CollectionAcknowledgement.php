<?php

include_once 'dbo_db/Helper.php';
include_once 'dbo_db/HoldingsDB.php';
include_once 'dbo_db/ActivitySummary.php';
include_once 'modules/Contacts/download/SimplePdfDownload.php';

// ini_set('display_errors', 1); error_reporting(E_ALL);


class Contacts_CollectionAcknowledgement_View extends Vtiger_Index_View
{

    protected $record = null;

    public function preProcess(Vtiger_Request $request, $display = false)
    {
        $recordId = $request->get('record');
        $moduleName = $request->getModule();

        // Getting model to reuse it in parent
        if (!$this->record) $this->record = Vtiger_DetailView_Model::getInstance($moduleName, $recordId);
    }

    public function process(Vtiger_Request $request)
    {

        $docNo = $request->get('docNo');
        $moduleName = $request->getModule();
        $recordModel = $this->record->getRecord();
        $tableName = $request->get('tableName');

        $companyRecord = Contacts_DefaultCompany_View::process();

        $activity = new dbo_db\ActivitySummary();
        $erpData = $activity->getDocumentPrintPreviewData($docNo, $tableName);

        $viewer = $this->getViewer($request);
        $company_full_address = Helper::getCompanyFullAddressWithoutCommas($companyRecord);

        $viewer->assign('RECORD_MODEL', $recordModel);
        $viewer->assign('PAGES', 1);
        $viewer->assign('HIDE_BP_INFO', false);
        $viewer->assign('COMPANY', $companyRecord);
        $viewer->assign('COMPANY_FULL_ADDRESS', $company_full_address);
        $viewer->assign('ERP_DOCUMENT', $erpData);
        $viewer->assign('DOCNO', $request->get('docNo'));
        $viewer->assign('PDFDownload', $request->get('PDFDownload'));
        $viewer->assign('hideCustomerInfo', $request->get('hideCustomerInfo'));

        if ($request->get('PDFDownload')) {
            $html = $viewer->view("CA.tpl", $moduleName, true);
            $this->downloadPDF($html, $request);
        } else {
            $viewer->view("CA.tpl", $moduleName);
        }
    }

    public function postProcess(Vtiger_Request $request) {}

    function downloadPDF($html, Vtiger_Request $request)
    {
        $recordModel = $this->record->getRecord();
        $clientID = SimplePdfDownload::clientIdFromRecord($recordModel);
        $fileName = SimplePdfDownload::fileNameDocNoSuffix($clientID, (string) $request->get('docNo'), 'CA');

        SimplePdfDownload::process($html, $fileName);
    }
}
