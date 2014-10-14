unit Test_Client_fmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses DPrefix_Client_uInitialize;

procedure TForm1.Button1Click(Sender: TObject);
var
  ErrorText: string;
begin
  if Client_Init(ErrorText) then
  begin
    Label1.Text := 'DPR_API_Versions_Rec.hdr.Version=' +
      Format('%2.1f', [DPR_API_Versions_Rec.hdr.Version]);
    Label2.Text := 'DPR_API_Versions_Rec.WebAppAPISpec_Version=' +
      IntToStr(DPR_API_Versions_Rec.WebAppAPISpec_Version);
    Label3.Text := 'DPR_API_Versions_Rec.ImageList_Version=' +
      IntToStr(DPR_API_Versions_Rec.ImageList_Version);
    Label4.Text := 'DPR_API_Versions_Rec.LingvoList_Version=' +
      IntToStr(DPR_API_Versions_Rec.LingvoList_Version);
    Label5.Text := 'DPR_API_Versions_Rec.TradukoList_Version=' +
      IntToStr(DPR_API_Versions_Rec.TradukoList_Version);
    Label6.Text := 'Wecome file = ' +
      DPR_API_ImageList_Rec.ImageList[0].LocalFilespec;
    ShowMessage('good');
  end
  else
    ShowMessage(ErrorText);
end;

end.
