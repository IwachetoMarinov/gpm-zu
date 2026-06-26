<div>
    {$RECORD_MODEL->get('firstname')} {$RECORD_MODEL->get('lastname')}<br>
</div>

<div>
    {if !empty($RECORD_MODEL->get('mailingstreet'))}
        {$RECORD_MODEL->get('mailingstreet')}<br>
    {/if}
    {if !empty($RECORD_MODEL->get('cf_902'))}
        {$RECORD_MODEL->get('cf_902')}<br>
    {/if}

    {if empty($RECORD_MODEL->get('mailingpobox'))}

        {if !empty($RECORD_MODEL->get('mailingcity')) && !empty($RECORD_MODEL->get('mailingzip'))}
            {$RECORD_MODEL->get('mailingcity')} {$RECORD_MODEL->get('mailingzip')}<br>
        {elseif !empty($RECORD_MODEL->get('mailingcity'))}
            {$RECORD_MODEL->get('mailingcity')}<br>
        {else}
            {$RECORD_MODEL->get('mailingzip')}<br>
        {/if}

        {$RECORD_MODEL->get('mailingcountry')}

    {else}

        {if !empty($RECORD_MODEL->get('mailingcity'))}
            P.O. Box {$RECORD_MODEL->get('mailingpobox')}, {$RECORD_MODEL->get('mailingcity')}<br>
        {else}
            P.O. Box {$RECORD_MODEL->get('mailingpobox')}<br>
        {/if}

        {if !empty($RECORD_MODEL->get('mailingstate'))}
            {$RECORD_MODEL->get('mailingstate')}, {$RECORD_MODEL->get('mailingcountry')}
        {else}
            {$RECORD_MODEL->get('mailingcountry')}
        {/if}

    {/if}
</div>
