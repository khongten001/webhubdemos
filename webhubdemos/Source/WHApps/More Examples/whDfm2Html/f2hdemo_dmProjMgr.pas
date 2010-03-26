unit f2hdemo_dmProjMgr;

interface

uses
  SysUtils, Classes, tpProj;

type
  TPMforF2H = class(TDataModule)
    ProjMgr: TtpProject;
    procedure ProjMgrDataModulesCreate1(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesCreate2(Sender: TtpProject;
      const SuggestedAppID: String; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrGUIInit(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PMforF2H: TPMforF2H;

implementation

uses
  MultiTypeApp,
  whdemo_Initialize, whDM, fmf2h, sample, whsample_EvtHandlers,
  whdemo_ViewSource, f2hf;

{$R *.dfm}

procedure TPMforF2H.ProjMgrDataModulesCreate1(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  {M}Application.CreateForm(TwhDataModule, whDataModule);
end;

var
  ACoverPageFilespec: string;

procedure TPMforF2H.ProjMgrDataModulesCreate2(Sender: TtpProject;
  const SuggestedAppID: String; var ErrorText: String;
  var Continue: Boolean);
begin
  whDemoSetAppId('dfm2html');  // this refreshes the app

  //Cover again after refresh
  CoverApp('dfm2html', 1, 'Loading WebHub Demo application', False,
    ACoverPageFilespec);

  // We want to let a parameter determine the AppID served by whLite.exe
  // See ucString.pas and uCode.pas for DefaultsTo and ParamString functions
  whDemoCreateSharedDataModules;
end;

procedure TPMforF2H.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
//
end;

procedure TPMforF2H.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  whDataModule.Init;
  whDemoInit;
  whDemoSetDelphiSourceLocation(
    'D:\Projects\WebHub Demos\Source\WHApps\More Examples\whDfm2Html\', False);
end;

procedure TPMforF2H.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  {M}Application.CreateForm(TfmF2HDemo, fmF2HDemo);
  {M}Application.CreateForm(TsampleFrm, sampleFrm);
  {M}Application.CreateForm(Tf2hFrm, f2hFrm);
end;

procedure TPMforF2H.ProjMgrGUIInit(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  UncoverApp(ACoverPageFilespec);
end;

end.
