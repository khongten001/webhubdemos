unit htrubic;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls,
  UTPANFRM, ExtCtrls, StdCtrls, TpMemo, DBCtrls, Grids, DBGrids,
  WebScan, WebGrid, WebRubi,
  WdbLink, WdbScan, wbdeGrid, DBTables, TpTable, DB, wbdeSource,
  wbdeForm, UpdateOk, tpAction, WebTypes,   WebLink,
  tpStatus, Toolbar, {}tpCompPanel, rbBase, rbSearch, rbLogic, rbRank,
  rbDS, rbTable, rbBridge_b_bde, wdbSSrc;

(*

The following was done in order to get this demonstration project started:

1. Install Rubicon2 (from www.tamarakca.com) and TwhRubiconSearch
(from www.href.com).

2. Create a BDE Alias called Rubicon2 which points to the
Rubicon examples\data directory, which is where the help.db
table is.

3. Open the examples\exMake.dpr included in Rubicon, compile it
and "make" the words table.  That will put words.db into the
Rubicon2 directory.

*)


type
  TfmHTRUPanel = class(TutParentForm)
    Msg: TwhbdeForm;
    wdsMessage: TwhbdeSource;
    dsMessage: TDataSource;
    qMessage: TQuery;
    tbWords: TtpTable;
    dsWords: TDataSource;
    wdsWords: TwhbdeSource;
    dgWords: TwhbdeGrid;
    wdsContents: TwhbdeSource;
    dgMsgs: TwhbdeGrid;
    dsContents: TDataSource;
    tbMessages: TtpTable;
    tpStatusBar1: TtpStatusBar;
    tpComponentPanel2: TtpComponentPanel;
    Panel1: TPanel;
    DBGrid: TDBGrid;
    DBNavigator: TDBNavigator;
    SearchDictionary: TrbSearch;
    rbWordsBDELink1: TrbWordsBDELink;
    rbTextBDELink1: TrbTextBDELink;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    procedure htRubiconSearchColStart(Sender: TwhScan; var ok: Boolean);
    procedure htRubiconSearchNotify(Sender: TObject;
      Event: TwhScanNotify);
    procedure htRubiconSearchRowStart(Sender: TwhScan; var ok: Boolean);
    procedure htRubiconSearchSendControls(Sender: TObject; var ok: Boolean;
      var Cmd: string);
    procedure MsgExecute(Sender: TObject);
    procedure dgMsgsExecute(Sender: TObject);
    procedure wdsContentsAdjDisplaySet(Sender: TwhdbSourceBase;
      const Value: ShortString);
    procedure dgWordsBeginTable(Sender: TwhbdeGrid; var Value: String);
    procedure dgWordsAfterExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    htRubiconSearch: TwhRubiconSearch;
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  fmHTRUPanel: TfmHTRUPanel;

implementation

{$R *.DFM}

uses
  TypInfo,
  webApp, webInfoU, whMacroAffixes,
  ucOther, ucFile;

//------------------------------------------------------------------------------

procedure TfmHTRUPanel.FormCreate(Sender: TObject);
begin
  inherited;
  htRubiconSearch := nil;
end;

procedure TfmHTRUPanel.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(htRubiconSearch);
end;

function TfmHTRUPanel.Init:Boolean;
begin
  Result:= inherited Init;
  if not result then
    exit;


  htRubiconSearch := TwhRubiconSearch.Create(Self);
  with htRubiconSearch do
  begin
    Name := 'htRubiconSearch';
    DirectCallOk := True;
    //Row = 0
    //RowCount = 0
    Col := 1;
    ColCount := 1;
    PageHeight := 2;
    //PageRows = 0
    //PageRow = 0
    {these do not compile...???}
    //ScanMode := dsByKey;
    //Buttons := [dsFirst, dsPrior, dsNext, dsLast, dsPost, dsCheckBoxes, dsInputFields];
    //ButtonsPos := dsBoth;
    //ButtonMode := bmJump;
    ButtonStyle := bsSubmit;
    ButtonAutoHide := True;
    SearchDictionary := Self.SearchDictionary;
    OnNotify := htRubiconSearchNotify;
    OnColStart := htRubiconSearchColStart;
    OnRowStart := htRubiconSearchRowStart;
    OnSendControls := htRubiconSearchSendControls;
    RecordLimit := 5;
  end;
  RefreshWebActions(Self);


  with tbMessages do
  begin
    try
      DatabaseName := ConcatPath(pWebApp.AppPath,  
        '..\..\..\..\Database\whRubicon\');
      TableName := 'Help';
      Open;  // must be open in order to search.
    except
      on e: exception do
        ShowMessage(e.message);
    end;
  end;

  qMessage.DatabaseName := tbMessages.DatabaseName;
  wdsContents.KeyFieldNames := 'HelpNo';    // was Forum;MsgNo for another table
  tbWords.DatabaseName := tbMessages.DatabaseName;
  wdsWords.KeyFieldNames := 'rbWord';
end;

// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// event handlers for the ThtRubiconSearch component
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //

procedure TfmHTRUPanel.htRubiconSearchColStart(Sender: TwhScan;
  var ok: Boolean);
var
  i:integer;
  a1,a2,a3:string;
begin
  inherited;
  with Sender do
    case col of
    1:begin

      i:=TwhRubiconSearch(Sender).RowKey;
      a1:=inttostr(i);
      if PageHeight<0 then
        a2:='List'
      else
        a2:='Show';
      a3:=inttostr(Row);
      with Response do begin
        SendLine(''
        +MacroStart + 'JUMP|' + MacroStart + 'PAGEID' + MacroEnd +','+
	  Sender.Name+'.'+a2+a3+'|'+a2+' '+a1+MacroEnd
        +', '
        +MacroStart + 'JUMP|DO,Msg.'+a3+'|Row '+a3+MacroEnd
        );
        if (PageHeight>-1) then
          if (PageRow>1) then
            SendLine(', ' + MacroStart + 'JUMP|' + MacroStart + 'PAGEID' + MacroEnd + ','+
	      Sender.Name+'.This'+a3+'|Scroll' + MacroEnd)
          else
            SendLine(', Scroll');
        end;
      //
      with qMessage do begin
        Close;
        Params[0].Value:=i;
        Open;

        if PageHeight>-1 then
          if WebApp.BoolVar['Simple'] then begin
            Response.SendLine('     <B>'+Fields[0].AsString+'  '+Fields[1].AsString+'  '+Fields[7].AsString+'</B>');
            end
          else begin
            Response.SendLine('<br>');
            Response.SendLine('<ul><li>'+Fields[0].AsString
            +'<li>#'+Fields[1].AsString+'  '+Fields[7].AsString
            +'<li>Subj:'+Fields[4].AsString
            +'<li>From:'+Fields[5].AsString
            +'<li>To:'+Fields[6].AsString
            +'</ul>');
            end;
        //
        if (PageHeight<0) then begin
          Fields[2].visible:=PageHeight<0;
          Fields[8].visible:=PageHeight<0;
          Response.SendLine(MacroStart + 'Msg.execute|'+a1+MacroEnd);
          end;
        end;
      end;
    2:begin
      with qMessage do begin
        Fields[2].visible:=PageHeight<0;
        Fields[8].visible:=PageHeight<0;
        end;
      Response.SendLine(MacroStart+'Msg.execute|'+a1+MacroEnd);
      end;
    //
    end;
end;

// -------------------------------------------------------------------------- //

procedure TfmHTRUPanel.htRubiconSearchNotify(Sender: TObject;
  Event: TwhScanNotify);
(* These are all the possible Event constants for this procedure. They are
   defined on TwhScan.
     wsAfterInit
     wsBeforeControls, wsAfterControls
     wsBeforeButtons,  wsAfterButtons
     wsBeforeScan,     wsAfterScan
     wsBeforeRow,      wsAfterRow
     wsBeforeCol,      wsAfterCol
     wsAfterExecute
     wsEmpty
     wsBeforeCHd,      wsAfterCHd
     wsButtonsPrep
*)
begin
  inherited;
  with TwhRubiconSearch(Sender),Response do begin
    SendComment(GetEnumString(TypeInfo(TwhScanNotify),ord(Event)));
    case Event of
//    wsBefore:
    wsBeforeCol:
      //this would be the place to set the TD property to change it for one cell.
      if col=1 then
        td:='<TD ALIGN=RIGHT><FONT COLOR=green>'
      else
        td:='<TD>';
    wsBeforeRow:;
    wsBeforeScan:
      if PageHeight<0 then
        TABLE:=''
      else
        TABLE:='<TABLE BORDER>';
//    wsAfter:
    wsAfterCol:
      if col=1 then
        Send('</FONT>');
    wsAfterRow:;
    wsAfterScan:;
    //
    wsAfterInit:
      SendLine('<BR>');
    wsAfterExecute:;
    //
    wsBeforeButtons:
      SendLine('<hr><Center>');
    wsAfterButtons:
      SendLine('</Center>');
    //
    wsBeforeControls:
      if PageRow=0 then //only when before scan
        SendLine(MacroStart+'htRubiconSearch.Row' + MacroEnd + '/' +
	  MacroStart + 'htRubiconSearch.RowCount' + MacroEnd + ' records.'
        +' <b>'+inttostr(100 * (htRubiconSearch.Row+1) div (htRubiconSearch.RowCount+1))+'%</b>'
        +' Keys:=' + MacroStart + 'htRubiconSearch.RowKeys' + MacroEnd + ' '
        +'<hr>');
    wsAfterControls: begin
      SendLine('<B>Find:</B>' +'<INPUT TYPE=TEXT NAME=htRubiconSearch.SearchValue SIZE=25 MAXSIZE=255 VALUE="' +
        MacroStart + 'htRubiconSearch.SearchValue' + MacroEnd + '">');
      SendLine('<B>Style:</B>'+MacroStart + '<INPUT TYPE=CHECKBOX NAME=Simple VALUE=Yes>Simple');
      //SendLine('<B>Test:</B> ' + MacroStart + 'DropDown1' + MacroEnd); DropDown1 not defined
      end;
    //
    wsEmpty:
      SendHDR('2','No answer.');
      end;
    end;
end;

// -------------------------------------------------------------------------- //

procedure TfmHTRUPanel.htRubiconSearchRowStart(Sender: TwhScan;
  var ok: Boolean);
begin
  inherited;
  with Sender do
    if ((not WebApp.BoolVar['Simple']) and (PageHeight>-1)) then
      ColCount:=2
    else
      ColCount:=1;
end;

// -------------------------------------------------------------------------- //

procedure TfmHTRUPanel.htRubiconSearchSendControls(Sender: TObject;
  var ok: Boolean; var Cmd: string);
begin
  inherited;
  Cmd:='CKB';
end;

// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// event handler for the component named Msg
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
procedure TfmHTRUPanel.MsgExecute(Sender: TObject);
var
  b:boolean;
begin
  inherited;
  with TwhbdeForm(Sender) do begin//TwhbdeForm(Sender).Command
    b:=StrToIntDef(Command,0)>0;
    with WebDataSource.DataSet do begin
      Fields[2].visible:=b;
      Fields[8].visible:=b;
      end;
    end;
end;

// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// event handlers for the Messages grid.
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
procedure TfmHTRUPanel.dgMsgsExecute(Sender: TObject);
begin
  inherited;
  with TwhbdeGrid(Sender) do begin
    WebApp.SendString( 'This table has ' +      {DataSet.}
    IntToStr(TwhbdeGrid(Sender).WebDataSource.RecordCount)
     + ' records.<p>' );
    end;
end;

// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// event handler for webDataSource named wdsContents
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
procedure TfmHTRUPanel.wdsContentsAdjDisplaySet(Sender: TwhdbSourceBase;
  const Value: ShortString);
var
  t,u: TwhScanButtons;
begin
  inherited;
  with dgMsgs do begin
    t:=DataScanOptions;
    u:=[dsbPost, dsbInputFields];  // does not compile. Incompatible types. TDataScanFeatures and TwhScanButtons.
    if (comparetext(value,'Edit')=0)
    or (comparetext(value,'EditMsg')=0)
    then
      t:=t+u
    else
      t:=t-u;
    DataScanOptions:=t;
    end;
end;

procedure TfmHTRUPanel.dgWordsBeginTable(Sender: TwhbdeGrid;
  var Value: String);
var
  a1:string;
begin
  inherited;
  a1:=pWebApp.PageGeneration.AutoPageHeader;
  a1:=MacroStart+a1+MacroEnd;
  Value:=a1+                  // the DO page does not include headers automatically.
         '<center>'+          // add a centering effect.
         '<table border>';    // now put in the usual table tag.
end;

procedure TfmHTRUPanel.dgWordsAfterExecute(Sender: TObject);
var
  a1:string;
begin
  inherited;
  with TwhbdeGrid(Sender) do begin
    a1:=WebApp.PageGeneration.AutoPageFooter;
    a1:=MacroStart+a1+MacroEnd;
    Response.Send('</center>'+        // end the center tag
                   a1);                // end the web page with a standard page footer.
    end;
end;

(*Initialization
  htRubiconSearch := TwhRubiconSearch.Create;
  SearchDictionary := TrbSearch.Create;
  rbWordsBDELink1 := TrbWordsBDELink.Create;
  rbTextBDELink1 := TrbTextBDELink.Create;
Finalization
  htRubiconSearch.Free;
  SearchDictionary.Free;
  rbWordsBDELink1.Free;
  rbTextBDELink1.Free;
  htRubiconSearch := nil;
  SearchDictionary := nil;
  rbWordsBDELink1 := nil;
  rbTextBDELink1 := nil;
*)

(*
  object htRubiconSearch: TwhRubiconSearch
    tpOptions = [tpUpdateOnLoad, tpUpdateOnGet, tpStatusPanel]
    StatusBar = tpStatusBar1
    WebIni = fmWebAppMainForm.WebIniLink
    DirectCallOk = True
    Row = 0
    RowCount = 0
    Col = 1
    ColCount = 1
    PageHeight = 2
    PageRows = 0
    PageRow = 0
    ColStyle = scData
    FixCols = 0
    FixRows = 0
    FixRowHeader = False
    FixColHeader = False
    OverlapScroll = False
    ScanMode = dsByKey
    ControlsPos = dsAbove
    ControlAutoHide = False
    Buttons = [dsFirst, dsPrior, dsNext, dsLast, dsPost, dsCheckBoxes, dsInputFields]
    ButtonsPos = dsBoth
    ButtonMode = bmJump
    ButtonStyle = bsSubmit
    ButtonAutoHide = True
    OnNotify = htRubiconSearchNotify
    OnColStart = htRubiconSearchColStart
    OnRowStart = htRubiconSearchRowStart
    OnSendControls = htRubiconSearchSendControls
    TABLE = '<TABLE BORDER>'
    TR = '<TR>'
    TH = '<TH>'
    TD = '<TD>'
    BR = '<BR>'
    IgnoreSyntaxErrors = False
    SearchDictionary = SearchDictionary
    RecordLimit = 5
    Left = 119
    Top = 140
  end
  object SearchDictionary: TrbSearch
    International = False
    SearchFor = 'WORK'
    SearchLogic = slSmart
    TextLink = rbTextBDELink1
    TimeLimit = 0
    Tokens.Strings = (
      'and'
      'or'
      'not'
      'like'
      'near')
    WordsLink = rbWordsBDELink1
    Left = 14
    Top = 22
  end
  object rbWordsBDELink1: TrbWordsBDELink
    dbiRead = False
    dbiWrite = False
    Table = tbWords
    Transactions = 0
    Left = 46
    Top = 22
  end
  object rbTextBDELink1: TrbTextBDELink
    dbiRead = False
    SubFieldNames.Strings = (
      'Message')
    Table = tbMessages
    Left = 86
    Top = 22
  end
*)

end.
