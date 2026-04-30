<?php

require_once 'modules/Contacts/cron/CronHelpers.php';
require_once 'modules/Contacts/cron/ActivitySummaryService.php';
require_once 'modules/Contacts/cron/StatementOfHoldingsService.php';

class YTDReportService
{
    public static function generateForClient(string $client_id, array $date_range = [])
    {
        if (empty($date_range)) {
            $date_range = Contacts_CronHelpers::buildMonthlyDateRange();
        }

        $activityService = new Contacts_ActivitySummaryService();
        try {
            $activityService->generateAndStoreForClient($client_id, $date_range);
        } catch (Throwable $e) {
            echo "Error processing activity summary for client $client_id: " . $e->getMessage() . "\n";
        }

        $holdingsService = new Contacts_StatementOfHoldingsService();
        try {
            $holdingsService->processClient($client_id, $date_range);
        } catch (Throwable $e) {
            echo "Error processing statement of holdings for client $client_id: " . $e->getMessage() . "\n";
        }

        return true;
    }
}
