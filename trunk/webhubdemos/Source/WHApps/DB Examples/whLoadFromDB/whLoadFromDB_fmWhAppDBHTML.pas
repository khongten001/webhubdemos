unit whLoadFromDB_fmWhAppDBHTML;
(*
Copyright (c) 1999-2013 HREF Tools Corp.

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

[ ] Make sure you have an AppID named 'dbhtml' pointed whLoadFromDB config

[ ] Compile this program to create whLoadFromDB.exe

[ ] Run whLoadFromDB.exe

[ ] from your web browser, request ?dbhtml:pgWelcome. You should see some content.

[ ] Enter the demo (?dbhtml:pgEnterDBHTML)

[ ] Using whLoadFromDB.exe, edit one of the database records and post the
    change. Notice that the edit box updates to show the id of the most recently
    posted record.

[ ] Reload content in your web browser.  You will not see the change, yet.

[ ] Click the Update button.

[ ] Reload in your web browser.  You should now see your change.

[ ] Edit something else in the database, perhaps reversing your change.

[ ] Click the Refresh All button.  This is slower but refreshes everything.

[ ] Reload in your web browser.  You should see your change.

Notes updated 2-Feb-2013
*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, Grids, DBGrids, DB, ExtCtrls, StdCtrls, Buttons,
  utPanFrm, updateOk, tpAction,
  toolbar, {}tpCompPanel, restorer;

type
  TfmAppDBHTML = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    tpComponentPanel2: TtpComponentPanel;
    tpToolBar2: TtpToolBar;
    btnPostOnePage: TButton;
    DBMemo1: TDBMemo;
    btnRefresh: TtpToolButton;
    Splitter1: TSplitter;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    EditPageID: TEdit;
    BtnLoad: TtpToolButton;
    procedure BtnLoadClick(Sender: TObject);
    procedure btnPostOnePageClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure Table1AfterPost(DataSet: TDataSet);
  private
    { Private declarations }
    procedure AddPage(const defaultlingvo: String;
      const pageid: String; const attributes: String; const pagecontent: String);
    procedure AddMacros(const defaultlingvo: String;
      const macrocontent: String);
    procedure DatabaseToWebHubStructure;
  public
    { Public declarations }
    function Init: Boolean; override;
    procedure SendBufferedStringFromDB(const Value: string;
      var Handled: Boolean);
    end;

var
  fmAppDBHTML: TfmAppDBHTML;

implementation

{$R *.DFM}

uses
  Variants,
  webApp, htbdeWApp, webInfou, webPHub, whdemo_ViewSource, webRead, htmConst,
  webList, webSplat,
  ucDlgs, whLoadFromDB_dmwhData;

//------------------------------------------------------------------------------

const
  cIDField = 'Identifier';
  cTextField = 'Text';
  cTypeField = 'Type';
  cPageIdentifier = whFolio;
  cWhenToLoadField = 'WhenToLoad';
  cAttributesField = 'Attributes';

function TfmAppDBHTML.Init: Boolean;
begin
  Result:= inherited Init;
  if Result then
  begin
    with TwhbdeApplication(pWebApp) do
    begin
      OnSendBufferedString := SendBufferedStringFromDB;
      DynContentDataSource := DMContent.DataSource1;  // hook up the database
      IDFieldName := cIDField;
      DynContentFieldName := cTextField;
      CacheDbContent := True;  {enable some caching}
    end;
    BtnLoadClick(nil);  // automatically load the database
    DMContent.ClientDataSet1.AfterPost := Table1AfterPost;
  end;
end;

//------------------------------------------------------------------------------

procedure TfmAppDBHTML.DatabaseToWebHubStructure;
var
  aPageID: string;
  aPageContent: string;
  aPageDesc: string;
  aTypeField: string;
begin
  {assume that we are positioned on the database record to load}
  with DMContent.DataSource1.DataSet do
  begin
    aTypeField := FieldByName(cTypeField).asString;
    if (aTypeField = whMacrosTag) then
    begin
      AddMacros('eng', FieldByName(cTextField).AsString);
    end
    else
    if (aTypeField = whFolio) then  // whFolio means whPage
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
    end;
  end;
end;

procedure TfmAppDBHTML.BtnLoadClick(Sender: TObject);
begin
  inherited;
  (* excellent tutorial about TClientDataSet:
  http://edn.embarcadero.com/article/29122
  *)

  if DMContent.DataSource1.DataSet.Active then
  begin
    DMContent.DataSource1.DataSet.Close;
  end
  else
  begin
    try
      DMContent.DataSource1.DataSet.Open;
      // for some reason (bug) the TClientDataSet can have ReadOnly False
      // yet need to have that property SET again to False.
      // Confirmed in Delphi XE3 2-Feb-2013
      if DMContent.ClientDataSet1.ReadOnly then
      begin
        // does not fire
        MsgWarningOk('ClientDataSet1.ReadOnly ... reversing');
        DMContent.ClientDataSet1.ReadOnly := False;
      end;
      if NOT DMContent.ClientDataSet1.CanModify then
      begin
        MsgWarningOk(DMContent.ClientDataSet1.Name + sLineBreak +
          'CanModify = False' + sLineBreak + sLineBreak +
          'Reversing so that you can do data entry now.');
        DMContent.ClientDataSet1.ReadOnly := False;
      end;
    except
      on E: Exception do
      begin
        MsgErrorOk(e.Message);
      end;
    end;

    if DMContent.DataSource1.DataSet.Active then
    begin
      DMContent.DataSource1.DataSet.First;
      while not DMContent.DataSource1.DataSet.EOF do
      begin
        DatabaseToWebHubStructure;
        DMContent.DataSource1.DataSet.Next;
      end;
    end;
  end;
  WebMessage('');
end;

// -----------------------------------------------------------------------------

procedure TfmAppDBHTML.Table1AfterPost(DataSet: TDataSet);
begin
  inherited;
  EditPageID.text := DataSet.fieldByName(cIDField).asString;
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
  ms := nil;
  try
    ms := TMemoryStream.Create;

    S := whTekoBegin + ' ' + clingvo + cEq + defaultlingvo + cEq + cGT +
      sLineBreak +
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
  finally
    FreeAndNil(ms);
  end;
end;

procedure TfmAppDBHTML.AddMacros(const defaultlingvo: String;
  const macrocontent: String);
var
  ms: TMemoryStream;
  S: String;
const
  cEq = '=';
begin
  ms := nil;
  try
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
  finally
    FreeAndNil(ms);
  end;
end;

procedure TfmAppDBHTML.btnPostOnePageClick(Sender: TObject);
var
  aTekeroID: String;  // a part of a teko file (page or droplet)
  aWhenToLoad: String;
begin
  inherited;
  if DMContent.DataSource1.DataSet.Active then
  begin
    DMContent.DataSource1.DataSet.Close;
  end
  else
  begin
    DMContent.DataSource1.DataSet.Open;

    aTekeroID := EditPageID.text;
    with DMContent.DataSource1.DataSet do
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

procedure TfmAppDBHTML.SendBufferedStringFromDB(const Value: string;
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
    {if we already know that this Value cannot be found in our database}
    if (NOT CacheDbContent) or (pos('|'+uppercase(Value)+'|',CacheDbFail)=0)
    then
    begin

      {locate based on Value}
      if DMContent.DataSource1.DataSet.Locate(IDFieldName, VarArrayOf([Value]), []) then
      begin
        {we found our match; grab the page/droplet content now}
        with DMContent.DataSource1.DataSet do
        begin
          a1 := FieldByName(cTextField).asString;
          aWhenToLoad := FieldByname(cWhenToLoadField).asString;
        end;

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
end;

end.
