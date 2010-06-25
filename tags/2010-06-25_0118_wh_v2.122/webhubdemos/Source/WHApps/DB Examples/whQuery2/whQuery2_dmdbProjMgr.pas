unit whQuery2_dmdbProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMDBProjMgr, tpProj;

type
  TDMForWHQuery2 = class(TDMForWHDBDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrGUIInit(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHQuery2: TDMForWHQuery2;

implementation

{$R *.dfm}

uses
  MultiTypeApp,
  webApp,
  htqry2C, counter;

procedure TDMForWHQuery2.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TfmHTQ2Panel, fmHTQ2Panel);
  {M}Application.CreateForm(TfmCounterPanel, fmCounterPanel);

end;

procedure TDMForWHQuery2.ProjMgrGUIInit(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  // implement a simplistic session counter
  pWebApp.OnNewSession := fmCounterPanel.htWebAppNewSession;
end;

end.
