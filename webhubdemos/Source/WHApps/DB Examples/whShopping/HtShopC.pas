unit htshopc;
(*
  Copyright (c) 1998-2012 HREF Tools Corp.

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
  Windows, SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls, 
  StdCtrls, Buttons, DB, Grids, DBGrids, ComCtrls, DBCtrls, ADODB,
  tpStatus, utPanFrm, updateOk, tpAction, tpMemo, toolbar, tpCompPanel,
  webMail, webSock, webTypes, webLink;

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
  ucString,
  webApp, whMail, whdemo_ViewSource, whShopping_dmShop;

function TfmShopPanel.Init: Boolean;
begin
  Result := inherited Init;
  if not Result then
    Exit;

  DataModuleWhMail.webMail.Subject := '';
  Result := True;
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
  with DataModuleWhMail.webMail do
  begin
    Sender.EMail := EditEMailFrom.Text;
    MailTo.clear;
    MailTo.add(EditEMailTo.Text);
    MailHost.hostname := EditMailhost.Text;
    MailHost.port := StrToIntDef(EditMailPort.Text, 25);
    subject := EditSubject.Text;
  end;
end;

{ ------------------------------------------------------------------------- }


{ ------------------------------------------------------------------------- }

{ Prepare-and-send mail message. }
procedure TfmShopPanel.WebActionMailerExecute(Sender: TObject);
var
  sList: TStringList;
begin
  with TwhWebActionEx(Sender).WebApp, DataModuleWhMail.webMail do
  begin
    if subject = '' then
      ConfigEMail;
    //
    Sender.Name := StringVar['CustFullName'];
    // fill in the message (Lines property)
    Lines.clear;
    Lines.add('CUSTOMER:');
    Lines.add(StringVar['CustFullName']);
    Lines.add(StringVar['CustCity']);
    Lines.add('');
    Lines.add('ORDER:');
    sList := nil;
    try
      sList := TStringList.create;
      DMShop1.getOrderList(sList);
      Lines.AddStrings(sList);
    finally
      sList.free;
    end;
    execute; { send the message }
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
