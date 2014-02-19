unit htshopc;
(*
  Copyright (c) 1998-2014 HREF Tools Corp.

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
{$I hrefdefines.inc}
  {$IF Defined(Delphi17UP)}
  {$DEFINE INDYSMTP}
  {$ELSE}
  {$UNDEF INDYSMTP}
  {$IFEND}


uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls, 
  StdCtrls, Buttons, DB, Grids, DBGrids, ComCtrls, DBCtrls, 
  tpStatus, utPanFrm, updateOk, tpAction, tpMemo, toolbar, tpCompPanel,
  {$IFDEF INDYSMTP}webMail, webSock, {$ENDIF}
  webTypes, webLink;

type
  TfmShopPanel = class(TutParentForm)
    toolbar: TtpToolBar;
    WebActionMailer: TwhWebActionEx;
    tpStatusBar1: TtpStatusBar;
    tpToolButton1: TtpToolButton;
    tpComponentPanel2: TtpComponentPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    tsEConfig: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    EditEMailFrom: TEdit;
    EditEMailTo: TEdit;
    EditMailhost: TEdit;
    EditSubject: TEdit;
    EditMailPort: TEdit;
    GroupBox1: TGroupBox;
    procedure WebActionMailerExecute(Sender: TObject);
    procedure tpToolButton1Click(Sender: TObject);
  private
    procedure ConfigEMail;
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  fmShopPanel: TfmShopPanel;

implementation

{$R *.DFM}

uses
  ucString, ucCodeSiteInterface,
  webApp, whMail, whdemo_ViewSource, whShopping_dmShop;

function TfmShopPanel.Init: Boolean;
begin
  Result := inherited Init;
  if Result then
  begin
    {$IFDEF INDYSMTP}
    DataModuleWhMail.webMailForm.IndyMessage.Subject := '';
    {$ELSE}
    DataModuleWhMail.webMailForm.WebMail.Subject := '';
    {$ENDIF}
  end;
end;


procedure TfmShopPanel.ConfigEMail;
begin
  { configure email based on values on form. }
  // e-mail settings -- please change to use your own defaults!
  if EditEMailFrom.Text = '' then
    EditEMailFrom.Text := 'someone@theweb.com';
  if EditEMailTo.Text = '' then
    EditEMailTo.Text := 'info@href.com';
  if EditMailhost.Text = '' then
    EditMailhost.Text := 'smtplocal.href.com';  
  if EditMailPort.Text = '' then
    EditMailPort.Text := '25';
  if EditSubject.Text = '' then
    EditSubject.Text := '** Shop1 Sale';
  //

  with DataModuleWhMail do
  begin
    {$IFDEF INDYSMTP}
    WebMailForm.IndyMessage.From.Address := EditEMailFrom.Text;
    WebMailForm.IndyMessage.Recipients.Clear;
    WebMailForm.IndyMessage.Recipients.EmailAddresses := EditEMailTo.Text;
    WebMailForm.IndySMTP.Host := EditMailhost.Text;
    WebMailForm.IndySMTP.Port := StrToIntDef(EditMailPort.Text, 25);
    WebMailForm.IndyMessage.Subject := EditSubject.Text;
    {$ELSE}
    WebMailForm.WebMail.Sender.EMail := EditEMailFrom.Text;
    WebMailForm.WebMail.MailTo.clear;
    WebMailForm.WebMail.MailTo.add(EditEMailTo.Text);
    WebMailForm.WebMail.MailHost.hostname := EditMailhost.Text;
    WebMailForm.WebMail.MailHost.port := StrToIntDef(EditMailPort.Text, 25);
    WebMailForm.WebMail.subject := EditSubject.Text;
    {$ENDIF}
  end;
end;

{ ------------------------------------------------------------------------- }


{ ------------------------------------------------------------------------- }

{ Prepare-and-send mail message. }
procedure TfmShopPanel.WebActionMailerExecute(Sender: TObject);
var
  sList: TStringList;
  temp: string;
begin
  with TwhWebActionEx(Sender).WebApp, DataModuleWhMail do
  begin
    {$IFDEF INDYSMTP}
    temp := WebMailForm.IndyMessage.Subject;
    {$ELSE}
    temp := WebMailForm.WebMail.Subject;
    {$ENDIF}
    if temp = '' then
      ConfigEMail;

    {$IFDEF INDYSMTP}
    WebMailForm.IndyMessage.From.Name := StringVar['CustFullName'];
    {$ELSE}
    WebMailForm.WebMail.Sender.Name := StringVar['CustFullName'];
    {$ENDIF}
    
    // fill in the message (Lines property)
    temp := 'CUSTOMER:' + sLineBreak +
      StringVar['CustFullName'] + sLineBreak +
      StringVar['CustCity'] + sLineBreak +
      sLineBreak +
      'ORDER:' + sLineBreak;

    {$IFDEF INDYSMTP}
    WebMailForm.IndyMessage.Body.Text := temp;
    {$ELSE}
    WebMailForm.WebMail.Lines.Text := temp;
    {$ENDIF}
    
    sList := nil;
    try
      sList := TStringList.create;
      DMShop1.getOrderList(sList);
	    {$IFDEF INDYSMTP}
	    WebMailForm.IndyMessage.Body.AddStrings(sList);
	    {$ELSE}
	    WebMailForm.WebMail.Lines.AddStrings(sList);
	    {$ENDIF}
    finally
      FreeAndNil(sList);
    end;
    {$IFDEF INDYSMTP}
        if not WebMailForm.IndySMTP.Connected then
          WebMailForm.IndySMTP.Connect;
        WebMailForm.IndySMTP.Send(WebMailForm.IndyMessage);
        WebMailForm.IndyMessage.MessageParts.Clear;
        WebMailForm.IndySMTP.Disconnect;
    {$ELSE}
        WebMailForm.WebMail.Execute; { send the message }
    {$ENDIF}
  end;
end;

{ ------------------------------------------------------------------------- }

{ fun with tool buttons... }

procedure TfmShopPanel.tpToolButton1Click(Sender: TObject);
begin
  with DBGrid1 do
    if DataSource = nil then
    begin
      DataSource := DMShop1.DataSource1;
      DBNavigator1.DataSource := DMShop1.DataSource1;
      DataSource.DataSet.Open;
    end
    else
    begin
      DataSource := nil;
      DBNavigator1.DataSource := nil;
    end
end;

end.
