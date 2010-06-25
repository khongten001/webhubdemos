program whapp2;

// whApp2.dpr
// This project provides a starting point for a minimalist
// WebHub application.

uses
  MultiTypeApp, SysUtils, htWebApp;

{$R *.RES}
{$R whAppIco.res}

var
  a: TwhApplication;

begin
  {M}Application.Initialize;
  a := TwhApplication.Create(Application.RootOwner);
  a.AppID := 'appvers';
  a.Refresh;
  Application.Run;
  FreeAndNil(a);
end.
