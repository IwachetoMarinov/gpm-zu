<!DOCTYPE html>
<html>

<head>
    <title>INVOICE</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        @font-face {
            font-family: 'Open Sans';
            font-style: normal;
            font-weight: 400;
            src: url('layouts/v7/resources/fonts/OpenSans-Regular.woff') format('woff');
        }

        @font-face {
            font-family: 'Open Sans';
            font-style: normal;
            font-weight: 700;
            src: url('layouts/v7/resources/fonts/OpenSans-Bold.woff') format('woff');
        }

        * {
            box-sizing: border-box;
            margin: 0px;
        }

        .printAreaContainer {
            height: 297mm;
            width: 210mm;
            border: 1px solid #fff;
            margin: auto;
            padding: 15mm 15mm;
            position: relative;
        }

        .printAreaContainer * {
            box-sizing: border-box;
            font-family: 'Open Sans';
            color: #666;

        }

        .printAreaContainer .full-width {
            width: 100%;
        }

        .printAreaContainer .header-logo {
            width: 50%;
            height: 11mm;
        }

        .printAreaContainer .header-text {
            width: 50%;
            height: 11mm;
            color: #fff;
            background: #008ECA;
            font-weight: bold;
            font-size: 10pt;
        }

        .printAreaContainer .header-text span {
            font-weight: normal;
            color: #fff;
        }

        .printAreaContainer .print-tbl {
            border-collapse: collapse;
            width: 100%;
            border: none;
        }

        .print-txt-center {
            text-align: center;
        }

        .print-txt-left {
            text-align: left;
        }

        .print-txt-right {
            text-align: right;
        }

        .print-footer {
            height: 20mm;
            background: #008ECA;
        }

        .big-label {
            color: #cd3330;
            font-weight: bold;
            font-size: 20pt;
        }

        table.content-table th {
            border: 1px dotted #666666;
            font-size: 10pt;
            background: #ECECEC;
            font-weight: bold;
            padding: 4px
        }

        table.content-table tr.footer th {
            color: #008ECA;
        }

        table.content-table td {
            border: none;
            font-size: 10pt;
            font-weight: normal;
            padding: 4px
        }

        table.graph-table td {
            width: 50%;
            font-size: 10pt;
            padding: 4px 0px;
        }

        .graph-bar {
            height: 1.5mm
        }

        .graph-bar.blue {
            background: #008ECA;
        }

        .graph-bar.green {
            background: #BACE10;
        }

        .doted-bg {
            background: url(graph_bg.jpg);
            background-size: 338px auto;
        }

        table.activity-tbl {
            border-collapse: collapse;
            width: 100%;
            border: 1px solid #333;
        }

        table.activity-tbl td,
        table.activity-tbl th {
            border: 1px solid #000;
            padding: 1mm 2mm;
            text-align: left;
        }

        table.activity-tbl th {
            background: #bca263;
        }

        .logo-bg-bottom {
            background: url(layouts/v7/modules/Contacts/resources/Gold_Logo_Higher_Res.png) no-repeat;
            background-size: 244mm;
            height: 70mm;
            width: 82mm;
            position: absolute;
            bottom: 0px;
            right: 0px;
            opacity: .4;
        }
    </style>
</head>

<body>
    {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
        <ul style="list-style-type: none;
                margin: 0;
                padding: 0;
                overflow: hidden;
                background-color: #333;">
            <li style="float:right"><a style="display: block;
                color: white;
                text-align: center;
                padding: 14px 16px;
                text-decoration: none;
                background-color: #bea364;"
                    href="index.php?module=Contacts&view=DocumentPrintPreview&record={$RECORD_MODEL->getId()}&docNo={$smarty.request.docNo}&tableName={$smarty.request.tableName}&docType={$smarty.request.docType}&PDFDownload=true{if $INTENT}&fromIntent={$smarty.request.fromIntent}{/if}&hideCustomerInfo={$smarty.request.hideCustomerInfo}">Download</a>
            </li>

            {assign var="transactionWarningExcludes" value=['description', 'grand_total']}
            {assign var="barItemWarningExcludes" value=[
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
                            "bar_number",
                            "field"
                        ]}

            {include file='TCWarnings.tpl'|vtemplate_path:'Contacts'
                            ERP_DOCUMENT=$ERP_DOCUMENT
                            TRANSACTION_WARNING_EXCLUDES=$transactionWarningExcludes
                            BARITEM_WARNING_EXCLUDES=$barItemWarningExcludes
                        }
        </ul>
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

                <tr >
                <td style="height: 12mm; text-decoration: underline; text-align: center; font-size:12pt;">
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
                                <td style="text-align: center;">{$ERP_DOCUMENT->deliveryDate}</td>
                                <td style="text-align: center;">Sale</td>
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

                            {assign var="balanceAmount" value=($balanceAmount)+($TRANSACTION->usdVal)}
                            {assign var="serials" value=""}

                            {foreach item=barItem from=$ERP_DOCUMENT->barItems}
                                {if $barItem->quantity eq 1}
                                    {assign var="serialPart" value=explode('-',$barItem->serials[0])}
                                    {assign var="serials" value=$serials|cat:$serialPart[0]|cat:', '}
                                {else}
                                    {assign var="serials" value=$serials|cat:$barItem->serials|cat:', '}
                                {/if}

                                {assign var="total" value=((($barItem->price)*($barItem->pureOz))+$barItem->otherCharge)}
                                <tr>
                                    <td style="vertical-align: top">{$barItem->quantity}</td>
                                    <td style="border-bottom:none;vertical-align: top">
                                        {$barItem->longDesc} <br><span
                                            style="font-size: smaller;font-style: italic;max-width: 250px;display: inline-block;word-break: break-all;white-space: normal;">
                                            <pre>{$barItem->serialNumbers}</pre>
                                        </span>
                                    </td>
                                    {if $barItem->metal eq 'mBTC'}
                                        <td style="text-align:right;vertical-align: top">
                                            {CurrencyField::convertToUserFormat({$barItem->price})}</td>
                                    {else}
                                        <td style="text-align:right;vertical-align: top">
                                            {CurrencyField::convertToUserFormat($total/$barItem->quantity)}</td>
                                    {/if}
                                    <td style="text-align:right;vertical-align: top">{number_format($barItem->pureOz,4)}
                                    </td>
                                    <td style="text-align:right;vertical-align: top">
                                        {CurrencyField::convertToUserFormat($total)}</td>
                                </tr>
                            {/foreach}
                            <tr>
                                <th style="width:75%;" colspan="4">TOTAL INVOICE AMOUNT:</th>
                                <td style="text-align:right"><strong>{$ERP_DOCUMENT->currency}
                                        {CurrencyField::convertToUserFormat($ERP_DOCUMENT->totalusdVal)}</strong>
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
                        </table>

                        <br>

                        <div style="font-size:9pt;">
                            <strong>PAYMENT MADE BY:</strong><br>

                            {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
                                <select id="paymentMethod" style="margin-top: 1mm;">
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
                    <td style='font-size: 8pt;font-weight: bold;position: absolute;bottom: 14px;'>
                        {include file='CompanyInfo.tpl'|vtemplate_path:'Contacts'}
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var downloadBtn = document.getElementById('downloadPdfBtn');
            var paymentSelect = document.getElementById('paymentMethod');

            if (!downloadBtn || !paymentSelect) {
                return;
            }

            downloadBtn.addEventListener('click', function() {
                var url = new URL(downloadBtn.href, window.location.origin);
                var paymentMethod = paymentSelect.value;

                if (paymentMethod) {
                    url.searchParams.set('paymentMethod', paymentMethod);
                } else {
                    url.searchParams.delete('paymentMethod');
                }

                downloadBtn.href = url.toString();
            });
        });
    </script>

</body>

</html>