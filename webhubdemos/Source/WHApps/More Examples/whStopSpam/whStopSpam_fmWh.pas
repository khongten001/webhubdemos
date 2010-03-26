unit whStopSpam_fmWh;
(*
Copyright (c) 2002-2005 HREF Tools Corp.

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
    Toolbar, Restorer, ComCtrls, tpstatus, webtypes, weblink,
  Buttons, webSOAPRegistry;


type
  // sample code 1 - execute method is not published

  IWebMailtoObfuscate = interface(IwhWebAction)
    // hint: press Ctrl+Shift+G at Delphi IDE to generate GUID
    ['{5ED74DF5-6E8E-4593-A89A-606D5EEF9AE1}']
    function MailtoStrObfuscate(const input:string;
      const MakeResultReadyToCopyFromWeb: Boolean): string; stdcall;
  end;

type
  TWebMailtoObfuscate = class(TwhWebAction, IWebMailtoObfuscate)
  public
    function MailtoStrObfuscate(const input:string;
      const MakeResultReadyToCopyFromWeb: Boolean): string; stdcall;
    procedure Execute; override;
  end;

type
  TfmUnicodePanel = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    tpStatusBar1: TtpStatusBar;
    Label1: TLabel;
    Label2: TLabel;
    BtnObfuscate: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    WebActionNoSaveState1: TwhWebAction;
    procedure BtnObfuscateClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure WebActionNoSaveState1Execute(Sender: TObject);
  private
    { Private declarations }
    waSlowSpam: TWebMailtoObfuscate;
  public
    function Init: Boolean; override;
    procedure Save(Restorer:TFormRestorer); override;
    procedure Load(Restorer:TFormRestorer); override;
    end;

var
  fmUnicodePanel: TfmUnicodePanel;

implementation

{$R *.DFM}

uses
  WebApp, ucString;

//------------------------------------------------------------------------------

function TfmUnicodePanel.Init:Boolean;
  procedure CreateWebAction(var Instance; AClass: TComponentClass;
    const AName: string);
  begin
    {See also: http://demos.href.com/scripts/runisa.dll/HTUN/html}
    TComponent(Instance) := AClass.Create(Self);
    with TComponent(Instance) as TwhWebAction do
    begin
      Name := AName;
      DirectCallOk := True;
      SOAPCallOk := True;
      Refresh;
    end;
  end;
begin
  Result:= inherited Init;
  if not result then
    exit;
  CreateWebAction(waSlowSpam, TWebMailtoObfuscate, 'waSlowSpam');
  waSlowSpam.OnExecute := WebActionNoSaveState1Execute;
end;

//------------------------------------------------------------------------------

procedure TfmUnicodePanel.Save(Restorer:TFormRestorer);
begin
// do not save restorer values
end;

procedure TfmUnicodePanel.Load(Restorer:TFormRestorer);
begin
  inherited Load(Restorer);
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
end;

//------------------------------------------------------------------------------

function TWebMailtoObfuscate.MailtoStrObfuscate(const input:string;
  const MakeResultReadyToCopyFromWeb: Boolean):string;
var
  i: integer;
  c: char;
  amp: string;
begin
  inherited;
  Result := '';
  if MakeResultReadyToCopyFromWeb then
    amp := '&amp;'
  else
    amp := '&';
  for i:=1 to length(input) do
  begin
    c := input[i];
    result := result + amp + '#' + IntToStr(Ord(c)) + ';';
  end;
end;

procedure TWebMailtoObfuscate.Execute;
begin
  inherited;
  // !!! HtmlParam is blank here.
end;

procedure TfmUnicodePanel.BtnObfuscateClick(Sender: TObject);
begin
  inherited;
  Edit2.Text := waSlowSpam.MailtoStrObfuscate(Edit1.Text,False);
  Edit3.Text := '<a href="'
    +waSlowSpam.MailtoStrObfuscate('mailto:'+Edit1.Text,False)+'">'+
    waSlowSpam.MailtoStrObfuscate(Edit1.Text,False)+'</a>';
end;

procedure TfmUnicodePanel.Edit1Change(Sender: TObject);
begin
  inherited;
  Edit2.Text := '';
  Edit3.Text := '';
end;


procedure TfmUnicodePanel.WebActionNoSaveState1Execute(Sender: TObject);
var
  phrase,addAmpersand: String;
begin
  inherited;
  with TWebMailtoObfuscate(Sender) do
  begin
    // usage waUnicode|phrase[|true]
    SplitString(HtmlParam,'|',phrase,addAmpersand);
    phrase := WebApp.Expand(phrase);
    Response.Send(MailtoStrObfuscate(phrase,StrToBool(addAmpersand)));
  end;
end;

initialization
  RegisterIwhWebAction(TypeInfo(IWebMailtoObfuscate));

end.
