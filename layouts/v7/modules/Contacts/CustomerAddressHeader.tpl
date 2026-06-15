<div style="font-size:11pt;margin-top: 14px;margin-bottom: 32px;">
    {$RECORD_MODEL->get('cf_898')}<br>
    {if empty($HIDE_BP_INFO)}
        {$RECORD_MODEL->get('firstname')} {$RECORD_MODEL->get('lastname')} <br>
        {* {$RECORD_MODEL->get('cf_968')} <br> *}
        {$RECORD_MODEL->get('mailingstreet')} <br>
        {* {$RECORD_MODEL->get('cf_970')} <br> *}
        {if empty($RECORD_MODEL->get('mailingpobox'))}
            {if !empty($RECORD_MODEL->get('mailingcity')) && !empty($RECORD_MODEL->get('mailingzip'))}
                {$RECORD_MODEL->get('mailingcity')} {$RECORD_MODEL->get('mailingzip')} <br>
            {else if !empty($RECORD_MODEL->get('mailingcity'))}
                {$RECORD_MODEL->get('mailingcity')}<br>
            {else}
                {$RECORD_MODEL->get('mailingzip')}<br>
            {/if}
            {$RECORD_MODEL->get('mailingcountry')}<br>
        {else}
            {if !empty($RECORD_MODEL->get('mailingcity'))}
                P.O. Box {$RECORD_MODEL->get('mailingpobox')}, {$RECORD_MODEL->get('mailingcity')}<br>
            {else}
                P.O. Box {$RECORD_MODEL->get('mailingpobox')}<br>
            {/if}
            {if !empty($RECORD_MODEL->get('mailingstate'))}
                {$RECORD_MODEL->get('mailingstate')}, {$RECORD_MODEL->get('mailingcountry')}<br>
            {else}
                {$RECORD_MODEL->get('mailingcountry')}<br>
            {/if}
        {/if}
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