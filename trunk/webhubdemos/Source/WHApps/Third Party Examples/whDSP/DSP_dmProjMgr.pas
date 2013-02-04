unit DSP_dmProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMProjMgr, tpProj;

type
  TPMForDSP = class(TDMForWHDemo)
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate2(Sender: TtpProject;
      const SuggestedAppID: String; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrStop(Sender: TtpProject; var ErrorText: String;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PMForDSP: TPMForDSP;

implementation

{$R *.dfm}

uses
  MultiTypeApp, webApp, htWebApp, DSP_u1, DSP_dmDisplayResults, DSP_dmWH1,
  whsample_ExceptionTester, DSP_dmRubicon, DSP_fmPanelSearch;
  //DSP_fmConfigure; obsolete

procedure TPMForDSP.ProjMgrDataModulesCreate2(Sender: TtpProject;
  const SuggestedAppID: String; var ErrorText: String; var Continue: Boolean);
begin
  Inherited;
  DSPAppHandler := TDSPAppHandler.Create;
  With pWebApp, DSPAppHandler do
  begin
    AddAppUpdateHandler(DSPAppUpdate);
    AddAppAfterExecuteHandler(DSPAppExecute);
    OnError := DSPAppError;
    OnEventMacro := DSPAppEventMacro;
    OnExecDone := DSPAppExecDone;
    OnNewSession := DSPAppNewSession;
    OnBadIP := DSPAppBadIP; // 1-June-2001 AML
  end;
  pWebApp.Refresh; // Sets WordsDatabaseName
end;

procedure TPMForDSP.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  Inherited;
  { M } Application.CreateForm(TDSPdm, DSPdm);
  { M } Application.CreateForm(TdmDisplayResults, dmDisplayResults);
  { M } Application.CreateForm(TdmDSPWebSearch, dmDSPWebSearch);
  // web action component to display results.
end;

procedure TPMForDSP.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  Inherited;
  DSPdm.Init;
  // Loads database, using AppSettings. Rubicon components in here. BEFORE MacrosUpdate!!
  DSPAppHandler.DSPMacrosUpdate;
  DSPdm.rbSearch.Cache := nil; // per Deven's advice, 16-May-2001.
  dmDSPWebSearch.Init;
end;

procedure TPMForDSP.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String; var Continue: Boolean);
begin
  Inherited;
  if ShouldEnableGUI then
  begin
    { M } Application.CreateForm(TfmSearchForm, fmSearchForm);
//    { M } Application.CreateForm(TfmAppConfigure, fmAppConfigure);
    { M } Application.CreateForm(TfmAppPanelExceptions, fmAppPanelExceptions);
  end;
end;

procedure TPMForDSP.ProjMgrStop(Sender: TtpProject; var ErrorText: String;
  var Continue: Boolean);
begin
  Inherited;
  FreeAndNil(DSPAppHandler);
end;

end.
