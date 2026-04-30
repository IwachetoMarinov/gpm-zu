<?php

class YTDReports_Monthly_Cron
{
    public function process()
    {
        echo "Starting YTD Reports Monthly Cron...\n";
        
        file_put_contents(
            '/tmp/ytd_cron_test.log',
            "YTD monthly cron ran at " . date('Y-m-d H:i:s') . "\n",
            FILE_APPEND
        );

        echo "Starting YTD Reports Monthly Cron...\n";

        return true;
    }
}