unit htqry2c;
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

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, ComCtrls,
  ExtCtrls, StdCtrls, Grids, DBGrids, Buttons,
  utPanFrm, tpStatus, UpdateOk, tpAction, toolbar, tpCompPanel;

type
  TfmHTQ2Panel = class(TutParentForm)
    DBGrid1: TDBGrid;
    tpStatusBar1: TtpStatusBar;
    Toolbar: TtpToolBar;
    tpToolButton1: TtpToolButton;
    procedure FormDestroy(Sender: TObject);
    procedure tpToolButton1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    //procedure CloseAllDatasets(AWebDataSource: TwhbdeSource);
  public
    { Public declarations }
    function Init: Boolean; override;
  protected
  end;

var
  fmHTQ2Panel: TfmHTQ2Panel = nil;

implementation

{$R *.DFM}

uses
  whQuery2_whdmData;

//------------------------------------------------------------------------------

procedure TfmHTQ2Panel.FormDestroy(Sender: TObject);
begin
  inherited;
  fmHTQ2Panel := nil;
end;

//------------------------------------------------------------------------------

function TfmHTQ2Panel.Init: boolean;
begin
  Result:= inherited Init;
  DBGrid1.enabled:=true;
  if Assigned(DMQuery2.DataSourceFull.DataSet) then
    tpToolButton1.Caption := 'Show Table (using ' +
      DMQuery2.DataSourceFull.DataSet.ClassName + ')';
end;

(*procedure TfmHTQ2Panel.CloseAllDatasets(AWebDataSource: TwhbdeSource);
var
  n:integer;
begin
  with AWebDataSource do
  begin
    n:=0;   // number of datasets to leave open
    while ComponentCount>n do
      Components[0].free;
  end;
end;
  *)

procedure TfmHTQ2Panel.tpToolButton1Click(Sender: TObject);
begin
  inherited;
  DBGrid1.DataSource := DMQuery2.DataSourceFull;
  DMQuery2.DataSourceFull.DataSet.Open;
end;

end.

