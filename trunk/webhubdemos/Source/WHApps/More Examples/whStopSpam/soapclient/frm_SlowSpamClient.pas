unit frm_SlowSpamClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, soap_waSlowSpam, StdCtrls, Buttons;

type
  TfrmSlowSpamClient = class(TForm)
    lblInput: TLabel;
    edtInput: TEdit;
    chkReadyForWeb: TCheckBox;
    lblOutput: TLabel;
    edtOutput: TEdit;
    btnTest: TBitBtn;
    btnClose: TBitBtn;
    procedure btnTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Test;
  end;

var
  frmSlowSpamClient: TfrmSlowSpamClient;

implementation

{$R *.dfm}

uses
  uCode;

{ TfrmSlowSpamClient }

procedure TfrmSlowSpamClient.btnTestClick(Sender: TObject);
begin
  Test;
end;

procedure TfrmSlowSpamClient.Test;
var
  InstanceID: Cardinal;
  SessionID: Cardinal;
  input: WideString;
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
  {To test your own server, change the URLs here. Leave commented-out to test
   against http://more.demos.href.com}

//  SetURLs('http://localhost/scripts/runisa.dll/htun/wsdl/waSlowSpam',
//    'http://localhost/scripts/runisa.dll/htun/soap/waSlowSpam');

//  SetURLs('http://local32/scriptsd07/runisa_d15_debug_win32.dll/htun/wsdl/waSlowSpam',
//    'http://local32/scriptsd07/runisa_d15_debug_win32.dll/htun/soap/waSlowSpam');

  Self.Caption := Self.Caption + ' compiled with ' + PascalCompilerCode;

  SetURLs('http://more.demos.href.com/scripts/runisa_d07_win32_debug.dll/' +
    'htun/wsdl/waSlowSpam',
    'http://more.demos.href.com/scripts/runisa_d07_win32_debug.dll/' +
    'htun/soap/waSlowSpam');
end;

end.
