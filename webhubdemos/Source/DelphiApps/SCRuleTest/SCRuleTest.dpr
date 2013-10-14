program SCRuleTest;

uses
  Vcl.Forms,
  SCRuleTest_fmMain in 'SCRuleTest_fmMain.pas' {Form3},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Golden Graphite');
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
