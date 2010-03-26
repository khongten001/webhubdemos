unit fmShared;
//fmCommon.GlobalCommand:='0';  //ignore
//fmCommon.GlobalCommand:='1';  //close
//fmCommon.GlobalCommand:='2';  //CentralInfo.refresh
//fmCommon.GlobalCommand:='3';  //webapp.refresh
//fmCommon.GlobalCommand:='4';  //webcommandline.suspend
//fmCommon.GlobalCommand:='5';  //webcommandline.resume

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, 
  utpanfrm, tpShareI, updateOk{non-gui}, updateOKGUI, 
  tpApplic{non-gui}, tpApplicGUI, 
  WebCall;

type
  TfmCommon = class(TutParentForm)
    Global: TtpSharedLongint;
    rg: TRadioGroup;
    Button1: TButton;
    tpAppRole1: TtpAppRole;
    laDBAlias: TLabel;
    edDBAlias: TEdit;
    btSet: TButton;
    Label1: TLabel;
    edWords: TEdit;
    procedure GlobalChange(Sender: TObject; var Continue: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure SetGlobalCommand(const Value:String);
    procedure AppUpdate(Sender: TObject);
  public
    { Public declarations }
    WebCommandLine: TwhConnection;
    property GlobalCommand:String write SetGlobalCommand;
  end;

var
  fmCommon: TfmCommon;

implementation         //winnt

{$R *.DFM}

uses
  WebInfou,WebApp, htWebApp;

procedure TfmCommon.FormCreate(Sender: TObject);
begin
  inherited;
  Global.GlobalName:=pWebApp.AppIDEx;
  AppUpdate(Sender);
  AddAppUpdateHandler(AppUpdate);
end;

procedure TfmCommon.AppUpdate(Sender: TObject);
begin
  edDBAlias.Text:=pWebApp.AppSetting['DatabaseAlias'];
  edWords.Text:=pWebApp.AppSetting['WordsTable'];
end;

procedure TfmCommon.SetGlobalCommand(const Value:String);
begin
  Global.GlobalName:=pWebApp.AppID;
  Global.GlobalValue:=0;
  sleep(20);
  application.processmessages;
  sleep(20);
  application.processmessages;
  sleep(20);
  Global.GlobalValue:=StrToIntDef(Value,0);
  sleep(20);
end;

procedure TfmCommon.GlobalChange(Sender: TObject; var Continue: Boolean);
begin
  inherited;
  with TtpSharedLongInt(Sender) do
    case GlobalValue of
      0:;
      1:begin
        Continue := False;
        Application.Terminate;
        end;
      2:begin
        pWebApp.CentralInfo.Refresh;
        end;
      3:begin
        pWebApp.Refresh;
        end;
      4:begin
        if Assigned(WebCommandLine) then
          WebCommandLine.Active:=False;
        end;
      5:begin
        if Assigned(WebCommandLine) then
          WebCommandLine.Active:=True;
        end;
      end;
end;

procedure TfmCommon.Button1Click(Sender: TObject);
begin
  inherited;
  Global.IgnoreOwnChanges:=False;
  GlobalCommand:=IntToStr(succ(rg.ItemIndex));
  Global.IgnoreOwnChanges:=True;
end;

end.
