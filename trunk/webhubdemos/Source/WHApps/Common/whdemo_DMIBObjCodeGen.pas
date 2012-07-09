unit whdemo_DMIBObjCodeGen;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this file *)

interface

uses
  SysUtils, Classes,
  IB_Components,
  webLink, whutil_RegExParsing;

type
  TCodeGenPattern = (cgpMacroLabelsForFields, cgpFieldListForImport,
    cgpSelectSQLDroplet);

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
    procedure MacroLabelsForFields(const CurrentTable: string; const FieldNum: Integer;
      const CurrentFieldname: string; Cursor: TIB_Cursor; out Value: string);
    procedure FieldListForImport(const CurrentTable: string; const FieldNum: Integer;
      const CurrentFieldname: string; Cursor: TIB_Cursor; out Value: string);
    procedure SelectSQLDroplet(const currTable: string;
      const primaryKeyFieldname: string; out Value: string);
  public
    { Public declarations }
    procedure Init;
    function CodeGenForPattern(conn: TIB_Connection; TableList: TStringList;
      const CodeGenPattern: TCodeGenPattern): string;
    function ProjectAbbrevForCodeGen: string;
  published
    property ProjectAbbreviationNoSpaces: string
      read FProjectAbbreviationNoSpaces write FProjectAbbreviationNoSpaces;
  end;

var
  DMIBObjCodeGen: TDMIBObjCodeGen;

implementation

{$R *.dfm}

uses
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
  Value := Format('f%d=%s', [FieldNum, CurrentFieldname]) + sLineBreak;
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
