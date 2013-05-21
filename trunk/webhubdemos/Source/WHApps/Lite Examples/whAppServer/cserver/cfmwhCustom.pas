unit cfmwhCustom;
////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1995-2005 HREF Tools Corp.  All Rights Reserved Worldwide.  //
//                                                                            //
//  This source code file is part of WebHub v2.04x.  Please obtain a WebHub   //
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
  toolbar, utPanFrm, tpMemo, restorer, ComCtrls, tpStatus, updateOK,
  tpAction, webTypes, webLink, tpCompPanel;

type
  TfmAppCustomPanel = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    Memo: TtpMemo;
    Splitter1: TSplitter;
    waTest: TwhWebActionEx;
    tpStatusBar1: TtpStatusBar;
    procedure waTestExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  fmAppCustomPanel: TfmAppCustomPanel;

implementation

{$R *.dfm}

function TfmAppCustomPanel.Init: Boolean;
begin
  Result := inherited Init;
end;

procedure TfmAppCustomPanel.waTestExecute(Sender: TObject);
begin
  inherited;
  TwhWebAction(Sender).Response.SendImm('ok this is a test');
end;

end.
