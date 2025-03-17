report 70011 "Purchase Order Report"
{
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;
    RDLCLayout = '.vscode\ReportLayouts\\Rep.70011.PurchaseOrderReport.rdl';

    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            RequestFilterHeading = 'Purchase Order';
            column(ItemNo; "No.") { }
            column(ItemDescription; "Description") { }
            column(Barcode; SKU) { }
            column(Quantity; Quantity) { }
            column(VAT; "VAT %") { }
            column(UnitCost; "Unit Cost") { }
            column(VendorName; recVendor.Name) { }
            column(VendorCode; recVendor."No.") { }

            trigger OnPreDataItem()
            begin
                datefilter := "Purchase Line".GetFilter("Document No.");

            end;


            trigger OnAfterGetRecord()
            begin
                // CLEAR(recConsignType);
                // recConsignType.RESET;
                // recConsignType.SETRANGE(Code, "Consignment Entries"."Consignment Type");
                // IF recConsignType.FINDFIRST THEN;

                // CLEAR(recStore);
                // recStore.RESET;
                // IF recStore.GET("Consignment Entries"."Store No.") THEN;

                // CLEAR(recVend);
                // IF recVend.GET("Consignment Entries"."Vendor No.") THEN;

                // FormatAddr.GetCompanyAddr(recCompanyInfo."Responsibility Center", RespCenter, recCompanyInfo, CompanyAddr);
                // FormatAddr.Vendor(VendAddr, recVend);
            end;
        }
    }

    trigger OnPreReport()
    begin
        recVendor.SetRange("No.", "Purchase Line"."Buy-from Vendor No.");

        // recVendor.GET();
        // recCompanyInfo.CALCFIELDS(Picture);
    end;

    var
        RespCenter: Record "Responsibility Center";
        recStore: Record "LSC Store";
        recCompanyInfo: Record "Company Information";
        recVend: Record Vendor;
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[10] of Text[50];
        VendAddr: array[10] of Text[50];
        DateFilter: text[250];


        recVendor: Record "Vendor";
        VendorName: text[250];
        VendorCode: text[250];
        ReferenceNo: text[250];
        PurchaseDate: text[250];
        SKU: text[250];

}