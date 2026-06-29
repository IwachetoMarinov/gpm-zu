<!DOCTYPE html>
<html>

<head>
    <title>ACTIVITY SUMMARY</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        {include file='PrintStyles.tpl'|vtemplate_path:'Contacts' print_layout='paginated'}
    </style>
</head>

<body style="margin: 0px;">
    {if $ENABLE_DOWNLOAD_BUTTON}
        <script type="text/javascript" src="layouts/v7/lib/jquery/jquery.min.js"></script>

        <ul style="list-style-type: none; margin: 0; padding: 0;overflow: hidden;background-color: #333;">
            <li id="downloadBtn" style="float:right"><a style="display: block;
                color: white;text-align: center;padding: 14px 16px;text-decoration: none;background-color: #bea364;"
                    href="index.php?module=Contacts&view=ActivtySummeryPrintPreview&record={$RECORD_MODEL->getId()}&ActivtySummeryDate={$smarty.request.ActivtySummeryDate}&PDFDownload=true">Download</a>
            </li>

            <li id='printConf' style="float:right">
                <span style="float: right;margin-right: 1px;color: white;background-color: #bea364;text-decoration: none;
                display: block;
                text-align: center;
                padding: 14px;cursor: pointer;">Settings</span>
            </li>

            {assign var="activityWarningExcludes" value=[
                'scr_description',
                'transaction_2',
                'transaction_3',
                'table_name_2',
                'table_name_3',
                'matched_amt',
                'posting_date'
            ]}

            {include file='ActivitySummaryWarnings.tpl'|vtemplate_path:'Contacts'
                TRANSACTIONS=$TRANSACTIONS
                ACTIVITY_WARNING_EXCLUDES=$activityWarningExcludes
            }
        </ul>

        <script type="text/javascript" src="layouts/v7/modules/Contacts/resources/ASPrintConf.js"></script>
        {include file='ASPrintConf.tpl'|vtemplate_path:'Contacts'}
        </ul>
    {/if}

    {* New balance, totalMovement and endingBalance *}
    {assign var="balance" value=$OPENING_BALANCE|default:0}
    {assign var="totalMovement" value=0}
    {assign var="endingBalance" value=$OPENING_BALANCE|default:0}

    {assign var="start" value=0}
    {assign var="end" value=1}
    {assign var="currency" value=$smarty.request.ActivtySummeryCurrency|default:$CURRENCY|default:'USD'}

    {for $page=1 to $PAGES}
        {if $page eq 1}
            {assign var="end" value=25}
        {else}
            {assign var="end" value=($end+30)}
        {/if}
        <div class="printAreaContainer">
            <div class="full-width">
                <table class="print-tbl">
                    <tr>
                        <td style="height: 144px;vertical-align: top;">
                            {if !isset($ROOT_DIRECTORY)}
                                <img src='layouts/v7/modules/Contacts/resources/gpm-new-logo.png'
                                    style="height: 103px; margin-top: -14px;float:right;width: 154px;">
                            {else}
                                <img src="file://{$ROOT_DIRECTORY}/layouts/v7/modules/Contacts/resources/gpm-new-logo.png"
                                    style="height: 103px; margin-top: -14px;float:right;width: 154px;">
                            {/if}

                            <div style="font-size:11pt;">
                                {include file='CustomerPrintInfo.tpl'|vtemplate_path:'Contacts'}
                            </div>
                        </td>
                    </tr>
                    {if $page eq 1}
                        <tr>
                            <td style="height: 10mm; text-decoration: underline;text-align: center">
                                <strong>ACTIVITY SUMMARY</strong>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 10mm;text-align: left;font-size:11pt">
                                {if $EARLIEST_DATE && $LATEST_DATE}
                                    For the period of: {$EARLIEST_DATE} to {$LATEST_DATE}
                                {else}
                                    Date: {date("Y-m-d")}
                                {/if}
                            </td>
                        </tr>
                    {/if}
                    <tr>
                        <td style="text-align: right;font-size: 9pt">
                            All amounts in {if isset($currency) and $currency neq ''}{$currency} {else} currency {/if}
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 10pt; height: {if $page eq 1}203{else}224{/if}mm; vertical-align: top;">
                            <table class="activity-tbl">
                                <tr>
                                    <th>DOCUMENT NO.</th>
                                    <th style="width: 22mm;text-align: center;min-width: 28mm;">DATE</th>
                                    <th>DESCRIPTION</th>
                                    <th style="width: 22mm;">DEPOSIT/(WITHDRAWAL)</th>
                                    <th style="text-align: center">BALANCE</th>
                                </tr>

                                <tr>
                                    <td colspan="4"><strong>OPENING BALANCE</strong></td>
                                    <td style="text-align:right"><strong>
                                            {if $OPENING_BALANCE > 0 }{number_format($OPENING_BALANCE, 2, '.', ',')}{else}({number_format(abs($OPENING_BALANCE), 2, '.', ',')}){/if}</strong>
                                    </td>
                                </tr>

                                {for $loopStart=$start to $end}

                                    {if $loopStart >= count($TRANSACTIONS)}{break}{/if}

                                    {assign var="start" value=($loopStart+1)}
                                    {assign var="TRANSACTION" value=$TRANSACTIONS[$loopStart]}

                                    {* Asign description *}
                                    {assign var="description" value=$TRANSACTION['description']|default:''}

                                    {* Asign depositWithdrawal *}
                                    {assign var="depositWithdrawal" value=$TRANSACTION['amount_in_account_currency']|default:0}

                                    {* Asign totalMovement *}
                                    {assign var="totalMovement" value=$totalMovement + $depositWithdrawal}

                                    {* Asign balance *}
                                    {assign var="balance" value=$balance + $depositWithdrawal}

                                    {* Asign Ending balance *}
                                    {assign var="endingBalance" value=$endingBalance + $depositWithdrawal}


                                    {* Normalize values to avoid null warnings *}
                                    {assign var="docNo" value=$TRANSACTION['voucher_no']|default:''}

                                    {assign var="transDate" value=$TRANSACTION['document_date']|default:''}

                                    {* Skip FX / MP transactions *}
                                    {if in_array($docNo|substr:0:3, array('FXP','FXR','MPD','MRD'))}
                                        {continue}
                                    {/if}

                                    <tr>
                                        {* Doc number column *}
                                        <td>{$docNo}</td>

                                        {* Transaction date column *}
                                        <td>
                                            {if $transDate ne ''}
                                                {$transDate|date_format:"%d-%b-%y"}
                                            {/if}
                                        </td>

                                        {* Description column *}
                                        <td>{$description}</td>

                                        {* Deposit/Withdrawal column *}
                                        <td style="text-align:right">
                                            {if $depositWithdrawal > 0}
                                                {number_format($depositWithdrawal, 2, '.', ',')}
                                            {else}
                                                ({number_format($depositWithdrawal*-1, 2, '.', ',')})
                                            {/if}
                                        </td>

                                        {* Balance column *}
                                        <td style="text-align:right">
                                            {if $balance gte 0}
                                                {number_format($balance,2, '.', ',')}
                                            {else}
                                                ({number_format($balance*-1,2, '.', ',')})
                                            {/if}
                                        </td>
                                    </tr>
                                {/for}


                                {if $PAGES eq $page}
                                    <tr>
                                        <td><strong>Total Movement</strong></td>
                                        <td></td>
                                        <td></td>
                                        <td style="text-align:right">
                                            <strong>{if $totalMovement gte 0 }{number_format($totalMovement,2, '.', ',')}{else}({number_format($totalMovement*-1,2, '.', ',')}){/if}</strong>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <th>Ending Balance</th>
                                        <th></th>
                                        <th></th>
                                        <th></th>
                                        <th style="text-align:right">{if $endingBalance gte 0 }
                                                {if $endingBalance eq 0}
                                                    --
                                                {else}
                                                    {number_format($endingBalance,2, '.', ',')}
                                                {/if}
                                            {else}
                                                ({number_format($endingBalance*-1,2, '.', ',')})
                                            {/if}
                                        </th>
                                    </tr>
                                {/if}
                            </table>
                            {if $PAGES eq $page}
                                <div style="text-align: right;font-size: 9pt;margin-top: 2mm">
                                    {if $endingBalance > 0 } This amount is owed to you.{/if}
                                    {if $endingBalance < 0 } This amount is owed to GPM.{/if}
                                </div>
                            {/if}
                        </td>
                    </tr>
                    <tr> 
                        <td style='font-size: 8pt;font-weight: bold;'>
                            {include file='CompanyPrintFooter.tpl'|vtemplate_path:'Contacts' address_field='raw'}
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    {/for}
</body>

</html>