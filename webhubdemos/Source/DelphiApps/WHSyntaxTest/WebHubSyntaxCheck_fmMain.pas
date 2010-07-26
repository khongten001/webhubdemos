unit WebHubSyntaxCheck_fmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons,
  webApp, htWebApp, webInfoU, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    BitBtnCancel: TBitBtn;
    Button1: TButton;
    Panel2: TPanel;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FlagContinue: Boolean;
    AnAppObject: TwhApplication;
    ACentralInfoObject: TwhCentralInfo;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  ucVers, ucDlgs;


{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.Caption := Format('%s v%s', [Self.Caption, GetVersionDigits(False)]);
  BitBtnCancel.Visible := False;
  ACentralInfoObject := TwhCentralInfo.Create(Self);
  AnAppObject := TwhApplication.Create(Self);
  AnAppObject.Name := 'WebApp';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ACentralInfoObject);
  FreeAndNil(anAppObject);
end;

procedure TForm1.BitBtnCancelClick(Sender: TObject);
begin
  FlagContinue := False;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  x,y: Integer;
  node: TTreeNode;
  ConfigFilespec: string;
begin
  if NOT ucDlgs.AskQuestionYesNo('Do you want to scan all WebHub AppIDs ' +
    'to report all syntax errors?') then
    Exit;

  FlagContinue := True;
  pWebApp.AssertCentralInfo;
  pWebApp.CentralInfo.CheckLisc;
  pWebApp.CentralInfo.Refresh;  // should reload list of AppIDs from disk
  BitBtnCancel.Visible := True;

  TreeView1.Items.Clear;
  Application.ProcessMessages;

  for x := 0 to High(pWebApp.CentralInfo.CentralApps.List) do
  begin
    if NOT FlagContinue then break;

    node := TreeView1.Items.AddChild(nil,
      pWebApp.CentralInfo.CentralApps.List[x].AppID);
    ConfigFilespec := pWebApp.CentralInfo.CentralApps.List[x].ConfigFolder +
      pWebApp.CentralInfo.CentralApps.List[x].ConfigFilename;

    if FileExists(ConfigFilespec) then
    begin
      pWebApp.AppID := pWebApp.CentralInfo.CentralApps.List[x].AppID;
      pWebApp.Refresh;
      for y := 0 to Pred(pWebApp.Debug.RefreshErrors.Count) do
        TreeView1.Items.AddChild(node, pWebApp.Debug.RefreshErrors[y]);
    end
    else
    begin
      TreeView1.Items.AddChild(node, Format('Config file not found: %s',
        [ConfigFilespec]));
    end;
    TreeView1.Repaint;
    Application.ProcessMessages;
  end;
  BitBtnCancel.Visible := False;
end;

end.
