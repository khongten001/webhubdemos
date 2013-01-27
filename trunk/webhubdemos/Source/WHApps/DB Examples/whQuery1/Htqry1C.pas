unit htqry1c;
(*
Copyright (c) 1999-2013 HREF Tools Corp.

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

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons,
  utPanFrm, Toolbar,
  updateOk, tpAction,
  tpStatus, tpCompPanel;

type
  TfmHTQ1Panel = class(TutParentForm)
    CheckBox1: TCheckBox;
    tpToolBar2: TtpToolBar;
    tpStatusBar1: TtpStatusBar;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox1Exit(Sender: TObject);
    procedure CheckBox1Enter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  fmHTQ1Panel: TfmHTQ1Panel;

implementation

{$R *.DFM}

uses
  ucCodeSiteInterface,
  whQuery1_whdmData;

//------------------------------------------------------------------------------

procedure TfmHTQ1Panel.CheckBox1Click(Sender: TObject);
begin
  inherited;
  DMHTQ1.ReportSQL := Checkbox1.Checked;
end;

procedure TfmHTQ1Panel.CheckBox1Enter(Sender: TObject);
begin
  inherited;
  Checkbox1.Checked := DMHTQ1.ReportSQL;
end;

procedure TfmHTQ1Panel.CheckBox1Exit(Sender: TObject);
begin
  inherited;
  DMHTQ1.ReportSQL := Checkbox1.Checked;
end;

function TfmHTQ1Panel.Init:Boolean;
begin
  Result:= inherited Init;
  if not result then
    exit;
end;

end.
