unit whLoadFromDB_fmWhAppDBHTML;
(*
Copyright (c) 1999-2004 HREF Tools Corp.

Permission is hereby granted, on 04-Jun-2004, free of charge, to any person
obtaining a copy of this file (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*)

(*
Guide to experimentation.

Requires: whcontent table, or equivalent, and WebHub v2.037+.

[ ] Make sure you have an AppID named DBHTML pointed to the whLoadFromDB.INI file.

[ ] Compile this program to create whLoadFromDB.exe

[ ] Run whLoadFromDB.exe

[ ] from your web browser, request ?DBHTML:pgWelcome. You should see some content.

[ ] Enter the demo (?DBHTML:pgEnterDBHTML)

[ ] Using whLoadFromDB.exe, edit one of the database records and post the
    change. Notice that the edit box updates to show the id of the most recently
    posted record.

[ ] Reload content in your web browser.  You will not see the change, yet.

[ ] Click the Update button.

[ ] Reload in your web browser.  You should now see your change.

[ ] Edit something else in the database, perhaps reversing your change.

[ ] Click the Refresh All button.  This is slower but refreshes everything.

[ ] Reload in your web browser.  You should see your change.

Notes updated 29-Jun-2004
*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UTPANFRM, ExtCtrls, StdCtrls, UpdateOk, tpAction, IniLink,
  Toolbar, {}tpCompPanel, Restorer, DBCtrls, Grids, DBGrids, Db, DBTables,
  Buttons;

type
  TfmAppDBHTML = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    tpComponentPanel2: TtpComponentPanel;
    Table1: TTable;
    DataSource1: TDataSource;
    EditPath: TEdit;
    tpToolBar2: TtpToolBar;
    EditPageID: TEdit;
    btnPostOnePage: TButton;
    DBMemo1: TDBMemo;
    BtnLoad: TButton;
    btnRefresh: TtpToolButton;
    Splitter1: TSplitter;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    procedure BtnLoadClick(Sender: TObject);
    procedure btnPostOnePageClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure Table1AfterPost(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fQuery: TQuery;
    procedure AddPage(const defaultlingvo: String;
      const pageid: String; const attributes: String; const pagecontent: String);
    procedure AddMacros(const defaultlingvo: String;
      const macrocontent: String);
    procedure DatabaseToWebHubStructure;
  public
    { Public declarations }
    function Init: Boolean; override;
    procedure SendBufferedStringFromDB(Const Value: String; var Handled: Boolean);
    end;

var
  fmAppDBHTML: TfmAppDBHTML;

implementation

{$R *.DFM}

uses
  webApp, htbdeWApp, webInfou, webPHub, whdemo_ViewSource, webRead, htmConst,
  webList,
  ucDlgs;

//------------------------------------------------------------------------------

const
  cTablename = 'whcontent.db';
  cIDField = 'Identifier';
  cTextField = 'Text';
  cTypeField = 'Type';
  cPageIdentifier = whFolio;
  cWhenToLoadField = 'WhenToLoad';
  cAttributesField = 'Attributes';

procedure TfmAppDBHTML.FormCreate(Sender: TObject);
begin
  inherited;
  FQuery := nil;
end;

function TfmAppDBHTML.Init: Boolean;
begin
  Result:= inherited Init;
  if not result then
    Exit;
  with TwhbdeApplication(pWebApp) do
  begin
    OnSendBufferedString := SendBufferedStringFromDB;
    DynContentDataSource := DataSource1;  // hook up the database
    IDFieldName := cIDField;
    DynContentFieldName := cTextField;
    CacheDbContent := True;  {enable some caching}
  end;
  fQuery := TQuery.Create(Self);
  BtnLoadClick(nil);  // automatically load the database
end;

procedure TfmAppDBHTML.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(fQuery);
end;

//------------------------------------------------------------------------------

procedure TfmAppDBHTML.DatabaseToWebHubStructure;
var
  aPageID: String;
  aPageContent: String;
  aPageDesc: String;
begin
  {assume that we are positioned on the database record to load}
  with Table1 do
  begin
    if (FieldByName(cTypeField).asString = whMacrosTag) then
    begin
      AddMacros('eng', FieldByName(cTextField).AsString);
    end
    else
    if (FieldByName(cTypeField).asString = whFolio) then  // whFolio means whPage
    begin
      aPageID := FieldByName(cIDField).asString;
      if FieldByName(cWhenToLoadField).asString = 'Preload' then
      begin
        aPageContent := FieldByName(cTextField).AsString;
        AddPage('eng', aPageID, FieldByName(cAttributesField).asString,
          aPageContent);
      end
      else
      begin
        aPageDesc := Copy(FieldByName(cAttributesField).asString, 7,
          Length(FieldByName(cAttributesField).asString) - 7);
        // add to the app's pages list.
        pWebApp.Pages.Add(aPageID+'='+aPageID+',,,' + aPageDesc);
      end;
      // note that the page sections will set themselves up when
      // page is requested
    end;
  end;
end;

procedure TfmAppDBHTML.BtnLoadClick(Sender: TObject);
begin
  inherited;
  if editPath.text = '' then
  begin
    { The path to the database is set here, using a routine that is shared by
      many of the demos. You could change how that's done for your own project.}
    editPath.text := getHtDemoDataRoot + 'whLoadFromDB\';
  end;

  fQuery.DatabaseName := editPath.Text;

  with pWebApp, table1 do
  begin
    Close;
    TableName := cTablename;
    if DatabaseName <> editPath.text then
    begin
      DatabaseName := editPath.text;
      try
        Open;
      except
        on e: exception do
        begin
          DatabaseName := '';
          ShowMessage(e.Message + 'Fix the path to the database and reload.');
          Exit;
        end;
      end;
    end
    else
    begin
      Open;
    end;
    //
    First;
    while not EOF do
    begin
      DatabaseToWebHubStructure;
      Next;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfmAppDBHTML.Table1AfterPost(DataSet: TDataSet);
begin
  inherited;
  EditPageID.text:=DataSet.fieldByName(cIDField).asString;
end;

// -----------------------------------------------------------------------------

procedure TfmAppDBHTML.AddPage(const defaultlingvo: String;
  const pageid: String; const attributes: String; const pagecontent: String);
var
  ms: TMemoryStream;
  S: String;
const
  cEq = '=';
begin
  ms := TMemoryStream.Create;

  S := whTekoBegin + ' ' + clingvo + cEq + defaultlingvo + cEq + cGT + sLineBreak +
    whFolioBegin + ' ' + cpageid + cEq + '"' + pageid + '" ' +
    attributes + cGT + sLineBreak +
    pagecontent + sLineBreak +
    whFolioEnd + sLineBreak +
    whTekoEnd;

  ms.SetSize(Length(S));
  ms.Seek(0, soFromBeginning);
  ms.Write(S[1], Length(S));

  WebRead.ReadChunksFromStream(pWebApp, ms,
    'Expression #' + IntToStr(GetTickCount), 'Temp', '',
     pWebApp.PageGeneration, pWebApp.Syntax0100,
     pWebApp.Tekeros, pWebApp.Pages, pWebApp.Macros,
     pWebApp.Debug.PageErrors, True, pWebApp.ProjectSyntax);

  ms.Free;
end;

procedure TfmAppDBHTML.AddMacros(const defaultlingvo: String;
  const macrocontent: String);
var
  ms: TMemoryStream;
  S: String;
const
  cEq = '=';
begin
  ms := TMemoryStream.Create;

  S := whTekoBegin + ' ' + clingvo + cEq + defaultlingvo + cEq + cGT + sLineBreak +
    whMacrosTagBegin + cGT + sLineBreak +
    macrocontent + sLineBreak +
    whMacrosTagEnd + sLineBreak +
    whTekoEnd;

  ms.SetSize(Length(S));
  ms.Seek(0, soFromBeginning);
  ms.Write(S[1], Length(S));

  WebRead.ReadChunksFromStream(pWebApp, ms,
    'Expression #' + IntToStr(GetTickCount), 'Temp', '',
     pWebApp.PageGeneration, pWebApp.Syntax0100,
     pWebApp.Tekeros, pWebApp.Pages, pWebApp.Macros,
     pWebApp.Debug.PageErrors, True, pWebApp.ProjectSyntax);

  ms.Free;
end;

procedure TfmAppDBHTML.btnPostOnePageClick(Sender: TObject);
var
  aTekeroID: String;  // a part of a teko file (page or droplet)
  aWhenToLoad: String;
begin
  inherited;
  if NOT Table1.Active then
  begin
    msgErrorOk('Load the database, first.');
    Exit;
  end;

  aTekeroID := EditPageID.text;
  with table1 do
  begin
    if Locate(cIDField, aTekeroID, []) then
    begin
      DatabaseToWebHubStructure;
      aWhenToLoad := FieldByName(cWhenToLoadField).asString;
      if (aWhenToLoad <> 'NoCache') and (aWhenToLoad <> 'n/a') then
      begin
        with pWebApp do
          if (Tekero[aTekeroID]<>'') or // already cached
             (FieldByName(cWhenToLoadField).asString = 'PreLoad') then
          begin
             Tekero[aTekeroID]:=FieldByName(cTextField).asString;
          end;
      end;
    end;
  end;
end;

procedure TfmAppDBHTML.btnRefreshClick(Sender: TObject);
begin
  inherited;
  with pWebApp do
  begin
    Refresh;  // reload whatever might come from INI or HTML
    BtnLoadClick(Sender);
  end;
end;

procedure TfmAppDBHTML.SendBufferedStringFromDB(Const Value: String;
  var Handled: Boolean);
var
  a1: String;
  aWhenToLoad: String;
  t: TwhList;
begin

  {Warning! PageIDs will always be in UPPERCASE so the database should put
   their identifiers in UPPERCASE as well. Droplets, on the other hand, may be
   in lowercase or mixed case.  v2.037}

  {Note! Implementing this event effectively bypasses the logic in the
   SendBufferedString method in htbdeWApp.pas, which works only with TTable
   objects and caches based purely on the CacheDbContent boolean property. The
   approach shown here is much more flexible.}

  with TwhbdeApplication(pWebApp) do
  begin
    {exit if we already know that this Value cannot be found in our database}
    if CacheDbContent and (pos('|'+uppercase(Value)+'|',CacheDbFail)>0) then
      Exit;

    {define the query statement to select based on Value}
    fQuery.SQL.Text := 'Select * from "' + cTablename + '" where (' +
      IDFieldName + '=''' + Value + ''')';
    fQuery.Open;

    if (fQuery.RecordCount = 1) then
    begin
      {we found our match; grab the page/droplet content now}
      a1 := fQuery.FieldByName(cTextField).asString;
      aWhenToLoad := fQuery.FieldByname(cWhenToLoadField).asString;

      {close the query before calling SendString, otherwise fQuery may be
       referenced recursively, which is not allowed for. }
      fQuery.Close;

      {output the content now}
      {Response.SendPChar(pchar(a1)); use SendPChar to ensure zero further expansion}
      SendString(a1);         // SendString expands any macros contained within a1

      {signal that we have handled this Value}
      Handled := True;

      {consider caching the content for next time}
      if aWhenToLoad <> 'NoCache' then
      begin
        {Load the page or droplet content into memory. Both page and droplet
         content are stored in the pWebApp.Droplets array.}
        t:=TwhList.create;
        t.text:=a1;
        Tekeros.AddObject(Value+'='+Value,t);
        {Reminder: do NOT free t. WebHub will free it when appropriate.}
      end;
    end
    else
    begin
      {add Value to the list so we don't search for it next time around.}
      CacheDbFail:=CacheDbFail+uppercase(Value)+'|';
      CacheDbFailCount := CacheDbFailCount + 1;
    end;
  end;
end;

end.