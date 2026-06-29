{if isset($CLIENT_ERP_NO) && $CLIENT_ERP_NO ne ''}
{$CLIENT_ERP_NO}<br>
{elseif !empty($RECORD_MODEL->get('cf_898'))}
{$RECORD_MODEL->get('cf_898')}<br>
{/if}
{assign var="show_bp_details" value=true}
{if isset($HIDE_BP_INFO) && $HIDE_BP_INFO}
    {assign var="show_bp_details" value=false}
{/if}
{if $show_bp_details}
    {$RECORD_MODEL->get('firstname')} {$RECORD_MODEL->get('lastname')}<br>
    {include file='CustomerMailingAddressLines.tpl'|vtemplate_path:'Contacts'}
{/if}
