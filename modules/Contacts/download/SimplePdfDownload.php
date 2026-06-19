<?php

/**
 * SimplePdfDownload.php
 *
 * Shared helper for Contacts views that convert HTML to PDF via wkhtmltopdf
 * and stream the result. Matches the legacy downloadPDF() behavior in each view.
 */
final class SimplePdfDownload
{
    /**
     * Convert HTML to PDF and send it as a download.
     *
     * @param string $html              Rendered document HTML
     * @param string $fileName          Base name (no extension) used for temp files
     * @param array  $options           Optional overrides:
     *   - downloadName (string)       Attachment filename (default: {$fileName}.pdf)
     *   - contentDescription (string) Content-Description header
     */
    public static function process(string $html, string $fileName, array $options = []): void
    {
        global $root_directory;

        $downloadName = $options['downloadName'] ?? ($fileName . '.pdf');
        $contentDescription = $options['contentDescription'] ?? 'Global Precious Metals CRM Data';

        $basePath = rtrim($root_directory, "/\\") . DIRECTORY_SEPARATOR . $fileName;
        $htmlPath = $basePath . '.html';
        $pdfPath  = $basePath . '.pdf';

        $handle = fopen($htmlPath, 'a') or die('Cannot open file:  ');
        fwrite($handle, $html);
        fclose($handle);

        exec(
            'wkhtmltopdf --enable-local-file-access  -L 0 -R 0 -B 0 -T 0 --disable-smart-shrinking '
            . $htmlPath . ' ' . $pdfPath
        );
        unlink($htmlPath);

        header('Content-type: application/pdf');
        header('Cache-Control: private');
        header('Content-Disposition: attachment; filename=' . $downloadName);
        header('Content-Description: ' . $contentDescription);
        ob_clean();
        flush();
        readfile($pdfPath);
        unlink($pdfPath);
        exit;
    }

    public static function clientIdFromRecord($recordModel): string
    {
        return (string) $recordModel->get('cf_898');
    }

    public static function docNoLastPart(string $docNo): string
    {
        $parts = explode('/', $docNo);
        return (string) (end($parts) ?: '');
    }

    /**
     * e.g. CLIENT-DOCNO-WITH-DASHES-TC
     */
    public static function fileNameDocNoSuffix(string $clientID, string $docNo, string $suffix): string
    {
        return $clientID . '-' . str_replace('/', '-', $docNo) . '-' . $suffix;
    }

    /**
     * e.g. CLIENT-PI-2026-12345-PI
     */
    public static function fileNameDocTypeYear(
        string $clientID,
        string $docType,
        string $docNo,
        ?string $lastDocType = null
    ): string {
        $year = date('Y');
        $lastPart = self::docNoLastPart($docNo);
        $last = $lastDocType ?? $docType;

        return $clientID . '-' . $docType . '-' . $year . '-' . $lastPart . '-' . $last;
    }

    /**
     * e.g. CLIENT-CR-2026-12345-CR
     */
    public static function fileNameTemplateYear(string $clientID, string $template, string $docNo): string
    {
        $year = date('Y');
        $lastPart = self::docNoLastPart($docNo);

        return $clientID . '-' . $template . '-' . $year . '-' . $lastPart . '-' . $template;
    }
}
