program Paradox2Xml;

uses
  Vcl.Forms,
  fmGUI in 'fmGUI.pas' {Form3},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Turquoise Gray');
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
