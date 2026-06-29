{include file='PrintStylesFonts.tpl'|vtemplate_path:'Contacts'}

* {
    box-sizing: border-box;
    margin: 0px
}

.printAreaContainer {
    height: 297mm;
    width: 210mm;
    border: 1px solid #fff;
    margin: auto;
    padding: 6mm 9mm;
    position: relative;
}

.text-content {
    font-size: 9.75pt !important;
}

.bottom-container {
    display: flex;
    gap: 10mm;
}

.bottom-container-item {
    flex: 1;
}

.printAreaContainer * {
    box-sizing: border-box;
    font-family: 'Open Sans';
    color: #666;
}

.printAreaContainer .full-width {
    width: 100%;
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
    font-size: 9.5pt;
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
    font-size: 9.5pt;
    background: #ECECEC;
    font-weight: bold;
    padding: 4px
}

table.content-table tr.footer th {
    color: #008ECA;
}

table.content-table td {
    border: none;
    font-size: 9.5pt;
    font-weight: normal;
    padding: 4px
}

table.graph-table td {
    width: 50%;
    font-size: 9.5pt;
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
