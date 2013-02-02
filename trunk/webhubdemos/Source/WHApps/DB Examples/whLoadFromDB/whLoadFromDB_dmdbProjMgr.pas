unit whLoadFromDB_dmdbProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMDBProjMgr, tpProj;

type
  TDMForWHLoadFromDB = class(TDMForWHDBDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrGUIInit(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHLoadFromDB: TDMForWHLoadFromDB;

implementation

{$R *.dfm}

uses
  MultiTypeApp, whLoadFromDB_fmWhAppDBHTML, whLoadFromDB_dmWhRetrieve,
  whLoadFromDB_dmwhData;

procedure TDMForWHLoadFromDB.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TDMContent, DMContent);
  if False then
    {M}Application.CreateForm(TdmWhRetrieve, dmWhRetrieve);
end;

procedure TDMForWHLoadFromDB.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  Continue := DMContent.Init(ErrorText);
  if False then
    if Continue then
      Continue := dmWhRetrieve.Init(ErrorText);
end;

procedure TDMForWHLoadFromDB.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TfmAppDBHTML, fmAppDBHTML);
end;

procedure TDMForWHLoadFromDB.ProjMgrGUIInit(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  if Assigned(dmWhRetrieve) then
    Continue := dmWhRetrieve.InitGUI(ErrorText);
end;

end.

