program cgidemo;

uses
  Forms,
  AppCGI in 'AppCGI.pas' {fmWebAppCGI};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmWebAppCGI, fmWebAppCGI);
  Application.Run;
end.
