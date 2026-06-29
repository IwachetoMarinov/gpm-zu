<!DOCTYPE html>
<html>

<head>
    <title>STORAGE INVOICE</title>
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
                        href="index.php?module=Contacts&view=STIPrintPreview&record={$RECORD_MODEL->getId()}&docNo={$smarty.request.docNo}&tableName={$smarty.request.tableName}&PDFDownload=true&bank={$SELECTED_BANK->getId()}&hideCustomerInfo={$smarty.request.hideCustomerInfo}&europeanAddress={$smarty.request.europeanAddress|default:0}">Download</a>
                </li>
            {/if}

            <li id='printConf' style="float:right">
                <span style="float: right;margin-right: 1px;color: white;background-color: #bea364;text-decoration: none;
                display: block;
                text-align: center;
                padding: 14px;cursor: pointer;">Settings</span>
            </li>

            {assign var="transactionWarningExcludes" value=["voucher_type", "posting_date", "grand_total", "matched_amt"]}
            {assign var="barItemWarningExcludes" value=[
                "transaction_type",
                "quantity",
                "metal_name",
                "warehouse",
                "tx_amount",
                "spot_price",
                "posting_date",
                "exchange_rate",
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
                "total_item_dc_amount",
                "serial_numbers",
                "weight",
                "bar_number",
                "other_charge",
                "narration",
                "long_desc",
                "metal_code",
                "remarks",
                "avg_spot_price",
                "currency"
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

    <div class="printAreaContainer">
        {assign var="metal" value=$ERP_DOCUMENT->barItems[0]->metal}

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
                        <strong>{if !empty($COMPANY->get('company_gst_no'))}TAX INVOICE
                            {else}STORAGE
                            INVOICE{/if}</strong>
                    </td>
                </tr>
                {if !empty($COMPANY->get('company_gst_no'))}
                    <tr style="font-weight: bold;font-size: 9pt">
                        <td>GST Reg No.: {$COMPANY->get('company_gst_no')}</td>
                    </tr>
                {/if}
                <tr>

                    {if isset($COMPANY) && !empty($COMPANY->get('vat_id'))}
                    <tr>
                        <td style="text-align: left;font-size: 10pt; font-weight: bold;">
                            VAT Nr: {$COMPANY->get('vat_id')}
                        </td>
                    </tr>
                {/if}

                <td style="text-align: right;font-size: 9pt">
                    All amounts in {$ERP_DOCUMENT->currency}
                </td>
                </tr>

                <tr>
                    <td style="font-size: 9pt; height: 168mm; vertical-align: top;">
                        <table class="activity-tbl" style="margin-bottom:5mm">
                            <tr>
                                <th colspan="2" style="width:25%;text-align: center;">INVOICE NO</th>
                                <th style="width:25%;text-align: center;">DATE</th>
                                <th colspan="2" style="width:50%;text-align: center;">AVERAGE LONDON FIX</th>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align: center;">{$ERP_DOCUMENT->docNo}</td>
                                <td style="text-align: center;">{$ERP_DOCUMENT->documentDate}</td>
                                <td style="width:25%;text-align: center;">{$metal}</td>
                                <td style="width:25%;text-align: center;">{$ERP_DOCUMENT->currency}
                                    {number_format($AVERAGE_SPOT_PRICE,2)} / OZ.</td>
                            </tr>
                        </table>
                        {assign var="totalStorageFee" value=0}
                        <table class="activity-tbl">
                            <tr>
                                <th style="width:75%;">DESCRIPTION</th>
                                <th style="width:25%;text-align: center">TOTAL {$ERP_DOCUMENT->currency}</th>
                            </tr>
                            <tr>
                                <td style="height:50mm;border-bottom:none;vertical-align: top;line-height: 2">
                                    {$ERP_DOCUMENT->description}
                                    {* Map locations *}
                                    {foreach from=$ERP_DOCUMENT->barItems item=charge}
                                        {if isset($charge->description) && !empty($charge->description)}
                                            <div style="margin-left: 10px;">- {$charge->description}</div>
                                        {/if}
                                    {/foreach}
                                </td>
                                <td style="text-align:right;vertical-align: top;line-height: 2">
                                    <br>
                                    {foreach from=$ERP_DOCUMENT->barItems item=charge}
                                        {assign var="totalStorageFee" value=$totalStorageFee+$charge->totalItemAmount}
                                        {number_format($charge->totalItemAmount,2)}<br>
                                    {/foreach}
                                </td>
                            </tr>

                            {if !empty($COMPANY->get('company_gst_no'))}
                                <tr>
                                    <td style="width:75%;">SUBTOTAL:</td>
                                    <td style="text-align:right"><strong>{$ERP_DOCUMENT->currency}
                                            {$ERP_DOCUMENT->grandTotal}</strong></td>
                                </tr>
                                <tr>
                                    <td style="width:75%;">GST on Storage charge (0%)</td>
                                    <td style="text-align:right"><strong>{$ERP_DOCUMENT->currency}
                                            {number_format(0,2)}</strong></td>
                                </tr>
                            {/if}
                            <tr>
                                <th style="width:75%;">TOTAL STORAGE FEE:</th>
                                <td style="text-align:right"><strong>{$ERP_DOCUMENT->currency}
                                        {number_format($totalStorageFee,2)}</strong></td>
                            </tr>
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
</body>

</html>