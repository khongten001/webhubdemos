unit whAsyncDemo_dmProjMgr;

interface

uses
  Classes,
  whdemo_DMProjMgr, tpProj;

type
  TDMForWHAsync = class(TDMForWHDemo)
    procedure ProjMgrDataModulesCreate1(Sender: TtpProject;
      var ErrorText: string; var Continue: Boolean);
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject; var ErrorText: string;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHAsync: TDMForWHAsync;

implementation

uses
  SysUtils,
  MultiTypeApp,
  webCall, whSharedLog,
  AsyncDm, SimpleDm;

{$R *.dfm}

procedure TDMForWHAsync.ProjMgrDataModulesCreate1(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  UseWebHubSharedLog;
end;

procedure TDMForWHAsync.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  Application.CreateForm(TdmAsyncDemo, dmAsyncDemo);
  Application.CreateForm(TdmSimpleAsync, dmSimpleAsync);
end;

procedure TDMForWHAsync.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  Continue := dmAsyncDemo.Init(ErrorText);
  if Continue then
    Continue := dmSimpleAsync.Init(ErrorText);
  UseWebHubSharedLog;
end;

end.
