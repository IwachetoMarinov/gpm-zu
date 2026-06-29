{assign var="sansRegular" value="layouts/v7/resources/fonts/OpenSans-Regular.woff"}
{assign var="sansBold" value="layouts/v7/resources/fonts/OpenSans-Bold.woff"}

{if isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload eq true}
    {assign var="rootPath" value=$ROOT_DIRECTORY|replace:'\\':'/'}
    {assign var="sansRegular" value="file:///$rootPath/layouts/v7/resources/fonts/OpenSans-Regular.woff"}
    {assign var="sansBold" value="file:///$rootPath/layouts/v7/resources/fonts/OpenSans-Bold.woff"}
{/if}

@font-face {
    font-family: 'Open Sans';
    font-style: normal;
    font-weight: 400;
    src: url('{$sansRegular}') format('woff');
}

@font-face {
    font-family: 'Open Sans';
    font-style: normal;
    font-weight: 700;
    src: url('{$sansBold}') format('woff');
}

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: 'Open Sans';
    font-size: 9pt;
    color: #666;
}

.printAreaContainer {
    width: 200mm;
    height: 297mm;
    margin: auto;
    padding: 4mm;
}

.pdf-wrapper {
    position: relative;
    background-color: #fff;
    top: -7mm;
}

.bottom-container {
    display: flex;
    gap: 10mm;
}

.bottom-container-item {
    flex: 1;
}

.printAreaContainer .header-logo {
    width: 50%;
    height: 11mm;
}

.printAreaContainer .header-text {
    width: 50%;
    height: 11mm;
    color: #fff;
    background: #008ECA;
    font-weight: bold;
    font-size: 10pt;
}

.printAreaContainer .header-text span {
    font-weight: normal;
    color: #fff;
}

.printAreaContainer .print-tbl {
    border-collapse: collapse;
    width: 100%;
    border: none;
}

table.content-table th {
    border: 1px dotted #666666;
    font-size: 10pt;
    background: #ECECEC;
    font-weight: bold;
    padding: 4px
}

table.content-table tr.footer th {
    color: #008ECA;
}

table.content-table td {
    border: none;
    font-size: 10pt;
    font-weight: normal;
    padding: 4px
}

table.graph-table td {
    width: 50%;
    font-size: 10pt;
    padding: 4px 0px;
}

.graph-bar {
    height: 1.5mm
}

.graph-bar.blue {
    background: #008ECA;
}

.graph-bar.green {
    background: #BACE10;
}

.doted-bg {
    background: url(graph_bg.jpg);
    background-size: 338px auto;
}

table.activity-tbl {
    border-collapse: collapse;
    width: 100%;
    border: 1px solid #333;
}

table.activity-tbl td,
table.activity-tbl th {
    border: 1px solid #000;
    padding: 1mm 2mm;
    text-align: left;
}

.signed-item {
    width: 30%;
}

.behalf-item {
    flex: 1;
}

table.activity-tbl th {
    background: #bca263;
}

input[type="checkbox"] {
    width: 5mm;
    height: 5mm;
    vertical-align: middle;
    margin-right: 1.5mm;
    accent-color: #000;
}

.editable-input-wrapper {
    margin-top: 2mm;
    display: flex;
    align-items: center;
    gap: 2mm;
}

.editable-input {
    border: none;
    width: 40mm;
    min-width: 40mm;
    border-bottom: 1px dotted #000;
}

.editable-full-input {
    flex: 1;
}

.custom-checkbox {
    font-size: 3.5mm;
    border: 1px solid transparent;
    padding: 2px 2px;
    display: inline-block;
    height: 5mm;
    width: 5mm;
    line-height: 3.5mm;
    margin-bottom: 0.8mm;
}

.editable-input:focus {
    outline: none;
}

.signature-section {
    margin-top: 2mm;
    padding: 0 4mm;
}

.signature-section-item {
    display: flex;
    justify-content: space-between;
    margin-top: 0;
}

.signature-section-left {
    width: 40%;
}

.signature-section-right {
    width: 57%;
}

.custom-editable-input {
    border: none;
    position: relative;
    padding-bottom: 1mm;
    flex: 1;
    min-width: 40mm;
    border-bottom: 1px dotted #000;
}

.custom-editable-input:focus {
    outline: none;
}

.full-width {
    width: 100%;
}

.custom-editable-table-input {
    min-width: auto;
}

.input-without-border {
    border: none;
    width: 100%;
}

.editable-input-wrapper-gap {
    flex-wrap: wrap;
}

@media print {
    @page {
        size: A4;
        margin: 0;
    }
}
