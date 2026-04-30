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
        $activityService->generateAndStoreForClient($client_id, $date_range);

        $holdingsService = new Contacts_StatementOfHoldingsService();
        $holdingsService->processClient($client_id, $date_range);

        return true;
    }
}
