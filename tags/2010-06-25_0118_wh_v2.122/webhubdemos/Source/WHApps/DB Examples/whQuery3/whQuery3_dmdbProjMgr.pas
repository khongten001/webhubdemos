unit whQuery3_dmdbProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMDBProjMgr, tpProj;

type
  TDMForWHQuery3 = class(TDMForWHDBDemo)
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
  DMForWHQuery3: TDMForWHQuery3;

implementation

{$R *.dfm}

uses
  MultiTypeApp, htqry3DM;
  
procedure TDMForWHQuery3.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TDataModuleQ3, DataModuleQ3);

end;

procedure TDMForWHQuery3.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  DataModuleQ3.Init;
end;

end.
