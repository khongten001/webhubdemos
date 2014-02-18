unit whSendmail_dmWhQuote; { custom code for emailing a quote - WebHub demo. }

(*
  Copyright (c) 2003-2014 HREF Tools Corp.
  Author: Ann Lynnworth

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
  SysUtils, Classes,
  updateOk, tpAction,
  webTypes, webLink, htmlBase, htmlCore, htmlSend;

type
  TdmWhQuote = class(TDataModule)
    waQuoteMessage: TwhWebActionEx;
    ExtraOutput: TwhResponse;
    procedure waQuoteMessageExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OverrideWebMailFormExecute(Sender: TObject);
    procedure Init;
  end;

var
  dmWhQuote: TdmWhQuote;

implementation

uses
{$IFDEF INDYSMTP}
  IdAttachment, IdAttachmentFile,
{$ENDIF}
  ucCodeSiteInterface,
  ucFile, ucOther, ucWinAPI,
  whMail, webApp, webPrologue, whMacroAffixes;

{$R *.DFM}

const
  cOutgoingMailServer = 'smtplocal.href.com'; // replace with your mail server
  cOutgoingMailPort = 25;

procedure TdmWhQuote.Init;
begin
  ExtraOutput.GUI.SetShowResponse(outQuick);
  DataModuleWhMail.WebMailForm.OnExecute := OverrideWebMailFormExecute;
end;

procedure TdmWhQuote.OverrideWebMailFormExecute(Sender: TObject);
var
  Temp: string;
begin
  Temp := 'X-Priority: 1 (Highest)' + sLineBreak + 'X-Hello: Testing 1-2-3';
{$IF Defined(INDYSMTP)}
  DataModuleWhMail.WebMailForm.IndyMessage.Headers.Text := Temp;
{$ELSE}
  DataModuleWhMail.WebMailForm.webMail.Headers.Text := Temp;
{$IFEND}
end;

procedure TdmWhQuote.waQuoteMessageExecute(Sender: TObject);
const
  cFn = 'waQuoteMessageExecute';
var
  nQ1, nQ2: integer;
  nAdjuster, nAmount: double;
const
  puppyPrice = 10; // relates to qty 1
  kittenPrice = 100; // relates to qty 2
begin
  CSEnterMethod(Self, cFn);
  // input from the web: inQty1, inQty2, inPayMethod
  // processing: calculate total amount due and set variables for the answer.
  // output: generate email message; no direct output to the web.
  with TwhWebActionEx(Sender).webApp do
  begin
    // Lots of variables are used to illustrate the steps. Optimization is left to the reader.
    nQ1 := StrToInt(StringVar['inQty1']);
    nQ2 := StrToInt(StringVar['inQty2']);
    nAdjuster := StrToFloat(StringVar['inPayMethod']);
    nAmount := ((nQ1 * puppyPrice) + (nQ2 * kittenPrice));
    // Copy the list price to the StringVars array so the values are web-accessible.
    StringVar['vListPrice'] := FormatCurrency(nAmount); // ucOther.pas
    // Adjust for discount or surcharge.
    nAmount := nAmount * nAdjuster;
    // Copy to StringVars.
    StringVar['vAmountDue'] := FormatCurrency(nAmount);
    // Now send email quote.

{$IFDEF INDYSMTP}
    with DataModuleWhMail do
    begin
      WebMailForm.IndyMessage.From.Address := 'info@href.com';
      WebMailForm.IndyMessage.From.Name := 'WebHub Demo: HTMail Quote System';
      WebMailForm.IndyMessage.Recipients.Clear;
      WebMailForm.IndyMessage.Recipients.EMailAddresses :=
        StringVar['inSurferEMail'];
      WebMailForm.IndyMessage.Subject := 'Automated Quotation';
      WebMailForm.IndyMessage.Body.Text :=
        pWebApp.Expand(MacroStart + 'chQuote' + MacroEnd);
      WebMailForm.IndySMTP.Host := cOutgoingMailServer;
      WebMailForm.IndySMTP.Port := cOutgoingMailPort;
      TIdAttachmentFile.Create(WebMailForm.IndyMessage.MessageParts,
        pWebApp.AppPath + 'sampleattachment.txt');
      try
        if not WebMailForm.IndySMTP.Connected then
          WebMailForm.IndySMTP.Connect;
        WebMailForm.IndySMTP.Send(WebMailForm.IndyMessage);
        WebMailForm.IndyMessage.MessageParts.Clear;
        WebMailForm.IndySMTP.Disconnect;
      except
        on E: Exception do
        begin
          CSSendNote('Indy Exception');
          CSSendException(E);
          WebMailForm.IndySMTP.Disconnect;
        end;
      end;
    end;
{$ELSE}
    with DataModuleWhMail.webMail do
    begin
      Sender.EMail := 'info@href.com';
      Sender.Name := 'WebHub Demo: HTMail Quote System';
      Mailto.Text := StringVar['inSurferEMail'];
      Subject := 'Automated Quotation';
      Lines.Text := pWebApp.Expand(MacroStart + 'chQuote' + MacroEnd);
      MailHost.Hostname := cOutgoingMailServer;
      MailHost.Port := cOutgoingMailPort;
      DataModuleWhMail.webMail.Headers.Text := 'X-Priority: 1 (Highest)';
      Files.Clear;
      Files.Add(pWebApp.AppPath + 'sampleattachment.txt');
      DataModuleWhMail.webMail.execute; // send the custom message
    end;
{$ENDIF}
    Response.SendComment('E-mail was sent to ' + StringVar['inSurferEMail']);
  end;
  CSExitMethod(Self, cFn);
end;

end.
