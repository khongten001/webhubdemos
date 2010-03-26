unit whSendMail_dmProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMProjMgr, tpProj;

type
  TDMForWHSendMail = class(TDMForWHDemo)
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHSendMail: TDMForWHSendMail;

implementation

{$R *.dfm}

uses
  MultiTypeApp, whSendmail_dmWhQuote;

procedure TDMForWHSendMail.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TdmWhQuote, dmWhQuote);
end;

end.
