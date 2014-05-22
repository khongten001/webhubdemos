program SharedReceiverFmx;

uses
  FMX.Forms,
  tpShareB in 'k:\webhub\tpack\tpShareB.pas',
  SharedReceiverFmx_fmMain in 'SharedReceiverFmx_fmMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Test CodeSite via TPack shared buffer using Firemonkey';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
