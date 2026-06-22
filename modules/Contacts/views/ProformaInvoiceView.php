<?php

include_once 'dbo_db/ActivitySummary.php';
include_once 'dbo_db/HoldingsDB.php';
include_once 'dbo_db/Helper.php';
include_once 'modules/Contacts/helpers/ContactsHelper.php';
include_once 'modules/Contacts/download/SimplePdfDownload.php';

class Contacts_ProformaInvoiceView_View extends Vtiger_Index_View
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
        $tableName = $request->get('tableName');
        $moduleName = $request->getModule();
        $recordModel = $this->record->getRecord();

        $allBankAccounts = [];

        $companyRecord = Contacts_DefaultCompany_View::process();

        // ✅ Bank accounts;
        $allBankAccounts = BankAccount_Record_Model::getAllInstances();
        $bankAccountId   = $request->get('bank');

        $activity = new dbo_db\ActivitySummary();
        $activity_data = $activity->getProformaInvoiceData($docNo, $tableName);

        $average_spot_price = ContactsHelper::getAverageSpotPrice($activity_data['barItems'] ?? []);

        $docType = "PI";
        $erpDoc = (object) $activity_data;

        // Reorder Activitity Items for DN documents based on description if it is equal to "Monthly Storage Fee Invoice"
        foreach ($erpDoc->barItems as $key => $item) {
            $item = (object) $item;
            $item->metal = ContactsHelper::getMetalName($item->metal_type_code);
        }

        $bankAccountId = $request->get('bank');
        if (empty($bankAccountId) && !empty($allBankAccounts)) {
            $firstAccount  = reset($allBankAccounts);
            $bankAccountId = $firstAccount->getId();
        }

        // ✅ Handle no bank accounts gracefully
        if (empty($bankAccountId)) $bankAccountId = null;

        $selectedBank = null;
        if (!empty($bankAccountId)) $selectedBank = BankAccount_Record_Model::getInstanceById($bankAccountId);

        if (empty($selectedBank)) {
            // fallback dummy object to prevent template fatal
            $selectedBank = new BankAccount_Record_Model();
            $selectedBank->set('beneficiary_name', '');
            $selectedBank->set('account_no', '');
            $selectedBank->set('account_currency', '');
            $selectedBank->set('iban_no', '');
            $selectedBank->set('bank_name', '');
            $selectedBank->set('bank_address', '');
            $selectedBank->set('swift_code', '');
        }

        $intent = false;
        if (!empty($request->get('fromIntent'))) {
            $intent = Vtiger_Record_Model::getInstanceById($request->get('fromIntent'), 'GPMIntent');
        }

        $company_full_address = Helper::getCompanyFullAddress($companyRecord);

        $viewer = $this->getViewer($request);
        $viewer->assign('RECORD_MODEL', $recordModel);
        $viewer->assign('ALL_BANK_ACCOUNTS', $allBankAccounts);
        $viewer->assign('SELECTED_BANK', $selectedBank ?? null);
        $viewer->assign('ERP_DOCUMENT', $erpDoc);
        $viewer->assign('HIDE_BP_INFO', $request->get('hideCustomerInfo'));
        $viewer->assign('INTENT', $intent);
        $viewer->assign('COMPANY', $companyRecord);
        $viewer->assign('COMPANY_FULL_ADDRESS', $company_full_address);
        $viewer->assign('AVERAGE_SPOT_PRICE', $average_spot_price);
        $viewer->assign('PAGES', $this->makeDataPage($erpDoc->barItems, $docType));
        if ($request->get('PDFDownload')) {
            $html = $viewer->view("$docType.tpl", $moduleName, true);
            $this->downloadPDF($html, $request);
        } else {
            $viewer->view("$docType.tpl", $moduleName);
        }
    }

    function makeDataPage($transaction, $docType)
    {
        $totalPage = 1;
        $recordCount = ($docType == 'SAL') ? 6 : 14;
        if (count($transaction) > $recordCount) {
            $totaldataAfterFirstPage = count($transaction) - $recordCount;
            $totalPage = ceil($totaldataAfterFirstPage / $recordCount) + 1;
        }
        return $totalPage;
    }

    public function postProcess(Vtiger_Request $request) {}

    function downloadPDF($html, Vtiger_Request $request)
    {
        $recordModel = $this->record->getRecord();
        $clientID = SimplePdfDownload::clientIdFromRecord($recordModel);
        $fileName = SimplePdfDownload::fileNameDocTypeYear($clientID, 'PI', (string) $request->get('docNo'), 'PI');

        SimplePdfDownload::process($html, $fileName);
    }
}
