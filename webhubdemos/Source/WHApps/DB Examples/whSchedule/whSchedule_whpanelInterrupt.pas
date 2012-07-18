unit whSchedule_whpanelInterrupt;
////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1995-2012 HREF Tools Corp.  All Rights Reserved Worldwide.  //
//                                                                            //
//  This source code file is part of WebHub v2.1x.  Please obtain a WebHub    //
//  development license from HREF Tools Corp. before using this file, and     //
//  refer friends and colleagues to href.com/webhub for downloading. Thanks!  //
////////////////////////////////////////////////////////////////////////////////

interface

{$I hrefdefines.inc}

uses
{$IFDEF LINUX}
  QForms, QControls, QDialogs, QGraphics, QExtCtrls, QStdCtrls,
{$ELSE}
  Forms, Controls, Dialogs, Graphics, ExtCtrls, StdCtrls,
{$ENDIF}
  SysUtils, Classes,
  toolbar, utPanFrm, restorer, tpCompPanel, ActnList, Buttons;

type
  TfmAppDBInterrupt = class(TutParentForm)
    ToolBar: TtpToolBar;
    tpComponentPanel: TtpComponentPanel;
    Panel: TPanel;
    ActionList1: TActionList;
    tpToolButton1: TtpToolButton;
    ActionDBOFF: TAction;
    ActionDBOn: TAction;
    tpToolButton2: TtpToolButton;
    tpToolButton3: TtpToolButton;
    ActionBackup: TAction;
    tpToolButton4: TtpToolButton;
    ActionRestore: TAction;
    tpToolButton5: TtpToolButton;
    ActionImport: TAction;
    tpToolButton6: TtpToolButton;
    procedure ActionDBOFFExecute(Sender: TObject);
    procedure ActionDBOnExecute(Sender: TObject);
    procedure tpToolButton3Click(Sender: TObject);
    procedure ActionBackupExecute(Sender: TObject);
    procedure ActionRestoreExecute(Sender: TObject);
    procedure ActionImportExecute(Sender: TObject);
  private
    { Private declarations }
    ACoverPageFilespec: string;
  public
    { Public declarations }
    function Init: Boolean; override;
    function RestorerActiveHere: Boolean; override;
  end;

var
  fmAppDBInterrupt: TfmAppDBInterrupt;

implementation

uses
  ucShell, ucDlgs, ucDlgsGUI, ucString,
  whcfg_App, webApp, htWebApp,
  //CodeRage_dmCommon, whSchedule_uImport,
  whSchedule_dmwhActions,
  uFirebird_Connect_CodeRageSchedule;

{$R *.dfm}

{ TfmAppDBInterrupt }

function TfmAppDBInterrupt.Init: Boolean;
begin
  Result := inherited Init;
  if not Result then
    Exit;
end;

function TfmAppDBInterrupt.RestorerActiveHere: Boolean;
begin
  Result := False;
end;

procedure TfmAppDBInterrupt.ActionDBOFFExecute(Sender: TObject);
begin
  inherited;
  gCodeRageSchedule_Conn.Connected := False;
  CoverApp('coderage', 2, 'Loading new schedule info', False,
    ACoverPageFilespec);
end;

procedure TfmAppDBInterrupt.ActionDBOnExecute(Sender: TObject);
begin
  inherited;
  gCodeRageSchedule_Conn.Connected := True;
  DMCodeRageActions.ResetDBConnection;
  UnCoverApp(ACoverPageFilespec);
end;

procedure TfmAppDBInterrupt.tpToolButton3Click(Sender: TObject);
begin
  inherited;
  pWebApp.Refresh;
end;

procedure TfmAppDBInterrupt.ActionBackupExecute(Sender: TObject);
var
  ErrorText: string;
begin
  inherited;
  Launch('launch-backup.bat', '',
    'D:\Projects\WebHubDemos\Live\Database\whSchedule',
    True, 10 * 1000, ErrorText);
  if ErrorText <> '' then
    MsgWarningOk(ErrorText);
end;

procedure TfmAppDBInterrupt.ActionRestoreExecute(Sender: TObject);
var
  ErrorText: string;
begin
  inherited;
  if (NOT IsEqual(pWebApp.ZMDefaultMapContext, 'DEMOS')) and
     (NOT IsEqual(pWebApp.ZMDefaultMapContext, 'DORIS')) 
  then
  begin
    MsgWarningOk('Only on DEMOS!');
    Exit;
  end;
  Launch('launch-restore.bat', '',
    'D:\Projects\WebHubDemos\Live\Database\whSchedule',
    True, 10 * 1000, ErrorText);
  if ErrorText <> '' then
    MsgWarningOk(ErrorText);
end;

procedure TfmAppDBInterrupt.ActionImportExecute(Sender: TObject);
begin
  inherited;
(*  ImportProductAbout; *)
end;

end.
