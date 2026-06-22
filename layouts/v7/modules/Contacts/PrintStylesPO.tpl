{assign var="sansRegular" value="layouts/v7/resources/fonts/OpenSans-Regular.ttf"}
{assign var="sansBold" value="layouts/v7/resources/fonts/OpenSans-Bold.ttf"}

{if isset($smarty.request.PDFDownload) || $smarty.request.PDFDownload eq true}
    {assign var="rootPath" value=$ROOT_DIRECTORY|replace:'\\':'/'}
    {assign var="sansRegular" value="file:///$rootPath/layouts/v7/resources/fonts/OpenSans-Regular.ttf"}
    {assign var="sansBold" value="file:///$rootPath/layouts/v7/resources/fonts/OpenSans-Bold.ttf"}
{/if}

@font-face {
    font-family: 'Open Sans';
    font-style: normal;
    font-weight: 400;
    src: url('{$sansRegular}') format('truetype');
}

@font-face {
    font-family: 'Open Sans';
    font-style: normal;
    font-weight: 700;
    src: url('{$sansBold}') format('truetype');
}

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: 'Open Sans';
    font-size: 8pt;
    color: #666;
}

#downloadBtn,
.select2-container {
    font-size: 12pt;
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
}

.table-heading {
    margin-bottom: 2mm;
}

.header-table td {
    vertical-align: top;
}

.title {
    text-align: center;
    font-size: 12pt;
    font-weight: bold;
    padding-top: 1mm;
}

.company-box {
    width: 100%;
    height: 38mm;
    border: 1px solid #000;
    display: flex;
    margin-top: 1mm;
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
    margin: 2mm 0 1mm 2mm;
}

.metals-table {
    width: 100%;
    border-collapse: collapse;
    border: 1px solid #000;
    font-size: 8pt;
    margin-bottom: 2mm;
    table-layout: fixed;
}

.metals-table th,
.metals-table td {
    border: 1px solid #000;
    padding: 1mm;
    text-align: center;
}

.metals-table th {
    background-color: #f0f0f0;
    font-weight: bold;
}

td.metal-row-label {
    text-align: left;
    font-weight: bold;
    padding-left: 2mm;
}

.serials-box {
    padding: 1.5mm;
}

.additional-section {
    margin: 1mm 0;
    line-height: 1.4;
}

.additional-section strong {
    font-weight: bold;
}

.indent {
    margin-left: 5mm;
}

.line {
    display: inline-block;
}

.long-line {
    display: inline-block;
}

.bank-details {
    margin: 2mm 0;
}

.bank-row {
    margin-bottom: 1.5mm;
}

.signature-section {
    margin-top: 4mm;
    padding: 0 2mm;
}

.signature-line {
    display: inline-block;
    margin-top: 4mm;
}

.main-table {
    border: 1px solid #000;
    margin-top: 1mm;
    padding: 2mm;
}

.bolder-element {
    font-weight: bold;
}

.details-container {
    padding: 0 4mm;
}

.signature-section-item {
    display: flex;
    justify-content: space-between;
    margin-top: 2mm;
}

.signature-section-left {
    width: 40%;
}

.signature-section-right {
    width: 57%;
}

input[type="checkbox"] {
    width: 5mm;
    height: 5mm;
    vertical-align: middle;
    margin-right: 1.5mm;
    accent-color: #000;
}

.bank-codes-container {
    display: flex;
    gap: 10mm;
}

.bank-details-container {
    display: flex;
}

.bank-details-item {
    width: 50%;
}

.bank-item {
    margin-bottom: 1mm;
}

.editable-input-wrapper {
    display: flex;
    align-items: center;
    gap: 2mm;
}

.custom-editable-input {
    border: none;
    position: relative;
    padding-bottom: 0.5mm;
    flex: 1;
    min-width: 40mm;
    border-bottom: 1px dotted #000;
}

.metals-table .custom-editable-input {
    padding-top: 0.5mm;
    padding-bottom: 0.5mm;
    text-align: center;
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

.custom-checkbox {
    font-size: 3.5mm;
    border: 1px solid transparent;
    padding: 2px 2px;
    display: inline-block;
    height: 5mm;
    width: 5mm;
    line-height: 3.5mm;
}

.company-heading {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    font-size: 7.5pt;
}

@page {
    size: A4;
    margin: 0;
}

html,
body {
    margin: 0;
    padding: 0;
}
