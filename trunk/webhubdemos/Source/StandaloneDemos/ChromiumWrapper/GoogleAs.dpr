program GoogleAs;

{$I hrefdefines.inc}

uses
  Forms,
  ZM_CodeSiteInterface in 'H:\ZM_CodeSiteInterface.pas',
  ucShellProcessCntrl in 'k:\webhub\tpack\ucShellProcessCntrl.pas',
  uCode in 'k:\webhub\tpack\uCode.pas',
  System.UITypes,
  ceflib in 'Externals\CEF3\src\ceflib.pas',
  cefgui in 'Externals\CEF3\src\cefgui.pas',
  ceferr in 'Externals\CEF3\src\ceferr.pas',
  cefvcl in 'Externals\CEF3\src\cefvcl.pas',
  GoogleAs_uCEF3_Init in 'GoogleAs_uCEF3_Init.pas',
  GoogleAs_fmChromium in 'GoogleAs_fmChromium.pas' {fmChromiumWrapper},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

var
  Flag: Boolean;

begin
  InitCEF_GoogleAs(Flag);
  ConditionalStartup(Flag);
end.
