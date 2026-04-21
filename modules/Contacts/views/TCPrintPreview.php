<?php

include_once 'dbo_db/ActivitySummary.php';
include_once 'dbo_db/HoldingsDB.php';
include_once 'dbo_db/Helper.php';

// ini_set('display_errors', 1); error_reporting(E_ALL);

class Contacts_TCPrintPreview_View extends Vtiger_Index_View
{

    protected $record = null;

    public function preProcess(Vtiger_Request $request, $display = false)
    {
        $recordId = $request->get('record');
        $moduleName = $request->getModule();

        // Getting model to reuse it in parent
        if (!$this->record)  $this->record = Vtiger_DetailView_Model::getInstance($moduleName, $recordId);
    }

    public function process(Vtiger_Request $request)
    {
        include_once 'modules/Contacts/models/MetalsAPI.php';
        $docNo = $request->get('docNo');
        $tableName = $request->get('tableName');
        $docType = substr($docNo, 0, 3);
        $moduleName = $request->getModule();
        $recordModel = $this->record->getRecord();

        $companyRecord = Contacts_DefaultCompany_View::process();

        $activity = new dbo_db\ActivitySummary();
        $activity_data = $activity->getDocumentPrintPreviewData($docNo, $tableName);

        $erpDoc = (object) $activity_data;
        $pages = $this->makeDataPages($erpDoc->barItems);
        $company_full_address = Helper::getCompanyFullAddress($companyRecord);

        $viewer = $this->getViewer($request);
        $viewer->assign('RECORD_MODEL', $recordModel);
        $viewer->assign('ERP_DOCUMENT', $erpDoc);
        $viewer->assign('OROSOFT_DOCTYPE', $docType);
        $viewer->assign('HIDE_BP_INFO', $request->get('hideCustomerInfo'));
        $viewer->assign('COMPANY', $companyRecord);
        $viewer->assign('COMPANY_FULL_ADDRESS', $company_full_address);
        $viewer->assign('PAGES', $pages);
        $viewer->assign('PAGE_COUNT', count($pages));

        if ($request->get('PDFDownload')) {
            $html = $viewer->view("TC.tpl", $moduleName, true);
            $this->downloadPDF($html, $request);
        } else {
            $viewer->view("TC.tpl", $moduleName);
        }
    }

    function makeDataPages($barItems)
    {
        // Tunable budgets (in "row units")
        $firstPageBudget = 14;
        $nextPageBudget  = 14;

        // How many characters roughly fit in one wrapped line in your DESCRIPTION column.
        $charsPerLine = 202;

        // Every extra wrapped line consumes extra "row units"
        $pages = [];
        $budget = $firstPageBudget;
        $used = 0;
        $countOnPage = 0;

        foreach ($barItems as $item) {
            $desc  = isset($item->itemDescription) ? $item->itemDescription : '';

            $serialText = '';
            if (!empty($item->serialNumbers)) {
                $serialText = $item->serialNumbers;
            } elseif (!empty($item->serials) && is_array($item->serials)) {
                $serialText = implode(', ', $item->serials);
            }

            $text = trim($desc . ' ' . $serialText);
            $len = mb_strlen($text);

            // Estimate wrapped lines in the DESCRIPTION cell
            $lines = max(1, (int)ceil($len / $charsPerLine));

            // Convert lines -> "row units":
            $units = 1 + ($lines - 1);

            // If this item doesn't fit on current page, close page and start a new one
            if ($countOnPage > 0 && ($used + $units) > $budget) {
                $pages[] = $countOnPage;
                $budget = $nextPageBudget;
                $used = 0;
                $countOnPage = 0;
            }

            $used += $units;
            $countOnPage++;
        }

        // last page
        if ($countOnPage > 0)  $pages[] = $countOnPage;

        return $pages;
    }


    function makeDataPage($transaction)
    {
        $totalPage = 1;
        $recordCount = 15;
        if (count($transaction) > $recordCount) {
            $totaldataAfterFirstPage = count($transaction) - $recordCount;
            $totalPage = ceil($totaldataAfterFirstPage / $recordCount) + 1;
        }
        return $totalPage;
    }

    public function postProcess(Vtiger_Request $request) {}

    function downloadPDF($html, Vtiger_Request $request)
    {
        global $root_directory;

        $recordModel = $this->record->getRecord();
        $clientID = $recordModel->get('cf_898');

        // Base filename (safe)
        $baseName = $clientID . '-' . str_replace('/', '-', $request->get('docNo')) . "-TC";

        // Storage directory
        $storagePath = rtrim($root_directory, '/') . '/storage/pdf-temp/';

        // Ensure directory exists
        if (!is_dir($storagePath)) {
            if (!mkdir($storagePath, 0755, true) && !is_dir($storagePath)) {
                throw new \RuntimeException("Cannot create storage directory: $storagePath");
            }
        }

        // Unique filenames (avoid collisions)
        $unique = uniqid($baseName . '-', true);
        $htmlFile = $storagePath . $unique . '.html';
        $pdfFile = $storagePath . $unique . '.pdf';

        try {
            // Write HTML safely
            if (file_put_contents($htmlFile, $html) === false) {
                throw new \RuntimeException("Cannot write HTML file: $htmlFile");
            }

            // Build command safely
            $cmd = sprintf(
                'wkhtmltopdf --enable-local-file-access -L 0 -R 0 -B 0 -T 0 --disable-smart-shrinking %s %s 2>&1',
                escapeshellarg($htmlFile),
                escapeshellarg($pdfFile)
            );

            exec($cmd, $output, $exitCode);

            // Check if PDF was generated
            if ($exitCode !== 0 || !file_exists($pdfFile)) {
                throw new \RuntimeException(
                    "PDF generation failed:\nCommand: $cmd\nOutput:\n" . implode("\n", $output)
                );
            }

            // Remove HTML file immediately
            @unlink($htmlFile);

            // Send headers
            header("Content-Type: application/pdf");
            header("Cache-Control: private");
            header("Content-Disposition: attachment; filename=\"{$baseName}.pdf\"");
            header("Content-Description: Generated PDF");
            header("Content-Length: " . filesize($pdfFile));

            // Clean output buffer
            if (ob_get_length()) {
                ob_clean();
            }

            flush();

            // Output file
            readfile($pdfFile);
        } catch (\Throwable $e) {
            // Cleanup on error
            @unlink($htmlFile);
            @unlink($pdfFile);

            // Log error (you can replace this with your logger)
            error_log($e->getMessage());

            // Optional: show message
            http_response_code(500);
            echo "PDF generation failed.";
        }

        // Final cleanup
        @unlink($pdfFile);

        exit;
    }
}
