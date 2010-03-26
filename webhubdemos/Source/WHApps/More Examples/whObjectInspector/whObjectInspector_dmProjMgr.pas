unit whObjectInspector_dmProjMgr;

{ *** custom datamodule(s) requires custom step Create #3 *** }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMProjMgr, tpProj;

type
  TDMForWHDemo1 = class(TDMForWHDemo)
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
  DMForWHDemo1: TDMForWHDemo1;

implementation

{$R *.dfm}

uses
  MultiTypeApp, whObjectInspector_dmWhAction;
  
procedure TDMForWHDemo1.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TdmWhAction, dmWhAction);
end;

procedure TDMForWHDemo1.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  dmWhAction.Init;
end;

end.
