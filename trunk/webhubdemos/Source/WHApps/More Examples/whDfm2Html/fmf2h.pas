unit fmf2h;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, whDM, ActnList, tpAction, tpActionGUI;

type
  TfmF2HDemo = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button6: TButton;
    tpActionListApp: TtpActionList;
    app_Edit01: TtpVCLAction;
    app_Save01: TtpVCLAction;
    app_Reload01: TtpVCLAction;
    app_SelectSession1: TtpVCLAction;
    app_DeleteSessions1: TtpVCLAction;
    app_Separator1: TtpVCLAction;
    app_PickAppID1: TtpVCLAction;
    app_EditPages1: TtpVCLAction;
    app_EditMacros1: TtpVCLAction;
    app_EditEvents1: TtpVCLAction;
    app_EditFiles1: TtpVCLAction;
    app_EditChunks1: TtpVCLAction;
    app_EditMediaSources1: TtpVCLAction;
    app_ViewUploadedFiles1: TtpVCLAction;
    app_ViewErrors1: TtpVCLAction;
    app_ExportPages1: TtpVCLAction;
    app_EditAppSettings1: TtpVCLAction;
    app_EditConfigFile1: TtpVCLAction;
    app_UnCoverApp1: TtpVCLAction;
    app_TestComponent1: TtpVCLAction;
    app_Update1: TtpVCLAction;
    app_Refresh1: TtpVCLAction;
    app_Help1: TtpVCLAction;
    app_Properties1: TtpVCLAction;
    Button4: TButton;
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmF2HDemo: TfmF2HDemo;

implementation

{$R *.DFM}

uses
  sample;

procedure TfmF2HDemo.Button3Click(Sender: TObject);
begin
  sampleFrm.show;
end;

end.
