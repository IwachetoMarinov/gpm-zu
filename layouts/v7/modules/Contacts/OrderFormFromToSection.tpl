<div class="company-box">
    <div class="company-half company-left">
        <div class="company-top">
            <div class="company-label"><strong>From:</strong></div>
            <div class="company-content">
                {include file='OrderFormCustomerAddress.tpl'|vtemplate_path:'Contacts'}
            </div>
        </div>

        <div class="company-bottom"></div>
    </div>

    <div class="company-half company-right">
        <div class="company-top">
            <div class="company-label"><strong>To:</strong></div>
            <div class="company-content">
                {include file='OrderFormCompanyAddress.tpl'|vtemplate_path:'Contacts'}
            </div>
        </div>

        <div class="company-bottom">
            {if isset($COMPANY)}
                {if !empty($COMPANY->get('email'))}
                    <p>Contact: <span style="font-style: italic;">{$COMPANY->get('email')}</span></p>
                {/if}
                {if !empty($COMPANY->get('company_phone'))}
                    <p>or <span style="font-style: italic;">{$COMPANY->get('company_phone')}</span></p>
                {/if}
            {/if}
        </div>
    </div>
</div>
