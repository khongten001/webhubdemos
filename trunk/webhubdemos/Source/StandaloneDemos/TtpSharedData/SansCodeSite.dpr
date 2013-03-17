program SansCodeSite;

uses
  CodeSiteLogging in 'alternate\CodeSiteLogging.pas',
  Vcl.Forms,
  SansCodeSite_fmMain in 'SansCodeSite_fmMain.pas' {Form5},
  ucCodeSiteInterface in 'K:\WebHub\tpack\ucCodeSiteInterface.pas';

{$R *.res}

// NB: This uses the FAKE CodeSiteLogging unit for testing purposes.
// Data goes through TtpSharedBuf and then into CodeSite

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
