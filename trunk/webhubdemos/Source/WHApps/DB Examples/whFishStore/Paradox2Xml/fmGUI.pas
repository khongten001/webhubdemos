unit fmGUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Bde.DBTables,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, Vcl.ExtCtrls, tpCompPanel,
  Vcl.ActnList, System.Actions, Vcl.StdActns, Vcl.Menus, Vcl.Grids, Vcl.DBGrids,
  Vcl.DBCtrls, Vcl.ComCtrls;

type
  TForm3 = class(TForm)
    ClientDataSetTarget: TClientDataSet;
    DataSetProviderTarget: TDataSetProvider;
    TableSource: TTable;
    tpComponentPanel1: TtpComponentPanel;
    Panel1: TPanel;
    FileOpenDialog1: TFileOpenDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    ActionList1: TActionList;
    FileExit1: TFileExit;
    ActionConvert: TAction;
    ActionAbout: TAction;
    Exit1: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    LabeledEditParadox: TLabeledEdit;
    Button2: TButton;
    LabeledEditXML: TLabeledEdit;
    Button1: TButton;
    TabSheet2: TTabSheet;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    TabSheet3: TTabSheet;
    DataSourceTarget: TDataSource;
    DBGridTarget: TDBGrid;
    DBNavigatorTarget: TDBNavigator;
    LabelTarget: TLabel;
    LabelSource: TLabel;
    CheckBox1: TCheckBox;
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
  // if you do not have ucDlgs (it is in CodeCentral) then change MsgInfo to
  // ShowMessage
  ucDlgs;

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
  ClientDataSetTarget.SaveToFile(LabeledEditXML.Text, dfXml);
  if FileExists(LabeledEditXML.Text) then
  begin
    if Checkbox1.Checked then
      ClientDataSetTarget.SaveToFile(ChangeFileExt(LabeledEditXML.Text, '.CDS'),
        dfBinary);
    MsgInfoOk('Done')
  end
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
    TableSource.Close;
    TableSource.DatabaseName := ExtractFilePath(FileOpenDialog1.FileName);
    TableSource.TableName := ChangeFileExt(ExtractFileName(
      FileOpenDialog1.FileName), '.DB');
    TableSource.Open;
    LabelSource.Caption := TableSource.DatabaseName + '   ' +
      TableSource.TableName;
    ClientDataSetTarget.Open;  // REQUIRED. otherwise export does nothing.
    LabelTarget.Caption :=
      TClientDataSet(DBGridTarget.DataSource.DataSet).ProviderName;
    MsgInfoOk(IntToStr(TableSource.RecordCount) + ' records in ' +
      TableSource.TableName);
    if ClientDataSetTarget.RecordCount = 0 then
      MsgErrorOk('Empty target');

    if LabeledEditXML.Text = '' then
      LabeledEditXML.Text := ChangeFileExt(LabeledEditParadox.Text, '.xml');
  end
  else
    LabeledEditXML.Text := '';
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Self.Height := 340;
  PageControl1.ActivePage := TabSheet1;
end;

end.
