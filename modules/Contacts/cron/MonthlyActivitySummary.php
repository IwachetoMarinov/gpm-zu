<?php

/* modules/Contacts/cron/MonthlyActivitySummary.php */
include_once 'CronHelpers.php';
include_once 'ActivitySummaryService.php';

// TEST cron job 
// /usr/bin/php /var/www/html/gpm-zu/monthly_transaction.php

class Contacts_MonthlyActivitySummary
{
    public function process()
    {
        echo "Starting Monthly Activity Summary Cron...\n";

        // 1. Check if not first day of the month, if yes then exit (to avoid running on the first day of the month)
        // if (date('d') !== '01') return;

        // 2. Build date range for the current month
        $date_range = Contacts_CronHelpers::buildMonthlyDateRange();

        echo "Date Range for Summary: " . implode(' to ', $date_range) . "\n";

        // 3 Get all Party codes (client IDs) to process monthly transactions for each client
        $clint_ids =  Contacts_CronHelpers::fetchClientIds();

        echo "<pre>";
        print_r($clint_ids);
        echo "</pre>";
    }
}
