unit whDynamicJPEG_fmWh;

(*
Copyright (c) 2003 HREF Tools Corp.

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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ExtCtrls, StdCtrls, ComCtrls, DB, DBCtrls, Grids, DBGrids,
  utPanFrm, UpdateOk, tpAction, Toolbar, Restorer, tpStatus, tpCompPanel,
  webTypes, webLink, whJPEG;

type
  TwhWebActionEx = class(TwhJPEG);

type
  TfmWhAnimals = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    DBGrid1: TDBGrid;
    waJPEG: TwhWebActionEx;
    DBImage: TDBImage;
    Splitter1: TSplitter;
    tpStatusBar1: TtpStatusBar;
    procedure waJPEGUpdate(Sender: TObject);
    procedure waJPEGExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: boolean; override;
    end;

var
  fmWhAnimals: TfmWhAnimals;

implementation

{$R *.DFM}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ZM_CodeSiteInterface,
  webApp, webInfou, whdemo_ViewSource, whDynamicJPEG_dmwhData;

function TfmWhAnimals.Init: boolean;
begin
  Result:= inherited Init;
  if Result then
  begin
    RefreshWebActions(Self);
  end;
end;

procedure TfmWhAnimals.waJPEGUpdate(Sender: TObject);
const cFn = 'waJPEGUpdate';
begin
  CSEnterMethod(Self, cFn);
  inherited;
  if Sender is TwhJPEG then
  begin
    with TwhJPEG(Sender) do
    begin
      //YOU MUST .. assign the picture property at runtime.
      if assigned(dbImage) then
        Picture:= dbImage.Picture
      else
        LogSendWarning('dbImage is nil', cFn);
      //optionally you can customize jpeg encoding options:
      //Grayscale:=True;
      //whJPEGImage.Smoothing := False;
      //whJPEGImage.CompressionQuality := 100;
      whJPEGImage.ProgressiveEncoding:=True;
    end;
  end;
  CSExitMethod(Self, cFn);
end;

procedure TfmWhAnimals.waJPEGExecute(Sender: TObject);
{$IFDEF CodeSite}const cFn = 'waJPEGExecute';{$ENDIF}
begin
  CSEnterMethod(Self, cFn);
  inherited;
  CSSend('DMBIOLIFE.ClientDataSet1.RecNo',
    S(DMBIOLIFE.ClientDataSet1.RecNo));
  CSExitMethod(Self, cFn);
end;

end.
