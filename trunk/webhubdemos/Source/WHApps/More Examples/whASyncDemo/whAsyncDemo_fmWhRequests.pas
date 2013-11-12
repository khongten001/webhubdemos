unit whAsyncDemo_fmWhRequests;
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UTPANFRM, ExtCtrls, StdCtrls, UpdateOk, tpAction, IniLink,
    Toolbar, Restorer, WebTypes, weblink, tpmemo, htcolmem,
  webmemo, ComCtrls, WebSend, tpCompPanel;

type
  TfmWhRequests = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    CheckBox1: TCheckBox;
    PageControl1: TPageControl;
    TabSheet5: TTabSheet;
    ListBox1: TListBox;
    TabSheet1: TTabSheet;
    WebHtmlMemo1: TwhguiTekoMemo;
    TabSheet2: TTabSheet;
    WebHtmlMemo2: TwhguiTekoMemo;
    TabSheet3: TTabSheet;
    WebHtmlMemo3: TwhguiTekoMemo;
    TabSheet4: TTabSheet;
    WebHtmlMemo4: TwhguiTekoMemo;
  private
    { Private declarations }
    FRoundRobin: Integer;
  public
    { Public declarations }
    function Init: Boolean; override;
    procedure WebAppOutputShow(Sender: TObject);
    end;

var
  fmWhRequests: TfmWhRequests;

implementation

{$R *.DFM}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webApp;

function TfmWhRequests.Init:Boolean;
begin
  Result:= inherited Init;
  if not result then
    exit;
  FRoundRobin := 1;
end;


//------------------------------------------------------------------------------

procedure TfmWhRequests.WebAppOutputShow(Sender: TObject);
var
  ts: TTabSheet;
begin
  with pWebApp.Response do
  begin
    case FRoundRobin of
      1: begin
         GUI.SetResponseMemo(WebHtmlMemo1);
         ts := TTabSheet(WebHtmlMemo1.Parent);
         end;
      2: begin
         GUI.SetResponseMemo(WebHtmlMemo2);
         ts := TTabSheet(WebHtmlMemo2.Parent);
         end;
      3: begin
         GUI.SetResponseMemo(WebHtmlMemo3);
         ts := TTabSheet(WebHtmlMemo3.Parent);
         end;
      4: begin
         GUI.SetResponseMemo(WebHtmlMemo4);
         ts := TTabSheet(WebHtmlMemo4.Parent);
         end;
      else ts := nil;
    end;
    Inc(FRoundRobin);
    if FRoundRobin > 4 then
      FRoundRobin := 1;
  end;

  if PageControl1.ActivePage <> TabSheet5 then
    PageControl1.ActivePage := ts;
end;

end.
