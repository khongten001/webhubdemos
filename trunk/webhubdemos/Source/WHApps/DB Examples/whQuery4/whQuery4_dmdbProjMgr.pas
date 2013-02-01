unit whQuery4_dmdbProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMDBProjMgr, tpProj;

type
  TDMForWHQuery4 = class(TDMForWHDBDemo)
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHQuery4: TDMForWHQuery4;

implementation

{$R *.dfm}

uses
  MultiTypeApp, htqry4DM, grid2DM;
  
procedure TDMForWHQuery4.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  // create custom data modules
  {M}Application.CreateForm(TDataModuleHTQ4, DataModuleHTQ4);
  {M}Application.CreateForm(TDataModuleGrid2, DataModuleGrid2);
end;

procedure TDMForWHQuery4.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  Continue := DataModuleGrid2.Init(ErrorText);
  if Continue then
    Continue := DataModuleHTQ4.Init(ErrorText);
end;

end.
