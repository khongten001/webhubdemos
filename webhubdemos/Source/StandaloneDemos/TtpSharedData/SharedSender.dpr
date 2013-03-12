program SharedSender;

uses
  Vcl.Forms,
  SharedSender_fmMain in 'SharedSender_fmMain.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
