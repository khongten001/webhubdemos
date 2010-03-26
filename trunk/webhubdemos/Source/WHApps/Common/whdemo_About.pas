unit whdemo_About;  {panel to help self-document all WebHub demos}
////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1995-2008 HREF Tools Corp.  All Rights Reserved Worldwide.  //
//                                                                            //
//  This source code file is part of WebHub v2.09x.  Please obtain a WebHub   //
//  development license from HREF Tools Corp. before using this file, and     //
//  refer friends and colleagues to href.com/webhub for downloading. Thanks!  //
////////////////////////////////////////////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls,
  UTPANFRM, ExtCtrls, StdCtrls, TpMemo, tpStatus, UpdateOk, 
  tpAction, WebTypes,   WebLink, ActnList, toolbar, {}tpCompPanel, Buttons;

type
  TfmAppAboutPanel = class(TutParentForm)
    Panel1: TPanel;
    Panel: TPanel;
    LabelShortDesc: TLabel;
    LabelQueryString: TLabel;
    Panel3: TPanel;
    LabelCopyright: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LabelAbout: TLabel;
    Panel2: TPanel;
    Panel4: TPanel;
    tpToolBar1: TtpToolBar;
    btnToggleConnection: TtpToolButton;
    tpComponentPanel1: TtpComponentPanel;
    ActionList1: TActionList;
    ActionToggleConnection: TAction;
    GroupBoxWHXP: TGroupBox;
    ActionShowConnectionDetail: TAction;
    tpToolButton1: TtpToolButton;
    Splitter1: TSplitter;
    Panel5: TPanel;
    Panel6: TPanel;
    LabelIdentification: TLabel;
    LabelDllCalls: TLabel;
    LabelAboutHarry: TLabel;
    procedure LabelURLClick(Sender: TObject);
    procedure ActionToggleConnectionExecute(Sender: TObject);
    procedure ActionShowConnectionDetailExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    destructor Destroy; override;
    function Init: Boolean; override;
    procedure SetAboutLabels(Sender: TObject);
  end;

var
  fmAppAboutPanel: TfmAppAboutPanel = nil;

implementation

{$R *.DFM}

uses
  ucShell, ucVers, ucString,
{$IFDEF WEBHUBACE}
  whxpUtils,
{$ENDIF}
  webApp, whConst, htWebApp, webCall;

//------------------------------------------------------------------------------

function TfmAppAboutPanel.Init: Boolean;
begin
  Result := inherited Init;
  if not Result then
    Exit;
  AddAppUpdateHandler(SetAboutLabels);
  GroupBoxWHXP.Visible := True;
  Result := assigned(pWebApp) and pWebApp.IsUpdated;
  if Result then
  begin
    SetAboutLabels(pWebApp);
    RefreshWebActions(Self);
  end;
end;

procedure TfmAppAboutPanel.SetAboutLabels(Sender: TObject);
var
  S: String;
begin
  S := GetVersionString(vsLegalCopyright);
  LabelCopyright.Caption := 'Copyright ';
  if S = '' then
    LabelCopyRight.Caption := LabelCopyright.Caption + '(c) 1997-' +
      FormatDateTime('yyyy', Now) + ' HREF Tools Corp.'
  else
    LabelCopyRight.Caption := LabelCopyright.Caption + S;

  with pWebApp do
  begin
    LabelShortDesc.Caption :=
      Macros.Values['mcWhDemoOneLiner' + AppID]; // e.g. 'Ad Rotation'
    if LabelShortDesc.Caption = '' then
      LabelShortDesc.Caption := AppID;
    S := ExtractFilePath(pWebApp.ConfigFilespec);
    with LabelQueryString do
    begin
      Caption := '?' + AppID + ':' + Situations.HomePageID;
    end;
    with LabelAbout do
    begin
      Caption := '?' + AppID + ':pgAbout::' + AppID;
    end;
  end;
  ActionShowConnectionDetailExecute(Self);
end;

procedure TfmAppAboutPanel.LabelURLClick(Sender: TObject);
begin
  inherited;
  with TLabel(Sender) do
    ucShell.WinShellOpen('http://localhost/scripts/runisa.dll' + Caption);
end;

procedure TfmAppAboutPanel.ActionToggleConnectionExecute(Sender: TObject);
begin
  inherited;
  if (NOT Assigned(pConnection)) or (NOT pConnection.IsUpdated) then
    Exit;

  with btnToggleConnection do
  begin
    if IsEqual(Caption, 'suspend') then
    begin
      pConnection.Active := False;
      Caption := 'Resume';
    end
    else
    begin
      pConnection.Active := True;
      Caption := 'Suspend';
    end;
  end;

end;

procedure TfmAppAboutPanel.ActionShowConnectionDetailExecute(
  Sender: TObject);
{$IFDEF WEBHUBACE}
var
  Port: Integer;
  pid: Cardinal;
{$ENDIF}
begin
  inherited;
{$IFDEF WEBHUBACE}
  LabelDllCalls.Caption := 'Calls: ' + IntToStr(pConnection.DllCalls);
  LabelIdentification.Caption := 'AppID=' + pConnection.AppID +
    ' and PID=' + IntToStr(getCurrentProcessID) +
    ' Slot#' + IntToStr(pConnection.SlotNo); {17-Dec-2004}
  if GetHarryListenPortAndPID(Port, pid) then
  begin
    LabelAboutHarry.Caption := 'Harry is running with PID ' + IntToStr(pid) +
      ' and looking for data on port ' + IntToStr(Port) + '.';
  end
  else
    LabelAboutHarry.Caption := 'Harry not running'
{$ELSE}
  LabelDllCalls.Caption := '';
  LabelIdentification.Caption := 'AppID=' + pWebApp.AppID +
    ' and Handle=' + IntToStr(Application.Handle);
  if pWebApp.ConnectToHub then
    LabelAboutHarry.Caption := 'Connect to Hub = True'
  else
    LabelAboutHarry.Caption := 'Connect to Hub = False';
{$ENDIF}
end;

destructor TfmAppAboutPanel.Destroy; 
begin
  inherited;
  fmAppAboutPanel := nil;
end;

end.
