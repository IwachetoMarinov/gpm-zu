<!DOCTYPE html>
<html>

<head>
    <title>PURCHASE & STORAGE ORDER</title>
    <meta charset="UTF-8">

    <style>
        {include file='PrintStylesPO.tpl'|vtemplate_path:'Contacts'}
    </style>
</head>

<body>
    {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
        {assign var=selected_bank value=""}

        {if isset($SELECTED_BANK) && $SELECTED_BANK && method_exists($SELECTED_BANK, 'getId')}
            {assign var=selected_bank value=$SELECTED_BANK->getId()}
        {/if}

        <script type="text/javascript" src="layouts/v7/lib/jquery/jquery.min.js"></script>
        <link type='text/css' rel='stylesheet' href='layouts/v7/lib/jquery/select2/select2.css'>
        <link type='text/css' rel='stylesheet' href='layouts/v7/lib/select2-bootstrap/select2-bootstrap.css'>
        <script type="text/javascript" src="layouts/v7/lib/jquery/select2/select2.min.js"></script>

        <ul style="list-style-type:none;margin:0;padding:0;overflow:hidden;background-color:#333;">
            <li style="float:right">
                <a id="downloadBtn"
                    style="display:block;color:white;text-align:center;padding:14px 16px;text-decoration:none;background-color:#bea364;"
                    href="index.php?module=Contacts&view=PurchaseOrderView&record={$RECORD_MODEL->getId()}&docNo={$smarty.request.docNo|default:''}&PDFDownload=true&hideCustomerInfo={$smarty.request.hideCustomerInfo|default:0}">
                    Download
                </a>
            </li>

            {assign var=bank_account_id value=$smarty.request.bank|default:$SELECTED_BANK->getId()}

            <li style="float: right;margin-top: 5px;margin-right: 5px;width: 198px;">
                <select class="inputElement select2" name="bank_accounts" id="bank_accounts">
                    <option value="">Select Bank Account</option>
                    {foreach item=account from=$ALL_BANK_ACCOUNTS}
                        <option {if $bank_account_id  eq $account->getId() } selected {/if} value="{$account->getId()}">
                            {$account->get('bank_alias_name')}</option>
                    {/foreach}
                </select>
            </li>
        </ul>

        {literal}
            <style>
                .select2-container .select2-choice>.select2-chosen {
                    width: 171px;
                }
            </style>
            <script>
                $(document).ready(function() {
                    $('.select2').select2();
                });
                jQuery("body").on('change', '#bank_accounts', function(e) {
                    var element = jQuery(e.currentTarget);
                    var bankId = Number(element.val());
                    window.location.replace(window.location.href.split('&bank=')[0] + '&bank=' + bankId);
                });
            </script>
        {/literal}
    {/if}

    <div
        class="printAreaContainer {if isset($smarty.request.PDFDownload) && $smarty.request.PDFDownload eq true}pdf-wrapper{/if}">

        <!-- HEADER -->
        <div class="logo">
            {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
                <img src="layouts/v7/modules/Contacts/resources/gpm-new-logo.png" style="width:50mm;">
            {else}
                <img src="file://{$ROOT_DIRECTORY}/layouts/v7/modules/Contacts/resources/gpm-new-logo.png"
                    style="width:40mm;">
            {/if}
        </div>

        <table class="header-table table-heading">
            <tr>
                <td class="title" style="text-decoration: underline; text-align: center;">PURCHASE & STORAGE ORDER</td>
            </tr>
        </table>

        <!-- FROM / TO SECTION -->
        <div class="company-box">
            <div class="company-half company-left">
                <div class="company-top">
                    <div class="company-label"><strong>From:</strong></div>
                    <div class="company-content">
                        <div>
                            {$RECORD_MODEL->get('firstname')} {$RECORD_MODEL->get('lastname')}<br>
                        </div>

                        <div>
                            {if !empty($RECORD_MODEL->get('mailingstreet'))}
                                {$RECORD_MODEL->get('mailingstreet')}<br>
                            {/if}

                            {if empty($RECORD_MODEL->get('mailingpobox'))}

                                {if !empty($RECORD_MODEL->get('mailingcity')) && !empty($RECORD_MODEL->get('mailingzip'))}
                                    {$RECORD_MODEL->get('mailingcity')} {$RECORD_MODEL->get('mailingzip')}<br>
                                {elseif !empty($RECORD_MODEL->get('mailingcity'))}
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
                        </div>
                    </div>
                </div>

                <div class="company-bottom">
                    Customer number:
                    <span style="font-weight: 600;">{$RECORD_MODEL->get('cf_898')}</span>
                </div>
            </div>

            <div class="company-half company-right">
                <div class="company-top">
                    <div class="company-label"><strong>To:</strong></div>
                    <div class="company-content">
                        <div style="text-transform: capitalize; font-weight: 600;">
                            {if isset($COMPANY)}
                                {$COMPANY->get('company_name')}
                            {/if}
                        </div>

                        <div style="margin-top: 1.5mm;">
                            {if isset($COMPANY)}
                                {$COMPANY->get('company_address')}
                            {/if}
                            <br />
                            {if isset($COMPANY)}
                                {if !empty($COMPANY->get('city'))}
                                    {$COMPANY->get('city')},
                                {/if}
                                {$COMPANY->get('state')} {$COMPANY->get('code')}<br>
                                {$COMPANY->get('country')}
                            {/if}
                        </div>
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

        <!-- SECTION 1 -->
        <section class="main-table">
            <div class="additional-section bolder-element">
                <strong>1.</strong> I/We hereby instruct GPM:
            </div>

            <!-- SECTION 2 -->
            <div class="section-title">
                (a) <span class="bolder-element"> to purchase</span> in its name and on my/our behalf the following
                physical precious
                metals (Please indicate the quantity and type
                of bars required):
            </div>

            <!-- METALS TABLE -->
            {assign var="metals" value=[
            'Gold 999.9',
            'Silver 999.0',
            'Platinum 999.5',
            'Palladium 999.5'
        ]}

            {assign var="weights" value=[
            ["label" => "1000oz", "grams" => "31,103g"],
            ["label" => "400oz", "grams" => "12,441g"],
            ["label" => "100oz", "grams" => "3,110g"],
            ["label" => "32.15oz", "grams" => "1,000g"],
            ["label" => "16.08oz", "grams" => "500g"],
            ["label" => "10oz", "grams" => "311g"],
            ["label" => "3.22oz", "grams" => "100g"],
            ["label" => "1oz", "grams" => "31g"],
            ["label" => "Other", "grams" => "(pls specify)"]
        ]}

            <table class="metals-table">
                <colgroup>
                    <col style="width:18%;">
                    <col style="width:9.11%;">
                    <col style="width:9.11%;">
                    <col style="width:9.11%;">
                    <col style="width:9.11%;">
                    <col style="width:9.11%;">
                    <col style="width:9.11%;">
                    <col style="width:9.11%;">
                    <col style="width:9.11%;">
                    <col style="width:9.11%;">
                </colgroup>
                <tr>
                    <th>Metal</th>
                    {foreach from=$weights item=w}
                        <th>
                            {$w.label}<br>
                            {if $w.grams}{$w.grams}{/if}
                        </th>
                    {/foreach}
                </tr>

                {foreach from=$metals item=m key=mi}
                    <tr>
                        <td class="metal-row-label">{$m}</td>

                        {foreach from=$weights item=w key=wi}
                            <td>
                                <input type="text" class="custom-editable-input custom-editable-table-input"
                                    name="metal_{$mi}_weight_{$wi}"
                                    style="width:100%; border:0; outline:none; background:transparent;" />
                            </td>
                        {/foreach}
                    </tr>
                {/foreach}
            </table>

            <!-- SERIALS BOX -->
            <div class="serials-box">
                (b) <span class="bolder-element"> for the sum of
                    {if isset($SELECTED_BANK)}
                        {$SELECTED_BANK->get('account_currency')}
                    {/if}
                </span>
                <span>
                    <input type="text" name="currency" class="custom-editable-input" />
                    <span style="font-style: italic;"> (the “Purchase Amount”)</span>
                </span>
            </div>

            <div class="serials-box">(c) <span class="bolder-element">and thereafter to</span></div>

            <div style="margin-left: 5mm;">
                <div style="margin-top: 2mm;padding-left: 2mm;">
                    {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
                        <input type="checkbox" name="country_option">
                    {else}
                        <span class="custom-checkbox"></span>
                    {/if}
                    <span>deliver & store the above metal in a facility located in:</span>
                    <span> <input type="text" name="location" class="custom-editable-input" /> </span>
                    <span style="font-style: italic;">(Please specify country)</span>
                </div>

                <div style="margin-top: 2mm;padding-left: 2mm;">
                    {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
                        <input type="checkbox" name="address_option">
                    {else}
                        <span class="custom-checkbox"></span>
                    {/if}
                    <span>deliver the above metal to:</span>
                    <span> <input type="text" name="address" style="width: 75mm;" class="custom-editable-input" />
                    </span>
                    <span style="font-style: italic;">(Please specify full address)</span>
                </div>
            </div>

            <!-- SECTION 2 -->
            <div class="additional-section ">
                <strong>2.</strong><span class="bolder-element"> I/We make the payment of the above Purchase Amount:
                </span>
                <div style="padding-left: 5mm;margin-top:1.5mm">
                    <div>(a) <span class="bolder-element">from the following jurisdiction:</span></div>

                    <div style="padding-left: 5mm; margin-top: 2mm;">Country:
                        <span> <input type="text" name="country" style="width: 60mm;"
                                class="custom-editable-input" /></span>
                    </div>

                    <div style="margin:1.5mm 0;">(b) <span class="bolder-element">to GPM’s bank account </span>as
                        follows:</div>

                    <div style="padding-left: 5mm;">
                        {include file='BankDetails.tpl'|vtemplate_path:'Contacts' selected_bank=$SELECTED_BANK}
                    </div>
                </div>
            </div>

            <!-- SECTION 3 -->
            <div class="additional-section">
                <span class="bolder-element">
                    3. I/We hereby elect the following Pricing Option (Please select one option):
                </span>

                <div style="margin-left: 5mm; margin-top:2mm;">

                    <div>
                        <label>
                            {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
                                <input type="checkbox" name="pricing_option_one" class="checkbox-radio pricing-option-one"
                                    {if $PRICING_OPTION neq '2'}checked{/if}>
                            {else}
                                <span class="custom-checkbox"></span>
                            {/if}
                            Pricing Option 1 (as defined in Clause 3.3.1)
                        </label>
                    </div>

                    <div style="margin-top: 2mm;">
                        <label>
                            {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
                                <input type="checkbox" name="pricing_option_two" class="checkbox-radio pricing-option-two"
                                    {if $PRICING_OPTION eq '2'}checked{/if}>
                            {else}
                                <span class="custom-checkbox"></span>
                            {/if}
                            Pricing Option 2 (as defined in Clause 3.3.2)
                        </label>
                    </div>
                </div>

                <div class="additional-section company-heading" style="margin-top:4mm;">
                    <span class="bolder-element">4. This Purchase & Storage Order and any agreement with GPM resulting
                        therefrom shall be subject to and governed by
                        the terms and conditions of the Form A executed and entered into by and
                        between
                        me/us and
                        {if isset($COMPANY)}
                            <span style="text-transform: capitalize;">{$COMPANY->get('company_name')}</span>
                        {/if}</span>
                </div>

                <!-- SIGNATURE SECTION -->
                <div class="signature-section">
                    <div class="signature-section-item">
                        <div class="signature-section-left">
                            <div class="editable-input-wrapper">
                                <span> Place:</span> <input type="text" name="place_input"
                                    class="custom-editable-input" />
                            </div>
                            <div class="editable-input-wrapper" style="margin-top: 2.5mm;">
                                <span>Date:</span> <input type="text" name="date_input" class="custom-editable-input" />
                            </div>
                        </div>

                        <div class="signature-section-right">
                            <div class="editable-input-wrapper">
                                <span> Signed by: </span>
                                <input type="text" name="signed_by" class="custom-editable-input" />
                            </div>
                            <div class="editable-input-wrapper" style="margin-top: 2.5mm;">
                                <span> On behalf of:</span>
                                <input type="text" name="on_behalf_of" class="custom-editable-input" />
                            </div>
                        </div>
                    </div>

                    <div style="margin-top:1mm;">
                        <div class="signature-line">.......................</div><br>
                        Signature
                    </div>
                </div>
            </div>

        </section>
    </div>


    <script>
        document.querySelectorAll('.checkbox-radio').forEach(function(element) {
            element.addEventListener('change', function() {
                if (this.classList.contains('pricing-option-one')) {
                    document.querySelector('.pricing-option-two').checked = false;
                } else if (this.classList.contains('pricing-option-two')) {
                    document.querySelector('.pricing-option-one').checked = false;
                }
            });
        });

        document.getElementById('downloadBtn').addEventListener('click', function(e) {

            const firstChecked = document.querySelector('input.pricing-option-one:checked');
            const secondChecked = document.querySelector('input.pricing-option-two:checked');

            const countryOption = document.querySelector('input[name="country_option"]');
            const addressOption = document.querySelector('input[name="address_option"]');

            let checked = null;
            if (firstChecked) {
                checked = "1";
            } else if (secondChecked) {
                checked = "2";
            }

            const url = new URL(this.href);
            if (checked) url.searchParams.set('pricing_option', checked);
            else url.searchParams.delete('pricing_option');

            if (countryOption && countryOption.checked) {
                url.searchParams.set('countryOption', '1');
            } else {
                url.searchParams.delete('countryOption');
            }

            if (addressOption && addressOption.checked) {
                url.searchParams.set('addressOption', '1');
            } else {
                url.searchParams.delete('addressOption');
            }

            document.querySelectorAll('.custom-editable-input').forEach(input => {
                if (!input.name) return;

                const val = (input.value ?? '').trim();
                if (val) url.searchParams.set(input.name, val);
                else url.searchParams.delete(input.name);
            });

            this.href = url.toString();
        });
    </script>
</body>

</html>