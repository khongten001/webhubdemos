unit SharedReceiver_fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, System.Actions, Vcl.ActnList, Vcl.Touch.GestureMgr,
  tpShareB, Vcl.Buttons, Vcl.StdActns;

type
  TForm4 = class(TForm)
    AppBar: TPanel;
    CloseButton: TImage;
    ActionList1: TActionList;
    Action1: TAction;
    GestureManager1: TGestureManager;
    Label1: TLabel;
    Button1: TButton;
    FileExit1: TFileExit;
    BitBtn1: TBitBtn;
    procedure CloseButtonClick(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  strict private
    { Private declarations }
    FSharedBuf: TtpSharedBuf;
    procedure AppBarResize;
    procedure AppBarShow(mode: integer);
    procedure BufferChanged(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

const
  AppBarHeight = 75;

procedure TForm4.AppBarResize;
begin
  AppBar.SetBounds(0, AppBar.Parent.Height - AppBarHeight,
    AppBar.Parent.Width, AppBarHeight);
end;

procedure TForm4.AppBarShow(mode: integer);
begin
  if mode = -1 then // Toggle
    mode := integer(not AppBar.Visible );

  if mode = 0 then
    AppBar.Visible := False
  else
  begin
    AppBar.Visible := True;
    AppBar.BringToFront;
  end;
end;

procedure TForm4.BufferChanged(Sender: TObject);
var
  //SA: AnsiString;
  S8: UTF8String;
begin
  S8 := FSharedBuf.GlobalUTF8String;
  Label1.Caption := string(S8);
end;

procedure TForm4.Button1Click(Sender: TObject);
{$I shared_buffer.inc}
begin
  if FSharedBuf = nil then
  begin
    FSharedBuf := TtpSharedBuf.CreateNamed(nil, cName, cSize);
    FSharedBuf.Name := 'FSharedBuf';
    FSharedBuf.OnChange := BufferChanged;
  end;
end;

procedure TForm4.Action1Execute(Sender: TObject);
begin
  AppBarShow(-1);
end;

procedure TForm4.CloseButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin

  FSharedBuf := nil;

  { quickly make this Metropolis UI form easier to work with! }
  Self.Width := 600;
  Self.Height := 400;
  Self.Top := 100;
  Self.Left := 100;
  Self.Caption := 'Shared Receiver';
  Label1.Caption := Self.Caption;
end;

procedure TForm4.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FSharedBuf);
end;

procedure TForm4.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  AppBarShow(0);
end;

procedure TForm4.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    AppBarShow(-1)
  else
    AppBarShow(0);
end;

procedure TForm4.FormResize(Sender: TObject);
begin
  AppBarResize;
end;

end.
