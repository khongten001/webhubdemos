program IbObj_Bootstrap;

// use with WebHub v2.181+ or v3.181+

uses
  Vcl.Forms,
  ucIBObjCodeGen_Bootstrap,
  IbObj_Bootstrap_fmMain in 'IbObj_Bootstrap_fmMain.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
