<!DOCTYPE html>
<html>

<head>
    <title>SHIPMENT & STORAGE ORDER</title>
    <meta charset="UTF-8">

    <style>
        {include file='PrintStylesSTO.tpl'|vtemplate_path:'Contacts'}
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
                    href="index.php?module=Contacts&view=StockTransferOrderView&record={$RECORD_MODEL->getId()}&docNo={$smarty.request.docNo|default:''}&bank={$selected_bank}&PDFDownload=true&hideCustomerInfo={$smarty.request.hideCustomerInfo|default:0}">
                    Download
                </a>
            </li>

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
                <td class="title" style="text-decoration: underline; text-align: center;">SHIPMENT & STORAGE ORDER</td>
            </tr>
        </table>

        {include file='OrderFormFromToSection.tpl'|vtemplate_path:'Contacts'}

        <!-- SECTION 1 -->
        <section class="main-table">
            <div class="additional-section bolder-element" style="margin-top: 0mm;">
                1. I/We hereby instruct GPM:
            </div>

            <div class="section-title">
                (a) <span class="bolder-element"> to ship</span> in its name and on my/our behalf the following physical
                precious metals (please indicate the quantity of bars in the
                relevant box):
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
            ["label" => "Other", "grams" => ""]
        ]}

            <table class="metals-table">
                <tr>
                    <th style="width:18%;">Metal</th>
                    {foreach from=$weights item=w}
                        <th style="width:9%;">
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
                Description of the precious metals <span style="font-style: italic;">(Please specify type, refiner,
                    serial numbers, fineness):</span>
                <div style="margin-top: 1mm;">
                    <input type="text" name="description" class="custom-editable-input full-width" />
                </div>
            </div>

            <!-- SECTION 3 -->
            <div class="additional-section" style="margin-left:2mm;">
                <div class="location-wrapper" style="margin-top:1mm;">
                    <span>From <span style="font-style: italic;">(Please specify pick-up location):</span></span>
                    <input type="text" name="from_location" class="custom-editable-input full-width" />
                </div>

                <div class="location-wrapper" style="margin-top:2mm;">
                    <span>To <span style="font-style: italic;">(Please specify delivery location):</span></span>
                    <input type="text" name="to_location" class="custom-editable-input full-width" />
                </div>

                <div style="margin-top:1mm;">
                    (b) <span class="bolder-element">and thereafter to store the above precious metal in a segregated
                        storage in:</span>
                    <div class="country-options">
                        <div>
                            {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
                                <input class="country-checkbox" type="checkbox" name="1"> Singapore
                            {else}
                                <span class="pdf-checkbox"></span>
                                <span class="pdf-checkbox-label">Singapore</span>
                            {/if}
                        </div>
                        <div>
                            {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
                                <input class="country-checkbox" type="checkbox" name="2"> Switzerland
                            {else}
                                <span class="pdf-checkbox"></span>
                                <span class="pdf-checkbox-label">Switzerland</span>
                            {/if}
                        </div>
                        <div>
                            {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
                                <input class="country-checkbox" type="checkbox" name="3"> Hong Kong
                            {else}
                                <span class="pdf-checkbox"></span>
                                <span class="pdf-checkbox-label">Hong Kong</span>
                            {/if}
                        </div>
                        <div>
                            {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
                                <input class="country-checkbox" type="checkbox" name="4"> Dubai
                            {else}
                                <span class="pdf-checkbox"></span>
                                <span class="pdf-checkbox-label">Dubai</span>
                            {/if}
                        </div>
                    </div>

                    <div>
                        <div>
                            <div class="custom-country">
                                {if !isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload neq true}
                                    <input class="country-checkbox" type="checkbox" name="5">
                                    <div>
                                        Other country or location (Please specify):
                                        <input type="text" class="custom-country-input" value="{$CUSTOM_COUNTRY|default:''}"
                                            style="width:60mm; margin-left:2mm;" />
                                    </div>
                                {else}
                                    <span class="pdf-checkbox"></span>
                                    <span class="pdf-checkbox-label">Other country or location (Please specify):
                                        {$CUSTOM_COUNTRY|default:''}</span>
                                {/if}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SECTION 2 -->
            <div class="additional-section ">
                <div style="margin-bottom:1mm;" class="bolder-element">
                    2. I/We agree that: (1) the above shipment will be effected by GPM after the Shipment Fee has been
                    agreed by and between me/us; and (2) GPM will serve me/us an invoice for the payment of the Storage
                    Fees upon delivery of the above bullion at the elected storage location (if applicable).
                </div>
            </div>

            <!-- SECTION 3 -->
            <div class="additional-section" style="margin-bottom: 1mm;">
                <div style="margin-bottom:1mm;" class="bolder-element">
                    3. I/We make the payment of the Shipping and Storage Fees:
                </div>

                <div style="margin-left: 2mm;">
                    <p class="bolder-element">(a) from the following jurisdiction:</p>
                    <div style="margin-left: 5mm; margin-top:2mm; font-weight: normal;">
                        <span> Country:</span>
                        <input type="text" name="country" class="custom-editable-input" />
                    </div>
                </div>

                <div style="margin-left: 2mm; margin-top:2mm;">
                    <p>(b) to <span class="bolder-element">GPM’s bank account</span> as follows:</p>
                    <div style="padding-left: 5mm;">
                        {include file='BankDetails.tpl'|vtemplate_path:'Contacts' selected_bank=$SELECTED_BANK}
                    </div>
                </div>
            </div>

            <div class="additional-section" style="margin-top: 3.5mm">
                <div style="margin-bottom:1mm;" class="bolder-element">
                    4. This Shipment & Storage Order and any agreement with GPM resulting therefrom shall be subject to
                    and governed by the terms and conditions of Form A executed and entered into
                    by and between me/us and Global Precious Metals Pte. Ltd.
                </div>
            </div>

            <!-- SIGNATURE SECTION -->
            <div class="signature-section">
                <div class="signature-section-item">
                    <div class="signature-section-left">
                        <div class="editable-input-wrapper">
                            <span> Place:</span> <input type="text" name="place_input" class="custom-editable-input" />
                        </div>
                        <div class="editable-input-wrapper" style="margin-top: 3mm;">
                            <span>Date:</span> <input type="text" name="date_input" class="custom-editable-input" />
                        </div>
                    </div>

                    <div class="signature-section-right">
                        <div class="editable-input-wrapper">
                            <span> Signed by: </span>
                            <input type="text" name="signed_by" class="custom-editable-input" />
                        </div>
                        <div class="editable-input-wrapper" style="margin-top: 3mm;">
                            <span> On behalf of:</span>
                            <input type="text" name="on_behalf_of" class="custom-editable-input" />
                        </div>
                    </div>
                </div>

                <div>
                    <div class="signature-line">...............................................</div><br>
                    Signature
                </div>
            </div>
        </section>
    </div>

    <script>
        const checkboxes = document.querySelectorAll('.country-checkbox');

        if (checkboxes?.length) {
            checkboxes.forEach(function(checkbox) {
                checkbox.addEventListener('click', function(e) {
                    const name = e.target?.getAttribute('name');

                    const customInput = document.querySelector('.custom-country-input');

                    if (name == '5') {
                        if (customInput) customInput.focus();
                    } else {
                        if (customInput) customInput.value = '';
                    }

                    checkboxes.forEach(function(box) {
                        if (box !== e.target) box.checked = false;
                    });
                });
            });
        }

        document.getElementById('downloadBtn').addEventListener('click', function(e) {

            const checked = document.querySelector('input.country-checkbox:checked');

            const countryType = checked ? checked.getAttribute('name') : null;

            const customInput = document.querySelector('.custom-country-input');

            const url = new URL(this.href);

            if (countryType) {
                url.searchParams.set('countryOption', countryType);

                if (countryType == '5' && customInput) {
                    url.searchParams.set('customCountry', customInput.value || '');
                }
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