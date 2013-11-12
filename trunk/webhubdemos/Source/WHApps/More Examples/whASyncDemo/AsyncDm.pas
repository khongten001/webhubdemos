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
  //whAsync,  // WebHub ASync until October 2013
  OtlCommon,  // Delphi OmniThreadLibrary
  OtlComm,
  OtlSync,
  OtlTask,
  OtlTaskControl,
  OtlCollections,
  OtlParallel,
  htmlCore;

type
  TTrackSurferTaskRec = record
    SessionNumber: Cardinal;
    OmniUniqueID: Int64;
    Output: TOmniValue;
    StartedOnAt: TDateTime;
    FinishedOnAt: TDateTime;
  end;
//  TTrackSurferTaskRecPtr = ^TTrackSurferTaskRec;

type
  TTrackSurferTaskList = TList<TTrackSurferTaskRec>;

type
  TdmAsyncDemo = class(TDataModule)
    procedure waAsyncActionExecute(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  strict private
    FCS: TCriticalSection;
    FSurferTasks: TTrackSurferTaskList;
    FCountJobsPending: Integer;
    FBackgroundPingWorker: IOmniBackgroundWorker;
    procedure ProcessPingWorkItem(const workItem: IOmniWorkItem);
    procedure HandlePingWorkDone(const Sender: IOmniBackgroundWorker;
      const workItem: IOmniWorkItem);
  public
    waAsyncAction: TwhWebAction;
    function Init(out ErrorText: string): Boolean;
    function FindTaskByUniqueID(const InValue: Int64): Integer;
    function FindTaskBySessionID(const InValue: Cardinal): Integer;
  end;

var
  dmAsyncDemo: TdmAsyncDemo;

implementation

{$R *.DFM}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  Forms,
  TypInfo, // for translating the Async-state into a literal
  webApp, // for access to pWebApp in the thread's constructor
  whMacroAffixes, // MacroStart and MacroEnd
  webSend,
  htStrWWW,
  htWebApp, // for subscribing to the AfterWebAppExecute event list.
  htThread, // backgroundthread class to subscribe TNotifyevents to.
  ipcMail,
  whMacros,
  ucAnsiUtil, // explicit conversion using specified CodePage number
  ucCodeSiteInterface,
  uCode, // tpRaise, tpRaiseHere
  ucString, // string function (IsIn..)
  ucPipe, // access to dos output
  ucWinAPI, // winpath
  whAsyncDemo_fmWhRequests;

{$REGION 'Documentation'}
///	<summary>
///	Process your custom async action through these datamodule events.
/// Below you will find init/finish procs and code for both the onexecute
/// events used in the demo application.
///	</summary>
{$ENDREGION}


procedure TdmAsyncDemo.waAsyncActionExecute(Sender: TObject);
const cFn = 'waAsyncActionExecute';
var
  j: Integer;
  TempOmniWorkItem: IOmniWorkItem;
  rec: TTrackSurferTaskRec;
  actionKeyword: string;
begin
  CSEnterMethod(Self, cFn);

  j := FindTaskBySessionID(pWebApp.SessionNumber);
  CSSend('Task index for this surfer', S(j));
  if j = -1 then
  begin
    rec.SessionNumber := pWebApp.SessionNumber;
    CSSend('rec.SessionNumber', S(rec.SessionNumber));
    actionKeyword := TwhWebAction(Sender).HtmlParam;
    CSSend('actionKeyword', actionKeyword);
    if actionKeyword = 'ping' then
    begin
      TempOmniWorkItem :=
        FBackgroundPingWorker.CreateWorkItem(pWebApp.Request.RemoteAddress);

      InterlockedIncrement(FCountJobsPending);
      rec.OmniUniqueID := TempOmniWorkItem.UniqueID;
      rec.FinishedOnAt := Now + 365;  // not done yet
      rec.StartedOnAt := Now;
      FCS.Enter;
      FSurferTasks.Add(rec);
      FCS.Leave;

      FBackgroundPingWorker.Schedule(TempOmniWorkItem);

      pWebApp.StringVarInt['_OmniUniqueID'] := TempOmniWorkItem.UniqueID;
      pWebApp.SendStringImm('starting your job now');
    end
    else
      pWebApp.SendStringImm('unsupported keyword');
  end
  else
  begin
    if FSurferTasks[j].FinishedOnAt < Now then
    begin
      CSSend('FSurferTasks[j].Output', FSurferTasks[j].Output.AsString);
      pWebApp.SendStringImm('<pre>' + sLineBreak);
      pWebApp.SendStringImm(FSurferTasks[j].Output.AsString);
      pWebApp.SendStringImm('</pre>'+ sLineBreak);
      FCS.Enter;
      FSurferTasks.Delete(j);
      FCS.Leave;
      InterlockedDecrement(FCountJobsPending);
    end;
  end;

  CSExitMethod(Self, cFn);
end;

// ----------------------------------------------------------------------
// Execute example retrieves DOS output and preps it for the web.

procedure TdmAsyncDemo.DataModuleCreate(Sender: TObject);
const cFn = 'DataModuleCreate';
begin
  CSEnterMethod(Self, cFn);
  FCS := TCriticalSection.Create;
  FSurferTasks := TTrackSurferTaskList.Create;
  FCountJobsPending := 0;
  waAsyncAction := TwhWebAction.Create(Self);
  waAsyncAction.Name := 'waAsyncAction';
  waAsyncAction.OnExecute := waAsyncActionExecute;
  //  TicksExpires = 3600000
  //  AsyncState = asInit

{
  GlobalOmniThreadPool.MonitorWith(OmniTED);
  GlobalOmniThreadPool.MaxExecuting := 2;
  GlobalOmniThreadPool.MaxQueued := 3;
}

{
  OmniTED := TOmniEventMonitor.Create(Self);
  OmniTED.Name := 'OmniTED';
}
  FBackgroundPingWorker := nil;

  CSExitMethod(Self, cFn);
end;

procedure TdmAsyncDemo.DataModuleDestroy(Sender: TObject);
const cFn = 'DataModuleDestroy';
begin
  CSEnterMethod(Self, cFn);
  {GlobalOmniThreadPool.CancelAll;}
  {if assigned(FThreadPool) then
  begin
    FThreadPool.CancelAll;
    FThreadPool := nil;
  end;}

  FBackgroundPingWorker.CancelAll;
  FBackgroundPingWorker.Terminate(INFINITE);
  FBackgroundPingWorker := nil;
  FreeAndNil(waAsyncAction);
  FreeAndNil(FSurferTasks);
  FreeAndNil(FCS);
  CSExitMethod(Self, cFn);
end;


function TdmAsyncDemo.FindTaskBySessionID(const InValue: Cardinal): Integer;
const cFn = 'FindTaskBySessionID';
var
  i: integer;
begin
  CSEnterMethod(Self, cFn);
  CSSend('InValue Integer', S(InValue));
  CSSend('InValue', Format('Cardinal? %d', [InValue]));
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

procedure TdmAsyncDemo.HandlePingWorkDone(const Sender: IOmniBackgroundWorker;
  const workItem: IOmniWorkItem);
const
  cFn = 'HandlePingWorkDone';
var
  i: Integer;
  rec: TTrackSurferTaskRec;
begin
  CSEnterMethod(Self, cFn);

  CSSend(Format('Work item %d returned Result=%s',
    [workItem.UniqueID, workItem.Result.AsString]));

  i := FindTaskByUniqueID(workItem.UniqueID);
  if i > -1 then
  begin
    FCS.Enter;
    rec := FSurferTasks[i];
    rec.Output := workItem.Result;
    rec.FinishedOnAt := Now;
    FSurferTasks[i] := rec;
    FCS.Leave;
  end;

  CSExitMethod(Self, cFn);
end;

function TdmAsyncDemo.Init(out ErrorText: string): Boolean;
begin
  ErrorText := '';
  FBackgroundPingWorker := Parallel.BackgroundWorker
    .NumTasks(1)
    .OnRequestDone(dmAsyncDemo.HandlePingWorkDone)
    .Execute(dmAsyncDemo.ProcessPingWorkItem);
  RefreshWebActions(Self);
  Result := True;
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
  DosCmd := 'ping ' + workItem.Data.AsString;
  CSSend('DosCmd', DosCmd);
  aa := GetDosOutputA(AnsiString(DosCmd), nil, ErrorCode);
  CSSend('aa', string(aa));
  s1 := AnsiCodePageToUnicode(aa, 1252);
  CSSend('s1', s1);
  workItem.Result := s1;
  CSSend('workItem.Result', workItem.Result);
  CSExitMethod(Self, cFn);
end;

end.
