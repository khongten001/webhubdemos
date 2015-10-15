unit BDETable_to_NexusTable_fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,
  tpTable,
  nxdb, nxseAllEngines,
  nxllComponent, nxsdServerEngine, nxsrServerEngine, nxdbDatabaseMapper,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    nxTable2: TnxTable;
    nxDatabase2: TnxDatabase;
    Button1: TButton;
    nxServerEngine1: TnxServerEngine;
    nxSession1: TnxSession;
    LabeledEditPdx: TLabeledEdit;
    LabeledEditNx: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    TablePdx: TtpTable;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
  S1: string;
begin
  TablePdx.TableFullName := LabeledEditPdx.Text;
  S1 := ExtractFilename(S1);

  nxDatabase2.AliasPath := LabeledEditNx.Text;

  nxTable2.TableName := Copy(S1, 1, Pos('.DB', S1)-1);

  nxDataBase2.Connected := True;

  TablePdx.Open;

  nxTable2.Close;

  nxTable2.FieldDefs.Clear;

  nxTable2.FieldDefs.Assign(TablePdx.FieldDefs);

  nxTable2.IndexDefs.Clear;

  nxTable2.IndexDefs.Assign(TablePdx.IndexDefs);

  for I := 0 to nxTable2.Indexdefs.Count-1 do
  begin
    if nxTable2.Indexdefs.Items[i].Name='' then
      nxTable2.Indexdefs.Items[i].Name:='ndxPrimary';
  end;

  nxTable2.CreateTable;
  nxTable2.Open;
  TablePdx.First;

  while not TablePdx.eof do
  begin

   nxTable2.Insert;

   for i:=0 to Pred(TablePdx.FieldCount) do
     nxTable2.Fields[i].Assign(TablePdx.Fields[i]);

   nxTable2.Post;

   TablePdx.next;

  end;

  nxTable2.Close;
  TablePdx.Close;

  ShowMessage('Done');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TablePdx := TtpTable.Create(Self);
  TablePdx.Name := 'TablePdx';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(TablePdx);
end;

end.
