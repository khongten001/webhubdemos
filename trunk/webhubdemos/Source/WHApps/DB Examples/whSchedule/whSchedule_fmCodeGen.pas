unit whSchedule_fmCodeGen;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2012 HREF Tools Corp.  All Rights Reserved Worldwide.      * }
{ ---------------------------------------------------------------------------- }

interface

{$I hrefdefines.inc}
{$DEFINE BootStrapDone}

uses
  Forms, Controls, Dialogs, Graphics, ExtCtrls, StdCtrls,
  SysUtils, Classes,
  toolbar, utPanFrm, restorer, tpCompPanel, ActnList, Vcl.Buttons;

type
  TfmCodeGenerator = class(TutParentForm)
    ToolBar: TtpToolBar;
    tpComponentPanel: TtpComponentPanel;
    Panel: TPanel;
    ActionList1: TActionList;
    tpToolBar1: TtpToolBar;
    tpToolButton1: TtpToolButton;
    ActionBootstrap: TAction;
    Memo1: TMemo;
    tpToolButton2: TtpToolButton;
    ActionGenPASandSQL: TAction;
    procedure ActionBootstrapExecute(Sender: TObject);
    procedure ActionGenPASandSQLExecute(Sender: TObject);
  private
    { Private declarations }
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
  ucLogFil, ucDlgs, tpIBOCodeGenerator_Bootstrap,
  webLink, uFirebird_Connect_CodeRageSchedule, tpIBOCodeGenerator,
  tpFirebirdCredentials;

const
  cProjectAbbreviationNoSpaces = 'CodeRageSchedule';
  cPASOutputRoot = 'D:\Projects\webhubdemos\' +
    'Source\WHApps\DB Examples\whSchedule\';
  cSQLOutputRoot = 'D:\Projects\webhubdemos\' +
    'Source\WHApps\DB Examples\whSchedule\DBDesign\gen_sql\';

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

  ZMLookup_Firebird_Credentials('CodeRageScheduleLOCAL', FBDB, FBUsername,
    FBPassword);
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
      'uStructureClientDataSets_' + cProjectAbbreviationNoSpaces + '.pas';
    Firebird_GenPAS_StructureClientDatasets(y, gCodeRageSchedule_Conn,
      cProjectAbbreviationNoSpaces, Filespec);
    Memo1.Lines.Add(Filespec);
    Memo1.Lines.Add('');

    Filespec :=
      cPASOutputRoot +
      'uFirebird_SQL_Snippets_' + cProjectAbbreviationNoSpaces + '.pas';
    Firebird_GenPAS_SQL_Snippets(y, gCodeRageSchedule_Conn,
      cProjectAbbreviationNoSpaces, Filespec);
    Memo1.Lines.Add(Filespec);
    Memo1.Lines.Add('');

    // Order Head and Detail need to be live datasets, not cached
    // BUT: it helps to have the Fill code for copy and paste samples
    Filespec :=
      cPASOutputRoot +
      'uFillClientDataSets_' + cProjectAbbreviationNoSpaces + '.pas';
    Firebird_GenPAS_FillClientDatasets(y, gCodeRageSchedule_Conn,
      cProjectAbbreviationNoSpaces, Filespec);
    Memo1.Lines.Add(Filespec);
    Memo1.Lines.Add('');
  end;
  FreeAndNil(y);
  gCodeRageSchedule_Conn.DisconnectToPool;
  Memo1.Lines.Add('Done! ' + FormatDateTime('dddd hh:nn:ss', Now));
end;

function TfmCodeGenerator.Init: Boolean;
begin
  Result := inherited Init;
  if not Result then
    Exit;
  // Call RefreshWebActions here only if it is not called within a TtpProject event
  // RefreshWebActions(Self);
end;

function TfmCodeGenerator.RestorerActiveHere: Boolean;
begin
  Result := False;
end;

end.
