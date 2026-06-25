<!DOCTYPE html>
<html>

<head>
    <title>PROFORMA INVOICE</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    {include file="partials/printCSS.tpl"|vtemplate_path:GPMIntent}
</head>

<body>
    {if $ENABLE_DOWNLOAD_BUTTON}
        {include file="partials/PiDownload.tpl"|vtemplate_path:GPMIntent}
    {/if}

    <div class="printAreaContainer">
        <div class="full-width">
            <table class="print-tbl">

                <!-- Customer header -->
                <tr>
                    <td style="height: 28mm;">
                        <img src='layouts/v7/modules/Contacts/resources/gpm-new-logo.png'
                            style="max-height:100%;float:right;width:154px;">
                        {if isset($RECORD_MODEL)}
                            <div style="font-size:11pt;margin-top:14px;margin-bottom:32px">
                                {include file='CustomerPrintInfo.tpl'|vtemplate_path:'Contacts'}
                            </div>
                        {/if}
                    </td>
                </tr>

                <!-- Invoice header -->
                <tr>
                    <td style="height:10mm;text-decoration:underline;text-align:center"><strong>
                            PROFORMA INVOICE
                        </strong></td>
                </tr>

                {if isset($COMPANY) && $COMPANY->get('company_gst_no')}
                    <tr style="font-weight:bold;font-size:9pt">
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

                <!-- Invoice meta -->
                <tr>
                    <td style="text-align:right;font-size:9pt">
                        <table class="activity-tbl" style="margin-bottom:5mm;margin-top:5mm">
                            <tr>
                                <th style="text-align: center;">INVOICE NO</th>
                                <th style="text-align: center;">INVOICE DATE</th>
                                <th style="text-align: center;">DELIVERY DATE</th>
                                <th style="text-align: center;">ORDER</th>
                            </tr>
                            <tr>
                                <td style="text-align:center">PI/{date('Y')}/{$INTENT->get('intent_no')}</td>
                                <td style="text-align:center">{date('Y-m-d',strtotime($INTENT->get('modifiedtime')))}
                                </td>
                                <td style="text-align:center">{date('Y-m-d',strtotime($INTENT->get('modifiedtime')))}
                                </td>
                                <td style="text-align:center">{$INTENT->get('gpm_order_type')}</td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <tr>
                    <td style="text-align:right;font-size:9pt">All amounts in {$INTENT_CURRENCY}</td>
                </tr>

                <!-- Product table -->
                <tr>
                    <td style="font-size:9pt;height:168mm;vertical-align:top;">
                        <table class="activity-tbl" style="margin-bottom:5mm">
                            <tr>
                                <th>QTY</th>
                                <th>DESCRIPTION</th>
                                <th>{$INTENT_CURRENCY} / UNIT</th>
                                <th>FINE OZ.</th>
                                <th>TOTAL {$INTENT_CURRENCY}</th>
                            </tr>

                            {foreach item=PRODUCT key=cnt from=$RELATED_PRODUCTS}
                                {assign var=METAL value=Vtiger_Record_Model::getInstanceById($PRODUCT->get('gpmmetalid'), 'Assets')}
                                <tr class="no-border">
                                    <td>{if $METAL->get('assetname') ne 'Storage Charges'}{number_format($PRODUCT->get('qty'),0)}{/if}
                                    </td>
                                    <td>{$METAL->get('assetname')}</td>
                                    <td style="text-align:center">
                                        {if $METAL->get('assetname') ne 'Storage Charges'}
                                            {number_format($PRODUCT->get('value_usd')/$PRODUCT->get('qty'),2)}
                                        {/if}
                                    </td>
                                    {if $METAL->get('gpm_metal_type') eq 'CRYPTO'}
                                        <td style="text-align:center">{number_format($PRODUCT->get('qty'),0)}</td>
                                    {else}
                                        <td style="text-align:center">
                                            {if $METAL->get('assetname') ne 'Storage Charges'}
                                                {number_format($PRODUCT->get('fine_oz'),3)}
                                            {/if}
                                        </td>
                                    {/if}
                                    <td style="text-align:right">{number_format($PRODUCT->get('value_usd'),2)}</td>
                                </tr>
                            {/foreach}

                            <tr>
                                <th colspan="4">TOTAL INVOICE AMOUNT</th>
                                <td style="text-align:right"><strong>{$INTENT_CURRENCY}
                                        {number_format($INTENT->get('total_amount'),2)}</strong></td>
                            </tr>
                        </table>

                        <!-- Bank info -->
                        {include file='BankDetails.tpl'|vtemplate_path:'Contacts' selected_bank=$SELECTED_BANK}

                    </td>
                </tr>

                <!-- Footer -->
                <tr>
                    <td style="font-size:8pt;font-weight:bold;position:absolute;bottom:14px;">
                        {include file='CompanyInfo.tpl'|vtemplate_path:'Contacts'}
                    </td>
                </tr>

            </table>
        </div>
    </div>
</body>

</html>