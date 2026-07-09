<div class="dashboardWidgetHeader">
    {include file="dashboards/WidgetHeader.tpl"|@vtemplate_path:$MODULE_NAME}
</div>

<style>
    #clientTransactionsWidget_{$WIDGET_SUFFIX} .clientTransactionsTabNav {
        display: flex;
        flex-wrap: wrap;
        gap: 6px;
        margin: 0 0 12px 0;
        padding: 0;
        list-style: none;
    }
    #clientTransactionsWidget_{$WIDGET_SUFFIX} .clientTransactionsTabNav > li {
        position: static !important;
        border: none !important;
        box-shadow: none !important;
        padding: 0 !important;
        margin: 0 !important;
        float: none !important;
        display: block;
    }
    #clientTransactionsWidget_{$WIDGET_SUFFIX} .clientTransactionsTabNav > li > a {
        display: block;
        padding: 7px 10px;
        font-size: 12px;
        line-height: 1.3;
        color: #555;
        background: #f5f5f5;
        border: 1px solid #ddd;
        border-radius: 4px;
        text-decoration: none;
        white-space: nowrap;
        cursor: pointer;
    }
    #clientTransactionsWidget_{$WIDGET_SUFFIX} .clientTransactionsTabNav > li > a:hover,
    #clientTransactionsWidget_{$WIDGET_SUFFIX} .clientTransactionsTabNav > li > a:focus {
        color: #333;
        background: #eee;
        border-color: #ccc;
    }
    #clientTransactionsWidget_{$WIDGET_SUFFIX} .clientTransactionsTabNav > li.active > a,
    #clientTransactionsWidget_{$WIDGET_SUFFIX} .clientTransactionsTabNav > li.active > a:hover,
    #clientTransactionsWidget_{$WIDGET_SUFFIX} .clientTransactionsTabNav > li.active > a:focus {
        color: #fff;
        background: #2c3b49;
        border-color: #2c3b49;
    }
    #clientTransactionsWidget_{$WIDGET_SUFFIX} .clientTransactionsTabContent {
        min-height: 220px;
        padding-top: 5px;
    }
    #clientTransactionsWidget_{$WIDGET_SUFFIX} .clientTransactionsTabContent .tab-pane {
        position: relative !important;
        border: none !important;
        box-shadow: none !important;
        padding: 0 !important;
    }
</style>

<div class="dashboardWidgetContent clientTransactionsWidgetContent" id="clientTransactionsWidget_{$WIDGET_SUFFIX}" style="padding:10px 15px;">
    <p class="text-muted" style="margin-bottom:10px;font-size:12px;">
        {vtranslate('LBL_CLIENT_TRANSACTIONS_PLACEHOLDER', $MODULE_NAME)}
    </p>

    <ul class="clientTransactionsTabNav" role="tablist">
        <li role="presentation" class="active">
            <a href="#clientTransactionsTabByClient_{$WIDGET_SUFFIX}"
                id="clientTransactionsTabLinkByClient_{$WIDGET_SUFFIX}"
                role="tab"
                data-toggle="tab"
                data-chart="bar">
                {vtranslate('LBL_CLIENT_TRANSACTIONS_BY_CLIENT', $MODULE_NAME)}
            </a>
        </li>
        <li role="presentation">
            <a href="#clientTransactionsTabByMonth_{$WIDGET_SUFFIX}"
                id="clientTransactionsTabLinkByMonth_{$WIDGET_SUFFIX}"
                role="tab"
                data-toggle="tab"
                data-chart="line">
                {vtranslate('LBL_CLIENT_TRANSACTIONS_BY_MONTH', $MODULE_NAME)}
            </a>
        </li>
        <li role="presentation">
            <a href="#clientTransactionsTabByType_{$WIDGET_SUFFIX}"
                id="clientTransactionsTabLinkByType_{$WIDGET_SUFFIX}"
                role="tab"
                data-toggle="tab"
                data-chart="doughnut">
                {vtranslate('LBL_CLIENT_TRANSACTIONS_BY_TYPE', $MODULE_NAME)}
            </a>
        </li>
    </ul>

    <div class="tab-content clientTransactionsTabContent">
        <div role="tabpanel"
            class="tab-pane fade in active"
            id="clientTransactionsTabByClient_{$WIDGET_SUFFIX}">
            <canvas id="clientTransactionsBar_{$WIDGET_SUFFIX}" height="120"></canvas>
        </div>
        <div role="tabpanel"
            class="tab-pane fade"
            id="clientTransactionsTabByMonth_{$WIDGET_SUFFIX}">
            <canvas id="clientTransactionsLine_{$WIDGET_SUFFIX}" height="120"></canvas>
        </div>
        <div role="tabpanel"
            class="tab-pane fade"
            id="clientTransactionsTabByType_{$WIDGET_SUFFIX}">
            <canvas id="clientTransactionsDoughnut_{$WIDGET_SUFFIX}" height="120"></canvas>
        </div>
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
        var widgetRoot = jQuery('#clientTransactionsWidget_' + suffix);
        var charts = { bar: null, line: null, doughnut: null };

        function createBarChart() {
            var ctx = document.getElementById('clientTransactionsBar_' + suffix);
            if (!ctx || charts.bar) {
                return charts.bar;
            }
            charts.bar = new Chart(ctx, {
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
            return charts.bar;
        }

        function createLineChart() {
            var ctx = document.getElementById('clientTransactionsLine_' + suffix);
            if (!ctx || charts.line) {
                return charts.line;
            }
            charts.line = new Chart(ctx, {
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
            return charts.line;
        }

        function createDoughnutChart() {
            var ctx = document.getElementById('clientTransactionsDoughnut_' + suffix);
            if (!ctx || charts.doughnut) {
                return charts.doughnut;
            }
            charts.doughnut = new Chart(ctx, {
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
            return charts.doughnut;
        }

        function showChart(chartType) {
            var chart = null;
            if (chartType === 'bar') {
                chart = createBarChart();
            } else if (chartType === 'line') {
                chart = createLineChart();
            } else if (chartType === 'doughnut') {
                chart = createDoughnutChart();
            }
            if (chart) {
                chart.resize();
            }
        }

        widgetRoot.find('a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
            showChart(jQuery(e.target).data('chart'));
        });

        showChart('bar');
    });
</script>
