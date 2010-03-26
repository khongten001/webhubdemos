unit whRubicon_dmdbProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMDBProjMgr, tpProj;

type
  TDMForWHRubicon = class(TDMForWHDBDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHRubicon: TDMForWHRubicon;

implementation

{$R *.dfm}

uses
  MultiTypeApp, htRubiC, htru_fmExMakeU;
  
procedure TDMForWHRubicon.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TfmHTRUPanel, fmHTRUPanel);
  {M}Application.CreateForm(TfmRubiconMakeBDE, fmRubiconMakeBDE);
end;

end.
