<div class="dashboardWidgetHeader">
    {include file="dashboards/WidgetHeader.tpl"|@vtemplate_path:$MODULE_NAME}
</div>

<div class="dashboardWidgetContent clientTransactionsWidgetContent" style="padding:10px 15px;max-height:480px;overflow-y:auto;">
    <p class="text-muted" style="margin-bottom:15px;">
        {vtranslate('LBL_CLIENT_TRANSACTIONS_PLACEHOLDER', $MODULE_NAME)}
    </p>

    <div style="padding:10px 0;">
        <h5>{vtranslate('LBL_CLIENT_TRANSACTIONS_BY_CLIENT', $MODULE_NAME)}</h5>
        <canvas id="clientTransactionsBar_{$WIDGET_SUFFIX}" height="90"></canvas>
    </div>

    <div style="padding:10px 0;">
        <h5>{vtranslate('LBL_CLIENT_TRANSACTIONS_BY_MONTH', $MODULE_NAME)}</h5>
        <canvas id="clientTransactionsLine_{$WIDGET_SUFFIX}" height="90"></canvas>
    </div>

    <div style="padding:10px 0 10px 0;">
        <h5>{vtranslate('LBL_CLIENT_TRANSACTIONS_BY_TYPE', $MODULE_NAME)}</h5>
        <canvas id="clientTransactionsDoughnut_{$WIDGET_SUFFIX}" height="90"></canvas>
    </div>
</div>

<div class="widgeticons dashBoardWidgetFooter">
    <div class="footerIcons pull-right">
        {include file="dashboards/DashboardFooterIcons.tpl"|@vtemplate_path:$MODULE_NAME}
    </div>
</div>

<script type="text/javascript" src="layouts/v7/lib/chartjs/chart.umd.min.js"></script>

<script>
    jQuery(document).ready(function() {
        var suffix = '{$WIDGET_SUFFIX|escape:"javascript"}';

        var barCtx = document.getElementById('clientTransactionsBar_' + suffix);
        if (barCtx) {
            new Chart(barCtx, {
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
                        legend: { display: true }
                    }
                }
            });
        }

        var lineCtx = document.getElementById('clientTransactionsLine_' + suffix);
        if (lineCtx) {
            new Chart(lineCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                    datasets: [{
                        label: 'Volume',
                        data: [42, 38, 55, 48, 61, 53],
                        borderColor: 'rgba(75, 192, 192, 1)',
                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                        fill: true,
                        tension: 0.3
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: { display: true }
                    }
                }
            });
        }

        var doughnutCtx = document.getElementById('clientTransactionsDoughnut_' + suffix);
        if (doughnutCtx) {
            new Chart(doughnutCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Buy', 'Sell', 'Transfer', 'Other'],
                    datasets: [{
                        label: 'By type',
                        data: [45, 30, 18, 7],
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.7)',
                            'rgba(54, 162, 235, 0.7)',
                            'rgba(255, 206, 86, 0.7)',
                            'rgba(153, 102, 255, 0.7)'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: { display: true, position: 'bottom' }
                    }
                }
            });
        }
    });
</script>
