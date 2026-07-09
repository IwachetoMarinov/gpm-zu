<div class="dashboardWidgetHeader">
    {include file="dashboards/WidgetHeader.tpl"|@vtemplate_path:$MODULE_NAME}
</div>

<div class="dashboardWidgetContent clientsListWidgetContent"
    style="padding:10px 15px;max-height:320px;overflow-y:auto;">
    <div class="row" style="padding:5px;border-bottom:1px solid #eee;margin-bottom:5px;">
        <div class="col-lg-4"><strong>{vtranslate('SINGLE_Contacts', $CONTACTS_MODULE)}</strong></div>
        <div class="col-lg-3"><strong>{vtranslate('Email', $CONTACTS_MODULE)}</strong></div>
        <div class="col-lg-2"><strong>{$CF898_LABEL}</strong></div>
        <div class="col-lg-3"><strong>{vtranslate('Office Phone', $CONTACTS_MODULE)}</strong></div>
    </div>
    {foreach from=$CLIENTS item=CLIENT}
        <div class="row clientsListRow" style="padding:5px 0;border-bottom:1px solid #f3f3f3;">
            <div class="col-lg-4 textOverflowEllipsis" title="{$CLIENT->getName()|escape:'html'}">
                <a href="{$CLIENT->getDetailViewUrl()}">{$CLIENT->getName()}</a>
            </div>
            <div class="col-lg-3 textOverflowEllipsis" title="{$CLIENT->get('email')|escape:'html'}">
                {$CLIENT->get('email')}
            </div>
            <div class="col-lg-2 textOverflowEllipsis" title="{$CLIENT->get('cf_898')|escape:'html'}">
                {$CLIENT->get('cf_898')}
            </div>
            <div class="col-lg-3 textOverflowEllipsis" title="{$CLIENT->get('phone')|escape:'html'}">
                {$CLIENT->get('phone')}
            </div>
        </div>
    {foreachelse}
        <div class="noDataMsg" style="padding:10px 5px;">
            {vtranslate('LBL_NO_ASSIGNED_CLIENTS', $MODULE_NAME)}
        </div>
    {/foreach}
</div>

{* Test Charts *}
{* <div style="padding:10px 0 20px 0;">
    <h4>Client Transactions Test Chart</h4>
    <canvas id="clientsTransactionsChart_{$WIDGET->get('linkid')}" height="90"></canvas>
</div>

<div style="padding:10px 0 20px 0;">
    <h4>Client Transactions Test Trend</h4>
    <canvas id="clientsTransactionsTrendChart_{$WIDGET->get('linkid')}" height="90"></canvas>
</div>

<div class="widgeticons dashBoardWidgetFooter">
    <div class="footerIcons pull-right">
        {include file="dashboards/DashboardFooterIcons.tpl"|@vtemplate_path:$MODULE_NAME}
    </div>
</div>

<script type="text/javascript" src="layouts/v7/lib/chartjs/chart.umd.min.js"></script>

<script>
    jQuery(document).ready(function() {
        var linkId = '{$WIDGET->get('linkid')|escape:"javascript"}';

        var ctx = document.getElementById('clientsTransactionsChart_' + linkId);
        if (ctx) {
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ['Ivan Petrov', 'Test Salm', 'Michael Jordan', 'Client 4', 'Client 5'],
                    datasets: [{
                        label: 'Transactions',
                        data: [12, 19, 7, 15, 9],
                        backgroundColor: 'rgba(54, 162, 235, 0.6)'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: {
                            display: true
                        }
                    }
                }
            });
        }

        var trendCtx = document.getElementById('clientsTransactionsTrendChart_' + linkId);
        if (trendCtx) {
            new Chart(trendCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                    datasets: [{
                        label: 'Monthly volume',
                        data: [28, 35, 22, 41, 38, 47],
                        borderColor: 'rgba(255, 159, 64, 1)',
                        backgroundColor: 'rgba(255, 159, 64, 0.2)',
                        fill: true,
                        tension: 0.3
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: {
                            display: true
                        }
                    }
                }
            });
        }
    });
</script> *}