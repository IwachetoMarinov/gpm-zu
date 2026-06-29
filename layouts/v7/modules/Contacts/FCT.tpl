<!DOCTYPE html>
<html>

<head>
    <title>FOREX CONFIRMATION {$smarty.request.docNo} </title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        {include file='PrintStyles.tpl'|vtemplate_path:'Contacts' print_layout='single' print_extra_styles='hidden'}
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
                    href="index.php?module=Contacts&view=DocumentPrintPreview&record={$RECORD_MODEL->getId()}&docNo={$smarty.request.docNo}&tableName={$smarty.request.tableName}&PDFDownload=true&hideCustomerInfo={$smarty.request.hideCustomerInfo}">Download</a>
            </li>
        </ul>
    {/if}
    <div class="printAreaContainer">
        <div class="full-width">
            <table class="print-tbl">
                <tr>
                    <td style="height: 28mm;">
                        <img src='layouts/v7/modules/Contacts/resources/gpm-new-logo.png'
                            style="max-height: 100%; float:right;width: 154px;">
                        <div style="font-size: 11pt;margin-top: 14px;margin-bottom: 32px">
                            {include file='CustomerPrintInfo.tpl'|vtemplate_path:'Contacts'}
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="height: 10mm; text-decoration: underline;text-align: center">
                        <strong>FOREX CONFIRMATION</strong>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;font-size: 9pt">
                    </td>
                </tr>
                <tr>
                    {assign var="metalPrice" value=($ERP_DOCUMENT->barItems[0]->price)}
                    <td style="font-size: 9pt; height: 168mm; vertical-align: top;">
                        <table class="activity-tbl" style="margin-bottom:5mm">
                            <tr>
                                <th colspan="2" style="width:25%;text-align:center">TRANSACTION ID</th>
                                <th style="width:25%;text-align:center">TRANSACTION DATE</th>
                                <th style="width:25%;text-align:center">VALUE DATE</th>
                                <th style="width:25%;text-align:center">TRANSACTION TYPE</th>
                            </tr>
                            <tr>
                                <td colspan="2" style='text-align:center;'>{$smarty.request.docNo}</td>
                                <td style='text-align:center;'>{$ERP_DOCUMENT->documentDate}</td>
                                <td style='text-align:center;'>{$ERP_DOCUMENT->deliveryDate}</td>
                                <td style='text-align:center;'>FX Spot</td>
                            </tr>
                        </table>
                        <table class="activity-tbl">
                            <tr>
                                <th style="width:50%;">DESCRIPTION</th>
                                <th style="width:25%;text-align:center">CURRENCY</th>
                                <th style="width:25%;text-align:center">AMOUNT</th>
                            </tr>
                            {foreach item=barItem from=$ERP_DOCUMENT->barItems}
                                {assign var="metal" value="-"|explode:$barItem->metal}
                                {assign var="spotPrice" value=$barItem->price}
                                {if $metal[0] eq 'USD'}
                                    {assign var="FIRST_PRICE" value=$ERP_DOCUMENT->totalusdVal}
                                    {assign var="SECOND_PRICE" value=$ERP_DOCUMENT->totalusdVal*$spotPrice}
                                {else}
                                    {assign var="FIRST_PRICE" value=$ERP_DOCUMENT->totalusdVal/$spotPrice}
                                    {assign var="SECOND_PRICE" value=$ERP_DOCUMENT->totalusdVal}
                                {/if}
                                <tr>
                                    <td style="border-bottom:none;vertical-align: top">
                                        We {strtolower($ERP_DOCUMENT->direction)}:<br><br>
                                        We {if strtolower($ERP_DOCUMENT->direction) eq 'sell'}buy:{else}sell:{/if}
                                        <br><br>
                                    </td>
                                    <td style="text-align:right;vertical-align: top">
                                        {$metal[0]}<br><br>
                                        {$metal[1]}
                                    </td>
                                    <td style="text-align:right;vertical-align: top">
                                        {number_format($FIRST_PRICE,2)}<br><br>
                                        {number_format($SECOND_PRICE,2)}
                                    </td>
                                </tr>
                            {/foreach}
                            <tr>
                                <td colspan="3"><b>FX details:</b><br>Spot Rate ({$metal[0]}/{$metal[1]}) : {$spotPrice}
                                </td>
                            </tr>
                        </table>
                        <br>
                        {if isset($COMPANY)}
                            <div>
                                If you have any questions concerning these transactions, please contact
                                {$COMPANY->get('company_name')} at <br>Tel: {$COMPANY->get('company_phone')} or by email:
                                {$COMPANY->get('email')}.
                            </div>
                        {/if}
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