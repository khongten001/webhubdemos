program GoogleAs;

{$I hrefdefines.inc}

uses
  Forms,
  ucCodeSiteInterface in 'H:\ucCodeSiteInterface.pas',
  System.UITypes,
  {$IFDEF CEF3}
  ceflib in 'Externals\CEF3\src\ceflib.pas',
  cefvcl in 'Externals\CEF3\src\cefvcl.pas',
  {$ELSE}
  ceflib in 'Externals\CEF1\src\ceflib.pas',
  cefvcl in 'Externals\CEF1\src\cefvcl.pas',
  {$ENDIF}
  GoogleAs_uCEF3_Init in 'GoogleAs_uCEF3_Init.pas',
  GoogleAs_fmChromium in 'GoogleAs_fmChromium.pas' {fmChromiumWrapper},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

var
  Flag: Boolean;

begin
  {$IFDEF CEF3}
  InitCEF_GoogleAs(Flag);
  ConditionalStartup(Flag);
  {$ELSE}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  // must create Chromium wrapper form first -- main form
  TStyleManager.TrySetStyle('Emerald Light Slate');
  Application.CreateForm(TfmChromiumWrapper, fmChromiumWrapper);
  Application.Run;
  {$ENDIF}
end.
