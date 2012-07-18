unit whdemo_DMIBObjCodeGen;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2012 HREF Tools Corp.  All Rights Reserved Worldwide.      * }
{ *                                                                          * }
{ * This source code file is part of WebHub v2.1x.  Please obtain a WebHub   * }
{ * development license from HREF Tools Corp. before using this file, and    * }
{ * refer friends and colleagues to http://www.href.com/webhub. Thanks!      * }
{ ---------------------------------------------------------------------------- }

{ ---------------------------------------------------------------------------- }
{ * Requires IBObjects from www.ibobjects.com                                * }
{ * Requires Firebird SQL Database                                           * }
{ *                                                                          * }
{ * EXTREMELY EXPERIMENTAL !                                                 * }
{ *                                                                          * }
{ ---------------------------------------------------------------------------- }

interface

uses
  SysUtils, Classes,
  IB_Components,
  webLink, whutil_RegExParsing, whCodeGenIBObj;

type
  TCodeGenPattern = (cgpMacroLabelsForFields, cgpMacroPKsForTables,
    cgpFieldListForImport, cgpSelectSQLDroplet, cgpUpdateSQLDroplet,
    cgpInstantFormReadonly, cgpInstantFormEdit);

type
  TDMIBObjCodeGen = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    FProjectAbbreviationNoSpaces: string;
    FUpdatedOnAtFieldname: string;
    FUpdateCounterFieldname: string;
    FAttributeParser: TAttributeParser;
    procedure WebAppUpdate(Sender: TObject);
  private
    FDatabaseIterator: TwhDatabaseIterator;
  private
    procedure MacroLabelsForFields(const CurrentTable: string;
      const FieldNum: Integer; const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure MacroPKsForTables(const currTable: string;
      const primaryKeyFieldname: string; out Value: string);
    procedure FieldListForImport(const CurrentTable: string;
      const FieldNum: Integer; const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure SelectSQLDroplet(const currTable: string;
      const primaryKeyFieldname: string; out Value: string);
    procedure UpdateSQLDropletA(const CurrentTable: string;
      const FieldNum: Integer; const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure UpdateSQLDropletB(const CurrentTable: string;
      const FieldNum: Integer; const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure InstantFormReadonly(const CurrentTable: string;
      const FieldNum: Integer; const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure InstantFormEdit(const CurrentTable: string;
      const FieldNum: Integer; const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
    function CodeGenForPattern(conn: TIB_Connection; TableList: TStringList;
      const CodeGenPattern: TCodeGenPattern): string;
    function ProjectAbbrevForCodeGen: string;
    property DatabaseIterator: TwhDatabaseIterator read FDatabaseIterator
      write FDatabaseIterator;
    property ProjectAbbreviationNoSpaces: string
      read FProjectAbbreviationNoSpaces write FProjectAbbreviationNoSpaces;
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
  TypInfo,
  webApp, htWebApp, whMacroAffixes,
  ucString, ucCodeSiteInterface, tpFirebirdCredentials, tpIBObjCodeGen;

{ TDMIBObjCodeGen }

function TDMIBObjCodeGen.CodeGenForPattern(conn: TIB_Connection;
  TableList: TStringList; const CodeGenPattern: TCodeGenPattern): string;
var
  i: Integer;
  CodeContent: string;
  FlagWasConnected: Boolean;
begin
  inherited;
  Result := '';

  FlagWasConnected := conn.Connected;
  if NOT FlagWasConnected then conn.Connect;

  case CodeGenPattern of
    cgpMacroLabelsForFields,
    cgpMacroPKsForTables: CodeContent := '<whmacros>' + sLineBreak;
    cgpFieldListForImport: CodeContent := '';
    cgpSelectSQLDroplet: CodeContent := '';
    cgpUpdateSQLDroplet: CodeContent := '';
    cgpInstantFormReadonly, cgpInstantFormEdit: CodeContent := '';
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
            Firebird_GenPAS_For_Each_Table(conn, MacroPKsForTables);

      cgpFieldListForImport:
        CodeContent := CodeContent + ';; ' + TableList[i] + sLineBreak +
          '[FieldList]' + sLineBreak +
          Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
          FieldListForImport) + sLineBreak;

      cgpSelectSQLDroplet:
        if i = 0 then  // no additional table looping
          CodeContent := CodeContent +
            Firebird_GenPAS_For_Each_Table(conn, SelectSQLDroplet);

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
          '</whdroplet>' + sLineBreak + sLineBreak;

      cgpInstantFormReadonly, cgpInstantFormEdit:
        begin
          CodeContent := CodeContent +
            '<whdroplet name="drInstantForm';
          if CodeGenPattern = cgpInstantFormReadonly then
            CodeContent := CodeContent + 'Readonly'
          else
            CodeContent := CodeContent + 'Edit';
          CodeContent := CodeContent +
             TableList[i] + '" show="no">' +
             sLineBreak;
          if CodeGenPattern = cgpInstantFormEdit then
            CodeContent := CodeContent +
              '<!--- <form method="post" accept-charset="UTF-8" ' +
              'action="(~ACTIONR|~)"> -->' +
              sLineBreak;
          CodeContent := CodeContent +
          '  <table id="' +
            LowerCase(
              GetEnumName(TypeInfo(TCodeGenPattern), Ord(CodeGenPattern))) +
              '-' + TableList[i] + '" class="' +
              LowerCase(
              GetEnumName(TypeInfo(TCodeGenPattern), Ord(CodeGenPattern))) +
              '">' +
          sLineBreak;
          if CodeGenPattern = cgpInstantFormReadonly then
            CodeContent := CodeContent +
              Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
                InstantFormReadonly)
          else
            CodeContent := CodeContent +
              Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
                InstantFormEdit);
          CodeContent := CodeContent +
          '  <tr class="' +
            LowerCase(
              GetEnumName(TypeInfo(TCodeGenPattern), Ord(CodeGenPattern))) +
            'Submit">' + sLineBreak +
          '    <td colspan="2"><input type="submit" name="btnInstantForm" ' +
           'value="Save" /></td>' +
          sLineBreak +
          '  </tr>' + sLineBreak +
          '  </table>' + sLineBreak;
          if CodeGenPattern = cgpInstantFormEdit then
            CodeContent := CodeContent +
              '<!--- </form> -->' + sLineBreak;
          CodeContent := CodeContent +
            '</whdroplet>' + sLineBreak + sLineBreak;
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
  FAttributeParser := nil;
  FUpdatedOnAtFieldname := 'UpdatedOnAt';
  FUpdateCounterFieldname := 'UpdateCounter';
end;

procedure TDMIBObjCodeGen.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FAttributeParser);
end;

procedure TDMIBObjCodeGen.FieldListForImport(const CurrentTable: string;
  const FieldNum: Integer; const CurrentFieldname: string; Cursor: TIB_Cursor;
  out Value: string);
begin
  // f1, f2, f3, f4
  Value := Format('f%d=%s', [FieldNum+1, CurrentFieldname]) + sLineBreak;
end;

procedure TDMIBObjCodeGen.InstantFormEdit(const CurrentTable: string;
  const FieldNum: Integer; const CurrentFieldname: string; Cursor: TIB_Cursor;
  out Value: string);
const cFn = 'InstantFormEdit';
var
  Size: Integer;
  SizeText: string;
  ThisFieldType: string;
  ThisFieldTypeRaw: Integer;
begin
  if (FieldNum = 0) or IsEqual(CurrentFieldName, FUpdatedOnAtFieldname) then
  begin
    { primary key field: readonly }
    { UpdatedOnAt field: set by trigger }
    InstantFormReadonly(CurrentTable, FieldNum, CurrentFieldname, Cursor, Value)
  end
  else
  if IsEqual(CurrentFieldname, FUpdateCounterFieldname) then
  begin
    { pass through the UpdateCounter for optimal multi-user editing }
    Value := '  <input type="hidden" name="edit-' + CurrentTable + '-' +
      FUpdateCounterFieldname + '" value="' + MacroStart + 'readonly-' +
      CurrentTable + '-' +
      FUpdateCounterFieldname + MacroEnd +'" />' + sLineBreak
  end
  else
  begin
    Size := -1;
    ThisFieldType := Cursor.FieldByName('field_type').AsString;
    ThisFieldTypeRaw := Cursor.FieldByName('field_type_raw').AsInteger;
    LogSendInfo(CurrentFieldname, ThisFieldType, cFn);
   // LogSendInfo('charset', Cursor.FieldByName('CHARACTER_SET_ID').AsString);

    Value := '  <tr>' + sLineBreak +
      '    <th>' + MacroStart + 'mcLabel-' + CurrentTable + '-' +
      CurrentFieldname + MacroEnd + '</th>' +
      sLineBreak +
      '    <td>' + '<!--- ' + ThisFieldType +
        ' Raw#' + IntToStr(ThisFieldTypeRaw) +
        ' -->';

    if ThisFieldTypeRaw = blr_blob then
    begin
      // blob textarea
      Value := Value +
        '<textarea name="txt-edit-' + CurrentTable + '-' +
        CurrentFieldname + '" id="' + CurrentFieldname + '-Blob">' +
        MacroStart + 'edit-' + CurrentTable + '-' +
        CurrentFieldname + MacroEnd + '</textarea>' + sLineBreak;
    end
    else
    begin
      case ThisFieldTypeRaw of
        blr_text: Size := 1; // char
        blr_short: Size := 4;
        blr_long,
        blr_quad,
        blr_float,
        blr_double,
        blr_d_float: Size := 12;
        blr_int64: Size := 16;
        blr_Varying:
          begin
            Size := Cursor.FieldByName('field_length').AsInteger; // varchar
            Size := Size Div 4;  // UTF-8 charset !!!
          end;
        blr_sql_date: Size := 12;
        blr_timestamp: Size := 20;  // datetime
      end;
      if Size <> -1 then
      begin
        SizeText := Format('size="%d" maxlength="%d"', [Size, Size])
      end
      else
        SizeText := '';
      Value := Value +
        '<input type="text" name="edit-' + CurrentTable + '-' + CurrentFieldname +
          '" value="(~edit-' + CurrentTable + '-' + CurrentFieldname + '~)" ' +
          SizeText + '/>';
    end;

    Value := Value +
        '    </td>' +
        sLineBreak +
      '  </tr>' + sLineBreak;
  end;
end;

procedure TDMIBObjCodeGen.InstantFormReadonly(const CurrentTable: string;
  const FieldNum: Integer; const CurrentFieldname: string; Cursor: TIB_Cursor;
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
  end;
end;

procedure TDMIBObjCodeGen.MacroLabelsForFields(const CurrentTable: string;
  const FieldNum: Integer; const CurrentFieldname: string; Cursor: TIB_Cursor;
  out Value: string);
var
  FieldDescription: string;
  FieldLabel: string;
begin
  FieldLabel := '';
  if IsEqual(CurrentFieldname, 'UpdatedBy') then
    FieldLabel := 'Updated By'
  else
  if IsEqual(CurrentFieldname, 'UpdatedOnAt') then
    FieldLabel := 'Last Mod'
  else
  if IsEqual(CurrentFieldname, 'UpdateCounter') then
    {nothing} // no macro desired
  else
  begin
    if NOT Assigned(FAttributeParser) then
    begin
      FAttributeParser := TAttributeParser.Create(' ');
    end;
    // Example: pk="autoincrement" label="ok dokie" otherAttrib="abc"
    FieldDescription := Cursor.FieldByName('field_description').AsString;
    FAttributeParser.SetPairs(FieldDescription);
    FieldLabel := FAttributeParser.Value('label');  // case sensitive
    if FieldLabel = '' then
    begin
      if FieldNum = 0 then
        FieldLabel := CurrentTable + ' PK'
      else
        FieldLabel := CurrentFieldname;  // default to actual field name
    end;
  end;
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
  if pWebApp.ZMDefaultMapContext <> 'DEMOS' then
    Result := StringReplaceAll(Result, 'LOCAL', '');
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

procedure TDMIBObjCodeGen.UpdateSQLDropletA(const CurrentTable: string;
      const FieldNum: Integer; const CurrentFieldname: string;
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
      const FieldNum: Integer; const CurrentFieldname: string;
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
