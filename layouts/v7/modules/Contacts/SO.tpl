<!DOCTYPE html>
<html>

<head>
    <title>SALE ORDER</title>
    <meta charset="UTF-8">

    <style>
        {include file='PrintStylesSO.tpl'|vtemplate_path:'Contacts'}
    </style>
</head>

<body>
    {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
        <ul style="list-style-type:none;margin:0;padding:0;overflow:hidden;background-color:#333;">
            <li style="float:right">
                <a id="downloadBtn"
                    style="display:block;color:white;text-align:center;padding:14px 16px;text-decoration:none;background-color:#bea364;"
                    href="index.php?module=Contacts&view=SaleOrderView&record={$RECORD_MODEL->getId()}&docNo={$smarty.request.docNo|default:''}&PDFDownload=true&hideCustomerInfo={$smarty.request.hideCustomerInfo|default:0}">
                    Download
                </a>
            </li>
        </ul>
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

        <table class="header-table">
            <tr>
                <td class="title" style="text-decoration: underline; text-align: center;">SALE ORDER</td>
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
                            {if !empty($RECORD_MODEL->get('cf_902'))}
                                {$RECORD_MODEL->get('cf_902')}<br>
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

        <section class="main-table">
            <div class="additional-section bolder-element">
                <strong>1.</strong> This Sale Order is subject to and governed by the terms and conditions of the
                Form A (CMA) executed and entered into by and between me/us and GPM.
            </div>

            <div class="section-title bolder-element">
                <strong>2.</strong> I/We hereby wish to sell to
                <span style="text-transform: capitalize;">
                    {if isset($COMPANY)}
                        {$COMPANY->get('company_name')}
                    {else }.................................................
                    {/if}
                </span>
                the following precious metals:
            </div>

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
            ["label" => "Other", "grams" => ""]
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

            <div class="serials-box">
                <p>If applicable, please specify the serial numbers of the items to be sold:</p>
                <input type="text" name="serial_numbers" class="custom-editable-input full-width" />
            </div>

            <div class="additional-section">
                If the metal to be sold is not currently in storage with GPM, please specify the
                exact pick-up location and the details of the person authorised to release the metal to GPM (if
                applicable, IC/Passport number):
                <div style="margin-top:2mm;" class="editable-input-wrapper">
                    <p class="editable-label">Pick-up location:</p>
                    <input type="text" name="pick_up_location" class="custom-editable-input" />
                </div>

                <div style="margin-top:3mm;" class="editable-input-wrapper">
                    <span>Authorised person: Full name:</span>
                    <input type="text" name="authorised_person_name" class="custom-editable-input" />
                    <span> IC/Passport No:</span>
                    <input type="text" name="authorised_person_id" class="custom-editable-input" />
                </div>
            </div>

            <div class="additional-section bolder-element ">
                <strong>3.</strong> I/We acknowledge that:
                <div class="indent">
                    - GPM shall quote a sale price, which is to be agreed and confirmed in writing (e.g. email, telafax)
                    to GPM.
                </div>
                <div class="indent">
                    - In the absence of the above written confirmation within 10 Business Days from the date hereof,
                    this Sale Order shall be null and void.
                </div>
            </div>

            <div class="additional-section bolder-element">
                <strong>4.</strong> The sales proceeds agreed upon shall be transferred to my/our bank account:
            </div>

            <div class="details-container">
                <div class="bank-details">
                    <div class="bank-row editable-input-wrapper">
                        <p class="editable-label"> Bank Name:</p>
                        <input type="text" name="bank_name" class="custom-editable-input" />
                    </div>

                    <div class="bank-row editable-input-wrapper" style="margin-top: 2mm;">
                        <p class="editable-label"> Bank Address:</p>
                        <input type="text" name="bank_address" class="custom-editable-input" />
                    </div>

                    <div class="bank-row editable-input-wrapper" style="margin-top: 2mm;">
                        <p class="editable-label"> Bank Code:</p>
                        <input type="text" name="bank_code" class="custom-editable-input" />
                        <p class="editable-label"> Swift Code:</p>
                        <input type="text" name="swift_code" class="custom-editable-input" />
                    </div>

                    <div class="bank-row editable-input-wrapper" style="margin-top: 2mm;">
                        <p class="editable-label"> Account No:</p>
                        <input type="text" name="account_no" class="custom-editable-input" />
                        <p class="editable-label"> Account Currency:</p>
                        <input type="text" name="account_currency" class="custom-editable-input" />
                    </div>
                </div>

                <div class="signature-section">
                    <div class="signature-section-item">
                        <div class="signature-section-left">
                            <div class="editable-input-wrapper">
                                <span> Place:</span> <input type="text" name="place_input"
                                    class="custom-editable-input" />
                            </div>
                            <div class="editable-input-wrapper" style="margin-top: 4.5mm;">
                                <span>Date:</span> <input type="text" name="date_input" class="custom-editable-input" />
                            </div>
                        </div>

                        <div class="signature-section-right">
                            <div class="editable-input-wrapper">
                                <span> Signed by: </span>
                                <input type="text" name="signed_by" class="custom-editable-input" />
                            </div>
                            <div class="editable-input-wrapper" style="margin-top: 4.5mm;">
                                <span> On behalf of:</span>
                                <input type="text" name="on_behalf_of" class="custom-editable-input" />
                            </div>
                        </div>
                    </div>

                    <div style="margin-top:4mm;">
                        <div class="signature-line">...............................................</div><br>
                        Signature
                    </div>
                </div>

        </section>
    </div>

    <script>
        document.getElementById('downloadBtn').addEventListener('click', function(e) {

            const name = document.querySelector('.input-name')?.value;

            const url = new URL(this.href);

            if (name) {
                url.searchParams.set('clientName', name);
            } else {
                url.searchParams.delete('clientName');
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