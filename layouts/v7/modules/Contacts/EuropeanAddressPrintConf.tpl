<style>
    #europeanAddressModal {
        display: none;
        position: fixed;
        z-index: 9999;
        padding-top: 100px;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgba(0, 0, 0, 0.4);
    }

    #europeanAddressModal .modal-content {
        background-color: #fefefe;
        margin: auto;
        padding: 20px;
        border: 1px solid #888;
        width: 25%;
        max-width: 92%;
    }

    #europeanAddressModal .printConfClose {
        color: #aaaaaa;
        float: right;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
    }

    #europeanAddressModal .printConfClose:hover,
    #europeanAddressModal .printConfClose:focus {
        color: #000;
        text-decoration: none;
    }

    #europeanAddressPrintConfSave {
        color: #fff;
        text-align: center;
        padding: 10px;
        text-decoration: none;
        background-color: #bea364;
        display: inline-block;
    }
</style>

<div id="europeanAddressModal">
    <div class="modal-content">
        <span class="printConfClose">&times;</span>
        <h2 style="margin-top:0;">Print Settings</h2>
        <br>
        <span style="margin-top: 10px; display:block">
            European Address :
            <input type="checkbox" id="europeanAddress" name="europeanAddress" value="1"
                {if $smarty.request.europeanAddress eq '1' || $smarty.request.europeanAddress eq 1}checked{/if}>
        </span>
        <br>
        <a id="europeanAddressPrintConfSave"
            href="index.php?module=Contacts&view={$PRINT_CONF_VIEW}&record={$RECORD_MODEL->getId()}&docNo={$smarty.request.docNo}{$PRINT_CONF_QUERY|default:''}">
            Save
        </a>
    </div>
</div>

<script type="text/javascript">
    jQuery(function ($) {
        $('body').on('click', '#printConf', function (e) {
            e.preventDefault();
            $('#europeanAddressModal').show();
        });

        $('body').on('click', '#europeanAddressModal .printConfClose', function (e) {
            e.preventDefault();
            $('#europeanAddressModal').hide();
        });

        $('body').on('click', '#europeanAddressModal', function (e) {
            if (e.target && e.target.id === 'europeanAddressModal') {
                $('#europeanAddressModal').hide();
            }
        });

        $('body').on('click', '#europeanAddressPrintConfSave', function (e) {
            e.preventDefault();

            var europeanAddress = $('#europeanAddress').is(':checked') ? 1 : 0;
            var baseUrl = $(this).attr('href');

            window.location.href = baseUrl + '&europeanAddress=' + europeanAddress;
        });
    });
</script>
