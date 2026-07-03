<?php

class Vtiger_ClientsList_Dashboard extends Vtiger_IndexAjax_View {

    public function process(Vtiger_Request $request) {
        $currentUser = Users_Record_Model::getCurrentUserModel();
        $viewer = $this->getViewer($request);
        $moduleName = $request->getModule();
        $linkId = $request->get('linkid');

        $contactsModule = Vtiger_Module_Model::getInstance('Contacts');
        $clients = $contactsModule->getAssignedClients($currentUser->getId());

        $cf898Field = Vtiger_Field_Model::getInstance('cf_898', $contactsModule);
        $cf898Label = $cf898Field ? vtranslate($cf898Field->get('label'), 'Contacts') : 'Client ID';

        $widget = Vtiger_Widget_Model::getInstance($linkId, $currentUser->getId());

        $viewer->assign('WIDGET', $widget);
        $viewer->assign('MODULE_NAME', $moduleName);
        $viewer->assign('CONTACTS_MODULE', 'Contacts');
        $viewer->assign('CLIENTS', $clients);
        $viewer->assign('CF898_LABEL', $cf898Label);

        $viewer->view('dashboards/ClientsList.tpl', $moduleName);
    }
}
