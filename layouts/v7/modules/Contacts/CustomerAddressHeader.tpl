<div style="font-size:11pt;margin-top: 14px;margin-bottom: 32px;">
    {$RECORD_MODEL->get('cf_898')}<br>
    {if empty($HIDE_BP_INFO)}
        {$RECORD_MODEL->get('firstname')} {$RECORD_MODEL->get('lastname')} <br>
        {include file='CustomerMailingAddressLines.tpl'|vtemplate_path:'Contacts'}
    {else}
        <br>
        <br>
        <br>
        <br>
    {/if}

    <div
        style="font-size:10pt; font-weight: bold; font-size: 18pt; {if !empty($invoice_title_style)}{$invoice_title_style}{else}margin-top: 2mm;{/if}">
        {if !empty($document_title)}{$document_title}{else}INVOICE{/if}
    </div>
</div>
