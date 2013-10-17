program GoogleAs;

{$I hrefdefines.inc}

uses
  {$IFDEF EUREKALOG}
  EMemLeaks,
  EResLeaks,
  EDebugExports,
  EAppVCL,
  ExceptionLog7,
  {$ENDIF}
  Forms,
  ucCodeSiteInterface in 'H:\ucCodeSiteInterface.pas',
  System.UITypes,
  ceflib in 'Externals\CEF1\src\ceflib.pas',
  cefvcl in 'Externals\CEF1\src\cefvcl.pas',
  GoogleAs_fmChromium in 'GoogleAs_fmChromium.pas' {fmChromiumWrapper},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  // must create Chromium wrapper form first -- main form
  TStyleManager.TrySetStyle('Emerald Light Slate');
  Application.CreateForm(TfmChromiumWrapper, fmChromiumWrapper);
  Application.Run;
end.
