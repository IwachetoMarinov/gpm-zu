{if isset($COMPANY)}
    {if !isset($show_name) || $show_name}
        {$COMPANY->get('company_name')} {if !empty($COMPANY->get('company_reg_no'))}(Co. Reg. No. {$COMPANY->get('company_reg_no')}){/if}<br>
    {elseif !empty($COMPANY->get('company_reg_no'))}
        (Co. Reg. No. {$COMPANY->get('company_reg_no')})<br>
    {/if}
    {if isset($address_field) && $address_field eq 'raw'}
        {if !empty($COMPANY->get('company_address'))}
            {$COMPANY->get('company_address')}<br>
        {/if}
        {if !empty($COMPANY->get('company_address_2'))}
            {$COMPANY->get('company_address_2')}<br>
        {/if}
    {else}
        {if !empty($COMPANY->get('company_address'))}
            {$COMPANY->get('company_address')}<br>
        {/if}
        {if !empty($COMPANY->get('company_address_2'))}
            {$COMPANY->get('company_address_2')}<br>
        {/if}
        {if !empty($COMPANY->get('city')) && !empty($COMPANY->get('code'))}
            {$COMPANY->get('city')} {$COMPANY->get('code')}<br>
        {elseif !empty($COMPANY->get('city'))}
            {$COMPANY->get('city')}<br>
        {elseif !empty($COMPANY->get('code'))}
            {$COMPANY->get('code')}<br>
        {/if}
        {if !empty($COMPANY->get('state'))}
            {$COMPANY->get('state')}{if !empty($COMPANY->get('country'))}, {$COMPANY->get('country')}{/if}
        {else}
            {$COMPANY->get('country')}
        {/if}
    {/if}
    <br>
    T: {$COMPANY->get('company_phone')} {if !empty($COMPANY->get('company_fax'))}| Fax: {$COMPANY->get('company_fax')} {/if} |
    {if isset($contact_field) && $contact_field eq 'website'}
        {$COMPANY->get('company_website')}
    {else}
        {$COMPANY->get('email')}
    {/if}<br>
{/if}
