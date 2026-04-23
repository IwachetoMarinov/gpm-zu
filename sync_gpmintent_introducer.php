<?php
require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/include/utils/utils.php';
require_once __DIR__ . '/includes/main/WebUI.php';

global $adb;

$sql = "
    UPDATE vtiger_gpmintent gi
    INNER JOIN vtiger_contactdetails c
        ON c.contactid = gi.contact_id
    SET gi.introducer_contact_id = c.introducer_id
    WHERE gi.contact_id IS NOT NULL
      AND c.introducer_id IS NOT NULL
      AND c.introducer_id <> 0
";

$result = $adb->pquery($sql, []);

if ($result) {
    echo "OK: synced non-empty GPMIntent introducer values from Contacts\n";
} else {
    echo "ERROR: sync failed\n";
}