unit Test_Indy_Smtp_dmProjMgr;

interface

{$I hrefdefines.inc}

uses
  SysUtils, Classes,
  tpProj;

type
  TDataModule1 = class(TDataModule)
    tpProject1: TtpProject;
    procedure tpProject1GUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: string;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

procedure BeforeApplicationRun;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  ucCodeSiteInterface, MultiTypeApp,
  {$IFDEF Delphi19UP}
  Vcl.Styles, Vcl.Themes,
  {$ENDIF }
  fmIndyEMailSSL;

procedure BeforeApplicationRun;
begin
end;

procedure TDataModule1.tpProject1GUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: string; var Continue: Boolean);
begin
  {$IFDEF Delphi19UP}
  // The Ruby Graphite style works when Vcl.Styles and Vcl.Themes
  // are included in the uses clause above
  // and
  // the program is compiled with Delphi XE5
  TStyleManager.TrySetStyle('Ruby Graphite');
  {$ENDIF}
  Application.CreateForm(TForm3, Form3);
end;

end.
