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
    {assign var=FROM_INTENT value=""}
    {if isset($smarty.request.fromIntent) && $smarty.request.fromIntent neq ""}
        {assign var=FROM_INTENT value="&fromIntent=`$smarty.request.fromIntent`"}
    {/if}

    {assign var=HCI value=""}
    {if $smarty.request.hideCustomerInfo eq '1' || $smarty.request.hideCustomerInfo eq 1}
        {assign var=HCI value="&hideCustomerInfo=1"}
    {/if}

    {assign var=HS value=""}
    {if $smarty.request.hideSerials eq '1' || $smarty.request.hideSerials eq 1}
        {assign var=HS value="&hideSerials=1"}
    {/if}

    {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
        <script type="text/javascript" src="layouts/v7/lib/jquery/jquery.min.js"></script>

        <ul style="list-style-type:none;margin:0;padding:0;overflow:hidden;background-color:#333;">
            <li style="float:right">
                <a id="downloadPdfBtn"
                    style="display:block;color:white;text-align:center;padding:14px 16px;text-decoration:none;background-color:#bea364;"
                    href="index.php?module=Contacts&view=DocumentPrintPreview&record={$RECORD_MODEL->getId()}&docNo={$smarty.request.docNo}&tableName={$smarty.request.tableName}&docType={$smarty.request.docType}&PDFDownload=true
                {$FROM_INTENT}
                {$HS}
                {$HCI}">
                    Download
                </a>
            </li>

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
                "item_code",
                "fine_oz",
                "gross_oz",
                "purity",
                "total_item_dc_amount",
                "weight",
                "remarks",
                "other_charge",
                "narration",
                "long_desc",
                "bar_number"                                                           
            ]}

            {include file='TCWarnings.tpl'|vtemplate_path:'Contacts'
                ERP_DOCUMENT=$ERP_DOCUMENT
                TRANSACTION_WARNING_EXCLUDES=$transactionWarningExcludes
                BARITEM_WARNING_EXCLUDES=$barItemWarningExcludes
            }                                            
        </ul>

        <script type="text/javascript" src="layouts/v7/modules/Contacts/resources/PrintConf.js"></script>
        {include file='PURTCPrintConf.tpl'|vtemplate_path:'Contacts'}
    {/if}

    {assign var="start" value=0}
    {assign var="end" value=1}
    {assign var="calcTotal" value=0}
    {for $page=1 to $PAGES}
        {if $page eq 1}
            {assign var="end" value=14}
        {else}
            {assign var="end" value=($end+14)}
        {/if}
        <div class="printAreaContainer">
            <div class="full-width">
                <table class="print-tbl">
                    <tr>
                        <td style="height: 28mm;">
                            <img src='layouts/v7/modules/Contacts/resources/gpm-new-logo.png'
                                style="max-height: 100%; float:right;width: 154px;">
                            {include file='CustomerAddressHeader.tpl'|vtemplate_path:'Contacts' invoice_title_style='margin-top: 4mm; margin-bottom: 2mm;'}
                        </td>
                    </tr>

                    <tr>
                        <td style="height: 12mm; text-decoration: underline;text-align: center; font-size:12pt;">
                            <strong>YOUR SALE</strong>
                        </td>
                    </tr>

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
                            {assign var="transactionType" value=$ERP_DOCUMENT->barItems[0]->transactionType|default:""}
                            <table class="activity-tbl" style="margin-bottom:5mm">
                                <tr>
                                    <th colspan="2" style="width:25%;text-align: center;">INVOICE NO</th>
                                    <th style="width:25%;text-align: center;">INVOICE DATE</th>
                                    <th style="width:25%;text-align: center;">DELIVERY DATE</th>
                                    <th style="width:25%;text-align:center">ORDER</th>
                                </tr>
                                <tr>
                                    <td colspan="2" style="text-align: center;">{$smarty.request.docNo}</td>
                                    <td style="text-align: center;">{$ERP_DOCUMENT->documentDate}</td>
                                    <td style="text-align: center;">{$ERP_DOCUMENT->postingDate}</td>
                                    <td style="text-align: center;">{$transactionType}</td>
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
                                {assign var="balanceAmount" value=($ERP_DOCUMENT->grandTotal)+($ERP_DOCUMENT->totalusd_val)}
                                {assign var="serials" value=""}

                                {for $loopStart=$start to $end}
                                    {assign var="barItem" value=$ERP_DOCUMENT->barItems[$loopStart]}
                                    {assign var="start" value=($loopStart+1)}

                                    {if $barItem->quantity eq 1}
                                        {assign var="serialPart" value=explode('-',$barItem->serials[0])}
                                        {assign var="serials" value=$serials|cat:$serialPart[0]|cat:', '}
                                    {else}
                                        {assign var="serials" value=$serials|cat:$barItem->serials|cat:', '}
                                    {/if}

                                    {assign var="total" value=((($barItem->price)*($barItem->pureOz))+$barItem->otherCharge)}
                                    {assign var="calcTotal" value=($calcTotal)+($barItem->totalItemAmount)}

                                    {if $loopStart eq count($ERP_DOCUMENT->barItems)}
                                        {break}
                                    {/if}
                                    <tr>
                                        <td style="vertical-align: top">{$barItem->quantity}</td>
                                        <td style="border-bottom:none;vertical-align: top">
                                            {$barItem->description} <br><span
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
                                {/for}
                                {if $PAGES eq $page}
                                    <tr>
                                        <th style="width:75%;" colspan="4">TOTAL INVOICE AMOUNT:</th>
                                        <td style="text-align:right"><strong>{$ERP_DOCUMENT->currency}
                                                {CurrencyField::convertToUserFormat($calcTotal)}</strong>
                                        </td>
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

                            <div style="font-size:9pt;">
                                <strong>PAYMENT MADE BY:</strong><br>

                                {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
                                    <select id="paymentMethod"  style="margin-top: 1mm;">
                                        <option value="">-- Select --</option>
                                        <option value="Cash">Cash</option>
                                        <option value="BankTransfer">Bank Transfer</option>
                                    </select>
                                {else}
                                    {if $smarty.request.paymentMethod eq 'Cash'}
                                        Cash
                                    {elseif $smarty.request.paymentMethod eq 'BankTransfer'}
                                        Bank Transfer
                                    {/if}
                                {/if}
                            </div>

                        </td>
                    </tr>

                    <tr>
                        <td style='font-size: 8pt;font-weight: bold;position: absolute;bottom: 14px;width: 85%'>
                            {include file='CompanyPrintFooter.tpl'|vtemplate_path:'Contacts'}
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    {/for}

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var downloadBtn = document.getElementById('downloadPdfBtn');
            var paymentSelect = document.getElementById('paymentMethod');

            if (!downloadBtn || !paymentSelect) return;

            downloadBtn.addEventListener('click', function() {
                var url = new URL(downloadBtn.href, window.location.origin);
                var paymentMethod = paymentSelect.value;
                var hideSerialsEl = document.getElementById('hideSerials');
                var hideCustomerInfoEl = document.getElementById('hideCustomerInfo');

                if (paymentMethod) {
                    url.searchParams.set('paymentMethod', paymentMethod);
                } else {
                    url.searchParams.delete('paymentMethod');
                }

                if (hideSerialsEl && hideSerialsEl.checked) {
                    url.searchParams.set('hideSerials', '1');
                } else {
                    url.searchParams.delete('hideSerials');
                }

                if (hideCustomerInfoEl && hideCustomerInfoEl.checked) {
                    url.searchParams.set('hideCustomerInfo', '1');
                } else {
                    url.searchParams.delete('hideCustomerInfo');
                }

                downloadBtn.href = url.toString();
            });
        });
    </script>

</body>

</html>