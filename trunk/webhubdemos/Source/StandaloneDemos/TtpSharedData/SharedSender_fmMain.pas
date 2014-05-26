unit SharedSender_fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  tpShareB, Vcl.StdCtrls, Vcl.ComCtrls, tpStatus;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    tpStatusBar1: TtpStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  strict private
    { Private declarations }
    FSharedBuf: TtpSharedBuf;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  //SA: AnsiString;
  S8: UTF8String;
{$I shared_buffer.inc}
begin
  if FSharedBuf = nil then
  begin
    FSharedBuf := TtpSharedBuf.CreateNamed(nil, cName, cSize);
    FSharedBuf.Name := 'FSharedBuf';
  end;

  //SA := AnsiString(Copy(Edit1.Text, 1, cSize));
  //FSharedBuf.GlobalAnsiString := SA;
  S8 := UTF8String(Copy(Edit1.Text, 1, cSize));
  FSharedBuf.GlobalUTF8String := S8;

  tpStatusBar1.Status :=  FormatDateTime('hh:nn:ss', Now) +
    ': Wrote to buffer named ' + FSharedBuf.GlobalName;
end;

procedure TForm3.FormCreate(Sender: TObject);
const
  ws2: unicodestring = 'phi omega : '#$03A8' '#$03A9;
begin
  FSharedBuf := nil;
  Edit1.Text := ws2;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FSharedBuf);
end;

end.
