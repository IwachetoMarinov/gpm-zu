{$RECORD_MODEL->get('cf_898')}<br>
{assign var="show_bp_details" value=true}
{if isset($HIDE_BP_INFO) && $HIDE_BP_INFO}
    {assign var="show_bp_details" value=false}
{/if}
{if $show_bp_details}
    {$RECORD_MODEL->get('firstname')} {$RECORD_MODEL->get('lastname')}<br>
    {if !empty($RECORD_MODEL->get('cf_968'))} {$RECORD_MODEL->get('cf_968')}<br>{/if}
    {if !empty($RECORD_MODEL->get('mailingstreet'))}
    {$RECORD_MODEL->get('mailingstreet')}<br>{/if}
    {if !empty($RECORD_MODEL->get('cf_970'))} {$RECORD_MODEL->get('cf_970')}<br>{/if}
    {if empty($RECORD_MODEL->get('mailingpobox'))}
        {if !empty($RECORD_MODEL->get('mailingcity')) && !empty($RECORD_MODEL->get('mailingzip')) }
            {$RECORD_MODEL->get('mailingcity')} {$RECORD_MODEL->get('mailingzip')}<br>
        {else if !empty($RECORD_MODEL->get('mailingcity'))}
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
{/if}
