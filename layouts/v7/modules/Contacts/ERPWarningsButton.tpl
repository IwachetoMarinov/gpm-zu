{* ERPWarningsButton.tpl *}

{assign var="erpWarningExcludes" value=$ERP_WARNING_EXCLUDES|default:[]}
{assign var="erpWarningsCount" value=0}
{assign var="erpWarnings" value=[]}

{if isset($ERP_WARNING_DATA->_warnings)}
    {assign var="erpWarnings" value=$ERP_WARNING_DATA->_warnings}
{elseif isset($ERP_WARNING_DATA['_warnings'])}
    {assign var="erpWarnings" value=$ERP_WARNING_DATA['_warnings']}
{/if}

{foreach from=$erpWarnings item=warning}
    {assign var="warningField" value=$warning.field|default:''}

    {if !$warningField || !in_array($warningField, $erpWarningExcludes)}
        {assign var="erpWarningsCount" value=$erpWarningsCount+1}
    {/if}
{/foreach}

{if $erpWarningsCount gt 0}
    <button
        type="button"
        class="erp-warning-btn {$ERP_WARNING_CLASS|default:'erp-fields-warning'}"
        data-warning-title="{$ERP_WARNING_TITLE|default:'ERP Mapping Warnings'|escape:'html'}"
        data-warning-message="
            <div>
                <h4 style='margin-top:0;color:#b94a48;'>
                    {$ERP_WARNING_TITLE|default:'ERP Mapping Warnings'|escape:'html'} ({$erpWarningsCount})
                </h4>

                <ul style='margin:0;padding-left:20px;'>
                    {foreach from=$erpWarnings item=warning}
                        {assign var='warningField' value=$warning.field|default:''}

                        {if !$warningField || !in_array($warningField, $erpWarningExcludes)}
                            <li style='margin-bottom:6px;'>
                                {$warning.message|default:$warning|escape:'html'}
                            </li>
                        {/if}
                    {/foreach}
                </ul>
            </div>
        "
    >
        {$ERP_WARNING_BUTTON_LABEL|default:'ERP Mapping Warnings'|escape:'html'} ({$erpWarningsCount})
    </button>
{/if}