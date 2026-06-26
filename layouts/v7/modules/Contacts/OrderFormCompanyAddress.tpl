<div style="text-transform: capitalize; font-weight: 600;">
    {if isset($COMPANY)}
        {$COMPANY->get('company_name')}
    {/if}
</div>

<div style="margin-top: 1.5mm;">
    {if isset($COMPANY)}
        {if !empty($COMPANY->get('company_address'))}
            {$COMPANY->get('company_address')}<br>
        {/if}
        {if !empty($COMPANY->get('company_address_2'))}
            {$COMPANY->get('company_address_2')}<br>
        {/if}
    {/if}
    {if isset($COMPANY)}
        {if !empty($COMPANY->get('city'))}
            {$COMPANY->get('city')},
        {/if}
        {$COMPANY->get('state')} {$COMPANY->get('code')}<br>
        {$COMPANY->get('country')}
    {/if}
</div>
