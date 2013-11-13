unit AsyncDm;
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

interface

{$I hrefdefines.inc}
{$I WebHub_Comms.inc}

uses
  Windows, Messages,  // both required by OmniThreadLibrary
  SysUtils, Classes, SyncObjs,
  {System.Generics.}Generics.Collections,
  updateOk, tpAction, webTypes, webLink, webVars,
  OtlCommon,  // Delphi OmniThreadLibrary replaces WebHub ASync November 2013
  OtlComm,
  OtlSync,
  OtlTask,
  OtlTaskControl,
  OtlCollections,
  OtlParallel;
  //htmlCore;

type
  TTrackSurferTaskRec = record
    SessionNumber: Cardinal;
    OmniUniqueID: Int64;
    Output: TOmniValue;
    StartedOnAt: TDateTime;
    FinishedOnAt: TDateTime;
  end;

type
  TTrackSurferTaskList = TList<TTrackSurferTaskRec>;

type
  TdmAsyncDemo = class(TDataModule)
    procedure waAsyncActionExecute(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  strict private
    otListLock: TOmniMREW;
    FSurferTasks: TTrackSurferTaskList;
    FCountDosJobsPending: Integer;
    FBackgroundPingWorker: IOmniBackgroundWorker;
    FBackgroundTracertWorker: IOmniBackgroundWorker;
    FBackgroundNSLookupWorker: IOmniBackgroundWorker;
    procedure ProcessPingWorkItem(const workItem: IOmniWorkItem);
    procedure ProcessTracertWorkItem(const workItem: IOmniWorkItem);
    procedure ProcessNSLookupWorkItem(const workItem: IOmniWorkItem);
    procedure HandleDosWorkDone(const Sender: IOmniBackgroundWorker;
      const workItem: IOmniWorkItem);
    function FindTaskByUniqueID(const InValue: Int64): Integer;
    function FindTaskBySessionID(const InValue: Cardinal): Integer;
  public
    waAsyncAction: TwhWebAction;
    function Init(out ErrorText: string): Boolean;
  end;

var
  dmAsyncDemo: TdmAsyncDemo;

implementation

{$R *.DFM}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  Forms,
  webApp, // for access to pWebApp
  htWebApp, // for subscribing to the AfterWebAppExecute event list.
  ucAnsiUtil, // explicit conversion using specified CodePage number
  ucCodeSiteInterface,
  ucString, // string function
  ucPipe // access to dos output
  ;


{$REGION 'Documentation'}
///	<summary>
///	This example shows how to process 3 DOS commands on a background thread:
/// ping, tracert and nslookup.
/// Each is handled by its own IOmniBackgroundWorker and its own "work"
/// method.  They share the "done" method.
///	</summary>
{$ENDREGION}


procedure TdmAsyncDemo.waAsyncActionExecute(Sender: TObject);
const cFn = 'waAsyncActionExecute';
var
  j: Integer;
  TempOmniWorkItem: IOmniWorkItem;
  rec: TTrackSurferTaskRec;
  actionKeyword: string;
  bValidKeyword: Boolean;
begin
  CSEnterMethod(Self, cFn);

  bValidKeyword := False;
  otListLock.EnterReadLock;
  j := FindTaskBySessionID(pWebApp.SessionNumber);  // -1 if not found
  otListLock.ExitReadLock;

  if j = -1 then
  begin
    rec.SessionNumber := pWebApp.SessionNumber;
    //CSSend('rec.SessionNumber', S(rec.SessionNumber));
    { Surfer selects a radio button, which expands to a particular string }
    actionKeyword := pWebApp.MoreIfParentild(TwhWebAction(Sender).HtmlParam);
    CSSend('actionKeyword', actionKeyword);
    if actionKeyword = 'ping' then
    begin
      TempOmniWorkItem :=
        FBackgroundPingWorker.CreateWorkItem(pWebApp.Request.RemoteAddress);
      bValidKeyword := True;
    end
    else
    if actionKeyword = 'tracert' then
    begin
      TempOmniWorkItem :=
        FBackgroundTracertWorker.CreateWorkItem(pWebApp.Request.RemoteAddress);
      bValidKeyword := True;
    end
    else
    if actionKeyword = 'nslookup' then
    begin
      TempOmniWorkItem :=
        FBackgroundNSLookupWorker.CreateWorkItem(pWebApp.Request.RemoteAddress);
      bValidKeyword := True;
    end;
    if bValidKeyword then
    begin
      InterlockedIncrement(FCountDosJobsPending);
      rec.OmniUniqueID := TempOmniWorkItem.UniqueID;
      rec.FinishedOnAt := Now + 365;  // not done yet
      rec.StartedOnAt := Now;
      otListLock.EnterWriteLock;
      FSurferTasks.Add(rec);
      otListLock.ExitWriteLock;
      pWebApp.StringVarInt['_OmniUniqueID'] := TempOmniWorkItem.UniqueID;
      pWebApp.StringVarInt['_CountDosJobsPending'] := FCountDosJobsPending;

      pWebApp.SendStringImm('Starting your ' + actionKeyword + ' task now...');

      if actionKeyword = 'ping' then
        FBackgroundPingWorker.Schedule(TempOmniWorkItem)
      else
      if actionKeyword = 'tracert' then
        FBackgroundTracertWorker.Schedule(TempOmniWorkItem)
      else
      if actionKeyword = 'nslookup' then
        FBackgroundNSLookupWorker.Schedule(TempOmniWorkItem);

    end
    else
      pWebApp.SendStringImm('unsupported keyword: ' + actionKeyword);
  end
  else
  begin
    CSSend('Task index for this surfer', S(j));
    otListLock.EnterReadLock;
    rec := FSurferTasks[j];
    otListLock.ExitReadLock;
    if rec.FinishedOnAt < Now then
    begin
      CSSend('FSurferTasks[j].Output', FSurferTasks[j].Output.AsString);
      pWebApp.SendStringImm('<pre>' + sLineBreak);
      pWebApp.SendStringImm(FSurferTasks[j].Output.AsString);
      pWebApp.SendStringImm('</pre>'+ sLineBreak);
      otListLock.EnterWriteLock;
      FSurferTasks.Delete(j);
      otListLock.ExitWriteLock;
      InterlockedDecrement(FCountDosJobsPending);
      pWebApp.Session.DeleteStringVarByName('_OmniUniqueID');
    end
    {
    else  // could give extra message to surfer here.
      pWebApp.SendStringImm('work in progress... display again')
    }
    ;
  end;

  CSExitMethod(Self, cFn);
end;

// ----------------------------------------------------------------------
// Execute example retrieves DOS output and preps it for the web.

procedure TdmAsyncDemo.DataModuleCreate(Sender: TObject);
const cFn = 'DataModuleCreate';
begin
  CSEnterMethod(Self, cFn);

  FSurferTasks := TTrackSurferTaskList.Create;
  FCountDosJobsPending := 0;

  waAsyncAction := TwhWebAction.Create(Self);
  waAsyncAction.Name := 'waAsyncAction';
  waAsyncAction.OnExecute := waAsyncActionExecute;

  FBackgroundPingWorker := nil;
  FBackgroundTracertWorker := nil;
  FBackgroundNSLookupWorker := nil;

  CSExitMethod(Self, cFn);
end;

procedure TdmAsyncDemo.DataModuleDestroy(Sender: TObject);
const cFn = 'DataModuleDestroy';
begin
  CSEnterMethod(Self, cFn);
  FBackgroundPingWorker.CancelAll;
  FBackgroundPingWorker.Terminate(INFINITE);
  FBackgroundPingWorker := nil;
  FBackgroundTracertWorker.CancelAll;
  FBackgroundTracertWorker.Terminate(INFINITE);
  FBackgroundTracertWorker := nil;
  FBackgroundNSLookupWorker.CancelAll;
  FBackgroundNSLookupWorker.Terminate(INFINITE);
  FBackgroundNSLookupWorker := nil;
  FreeAndNil(waAsyncAction);
  FreeAndNil(FSurferTasks);
  CSExitMethod(Self, cFn);
end;


function TdmAsyncDemo.FindTaskBySessionID(const InValue: Cardinal): Integer;
const cFn = 'FindTaskBySessionID';
var
  i: integer;
begin
  CSEnterMethod(Self, cFn);
  CSSend('InValue', S(InValue));
  Result := -1;
  CSSend('FSurferTasks.Count', S(FSurferTasks.Count));

  for i := 0 to Pred(FSurferTasks.Count) do
  begin
    CSSend('Task #' + S(i),
      Format('for SessionNumber %d', [FSurferTasks[i].SessionNumber]));
    if FSurferTasks[i].SessionNumber = InValue then
    begin
      Result := i;
      break;
    end;
  end;
  CSSend(cFn + ' Result', S(Result));
  CSExitMethod(Self, cFn);
end;

function TdmAsyncDemo.FindTaskByUniqueID(const InValue: Int64): Integer;
const cFn = 'FindTaskByUniqueID';
var
  i: integer;
begin
  CSEnterMethod(Self, cFn);
  CSSend('InValue', S(InValue));
  Result := -1;
  CSSend('FSurferTasks.Count', S(FSurferTasks.Count));

  for i := 0 to Pred(FSurferTasks.Count) do
  begin
    CSSend(S(i), S(FSurferTasks[i].OmniUniqueID));
    CSSend('StartedOnAt',
      FormatDateTime('ddd hh:nn', FSurferTasks[i].StartedOnAt));
    if FSurferTasks[i].OmniUniqueID = InValue then
    begin
      Result := i;
      break;
    end;
  end;
  CSSend(cFn + ' Result', S(Result));
  CSExitMethod(Self, cFn);
end;

procedure TdmAsyncDemo.HandleDosWorkDone(const Sender: IOmniBackgroundWorker;
  const workItem: IOmniWorkItem);
const
  cFn = 'HandleDosWorkDone';
var
  i: Integer;
  rec: TTrackSurferTaskRec;
begin
  CSEnterMethod(Self, cFn);

  CSSend(Format('Work item %d returned Result=%s',
    [workItem.UniqueID, workItem.Result.AsString]));

  otListLock.EnterWriteLock;
  try
    i := FindTaskByUniqueID(workItem.UniqueID);
    if i > -1 then
    begin
      rec := FSurferTasks[i];
      rec.Output := workItem.Result;
      rec.FinishedOnAt := Now;
      FSurferTasks[i] := rec;
    end;
  finally
    otListLock.ExitWriteLock;
  end;

  CSExitMethod(Self, cFn);
end;

function TdmAsyncDemo.Init(out ErrorText: string): Boolean;
begin
  ErrorText := '';
  FBackgroundPingWorker := Parallel.BackgroundWorker
    .NumTasks(2)
    .OnRequestDone(dmAsyncDemo.HandleDosWorkDone)
    .Execute(dmAsyncDemo.ProcessPingWorkItem);
  FBackgroundTracertWorker := Parallel.BackgroundWorker
    .NumTasks(2)
    .OnRequestDone(dmAsyncDemo.HandleDosWorkDone)
    .Execute(dmAsyncDemo.ProcessTracertWorkItem);
  FBackgroundNSlookupWorker := Parallel.BackgroundWorker
    .NumTasks(2)
    .OnRequestDone(dmAsyncDemo.HandleDosWorkDone)
    .Execute(dmAsyncDemo.ProcessNSLookupWorkItem);
  RefreshWebActions(Self);
  Result := True;
end;

procedure TdmAsyncDemo.ProcessNSLookupWorkItem(const workItem: IOmniWorkItem);
const cFn = 'ProcessNSLookupWorkItem';
var
  DosCmd: string;
  aa: AnsiString;
  s1: string;
  ErrorCode: Integer;
begin
  CSEnterMethod(Self, cFn);
  DosCmd := 'nslookup ' + workItem.Data.AsString;
  //CSSend('DosCmd', DosCmd);
  aa := GetDosOutputA(AnsiString(DosCmd), nil, ErrorCode);
  s1 := AnsiCodePageToUnicode(aa, 1252);
  workItem.Result := s1;
  //CSSend('workItem.Result', workItem.Result);
  CSExitMethod(Self, cFn);
end;

procedure TdmAsyncDemo.ProcessPingWorkItem(const workItem: IOmniWorkItem);
const cFn = 'ProcessPingWorkItem';
var
  DosCmd: string;
  aa: AnsiString;
  s1: string;
  ErrorCode: Integer;
begin
  CSEnterMethod(Self, cFn);
  DosCmd := 'ping ' + workItem.Data.AsString + ' -n 10';  // repeat 10x
  CSSend('DosCmd', DosCmd);
  aa := GetDosOutputA(AnsiString(DosCmd), nil, ErrorCode);
  //CSSend('aa', string(aa));
  s1 := AnsiCodePageToUnicode(aa, 1252);
  //CSSend('s1', s1);
  workItem.Result := s1;
  CSSend('workItem.Result', workItem.Result);
  CSExitMethod(Self, cFn);
end;

procedure TdmAsyncDemo.ProcessTracertWorkItem(const workItem: IOmniWorkItem);
const cFn = 'ProcessTracertWorkItem';
var
  DosCmd: string;
  aa: AnsiString;
  s1: string;
  ErrorCode: Integer;
begin
  CSEnterMethod(Self, cFn);
  DosCmd := 'tracert ' + workItem.Data.AsString;
  CSSend('DosCmd', DosCmd);
  aa := GetDosOutputA(AnsiString(DosCmd), nil, ErrorCode);
  s1 := AnsiCodePageToUnicode(aa, 1252);
  workItem.Result := s1;
  CSSend('workItem.Result', workItem.Result);
  CSExitMethod(Self, cFn);
end;

end.
