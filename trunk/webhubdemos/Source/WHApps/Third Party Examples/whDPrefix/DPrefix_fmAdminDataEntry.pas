unit DPrefix_fmAdminDataEntry; // GUI for quick data entry by administrator

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 1999-2017 HREF Tools Corp.  All Rights Reserved Worldwide. * }
{ *                                                                          * }
{ * This source code file is part of the Delphi Prefix Registry.             * }
{ *                                                                          * }
{ * This file is licensed under a Creative Commons Attribution 2.5 License.  * }
{ * http://creativecommons.org/licenses/by/2.5/                              * }
{ * If you use this file, please keep this notice intact.                    * }
{ *                                                                          * }
{ * Author: Ann Lynnworth                                                    * }
{ *                                                                          * }
{ * Refer friends and colleagues to www.href.com/whvcl. Thanks!              * }
{ ---------------------------------------------------------------------------- }

{$I hrefdefines.inc}

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, Grids, DBGrids, DB, DBCtrls, ExtCtrls, StdCtrls,
  System.Actions, // requires D17 XE3
  Vcl.ActnList,   // requires D17 XE3
  utPanFrm, updateOk, tpAction, toolbar, tpCompPanel, restorer, tpStatus,
  webTypes, webLink, webCall, webLogin, wdbSource, wdbLink, wdbScan,
  wdbGrid, wdbSSrc,
  DPrefix_dmAdminDataEntry;

type
  TfmWhActions = class(TutParentForm)
    ToolBar: TtpToolBar;
    tpComponentPanel2: TtpComponentPanel;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    tpStatusBar1: TtpStatusBar;
    tpToolButton1: TtpToolButton;
    GroupBox3: TGroupBox;
    tpToolButton3: TtpToolButton;
    tpToolButton5: TtpToolButton;
    ComboBoxStatus: TComboBox;
    procedure tpToolButton1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  fmWhActions: TfmWhActions = nil;

implementation

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  nxDB,
  DateUtils, Character,
  ucBase64, //encoding and decoding the of the primary key of the component prefix.. not really needed in this case
  ucDlgs,   //admin/non-web confirmation questions
  ucString, //string utilities, splitstring, startswith, isequal, etc..
  ucFile,   //ForceDirectories insures that a legal path exists
  ucShell, ucPos, ucLogFil, ucMsTime, ZM_CodeSiteInterface,
  webapp,   //access to pWebApp
  webSend, webScan, DPrefix_dmNexus, whutil_ValidEmail, DPrefix_dmWhActions,
  whdemo_Extensions;

{$R *.DFM}

//------------------------------------------------------------------------------

procedure TfmWhActions.FormCreate(Sender: TObject);
begin
  inherited;
  tpToolButton5.OnClick := DMAdminDataEntry.ActDeleteStatusDExecute;
  tpToolButton1.OnClick := tpToolButton1Click;

end;

procedure TfmWhActions.FormDestroy(Sender: TObject);
begin
  inherited;
  fmWhActions := nil;
end;

//------------------------------------------------------------------------------

function TfmWhActions.Init: Boolean;
begin
  Result := inherited Init;
end;

procedure TfmWhActions.tpToolButton1Click(Sender: TObject);
begin
  inherited;
  //use dis/en-ablecontrols!
  with DBGrid1 do
    if DataSource=nil then
    begin
      DataSource:=DMDPRWebAct.dsAdmin;
      DBNavigator1.DataSource:=DMDPRWebAct.dsAdmin;
      case ComboBoxStatus.ItemIndex of
        0: DMNexus.TableAdminUnfiltered;
        1: DMNexus.TableAdminOnlyPending;
        2: DMNexus.TableAdminOnlyDelete;
        // 3: DMNexus.TableAdminOnlyApproved;
        4: DMNexus.TableAdminOnlyBlankEMail;
        5: DMNexus.TableAdminOnlyAmpersand;
        else  MsgErrorOk('ComboBoxStatus.ItemIndex' +
          IntToStr(ComboBoxStatus.ItemIndex) + ' not implemented');
      end;
    end
    else
    begin
      DMNexus.TableAdminUnfiltered;
      DataSource:=nil;
      DBNavigator1.DataSource:=nil;
    end;
end;

end.

