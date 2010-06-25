unit whParadox_dmProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMProjMgr, tpProj;

type
  TDMForWHParadox = class(TDMForWHDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate2(Sender: TtpProject;
      const SuggestedAppID: String; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHParadox: TDMForWHParadox;

implementation

{$R *.dfm}

uses
  MultiTypeApp, whParadox_fmWhProcess, whParadox_dmWhProcess;
  
procedure TDMForWHParadox.ProjMgrDataModulesCreate2(Sender: TtpProject;
  const SuggestedAppID: String; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  Application.CreateForm(TdmwhProcess, dmwhProcess);
end;

procedure TDMForWHParadox.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  dmwhProcess.Init;
end;

procedure TDMForWHParadox.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  {$IFNDEF PREVENTGUI}
  if ShouldEnableGUI then
  begin
    Application.CreateForm(TfmWhProcess, fmWhProcess);
  end;
  {$ENDIF}
end;

end.
