<?php

/* modules/Contacts/cron/CronHelpers.php */

class Contacts_CronHelpers
{

    // Comments here

    public static function buildMonthlyDateRange()
    {
        $year = date('Y');
        $month = date('m');
        $startDate = date('Y-m-d', strtotime("$year-$month-01"));
        $endDate = date('Y-m-t', strtotime($startDate));
        return [$startDate, $endDate];
    }

    public static function fetchClientIds()
    {
        $db = PearDatabase::getInstance();

        $query = "
        SELECT DISTINCT cf_898 AS client_id
        FROM vtiger_contactscf
        WHERE cf_898 IS NOT NULL AND cf_898 != ''
    ";

        $result = $db->pquery($query, []);

        $clientIds = [];
        while ($row = $db->fetch_array($result)) {
            $clientIds[] = $row['client_id'];
        }

        return $clientIds;
    }
}
