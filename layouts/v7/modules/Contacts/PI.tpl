<!DOCTYPE html>
<html>

<head>
    <title>PROFORMA INVOICE</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        {include file='PrintStyles.tpl'|vtemplate_path:'Contacts' print_layout='single'}
    </style>
</head>

<body>
    {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
        <script type="text/javascript" src="layouts/v7/lib/jquery/jquery.min.js"></script>
        <link type='text/css' rel='stylesheet' href='layouts/v7/lib/jquery/select2/select2.css'>
        <link type='text/css' rel='stylesheet' href='layouts/v7/lib/select2-bootstrap/select2-bootstrap.css'>
        <script type="text/javascript" src="layouts/v7/lib/jquery/select2/select2.min.js"></script>

        <ul style="list-style-type: none;
                margin: 0;
                padding: 0;
                overflow: hidden;
                background-color: #333;">

            {if $SELECTED_BANK}
                <li style="float:right">
                    <a style="display: block;color: white;text-align: center;padding: 14px 16px;text-decoration: none;background-color: #bea364;"
                        href="index.php?module=Contacts&view=ProformaInvoiceView&record={$RECORD_MODEL->getId()}&docNo={$smarty.request.docNo}&tableName={$smarty.request.tableName}&PDFDownload=true&bank={$SELECTED_BANK->getId()}{if $INTENT}&fromIntent={$smarty.request.fromIntent}{/if}&hideCustomerInfo={$smarty.request.hideCustomerInfo}">Download</a>
                </li>
            {/if}
            <li id='printConf' style="float:right">
                <span style="float: right;margin-right: 1px;color: white;background-color: #bea364;text-decoration: none;
                display: block;
                text-align: center;
                padding: 14px;cursor: pointer;">Settings</span>
            </li>

            {assign var="transactionWarningExcludes" value=['description', 'grand_total', 'matched_amt', 'posting_date']}
            {assign var="barItemWarningExcludes" value=[
                'metal_code',
                "metal_name",
                "metal_type_code",
                'warehouse',
                'tx_amount',
                'avg_spot_price',
                'posting_date',
                'item_code',
                'fine_oz',
                'gross_oz',
                'purity',
                'total_item_dc_amount',
                'weight',
                'remarks',
                'other_charge',
                'item_price',
                'narration',
                'long_desc',
                'premium_final',
                'exchange_rate',
                'serial_numbers',
                'bar_number'
            ]}

            {include file='TCWarnings.tpl'|vtemplate_path:'Contacts'
                ERP_DOCUMENT=$ERP_DOCUMENT
                TRANSACTION_WARNING_EXCLUDES=$transactionWarningExcludes
                BARITEM_WARNING_EXCLUDES=$barItemWarningExcludes
            }
        </ul>

        <script type="text/javascript" src="layouts/v7/modules/Contacts/resources/PrintConf.js"></script>
        {include file='printConf.tpl'|vtemplate_path:'Contacts'}
    {/if}
    {assign var="start" value=0}
    {assign var="end" value=1}
    {assign var="calcTotal" value=0}
    {assign var="SUB_TOTAL" value=0}
    {for $page=1 to $PAGES}
        {if $page eq 1}
            {assign var="end" value=6}
        {else}
            {assign var="end" value=($end+6)}
        {/if}
        <div class="printAreaContainer">
            <div class="full-width">
                <table class="print-tbl">
                    <tr>
                        <td style="height: 28mm;">
                            <img src='layouts/v7/modules/Contacts/resources/gpm-new-logo.png'
                                style="max-height: 100%; float:right;width: 154px;">
                            <div style="font-size:11pt;margin-top: 14px;margin-bottom: 32px;">
                                {include file='CustomerPrintInfo.tpl'|vtemplate_path:'Contacts'}
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 10mm; text-decoration: underline;text-align: center">
                            <strong>PROFORMA INVOICE</strong>
                        </td>
                    </tr>

                    {if isset($COMPANY) && !empty($COMPANY->get('vat_id'))}
                        <tr>
                            <td style="text-align: left;font-size: 10pt; font-weight: bold;">
                                VAT Nr: {$COMPANY->get('vat_id')}
                            </td>
                        </tr>
                    {/if}

                    <tr>
                        <td style="text-align: right;font-size: 9pt">
                            All amounts in {$ERP_DOCUMENT->currency}
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 9pt; height: 168mm; vertical-align: top;">
                            <table class="activity-tbl" style="margin-bottom:5mm">
                                <tr>
                                    <th colspan="2" style="width:25%;text-align:center">INVOICE NO</th>
                                    <th style="width:25%;text-align:center">INVOICE DATE</th>
                                    <th style="width:25%;text-align:center">ORDER</th>
                                </tr>
                                <tr>
                                    <td colspan="2" style="text-align:center">{$smarty.request.docNo}</td>
                                    <td style="text-align:center">{$ERP_DOCUMENT->documentDate}</td>
                                    <td style="text-align:center">Purchase & Delivery</td>
                                </tr>
                            </table>
                            <table class="activity-tbl">
                                <tr>
                                    <th style="width:10%;">QTY</th>
                                    <th style="width:40%;">DESCRIPTION</th>
                                    <th style="width:13%;text-align:center">{$ERP_DOCUMENT->currency}/UNIT</th>
                                    <th style="width:12%;text-align:center">FINE OZ.</th>
                                    <th style="width:30%;text-align:center">TOTAL {$ERP_DOCUMENT->currency}</th>
                                </tr>
                                {assign var="metalPrice" value=($ERP_DOCUMENT->xauPrice)+($ERP_DOCUMENT->mbtcPrice)+($ERP_DOCUMENT->xagPrice)+($ERP_DOCUMENT->xptPrice)+($ERP_DOCUMENT->xpdPrice)}
                                {assign var="balanceAmount" value=($balanceAmount)+($TRANSACTION->usdVal)}
                                {for $loopStart=$start to $end}

                                    {assign var="barItem" value=$ERP_DOCUMENT->barItems[$loopStart]}
                                    {assign var="start" value=($loopStart+1)}

                                    {assign var="total" value=$barItem->totalItemAmount}
                                    {assign var="calcTotal" value=$calcTotal+round($total,2)}
                                    {assign var="SUB_TOTAL" value=$SUB_TOTAL+round($total,2)}
                                    {if $loopStart eq count($ERP_DOCUMENT->barItems)}
                                        {break}
                                    {/if}
                                    {if empty($barItem->quantity) and empty($barItem->longDesc)}
                                        {if strpos($barItem->narration,'GST') === 0 ||strpos($barItem->narration,'GST') > 0 }
                                        {else}
                                            <tr>
                                                <td style="vertical-align: top"></td>
                                                <td style="border-bottom:none;vertical-align: top">Storage Charge</td>
                                                <td style="text-align:right;vertical-align: top"></td>
                                                <td style="text-align:right;vertical-align: top"></td>
                                                <td style="text-align:right;vertical-align: top">{number_format($total,2)}</td>
                                            </tr>
                                        {/if}
                                    {else}
                                        <tr>
                                            <td style="vertical-align: top">{$barItem->quantity}</td>
                                            <td style="border-bottom:none;vertical-align: top">
                                                {$barItem->itemDescription} <br>
                                                {* <span style="font-size: smaller;font-style: italic;max-width: 250px;display: inline-block;word-break: break-all;white-space: normal;">{$barItem->serialNumbers}</span> *}
                                            </td>

                                            <td style="text-align:right;vertical-align: top">
                                                {number_format($barItem->unitPrice,2)}
                                            </td>

                                            <td style="text-align:right;vertical-align: top">
                                                {number_format($barItem->totalFineOz,4)}
                                            </td>

                                            <td style="text-align:right;vertical-align: top">
                                                {number_format($barItem->totalItemAmount,2)}
                                            </td>
                                        </tr>
                                    {/if}
                                {/for}

                                {if $PAGES eq $page}
                                    <tr>
                                        <th style="width:75%;" colspan="4">TOTAL INVOICE AMOUNT:</th>
                                        <td style="text-align:right"><strong>{$ERP_DOCUMENT->currency}
                                                {number_format($calcTotal ,2)}</strong></td>
                                    </tr>
                                {/if}

                            </table>
                            <br>
                            <br>

                            {assign var="exchangeRateInfo" value=MASForex_Record_Model::getLatestExchangeRateByCurrency($ERP_DOCUMENT->documentDate, $ERP_DOCUMENT->currency)}

                            {include file='BankDetails.tpl'|vtemplate_path:'Contacts' selected_bank=$SELECTED_BANK}
                        </td>
                    </tr>
                    <tr>
                        <td style='font-size: 8pt;font-weight: bold;position: absolute;bottom: 14px;'>
                            {include file='CompanyInfo.tpl'|vtemplate_path:'Contacts'}
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    {/for}
</body>

</html>