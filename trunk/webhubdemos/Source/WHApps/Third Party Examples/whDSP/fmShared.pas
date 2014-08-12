unit fmShared;
//fmCommon.GlobalCommand:='0';  //ignore
//fmCommon.GlobalCommand:='1';  //close
//fmCommon.GlobalCommand:='2';  //CentralInfo.refresh
//fmCommon.GlobalCommand:='3';  //webapp.refresh
//fmCommon.GlobalCommand:='4';  //webcommandline.suspend
//fmCommon.GlobalCommand:='5';  //webcommandline.resume

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  ExtCtrls, StdCtrls, 
  utpanfrm, tpShareB, updateOk{non-gui}, updateOKGUI, 
  tpApplic{non-gui}, tpApplicGUI, 
  webCall;

type
  TfmCommon = class(TutParentForm)
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
    Global: TSharedInt;
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
  Global := TSharedInt.CreateNamed(Self, pWebApp.AppID, cReadWriteSharedMem, cLocalSharedMem);
  Global.Name := 'Global';
  Global.OnChange := GlobalChange;
  Global.GlobalInteger := 0;

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
  if Global.GlobalName <> pWebApp.AppID then
    Global.GlobalName:=pWebApp.AppID;
  Global.GlobalInteger := 0;
  sleep(20);
  application.processmessages;
  sleep(20);
  application.processmessages;
  sleep(20);
  Global.GlobalInteger:=StrToIntDef(Value,0);
  sleep(20);
end;

procedure TfmCommon.GlobalChange(Sender: TObject);
begin
  inherited;
  with TSharedInt(Sender) do
    case GlobalValue of
      0:;
      1:begin
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

(* destroy should FreeAndNil(Global); *)

end.
