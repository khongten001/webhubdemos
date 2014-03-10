unit fmIndyEMailSSL;

(*
Copyright (c) 2013 HREF Tools Corp.

Permission is hereby granted, on 29-Dec-2013, free of charge, to any person
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
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  tpCompPanel, IdIPMCastBase, IdIPMCastClient, IdIOHandler,
  IdIOHandlerStream, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  IdMessage, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  IdAttachment, IdAttachmentFile, IdText, IdMessageBuilder;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    editSMTP: TLabeledEdit;
    EditUser: TLabeledEdit;
    editPass: TLabeledEdit;
    editFilespec: TLabeledEdit;
    rbAttachmentTechnique: TRadioGroup;
    GroupBox2: TGroupBox;
    edSubject: TLabeledEdit;
    edFrom: TLabeledEdit;
    EdCC: TLabeledEdit;
    edTo: TLabeledEdit;
    cbUTF8: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ClickTestSecureEMail(Sender: TObject);
  private
    { Private declarations }
    IdSMTP1: TIdSMTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdMessage1: TIdMessage;
    IdAttachment1: TIdAttachment;
    IdText1: TIdText;
    IdMsgBldr1: TIdMessageBuilderPlain;
    procedure IndyMailStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
  strict private
    function IntentionalError_SmtpServer: Boolean;
    function IntentionalError_SmtpSenderEmail: Boolean;
    function IntentionalError_SmtpUsername: Boolean;
    function IntentionalError_SmtpPassword: Boolean;
    function IntentionalError_MissingAttachment: Boolean;
  strict private
    function SubjectSample(const i: Integer): string;
    function BodySampleForAttachment(const i: Integer): string;
    procedure AttachmentTest01;
    procedure AttachmentTest02;
    procedure AttachmentTest03;
    procedure AttachmentTest04;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses
  CodeSiteLogging,
  TypInfo,
  IdGlobal,
  ucString, ucLogFil, ucMsTime, ucDlgs, uCode, ucCodeSiteInterface;

const
  cFromName = 'Indy SMTP';
  cCharsetUTF8 = 'utf-8';  // must include hyphen symbol

procedure TForm3.AttachmentTest01;
const cFn = 'AttachmentTest01';
begin
  CSEnterMethod(Self, cFn);
  IdMessage1.Subject := SubjectSample(1);
  IdMessage1.AttachmentEncoding := 'UUE';
  IdMessage1.ConvertPreamble := True;
  idMessage1.MessageParts.Clear;
  idMessage1.Body.Text := BodySampleForAttachment(1);
  TIdAttachmentFile.Create(idMessage1.MessageParts, editFilespec.Text);
  CSExitMethod(Self, cFn);
end;

procedure TForm3.AttachmentTest02;
begin
  IdMessage1.Subject := SubjectSample(2);
  IdMessage1.AttachmentEncoding := 'UUE';
  IdMessage1.ConvertPreamble := True;
  idMessage1.MessageParts.Clear;
  idMessage1.Body.Text := BodySampleForAttachment(2);
  idAttachment1 := TIdAttachmentFile.Create(idMessage1.MessageParts,
    editFilespec.Text);
  idAttachment1.ContentType := 'application/pdf';
end;

procedure TForm3.AttachmentTest03;
begin
  IdMessage1.Subject := SubjectSample(3);
  idMessage1.MessageParts.Clear;

  IdMessage1.ContentType := 'multipart/alternative';

  if IdText1 = nil then
    IdText1 := TIdText.Create(IdMessage1.MessageParts, nil);
  IdText1.ContentType := 'text/plain';
  IdText1.ContentTransfer := '8BIT'; //to stop encoding text
  IdText1.Body.Text := BodySampleForAttachment(3);
  if cbUTF8.Checked then
    IdText1.CharSet := cCharsetUTF8 // must set this here not just on TidMessage
  else
    IdText1.CharSet := '';
  idAttachment1 := TIdAttachmentFile.Create(idMessage1.MessageParts,
    editFilespec.Text);
  idAttachment1.ContentType := 'application/pdf';
  IdMessage1.ContentType := 'multipart/mixed';
end;

procedure TForm3.AttachmentTest04;
const cFn = 'AttachmentTest04';
begin
  CSEnterMethod(Self, cFn);
  try
    IdMsgBldr1 := TIdMessageBuilderPlain.Create;

    IdMsgBldr1.PlainText.Text := BodySampleForAttachment(4);
    CSSend('Default IdMsgBldr1.PlainTextCharSet', IdMsgBldr1.PlainTextCharSet);
    if cbUTF8.Checked then
    begin
      // required step when using TIdMessageBuilderPlain
      IdMsgBldr1.PlainTextCharSet := cCharsetUTF8;
      CSSend('IdMsgBldr1.PlainTextCharSet', IdMsgBldr1.PlainTextCharSet);
    end;

    IdMsgBldr1.Attachments.Add(editFilespec.Text, 'application/pdf');
    IdMessage1 := IdMsgBldr1.NewMessage;
    CSSend('IdMessage1.IsEncoded', S(IdMessage1.IsEncoded));
    IdMessage1.IsEncoded := False;
  finally
    FreeAndNil(IdMsgBldr1);
  end;
  IdMessage1.Subject := SubjectSample(4);  // must set after "building"

  CSExitMethod(Self, cFn);
end;

procedure TForm3.ClickTestSecureEMail(Sender: TObject);
const cFn = 'ClickTestSecureEMail';
var
  SaveCaption: string;

  function VERP(const FromAddress, ToAddress: string): string;
  var
    a1, a2: string;
  begin
    SplitString(FromAddress, '@', a1, a2);  // info @ suretreat.com
    Result := a1 + '+' +
      StringReplaceAll(ToAddress, '@', '=') + '@' + a2;
  end;

begin
  CSEnterMethod(Self, cFn);

  SaveCaption := BitBtn2.Caption;
  BitBtn2.Caption := 'in process...';
  BitBtn2.Enabled := False;
  Self.Update;

  idMessage1.Subject := edSubject.Text;
  idMessage1.Body.Text := BodySampleForAttachment(0);

  if Checkbox1.Checked then
  begin
    if NOT IntentionalError_MissingAttachment then
    begin
      case Succ(rbAttachmentTechnique.ItemIndex) of
        1: AttachmentTest01;
        2: AttachmentTest02;
        3: AttachmentTest03;
        4: AttachmentTest04;
      end;
    end
    else
      idAttachment1 := TIdAttachmentFile.Create(idMessage1.MessageParts,
         ChangeFileExt(editFilespec.Text, '.bad'));
  end;

  with idMessage1 do
  begin
    idMessage1.Recipients.Clear;

    // bounce@simulator.amazonses.com
    // ooto@simulator.amazonses.com
    // complaint@simulator.amazonses.com
    // suppressionlist@simulator.amazonses.com

    (* The mailbox simulator supports labeling, which enables you to test your
    support for Variable Envelope Return Path (VERP). For example, you can send
    an email to bounce+label1@simulator.amazonses.com and
    bounce+label2@simulator.amazonses.com to test how your setup matches a
    bounce message with the undeliverable address that caused the bounce. For
    more information about VERP, see
    http://en.wikipedia.org/wiki/Variable_envelope_return_path.
    *)
    idMessage1.Recipients.EMailAddresses := edTo.Text;
    if edCC.Text <> '' then
     IdMessage1.Recipients.Add.Address := edCC.Text;
    CSSend('idMessage1.Recipients.EMailAddresses',
      idMessage1.Recipients.EMailAddresses);
    //idMessage1.From.Address := VERP(edFrom.Text, edTo.Text);  // see VERP

    idMessage1.From.Address := edFrom.Text;
    if IntentionalError_SmtpSenderEmail then
      idMessage1.From.Address := LeftOf('@', edFrom.Text) +
        '@invalid.microsoft.com';

    idMessage1.From.Name := cFromName;
    CSSend('idMessage1.From.Address', idMessage1.From.Address);

    idSMTP1.Host := editSMTP.Text;
    if IntentionalError_SmtpServer then
      idSMTP1.Host := 'invalid.' + idSMTP1.Host;
    idSMTP1.Username := editUser.Text;
    if IntentionalError_SmtpUsername then
      idSMTP1.Username := 'bad' + Copy(idSMTP1.Username, 4, MaxInt);

    idSMTP1.Password := editPass.Text;
    if IntentionalError_SmtpPassword then
      idSMTP1.Password := 'bad' + Copy(idSMTP1.Password, 4, MaxInt);

    IdMessage1.Priority := mpNormal;
    IdMessage1.Encoding := meDefault;

    CSSend('Default idMessage1.CharSet', idMessage1.CharSet);
    if cbUTF8.Checked then
    begin
      IdMessage1.CharSet := cCharsetUTF8;
      CSSend('IdMessage1.CharSet', IdMessage1.CharSet);
    end;

    CSSend('idSMTP1.Host', idSMTP1.Host);
  end;

    try
      if NOT idSMTP1.Connected then
        idSMTP1.Connect;
      CSSend('about to call idSMTP1.Send');
      idSMTP1.Send(idMessage1);
      CSSend('done sending');
      if Assigned(idMessage1.MessageParts) then
        idMessage1.MessageParts.Clear;
      idSMTP1.Disconnect;
    except
      on E: Exception do
      begin
        CSSendNote('Indy Exception');
        CSSendException(E);
        idSMTP1.Disconnect;
        MsgErrorOk('Exception' + sLineBreak + E.Message + sLineBreak
        {$IFDEF CodeSite} + 'See details in CodeSite log'{$ENDIF}
        );
      end;
    end;

  BitBtn2.Caption := SaveCaption;
  BitBtn2.Enabled := True;
  Self.Update;
  CSExitMethod(Self, cFn);
end;

function TForm3.BodySampleForAttachment(const i: Integer): string;
var
  s8: UTF8String;
begin
  Result := 'Test #' + IntToStr(i) + ' as of ' +
    FormatDateTime('dddd dd-MMM-yyyy hh:nn', NowGMT) + sLineBreak;
  if cbUTF8.Checked then
  begin
    Result := Result + sLineBreak + ' Russian whteko follows ' +
      sLineBreak;
    S8 := UTF8StringLoadFromFile('..\WHTML\Shared WHTML\lingvo_rus.whteko');
    StripUTF8BOM(S8);
    Result := Result + sLineBreak + UnicodeString(S8);
  end;
  Result := Result + Memo1.Lines.Text + sLineBreak + sLineBreak +
    'compiled with ' + PascalCompilerCode;
end;

procedure TForm3.FormCreate(Sender: TObject);
const cFn = 'FormCreate';
begin
  CSEnterMethod(Self, cFn);
  IdAttachment1 := nil;
  IdText1 := nil;
  IdMsgBldr1 := nil;

  Application.Title := Application.Title + ' (' + PascalCompilerCode + ')';
  BitBtn2.Caption := BitBtn2.Caption + ' (' + PascalCompilerCode + ')';

  IdSMTP1 := TIdSMTP.Create(Self);
  IdSMTP1.Name := 'IdSMTP1';
  IdSSLIOHandlerSocketOpenSSL1 := TIdSSLIOHandlerSocketOpenSSL.Create(Self);
  IdSSLIOHandlerSocketOpenSSL1.Name := 'IdSSLIOHandlerSocketOpenSSL1';
  with IdSSLIOHandlerSocketOpenSSL1 do
  begin
    MaxLineAction := TIdMaxLineAction.maException;
    Port := 0;
    DefaultPort := 0;
    SSLOptions.Mode := sslmUnassigned;
    SSLOptions.VerifyMode := []; // [sslvrfFailIfNoPeerCert];
    SSLOptions.VerifyDepth := 0;

    //  let the SSL/TLS handshake determine the highest
    // available SSL/TLS version dynamically.
    SSLOptions.Method := TIdSSLVersion.sslvSSLv23;
  end;

  IdMessage1 := TIdMessage.Create(Self);
  IdMessage1.Name := 'IdMessage1';

  with IdSMTP1 do
  begin
    OnStatus := IndyMailStatus;
    IOHandler := IdSSLIOHandlerSocketOpenSSL1;
    Port := 587;
    SASLMechanisms.Clear;
    UseTLS := utUseExplicitTLS;
  end;

  { optionally use a local file to fill in default values for any of the
    edit boxes, for example:

      EditUser.Text := 'access user';
      EditPass.Text := 'password';
      EdFrom.Text := 'webmaster @href.com';
      EdCC.Text := 'customer service@href.com';
      EdTo.Text := 'ann @href.com'; }

  {$I client_access_info.txt}  // optional local file (can be 0 bytes - empty)

  // any local pdf file for testing
  EditFilespec.Text :=
    ExtractFilePath(ParamStr(0)) +
    '..\..\..\Source\StandaloneDemos\EMail_with_StartTLS\LoremIpsum.pdf';

  CSExitMethod(Self, cFn);
end;

procedure TForm3.FormDestroy(Sender: TObject);
const cFn = 'FormDestroy';
begin
  CSEnterMethod(Self, cFn);
  idMessage1.MessageParts.Clear;
  IdAttachment1 := nil; // destroyed by clearing MessageParts BUT not set to nil
  IdText1 := nil;       // same here (nb: used in test #3)
  FreeAndNil(IdAttachment1);
  FreeAndNil(IdText1);
  FreeAndNil(IdMsgBldr1);
  FreeAndNil(idMessage1);
  FreeAndNil(IdSSLIOHandlerSocketOpenSSL1);
  FreeAndNil(idSMTP1);
  CSExitMethod(Self, cFn);
end;

procedure TForm3.IndyMailStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
const cFn = 'IndyMailStatus';
begin
  CSSend(Self.ClassName + '.' + cFn, AStatusText);
end;

function TForm3.IntentionalError_MissingAttachment: Boolean;
begin
{ leads to exception
Cannot open file "D:\Kynosoura\Projects\book-googledrive\Who Knew - Public Edition\Book Cloud\2013-11-05_Germany_WSJ_ValuableCacheOfNazi-SeizedArt.bad". The system cannot find the file specified
}
  Result := RadioGroup1.ItemIndex = 6;
end;

function TForm3.IntentionalError_SmtpPassword: Boolean;
begin
  Result := RadioGroup1.ItemIndex = 3;
end;

function TForm3.IntentionalError_SmtpSenderEmail: Boolean;
begin
{ leads to exception from Amazon SES through mail dialogue:
Message rejected: Email address is not verified.
}
  Result := RadioGroup1.ItemIndex = 4;
end;

function TForm3.IntentionalError_SmtpServer: Boolean;
begin
{ leads to exception:
Socket Error # 11001
Host not found. }
  Result := RadioGroup1.ItemIndex = 1;
end;

function TForm3.IntentionalError_SmtpUsername: Boolean;
begin
{ leads to exception
Authentication Credentials Invalid
}
  Result := RadioGroup1.ItemIndex = 2;
end;

function TForm3.SubjectSample(const i: Integer): string;
begin
  Result := 'EMail Test, Mode ' + IntToStr(i) + ', ';
  if cbUTF8.Checked then
    Result := Result + cCharsetUTF8 + ', ';
  if Checkbox1.Checked then
    Result := Result + 'pdf, ';
  Result := Result + PascalCompilerCode;
end;

end.
