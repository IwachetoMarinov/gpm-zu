<div>
    {if !empty($RECORD_MODEL->get('cf_898'))}
        {$RECORD_MODEL->get('cf_898')}<br>
    {/if}
    {$RECORD_MODEL->get('firstname')} {$RECORD_MODEL->get('lastname')}<br>
    {include file='CustomerMailingAddressLines.tpl'|vtemplate_path:'Contacts'}
</div>
