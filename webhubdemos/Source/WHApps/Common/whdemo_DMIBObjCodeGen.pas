unit whdemo_DMIBObjCodeGen;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this file *)

interface

uses
  SysUtils, Classes,
  IB_Components,
  webLink, whutil_RegExParsing, whCodeGenIBObj;

type
  TCodeGenPattern = (cgpMacroLabelsForFields, cgpFieldListForImport,
    cgpSelectSQLDroplet, cgpFormViewReadonly, cgpFormViewEdit);

type
  TDMIBObjCodeGen = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    FProjectAbbreviationNoSpaces: string;
    FAttributeParser: TAttributeParser;
    procedure WebAppUpdate(Sender: TObject);
  private
    FDatabaseIterator: TwhDatabaseIterator;
  private
    procedure MacroLabelsForFields(const CurrentTable: string;
      const FieldNum: Integer; const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure FieldListForImport(const CurrentTable: string;
      const FieldNum: Integer; const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure SelectSQLDroplet(const currTable: string;
      const primaryKeyFieldname: string; out Value: string);
    procedure FormViewReadonly(const CurrentTable: string;
      const FieldNum: Integer; const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
    procedure FormViewEdit(const CurrentTable: string;
      const FieldNum: Integer; const CurrentFieldname: string;
      Cursor: TIB_Cursor; out Value: string);
  public
    { Public declarations }
    procedure Init;
    function CodeGenForPattern(conn: TIB_Connection; TableList: TStringList;
      const CodeGenPattern: TCodeGenPattern): string;
    function ProjectAbbrevForCodeGen: string;
    property DatabaseIterator: TwhDatabaseIterator read FDatabaseIterator
      write FDatabaseIterator;
  published
    property ProjectAbbreviationNoSpaces: string
      read FProjectAbbreviationNoSpaces write FProjectAbbreviationNoSpaces;
  end;

var
  DMIBObjCodeGen: TDMIBObjCodeGen;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  TypInfo,
  webApp, htWebApp,
  ucString, tpFirebirdCredentials, tpIBOCodeGenerator;

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
    cgpMacroLabelsForFields: CodeContent := '<whmacros>' + sLineBreak;
    cgpFieldListForImport: CodeContent := '';
    cgpSelectSQLDroplet: CodeContent := '';
    cgpFormViewReadonly, cgpFormViewEdit: CodeContent := '';
  end;

  for i := 0 to Pred(TableList.Count) do
  begin
    case CodeGenPattern of
      cgpMacroLabelsForFields:
        CodeContent := CodeContent +
          Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
          MacroLabelsForFields);
      cgpFieldListForImport:
        CodeContent := CodeContent + ';; ' + TableList[i] + sLineBreak +
          '[FieldList]' + sLineBreak +
          Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
          FieldListForImport) + sLineBreak;
      cgpSelectSQLDroplet:
        if i = 0 then  // no additional table looping
          CodeContent := CodeContent +
            Firebird_GenPAS_For_Each_Table(conn, SelectSQLDroplet);
      cgpFormViewReadonly, cgpFormViewEdit:
        begin
          CodeContent := CodeContent +
            '<whdroplet name="drFormView';
          if CodeGenPattern = cgpFormViewReadonly then
            CodeContent := CodeContent + 'Readonly'
          else
            CodeContent := CodeContent + 'Edit';
          CodeContent := CodeContent +
             TableList[i] + '" show="no">' +
             sLineBreak;
          if CodeGenPattern = cgpFormViewEdit then
            CodeContent := CodeContent +
              '<form method="post" accept-charset="UTF-8" action="#">' +
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
          if CodeGenPattern = cgpFormViewReadonly then
            CodeContent := CodeContent +
              Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
                FormViewReadonly)
          else
            CodeContent := CodeContent +
              Firebird_GenPAS_For_Each_Field_in_1Table(conn, TableList[i],
                FormViewEdit);
          CodeContent := CodeContent +
          '  <tr class="' +
            LowerCase(
              GetEnumName(TypeInfo(TCodeGenPattern), Ord(CodeGenPattern))) +
            'Submit">' + sLineBreak +
          '    <td colspan="2"><input type="submit" name="btnFormView"/></td>' +
          sLineBreak +
          '  </tr>' + sLineBreak +
          '  </table>' + sLineBreak;
          if CodeGenPattern = cgpFormViewEdit then
            CodeContent := CodeContent +
              '</form>' + sLineBreak;
          CodeContent := CodeContent +
            '</whdroplet>' + sLineBreak + sLineBreak;
        end;
    end;
  end;

  case CodeGenPattern of
    cgpMacroLabelsForFields:
      CodeContent := CodeContent + '</whmacros>' + sLineBreak;
  end;

  if NOT FlagWasConnected then conn.DisconnectToPool;

  Result := CodeContent;
end;

procedure TDMIBObjCodeGen.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
  FAttributeParser := nil;
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

procedure TDMIBObjCodeGen.FormViewEdit(const CurrentTable: string;
  const FieldNum: Integer; const CurrentFieldname: string; Cursor: TIB_Cursor;
  out Value: string);
begin
  Value := '  <tr>' + sLineBreak +
    '    <th>(~mcLabel-' + CurrentTable + '-' + CurrentFieldname + '~)</th>' +
    sLineBreak +
    '    <td>' +
    '<input name="edit-' + CurrentTable + '-' + CurrentFieldname +
      '" value="(~edit-' + CurrentTable + '-' + CurrentFieldname + '~)" />' +
      '</td>' +
      sLineBreak +
    '  </tr>' + sLineBreak;
end;

procedure TDMIBObjCodeGen.FormViewReadonly(const CurrentTable: string;
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

procedure TDMIBObjCodeGen.Init;
begin
  // reserved for code that should run once, after AppID set
  if FlagInitDone then Exit;

  if Assigned(pWebApp) and pWebApp.IsUpdated then
  begin
    // Call RefreshWebActions here only if it is not called within a TtpProject event
    // RefreshWebActions(Self);

    // helpful to know that WebAppUpdate will be called whenever the
    // WebHub app is refreshed.
    AddAppUpdateHandler(WebAppUpdate);

    FlagInitDone := True;
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

procedure TDMIBObjCodeGen.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

end.
