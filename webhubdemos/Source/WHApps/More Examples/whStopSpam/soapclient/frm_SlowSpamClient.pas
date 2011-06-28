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
  {to test your own copy, change the URLs here}
//  SetURLs('http://local32/scriptsd07/runisa_d15_debug_win32.dll/htun/wsdl/waSlowSpam',
//    'http://local32/scriptsd07/runisa_d15_debug_win32.dll/htun/soap/waSlowSpam');
end;

end.
