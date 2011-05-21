unit whAsyncDemo_dmProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMProjMgr, tpProj;

type
  TDMForWHAsync = class(TDMForWHDemo)
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: string;
      var Continue: Boolean);
    procedure ProjMgrGUIInit(Sender: TtpProject; const ShouldEnableGUI: Boolean;
      var ErrorText: string; var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHAsync: TDMForWHAsync;

implementation

uses
  MultiTypeApp,
  webCall,
  AsyncDm, StreamsDM, SimpleDm, whAsyncDemo_fmWhRequests;

{$R *.dfm}

procedure TDMForWHAsync.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  Application.CreateForm(TdmAsyncDemo, dmAsyncDemo);
  Application.CreateForm(TdmStreams, dmStreams);
  Application.CreateForm(TdmSimpleAsync, dmSimpleAsync);
end;

procedure TDMForWHAsync.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  Application.CreateForm(TfmWhRequests, fmWhRequests);
end;

procedure TDMForWHAsync.ProjMgrGUIInit(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  AddConnectionExecuteHandler(fmWhRequests.WebCommandLineExecute);
end;

end.
