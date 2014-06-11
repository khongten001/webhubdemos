program SetupEditPadForWebHub;

{$R *.dres}

uses
  FMX.Forms,
  ucCodeSiteInterface in 'k:\webhub\tpack\ucCodeSiteInterface.pas',
  ucString in 'k:\webhub\tpack\ucString.pas',
  SetupEditPadForWebHub_fmMain in 'SetupEditPadForWebHub_fmMain.pas' {Form2},
  SetupEditPadForWebHub_uDownload in 'SetupEditPadForWebHub_uDownload.pas',
  SetupEditPadForWebHub_uColors in 'SetupEditPadForWebHub_uColors.pas',
  SetupEditPadForWebHub_uPaths in 'SetupEditPadForWebHub_uPaths.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
