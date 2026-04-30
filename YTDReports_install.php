<?php

require_once __DIR__ . '/vendor/autoload.php';
include_once 'vtlib/Vtiger/Module.php';
include_once 'include/utils/utils.php';
include_once 'vtlib/Vtiger/Cron.php';


$moduleName = 'YTDReports';

// Check if module exists
$module = Vtiger_Module::getInstance($moduleName);

// Create module if it doesn't exist
if (!$module) {
    $module = new Vtiger_Module();
    $module->name = $moduleName;
    $module->save();

    $module->initTables();

    echo "$moduleName module created\n";
} else {
    echo "$moduleName already exists\n";
}

// Link module to Contacts
$contactsModule = Vtiger_Module::getInstance('Contacts');

if ($contactsModule) {
    $contactsModule->setRelatedList(
        $module,
        'YTD Reports',
        ['ADD', 'SELECT'],
        'get_related_list'
    );

    echo "Related list added to Contacts\n";
} else {
    echo "Contacts module not found\n";
}

$job = Vtiger_Cron::getInstance('YTDReports Monthly');

if (!$job) {
    Vtiger_Cron::register(
        'YTDReports Monthly',
        'modules/YTDReports/cron/Monthly.php',
        1440,
        'YTDReports_Monthly_Cron'
    );

    echo "Cron job created\n";
} else {
    echo "Cron job already exists\n";
}
