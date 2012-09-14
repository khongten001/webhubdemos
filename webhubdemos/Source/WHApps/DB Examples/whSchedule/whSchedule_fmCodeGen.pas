unit whSchedule_fmCodeGen;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2012 HREF Tools Corp.  All Rights Reserved Worldwide.      * }
{ *                                                                          * }
{ * This source code file is part of WebHub v2.1x.  Please obtain a WebHub   * }
{ * development license from HREF Tools Corp. before using this file, and    * }
{ * refer friends and colleagues to http://www.href.com/webhub. Thanks!      * }
{ *                                                                          * }
{ ---------------------------------------------------------------------------- }

{ ---------------------------------------------------------------------------- }
{ * Requires WebHub v2.171+                                                  * }
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
    tsCodeGenBasics: TTabSheet;
    tpToolBar3: TtpToolBar;
    tpToolButton10: TtpToolButton;
    TabSheet3: TTabSheet;
    tpToolBar4: TtpToolBar;
    tpToolButton15: TtpToolButton;
    tpToolButton16: TtpToolButton;
    mOutput: TMemo;
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
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    FProjectConnection: TIB_Connection;
    FProjectTransaction: TIB_Transaction;
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
  IB_Export, IB_Import,
  ucLogFil, ucDlgs, ucString, ucAnsiUtil,
  ucIbAndFbCredentials, ucIBObjCodeGen_Bootstrap, ucIBObjCodeGen,
  webApp, webLink,
  uFirebird_Connect_CodeRageSchedule, uFirebird_SQL_Snippets_CodeRageSchedule,
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
const
  cProjectAbbrev = 'CodeRageSchedule';
begin
  inherited;
  { Bootstrap step must be done once at the beginning, to create the unit that
    is subsequently used for all connections to the firebird database. }
  mOutput.Clear;
  if DirectoryExists(cPASOutputRoot) then
  begin
    BootstrapFilespec := cPASOutputRoot +
      'uFirebird_Connect_' + cProjectAbbrev + '.pas';
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
      IbAndFb_GenPAS_Connect(False, cProjectAbbrev, BootstrapFilespec);
      mOutput.Lines.Text := StringLoadFromFile(BootstrapFilespec);
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
  x: Integer;
begin
  inherited;

//  {$IFDEF CodeSite}CodeSite.Send('4fields', Firebird_GetSQL_Fieldlist4Table);{$ENDIF}

  y := nil;

  Init;

  mOutput.Lines.Text := DBName;
  mOutput.Lines.Add('connecting...');
  Application.ProcessMessages;
  FProjectConnection.Connect;

  try
    Firebird_GetTablesInDatabase(y, Flag, DBName,
      FProjectConnection, FProjectTransaction, DBUser, DBPass);
    x := y.IndexOf('Words');
    if x > -1 then
      y.Delete(x);  // no generation for Rubicon Words table.

    case cbCodeGenPattern.ItemIndex of
      0: CodeContent := DMIBObjCodeGen.CodeGenForPattern(FProjectConnection,
        y, cgpMacroLabelsForFields);
      1: CodeContent := DMIBObjCodeGen.CodeGenForPattern(FProjectConnection,
        y, cgpMacroPKsForTables);
      2: CodeContent := DMIBObjCodeGen.CodeGenForPattern(FProjectConnection,
        y, cgpFieldListForImport);
      3: CodeContent := DMIBObjCodeGen.CodeGenForPattern(FProjectConnection,
        y, cgpSelectSQLDroplet);
      4: CodeContent := DMIBObjCodeGen.CodeGenForPattern(FProjectConnection,
        y, cgpUpdateSQLDroplet);
      5: CodeContent := DMIBObjCodeGen.CodeGenForPattern(FProjectConnection,
        y, cgpInstantFormReadonly);
      6: CodeContent := DMIBObjCodeGen.CodeGenForPattern(FProjectConnection,
        y, cgpInstantFormEdit);
      7: CodeContent := DMIBObjCodeGen.CodeGenForPattern(FProjectConnection,
        y, cgpInstantFormEditLabelAbove);
    end;
  finally
    FreeAndNil(y);
  end;

  Application.ProcessMessages;
  mOutput.Lines.Text := CodeContent;
  FProjectConnection.DisconnectToPool;
end;

procedure TfmCodeGenerator.ActionExportExecute(Sender: TObject);
var
  q: TIB_Cursor;
  ex: TIB_Export;

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
    mOutput.Lines.Add(q.SQL.Text);
    ex.Filename := 'D:\Projects\webhubdemos\Live\Database\whSchedule\backup\' +
      InTablename + '.csv';
    mOutput.Lines.Add(ex.Filename);
    q.Open;
    ex.Execute;
    mOutput.Lines.Add('Done with ' + InTablename);
    mOutput.Lines.Add('');
  end;

begin
  inherited;

  Init;
  FProjectConnection.Connect;

  ex := nil;
  q := nil;
  try
    q := TIB_Cursor.Create(Self);
    q.IB_Connection := FProjectConnection;
    q.IB_Transaction := FProjectTransaction;
    q.Name := 'q4export';
    ex := TIB_Export.Create(Self);
    ex.Dataset := q;
    ex.ExportFormat := efText_Delimited;

    {While humans like to see headers in the CSV file, they did not prove 
    to be machine readable in this particular case of the schedule database. 
    They were turned off here to avoid having to chase down the root cause. 
    Headers probably work fine in many other projects.  You will find out 
    during export and/or when you try to import.}

    ex.IncludeHeaders := False;
    ex.OnTranslateString := TranslateOutgoingStringBreaks;
    mOutput.Clear;
    Export_1_Table('ABOUT');
    Export_1_Table('XPRODUCT');
    Export_1_Table('SCHEDULE');
  finally
    FreeAndNil(ex);
    FreeAndNil(q);
  end;
  FProjectConnection.DisconnectToPool;
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
  mOutput.Lines.Clear;
  mOutput.Lines.Add('Starting... takes time depending on connection speed');
  mOutput.Lines.Add('');

  Init;
  mOutput.Lines.Add(FBDB);
  mOutput.Lines.Add(FBUsername + #9 + FBPassword);
  mOutput.Lines.Add('');

  FProjectConnection.Connect;

  Firebird_GetTablesInDatabase(y, Flag, FBDB,
    FProjectConnection, FProjectTransaction, FBUsername, FBPassword);

  if Assigned(y) then
  begin
    Filespec :=
      cSQLOutputRoot + 'CodeRageSchedule_Triggers.sql';
    IbAndFb_GenSQL_Triggers(y, FProjectConnection,
      Filespec);
    mOutput.Lines.Add(Filespec);
    mOutput.Lines.Add('');

    Filespec :=
      cPASOutputRoot +
      'uStructureClientDataSets_' + DMIBObjCodeGen.ProjectAbbrevForCodeGen +
      '.pas';
    Firebird_GenPAS_StructureClientDatasets(y, FProjectConnection,
      DMIBObjCodeGen.ProjectAbbrevForCodeGen, Filespec);
    mOutput.Lines.Add(Filespec);
    mOutput.Lines.Add('');

    Filespec :=
      cPASOutputRoot +
      'uFirebird_SQL_Snippets_' + DMIBObjCodeGen.ProjectAbbrevForCodeGen + '.pas';
    Firebird_GenPAS_SQL_Snippets(y, FProjectConnection,
      DMIBObjCodeGen.ProjectAbbrevForCodeGen, Filespec);
    mOutput.Lines.Add(Filespec);
    mOutput.Lines.Add('');

    // Order Head and Detail need to be live datasets, not cached
    // BUT: it helps to have the Fill code for copy and paste samples
    Filespec :=
      cPASOutputRoot +
      'uFillClientDataSets_' + DMIBObjCodeGen.ProjectAbbrevForCodeGen + '.pas';
    Firebird_GenPAS_FillClientDatasets(y, FProjectConnection,
      DMIBObjCodeGen.ProjectAbbrevForCodeGen, Filespec);
    mOutput.Lines.Add(Filespec);
    mOutput.Lines.Add('');
  end;
  FreeAndNil(y);
  FProjectConnection.DisconnectToPool;
  mOutput.Lines.Add('Done! ' + FormatDateTime('dddd hh:nn:ss', Now));
end;

procedure TfmCodeGenerator.ActionImportExecute(Sender: TObject);
var
  im: TIB_Import;
begin
  inherited;
  im := nil;
  mOutput.Clear;

  Init;
  FProjectConnection.Connect;

  try
    im := TIB_Import.Create(Self);
    im.Name := 'import4coderage';
    im.IB_Connection := FProjectConnection;
    im.IB_Transaction := FProjectTransaction;
    im.ImportFormat := ifUTF8;
    try
      // XProduct table
      im.IniFile := cCSVIniRoot + 'ImportSpec_001_XProduct.ini';
      mOutput.Lines.Add(im.IniFile);
      im.ImportMode := mCopy;
      im.Execute;
      // schedule table
      im.IniFile := cCSVIniRoot + 'ImportSpec_002_schedule.ini';
      mOutput.Lines.Add(im.IniFile);
      im.ImportMode := mCopy;  // erase first then import
      //im.OnParse := TranslateIncomingStringBreaks;
      im.Execute;

      // About table (requires the above 2 present, first)
      im.IniFile := cCSVIniRoot + 'ImportSpec_003_about.ini';
      mOutput.Lines.Add(im.IniFile);
      im.ImportMode := mCopy;  // erase first then import
      im.Execute;
      mOutput.Lines.Add('Done');
    except
      on E: Exception do
      begin
        {$IFDEF CodeSite}CodeSite.SendException(E);{$ENDIF}
        mOutput.Lines.Add(E.Message);
      end;
    end;
  finally
    FreeAndNil(im);
  end;
  FProjectConnection.DisconnectToPool;
end;

procedure TfmCodeGenerator.FormCreate(Sender: TObject);
begin
  inherited;
  FlagInitDone := False;
end;

function TfmCodeGenerator.Init: Boolean;
var
  DBName, DBUser, DBPass: string;
begin
  Result := inherited Init;
  if NOT FlagInitDone then
  begin
    PageControl1.ActivePage := tsCodeGenBasics;
    cbCodeGenPattern.ItemIndex := 0;
    FlagInitDone := True;
  end;

  if DMIBObjCodeGen.ProjectAbbreviationNoSpaces = '' then
    DMIBObjCodeGen.ProjectAbbreviationNoSpaces :=
      LabeledEditProjectAbbrev.Text
  else
    LabeledEditProjectAbbrev.Text :=
      DMIBObjCodeGen.ProjectAbbreviationNoSpaces;

  ZMLookup_Firebird_Credentials(DMIBObjCodeGen.ProjectAbbreviationNoSpaces,
    DBName, DBUser, DBPass);
  LabelDBInfo.Caption := DBName + ' ' + DBUser + ' ' + DBPass;
  CreateIfNil(DBName, DBUser, DBPass);
  FProjectConnection := gCodeRageSchedule_Conn;
  FProjectTransaction := gCodeRageSchedule_Tr;

  {Set number of fields to prompt for, per HTML row}
  DMIBObjCodeGen.FieldsPerRowInInstantForm := 1;

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
