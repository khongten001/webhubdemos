unit whParadox_fmWhProcess;
(*
Copyright (c) 2008-2012 HREF Tools Corp.
Author: Ann Lynnworth
*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls,
  utPanFrm, updateOk, tpCompPanel, tpAction, Toolbar, Restorer, tpstatus,
  webTypes, weblink;

type
  TfmWhProcess = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    tpStatusBar1: TtpStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
    end;

var
  fmWhProcess: TfmWhProcess;

implementation

{$R *.DFM}

uses
  webApp;

{______________________________________________________________________________}

function TfmWhProcess.Init:Boolean;
begin
  Result:= inherited Init;
  if not Result then
    Exit;
end;


{______________________________________________________________________________}


end.
