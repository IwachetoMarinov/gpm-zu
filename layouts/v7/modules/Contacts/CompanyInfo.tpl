{if isset($COMPANY)}
    {if !isset($show_name) || $show_name}
        {$COMPANY->get('company_name')} {if !empty($COMPANY->get('company_reg_no'))}(Co. Reg. No. {$COMPANY->get('company_reg_no')}){/if}<br>
    {elseif !empty($COMPANY->get('company_reg_no'))}
        (Co. Reg. No. {$COMPANY->get('company_reg_no')})<br>
    {/if}
    {if isset($address_field) && $address_field eq 'raw'}
        {$COMPANY->get('company_address')}
    {else}
        {$COMPANY_FULL_ADDRESS}
    {/if}
    <br>
    T: {$COMPANY->get('company_phone')} {if !empty($COMPANY->get('company_fax'))}| Fax: {$COMPANY->get('company_fax')} {/if} |
    {if isset($contact_field) && $contact_field eq 'website'}
        {$COMPANY->get('company_website')}
    {else}
        {$COMPANY->get('email')}
    {/if}<br>
{/if}
