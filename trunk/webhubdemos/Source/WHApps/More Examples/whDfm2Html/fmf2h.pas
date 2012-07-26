unit fmf2h;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, whDM, ActnList, tpAction, tpActionGUI;

type
  TfmF2HDemo = class(TForm)
    ButtonEditFiles: TButton;
    ButtonAppRefresh: TButton;
    ButtonShowForm: TButton;
    ButtonEditConfigFile: TButton;
    tpActionListApp: TtpActionList;
    ButtonAppProperties: TButton;
    app_PickAppID1: TtpVCLAction;
    app_EditPages1: TtpVCLAction;
    app_EditMacros1: TtpVCLAction;
    app_EditEvents1: TtpVCLAction;
    app_EditFiles1: TtpVCLAction;
    app_EditDroplets1: TtpVCLAction;
    app_EditMediaSources1: TtpVCLAction;
    app_ViewUploadedFiles1: TtpVCLAction;
    app_ViewErrors1: TtpVCLAction;
    app_ExportPages1: TtpVCLAction;
    app_EditAppSettings1: TtpVCLAction;
    app_EditConfigFile1: TtpVCLAction;
    app_OpenErrorLogFolder1: TtpVCLAction;
    app_UnCoverApp1: TtpVCLAction;
    app_TestComponent1: TtpVCLAction;
    app_Update1: TtpVCLAction;
    app_Refresh1: TtpVCLAction;
    app_Help1: TtpVCLAction;
    app_Properties1: TtpVCLAction;
    procedure ButtonShowFormClick(Sender: TObject);
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

procedure TfmF2HDemo.ButtonShowFormClick(Sender: TObject);
begin
  sampleFrm.show;
end;

end.
