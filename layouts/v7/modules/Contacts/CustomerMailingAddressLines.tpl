{if !empty($RECORD_MODEL->get('mailingstreet'))}
    {$RECORD_MODEL->get('mailingstreet')}<br>
{/if}
{if !empty($RECORD_MODEL->get('cf_902'))}
    {$RECORD_MODEL->get('cf_902')}<br>
{/if}
{if !empty($RECORD_MODEL->get('mailingpobox'))}
    PO Box {$RECORD_MODEL->get('mailingpobox')}<br>
{/if}
{if !empty($RECORD_MODEL->get('mailingcity')) || !empty($RECORD_MODEL->get('mailingstate')) || !empty($RECORD_MODEL->get('mailingzip'))}
    {if !empty($RECORD_MODEL->get('mailingcity'))}
        {$RECORD_MODEL->get('mailingcity')}{if !empty($RECORD_MODEL->get('mailingstate')) || !empty($RECORD_MODEL->get('mailingzip'))}, {/if}
    {/if}
    {if !empty($RECORD_MODEL->get('mailingstate'))}
        {$RECORD_MODEL->get('mailingstate')}{if !empty($RECORD_MODEL->get('mailingzip'))} {/if}
    {/if}
    {if !empty($RECORD_MODEL->get('mailingzip'))}
        {$RECORD_MODEL->get('mailingzip')}
    {/if}
    <br>
{/if}
{if !empty($RECORD_MODEL->get('mailingcountry'))}
    {$RECORD_MODEL->get('mailingcountry')}<br>
{/if}
