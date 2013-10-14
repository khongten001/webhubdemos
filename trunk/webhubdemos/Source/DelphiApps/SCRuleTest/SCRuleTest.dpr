program SCRuleTest;

uses
  Vcl.Forms,
  SCRuleTest_fmMain in 'SCRuleTest_fmMain.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
