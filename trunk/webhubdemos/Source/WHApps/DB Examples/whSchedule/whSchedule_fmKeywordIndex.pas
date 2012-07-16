unit whSchedule_fmKeywordIndex;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 1995-2011 HREF Tools Corp.  All Rights Reserved Worldwide. * }
{ *                                                                          * }
{ * This source code file is part of WebHub v2.1x.  Please obtain a WebHub   * }
{ * development license from HREF Tools Corp. before using this file, and    * }
{ * refer friends and colleagues to http://www.href.com/webhub. Thanks!      * }
{ ---------------------------------------------------------------------------- }

interface

{$I hrefdefines.inc}

uses
  Forms, Controls, Dialogs, Graphics, ExtCtrls, StdCtrls, ActnList, Vcl.Buttons,
  SysUtils, Classes,
  IB_Components, IBODataSet,
  rbBridge_i_ibobjects, rbMake, rbAccept,
  toolbar, utPanFrm, restorer, tpCompPanel, rbPrgDlg, rbCache, uLingvoCodePoints;

type
  TfmRubiconIndex = class(TutParentForm)
    ToolBar: TtpToolBar;
    tpComponentPanel: TtpComponentPanel;
    Panel: TPanel;
    ActionList1: TActionList;
    tpToolButton1: TtpToolButton;
    ActionCreateIndex: TAction;
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
  webLink, tpFirebirdCredentials, uFirebird_Connect_CodeRageSchedule,
  whdemo_DMIBObjCodeGen;

{ TfmRubiconIndex }

procedure TfmRubiconIndex.ActionCreateIndexExecute(Sender: TObject);
var
  DBName, DBUser, DBPass: string;
begin
  inherited;
  makewordslink := TrbMakeWordsIBOLink.Create(Self);
  makewordslink.Name := 'makewordslink';
  makewordslink.TableName := 'WORDS';

  rbMake1 := TrbMake.Create(Self);
  rbMake1.Name := 'rbMake1';
  rbMake1.Ansi := False;  // UTF16

  rbAccept1 := TrbAccept.Create(Self);
  rbAccept1.Name := 'rbAccept1';
  rbAccept1.Alpha := CNFInternationalAlphabet;
  rbAccept1.NoLeadingNumbers := True;

  rbMake1.WordDelims := CNFInternationalWordDelims;
  rbMake1.MinWordLen := 4; // cCNFMinWordLen;

  rbProgressDialog1 := TrbProgressDialog.Create(Self);
  rbProgressDialog1.Name := 'rbProgressDialog1';
  rbProgressDialog1.Engine := rbMake1;

  rbCache1 := TrbCache.Create(Self);
  rbCache1.Name := 'rbCache1';
  rbMake1.Cache := rbCache1;

  ZMLookup_Firebird_Credentials(DMIBObjCodeGen.ProjectAbbreviationNoSpaces,
    DBName, DBUser, DBPass);
  CreateIfNil(DBName, DBUser, DBPass);
  if NOT gCodeRageSchedule_Conn.Connected then
    gCodeRageSchedule_Conn.Connect;

  QMake := TIBOQuery.Create(Self);
  QMake.Name := 'QMake';
  QMake.IB_Connection := gCodeRageSchedule_Conn;
  QMake.IB_Transaction := gCodeRageschedule_Tr;

  QData := TIBOQuery.Create(Self);
  QData.Name := 'QData';
  QData.IB_Connection := gCodeRageSchedule_Conn;
  QData.IB_Transaction := gCodeRageschedule_Tr;
  makewordslink.IBOQuery := QData;

  rbMakeTextLink1 := TrbMakeTextIBOLink.Create(Self);
  rbMakeTextLink1.Name := 'rbMakeTextLink1';
  rbMakeTextLink1.TableName := 'Schedule';
  rbMakeTextLink1.IndexFieldName := 'SchNo';
  rbMakeTextLink1.FieldNames.Text :=
    'SchTitle' + sLineBreak +
    'SchPresenterFullName' + sLineBreak +
    'SchPresenterOrg' + sLineBreak + 'SchBlurb';
  rbMakeTextLink1.IBOQuery := QMake;
  rbMake1.TextLink := rbMakeTextLink1;
  rbMake1.WordsLink := makewordslink;

  rbMake1.Execute;
end;

procedure TfmRubiconIndex.FormCreate(Sender: TObject);
begin
  inherited;
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

end.
