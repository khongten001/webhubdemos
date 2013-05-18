unit whClone_dmdbProjMgr;

interface

{$I hrefdefines.inc}
{$I WebHub_Comms.inc}

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
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  MultiTypeApp,
  {$IFNDEF PREVENTGUI}fmclone,{$ENDIF}
  webCall, whClone_dmwhData, whClone_dmwhGridsNScans;

procedure TDMForWHClone.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
const cFn = 'ProjMgrDataModulesCreate3';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  {M}Application.CreateForm(TDMData2Clone, DMData2Clone);
  {M}Application.CreateForm(TDMGridsNScans, DMGridsNScans);
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMForWHClone.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
const cFn = 'ProjMgrDataModulesInit';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  Continue := DMData2Clone.Init(ErrorText);
  if Continue then
    Continue := DMGridsNScans.Init(ErrorText);
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMForWHClone.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
const cFn = 'ProjMgrGUICreate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  {$IFNDEF PREVENTGUI}
  if ShouldEnableGUI then
    {M}Application.CreateForm(TfmBendFields, fmBendFields);
  {$ENDIF}
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMForWHClone.ProjMgrStartupComplete(Sender: TtpProject);
begin
  inherited;
  {$IFDEF WEBHUBACE}
  pConnection.MarkReadyToWork;
  {$ENDIF}
end;

end.

