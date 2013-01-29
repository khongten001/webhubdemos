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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UTPANFRM, ExtCtrls, StdCtrls, UpdateOk, tpAction, IniLink,
    Toolbar, Restorer, DBCtrls, WebTypes, weblink, Db, DBTables,
  Grids, DBGrids, whJPEG, ComCtrls, tpStatus, tpCompPanel;

type
  TwhWebActionEx = class(TwhJPEG);

type
  TfmWhAnimals = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    DBGrid1: TDBGrid;
    Table1: TTable;
    Table1NAME: TStringField;
    Table1SIZE: TSmallintField;
    Table1WEIGHT: TSmallintField;
    Table1AREA: TStringField;
    Table1BMP: TBlobField;
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
  ucCodeSiteInterface,
  webApp, webInfou, whdemo_ViewSource, whDynamicJPEG_dmwhData;

function TfmWhAnimals.Init: boolean;
begin
  Result:= inherited Init;
  if Result then
  begin
    with Table1 do
    begin
      DatabaseName := getHtDemoDataRoot + 'whDynamicJPEG\';
      TableName := 'animals.dbf';
      Open;
    end;
    RefreshWebActions(Self);
    //waJPEGUpdate(waJPEG);
  end;
end;

procedure TfmWhAnimals.waJPEGUpdate(Sender: TObject);
const cFn = 'waJPEGUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
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
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TfmWhAnimals.waJPEGExecute(Sender: TObject);
{$IFDEF CodeSite}const cFn = 'waJPEGExecute';{$ENDIF}
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  {$IFDEF CodeSite}CodeSite.Send('Record #', Table1.RecNo);{$ENDIF}
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

end.
