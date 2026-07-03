<?php



class Vtiger_TodayTasks_Dashboard extends Vtiger_IndexAjax_View
{

    public function process(Vtiger_Request $request)
    {

        $currentUser = Users_Record_Model::getCurrentUserModel();

        $viewer = $this->getViewer($request);

        $moduleName = $request->getModule();

        $page = $request->get('page');

        $linkId = $request->get('linkid');

        $pagingModel = new Vtiger_Paging_Model();

        $pagingModel->set('page', $page);

        $pagingModel->set('limit', 10);

        $moduleModel = Vtiger_Module_Model::getInstance($moduleName);

        $todayTasks = $moduleModel->getCalendarActivities('today_tasks', $pagingModel, $currentUser->getId(), null);

        $widget = Vtiger_Widget_Model::getInstance($linkId, $currentUser->getId());

        $viewer->assign('WIDGET', $widget);

        $viewer->assign('MODULE_NAME', $moduleName);

        $viewer->assign('ACTIVITIES', $todayTasks);

        $viewer->assign('PAGING', $pagingModel);

        $viewer->assign('CURRENTUSER', $currentUser);

        $content = $request->get('content');

        if (!empty($content)) {

            $viewer->view('dashboards/CalendarActivitiesContents.tpl', $moduleName);
        } else {

            $viewer->view('dashboards/TodayTasks.tpl', $moduleName);
        }
    }
}
