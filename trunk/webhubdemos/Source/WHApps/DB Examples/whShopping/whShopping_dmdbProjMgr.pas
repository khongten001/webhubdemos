unit whShopping_dmdbProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMProjMgr, tpProj;

type
  TDMForWHShopping = class(TDMForWHDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: string; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject; var ErrorText: string;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHShopping: TDMForWHShopping;

implementation

{$R *.dfm}

uses
  MultiTypeApp, HtShopC, whShopping_dmShop, whShopping_dmwhSessionWatch,
  dmwhGoogleAPIActions, dmwhSoapActions;

procedure TDMForWHShopping.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TDMShop1, DMShop1);
  {M}Application.CreateForm(TDMSessWatch, DMSessWatch);
  {M}Application.CreateForm(TDMGAPI, DMGAPI);
  {M}Application.CreateForm(TDMSOAPClient, DMSOAPClient);
end;

procedure TDMForWHShopping.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  Continue := DMShop1.Init(ErrorText);
  if Continue then
    Continue := DMSessWatch.Init(ErrorText);
  if Continue then
    Continue := DMGAPI.Init(ErrorText);
  if Continue then
    Continue := DMSOAPClient.Init(ErrorText);
end;

procedure TDMForWHShopping.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TfmShopPanel, fmShopPanel);
end;

end.

