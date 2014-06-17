program WHBridge2EditPad;

uses
  EMemLeaks,
  FMX.Forms,
  WHBridge2EditPad_fmMain in 'WHBridge2EditPad_fmMain.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
