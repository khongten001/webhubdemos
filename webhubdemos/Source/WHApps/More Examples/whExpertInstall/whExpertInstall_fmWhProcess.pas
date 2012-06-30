unit whExpertInstall_fmWhProcess;
(*
Copyright (c) 2012 HREF Tools Corp.
Author: Ann Lynnworth

Permission is hereby granted, on 6-Jun-2012, free of charge, to any person
obtaining a copy of this file (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UTPANFRM, ExtCtrls, StdCtrls, UpdateOk, tpAction, IniLink,
  Toolbar, Restorer, tpmemo, Buttons, ComCtrls, tpstatus,
  webTypes, weblink, tpCompPanel;

type
  TfmWhProcess = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    ConverterFilename: TGroupBox;
    tpMemoConfig: TtpMemo;
    waStep: TwhWebAction;
    tpStatusBar1: TtpStatusBar;
    procedure waStepExecute(Sender: TObject);
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
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  DateUtils,
  ucShell, ucLogFil, ucFile, ucDlgs, ucCodeSiteInterface,
  webApp;

function TfmWhProcess.Init: Boolean;
begin
  Result:= inherited Init;
  if not Result then
    Exit;
end;

{______________________________________________________________________________}

procedure TfmWhProcess.waStepExecute(Sender: TObject);
begin
  inherited;

  with TwhWebActionEx(Sender) do
  begin
    WebApp.Response.SendBounceToPage('pgResult', '');
  end;
end;

{______________________________________________________________________________}

end.
