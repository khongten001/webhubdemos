unit whClone_dmdbProjMgr;

interface

{$I hrefdefines.inc}

uses
  SysUtils, Classes,
  whdemo_DMDBProjMgr, tpProj;

type
  TDMForWHClone = class(TDMForWHDBDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: string; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject; var ErrorText: string;
      var Continue: Boolean);
    procedure ProjMgrStartupComplete(Sender: TtpProject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHClone: TDMForWHClone;

implementation

{$R *.dfm}

uses
  MultiTypeApp,
  ucCodeSiteInterface,
  {$IFNDEF PREVENTGUI}fmclone,{$ENDIF}
  whutil_ZaphodsMap, webApp, htWebApp,
  webCall, whClone_dmwhData, whClone_dmwhGridsNScans;

procedure TDMForWHClone.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
const cFn = 'ProjMgrDataModulesCreate3';
begin
  CSEnterMethod(Self, cFn);
  inherited;
  {M}Application.CreateForm(TDMData2Clone, DMData2Clone);
  {M}Application.CreateForm(TDMGridsNScans, DMGridsNScans);
  CSExitMethod(Self, cFn);
end;

procedure TDMForWHClone.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
const cFn = 'ProjMgrDataModulesInit';
begin
  CSEnterMethod(Self, cFn);
  inherited;
  Continue := DMData2Clone.Init(ErrorText);
  if Continue then
    Continue := DMGridsNScans.Init(ErrorText);
  CSExitMethod(Self, cFn);
end;

procedure TDMForWHClone.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
const cFn = 'ProjMgrGUICreate';
begin
  CSEnterMethod(Self, cFn);
  inherited;
  {$IFNDEF PREVENTGUI}
  if ShouldEnableGUI then
    {M}Application.CreateForm(TfmBendFields, fmBendFields);
  {$ENDIF}
  CSExitMethod(Self, cFn);
end;

procedure TDMForWHClone.ProjMgrStartupComplete(Sender: TtpProject);
begin
  inherited;
  UncoverAppOnStartup(pWebApp.AppID);
  pConnection.MarkReadyToWork;
end;

end.

