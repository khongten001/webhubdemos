program whapp;

// WhApp.dpr
// This project provides a starting point for WebHub applications,
// for people who want to avoid using form inheritance.

// The AppID defaults to AppID as set in AppMain.pas.

uses
  Forms,
  utPanFrm in '..\..\lib\UTPANFRM.PAS' {utParentForm},
  utTrayFM in '..\..\lib\UTTRAYFM.PAS' {fmTrayForm},
  whHTML in '..\..\lib\WHHTML.PAS' {fmAppHTML},
  whAppIn in '..\..\lib\WHAPPIN.PAS' {fmAppIn},
  whAppOut in '..\..\lib\WHAPPOUT.PAS' {fmAppOut},
  AppMain in '..\..\lib\APPMAIN.PAS' {fmWebAppMainForm},
  APPCUSTM in '..\..\lib\APPCUSTM.PAS' {fmAppCustomPanel},
  AppUtil in '..\..\lib\Apputil.pas',
  utMainFm in '..\..\lib\utMainFm.pas' {fmMainForm},
  readme in 'readme.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmWebAppMainForm, fmWebAppMainForm);
  Application.CreateForm(TfmAppCustomPanel, fmAppCustomPanel);
  Application.CreateForm(TfmAppHTML, fmAppHTML);
  Application.CreateForm(TfmAppIn, fmAppIn);
  Application.CreateForm(TfmAppOut, fmAppOut);
  fmWebAppMainForm.Init;
  Application.Run;
end.



