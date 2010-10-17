unit whStopSpam_fmWh;  {optional GUI for use with whStopSpam_dmwh}

{NB: when this application runs as a service, forms are NOT created.}

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
  Buttons, webSOAPRegistry, tpCompPanel;


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
    procedure BtnObfuscateClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
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
  WebApp, ucString, whStopSpam_dmwh;

//------------------------------------------------------------------------------

function TfmUnicodePanel.Init:Boolean;
begin
  Result:= inherited Init;
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

procedure TfmUnicodePanel.BtnObfuscateClick(Sender: TObject);
begin
  inherited;
  Edit2.Text := DMforHTUN.waSlowSpam.MailtoStrObfuscate(Edit1.Text,False);
  Edit3.Text := '<a href="' +
    DMforHTUN.waSlowSpam.MailtoStrObfuscate('mailto:'+Edit1.Text,False)+'">'+
    DMforHTUN.waSlowSpam.MailtoStrObfuscate(Edit1.Text,False)+'</a>';
end;

procedure TfmUnicodePanel.Edit1Change(Sender: TObject);
begin
  inherited;
  Edit2.Text := '';
  Edit3.Text := '';
end;

end.
