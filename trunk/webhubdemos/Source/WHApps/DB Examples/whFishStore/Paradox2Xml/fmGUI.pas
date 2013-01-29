unit fmGUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Bde.DBTables,
  Datasnap.Provider, Data.DB, Datasnap.DBClient;

type
  TForm3 = class(TForm)
    ClientDataSet1: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    Table1: TTable;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
//http://docwiki.embarcadero.com/Libraries/XE3/en/Datasnap.DBClient.TDataPacketFormat
  ClientDataSet1.SaveToFile('D:\Projects\webhubdemos\Live\Database\whFishStore\fishcost_emb.xml',dfXml);
end;

end.
