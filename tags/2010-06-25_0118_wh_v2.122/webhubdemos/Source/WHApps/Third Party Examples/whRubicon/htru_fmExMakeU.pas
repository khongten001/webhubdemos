unit htru_fmExMakeU;

{*********************************************************}
{* copied by HREF Tools Corp., with permission, from:    *}
{* Rubicon\examples\bde\ExMakeU.pas                      *}
{* for use in the WebHub Rubicon demo "htru"             *}
{*********************************************************}


{*********************************************************}
{*                   EXMAKEU.PAS 2.2.1                   *}
{*     Copyright (c) Tamarack Associates 1996 - 2003.    *}
{*                 All rights reserved.                  *}
{*********************************************************}

interface

{$I hrefdefines.inc}

uses
{$IFDEF LINUX}
  QForms, QControls, QDialogs, QGraphics, QExtCtrls, QStdCtrls,
{$ELSE}
  Forms, Controls, Dialogs, Graphics, ExtCtrls, StdCtrls,
{$ENDIF}
  SysUtils, Classes,
  toolbar, {}tpCompPanel, utPanFrm, tpMemo, restorer, Tabs, rbPrgDlg, rbBase, rbCache,
  rbAccept, rbMake, rbDS, rbTable, rbBDE, DB, DBTables, Grids, DBGrids,
  DBCtrls;

type
  TfmRubiconMakeBDE = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    Button1: TButton;
    CheckBox1: TCheckBox;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    Table1: TTable;
    Table2: TTable;
    rbMakeTextBDELink1: TrbMakeTextBDELink;
    rbMakeWordsBDELink1: TrbMakeWordsBDELink;
    rbMake1: TrbMake;
    rbAccept1: TrbAccept;
    rbCache1: TrbCache;
    rbProgressDialog1: TrbProgressDialog;
    tpComponentPanel1: TtpComponentPanel;
    TabSet1: TTabSet;
    procedure Button1Click(Sender: TObject);
    procedure TabSet1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function rbMake1AcceptWord(Sender: TObject; const Word: String): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  fmRubiconMakeBDE: TfmRubiconMakeBDE;

implementation

{$R *.dfm}


uses
  ucFile, webApp;

{ TfmAppPanel }

function TfmRubiconMakeBDE.Init: Boolean;
begin
  Result := inherited Init;
  if not Result then
    Exit;
  Table1.DatabaseName := ConcatPath(pWebApp.AppPath,
    '..\..\..\..\Database\whRubicon\');
  Table2.DatabaseName := Table1.DatabaseName;
end;


procedure TfmRubiconMakeBDE.TabSet1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
 AllowChange := True;
 case NewTab of
  0 : DBGrid1.DataSource := DataSource1;
  1 : DBGrid1.DataSource := DataSource2
 end;
 DBNavigator1.DataSource := DBGrid1.DataSource
end;

procedure TfmRubiconMakeBDE.DBGrid1DblClick(Sender: TObject);
begin
 DBGrid1.SelectedField.ReadOnly := DBGrid1.ReadOnly;
 //Form2.ShowMemo(DBGrid1.DataSource,DBGrid1.SelectedField)
end;

procedure TfmRubiconMakeBDE.Button1Click(Sender: TObject);
begin
 if rbMakeWordsBDELink1.Transactions > 0 then
  Table1.Database.TransIsolation := tiDirtyRead;
 if CheckBox1.Checked then
  rbMake1.SegmentSize := 352
 else
  rbMake1.SegmentSize := 0; {* Resets SegmentSize to High(LongInt) *}
 rbMake1.Execute
end;

procedure TfmRubiconMakeBDE.FormCreate(Sender: TObject);
begin
// Application.Icon := Icon;
end;

function TfmRubiconMakeBDE.rbMake1AcceptWord(Sender: TObject; const Word: String) : Boolean;
begin
 rbAccept1.Word := Word;
 Result := rbAccept1.Accept
end;


end.
