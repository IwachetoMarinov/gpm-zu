<?php

class Potentials_AutoLinkContact_Handler extends VTEventHandler
{

    public function handleEvent($eventName, $entityData)
    {

        if ($eventName !== 'vtiger.entity.beforesave')  return;

        $moduleName = $entityData->getModuleName();

        if ($moduleName !== 'Potentials')  return;

        $data = $entityData->getData();

        // Get ERP number from Opportunity
        $erp = $data['cf_1181'];

        if (empty($erp)) return;

        global $adb;

        // Find matching Contact
        $result = $adb->pquery(
            "SELECT vtiger_contactscf.contactid 
             FROM vtiger_contactscf
             INNER JOIN vtiger_crmentity ON vtiger_crmentity.crmid = vtiger_contactscf.contactid
             WHERE vtiger_crmentity.deleted = 0
             AND vtiger_contactscf.cf_898 = ?",
            [$erp]
        );

        if ($adb->num_rows($result) == 1) {
            $contactId = $adb->query_result($result, 0, 'contactid');

            // Set relation automatically
            $entityData->set('contact_id', $contactId);
        }
    }
}
