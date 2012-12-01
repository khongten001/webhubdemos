program IbObj_Bootstrap;

uses
  Vcl.Forms,
  IbObj_Bootstrap_fmMain in 'IbObj_Bootstrap_fmMain.pas' {Form2},
  ucIBObjCodeGen_Bootstrap in 'K:\WebHub\tpack\ucIBObjCodeGen_Bootstrap.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
