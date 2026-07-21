<!DOCTYPE html>
<html>

<head>
    <title>GPM QUOTE</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    {include file="partials/printCSS.tpl"|vtemplate_path:GPMIntent}
</head>

<body>
    {if $ENABLE_DOWNLOAD_BUTTON}
        <script type="text/javascript" src="layouts/v7/lib/jquery/jquery.min.js"></script>
        <link type='text/css' rel='stylesheet' href='layouts/v7/lib/jquery/select2/select2.css'>
        <link type='text/css' rel='stylesheet' href='layouts/v7/lib/select2-bootstrap/select2-bootstrap.css'>
        <script type="text/javascript" src="layouts/v7/lib/jquery/select2/select2.min.js"></script>
        <ul style="list-style-type: none;
                margin: 0;
                padding: 0;
                overflow: hidden;
                background-color: #333;">
            <li style="float:right">
                <a style="display: block;
                        color: white;
                        text-align: center;
                        padding: 14px 16px;
                        text-decoration: none;
                        background-color: #bea364;"
                    href="{$DOWNLOAD_LINK}&europeanAddress={$smarty.request.europeanAddress|default:0}">Download</a>
            </li>

            <li id="printConf" style="float:right">
                <span style="float: right;margin-right: 1px;color: white;background-color: #bea364;text-decoration: none;
                display: block;
                text-align: center;
                padding: 14px;cursor: pointer;">Settings</span>
            </li>
            
            <li style="float: right;margin-top: 5px;margin-right: 5px;width: 198px;">
                <select class="inputElement select2" name="view_type" id="view_type">
                    <option {if $smarty.request.type eq 'full'} selected {/if} value="full">Full</option>
                    <option {if $smarty.request.type eq 'simple'} selected {/if} value="simple">Simple</option>
                </select>
            </li>

            {assign var="PRINT_CONF_QUERY" value="&type=`$smarty.request.type|default:'full'`"}
            {include file='EuropeanAddressPrintConf.tpl'|vtemplate_path:'Contacts'
                PRINT_CONF_VIEW='ViewQuotation'
                PRINT_CONF_MODULE='GPMIntent'
                PRINT_CONF_RECORD=$INTENT->getId()}
        </ul>
        {literal}
            <style>
                .select2-container .select2-choice>.select2-chosen {
                    width: 171px;
                }
            </style>
            <script>
                $(document).ready(function() {
                    $('.select2').select2();
                });
                jQuery("body").on('change', '#view_type', function(e) {
                    var element = jQuery(e.currentTarget);
                    var viewType = element.val();
                    window.location.replace(window.location.href.split('&type=')[0] + '&type=' + viewType);
                });
            </script>
        {/literal}
    {/if}
    <div class="printAreaContainer">
        <div class="full-width">
            <table class="print-tbl">
                <tr>
                    <td style="height: 28mm;">
                        <img src='layouts/v7/modules/Contacts/resources/gpm-new-logo.png'
                            style="max-height: 100%; float:right;width: 154px;">
                        <div style="font-size:11pt;margin-top: 14px;margin-bottom: 32px">
                            {assign var="CLIENT_ERP_NO" value=$INTENT->get('contact_erp_no')}
                            {include file='CustomerPrintInfo.tpl'|vtemplate_path:'Contacts'}
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="height: 10mm; text-decoration: underline;text-align: center">
                        <strong>QUOTATION</strong>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;font-size: 9pt">
                        <table class="activity-tbl" style="margin-bottom:5mm;margin-top:5mm">
                            <tr>
                                <th style="width:25%;text-align:center">DATE</th>
                                <th style="width:25%;text-align:center">ORDER</th>
                                <th style="width:25%;text-align:center">LOCATION</th>
                            </tr>
                            <tr>
                                <td style="text-align:center">{date('Y-m-d',strtotime($INTENT->get('modifiedtime')))}
                                </td>
                                <td style="text-align:center">{$INTENT->get('gpm_order_type')}</td>
                                <td style="text-align:center">{$INTENT->get('gpm_order_location')}</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;font-size: 9pt">
                        All amounts in {if isset($INTENT_CURRENCY)}{$INTENT_CURRENCY}{else}currency{/if}
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 9pt; height: 168mm; vertical-align: top;">
                        <table class="activity-tbl" style="margin-bottom:5mm">
                            <tr>
                                <th style="width:10%;">QTY</th>
                                <th style="width:40%;">DESCRIPTION</th>
                                <th style="width:12%;"> {$INTENT_CURRENCY} / UNIT</th>
                                <th style="width:8%;text-align:center">FINE OZ.</th>
                                <th style="width:20%;text-align:center">TOTAL</th>
                            </tr>
                            {foreach item=PRODUCT key=cnt from=$RELATED_PRODUCTS}
                                {assign var=METAL value=Vtiger_Record_Model::getInstanceById($PRODUCT->get('gpmmetalid'), 'Assets')}
                                <tr class="no-border">
                                    <td style="vertical-align: top;">
                                        {if $METAL->get('assetname') != 'Storage Charges'}{number_format($PRODUCT->get('qty'),0)}{/if}
                                    </td>
                                    <td style='vertical-align: top;'>
                                        {$METAL->get('assetname')}
                                    </td>
                                    <td style='vertical-align: top;text-align:center'>
                                        {if $METAL->get('assetname') != 'Storage Charges'}
                                            {number_format($PRODUCT->get('value_usd')/$PRODUCT->get('qty'),2)}
                                        {/if}
                                    </td>
                                    {if $METAL->get('gpm_metal_type') eq 'CRYPTO'}
                                        <td style='vertical-align: top;text-align:center'>
                                            {number_format($PRODUCT->get('qty'),0)}
                                        </td>
                                    {else}
                                        <td style='vertical-align: top;text-align:center'>
                                            {if $METAL->get('assetname') != 'Storage Charges'}{number_format($PRODUCT->get('fine_oz'),4)}{/if}
                                        </td>
                                    {/if}
                                    {if count($RELATED_PRODUCTS) lt 5 && $cnt eq count($RELATED_PRODUCTS)-1}
                                        <td style='height:50mm;vertical-align: top;text-align:right'>
                                            {number_format($PRODUCT->get('value_usd'),2)}

                                        {else}
                                        <td style='vertical-align: top;text-align:right'>
                                            {number_format($PRODUCT->get('value_usd'),2)}

                                        {/if}
                                    </td>
                                </tr>

                            {/foreach}

                            <tr>
                                <th colspan="4">TOTAL QUOTE VALUE</th>
                                <td style='text-align:right'><strong>{$INTENT_CURRENCY}
                                        {number_format($INTENT->get('total_amount'),2)}</strong></td>
                            </tr>
                        </table>
                        <br>
                        <div>
                            The above quote is indicative and is based on the current spot price. Any final quote will
                            depend on the prevailing market price and conditions.
                            If there are any aspects about our offering or pricing you would like to discuss, please do
                            not hesitate to contact us.
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
</body>

</html>