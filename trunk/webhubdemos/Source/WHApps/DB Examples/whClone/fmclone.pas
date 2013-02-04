unit fmclone;
(*
Copyright (c) 1997-2013 HREF Tools Corp.

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
  Windows, SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls, StdCtrls,
  ComCtrls, DB, Grids, DBGrids,
  toolbar, tpCompPanel, updateOk, utPanFrm, tpAction, Restorer, tpStatus,
  wdbSSrc, wdbScan;

type
  TfmBendFields = class(TutParentForm)
    ToolBar: TtpToolBar;
    DBGrid: TDBGrid;
    tpStatusBar1: TtpStatusBar;
    procedure Scan2Execute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
    end;

var
  fmBendFields: TfmBendFields;

implementation

{$R *.DFM}

uses
  ucHTML,
  webApp, wbdeSource,
  whClone_dmwhData, whClone_dmwhGridsNScans;

//------------------------------------------------------------------------------

function TfmBendFields.Init:Boolean;
begin
  Result:= inherited Init;

//on startup the grid will take over the form..
//note that both webdatasources use OpenDataSetVisual=True  .. that is not very
//efficient when running over the web, yet it is a great way to SEE what your
//webdatasource sees visually. OpenDataSetVisual=True is of course required if
//you're using RTTI to access the value of database controls on a form, but that's
//where you'd usually use the Field macro, so consider it a debugging property.
//-Michael Ax.

  if Result then
  begin
    //DMData2Clone.Scan1.OnExecute := Scan2Execute;
    //DMData2Clone.Scan2.OnExecute := Scan2Execute;
    DBGrid.DataSource := nil;  // non-gui operation to avoid threading errors.
  end;
end;


procedure TfmBendFields.Scan2Execute(Sender: TObject);
begin
  dbGrid.DataSource :=
    TwhbdeSource(TwhdbScan(Sender).WebDataSource).DataSource;
  DMGridsNScans.ScanOnExecutePageHeader(Sender);
end;

end.
