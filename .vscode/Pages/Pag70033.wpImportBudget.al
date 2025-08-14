page 70033 "Import Budget. Data"
{
    ApplicationArea = All;
    Caption = 'Import Budget. Data';
    PageType = List;
    SourceTable = "wp Import Budget. Data";
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = True;
    DeleteAllowed = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Editable = False;
                }
                field("Store No"; Rec."StoreNo")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field("Class Code"; Rec."ClassCode")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Level; Rec.Level)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Pos Terminal No"; Rec."Pos Terminal No")
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Division Code"; Rec."DivisionCode")
                {
                    ToolTip = 'Specifies the value of the Description 2 field.', Comment = '%';
                }
                field("TotalSales"; Rec."TotalSales")
                {
                    ToolTip = 'Specifies the value of the UOM Code field.', Comment = '%';
                }

                field("No. of Errors"; Rec."No. of Errors")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = true;
                    Editable = false;
                    StyleExpr = NoOfErrorsStyleTxt;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            Group(ImportData)
            {

                action(BudgetData)
                {
                    Caption = 'Import Budget Data';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    PromotedIsBig = false;
                    trigger OnAction()
                    var
                        ImportBudget: record "wp Import Budget. Data";
                        ImportBudgetError: Record "wp Import Budget. Error";

                    begin
                        // ImportBudget.DeleteAll();
                        // ImportBudgetError.DeleteAll();
                        ReadExcelSheet();
                        ImportExcelData_Budget();
                        Clear(gRec_TempExcelBuffer);
                    end;
                }
                action(CheckBudgetData)
                {
                    Caption = 'Check Budget. Data';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    PromotedIsBig = false;
                    trigger OnAction()
                    var
                        ImportBudget: record "wp Import Budget. Data";
                        ImportBudgetError: Record "wp Import Budget. Error";

                    begin
                        ImportBudgetError.DeleteAll();
                        ImportBudget.RESET;
                        IF ImportBudget.FindSet() then
                            repeat
                                CheckDetailLine(ImportBudget);
                            UNtil ImportBudget.NEXT = 0;
                    end;
                }
            }
        }
    }
    var
        FileName: Text[100];
        SheetName: Text[100];
        gRec_TempExcelBuffer: Record "Excel Buffer" temporary;
        NoFileFoundMsg: Label 'No Excel file found!';
        RecordsXofYMsg: Label 'Processing %1 of %2 records';
        gCU_ConfigProgressBar: Codeunit "Config. Progress Bar";
        NoOfErrorsStyleTxt: Text;
        gInt_LastLineNo: Integer;


    trigger OnAfterGetRecord()
    begin
        NoOfErrorsStyleTxt := Rec.SetFieldStyle(Rec.FieldNo("No. of Errors"));
    end;

    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: Instream;
        FromFile: Text[100];
        UploadExcelMsg: Text[200];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);

        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := gRec_TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        gRec_TempExcelBuffer.Reset();
        gRec_TempExcelBuffer.DeleteAll();
        gRec_TempExcelBuffer.OpenBookStream(IStream, SheetName);
        gRec_TempExcelBuffer.ReadSheet();
    end;

    procedure GetExcelValueAsText(var pRec_ExcelBuf: Record "Excel Buffer"; pRowID: Integer; pColumnID: Integer): Text
    var
        return: Text;
    begin
        return := '';
        pRec_ExcelBuf.Reset();
        if (pRec_ExcelBuf.Get(pRowID, pColumnID)) then begin
            if (pRec_ExcelBuf."Cell Value as Text" <> '') then begin
                Evaluate(return, pRec_ExcelBuf."Cell Value as Text");
            end;
        end;
        exit(return);
    end;

    procedure GetExcelValueAsDecimal(var pRec_ExcelBuf: Record "Excel Buffer"; pRowID: Integer; pColumnID: Integer): Decimal
    var
        returnValue: Decimal;
        cellText: Text;
    begin
        returnValue := 0;

        pRec_ExcelBuf.Reset();
        if pRec_ExcelBuf.Get(pRowID, pColumnID) then begin
            cellText := pRec_ExcelBuf."Cell Value as Text";

            if cellText <> '' then
                if not Evaluate(returnValue, cellText) then
                    Error('Không thể chuyển "%1" thành kiểu Decimal.', cellText);
        end;

        exit(returnValue);
    end;

    procedure GetExcelValueAsDate(var pRec_ExcelBuf: Record "Excel Buffer"; pRowID: Integer; pColumnID: Integer): Date
    var
        return: Date;
    begin
        return := 0D;
        pRec_ExcelBuf.Reset();
        if (pRec_ExcelBuf.Get(pRowID, pColumnID)) then begin
            if (pRec_ExcelBuf."Cell Value as Text" <> '') then begin
                Evaluate(return, pRec_ExcelBuf."Cell Value as Text");
            end;
        end;
        exit(return);
    end;

    local procedure ImportExcelData_Budget()
    var
        ImportBudgetData: Record "wp Import Budget. Data";
        IsImportBudgetDataCheck: Record "wp Import Budget. Data";
        RowNo: Integer;
        ColNo: Integer;
        MaxRowNo: Integer;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;

        gRec_TempExcelBuffer.Reset();
        if gRec_TempExcelBuffer.FindLast() then begin
            MaxRowNo := gRec_TempExcelBuffer."Row No.";
        end;

        gCU_ConfigProgressBar.Init(MaxRowNo, 1000, 'Importing data of Budget...');

        //Check LineNo
        clear(IsImportBudgetDataCheck);
        IsImportBudgetDataCheck.SetCurrentKey("Line No.");
        if IsImportBudgetDataCheck.FindLast() then
            gInt_LastLineNo := IsImportBudgetDataCheck."Line No."
        else
            gInt_LastLineNo := 1000;

        for RowNo := 2 to MaxRowNo do begin
            Clear(ImportBudgetData);
            ImportBudgetData."Line No." := gInt_LastLineNo + 1000;
            ImportBudgetData."StoreNo" := GetExcelValueAsText(gRec_TempExcelBuffer, RowNo, 1);
            ImportBudgetData.DivisionCode := GetExcelValueAsText(gRec_TempExcelBuffer, RowNo, 2);
            ImportBudgetData.ClassCode := GetExcelValueAsText(gRec_TempExcelBuffer, RowNo, 3);
            ImportBudgetData.Level := GetExcelValueAsText(gRec_TempExcelBuffer, RowNo, 4);
            ImportBudgetData."Pos Terminal No" := GetExcelValueAsText(gRec_TempExcelBuffer, RowNo, 5);
            Evaluate(ImportBudgetData.Date, GetExcelValueAsText(gRec_TempExcelBuffer, RowNo, 6));
            ImportBudgetData.TotalSales := GetExcelValueAsDecimal(gRec_TempExcelBuffer, RowNo, 7);

            // IF GetExcelValueAsText(gRec_TempExcelBuffer, RowNo, 9) <> '' THEN
            //     Evaluate(ImportBudgetData."Line Discount TotalSales", GetExcelValueAsText(gRec_TempExcelBuffer, RowNo, 9))
            // else
            //     ImportBudgetData."Line Discount TotalSales" := 0;

            //Check đã có chưa
            clear(IsImportBudgetDataCheck);
            IsImportBudgetDataCheck.SetRange(StoreNo, ImportBudgetData.StoreNo);
            IsImportBudgetDataCheck.SetRange(Date, ImportBudgetData.Date);
            IsImportBudgetDataCheck.SetRange(DivisionCode, ImportBudgetData.DivisionCode);
            IsImportBudgetDataCheck.SetRange(ClassCode, ImportBudgetData.ClassCode);
            IsImportBudgetDataCheck.SetRange(Level, ImportBudgetData.Level);
            IsImportBudgetDataCheck.SetRange("Pos Terminal No", ImportBudgetData."Pos Terminal No");
            if not IsImportBudgetDataCheck.FindFirst() then begin
                If ImportBudgetData.Insert() then
                    gInt_LastLineNo := ImportBudgetData."Line No.";
            end else begin
                IsImportBudgetDataCheck.TotalSales := ImportBudgetData.TotalSales;
                IsImportBudgetDataCheck.Modify();
            end;

            gCU_ConfigProgressBar.Update(StrSubstNo(RecordsXofYMsg, RowNo, MaxRowNo));
        end;

        gCU_ConfigProgressBar.Close;
    end;

    procedure CheckDetailLine(CurrImportBudget: record "wp Import Budget. Data"): Boolean
    var
        Vend: record Vendor;
        Currencies: record Currency;
        ItemCharge: record "Item Charge";
        FixAsset: record "Fixed Asset";
        GLAcc: record "G/L Account";
        CurrItem: record Item;
        CurrResource: record Resource;
        Loc: record Location;
        UOM: record "Unit of Measure";
        ItemUOM: record "Item Unit of Measure";
        ResourceUOM: record "Resource Unit of Measure";
        ItemTrackCode: record "Item Tracking Code";
        isCheck: Boolean;

    begin
        // IF NOT Vend.GET(CurrImportBudget."StoreNo") then
        //     InsertBudgetError(CurrImportBudget, 'Buy from Vendor No. value is invalid, cannot be found in the releated table (Vendor)');
        isCheck := true;

        IF CurrImportBudget."Date" = 0D then
            isCheck := InsertBudgetError(CurrImportBudget, 'Document Date value is invalid');
        IF (CurrImportBudget."StoreNo" = '') then
            isCheck := InsertBudgetError(CurrImportBudget, 'Store No value is empty');
        IF (CurrImportBudget."DivisionCode" = '') then
            isCheck := InsertBudgetError(CurrImportBudget, 'Division Code value is empty');
        IF (CurrImportBudget."ClassCode" = '') then
            isCheck := InsertBudgetError(CurrImportBudget, 'Class Code value is empty');
        IF (CurrImportBudget."Level" = '') then
            isCheck := InsertBudgetError(CurrImportBudget, 'Level value is empty');
        IF (CurrImportBudget."TotalSales" = 0) then
            isCheck := InsertBudgetError(CurrImportBudget, 'TotalSales value is empty');
        IF (CurrImportBudget."TotalSales" = 0) then
            isCheck := InsertBudgetError(CurrImportBudget, 'TotalSales value is empty');

        exit(isCheck);
    end;

    procedure InsertBudgetError(CurrImportBudget: record "wp Import Budget. Data"; ErrorDesc: Text[100]): Boolean
    var
        BudgetError: Record "wp Import Budget. Error";
        LastEntryNo: Integer;
        ILE: record "Item Ledger Entry";
    begin
        BudgetError.Reset();
        IF BudgetError.FindLast() then
            LastEntryNo := BudgetError."Entry No.";
        BudgetError.INIT;
        BudgetError."Entry No." := LastEntryNo + 1;
        BudgetError."Line No." := CurrImportBudget."Line No.";
        BudgetError."Error Description" := ErrorDesc;
        BudgetError.INSERT;

        error(ErrorDesc);
        exit(false);
    end;
}
