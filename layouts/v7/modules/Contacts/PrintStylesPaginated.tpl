.printAreaContainer {
    width: 210mm;
    height: 297mm;
    padding: 15mm;
    box-sizing: border-box;
    margin: 0 auto;
    position: relative;
    page-break-after: always;
    break-after: page;
}

.printAreaContainer:last-child {
    page-break-after: auto;
    break-after: auto;
}

@media print {
    @page {
        size: A4;
        margin: 0;
    }
}
