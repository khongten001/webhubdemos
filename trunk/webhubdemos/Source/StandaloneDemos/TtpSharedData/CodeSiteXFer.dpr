program CodeSiteXFer;

uses
  CodeSiteLogging,
  Vcl.Forms,
  CodeSiteXFer_fmMain in 'CodeSiteXFer_fmMain.pas' {Form3},
  ucCodeSiteInterface in 'K:\WebHub\tpack\ucCodeSiteInterface.pas',
  tpStreams in 'K:\WebHub\tpack\tpStreams.pas',
  tpShareB in 'K:\WebHub\tpack\tpShareB.pas';

{$R *.res}

begin
  Application.Initialize;
  CodeSiteManager.Enabled := True;
  CodeSite.Send(ParamStr(0));
  CodeSite.SendNote('this is a test');
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
