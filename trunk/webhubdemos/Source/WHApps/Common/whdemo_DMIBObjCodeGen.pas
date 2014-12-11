unit whdemo_DMIBObjCodeGen;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2012-2014 HREF Tools Corp.  All Rights Reserved Worldwide. * }
{ *                                                                          * }
{ * This source code file is part of WebHub v3.1x.  Please obtain a WebHub   * }
{ * development license from HREF Tools Corp. before using this file, and    * }
{ * refer friends and colleagues to http://www.href.com/webhub. Thanks!      * }
{ ---------------------------------------------------------------------------- }

{ ---------------------------------------------------------------------------- }
{ * Requires IBObjects from www.ibobjects.com                                * }
{ * Requires Firebird SQL Database                                           * }
{ * Requires WebHub v2.175+                                                  * }
{ *                                                                          * }
{ * EXTREMELY EXPERIMENTAL !                                                 * }
{ *                                                                          * }
{ ---------------------------------------------------------------------------- }

interface

uses
  SysUtils, Classes, StdCtrls,
  IB_Components,
  ucIBObjCodeGen,
  webLink, whutil_RegExParsing, whCodeGenIBObj;

type
  TGUIWriteInfoProc = reference to procedure(const MesssageToUser: string);

type
  TCodeGenPattern = (cgpMacroLabelsForFields, cgpMacroPKsForTables,
    cgpFieldListForImport, cgpSelectSQLDroplet, cgpUpdateSQLDroplet,
    cgpInstantFormReadonly, cgpInstantFormEdit, cgpInstantFormEditLabelAbove,
    cgpInstantFormInsert,
    cgpTableHeaderCells, cgpTableRowCells, cgpTableDropletForScan);

type
  TDMIBObjCodeGen = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    FProjectAbbreviationNoSpaces: string;
    FUpdatedByFieldname: string;
    FUpdatedOnAtFieldname: string;
    FUpdateCounterFieldname: string;
    FCounter: Integer;
    FLastFieldWasHidden: Boolean;
    FFieldsPerRowInInstantForm: Integer;
    FAttributeParser: TAttributeParser;
    procedure WebAppUpdate(Sender: TObject);
  private
    FDatabaseIterator: TwhDatabaseIterator;
    FActiveConn: TIB_Connection;
    FActiveTr: TIB_Transaction;
    FActiveSess: TIB_Session;
    function RawTypeToHTMLSize(const RawFirebirdType: Integer;
      Cursor: TIB_Cursor): Integer;
  private
    procedure MacroLabelsForFields(const CurrentTable: string;
      const ThisTableFieldCount, FieldNum: Integer;
      const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure MacroPKsForTables(const currTable: string;
      const primaryKeyFieldname: string; out Value: string);
    procedure FieldListForImport(const CurrentTable: string;
      const ThisTableFieldCount, FieldNum: Integer;
      const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure SelectSQLDroplet(const currTable: string;
      const primaryKeyFieldname: string; out Value: string);
    procedure UpdateSQLDropletA(const CurrentTable: string;
      const ThisTableFieldCount, FieldNum: Integer;
      const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure UpdateSQLDropletB(const CurrentTable: string;
      const ThisTableFieldCount, FieldNum: Integer;
      const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure InstantFormReadonly(const CurrentTable: string;
      const ThisTableFieldCount, FieldNum: Integer;
      const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);

    procedure InstantFormEditOrInsert(const FlagBlankValues: Boolean;
      const CurrentTable: string;
      const ThisTableFieldCount, FieldNum: Integer;
      const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);

    procedure InstantFormEdit(const CurrentTable: string;
      const ThisTableFieldCount, FieldNum: Integer;
      const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure InstantFormInsert(const CurrentTable: string;
      const ThisTableFieldCount, FieldNum: Integer;
      const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure InstantFormEditLabelAbove(const CurrentTable: string;
      const ThisTableFieldCount, FieldNum: Integer;
      const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure TableHeaderCells(const CurrentTable: string;
      const ThisTableFieldCount, FieldNum: Integer;
      const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure TableRowCells(const CurrentTable: string;
      const ThisTableFieldCount, FieldNum: Integer;
      const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);

    procedure TableDropletForScan(const currTable: string;
      const primaryKeyFieldname: string; out Value: string);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
    function CodeGenForPattern(conn: TIB_Connection; TableList: TStringList;
      const CodeGenPattern: TCodeGenPattern;
      AdjustTableListProc: TAdjustTableListProc = nil): string;
    procedure GenPASandSQL(inProjectAbbrev: string; const IsInterbase: Boolean;
      conn: TIB_Connection; sess: TIB_Session; tr: TIB_Transaction;
      const PASOutputFolder, SQLOutputFolder: string;
      GUIWriteInfoProc: TGUIWriteInfoProc;
      AdjustTableListProc: TAdjustTableListProc;
      GeneratorNameFn: TtpcgGeneratorNameFn);
    function LabelForField(const CurrentTable: string;
      const FieldNum: Integer; const CurrentFieldname: string;
      Cursor: TIB_Cursor): string;
    function ProcessCodeGenForPattern(AListBox: TListBox; conn: TIB_Connection;
      GUIWriteInfoProc: TGUIWriteInfoProc;
      AdjustTableListProc: TAdjustTableListProc): string;
    function ProjectAbbrevForCodeGen: string;
    property ActiveConn: TIB_Connection read FActiveConn write FActiveConn;
    property ActiveTr: TIB_Transaction read FActiveTr write FActiveTr;
    property ActiveSess: TIB_Session read FActiveSess write FActiveSess;
    property Counter: Integer read FCounter write FCounter;
    property DatabaseIterator: TwhDatabaseIterator read FDatabaseIterator
      write FDatabaseIterator;
    property FieldsPerRowInInstantForm: Integer read FFieldsPerRowInInstantForm
      write FFieldsPerRowInInstantForm;
    property ProjectAbbreviationNoSpaces: string
      read FProjectAbbreviationNoSpaces write FProjectAbbreviationNoSpaces;
    property UpdatedByFieldname: string read FUpdatedByFieldname
      write FUpdatedByFieldname;
    property UpdatedOnAtFieldname: string
      read FUpdatedOnAtFieldname write FUpdatedOnAtFieldname;
    property UpdateCounterFieldname: string read FUpdateCounterFieldname
      write FUpdateCounterFieldname;
  end;

var
  DMIBObjCodeGen: TDMIBObjCodeGen;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  IB_Header,
  TypInfo, Forms,
  webApp, htWebApp, whMacroAffixes,
  ucString, ucCodeSiteInterface, ucIbAndFbCredentials;

{ TDMIBObjCodeGen }

procedure TDMIBObjCodeGen.GenPASandSQL(inProjectAbbrev: string;
  const IsInterbase: Boolean; conn: TIB_Connection; sess: TIB_Session;
  tr: TIB_Transaction; const PASOutputFolder, SQLOutputFolder: string;
  GUIWriteInfoProc: TGUIWriteInfoProc;
  AdjustTableListProc: TAdjustTableListProc;
  GeneratorNameFn: TtpcgGeneratorNameFn);
const cFn = 'GenPASandSQL';
var
  Flag: Boolean;
  y: TStringList;
  Filespec: string;
begin
  inherited;
  y := nil;

  if Assigned(conn) and Assigned(tr) and Assigned(sess) then
  begin
    FActiveConn := conn;
    GUIWriteInfoProc('Starting... takes time depending on connection speed');
    GUIWriteInfoProc('');
    GUIWriteInfoProc('DatabaseName: ' + conn.DatabaseName);
    GUIWriteInfoProc('Credentials: ' + conn.Username + #9 + conn.Password);
    GUIWriteInfoProc('');

    conn.Connect;

    try
      Firebird_GetTablesInDatabase(y, Flag, conn.DatabaseName, conn, tr,
        conn.Username, conn.Password);

      if Assigned(y) then
      begin
        AdjustTableListProc(y);
        Filespec := IncludeTrailingPathDelimiter(SQLOutputFolder) +
          InProjectAbbrev + '_Triggers.sql';
        IbAndFb_GenSQL_Triggers(y, conn, Filespec,
          GeneratorNameFn,
          UpdatedOnAtFieldname, UpdateCounterFieldName);
        GUIWriteInfoProc(Filespec);
        GUIWriteInfoProc('');

        Filespec := IncludeTrailingPathDelimiter(PASOutputFolder) +
          'uStructureClientDataSets_' + InProjectAbbrev + '.pas';
        Firebird_GenPAS_StructureClientDatasets(y, conn, InProjectAbbrev,
          Filespec);
        GUIWriteInfoProc(Filespec);
        GUIWriteInfoProc('');

        Filespec := IncludeTrailingPathDelimiter(PASOutputFolder) + 'u';
        if IsInterbase then
          Filespec := Filespec + 'Interbase'
        else
          Filespec := Filespec + 'Firebird';
        Filespec := Filespec + '_SQL_Snippets_' + InProjectAbbrev + '.pas';
        Firebird_GenPAS_SQL_Snippets(y, conn, InProjectAbbrev, Filespec,
          FUpdatedOnAtFieldname, FUpdateCounterFieldname);
        GUIWriteInfoProc(Filespec);
        GUIWriteInfoProc('');

        // The project may never use TClientDataSet
        // BUT: it helps to have the Fill code for copy and paste samples
        Filespec := IncludeTrailingPathDelimiter(PASOutputFolder) +
          'uFillClientDataSets_' + InProjectAbbrev + '.pas';
        Firebird_GenPAS_FillClientDatasets(y, conn, InProjectAbbrev, Filespec);
        GUIWriteInfoProc(Filespec);
        GUIWriteInfoProc('');

        Filespec := IncludeTrailingPathDelimiter(PASOutputFolder) + 'u';
        if IsInterbase then
          Filespec := Filespec + 'Interbase'
        else
          Filespec := Filespec + 'Firebird';
        Filespec := Filespec + '_RecordStruct_' + InProjectAbbrev + '.pas';
        Firebird_GenPAS_RecordStruct(y, conn, InProjectAbbrev, Filespec);
        GUIWriteInfoProc(Filespec);
        GUIWriteInfoProc('');
      end;
    finally
      FreeAndNil(y);
    end;
    conn.DisconnectToPool;
    GUIWriteInfoProc(cFn + ' Done! ' + FormatDateTime('dddd hh:nn:ss', Now));
  end
  else
    GUIWriteInfoProc('Programmer Error: connection, transaction and session ' +
      'must be assigned and ready to use.');
end;

function TDMIBObjCodeGen.ProcessCodeGenForPattern(AListBox: TListBox;
  conn: TIB_Connection;
  GUIWriteInfoProc: TGUIWriteInfoProc;
  AdjustTableListProc: TAdjustTableListProc): string;
var
  y: TStringList;
  Flag: Boolean;
  CodeContent: string;
  listIdx: Integer;
begin
  inherited;
  y := nil;

  if Assigned(conn) then
  begin
    FActiveConn := conn;

    GUIWriteInfoProc('<whdoc for="' + FActiveConn.DatabaseName +
      '">');
    GUIWriteInfoProc('Content based on Firebird SQL meta data');
    GUIWriteInfoProc('As of ' + FormatDateTime('dddd dd-MMM-yyyy hh:nn', Now));
    GUIWriteInfoProc('</whdoc>');
    Application.ProcessMessages;
    FActiveConn.Connect;
    GUIWriteInfoProc('');

    try
      Firebird_GetTablesInDatabase(y, Flag, FActiveConn.DatabaseName,
        FActiveConn, FActiveTr, FActiveConn.Username, FActiveConn.Password);
      if Assigned(AdjustTableListProc) then
        AdjustTableListProc(y);

      for listIdx := 0 to Pred(AListBox.Count) do
      begin
        if AListBox.Selected[listIdx] then
        case listIdx of
         0: CodeContent := DMIBObjCodeGen.CodeGenForPattern(
          FActiveConn, y, cgpMacroLabelsForFields);
         1: CodeContent := DMIBObjCodeGen.CodeGenForPattern(
          FActiveConn, y, cgpMacroPKsForTables);
         2: CodeContent := DMIBObjCodeGen.CodeGenForPattern(
          FActiveConn, y, cgpFieldListForImport);
         3: CodeContent := DMIBObjCodeGen.CodeGenForPattern(
          FActiveConn, y, cgpSelectSQLDroplet);
         4: CodeContent := DMIBObjCodeGen.CodeGenForPattern(
          FActiveConn, y, cgpUpdateSQLDroplet);
         5: CodeContent := DMIBObjCodeGen.CodeGenForPattern(
          FActiveConn, y, cgpInstantFormReadonly);
         6: CodeContent := DMIBObjCodeGen.CodeGenForPattern(
          FActiveConn, y, cgpInstantFormEdit);
         7: CodeContent := DMIBObjCodeGen.CodeGenForPattern(
          FActiveConn, y, cgpInstantFormEditLabelAbove);
         8: CodeContent := DMIBObjCodeGen.CodeGenForPattern(
           FActiveConn, y, cgpInstantFormInsert);
         9: CodeContent := DMIBObjCodeGen.CodeGenForPattern(
          FActiveConn, y, cgpTableHeaderCells);
        10: CodeContent := DMIBObjCodeGen.CodeGenForPattern(
          FActiveConn, y, cgpTableRowCells);
        11: CodeContent := DMIBObjCodeGen.CodeGenForPattern(
          FActiveConn, y, cgpTableDropletForScan, AdjustTableListProc);
        else
          GUIWriteInfoProc('Unsupported selection in ' + AListBox.ClassName);
        end
        else
          CodeContent := '';
        if CodeContent <> '' then
        begin
          GUIWriteInfoProc( CodeContent );
          GUIWriteInfoProc('');
        end;
      end;
      Application.ProcessMessages;
    finally
      FreeAndNil(y);
    end;

    FActiveConn.DisconnectToPool;
  end;
end;

function TDMIBObjCodeGen.CodeGenForPattern(conn: TIB_Connection;
  TableList: TStringList; const CodeGenPattern: TCodeGenPattern;
  AdjustTableListProc: TAdjustTableListProc = nil): string;
var
  i: Integer;
  CodeContent: string;
  FlagWasConnected: Boolean;
begin
  inherited;
  Result := '';
  FActiveConn := conn;

  FlagWasConnected := conn.Connected;
  if NOT FlagWasConnected then conn.Connect;

  CodeContent := '';
  case CodeGenPattern of
    cgpMacroLabelsForFields,
    cgpMacroPKsForTables: CodeContent := '<whmacros>' + sLineBreak;
  end;

  for i := 0 to Pred(TableList.Count) do
  begin
    case CodeGenPattern of
      cgpMacroLabelsForFields:
        CodeContent := CodeContent +
          Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
          MacroLabelsForFields);

      cgpMacroPKsForTables:
        if i = 0 then  // no additional table looping
          CodeContent := CodeContent +
            Firebird_GenPAS_For_Each_Table(conn, MacroPKsForTables,
              AdjustTableListProc);

      cgpFieldListForImport:
        CodeContent := CodeContent + ';; ' + TableList[i] + sLineBreak +
          '[FieldList]' + sLineBreak +
          Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
          FieldListForImport) + sLineBreak;

      cgpSelectSQLDroplet:
        if i = 0 then  // no additional table looping
          CodeContent := CodeContent +
            Firebird_GenPAS_For_Each_Table(conn, SelectSQLDroplet,
              AdjustTableListProc);

      cgpUpdateSQLDroplet:
        CodeContent := CodeContent +
          '<whdroplet name="' + Format('dr%s-UpdateSQL', [TableList[i]]) +
          '">' + sLineBreak +
          'update ' + TableList[i] + sLineBreak +
          'set' + sLineBreak +
          Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
            UpdateSQLDropletA) +
            '  WHERE ' + sLineBreak +
          Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
            UpdateSQLDropletB) +
          sLineBreak +
          '</whdroplet>' + sLineBreak + sLineBreak;

      cgpInstantFormReadonly,
      cgpInstantFormEdit, cgpInstantFormEditLabelAbove,
      cgpInstantFormInsert:
        begin
          FLastFieldWasHidden := False;
          CodeContent := CodeContent +
            '<whdroplet name="drInstantForm';
          case CodeGenPattern of
            cgpInstantFormReadonly: CodeContent := CodeContent + 'Readonly';
            cgpInstantFormEdit: CodeContent := CodeContent + 'Edit';
            cgpInstantFormEditLabelAbove: CodeContent := CodeContent +
              'EditLabelAbove';
            cgpInstantFormInsert: CodeContent := CodeContent + 'Insert';
          end;

          CodeContent := CodeContent +
             TableList[i] + '" show="no">' +
             sLineBreak;
          if CodeGenPattern <> cgpInstantFormReadonly then
            CodeContent := CodeContent +
              '<!--- <form method="post" accept-charset="UTF-8" ' +
              'action="(~ACTIONR|~)"> -->' +
              sLineBreak;
          if CodeGenPattern in [cgpInstantFormEdit,
            cgpInstantFormEditLabelAbove, cgpInstantFormInsert] then
            CodeContent := CodeContent + '<!--- ';
          CodeContent := CodeContent +
          '  <table id="' +
            LowerCase(
              GetEnumName(TypeInfo(TCodeGenPattern), Ord(CodeGenPattern))) +
              '-' + TableList[i] + '" class="' +
              LowerCase(
              GetEnumName(TypeInfo(TCodeGenPattern), Ord(CodeGenPattern))) +
              '">';
          if CodeGenPattern in [cgpInstantFormEdit,
            cgpInstantFormEditLabelAbove, cgpInstantFormInsert] then
            CodeContent := CodeContent + ' -->';
          CodeContent := CodeContent + sLineBreak;

          case CodeGenPattern of
            cgpInstantFormReadonly: CodeContent := CodeContent +
              Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
                InstantFormReadonly);
            cgpInstantFormInsert: CodeContent := CodeContent +
              Firebird_GenPas_For_Each_Field_in_1Table(conn, TableList[i],
                InstantFormInsert);
            cgpInstantFormEdit:
              begin
                CodeContent := CodeContent +
                  Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
                    InstantFormEdit) +
                '  <tr class="' +
                  LowerCase(
                    GetEnumName(TypeInfo(TCodeGenPattern),
                    Ord(CodeGenPattern))) +
                  'Submit">' + sLineBreak +
                '    <td colspan="2"><input type="submit" ' +
                'name="btnInstantForm" ' +
                'value="Save" /></td>' +
                sLineBreak +
                '  </tr>' + sLineBreak;
              end;
            cgpInstantFormEditLabelAbove:
              begin
                CodeContent := CodeContent +
                  Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
                    InstantFormEditLabelAbove) +
                '  <tr class="' +
                  LowerCase(
                    GetEnumName(TypeInfo(TCodeGenPattern),
                    Ord(CodeGenPattern))) +
                  'Submit">' + sLineBreak +
                '    <td colspan="' + IntToStr(FFieldsPerRowInInstantForm) +
                '"><input type="submit" name="btnInstantForm" ' +
                 'value="Save" /></td>' +
                sLineBreak +
                '  </tr>' + sLineBreak;
              end;
          end;
          if CodeGenPattern in [cgpInstantFormEdit,
            cgpInstantFormEditLabelAbove, cgpInstantFormInsert] then
            CodeContent := CodeContent +
              '<!--- </form> -->' + sLineBreak;
          CodeContent := CodeContent +
            '</whdroplet>' + sLineBreak + sLineBreak;
        end;
        cgpTableHeaderCells:
        begin
          CodeContent := CodeContent +
            '<whdroplet name="' + Format('drDataSetHeader-%s', [TableList[i]]) +
            '">' + sLineBreak;
          CodeContent := CodeContent +
              Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
                TableHeaderCells);
          CodeContent := CodeContent +
            '</whdroplet>' + sLineBreak + sLineBreak;
        end;
        cgpTableRowCells:
        begin
          CodeContent := CodeContent +
            '<whdroplet name="' + Format('drDataSetRow-%s', [TableList[i]]) +
            '">' + sLineBreak;
          CodeContent := CodeContent +
              Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
                TableRowCells);
          CodeContent := CodeContent +
            '</whdroplet>' + sLineBreak + sLineBreak;
        end;
        cgpTableDropletForScan:
        begin
          if i = 0 then  // no additional table looping
            CodeContent := CodeContent +
              Firebird_GenPAS_For_Each_Table(conn, TableDropletForScan,
                AdjustTableListProc);
        end;
    end;
  end;

  case CodeGenPattern of
    cgpMacroLabelsForFields, cgpMacroPKsForTables:
      CodeContent := CodeContent + '</whmacros>' + sLineBreak;
  end;

  if NOT FlagWasConnected then conn.DisconnectToPool;

  Result := CodeContent;
end;

procedure TDMIBObjCodeGen.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
  FFieldsPerRowInInstantForm := 1;
  FAttributeParser := nil;
  FUpdatedByFieldname := 'UpdatedBy';
  FUpdatedOnAtFieldname := 'UpdatedOnAt';
  FUpdateCounterFieldname := 'UpdateCounter';
end;

procedure TDMIBObjCodeGen.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FAttributeParser);
end;

procedure TDMIBObjCodeGen.FieldListForImport(const CurrentTable: string;
  const ThisTableFieldCount, FieldNum: Integer; const CurrentFieldname: string;
  Cursor: TIB_Cursor; out Value: string);
begin
  // f1, f2, f3, f4
  Value := Format('f%d=%s', [FieldNum+1, CurrentFieldname]) + sLineBreak;
end;


procedure TDMIBObjCodeGen.InstantFormEdit(const CurrentTable: string;
  const ThisTableFieldCount, FieldNum: Integer; const CurrentFieldname: string;
  Cursor: TIB_Cursor; out Value: string);
begin
  InstantFormEditOrInsert(False, // Editing. Therefore do NOT use blank values.
    CurrentTable, ThisTableFieldCount, FieldNum,
    CurrentFieldname, Cursor, Value);
end;

procedure TDMIBObjCodeGen.InstantFormEditOrInsert(const FlagBlankValues:
  Boolean; const CurrentTable: string; const ThisTableFieldCount, FieldNum:
  Integer; const CurrentFieldname: string; Cursor: TIB_Cursor;
  out Value: string);
const cFn = 'InstantFormEdit';
var
  ISize, IMaxLength: Integer;
  SizeMaxLengthText: string;
  ThisFieldType: string;
  ThisFieldTypeRaw: Integer;
  ThisFieldDesc: string;
  ThisPlaceholder: string;
  ThisInputType: string;
  ThisReadonly: string;
  HideThisField: Boolean;
  Prefix: string;
  FieldNumStopHere: Integer;
begin

  if (FieldNum = 0) or (FCounter = Pred(FFieldsPerRowInInstantForm)) then
  begin
    FCounter := 0;
  end
  else
    Inc(FCounter);

  if (FCounter = 0) and (NOT FLastFieldWasHidden) then
    Value := '  <tr>' + sLineBreak
   else
     Value := '';

  ThisFieldDesc := Cursor.FieldByName('field_description').AsString;
  // e.g. type="hidden"
  ThisInputType := RegExParseAttribute(FAttributeParser, 'type', ThisFieldDesc);

  if ThisInputType = '' then
    ThisInputType := 'text';

  HideThisField := (ThisInputType='hidden') or (FieldNum = 0);

  if ((FieldNum = 0) and (NOT HideThisField)) or
    ((FieldNum = 0) and FlagBlankValues ) or
    IsEqual(CurrentFieldName, FUpdatedOnAtFieldname) then
  begin
    if (FieldNum = 0) and FlagBlankValues then
    begin
      Value := Value + '    ' + MacroStart + 'SET|readonly-' + CurrentTable +
        '-' + CurrentFieldName + '=' + '-1' + MacroEnd + sLineBreak;
    end
    else
    begin
      { primary key field: readonly and developer wants it shown}
      { UpdatedOnAt field: set by trigger }
      Value := Value +
        '    <th>(~mcLabel-' + CurrentTable + '-' + CurrentFieldname + '~)</th>' +
        sLineBreak +
        '    <td>(~readonly-' + CurrentTable + '-' + CurrentFieldname + '~)' +
        '</td>' + sLineBreak;
    end;
  end
  else
  begin
    if IsEqual(CurrentFieldname, FUpdateCounterFieldname) then
    begin
      HideThisField := True;
      ThisInputType := 'hidden';
      { pass through the UpdateCounter for optimal multi-user editing }
      Value := Value +
        '  <input type="' + ThisInputType + '" name="edit-' + CurrentTable +
        '-' + FUpdateCounterFieldname + '" value="';
      if NOT FlagBlankValues then
      begin
        Value := Value + MacroStart + 'readonly-' + CurrentTable + '-' +
          FUpdateCounterFieldname + MacroEnd;
      end;
      Value := Value +'" />' + sLineBreak
    end
    else
    begin
      ThisFieldType := Cursor.FieldByName('field_type').AsString;
      ThisFieldTypeRaw := Cursor.FieldByName('field_type_raw').AsInteger;
      ThisPlaceholder := RegExParseAttribute(FAttributeParser,
        'placeholder',
        ThisFieldDesc);
      ThisReadonly := RegExParseAttribute(FAttributeParser,
        'readonly',
        ThisFieldDesc);
      if ThisReadonly <> '' then
        ThisReadonly := 'readonly=' + ThisReadonly + ' ';  // readonly="readonly"
      CSSend(CurrentFieldname, ThisFieldType);
      CSSend('ThisFieldTypeRaw', S(ThisFieldTypeRaw));
      // field not found! CSSend('charset', Cursor.FieldByName('CHARACTER_SET_ID').AsString);
      if ThisPlaceholder <> '' then
        CSSend('ThisPlaceholder', ThisPlaceholder);

     if ThisInputType <> 'hidden' then
     begin
       value := Value +
        '    <th>' + MacroStart + 'mcLabel-' + CurrentTable + '-' +
        CurrentFieldname + MacroEnd + '</th>' +
        sLineBreak +
        '    <td>';
     end;

      if ThisFieldTypeRaw = blr_blob then
      begin
        // blob textarea
        Value := Value +
          '<textarea name="txt-edit-' + CurrentTable + '-' +
          CurrentFieldname + '" id="' + CurrentFieldname + '-Blob" ' +
          ThisReadonly + '>';
        if NOT FlagBlankValues then
        begin
          Value := Value + MacroStart + 'edit-' + CurrentTable + '-' +
          CurrentFieldname + MacroEnd;
        end;
        Value := Value + '</textarea>';
      end
      else
      begin
        SizeMaxLengthText := '';
        if NOT HideThisField then
        begin
          IMaxLength := RawTypeToHTMLSize(ThisFieldTypeRaw, Cursor);
          if IMaxLength <> -1 then
          begin
            ISize := IMaxLength;
            if Assigned(FDatabaseIterator) and Assigned(FDatabaseIterator.OnDecideHTMLSize) then
              FDatabaseIterator.OnDecideHTMLSize(FDatabaseIterator, Cursor,
                FieldNum, ThisFieldTypeRaw, iMaxLength, iSize);

            SizeMaxLengthText := Format('size="%d" maxlength="%d"', [ISize,
              IMaxLength])
          end;
        end;
        if FieldNum = 0 then
          Prefix := 'readonly'  // primary key
        else
          Prefix := 'edit';
        Value := Value +
          '<input type="' + ThisInputType + '" name="' + Prefix + '-' +
            CurrentTable + '-' + CurrentFieldname + '" value="';
        if NOT FlagBlankValues then
        begin
          Value := Value + MacroStart + Prefix + '-' + CurrentTable + '-' +
            CurrentFieldname + MacroEnd;
        end;
        Value := Value + '" ' + ThisReadonly + SizeMaxLengthText;
        if ThisPlaceholder <> '' then
          Value := Value + ' placeholder="' + ThisPlaceholder + '"';
        Value := Value + '/>';
      end;
      Value := Value + sLineBreak;
      if ThisInputType <> 'hidden' then
        Value := Value + '    </td>' + sLineBreak;
    end;
  end;
  if HideThisField then
    Dec(FCounter);  // only count visible fields
  FLastFieldWasHidden := HideThisField;
  if (UpdateCounterFieldname = '') then
    FieldNumStopHere := Pred(ThisTableFieldCount)
  else
    FieldNumStopHere := Pred(Pred(ThisTableFieldCount));
  if (FCounter = Pred(FFieldsPerRowInInstantForm)) or (FieldNum =
    FieldNumStopHere) then
  begin
    while FCounter < Pred(FFieldsPerRowInInstantForm) do
    begin
      Value := Value + '    <th></th><td></td>' + sLineBreak;
      Inc(FCounter);
    end;
    Value := Value + '  </tr>' + sLineBreak;
  end;
end;

procedure TDMIBObjCodeGen.InstantFormEditLabelAbove(const CurrentTable: string;
  const ThisTableFieldCount, FieldNum: Integer; const CurrentFieldname: string;
  Cursor: TIB_Cursor; out Value: string);
const cFn = 'InstantFormEditLabelAbove';
var
  Size: Integer;
  SizeText: string;
  ThisFieldType: string;
  ThisFieldTypeRaw: Integer;
  ThisFieldDesc: string;
  ThisPlaceholder: string;
  ThisReadonly: string;
  ThisInputType: string;
  HideThisField: Boolean;
  Prefix: string;
  FieldNumStopHere: Integer;
begin

  if (FieldNum = 0) or (FCounter = Pred(FFieldsPerRowInInstantForm)) then
    FCounter := 0
  else
    Inc(FCounter);

  if (FCounter = 0) and (NOT FLastFieldWasHidden) then
    Value := '  <tr>' + sLineBreak
   else
     Value := '';

  ThisFieldDesc := Cursor.FieldByName('field_description').AsString;

  // e.g. type="hidden"
  ThisInputType := RegExParseAttribute(FAttributeParser,
    'type',
    ThisFieldDesc);
  if ThisInputType = '' then
    ThisInputType := 'text';

  HideThisField := (ThisInputType='hidden') or (FieldNum = 0);

  if ((FieldNum = 0) and (NOT HideThisField)) or
    IsEqual(CurrentFieldName, FUpdatedOnAtFieldname) then
  begin
    { primary key field: readonly and developer wants it shown}
    { UpdatedOnAt field: set by trigger }
    Value := Value +
      '    <td><div class="labelCell">' +
      '(~mcLabel-' + CurrentTable + '-' + CurrentFieldname + '~)</div>' +
      '(~readonly-' + CurrentTable + '-' + CurrentFieldname + '~)' +
      '</td>' + sLineBreak;
  end
  else
  begin
    if IsEqual(CurrentFieldname, FUpdateCounterFieldname) then
    begin
      HideThisField := True;
      ThisInputType := 'hidden';
      { pass through the UpdateCounter for optimal multi-user editing }
      Value := Value +
        '  <input type="' + ThisInputType + '" name="edit-' + CurrentTable +
        '-' + FUpdateCounterFieldname + '" value="' + MacroStart + 'readonly-' +
        CurrentTable + '-' +
        FUpdateCounterFieldname + MacroEnd +'" />' + sLineBreak
    end
    else
    begin
      ThisFieldType := Cursor.FieldByName('field_type').AsString;
      ThisFieldTypeRaw := Cursor.FieldByName('field_type_raw').AsInteger;
      ThisReadonly := RegExParseAttribute(FAttributeParser,
        'readonly',
        ThisFieldDesc);

      ThisPlaceholder := RegExParseAttribute(FAttributeParser,
        'placeholder',
        ThisFieldDesc);
      if ThisPlaceholder <> '' then
        CSSend('ThisPlaceholder', ThisPlaceholder);

      ThisInputType := RegExParseAttribute(FAttributeParser,
        'type',  // e.g. type="hidden"
        ThisFieldDesc);
      if ThisInputType = '' then
        ThisInputType := 'text';

      if NOT HideThisField then
      begin
        value := Value +
          '    <td><div class="labelCell">' + MacroStart + 'mcLabel-' +
          CurrentTable + '-' +
          CurrentFieldname + MacroEnd + '</div>' { +
          '<!--- ' + ThisFieldType +
            ' Raw#' + IntToStr(ThisFieldTypeRaw) +
            ' -->'};
      end;

      if ThisFieldTypeRaw = blr_blob then
      begin
        // blob textarea
        Value := Value +
          '<textarea name="txt-edit-' + CurrentTable + '-' +
          CurrentFieldname + '" id="' + CurrentFieldname + '-Blob" ' +
          ThisReadonly + '>' +
          MacroStart + 'edit-' + CurrentTable + '-' +
          CurrentFieldname + MacroEnd + '</textarea>';
      end
      else
      begin
        SizeText := '';
        if NOT HideThisField then
        begin
          Size := RawTypeToHTMLSize(ThisFieldTypeRaw, Cursor);
          if Size <> -1 then
          begin
            SizeText := Format('size="%d" maxlength="%d"', [Size, Size])
          end
        end;
        if FieldNum = 0 then
          Prefix := 'readonly'
        else
          Prefix := 'edit';
        Value := Value +
          '<input type="' + ThisInputType + '" name="' + Prefix + '-' +
            CurrentTable + '-' + CurrentFieldname + '" value="' + MacroStart +
            Prefix + '-' + CurrentTable + '-' + CurrentFieldname + MacroEnd +
            '" ' + ThisReadonly + SizeText;
        if ThisPlaceholder <> '' then
          Value := Value + ' placeholder="' + ThisPlaceholder + '"';
        Value := Value + '/>';
      end;
      Value := Value + sLineBreak;
      if ThisInputType <> 'hidden' then
        Value := Value + '    </td>' + sLineBreak;
    end;
  end;
  if HideThisField then
    Dec(FCounter);  // only count visible fields
  FLastFieldWasHidden := HideThisField;

  if (UpdateCounterFieldname = '') then
    FieldNumStopHere := Pred(ThisTableFieldCount)
  else
    FieldNumStopHere := Pred(Pred(ThisTableFieldCount));

  if (FCounter = Pred(FFieldsPerRowInInstantForm)) or (FieldNum =
    FieldNumStopHere) then
  begin
    while FCounter < Pred(FFieldsPerRowInInstantForm) do
    begin
      Value := Value + '    <th></th><td></td>' + sLineBreak;
      Inc(FCounter);
    end;
    Value := Value + '  </tr>' + sLineBreak;
  end;
end;

procedure TDMIBObjCodeGen.InstantFormInsert(const CurrentTable: string;
  const ThisTableFieldCount, FieldNum: Integer; const CurrentFieldname: string;
  Cursor: TIB_Cursor; out Value: string);
begin
  InstantFormEditOrInsert(True, // Inserting. Therefore DO use blank values.
    CurrentTable, ThisTableFieldCount, FieldNum,
    CurrentFieldname, Cursor, Value);
end;

procedure TDMIBObjCodeGen.InstantFormReadonly(const CurrentTable: string;
  const ThisTableFieldCount, FieldNum: Integer; const CurrentFieldname: string; Cursor: TIB_Cursor;
  out Value: string);
begin
  try
    Value := '  <tr>' + sLineBreak +
      '    <th>(~mcLabel-' + CurrentTable + '-' + CurrentFieldname + '~)</th>' +
      sLineBreak +
      '    <td>(~readonly-' + CurrentTable + '-' + CurrentFieldname + '~)' +
      '</td>' + sLineBreak +
      '  </tr>' + sLineBreak;
  except
    on E: Exception do
    begin
      {$IFDEF CodeSite}CodeSite.SendException(E);{$ENDIF}
      Value := '<!-- error fieldnum ' + IntToStr(FieldNum) + ' -->';
    end;

  end;
end;

function TDMIBObjCodeGen.Init(out ErrorText: string): Boolean;
begin
  ErrorText := '';
  Result := FlagInitDone;
  // reserved for code that should run once, after AppID set
  if Result then Exit;

  if Assigned(pWebApp) and pWebApp.IsUpdated then
  begin
    // Call RefreshWebActions here only if it is not called within a TtpProject event
    // RefreshWebActions(Self);

    // helpful to know that WebAppUpdate will be called whenever the
    // WebHub app is refreshed.
    AddAppUpdateHandler(WebAppUpdate);

    FlagInitDone := True;
    Result := True;
  end
  else
  begin
    { when running in an EXE that does not have a WebHub app object}
    FlagInitDone := True;
    Result := True;
  end;
end;

function TDMIBObjCodeGen.LabelForField(const CurrentTable: string;
  const FieldNum: Integer; const CurrentFieldname: string;
  Cursor: TIB_Cursor): string;
const cFn = 'LabelForField';
var
  FldDesc: string;
begin
  {$IFDEF LogLabel}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  Result := '';
  FldDesc := Cursor.FieldByName('field_description').AsString;
  {$IFDEF LogLabel}CSSend('FldDesc', FldDesc);{$ENDIF}
  Result := RegExParseAttribute(FAttributeParser, 'label', FldDesc);
  if Result = '' then
  begin
    if FieldNum = 0 then
      Result := CurrentTable + ' PK'
    else
    if IsEqual(CurrentFieldname, FUpdatedByFieldname) then
      Result := 'Updated By'
    else
    if IsEqual(CurrentFieldname, FUpdatedOnAtFieldname) then
      Result := 'Last Mod'
    else
    if IsEqual(CurrentFieldname, FUpdateCounterFieldname) then
      Result := 'Update Count'
    else
      Result := CurrentFieldname;  // default to actual field name
  end;
  {$IFDEF LogLabel}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMIBObjCodeGen.MacroLabelsForFields(const CurrentTable: string;
  const ThisTableFieldCount, FieldNum: Integer; const CurrentFieldname: string; Cursor: TIB_Cursor;
  out Value: string);
var
  FieldLabel: string;
begin
  FieldLabel := LabelForField(CurrentTable, FieldNum, CurrentFieldname, Cursor);
  if FieldLabel <> '' then
    Value := 'mcLabel' + '-' + CurrentTable + '-' + CurrentFieldName + '=' +
      FieldLabel + sLineBreak;
end;

procedure TDMIBObjCodeGen.MacroPKsForTables(const currTable,
  primaryKeyFieldname: string; out Value: string);
begin
  Value := 'mcPK' + '-' + CurrTable + '=' + primaryKeyFieldname + sLineBreak;
end;

function TDMIBObjCodeGen.ProjectAbbrevForCodeGen: string;
begin
  Result := FProjectAbbreviationNoSpaces;
  Result := StringReplaceAll(Result, 'LOCAL', '');
end;

function TDMIBObjCodeGen.RawTypeToHTMLSize(
  const RawFirebirdType: Integer; Cursor: TIB_Cursor): Integer;
begin
  Result := -1;
      case RawFirebirdType of
        blr_text: Result := 1; // char
        blr_short: Result := 4;
        blr_long,
        blr_quad,
        blr_float,
        blr_double,
        blr_d_float: Result := 12;
        blr_int64: Result := 16;
        blr_Varying:
          begin
            Result := Cursor.FieldByName('field_length').AsInteger; // varchar
            if Assigned(FActiveConn) and (FActiveConn.CharSet = 'UTF8') then
              Result := Result Div 4;  // field_length is 4 times longer
          end;
        blr_sql_date: Result := 12;
        blr_timestamp: Result := 20;  // datetime
      end;

end;

procedure TDMIBObjCodeGen.SelectSQLDroplet(const currTable,
  primaryKeyFieldname: string; out Value: string);
begin
  Value := '<whdroplet name="' + Format('dr%s-SelectSQL', [CurrTable]) +
    '">' + sLineBreak;
  Value := Value +
    'select * from ' + currTable + sLineBreak +
    '</whdroplet>' + sLineBreak + sLineBreak;
end;

procedure TDMIBObjCodeGen.TableDropletForScan(const currTable: string;
      const primaryKeyFieldname: string; out Value: string);
begin
  Value :=
    '<whdroplet name="' + Format('drScan-%s', [currTable]) + '">' + sLineBreak;
  Value := Value +
    '<table class="whScan-table">' + sLineBreak +
    MacroStart + 'drDataSetHeader-' + currTable + MacroEnd + sLineBreak +
    '<whrow>' + sLineBreak +
    MacroStart + 'drDataSetRow-' + currTable + MacroEnd + sLineBreak +
    '</whrow>' + sLineBreak +
    '</table>' + sLineBreak +
    '</whdroplet>' + sLineBreak + sLineBreak;
end;

procedure TDMIBObjCodeGen.TableHeaderCells(const CurrentTable: string;
  const ThisTableFieldCount, FieldNum: Integer; const CurrentFieldname: string;
  Cursor: TIB_Cursor; out Value: string);
var
  ThisFieldDesc: string;
  ThisInputType: string;
  HideThisField: Boolean;
begin
  ThisFieldDesc := Cursor.FieldByName('field_description').AsString;
  // e.g. type="hidden"
  ThisInputType := RegExParseAttribute(FAttributeParser,
    'type',
    ThisFieldDesc);
  HideThisField := (ThisInputType='hidden'); // or
    //(CurrentFieldName = UpdateCounterFieldName);

  if FieldNum = 0 then
    Value := '<tr>' + sLineBreak
  else
    Value := '';
  if (NOT HideThisField) then
  begin
    Value := Value + '  <th>' + LabelForField(CurrentTable, FieldNum,
      CurrentFieldname, Cursor) + '</th>' + sLineBreak;
  end;
  if FieldNum = Pred(ThisTableFieldCount) then
    Value := Value + '</tr>' + sLineBreak;
end;

procedure TDMIBObjCodeGen.TableRowCells(const CurrentTable: string;
  const ThisTableFieldCount, FieldNum: Integer; const CurrentFieldname: string;
  Cursor: TIB_Cursor; out Value: string);
var
  ThisFieldDesc: string;
  ThisInputType: string;
  HideThisField: Boolean;
begin
  ThisFieldDesc := Cursor.FieldByName('field_description').AsString;
  ThisInputType := RegExParseAttribute(FAttributeParser, 'type', ThisFieldDesc);
  HideThisField := (ThisInputType='hidden');

  if FieldNum = 0 then
    Value := '<tr>' + sLineBreak
  else
    Value := '';
  if (NOT HideThisField) then
  begin
    Value := Value + '  <td>' + MacroStart + 'readonly-' + CurrentTable +
      '-' + CurrentFieldName + MacroEnd + '</td>' + sLineBreak;
  end;
  if FieldNum = Pred(ThisTableFieldCount) then
    Value := Value + '</tr>' + sLineBreak;
end;

procedure TDMIBObjCodeGen.UpdateSQLDropletA(const CurrentTable: string;
      const ThisTableFieldCount, FieldNum: Integer; const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
var
  FlagSkip: Boolean;
begin

  if FieldNum = 0 then
    FlagSkip := True  // never update the primary key
  else
  if IsEqual(CurrentFieldname, FUpdatedOnAtFieldname) then
  begin
    FlagSkip := True;
  end
  else
  if IsEqual(CurrentFieldname, FUpdateCounterFieldname)
  then
  begin
    FlagSkip := True;
  end
  else
    FlagSkip := False;

  if NOT FlagSkip then
  begin
    //     , USPShort=:USPShort
    if FieldNum = 1 then
      Value := Value + '  '
    else
      Value := Value + '  , ';
    Value := Value + CurrentFieldname + '=:' +
      CurrentFieldname + sLineBreak;
  end;
end;

procedure TDMIBObjCodeGen.UpdateSQLDropletB(const CurrentTable: string;
      const ThisTableFieldCount, FieldNum: Integer; const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
begin

  if FieldNum = 0 then
  begin
    Value := Value + '  (' + CurrentFieldName + ' = :' + CurrentFieldname +
    ') ';
  end
  else
  if IsEqual(CurrentFieldname, FUpdateCounterFieldname) then
  begin
    Value := Value + sLineBreak + '  and ' + sLineBreak +
      '  (' + CurrentFieldName + ' = :' + CurrentFieldname + ')' + sLineBreak;
  end;
end;

procedure TDMIBObjCodeGen.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

end.
