unit frm_SlowSpamClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,
  soap_waSlowSpam;

type
  TfrmSlowSpamClient = class(TForm)
    lblInput: TLabel;
    edtInput: TEdit;
    chkReadyForWeb: TCheckBox;
    lblOutput: TLabel;
    edtOutput: TEdit;
    btnTest: TBitBtn;
    btnClose: TBitBtn;
    BtnShowResult: TBitBtn;
    procedure btnTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnShowResultClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FTestHtmlFilespec: string;
  public
    { Public declarations }
    procedure Test;
  end;

var
  frmSlowSpamClient: TfrmSlowSpamClient;

implementation

{$R *.dfm}

uses
  ucShell, ucLogFil, ucString, ucFile, uCode;

{ TfrmSlowSpamClient }

procedure TfrmSlowSpamClient.BtnShowResultClick(Sender: TObject);
begin
  if FTestHtmlFilespec = '' then
    FTestHtmlFilespec := GetTempFileName('htun-soap-client-demo.html');
  UTF8StringWriteToFile(FTestHtmlFilespec, UTF8Encode(edtOutput.Text));
  WinShellOpen(FTestHtmlFilespec);
end;

procedure TfrmSlowSpamClient.btnTestClick(Sender: TObject);
begin
  Test;
end;

procedure TfrmSlowSpamClient.Test;
var
  InstanceID: Cardinal;
  SessionID: Cardinal;
  input: UnicodeString;
  MakeResultReadyToCopyFromWeb: Boolean;
begin
  edtOutput.Enabled := False;
  try
    try
      edtOutput.Text := 'Processing...';
      Update;
      InstanceID := 0;
      SessionID := 0;
      input := edtInput.Text;
      MakeResultReadyToCopyFromWeb := chkReadyForWeb.Checked;
      edtOutput.Text := GetIwaSlowSpam.MailtoStrObfuscate(InstanceID, SessionID,
        input, MakeResultReadyToCopyFromWeb);
    except
      on E: Exception do
        edtOutput.Text := E.Message;
    end;
  finally
    edtOutput.Enabled := True;
  end;
end;

procedure TfrmSlowSpamClient.FormCreate(Sender: TObject);
begin
  FTestHtmlFilespec := '';
  Self.Caption := Self.Caption + ' compiled with ' + PascalCompilerCode;

  {To test your own server, change the URLs here. Leave commented-out to test
   against http://more.demos.href.com.
   See initialization of soap_waSlowSpam.pas for the default values.}

//  SetURLs('http://localhost/scripts/runisa.dll/htun/wsdl/waSlowSpam',
//    'http://localhost/scripts/runisa.dll/htun/soap/waSlowSpam');

//  SetURLs('http://local32/scriptsd07/runisa_d15_win32_debug.dll/htun/wsdl/waSlowSpam',
//    'http://local32/scriptsd07/runisa_d15_win32_debug.dll/htun/soap/waSlowSpam');

//  SetURLs('http://more.demos.href.com/scripts/runisa_d07_win32_debug.dll/' +
//    'htun/wsdl/waSlowSpam',
//    'http://more.demos.href.com/scripts/runisa_d07_win32_debug.dll/' +
//    'htun/soap/waSlowSpam');
end;

procedure TfrmSlowSpamClient.FormDestroy(Sender: TObject);
begin
  if FTestHtmlFilespec <> '' then
    DeleteFile(FTestHtmlFilespec);
end;

end.
