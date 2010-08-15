unit importfm;
(*
Copyright (c) 1997 HREF Tools Corp.

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

// This code is FYI. It is not used actively by the web application.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, DB, DBTables,
  UTPANFRM, tpMemo, tpTable, UpdateOk, tpAction, 
  wbdeForm,
  wbdeSource, WebTypes,
  WebLink, WdbLink, WdbScan, wbdeGrid, WebMemo, Buttons, Toolbar, {}tpCompPanel,
  Grids, TxtGrid, DBGrids, DBCtrls, tpStatus, 
  ucstring, WebPage, WebPHub;

type
  TFormImport = class(TutParentForm)
    tpStatusBar1: TtpStatusBar;
    tpComponentPanel2: TtpComponentPanel;
    Panel1: TPanel;
    Toolbar: TtpToolBar;
    tpToolButton1: TtpToolButton;
    Table1: TTable;
    EditDirectory: TEdit;
    EditURL: TEdit;
    Label1: TLabel;
    procedure tpToolButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  FormImport: TFormImport;

implementation

{$R *.DFM}

uses
  WebApp,
  ucScnDir,  // This is for scanning files/directories.
  ucFile;

var
  tbl:TTable=nil;
  aURL:string='';

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

function TFormImport.Init:Boolean;
var
  a1:string;
begin
  Result:= inherited Init;
  if not result then
    exit;
  a1:=pWebApp.AppSetting['DatabaseName'];
  if a1='' then exit;
  with Table1 do begin
    DatabaseName:=a1;
    open;
    end;
  tbl:=table1;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

// this function is called by the ScanAllFiles procedure, for each file.
function ImportAFile(const FileName:String):boolean;
var
  fileID:integer;
  a1,a2:string;
begin
  Result:=True;
  SplitString(ExtractFileName(Filename),'.',a1,a2);
  with tbl do begin
    if NOT Locate('Filename',a1,[loCaseInsensitive]) then begin
      last;
      fileID:=fieldByName('FileID').asInteger+1;
      edit;
      insert;
      fieldByName('FileID').asInteger:=fileID;
      fieldByName('Filename').asString:=a1;
      end
    else begin
      edit;
      end;
    fieldByName('FileExt').asString:=a2;
    FieldByName('FileSize').asString:=IntToStr(ucFile.getFileSize(filename));
    FieldByName('FileURLDir').asString:=aURL;
    post;
    end;
end;

//------------------------------------------------------------------------------

procedure TFormImport.tpToolButton1Click(Sender: TObject);
begin
  inherited;
  aURL:=editURL.text;
  ScanAllFiles(editDirectory.text,'*.*',ImportAFile);
end;

end.
