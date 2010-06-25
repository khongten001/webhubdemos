program SlowSpamClient;

uses
  Forms,
  frm_SlowSpamClient in 'frm_SlowSpamClient.pas' {frmSlowSpamClient},
  soap_waSlowSpam in 'soap_waSlowSpam.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSlowSpamClient, frmSlowSpamClient);
  Application.Run;
end.
