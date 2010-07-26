program WebHubSyntaxCheck;

uses
  MultiTypeApp,
  WebHubSyntaxCheck_fmMain in 'WebHubSyntaxCheck_fmMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
