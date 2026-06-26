<!DOCTYPE html>
<html>

<head>
    <title>INVOICE</title>
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
                        href="index.php?module=Contacts&view=DocumentPrintPreview&record={$RECORD_MODEL->getId()}&docNo={$smarty.request.docNo}&tableName={$smarty.request.tableName}&docType={$smarty.request.docType}&PDFDownload=true&bank={$SELECTED_BANK->getId()}{if $INTENT}&fromIntent={$smarty.request.fromIntent}{/if}&hideSerials={$smarty.request.hideSerials}&hideCustomerInfo={$smarty.request.hideCustomerInfo}">Download</a>
                </li>
            {/if}
            <li id='printConf' style="float:right">
                <span style="float: right;margin-right: 1px;color: white;background-color: #bea364;text-decoration: none;
                display: block;
                text-align: center;
                padding: 14px;cursor: pointer;">Settings</span>
            </li>

            {assign var="transactionWarningExcludes" value=['description', 'grand_total', 'matched_amt']}
            {assign var="barItemWarningExcludes" value=[
                    "metal_code",
                    "metal_name",
                    "metal_type_code",
                    "warehouse",
                    "tx_amount",
                    "avg_spot_price",
                    "posting_date",
                    "exchange_rate",
                    "item_code",
                    "fine_oz",
                    "gross_oz",
                    "purity",
                    "item_price",
                    "premium_final",
                    "total_item_dc_amount",
                    "weight",
                    "remarks",
                    "other_charge",
                    "long_desc",
                    "narration",
                    "bar_number"
            ]}

            {include file='TCWarnings.tpl'|vtemplate_path:'Contacts'
                ERP_DOCUMENT=$ERP_DOCUMENT
                TRANSACTION_WARNING_EXCLUDES=$transactionWarningExcludes
                BARITEM_WARNING_EXCLUDES=$barItemWarningExcludes
            }

        </ul>
        
        <script type="text/javascript" src="layouts/v7/modules/Contacts/resources/PrintConf.js"></script>
        {include file='SALPrintConf.tpl'|vtemplate_path:'Contacts'}
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
                            {include file='CustomerAddressHeader.tpl'|vtemplate_path:'Contacts'}
                        </td>
                    </tr>

                    <tr>
                        <td style="height: 12mm; text-decoration: underline; text-align: center; font-size:12pt;">
                            <strong>YOUR PURCHASE</strong>
                        </td>
                    </tr>

                    {if isset($COMPANY) && !empty($COMPANY->get('company_gst_no'))}
                        <tr style="font-weight: bold;font-size: 9pt">
                            <td>GST Reg No.: {$COMPANY->get('company_gst_no')}</td>
                        </tr>
                    {/if}

                    {if isset($COMPANY) && !empty($COMPANY->get('vat_id'))}
                        <tr>
                            <td style="text-align: left;font-size: 10pt; font-weight: bold;">
                                VAT Nr: {$COMPANY->get('vat_id')}
                            </td>
                        </tr>
                    {/if}

                     <tr>
                        <td>
                            <table style="width:100%; border-collapse:collapse;">
                                <tr>
                                    <td style="font-size:9pt; text-align:right;">
                                        All amounts in {$ERP_DOCUMENT->currency}
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>

                    <tr>
                        <td style="font-size: 9pt; height: 168mm; vertical-align: top;">
                            <table class="activity-tbl" style="margin-bottom:5mm">
                                <tr>
                                    <th colspan="2" style="width:25%;text-align:center">INVOICE NO</th>
                                    <th style="width:25%;text-align:center">INVOICE DATE</th>
                                    <th style="width:25%;text-align:center">DELIVERY DATE</th>
                                    <th style="width:25%;text-align:center">ORDER</th>
                                </tr>
                                <tr>
                                    <td colspan="2" style="text-align:center">{$smarty.request.docNo}</td>
                                    <td style="text-align:center">{$ERP_DOCUMENT->documentDate}</td>
                                    <td style="text-align:center">{$ERP_DOCUMENT->postingDate}</td>
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
                                {assign var="serials" value=""}
                                {assign var="GST_ITEM" value=false}
                                {for $loopStart=$start to $end}

                                    {assign var="barItem" value=$ERP_DOCUMENT->barItems[$loopStart]}
                                    {assign var="start" value=($loopStart+1)}

                                    {if $barItem->quantity eq 1}
                                        {assign var="serialPart" value=explode('-',$barItem->serials[0])}
                                        {assign var="serials" value=$serials|cat:$serialPart[0]|cat:', '}
                                    {else}
                                        {assign var="serials" value=$serials|cat:$barItem->serials|cat:', '}
                                    {/if}
                                    {assign var="total" value=$barItem->totalItemAmount}
                                    {assign var="calcTotal" value=$calcTotal+round($total,2)}
                                    {assign var="SUB_TOTAL" value=$SUB_TOTAL+round($total,2)}
                                    {if $loopStart eq count($ERP_DOCUMENT->barItems)}
                                        {break}
                                    {/if}
                                    {if empty($barItem->quantity) and empty($barItem->longDesc)}
                                        {if strpos($barItem->narration,'GST') === 0 ||strpos($barItem->narration,'GST') > 0 }
                                            {assign var="GST_ITEM" value=$barItem}
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
                                                {$barItem->itemDescription} <br><span
                                                    style="font-size: smaller;font-style: italic;max-width: 250px;display: inline-block;word-break: break-all;white-space: normal;">
                                                    <pre>{$barItem->serialNumbers}</pre>
                                                </span>
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
                                    {if $GST_ITEM}
                                        <tr>
                                            <td style="width:75%;" colspan="4">SUBTOTAL:</td>
                                            <td style="text-align:right"><strong>{$ERP_DOCUMENT->currency}
                                                    {number_format($SUB_TOTAL,2)}</strong></td>
                                        </tr>
                                        <tr>
                                            <td style="width:75%;" colspan="4">GST on Storage charge in Singapore (7%)</td>
                                            <td style="text-align:right"><strong>{$ERP_DOCUMENT->currency}
                                                    {number_format($GST_ITEM->otherCharge,2)}</strong></td>
                                        </tr>
                                    {/if}
                                    {if isset($COMPANY) && !empty($COMPANY->get('company_gst_no')) && empty($GST_ITEM)}
                                        <tr>
                                            <td style="width:75%;" colspan="4">SUBTOTAL:</td>
                                            <td style="text-align:right"><strong>{$ERP_DOCUMENT->currency}
                                                    {number_format($SUB_TOTAL,2)}</strong></td>
                                        </tr>
                                        <tr>
                                            <td style="width:75%;" colspan="4">GST on Storage charge (0%)</td>
                                            <td style="text-align:right"><strong>
                                                    {$ERP_DOCUMENT->currency}
                                                    {number_format(0,2)}</strong></td>
                                        </tr>
                                    {/if}
                                    <tr>
                                        <th style="width:75%;" colspan="4">TOTAL INVOICE AMOUNT:</th>
                                        <td style="text-align:right"><strong>{$ERP_DOCUMENT->currency}
                                                {number_format($calcTotal ,2)}</strong></td>
                                    </tr>
                                    {if $INTENT}
                                        <tr>
                                            <th style="width:75%;" colspan="4">TOTAL INVOICE AMOUNT IN
                                                {$INTENT->get('package_currency')}: {if $INTENT->get('package_currency') eq 'EUR'}
                                                (EUR/USD{else}(USD/{$INTENT->get('package_currency')}
                                                {/if} RATE
                                                {$INTENT->get('fx_spot_price')})</th>
                                            <td style="text-align:right"><strong>{$INTENT->get('package_currency')}
                                                    {number_format($INTENT->get('total_foreign_amount'),2)}</strong></td>
                                        </tr>
                                    {/if}
                                {/if}

                            </table>
                            <br>
                            <br>
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