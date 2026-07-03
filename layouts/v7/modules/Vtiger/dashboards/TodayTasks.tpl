<div class="dashboardWidgetHeader">

    {include file="dashboards/WidgetHeader.tpl"|@vtemplate_path:$MODULE_NAME}

</div>

<div name="history" class="dashboardWidgetContent" style="padding-top:15px;">

    {include file="dashboards/CalendarActivitiesContents.tpl"|@vtemplate_path:$MODULE_NAME WIDGET=$WIDGET}

</div>

<div class="widgeticons dashBoardWidgetFooter">

    <div class="footerIcons pull-right">

        {include file="dashboards/DashboardFooterIcons.tpl"|@vtemplate_path:$MODULE_NAME}

    </div>

</div>

