unit whDynamicJPEG_dmProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMProjMgr, tpProj;

type
  TDMForWHDynamicJPEG = class(TDMForWHDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrGUIInit(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate2(Sender: TtpProject;
      const SuggestedAppID: String; var ErrorText: String;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHDynamicJPEG: TDMForWHDynamicJPEG;

implementation

{$R *.dfm}

uses
  MultiTypeApp, whDynamicJPEG_fmWh, dmwhAnsiUmlauts;

procedure TDMForWHDynamicJPEG.ProjMgrDataModulesCreate2(Sender: TtpProject;
  const SuggestedAppID: String; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TDataModule1, DataModule1);
end;

procedure TDMForWHDynamicJPEG.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TfmWhAnimals, fmWhAnimals);

end;

procedure TDMForWHDynamicJPEG.ProjMgrGUIInit(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  fmWhAnimals.Init;
end;

end.