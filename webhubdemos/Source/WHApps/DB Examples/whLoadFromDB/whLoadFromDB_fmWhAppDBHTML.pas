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
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  DBCtrls, Grids, DBGrids, DB, ExtCtrls, StdCtrls, Buttons,
  utPanFrm, updateOk, tpAction, toolbar, tpCompPanel,
  webCall, webSend;

type
  TfmAppDBHTML = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    tpComponentPanel2: TtpComponentPanel;
    tpToolBar2: TtpToolBar;
    btnPostOnePage: TButton;
    DBMemo1: TDBMemo;
    Splitter1: TSplitter;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    EditPageID: TEdit;
    BtnLoad: TtpToolButton;
    procedure BtnLoadClick(Sender: TObject);
    procedure btnPostOnePageClick(Sender: TObject);
    procedure Table1AfterPost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
    procedure NoteBadPageID(Sender: TwhConnection;
      const ADesiredPageID: string; var bContinue: Boolean);
    function RestorerActiveHere: Boolean; override;
    end;

var
  fmAppDBHTML: TfmAppDBHTML;

implementation

{$R *.DFM}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  Variants,
  ucDlgs, ucCodeSiteInterface,
  webApp, whLoadFromDB_dmwhData;

//------------------------------------------------------------------------------

function TfmAppDBHTML.Init: Boolean;
begin
  Result:= inherited Init;
  if Result then
  begin
    pConnection.OnBadPageID := NoteBadPageID;
    (* Vital! Do not have the DB controls active while surfers are causing the
       underlying TClientDataSet to change records, etc. That causes
       synchronization errors with the main thread and the EXE will hang. *)
    DBGrid1.Enabled := False;
    DBGrid1.DataSource := nil;
    DBMemo1.DataSource := nil;
    DBNavigator1.DataSource := nil;
  end;
end;

function TfmAppDBHTML.RestorerActiveHere: Boolean;
begin
  Result := False;
end;

//------------------------------------------------------------------------------

procedure TfmAppDBHTML.BtnLoadClick(Sender: TObject);
const cFn = 'BtnLoadClick';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  if Assigned(DBGrid1.DataSource) then
  begin
    DBGrid1.DataSource := nil;
    DBMemo1.DataSource := nil;
    DBNavigator1.DataSource := nil;
    DMContent.ClientDataSet1.AfterPost := nil;
  end
  else
  begin
    MsgWarningOk(
      'Please do not allow surfers to use the app while you are editing');
    DBGrid1.Enabled := True;
    DBGrid1.DataSource := DMContent.DataSource1;
    DBMemo1.Enabled := True;
    DBMemo1.DataSource := DMContent.DataSource1;
    DBNavigator1.Enabled := True;
    DBNavigator1.DataSource := DMContent.DataSource1;
    DMContent.ClientDataSet1.AfterPost := Table1AfterPost;
    if NOT DMContent.DataSource1.DataSet.Active then
    begin
      DMContent.DataSource1.DataSet.Open;
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

// -----------------------------------------------------------------------------

procedure TfmAppDBHTML.Table1AfterPost(DataSet: TDataSet);
begin
  inherited;
  EditPageID.text := DataSet.fieldByName(cIDField).asString;
end;

// -----------------------------------------------------------------------------

procedure TfmAppDBHTML.btnPostOnePageClick(Sender: TObject);
var
  aTekeroID: string;  // a part of a teko file (page or droplet)
  aWhenToLoad: string;
begin
  inherited;
  if NOT DMContent.DataSource1.DataSet.Active then
    DMContent.DataSource1.DataSet.Open;

  { TO-DO: test this in isolateion }

  aTekeroID := EditPageID.text;
  with DMContent.DataSource1.DataSet do
  begin
    if Locate(cIDField, aTekeroID, [loCaseInsensitive]) then
    begin
      DMContent.LoadWebHubTekeroFromDB;
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

procedure TfmAppDBHTML.NoteBadPageID(Sender: TwhConnection;
  const ADesiredPageID: string; var bContinue: Boolean);
const cFn = 'NoteBadPageID';
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // demonstrate how to catch an invalid PageID request.
  LogSendWarning('ADesiredPageID = ' + ADesiredPageID, cFn);
  bContinue := True;  // logged but not handled
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

end.
