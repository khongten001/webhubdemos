unit whSendmail_dmWhQuote;   {custom code for emailing a quote - WebHub demo.}
(*
Copyright (c) 2003 HREF Tools Corp.
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

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UpdateOk, tpAction, WebTypes,   WebLink, WebMail,
  WebSock, IniLink, HtmlBase, HtmlCore, HtmlSend, CGiServ, WebServ;

type
  TdmWhQuote = class(TDataModule)
    waQuoteMessage: TwhWebActionEx;
    ExtraOutput: TwhResponse;
    procedure waQuoteMessageExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ExpandChunk(aDropletID: string): string;
    procedure Init;
  end;

var
  dmWhQuote: TdmWhQuote;

implementation

uses
  ucFile, ucOther, ucWinAPI,
  whMail, webApp, webPrologue;

{$R *.DFM}

const
  cOutgoingMailServer = 'mail.href.com';   // replace with your mail server

function TdmWhQuote.ExpandChunk(aDropletID: string):string;
var
  t:TwhResponse;
begin
  //connect the mailmerge output
  t:=pWebApp.Response;
  pWebApp.Response:=ExtraOutput;
  ExtraOutput.WebApp:=pWebApp;
  //expand the droplet
  With ExtraOutput do
  begin
    ResponseFilespec := GetTempFileName('quote.txt');
    SetContentType(proSkip, '');
    Open;
    pWebApp.SendMacro(aDropletID);
    Result := Stream.text;
    Close;
    DeleteFile(ResponseFilespec);
    end;
  //disconnect the mailmerge output;
  pWebApp.Response:=t;
  ExtraOutput.WebApp:=nil;
end;

procedure TdmWhQuote.Init;
begin
  ExtraOutput.GUI.SetShowResponse(outQuick);
end;

procedure TdmWhQuote.waQuoteMessageExecute(Sender: TObject);
var
  nQ1,nQ2:integer;
  nAdjuster,nAmount:double;
const
  puppyPrice=10;    // relates to qty 1
  kittenPrice=100;  // relates to qty 2
begin
  // input from the web: inQty1, inQty2, inPayMethod
  // processing: calculate total amount due and set variables for the answer.
  // output: generate email message; no direct output to the web.
  with TwhWebActionEx(Sender).WebApp do
  begin
    // Lots of variables are used to illustrate the steps. Optimization is left to the reader.
    nQ1:=StrToInt(StringVar['inQty1']);
    nQ2:=StrToInt(StringVar['inQty2']);
    nAdjuster:=StrToFloat(StringVar['inPayMethod']);
    nAmount:=((nQ1*puppyPrice)+(nQ2*kittenPrice));
    // Copy the list price to the StringVars array so the values are web-accessible.
    StringVar['vListPrice']:=FormatCurrency(nAmount);  // ucOther.pas
    // Adjust for discount or surcharge.
    nAmount:=nAmount*nAdjuster;
    // Copy to StringVars.
    StringVar['vAmountDue']:=FormatCurrency(nAmount);
    // Now send email quote.
    with DataModuleWhMail.WebMail do
    begin
      Sender.EMail:='info@href.com';
      Sender.Name:='WebHub Demo: HTMail Quote System';
      Mailto.text:=StringVar['inSurferEMail'];
      Subject:='Automated Quotation';
      Lines.text:=ExpandChunk('chQuote');
      MailHost.Hostname:=cOutgoingMailServer;
      MailHost.Port:=25;
      DataModuleWhMail.WebMail.execute;            // send the custom message
    end;
    Response.SendComment('E-mail was sent to '+StringVar['inSurferEMail']);
  end;
end;

end.
