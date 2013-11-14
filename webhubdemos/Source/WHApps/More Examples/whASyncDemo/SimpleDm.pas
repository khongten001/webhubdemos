unit SimpleDm;
(*
  Copyright (c) 1999 HREF Tools Corp.
  Refactored to use OmniThreadLibrary 12-Nov-2013

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

uses
  SysUtils, Classes,
  {System.Generics.}Generics.Collections,
  OtlCommon,  // Delphi OmniThreadLibrary replaces WebHub ASync November 2013
  OtlComm,
  OtlSync,
  OtlTask,
  OtlTaskControl,
  OtlCollections,
  OtlParallel,
  tpAction, updateOK,
  webTypes,
  webLink;

type
  TTrackSurferSimpleTaskRec = record
    SessionNumber: Cardinal;
    OmniUniqueID: Int64;   // unique per IOmniBackgroundWorker
    OmniWorkItem: IOmniWorkItem;
    Output: Integer;
    PercentComplete: Integer;
    StartedOnAt: TDateTime;
    FinishedOnAt: TDateTime;
  end;

type
  TTrackSurferSimpleTaskList = TList<TTrackSurferSimpleTaskRec>;

type
  TdmSimpleAsync = class(TDatamodule)
    procedure waAsyncSimple1Execute(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  strict private
    otListLock: TOmniMREW;
    FSurferTasks: TTrackSurferSimpleTaskList;
    FCountJobsPending: Integer;
    FBackgroundWorker: IOmniBackgroundWorker;
    procedure ProcessWorkItem(const workItem: IOmniWorkItem);
    procedure HandleWorkDone(const Sender: IOmniBackgroundWorker;
      const workItem: IOmniWorkItem);
    function FindTaskByUniqueID(const InValue: Int64): Integer;
    function FindTaskBySessionID(const InValue: Cardinal): Integer;
  public
    waAsyncSimple1: TwhWebAction;
    function Init(out ErrorText: string): Boolean;
  end;

var
  dmSimpleAsync: TdmSimpleAsync;

implementation

{$R *.DFM}

uses
{$IFDEF CodeSite}CodeSiteLogging, {$ENDIF}
  Windows, // InterlockedIncrement
  //Forms,   // ProcessMessages
  TypInfo, // for translating the Async-state into a literal
  webApp,  // for access to pWebApp in the thread's constructor
  ucCodeSiteInterface,
  ucString; // string functions


procedure TdmSimpleAsync.DataModuleCreate(Sender: TObject);
begin
  waAsyncSimple1 := TwhWebAction.Create(Self);
  waAsyncSimple1.Name := 'waAsyncSimple1';
  waAsyncSimple1.OnExecute := waAsyncSimple1Execute;
  FBackgroundWorker := nil;

  FSurferTasks := TTrackSurferSimpleTaskList.Create;
  FCountJobsPending := 0;
end;

procedure TdmSimpleAsync.DataModuleDestroy(Sender: TObject);
begin
  FBackgroundWorker.CancelAll;
  FBackgroundWorker.Terminate(INFINITE);
  FBackgroundWorker := nil;
  FreeAndNil(FSurferTasks);
  FreeAndNil(waAsyncSimple1);

end;

function TdmSimpleAsync.FindTaskBySessionID(const InValue: Cardinal): Integer;
const cFn = 'FindTaskBySessionID';
var
  i: integer;
begin
  //CSEnterMethod(Self, cFn);
  Result := -1;
  //CSSend('FSurferTasks.Count', S(FSurferTasks.Count));

  for i := 0 to Pred(FSurferTasks.Count) do
  begin
    //CSSend('Task #' + S(i),
    //  Format('for SessionNumber %d', [FSurferTasks[i].SessionNumber]));
    if FSurferTasks[i].SessionNumber = InValue then
    begin
      Result := i;
      break;
    end;
  end;
  //CSSend(cFn + ' Result', S(Result));
  //CSExitMethod(Self, cFn);
end;

function TdmSimpleAsync.FindTaskByUniqueID(const InValue: Int64): Integer;
//const cFn = 'FindTaskByUniqueID';
var
  i: integer;
begin
  //CSEnterMethod(Self, cFn);
  Result := -1;

  for i := 0 to Pred(FSurferTasks.Count) do
  begin
    //CSSend(S(i), S(FSurferTasks[i].OmniUniqueID));
    //CSSend('StartedOnAt',
    //  FormatDateTime('ddd hh:nn', FSurferTasks[i].StartedOnAt));
    if FSurferTasks[i].OmniUniqueID = InValue then
    begin
      Result := i;
      break;
    end;
  end;
  //CSSend(cFn + ' Result', S(Result));
  //CSExitMethod(Self, cFn);
end;

procedure TdmSimpleAsync.HandleWorkDone(const Sender: IOmniBackgroundWorker;
  const workItem: IOmniWorkItem);
const
  cFn = 'HandleWorkDone';
var
  i: Integer;
  rec: TTrackSurferSimpleTaskRec;
begin
  CSEnterMethod(Self, cFn);

  CSSend('workItem.UniqueID', S(workItem.UniqueID));

  otListLock.EnterWriteLock;
  try
    i := FindTaskByUniqueID(workItem.UniqueID);
    if i > -1 then
    begin
      rec := FSurferTasks[i];
      rec.Output := workItem.Result.AsInteger;
      rec.FinishedOnAt := Now;
      rec.PercentComplete := 100;
      FSurferTasks[i] := rec;
      CSSend('Work complete for session', S(rec.SessionNumber));
    end
    else
      CSSendError('Unable to find task in list');
  finally
    otListLock.ExitWriteLock;
  end;

  CSExitMethod(Self, cFn);
end;

function TdmSimpleAsync.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  CSEnterMethod(Self, cFn);
  ErrorText := '';
  RefreshWebActions(Self);
  Result := waAsyncSimple1.IsUpdated;
  if Result then
  begin
    FBackgroundWorker := Parallel.BackgroundWorker
      .NumTasks(5)
      .OnRequestDone(dmSimpleAsync.HandleWorkDone)
      .Execute(dmSimpleAsync.ProcessWorkItem);
  end
  else
  begin
    ErrorText := 'Unable to refresh ' + waAsyncSimple1.Name;  // very unlikely
  end;
  CSExitMethod(Self, cFn);
end;

procedure TdmSimpleAsync.ProcessWorkItem(const workItem: IOmniWorkItem);
const cFn = 'ProcessWorkItem';
var
  i, iJob: Integer;
  rec: TTrackSurferSimpleTaskRec;
  iSimulateDBQuerySeconds: Integer;
const
  cLoops = 100;
begin
  CSEnterMethod(Self, cFn);
  iSimulateDBQuerySeconds := workItem.Data.AsInteger;
  CSSend('iSimulateDBQuerySeconds', S(iSimulateDBQuerySeconds));
  if iSimulateDBQuerySeconds < 5 then
  begin
    iSimulateDBQuerySeconds := 5;
    CSSend('iSimulateDBQuerySeconds', S(iSimulateDBQuerySeconds));
  end;

  otListLock.EnterReadLock;
  iJob := FindTaskByUniqueID(workItem.UniqueID);
  otListLock.ExitReadLock;

  if iJob > -1 then
  begin
    for i := 0 to Pred(cLoops) do
    begin
      if workItem.CancellationToken.IsSignalled then
        break;
      Sleep((iSimulateDBQuerySeconds * 1000) Div cLoops);
      //Application.ProcessMessages;
      if workItem.CancellationToken.IsSignalled then
        break;
      if i mod 10 = 0 then
      begin
        otListLock.EnterWriteLock;
        iJob := FindTaskByUniqueID(workItem.UniqueID);
        try
          rec := FSurferTasks[iJob];
          rec.PercentComplete := i;  // math is easy with 100 loops
          FSurferTasks[iJob] := rec;
        finally
          otListLock.ExitWriteLock;
        end;
      end;
    end;
    workItem.Result := Random(9999);
    CSSend('workItem.Result', S(workItem.Result.AsInteger));
  end;

  CSExitMethod(Self, cFn);
end;


procedure TdmSimpleAsync.waAsyncSimple1Execute(Sender: TObject);
const cFn = 'waAsyncSimple1Execute';
const cCancel = 'cancel';
var
  j: Integer;
  InputSleepSeconds: Integer;
  TempOmniWorkItem: IOmniWorkItem;
  rec: TTrackSurferSimpleTaskRec;
  N: Integer;
begin
  CSEnterMethod(Self, cFn);

  j := FindTaskBySessionID(pWebApp.SessionNumber);  // -1 if not found

  if j = -1 then
  begin
    { new work }
    rec.SessionNumber := pWebApp.SessionNumber;
    InputSleepSeconds := pWebApp.StringVarInt['Demo1SleepSec'];
    CSSend('InputSleepSeconds', S(InputSleepSeconds));
    if InputSleepSeconds < 5 then
    begin
      InputSleepSeconds := 5;
      CSSend('InputSleepSeconds', S(InputSleepSeconds));
    end;

    TempOmniWorkItem := FBackgroundWorker.CreateWorkItem(InputSleepSeconds);
    //  .TaskConfig(Parallel.TaskConfig.WithLock(CreateOmniCriticalSection));

    InterlockedIncrement(FCountJobsPending);
    rec.OmniUniqueID := TempOmniWorkItem.UniqueID;
    rec.FinishedOnAt := Now + 365;  // not done yet
    rec.PercentComplete := 0;
    rec.StartedOnAt := Now;
    rec.OmniWorkItem := TempOmniWorkItem;

    otListLock.EnterWriteLock;
    FSurferTasks.Add(rec);  // only main thread adds to list
    otListLock.ExitWriteLock;

    pWebApp.StringVarInt['_PercentComplete'] := rec.PercentComplete;
    pWebApp.StringVarInt['_OmniUniqueID'] := TempOmniWorkItem.UniqueID;
    pWebApp.StringVarInt['_CountJobsPending'] := FCountJobsPending;
    pWebApp.Session.DeleteStringVarByName('_Demo1Output');

    FBackgroundWorker.Schedule(TempOmniWorkItem);

  end
  else
  begin
    { existing work }
    //CSSend('Task index for this surfer', S(j));
    if FSurferTasks[j].FinishedOnAt < Now then
    begin
      //CSSend('FSurferTasks[j].Output', FSurferTasks[j].Output.AsString);
      pWebApp.StringVar['_Demo1Output'] :=
      '<span style="font-weight:900; color: #20B2AA;">' +
        sLineBreak +
        'Session ' + IntToStr(FSurferTasks[j].SessionNumber) +
        ': here is your random number between 0 and 9999: ' +
        IntTostr(FSurferTasks[j].Output) +
        '</span>'+ sLineBreak;
      otListLock.EnterWriteLock;
      FSurferTasks.Delete(j);  // only main thread deletes from list
      otListLock.ExitWriteLock;
      InterlockedDecrement(FCountJobsPending);
      pWebApp.Session.DeleteStringVarByName('_OmniUniqueID');
    end
    else
    begin
      if TwhWebAction(Sender).HtmlParam = cCancel then
      begin
        CSSendNote(cCancel);
        otListLock.EnterWriteLock;
        try
          j := FindTaskBySessionID(pWebApp.SessionNumber);  // again
          rec := FSurferTasks[j];
          rec.OmniWorkItem.CancellationToken.Signal;
          FSurferTasks.Delete(j);  // only main thread deletes from list
        finally
          otListLock.ExitWriteLock;
        end;
        InterlockedDecrement(FCountJobsPending);
        pWebApp.Session.DeleteStringVarByName('_OmniUniqueID');
        pWebApp.Session.DeleteStringVarByName('_PercentComplete');
        pWebApp.StringVar['_Demo1Output'] := 'cancelled by surfer';
      end
      else
      begin
        // give message to surfer here.
        otListLock.EnterReadLock;
        try
          j := FindTaskBySessionID(pWebApp.SessionNumber);  // again
          rec := FSurferTasks[j];
        finally
          otListLock.ExitReadLock;
        end;
        InterlockedExchange(N, rec.PercentComplete);
        pWebApp.StringVarInt['_PercentComplete'] := N;
        pWebApp.StringVarInt['_CountJobsPending'] := FCountJobsPending;
        pWebApp.Response.Send('(~_PercentComplete~) percent complete');
      end;
    end;
  end;

  CSExitMethod(Self, cFn);
end;

initialization
  Randomize;

end.
