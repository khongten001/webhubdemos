unit whSchedule_fmKeywordIndex;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2012 HREF Tools Corp.  All Rights Reserved Worldwide.      * }
{ *                                                                          * }
{ * WebHub panel for creating the keyword index using Rubicon.               * }
{ *                                                                          * }
{ * Requires: Firebird SQL                                                   * }
{ *           Rubicon components from HREF Tools Corp.                       * }
{ ---------------------------------------------------------------------------- }

interface

{$I hrefdefines.inc}

(*
  {$I xe_actions.inc}
  {$I xe_actnlist.inc}
*)

uses
  Forms, Controls, Dialogs, Graphics, ExtCtrls, StdCtrls, Buttons, SysUtils,
  Classes, DB,
  IB_Components, IBODataSet,
  rbBridge_i_ibobjects, rbMake, rbAccept, rbPrgDlg, rbCache, rbBase,
  toolbar, utPanFrm, restorer, tpCompPanel,
  uLingvoCodePoints, System.Actions, Vcl.ActnList;

type
  TfmRubiconIndex = class(TutParentForm)
    ToolBar: TtpToolBar;
    tpComponentPanel: TtpComponentPanel;
    Panel: TPanel;
    ActionList1: TActionList;
    tpToolButton1: TtpToolButton;
    ActionCreateIndex: TAction;
    Memo1: TMemo;
    procedure ActionCreateIndexExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    rbMake1: TrbMake;
    makewordslink: TrbMakeWordsIBOLink;
    rbAccept1: TrbAccept;
    rbProgressDialog1: TrbProgressDialog;
    rbMakeTextLink1: TrbMakeTextIBOLink;
    rbCache1: TrbCache;
    QMake: TIBOQuery;
    QData: TIBOQuery;
    function ScheduleAcceptWord(Sender: TObject; const InWord: string) : Boolean;
    procedure ScheduleAfterSQL(Sender: TObject; SQL: TStringBuilder);
    procedure ScheduleProcessField(Sender: TObject; Engine: TrbEngine; Field:
    TField);
  public
    { Public declarations }
    function Init: Boolean; override;
    function RestorerActiveHere: Boolean; override;
  end;

var
  fmRubiconIndex: TfmRubiconIndex;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webLink, webApp, htWebApp,
  ucIbAndFbCredentials, uFirebird_Connect_CodeRageSchedule,
  ucCodeSiteInterface,
  whdemo_DMIBObjCodeGen;

{ TfmRubiconIndex }

procedure TfmRubiconIndex.ActionCreateIndexExecute(Sender: TObject);
var
  DBName, DBUser, DBPass: string;
  ACoverPageFilespec: string;
begin
  inherited;
  if gCodeRageSchedule_Conn = nil then
  begin
    Memo1.Lines.Text := 'Project: ' +
      DMIBObjCodeGen.ProjectAbbreviationNoSpaces;
    ZMLookup_Firebird_Credentials(DMIBObjCodeGen.ProjectAbbreviationNoSpaces,
      DBName, DBUser, DBPass);
    Memo1.Lines.Add(DBName);
    CreateIfNil(DBName, DBUser, DBPass);
  end;

  CoverApp(pWebApp.AppID, 5, 'Recreating index for training archive',
    False, ACoverPageFilespec);

  // Stop all use of the WORDS table temporarily
  gCodeRageSchedule_Conn.DisconnectToPool;
  gCodeRageSchedule_Conn.Connect;

  Assert(SameText(gCodeRageSchedule_Conn.CharSet, 'UTF8'),
    gCodeRageSchedule_Conn.DatabaseName + ' charset!');

  if NOT Assigned(makewordslink) then
  begin
    makewordslink := TrbMakeWordsIBOLink.Create(Self);
    makewordslink.Name := 'makewordslink';
    makewordslink.TableName := 'WORDS';

    rbMake1 := TrbMake.Create(Self);
    rbMake1.Name := 'rbMake1';
    rbMake1.Ansi := False;  // very important! Unicode! UTF16!
    rbMake1.OnAcceptWord := ScheduleAcceptWord;

    rbAccept1 := TrbAccept.Create(Self);
    rbAccept1.Name := 'rbAccept1';
    rbAccept1.Alpha := DemoInternationalAlphabet;
    rbAccept1.NoLeadingNumbers := True;

    rbMake1.WordDelims := DemoInternationalWordDelims;
    rbMake1.MinWordLen := 2; // cCNFMinWordLen;

    rbProgressDialog1 := TrbProgressDialog.Create(Self);
    rbProgressDialog1.Name := 'rbProgressDialog1';
    rbProgressDialog1.Engine := rbMake1;

    rbCache1 := TrbCache.Create(Self);
    rbCache1.Name := 'rbCache1';
    rbMake1.Cache := rbCache1;

    QMake := TIBOQuery.Create(Self);
    QMake.Name := 'QMake';
    QMake.IB_Connection := gCodeRageSchedule_Conn;
    QMake.IB_Session := gCodeRageSchedule_Sess;
    QMake.IB_Transaction := gCodeRageschedule_Tr;

    QData := TIBOQuery.Create(Self);
    QData.Name := 'QData';
    QData.IB_Connection := gCodeRageSchedule_Conn;
    QData.IB_Session := gCodeRageSchedule_Sess;
    QData.IB_Transaction := gCodeRageschedule_Tr;
    makewordslink.IBOQuery := QData;
    makewordslink.AfterSQL := ScheduleAfterSQL;

    rbMakeTextLink1 := TrbMakeTextIBOLink.Create(Self);
    rbMakeTextLink1.Name := 'rbMakeTextLink1';
    rbMakeTextLink1.TableName := 'Schedule';
    rbMakeTextLink1.IndexFieldName := 'SchNo';
    rbMakeTextLink1.FieldNames.Text :=
      'SchTitle' + sLineBreak +
      'SchPresenterFullName' + sLineBreak +
      'SchPresenterOrg' + sLineBreak + 'SchBlurb' + sLineBreak + 'SchRepeatOf';
    rbMakeTextLink1.IBOQuery := QMake;
    rbMakeTextLink1.OnProcessField := ScheduleProcessField;
    rbMake1.TextLink := rbMakeTextLink1;
    rbMake1.WordsLink := makewordslink;
  end;

  Memo1.Lines.Add('Starting to use Rubicon to create the keyword index');
  try
    rbMake1.Execute;
    Memo1.Lines.Add('Done. ' + FormatDateTime('dddd hh:nn:mm', Now));
    gCodeRageSchedule_Conn.DisconnectToPool;
    gCodeRageSchedule_Conn.Connect;
  except
    on E: Exception do
    begin
      {$IFDEF CodeSite}CodeSite.SendException(E);{$ENDIF}
      Memo1.Lines.Add(E.Message);
    end;
  end;
  UncoverApp(pWebApp.AppID, ACoverPageFilespec);
end;

procedure TfmRubiconIndex.FormCreate(Sender: TObject);
begin
  inherited;
  Memo1.Clear;
  makewordslink := nil;
  rbMake1 := nil;
  rbProgressDialog1 := nil;
  QMake := nil;
  QData := nil;
  rbMakeTextLink1 := nil;
  rbCache1 := nil;
end;

procedure TfmRubiconIndex.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(makewordslink);
  FreeAndNil(rbMake1);
  FreeAndNil(rbProgressDialog1);
  FreeAndNil(QMake);
  FreeAndNil(QData);
  FreeAndNil(rbMakeTextLink1);
  FreeAndNil(rbCache1);
end;

function TfmRubiconIndex.Init: Boolean;
begin
  Result := inherited Init;
  if not Result then
    Exit;
end;

function TfmRubiconIndex.RestorerActiveHere: Boolean;
begin
  Result := False;
end;

function TfmRubiconIndex.ScheduleAcceptWord(Sender: TObject;
  const InWord: string): Boolean;
begin
  Result := Length(InWord) >= 4;
  if NOT Result then
  begin
    Result := SameText('XE', Copy(InWord, 1, 2)); // XE, XE2, XE3
  end;
end;

procedure TfmRubiconIndex.ScheduleAfterSQL(Sender: TObject; SQL: TStringBuilder);
begin
  CSSend('SQL', SQL.ToString);
end;

procedure TfmRubiconIndex.ScheduleProcessField(Sender: TObject;
  Engine: TrbEngine; Field: TField);
begin
  if Field.DataSet.FieldByName('SchRepeatOf').AsString = '' then
    Engine.ProcessString(Field.AsString);
end;

end.
