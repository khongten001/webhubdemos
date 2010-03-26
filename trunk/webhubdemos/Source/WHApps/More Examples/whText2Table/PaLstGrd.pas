unit palstgrd;
(*
Copyright (c) 1999 HREF Tools Corp.

Permission is hereby granted, on 04-Jun-2004, free of charge, to any person
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

(* This unit provides a WebHub Panel containing the WebListGrid, for use in any
   WebHub application.

   This unit contains the 2 copies of the TwhListGrid component, and some
   buttons for convenience.  If you are not using TwhListGrid
   in your application, do not include this unit. *)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UTPANFRM, ExtCtrls, StdCtrls, Toolbar, Buttons,
  ComCtrls, tpStatus, UpdateOk, tpAction, WebTypes,   WebLink,
  WebLGrid;

type
  TfmWebListGridPanel = class(TutParentForm)
    ToolBar: TtpToolBar;
    WebListGrid: TwhListGrid;
    tpStatusBar1: TtpStatusBar;
    tpToolButton1: TtpToolButton;
    Label1: TLabel;
    tpToolButton2: TtpToolButton;
    tpToolButton3: TtpToolButton;
    tpToolButton4: TtpToolButton;
    wg2: TwhListGrid;
    procedure tpToolButton1Click(Sender: TObject);
    procedure tpToolButton2Click(Sender: TObject);
    procedure tpToolButton3Click(Sender: TObject);
    procedure tpToolButton4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  fmWebListGridPanel: TfmWebListGridPanel;

implementation

{$R *.DFM}

//------------------------------------------------------------------------------

function TfmWebListGridPanel.Init:Boolean;
begin
  Result:= inherited Init;
  if not Result then
    Exit;
  RefreshWebActions(fmWebListGridPanel);
end;

procedure TfmWebListGridPanel.tpToolButton1Click(Sender: TObject);
begin
  inherited;
  WebListGrid.ExecuteVerbByName('Edit Files');
end;

procedure TfmWebListGridPanel.tpToolButton2Click(Sender: TObject);
begin
  inherited;
  WebListGrid.ExecuteVerbByName('Refresh');
end;

procedure TfmWebListGridPanel.tpToolButton3Click(Sender: TObject);
begin
  inherited;
  WebListGrid.ExecuteVerbByName('Properties');
end;

procedure TfmWebListGridPanel.tpToolButton4Click(Sender: TObject);
begin
  inherited;
  WebListGrid.ExecuteVerbByName('Help');
end;

end.
