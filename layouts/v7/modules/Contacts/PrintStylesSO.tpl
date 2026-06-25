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
    font-size: 10pt;
    color: #666;
}

.printAreaContainer {
    width: 210mm;
    height: 297mm;
    margin: auto;
    padding: 4mm;
}

.pdf-wrapper {
    position: relative;
    background-color: #fff;
    top: -7mm;
}

.header-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 2mm;
}

.header-table td {
    vertical-align: top;
}

.logo {
    width: 52mm;
}

.title {
    text-align: center;
    font-size: 13pt;
    font-weight: bold;
    padding-top: 1mm;
}

.company-box {
    width: 100%;
    height: 38mm;
    border: 1px solid #000;
    display: flex;
    margin-top: 1mm;
    font-size: 8.3pt;
}

.company-half {
    width: 50%;
    display: flex;
    flex-direction: column;
}

.company-left {
    border-right: 1px solid #000;
}

.company-top {
    height: 24mm;
    display: flex;
    border-bottom: 1px solid #000;
}

.company-bottom {
    height: 14mm;
    padding: 2mm;
    overflow: hidden;
}

.company-label {
    width: 18mm;
    padding: 2mm 0 0 2mm;
    border-right: 1px solid #000;
    flex-shrink: 0;
}

.company-content {
    flex: 1;
    padding: 2mm 2mm 0 2mm;
    overflow: hidden;
    line-height: 1.35;
}

.section-title {
    margin: 2mm 0;
}

.metals-table {
    width: 100%;
    border-collapse: collapse;
    border: 1px solid #000;
    font-size: 8pt;
    margin-top: 4mm;
    margin-bottom: 2mm;
    table-layout: fixed;
}

.metals-table th,
.metals-table td {
    border: 1px solid #000;
    padding: 0.6mm;
    text-align: center;
    overflow: hidden;
    word-wrap: break-word;
}

.metals-table th {
    background: #f0f0f0;
    font-weight: bold;
}

td.metal-row-label {
    text-align: left;
    font-weight: bold;
    padding-left: 2mm;
}

.serials-box {
    min-height: 15mm;
    padding: 2mm;
    margin-bottom: 2mm;
}

.additional-section {
    margin: 3mm 0;
    line-height: 1.4;
}

.additional-section strong {
    font-weight: bold;
}

.indent {
    margin-left: 5mm;
}

.bank-details {
    margin: 2mm 0;
}

.bank-row {
    margin-bottom: 1.5mm;
}

.signature-section {
    margin-top: 8mm;
}

.signature-section-item {
    display: flex;
    justify-content: space-between;
    margin-top: 4mm;
}

.signature-section-left {
    width: 40%;
}

.signature-section-right {
    width: 57%;
}

.signature-line {
    display: inline-block;
    margin-top: 5mm;
}

.main-table {
    border: 1px solid #000;
    margin-top: 3mm;
    padding: 2mm 1.5mm;
}

.bolder-element {
    font-weight: bold;
}

.details-container {
    padding: 0 4mm;
}

.editable-input-wrapper {
    display: flex;
    align-items: center;
    gap: 2mm;
}

.custom-editable-input {
    border: none;
    position: relative;
    padding-bottom: 1mm;
    flex: 1;
    min-width: 40mm;
    border-bottom: 1px dotted #000;
}

.metals-table .custom-editable-input {
    padding-top: 0.5mm;
    padding-bottom: 0.5mm;
    text-align: center;
}

.custom-editable-table-input {
    min-width: auto;
}

.custom-editable-input:focus {
    outline: none;
}

.full-width {
    width: 100%;
}
