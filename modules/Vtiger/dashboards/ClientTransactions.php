<?php

class Vtiger_ClientTransactions_Dashboard extends Vtiger_IndexAjax_View {

    public function process(Vtiger_Request $request) {
        $currentUser = Users_Record_Model::getCurrentUserModel();
        $viewer = $this->getViewer($request);
        $moduleName = $request->getModule();
        $linkId = $request->get('linkid');

        $widget = Vtiger_Widget_Model::getInstance($linkId, $currentUser->getId());

        $viewer->assign('WIDGET', $widget);
        $viewer->assign('MODULE_NAME', $moduleName);
        $viewer->assign('WIDGET_SUFFIX', $linkId);

        $viewer->view('dashboards/ClientTransactions.tpl', $moduleName);
    }
}
