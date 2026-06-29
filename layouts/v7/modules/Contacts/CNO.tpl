<!DOCTYPE html>
<html>

<head>
    <title>CREDIT NOTE {$smarty.request.docNo}</title>
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

            {if isset($SELECTED_BANK) && $SELECTED_BANK && method_exists($SELECTED_BANK, 'getId')}
                <li style="float:right">
                    <a style="display: block;color: white;text-align: center;padding: 14px 16px;text-decoration: none;background-color: #bea364;"
                        href="index.php?module=Contacts&view=NotePrintPreview&record={$RECORD_MODEL->getId()}&docNo={$smarty.request.docNo}&tableName={$smarty.request.tableName}&PDFDownload=true&bank={$SELECTED_BANK->getId()}&hideCustomerInfo={$smarty.request.hideCustomerInfo}">Download</a>
                </li>

                {assign var="transactionWarningExcludes" value=["description", "posting_date", "grand_total", "matched_amt"]}
                {assign var="barItemWarningExcludes" value=[
                    "quantity",
                    "metal_code",
                    "metal_name",
                    "metal_type",
                    "metal_type_code",
                    "warehouse",
                    "tx_amount",
                    "spot_price",
                    "avg_spot_price",
                    "posting_date",
                    "item_code",
                    "item_description",
                    "fine_oz",
                    "total_fine_oz",
                    "gross_oz",
                    "purity",
                    "item_price",
                    "unit_price",
                    "premium_perc",
                    "premium_final",
                    "total_item_amount",
                    "total_item_dc_amount",
                    "serial_numbers",
                    "weight",
                    "bar_number",
                    "remarks",
                    "other_charge",
                    "long_desc",
                    "narration"
                ]}

                {include file='TCWarnings.tpl'|vtemplate_path:'Contacts'
                                ERP_DOCUMENT=$ERP_DOCUMENT
                                TRANSACTION_WARNING_EXCLUDES=$transactionWarningExcludes
                                BARITEM_WARNING_EXCLUDES=$barItemWarningExcludes
                            }
            {/if}
        </ul>
    {/if}
    <div class="printAreaContainer">
        <div class="full-width">
            <table class="print-tbl">
                <tr>
                    <td style="height: 28mm;">
                        <img src='layouts/v7/modules/Contacts/resources/gpm-new-logo.png'
                            style="max-height: 100%; float:right;width: 154px;">
                        <div style="font-size:11pt;margin-top: 14px;margin-bottom: 32px">
                            {include file='CustomerPrintInfo.tpl'|vtemplate_path:'Contacts'}
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="height: 10mm; text-decoration: underline;text-align: center">
                        <strong>CREDIT NOTE</strong>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 9pt;vertical-align: top;">
                        <table class="activity-tbl" style="margin-bottom:2mm;width:40%;margin-top:2mm;">
                            <tr>
                                <th style="text-align:center;width:50%">CREDIT NOTE NO</th>
                                <th style="text-align:center;width:50%">DATE</th>
                            </tr>
                            <tr>
                                <td style="text-align:center">{$smarty.request.docNo}</td>
                                <td style="text-align:center">{$ERP_DOCUMENT->documentDate}</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;font-size: 9pt">
                        All amounts in {$ERP_DOCUMENT->currency}
                    </td>
                </tr>
                <tr>
                    <td style="width:25%;font-size: 9pt; height: 138mm; vertical-align: top;">
                        {assign var="description" value=$ERP_DOCUMENT->barItems[0]->description|default:""}
                        {assign var="total" value=$ERP_DOCUMENT->barItems[0]->creditNoteAmount|default:0.00}
                        <table class="activity-tbl">
                            <tr>
                                <th style="width:70%;">DESCRIPTION</th>
                                <th style="width:30%;text-align:center">TOTAL {$ERP_DOCUMENT->currency}</th>
                            </tr>
                            <tr>
                                <td style="border-bottom:none;vertical-align: top;height: 30mm">
                                    {$description}
                                </td>
                                <td style="text-align:right;vertical-align: top">
                                    {CurrencyField::convertToUserFormat($total)}</td>
                            </tr>
                            <tr>
                                <th>TOTAL CREDIT AMOUNT:</th>
                                <td style="text-align:right"><strong>{$ERP_DOCUMENT->currency}
                                        {number_format($total, 2, '.', ',')}</strong>
                                </td>
                            </tr>
                        </table>
                        <br>
                        <br>
                        <br>
                        <br>
                        <br>
                        <br>
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
</body>

</html>