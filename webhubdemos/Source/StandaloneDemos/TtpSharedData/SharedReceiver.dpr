program SharedReceiver;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  SharedReceiver_fmMain in 'SharedReceiver_fmMain.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.UseMetropolisUI;
  TStyleManager.TrySetStyle('Metropolis UI Dark');
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Metropolis UI Application';
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
