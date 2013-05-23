program AppRoleTester;

uses
  Vcl.Forms,
  AppRoleTester_fmMain in 'AppRoleTester_fmMain.pas' {Form3},
  tpApplic in 'K:\WebHub\tpack\tpApplic.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
