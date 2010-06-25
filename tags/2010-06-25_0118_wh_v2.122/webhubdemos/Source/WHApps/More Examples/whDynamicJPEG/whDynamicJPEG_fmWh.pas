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
  Grids, DBGrids, whJPEG, ComCtrls, tpStatus;

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
    DataSource1: TDataSource;
    waJPEG: TwhWebActionEx;
    DBImage: TDBImage;
    Splitter1: TSplitter;
    waAnimalNav: TwhWebAction;
    tpStatusBar1: TtpStatusBar;
    procedure waJPEGUpdate(Sender: TObject);
    procedure waJPEGExecute(Sender: TObject);
    procedure waAnimalNavExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
    end;

var
  fmWhAnimals: TfmWhAnimals;

implementation

{$R *.DFM}

uses
  WebApp, WebInfou, whdemo_ViewSource;

//------------------------------------------------------------------------------

function TfmWhAnimals.Init:Boolean;
begin
  Result:= inherited Init;
  if not Result then
    Exit;
  with Table1 do
  begin
    DatabaseName := getHtDemoDataRoot + 'whDynamicJPEG\';
    TableName := 'animals.dbf';
    Open;
  end;
  RefreshWebActions(fmWhAnimals);
end;

//------------------------------------------------------------------------------
procedure TfmWhAnimals.waJPEGUpdate(Sender: TObject);
begin
  inherited;
  with TwhJPEG(Sender) do
  begin
    //YOU MUST .. assign the picture property at runtime.
    if assigned(dbImage) then
      Picture:= dbImage.Picture;
    //optionally you can customize jpeg encoding options:
    //Grayscale:=True;
    //whJPEGImage.Smoothing := False;
    //whJPEGImage.CompressionQuality := 100;
    whJPEGImage.ProgressiveEncoding:=True;
  end;
end;

procedure TfmWhAnimals.waJPEGExecute(Sender: TObject);
begin
  inherited;
  //pWebApp.Summary.Add('<i>Record #' + IntToStr(Table1.RecNo) + '</i>');
end;

procedure TfmWhAnimals.waAnimalNavExecute(Sender: TObject);
begin
  inherited;
  // Move pointer within the table to the next record so that the
  // the display shows a different image.
  with TwhWebAction(Sender) do
  begin
    if (Command = 'Prev') then
    begin
      Table1.Prior;
      if Table1.BOF then
        Table1.Last
    end
    else
    begin
      Table1.Next;
      if Table1.EOF then
        Table1.First;
    end;
  end;
end;

end.
