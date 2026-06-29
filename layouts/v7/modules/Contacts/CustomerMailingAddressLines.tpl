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
    {if $smarty.request.europeanAddress eq '1' || $smarty.request.europeanAddress eq 1}
        {if !empty($RECORD_MODEL->get('mailingzip'))}
            {$RECORD_MODEL->get('mailingzip')}{if !empty($RECORD_MODEL->get('mailingcity'))} {$RECORD_MODEL->get('mailingcity')}{/if}{if !empty($RECORD_MODEL->get('mailingstate'))} {$RECORD_MODEL->get('mailingstate')}{/if}
        {elseif !empty($RECORD_MODEL->get('mailingcity'))}
            {$RECORD_MODEL->get('mailingcity')}{if !empty($RECORD_MODEL->get('mailingstate'))} {$RECORD_MODEL->get('mailingstate')}{/if}
        {else}
            {$RECORD_MODEL->get('mailingstate')}
        {/if}
    {else}
        {if !empty($RECORD_MODEL->get('mailingcity'))}
            {$RECORD_MODEL->get('mailingcity')}{if !empty($RECORD_MODEL->get('mailingstate')) || !empty($RECORD_MODEL->get('mailingzip'))}, {/if}
        {/if}
        {if !empty($RECORD_MODEL->get('mailingstate'))}
            {$RECORD_MODEL->get('mailingstate')}{if !empty($RECORD_MODEL->get('mailingzip'))} {/if}
        {/if}
        {if !empty($RECORD_MODEL->get('mailingzip'))}
            {$RECORD_MODEL->get('mailingzip')}
        {/if}
    {/if}
    <br>
{/if}
{if !empty($RECORD_MODEL->get('mailingcountry'))}
    {$RECORD_MODEL->get('mailingcountry')}<br>
{/if}
