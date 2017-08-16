program SetupEditPadForWebHub;

{$R *.dres}

//note to WebHub developers: use H:\ instead of K:\WebHub\TPack for these paths.

uses
  FMX.Forms,
  ZM_CodeSiteInterface,
  ucDlgs in 'k:\webhub\tpack\ucDlgs.pas',
  ucDlgsGUI in 'k:\webhub\tpack\ucDlgsGUI.pas',
  ucPos in 'k:\webhub\tpack\ucPos.pas',
  ucShell in 'k:\webhub\tpack\ucShell.pas',
  ucString in 'k:\webhub\tpack\ucString.pas',
  ucVers in 'k:\webhub\tpack\ucVers.pas',
  uCode in 'k:\webhub\tpack\uCode.pas',
  SetupEditPadForWebHub_fmMain in 'SetupEditPadForWebHub_fmMain.pas' {Form2},
  SetupEditPadForWebHub_uDownload in 'SetupEditPadForWebHub_uDownload.pas',
  SetupEditPadForWebHub_uColors in 'SetupEditPadForWebHub_uColors.pas',
  SetupEditPadForWebHub_uPaths in 'SetupEditPadForWebHub_uPaths.pas',
  uFileIO_Helper in 'K:\WebHub\ZaphodsMap_Tests_DUnitX\ZM_DUnitX_Common\uFileIO_Helper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
