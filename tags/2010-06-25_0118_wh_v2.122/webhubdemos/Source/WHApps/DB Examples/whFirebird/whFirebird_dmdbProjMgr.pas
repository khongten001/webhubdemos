unit whFirebird_dmdbProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMDBProjMgr, tpProj;

type
  TDMForWHFirebird = class(TDMForWHDBDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHFirebird: TDMForWHFirebird;

implementation

{$R *.dfm}

uses
  MultiTypeApp, whfmEmployee;
  
procedure TDMForWHFirebird.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  // create additional forms AFTER appid has been set.
  {M}Application.CreateForm(TfmEmployee, fmEmployee);
end;

end.
