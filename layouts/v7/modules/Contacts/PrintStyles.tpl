{include file='PrintStylesFonts.tpl'|vtemplate_path:'Contacts'}
{include file='PrintStylesBase.tpl'|vtemplate_path:'Contacts'}
{if isset($print_layout) && $print_layout eq 'single'}
    {include file='PrintStylesSinglePage.tpl'|vtemplate_path:'Contacts'}
{else}
    {include file='PrintStylesPaginated.tpl'|vtemplate_path:'Contacts'}
{/if}
{if isset($print_extra_styles) && $print_extra_styles eq 'hidden'}
{/if}
