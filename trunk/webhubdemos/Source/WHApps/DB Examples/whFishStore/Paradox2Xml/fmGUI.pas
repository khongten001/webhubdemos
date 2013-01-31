unit fmGUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Bde.DBTables,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, Vcl.ExtCtrls, tpCompPanel,
  Vcl.ActnList, System.Actions, Vcl.StdActns, Vcl.Menus;

type
  TForm3 = class(TForm)
    ClientDataSet1: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    Table1: TTable;
    tpComponentPanel1: TtpComponentPanel;
    Panel1: TPanel;
    LabeledEditParadox: TLabeledEdit;
    Button1: TButton;
    LabeledEditXML: TLabeledEdit;
    FileOpenDialog1: TFileOpenDialog;
    Button2: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    ActionList1: TActionList;
    FileExit1: TFileExit;
    ActionConvert: TAction;
    ActionAbout: TAction;
    Exit1: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActionConvertExecute(Sender: TObject);
    procedure ActionAboutExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses
  ucString, ucDlgs;

procedure TForm3.ActionAboutExecute(Sender: TObject);
begin
  MsgInfoOk('Convert 1 Paradox table at a time to the XML format usable by ' +
    'TClientDataSet' + sLineBreak + sLineBreak +
    'Delphi source is included in webhubdemos project' + sLineBreak +
    'Essential: ClientDataSet1.SaveToFile(LabeledEditXML.Text, dfXml)' +
    sLineBreak + sLineBreak +
    'Compiled with Delphi XE3 update 1' + sLineBreak +
    'http://www.href.com/techhelp' //+ sLineBreak + sLineBreak +
    );
end;

procedure TForm3.ActionConvertExecute(Sender: TObject);
begin
//http://docwiki.embarcadero.com/Libraries/XE3/en/Datasnap.DBClient.TDataPacketFormat
  ClientDataSet1.SaveToFile(LabeledEditXML.Text, dfXml);
  if FileExists(LabeledEditXML.Text) then
    MsgInfoOk('Done')
  else
    MsgErrorOk('Failed.' + sLineBreak + LabeledEditXML.Text + sLineBreak +
      'does not exist.');
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  if LabeledEditParadox.Text <> '' then
    FileOpenDialog1.DefaultFolder := ExtractFilepath(LabeledEditParadox.Text);

  if FileOpenDialog1.Execute then
  begin
    LabeledEditParadox.Text := FileOpenDialog1.FileName;
    Table1.Close;
    Table1.DatabaseName := ExtractFilePath(FileOpenDialog1.FileName);
    Table1.TableName := LeftOfS('.', ExtractFileName(FileOpenDialog1.FileName));
    Table1.Open;
    MsgInfoOk(IntToStr(Table1.RecordCount) + ' records in ' + Table1.TableName);
    if LabeledEditXML.Text = '' then
      LabeledEditXML.Text := ChangeFileExt(LabeledEditParadox.Text, '.xml');
  end
  else
    LabeledEditXML.Text := '';
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Self.Height := 280;
end;

end.
