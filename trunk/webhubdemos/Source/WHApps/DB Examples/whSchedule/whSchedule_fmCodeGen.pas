unit whSchedule_fmCodeGen;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2012 HREF Tools Corp.  All Rights Reserved Worldwide.      * }
{ ---------------------------------------------------------------------------- }

interface

{$I hrefdefines.inc}
{$DEFINE BootStrapDone}

uses
  Forms, Controls, Dialogs, Graphics, ExtCtrls, StdCtrls,
  SysUtils, Classes, ActnList, Vcl.Buttons, Vcl.ComCtrls,
  IB_Components,
  toolbar, utPanFrm, restorer, tpCompPanel,
  whutil_RegExParsing;

type
  TfmCodeGenerator = class(TutParentForm)
    ToolBar: TtpToolBar;
    tpComponentPanel: TtpComponentPanel;
    Panel: TPanel;
    ActionList1: TActionList;
    ActionBootstrap: TAction;
    ActionGenPASandSQL: TAction;
    ActionExport: TAction;
    ActionImport: TAction;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    tpToolBar2: TtpToolBar;
    tpToolButton5: TtpToolButton;
    TabSheet2: TTabSheet;
    tpToolBar3: TtpToolBar;
    tpToolButton10: TtpToolButton;
    TabSheet3: TTabSheet;
    tpToolBar4: TtpToolBar;
    tpToolButton15: TtpToolButton;
    tpToolButton16: TtpToolButton;
    Memo1: TMemo;
    LabelDBInfo: TLabel;
    LabeledEditProjectAbbrev: TLabeledEdit;
    TabSheet4: TTabSheet;
    tpToolBar1: TtpToolBar;
    cbCodeGenPattern: TComboBox;
    Button1: TButton;
    ActionCodeGenForPattern: TAction;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure ActionBootstrapExecute(Sender: TObject);
    procedure ActionGenPASandSQLExecute(Sender: TObject);
    procedure ActionExportExecute(Sender: TObject);
    procedure ActionImportExecute(Sender: TObject);
    procedure ActionCodeGenForPatternExecute(Sender: TObject);
  private
    { Private declarations }
    procedure TranslateOutgoingStringBreaks( var AString: string );
(*    procedure TranslateIncomingStringBreaks(Sender: TObject;
                         var InputFields: TStrings;
                             NumberOfFields: integer);*)
  public
    { Public declarations }
    function Init: Boolean; override;
    function RestorerActiveHere: Boolean; override;
  end;

var
  fmCodeGenerator: TfmCodeGenerator;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  IB_Export,
  ucLogFil, ucDlgs, tpIBOCodeGenerator_Bootstrap, ucString, ucAnsiUtil,
  webApp, webLink, uFirebird_Connect_CodeRageSchedule, tpIBOCodeGenerator,
  tpFirebirdCredentials, uFirebird_SQL_Snippets_CodeRageSchedule, IB_Import,
  whdemo_DMIBObjCodeGen;

const
  cPASOutputRoot = 'D:\Projects\webhubdemos\' +
    'Source\WHApps\DB Examples\whSchedule\';
  cSQLOutputRoot = 'D:\Projects\webhubdemos\' +
    'Source\WHApps\DB Examples\whSchedule\DBDesign\gen_sql\';
  cCSVIniRoot = 'D:\Projects\webhubdemos\' +
    'Source\WHApps\DB Examples\whSchedule\DBDesign\csv_import\';

{ TfmCodeGenerator }

procedure TfmCodeGenerator.ActionBootstrapExecute(Sender: TObject);
var
  BootstrapFilespec: string;
begin
  inherited;
  { Bootstrap step must be done once at the beginning, to create the unit that
    is subsequently used for all connections to the firebird database. }
  Memo1.Clear;
  if DirectoryExists(cPASOutputRoot) then
  begin
    BootstrapFilespec := cPASOutputRoot + 'uFirebird_Connect_CodeRageSchedule.pas';
    if FileExists(BootstrapFilespec) then
    begin
      if AskQuestionYesNo('Delete prior ' + sLineBreak + sLineBreak +
        BootstrapFilespec + sLineBreak + sLineBreak + '?') then
      begin
        DeleteFile(BootstrapFilespec);
      end;
    end;
    if NOT FileExists(BootstrapFilespec) then
    begin
      Firebird_GenPAS_Connect('CodeRageSchedule', BootstrapFilespec);
      Memo1.Lines.Text := StringLoadFromFile(BootstrapFilespec);
      MsgInfoOk('Done. Contents are displayed in memo now.');
    end;
  end
  else
    MsgErrorOk('Directory not found' + sLineBreak + sLineBreak +
      cPASOutputRoot);
end;

procedure TfmCodeGenerator.ActionCodeGenForPatternExecute(Sender: TObject);
var
  y: TStringList;
  DBName, DBUser, DBPass: string;
  Flag: Boolean;
  CodeContent: string;
begin
  inherited;
  y := nil;

  ZMLookup_Firebird_Credentials(DMIBObjCodeGen.ProjectAbbreviationNoSpaces,
    DBName, DBUser, DBPass);
  CreateIfNil(DBName, DBUser, DBPass);
  Memo1.Lines.Text := DBName;
  Memo1.Lines.Add('connecting...');
  Application.ProcessMessages;
  gCodeRageSchedule_Conn.Connect;


  try
    Firebird_GetTablesInDatabase(y, Flag, DBName,
      gCodeRageSchedule_Conn, gCodeRageSchedule_Tr, DBUser, DBPass);

    case cbCodeGenPattern.ItemIndex of
      0: CodeContent := DMIBObjCodeGen.CodeGenForPattern(gCodeRageSchedule_Conn,
        y, cgpMacroLabelsForFields);
      1: CodeContent := DMIBObjCodeGen.CodeGenForPattern(gCodeRageSchedule_Conn,
        y, cgpFieldListForImport);
      2: CodeContent := DMIBObjCodeGen.CodeGenForPattern(gCodeRageSchedule_Conn,
        y, cgpSelectSQLDroplet);
      3: CodeContent := DMIBObjCodeGen.CodeGenForPattern(gCodeRageSchedule_Conn,
        y, cgpFormViewReadonly);
      4: CodeContent := DMIBObjCodeGen.CodeGenForPattern(gCodeRageSchedule_Conn,
        y, cgpFormViewEdit);
    end;
  finally
    FreeAndNil(y);
  end;

  Application.ProcessMessages;
  Memo1.Lines.Text := CodeContent;
  gCodeRageSchedule_Conn.DisconnectToPool;
end;

procedure TfmCodeGenerator.ActionExportExecute(Sender: TObject);
var
  q: TIB_Cursor;
  ex: TIB_Export;
  DBName, DBUser, DBPass: string;

  function Select_SQL_for_Export(const InTablename: string): string;
  begin
    if InTablename = 'ABOUT' then
      Result := 'select -1 as AboutID, SCHID, PRODUCTID from ABOUT'
    else
    if InTablename = 'XPRODUCT' then
      Result := 'select PRODUCTID, PRODUCTABBREV, PRODUCTNAME ' +
        'FROM XPRODUCT'
    else
    if InTablename = 'SCHEDULE' then
      Result := 'select -1 as SCHID, SCHTITLE, SCHONATPDT, SCHMINUTES, ' +
        'SCHPRESENTERFULLNAME, SCHPRESENTERORG, SCHLOCATION, SCHBLURB, ' +
        'SCHREPEATOF, SCHTAGC, SCHTAGD, SCHTAGPRISM from SCHEDULE';
  end;

  procedure Export_1_Table(const InTablename: string);
  begin
    if Q.Active then
    begin
      Q.Close;
      Q.Unprepare;
    end;
    q.SQL.Text := Select_SQL_for_Export(InTablename);
    Memo1.Lines.Add(q.SQL.Text);
    ex.Filename := 'D:\Projects\webhubdemos\Live\Database\whSchedule\backup\' +
      InTablename + '.csv';
    Memo1.Lines.Add(ex.Filename);
    q.Open;
    ex.Execute;
    Memo1.Lines.Add('Done with ' + InTablename);
    Memo1.Lines.Add('');
  end;

begin
  inherited;

  ZMLookup_Firebird_Credentials(DMIBObjCodeGen.ProjectAbbreviationNoSpaces,
    DBName, DBUser, DBPass);
  CreateIfNil(DBName, DBUser, DBPass);
  gCodeRageSchedule_Conn.Connect;

  ex := nil;
  q := nil;
  try
    q := TIB_Cursor.Create(Self);
    q.IB_Connection := gCodeRageSchedule_Conn;
    q.IB_Transaction := gCodeRageSchedule_Tr;
    q.Name := 'q4export';
    ex := TIB_Export.Create(Self);
    ex.Dataset := q;
    ex.ExportFormat := efText_Delimited;

    ex.IncludeHeaders := False;
    ex.OnTranslateString := TranslateOutgoingStringBreaks;
    Memo1.Clear;
    Export_1_Table('ABOUT');
    Export_1_Table('XPRODUCT');
    Export_1_Table('SCHEDULE');
  finally
    FreeAndNil(ex);
    FreeAndNil(q);
  end;
  gCodeRageSchedule_Conn.DisconnectToPool;
end;

procedure TfmCodeGenerator.ActionGenPASandSQLExecute(Sender: TObject);
var
  Flag: Boolean;
  y: TStringList;
  Filespec: string;
  FBDB, FBUsername, FBPassword: string;
begin
  inherited;
  y := nil;
  Memo1.Lines.Clear;
  Memo1.Lines.Add('Starting... takes time depending on connection speed');
  Memo1.Lines.Add('');

  ZMLookup_Firebird_Credentials(DMIBObjCodeGen.ProjectAbbreviationNoSpaces,
    FBDB, FBUsername, FBPassword);
  CreateIfNil(FBDB, FBUsername, FBPassword);
  Memo1.Lines.Add(FBDB);
  Memo1.Lines.Add(FBUsername + #9 + FBPassword);
  Memo1.Lines.Add('');

  gCodeRageSchedule_Conn.Connect;

  Firebird_GetTablesInDatabase(y, Flag, FBDB,
    gCodeRageSchedule_Conn, gCodeRageSchedule_Tr, FBUsername, FBPassword);

  if Assigned(y) then
  begin
    Filespec :=
      cSQLOutputRoot + 'CodeRageSchedule_Triggers.sql';
    Firebird_GenSQL_TriggersFor3UpdateFields(y, gCodeRageSchedule_Conn,
      Filespec);
    Memo1.Lines.Add(Filespec);
    Memo1.Lines.Add('');

    Filespec :=
      cPASOutputRoot +
      'uStructureClientDataSets_' + DMIBObjCodeGen.ProjectAbbrevForCodeGen +
      '.pas';
    Firebird_GenPAS_StructureClientDatasets(y, gCodeRageSchedule_Conn,
      DMIBObjCodeGen.ProjectAbbrevForCodeGen, Filespec);
    Memo1.Lines.Add(Filespec);
    Memo1.Lines.Add('');

    Filespec :=
      cPASOutputRoot +
      'uFirebird_SQL_Snippets_' + DMIBObjCodeGen.ProjectAbbrevForCodeGen + '.pas';
    Firebird_GenPAS_SQL_Snippets(y, gCodeRageSchedule_Conn,
      DMIBObjCodeGen.ProjectAbbrevForCodeGen, Filespec);
    Memo1.Lines.Add(Filespec);
    Memo1.Lines.Add('');

    // Order Head and Detail need to be live datasets, not cached
    // BUT: it helps to have the Fill code for copy and paste samples
    Filespec :=
      cPASOutputRoot +
      'uFillClientDataSets_' + DMIBObjCodeGen.ProjectAbbrevForCodeGen + '.pas';
    Firebird_GenPAS_FillClientDatasets(y, gCodeRageSchedule_Conn,
      DMIBObjCodeGen.ProjectAbbrevForCodeGen, Filespec);
    Memo1.Lines.Add(Filespec);
    Memo1.Lines.Add('');
  end;
  FreeAndNil(y);
  gCodeRageSchedule_Conn.DisconnectToPool;
  Memo1.Lines.Add('Done! ' + FormatDateTime('dddd hh:nn:ss', Now));
end;

procedure TfmCodeGenerator.ActionImportExecute(Sender: TObject);
var
  im: TIB_Import;
  DBName, DBUser, DBPass: string;
begin
  inherited;
  im := nil;
  Memo1.Clear;

  ZMLookup_Firebird_Credentials(DMIBObjCodeGen.ProjectAbbreviationNoSpaces,
    DBName, DBUser, DBPass);
  CreateIfNil(DBName, DBUser, DBPass);
  gCodeRageSchedule_Conn.Connect;

  try
    im := TIB_Import.Create(Self);
    im.Name := 'import4coderage';
    im.IB_Connection := gCodeRageSchedule_Conn;
    im.IB_Transaction := gCodeRageSchedule_Tr;
    im.ImportFormat := ifUTF8;
    try
      // XProduct table
      im.IniFile := cCSVIniRoot + 'ImportSpec_001_XProduct.ini';
      Memo1.Lines.Add(im.IniFile);
      im.ImportMode := mCopy;
      im.Execute;
      // schedule table
      im.IniFile := cCSVIniRoot + 'ImportSpec_002_schedule.ini';
      Memo1.Lines.Add(im.IniFile);
      im.ImportMode := mCopy;  // erase first then import
      //im.OnParse := TranslateIncomingStringBreaks;
      im.Execute;

      // About table (requires the above 2 present, first)
      im.IniFile := cCSVIniRoot + 'ImportSpec_003_about.ini';
      Memo1.Lines.Add(im.IniFile);
      im.ImportMode := mCopy;  // erase first then import
      im.Execute;
      Memo1.Lines.Add('Done');
    except
      on E: Exception do
      begin
        {$IFDEF CodeSite}CodeSite.SendException(E);{$ENDIF}
        Memo1.Lines.Add(E.Message);
      end;
    end;
  finally
    FreeAndNil(im);
  end;
  gCodeRageSchedule_Conn.DisconnectToPool;
end;

function TfmCodeGenerator.Init: Boolean;
var
  DBName, DBUser, DBPass: string;
begin
  Result := inherited Init;
  if Result then
  begin
    cbCodeGenPattern.ItemIndex := 0;
    DMIBObjCodeGen.ProjectAbbreviationNoSpaces := LabeledEditProjectAbbrev.Text;
    if pWebApp.ZMDefaultMapContext <> 'DEMOS' then
      DMIBObjCodeGen.ProjectAbbreviationNoSpaces :=
        DMIBObjCodeGen.ProjectAbbreviationNoSpaces + 'LOCAL';
    ZMLookup_Firebird_Credentials(DMIBObjCodeGen.ProjectAbbreviationNoSpaces,
      DBName, DBUser, DBPass);
    LabelDBInfo.Caption := DBName + ' ' + DBUser + ' ' + DBPass;
    CreateIfNil(DBName, DBUser, DBPass);
  end;
end;

function TfmCodeGenerator.RestorerActiveHere: Boolean;
begin
  Result := False;
end;

(*procedure TfmCodeGenerator.TranslateIncomingStringBreaks(Sender: TObject;
  var InputFields: TStrings; NumberOfFields: integer);
begin
// do nothing for now
end;*)

procedure TfmCodeGenerator.TranslateOutgoingStringBreaks(var AString: string);
var
  SAnsi: AnsiString;
  Raw: TBytes;
const
  // http://www.fileformat.info/info/unicode/char/2029/index.htm
  cParaBreak: UnicodeString = #$2029; // '#CRLF#';
begin
  (* required during transition from CHARSET None to CHARSET UTF8. *)
  Raw := BytesOf(AString);
  SAnsi := UTF8ToAnsiCodePage(UTF8String(Raw), 1252);
  AString := AnsiCodePageToUnicode(SAnsi, 1252);

  // unicode parabreak
  //AString := StringReplace(AString, sLineBreak, cParaBreak, [rfReplaceAll]);
  AString := StringReplaceAll(AString, sLineBreak, cParaBreak);
end;

end.
