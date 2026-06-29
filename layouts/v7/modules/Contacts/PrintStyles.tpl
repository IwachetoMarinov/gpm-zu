{if isset($print_layout) && $print_layout eq 'form_cr'}
    {include file='PrintStylesFormCR.tpl'|vtemplate_path:'Contacts'}
{elseif isset($print_layout) && $print_layout eq 'form_ca'}
    {include file='PrintStylesFormCA.tpl'|vtemplate_path:'Contacts'}
{elseif isset($print_layout) && $print_layout eq 'form_ncr'}
    {include file='PrintStylesFormNCR.tpl'|vtemplate_path:'Contacts'}
{else}
    {include file='PrintStylesFonts.tpl'|vtemplate_path:'Contacts'}
    {include file='PrintStylesBase.tpl'|vtemplate_path:'Contacts'}
    {if isset($print_layout) && $print_layout eq 'single'}
        {include file='PrintStylesSinglePage.tpl'|vtemplate_path:'Contacts'}
    {else}
        {include file='PrintStylesPaginated.tpl'|vtemplate_path:'Contacts'}
    {/if}
    {if isset($print_extra_styles) && $print_extra_styles eq 'hidden'}
.hidden {
    /*display: none;*/
}
    {/if}
{/if}
