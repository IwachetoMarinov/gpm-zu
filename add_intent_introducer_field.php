<?php
/* Run once: creates a GPMIntent reference field "Introducer" pointing to Contacts */

require_once __DIR__ . '/vendor/autoload.php';
include_once 'vtlib/Vtiger/Module.php';

$intent = Vtiger_Module::getInstance('GPMIntent');
$contacts = Vtiger_Module::getInstance('Contacts');

if (!$intent) {
    echo "ERROR: GPMIntent module not found\n";
    exit;
}
if (!$contacts) {
    echo "ERROR: Contacts module not found\n";
    exit;
}

/**
 * Choose the block in GPMIntent where the field should appear.
 * Prefer Intent Information; fallback to first available block.
 */
$block = Vtiger_Block::getInstance('LBL_INTENT_INFORMATION', $intent);
if (!$block) {
    $blocks = Vtiger_Block::getAllForModule($intent);
    $block = $blocks ? $blocks[0] : null;
}
if (!$block) {
    echo "ERROR: No block found for GPMIntent\n";
    exit;
}

/**
 * Avoid duplicates: if field already exists, stop.
 */
$fieldName = 'introducer_contact_id';
$existing = Vtiger_Field::getInstance($fieldName, $intent);
if ($existing) {
    echo "OK: Field already exists: {$fieldName}\n";
    exit;
}

/**
 * Create read-only reference field on Intent table.
 */
$field = new Vtiger_Field();
$field->name = $fieldName;
$field->label = 'Introducer';
$field->table = 'vtiger_gpmintent';
$field->column = $fieldName;
$field->columntype = 'INT(11)';
$field->uitype = 10;          // Reference
$field->typeofdata = 'V~O';   // Optional
$field->displaytype = 2;      // Detail view only / non-editable in normal edit forms
$field->summaryfield = 1;

$block->addField($field);

// Link the reference only to Contacts
$field->setRelatedModules(['Contacts']);

echo "OK: Created GPMIntent.Introducer reference field to Contacts ({$fieldName})\n";