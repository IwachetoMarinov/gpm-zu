<div {if isset($inner_div_style)} style="{$inner_div_style}"{/if}>
    {if isset($COMPANY)}
        <div style="float:left">
            {include file='CompanyInfo.tpl'|vtemplate_path:'Contacts'
                address_field=$address_field
                contact_field=$contact_field}
        </div>
    {/if}
    <div style="float:right;"><br><br>Page {$page} | {if isset($pages_format) && $pages_format eq 'count'}{count($PAGES)}{else}{$PAGES}{/if}</div>
</div>
