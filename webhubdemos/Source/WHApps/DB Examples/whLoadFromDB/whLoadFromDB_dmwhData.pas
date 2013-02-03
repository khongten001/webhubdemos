unit whLoadFromDB_dmwhData;

(*
Copyright (c) 1999-2013 HREF Tools Corp.

Permission is hereby granted, on 2-Feb-2013, free of charge, to any person
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

interface

uses
  SysUtils, Classes,
  webLink, Data.DB, Datasnap.DBClient, MidasLib;

type
  TDMContent = class(TDataModule)
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure AddPage(const defaultlingvo: String;
      const pageid: String; const attributes: String; const pagecontent: String);
    procedure AddMacros(const defaultlingvo: String;
      const macrocontent: String);
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
    function LoadWebHubTekerosFromDB: Boolean;
    function LoadWebHubTekeroFromDB: Boolean;
    procedure SendBufferedStringFromDB(const Value: string;
      var Handled: Boolean);
  end;

var
  DMContent: TDMContent;
const
  cIDField = 'Identifier';
  cWhenToLoadField = 'WhenToLoad';
  cTextField = 'Text';

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  Variants,
  ucCodeSiteInterface,
  webApp, webSplat, htbdeWApp, htWebApp, htmConst, webRead, webList,
  whdemo_ViewSource;

const
  cTypeField = 'Type';
  cPageIdentifier = whFolio;
  cAttributesField = 'Attributes';

{ TDMContent }

procedure TDMContent.AddMacros(const defaultlingvo, macrocontent: String);
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
      'Expression #' + FormatDateTime('yyyymmddhhnnss', Now),
       'Temp', '',
       pWebApp.PageGeneration, pWebApp.Syntax0100,
       pWebApp.Tekeros, pWebApp.Pages, pWebApp.Macros,
       pWebApp.Debug.PageErrors, True, pWebApp.ProjectSyntax);
  finally
    FreeAndNil(ms);
  end;
end;

procedure TDMContent.AddPage(const defaultlingvo, pageid, attributes,
  pagecontent: String);
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
      'Expression #' + FormatDateTime('yyyymmddhhnnss', Now), 'Temp', '',
       pWebApp.PageGeneration, pWebApp.Syntax0100,
       pWebApp.Tekeros, pWebApp.Pages, pWebApp.Macros,
       pWebApp.Debug.PageErrors, True, pWebApp.ProjectSyntax);
  finally
    FreeAndNil(ms);
  end;
end;

procedure TDMContent.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMContent.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin

      if pWebApp is TwhApplication then
      with TwhApplication(pWebApp) do
      begin
        OnSendBufferedString := SendBufferedStringFromDB;
      end;

      if pWebApp is TwhbdeApplication then
      with TwhbdeApplication(pWebApp) do
      begin
        DynContentDataSource := DMContent.DataSource1;  // hook up the database
        IDFieldName := cIDField;
        DynContentFieldName := cTextField;
        CacheDbContent := True;  {enable some caching}
      end;

      ClientDataSet1.FileName := getHtDemoDataRoot + 'whLoadFromDB\' +
        'whContent.xml';
      try
        ClientDataSet1.Open;
        ClientDataSet1.ReadOnly := False;
      except
        on E: Exception do
        begin
          ErrorText := E.Message;
        end;
      end;

      if ErrorText = '' then
      begin
        LoadWebHubTekerosFromDB;
        AddAppUpdateHandler(WebAppUpdate);
        FlagInitDone := True;
      end;
    end;
  end;
  Result := FlagInitDone;
  {$IFDEF CodeSite}CodeSite.Send('Result', Result);
  CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

function TDMContent.LoadWebHubTekeroFromDB: Boolean;
const cFn = 'LoadWebHubTekeroFromDB';
var
  aPageID: string;
  aPageContent: string;
  aPageDesc: string;
  aTypeField: string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  Result := True;

  {assume that we are positioned on the database record to load}
  with ClientDataSet1 do
  begin
    aTypeField := FieldByName(cTypeField).asString;
   // CSSend('aTypeField', aTypeField);
    if (aTypeField = whMacrosTag) then
    begin
      AddMacros('eng', FieldByName(cTextField).AsString);
    end
    else
    if (aTypeField = whFolio) then  // whFolio means whPage
    begin
      aPageID := FieldByName(cIDField).asString;
      CSSend('aPageID', aPageID);
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
    end
    else
    begin
      CSSendNote(Format('Not preloading "%s" of type %s.',
        [FieldByName(cIDField).AsString, aTypeField]));
      Result := False;
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

function TDMContent.LoadWebHubTekerosFromDB: Boolean;
const cFn = 'LoadWebHubTekerosFromDB';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  Result := True;

  (* excellent tutorial about TClientDataSet:
  http://edn.embarcadero.com/article/29122
  *)
  if NOT ClientDataSet1.Active then
  begin
    try
      DMContent.DataSource1.DataSet.Open;
      // for some reason (bug) the TClientDataSet can have ReadOnly False
      // yet need to have that property SET again to False.
      // Confirmed in Delphi XE3 2-Feb-2013
      if DMContent.ClientDataSet1.ReadOnly then
      begin
        // does not fire
        //MsgWarningOk('ClientDataSet1.ReadOnly ... reversing');
        DMContent.ClientDataSet1.ReadOnly := False;
      end;
      if NOT DMContent.ClientDataSet1.CanModify then
      begin
        //MsgWarningOk(DMContent.ClientDataSet1.Name + sLineBreak +
        //  'CanModify = False' + sLineBreak + sLineBreak +
        //  'Reversing so that you can do data entry now.');
        DMContent.ClientDataSet1.ReadOnly := False;
      end;
    except
      on E: Exception do
      begin
        LogSendException(E, cFn);
        Result := False;
      end;
    end;
  end;

  if Result then
  begin
    ClientDataSet1.First;
    while not ClientDataSet1.EOF do
    begin
      DMContent.LoadWebHubTekeroFromDB;
      ClientDataSet1.Next;
    end;
  end;
  WebMessage('');
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMContent.SendBufferedStringFromDB(const Value: string;
  var Handled: Boolean);
{$IFDEF CodeSite}const cFn = 'SendBufferedStringFromDB';{$ENDIF}
var
  a1: String;
  aWhenToLoad: String;
  t: TwhList;
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}

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
      if NOT DMContent.DataSource1.DataSet.Active then
      begin
        CSSendWarning(DMContent.DataSource1.DataSet.Name + ' not active yet');
        DMContent.DataSource1.DataSet.Open;
      end;

      {locate based on Value}
      if DMContent.DataSource1.DataSet.Locate(IDFieldName, VarArrayOf([Value]),
        [loCaseInsensitive]) then
      begin
        {we found our match; grab the page/droplet content now}
        with DMContent.DataSource1.DataSet do
        begin
          a1 := FieldByName(cTextField).asString;
          CSSend('FOUND a1', a1);
          aWhenToLoad := FieldByname(cWhenToLoadField).asString;
          CSSend('aWhenToLoad', aWhenToLoad);
        end;

        {output the content now, potentially recursively calling here}
        // SendString expands any macros contained within a1
        // SendStringImm does not.
        SendString(a1);

        {signal that we have handled this Value}
        Handled := True;

        {consider caching the content for next time}
        if aWhenToLoad <> 'NoCache' then
        begin
          {Load the page or droplet content into memory. Both page and droplet
           content are stored in the pWebApp.Droplets array.}
          t := TwhList.create;
          t.text := a1;
          Tekeros.AddObject(Value + '=' + Value, t);
          {Reminder: do NOT free t. WebHub will free it when appropriate.}
        end;
      end
      else
      begin
        {add Value to the list so we don't search for it next time around.}
        CSSendWarning('Not located: ' + Value);
        CacheDbFail := CacheDbFail+uppercase(Value)+'|';
        CSSend('CacheDbFail', CacheDbFail);
        CacheDbFailCount := CacheDbFailCount + 1;
        CSSend('CacheDbFailCount', S(CacheDbFailCount));
      end;
    end;
  end;
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMContent.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  LoadWebHubTekerosFromDB;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

end.
