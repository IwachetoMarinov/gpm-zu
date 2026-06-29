<!DOCTYPE html>
<html>

<head>
    <title>STATEMENT OF HOLDING AND VALUATION</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        {include file='PrintStyles.tpl'|vtemplate_path:'Contacts' print_layout='single' print_extra_styles='hidden'}

        table.activity-tbl tr.no-border td {
            border-bottom: none;
            border-top: none;
        }
    </style>
</head>

<body>
    {if $ENABLE_DOWNLOAD_BUTTON}
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
                    href="index.php?module=Contacts&view=HoldingPrintPreview&record={$RECORD_MODEL->getId()}&PDFDownload=true">Download</a>
            </li>

            {assign var="holdingWarningExcludes" value=[]}

            {include file='HoldingWarnings.tpl'|vtemplate_path:'Contacts'
                HOLDINGS=$ERP_HOLDINGS
                HOLDING_WARNING_EXCLUDES=$holdingWarningExcludes
            }
        </ul>
    {/if}
    <div class="printAreaContainer">
        <div class="full-width">
            <table class="print-tbl">
                <tr>
                    <td style="height: 28mm;">

                        {if !isset($ROOT_DIRECTORY)}
                            <img src='layouts/v7/modules/Contacts/resources/gpm-new-logo.png'
                                style="max-height: 100%; float:right;width: 154px;">
                        {else}
                            <img src="file://{$ROOT_DIRECTORY}/layouts/v7/modules/Contacts/resources/gpm-new-logo.png"
                                style="max-height: 100%; float:right;width: 154px;">
                        {/if}

                        <div style="font-size:11pt;margin-top: 14px;margin-bottom: 32px">
                            {include file='CustomerPrintInfo.tpl'|vtemplate_path:'Contacts'}
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="height: 10mm; text-decoration: underline;text-align: center">
                        <strong>STATEMENT OF HOLDINGS AND VALUATION</strong>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;font-size: 9pt">
                        <table class="activity-tbl" style="margin-top:5mm; width: 50%">
                            <tr>
                                <th colspan="2">REFERENCE VALUE AS PER THE</th>
                            </tr>
                            <tr>
                                <th>LONDON FIX ON</th>
                                <td style="text-align:center">{$LBMA_DATE}</td>
                            </tr>
                            {assign var="spot_price" value={$ERP_HOLDINGMETALS[0]['spot_price']|default:0} }
                            {foreach item=metal from=$METALS}
                                <tr>
                                    <th>{if isset($metal['MT_Name'])}{$metal['MT_Name']}{/if}</th>
                                    <td style="text-align:center">
                                        {if isset($metal['Spot_Price'])}
                                            USD {number_format($metal['Spot_Price'], 2, '.', ',')} / Oz.
                                        {/if}</td>
                                </tr>
                            {/foreach}
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;font-size: 9pt">
                        All amounts in USD
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 9pt; height: 168mm; vertical-align: top;">
                        <table class="activity-tbl" style="margin-bottom:5mm">
                            <tr>
                                <th style="width:10%;">QTY</th>
                                <th style="width:50%;">DESCRIPTION</th>
                                <th style="width:20%;text-align:center">FINE WEIGHT(OZ.)</th>
                                <th style="width:20%;text-align:center">TOTAL</th>
                            </tr>
                            {foreach item=HOLDINGS key=location from=$ERP_HOLDINGS}
                                <tr class="no-border">
                                    <td></td>
                                    <td><strong>{$location}</strong></td>
                                    {* <td><strong>{vtranslate($location,'MetalPrice')}</strong></td> *}
                                    <td style='text-align:right'></td>
                                    <td style='text-align:right'></td>
                                </tr>
                                {foreach item=HOLDING from=$HOLDINGS}
                                    <tr class="no-border">
                                        <td style="vertical-align: top;">{number_format($HOLDING->quantity,0)}</td>

                                        <td>
                                            {$HOLDING->longDesc} <br>
                                            <span style="font-size: smaller;font-style: italic;">
                                                <pre>{$HOLDING->serials}</pre>
                                            </span>
                                        </td>

                                        <td style='vertical-align: top;text-align:right'>
                                            {number_format($HOLDING->pureOz ,4)}
                                        </td>
                                        {* {assign var=CRYPTO value=['MBTC','ETH']}
                                        {if in_array(strtoupper($HOLDING->metal),$CRYPTO) }
                                            <td style='vertical-align: top;text-align:right'>{number_format($HOLDING->pureOz,8)}
                                            </td>
                                        {else}
                                            <td style='vertical-align: top;text-align:right'>{number_format($HOLDING->pureOz,2)}
                                            </td>
                                        {/if} *}
                                        <td style='vertical-align: top;text-align:right'>
                                            {CurrencyField::convertToUserFormat($HOLDING->total)}</td>
                                    </tr>
                                {/foreach}
                            {/foreach}
                            <tr>
                                <th colspan="3">TOTAL MARKET VALUE</th>
                                <td style='text-align:right'><strong>USD
                                        {CurrencyField::convertToUserFormat($TOTAL)}</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style='font-size: 8pt;font-weight: bold; width: 85%; position: absolute; bottom: 14px;'>
                        {if isset($COMPANY)}
                            {$COMPANY->get('company_name')} {if !empty($COMPANY->get('company_reg_no'))}(Co. Reg. No.
                            {$COMPANY->get('company_reg_no')}){/if}<br>
                            {$COMPANY->get('company_address')}

                            {if $COMPANY->get('city')}, {$COMPANY->get('city')}{/if}
                            {if $COMPANY->get('state')}, {$COMPANY->get('state')}{/if}
                            {if $COMPANY->get('code')}, {$COMPANY->get('code')}{/if}
                            {if $COMPANY->get('country')}, {$COMPANY->get('country')}{/if}
                            <br>
                            T: {$COMPANY->get('company_phone')} {if !empty($COMPANY->get('company_fax'))}| Fax:
                            {$COMPANY->get('company_fax')} {/if} | {$COMPANY->get('email')}<br>
                        {/if}
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>

</html>