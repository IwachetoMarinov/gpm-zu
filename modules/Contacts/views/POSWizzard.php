<?php

class Contacts_POSWizzard_View extends Vtiger_Index_View
{
	public function requiresPermission(Vtiger_Request $request)
	{
		return array(
			array('module_parameter' => 'module', 'action' => 'DetailView')
		);
	}

	public function preProcess(Vtiger_Request $request, $display = false)
	{
	}

	public function process(Vtiger_Request $request)
	{
		$viewer = $this->getViewer($request);
		$moduleName = $request->getModule();

		$viewer->assign('MODULE', $moduleName);
		$viewer->assign('APP', $request->get('app'));
		$viewer->assign('USER_MODEL', Users_Record_Model::getCurrentUserModel());
		$viewer->view('POSWizzard.tpl', $moduleName);
	}

	public function postProcess(Vtiger_Request $request)
	{
	}
}
