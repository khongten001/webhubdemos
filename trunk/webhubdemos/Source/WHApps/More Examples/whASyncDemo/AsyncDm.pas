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

type
  TDosCmdType = (dctInvalid, dctPing, dctTracert, dctNSLookup);

type
  TTrackSurferTaskRec = record
    SessionNumber: Cardinal;
    CmdType: TDosCmdType;
    OmniUniqueID: Int64;  // unique per IOmniBackgroundWorker (not global)
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
    function FindTaskByUniqueID(const InCmdType: TDosCmdType; const InValue: Int64): Integer;
    function FindFirstTaskForSessionID(const InCmdType: TDosCmdType; const InValue: Cardinal): Integer;
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
  SurferCmdType: TDosCmdType;
begin
  CSEnterMethod(Self, cFn);

  { Surfer selects a radio button, which expands to a particular string }
  actionKeyword := pWebApp.StringVar['inDosKeyword'];
  CSSend('actionKeyword', actionKeyword);
  if actionKeyword = 'ping' then
    SurferCmdType := dctping
  else
  if actionKeyword = 'tracert' then
    SurferCmdType := dctTracert
  else
  if actionKeyword = 'nslookup' then
    SurferCmdType := dctNSLookup
  else
    SurferCmdType := dctInvalid;

  if SurferCmdType <> dctInvalid then
  begin
    otListLock.EnterReadLock;
    j := FindFirstTaskForSessionID(SurferCmdType, pWebApp.SessionNumber);  // -1 if not found
    otListLock.ExitReadLock;

    if j = -1 then
    begin
      rec.SessionNumber := pWebApp.SessionNumber;
      rec.CmdType := SurferCmdType;

      case SurferCmdType of
        dctPing:
          TempOmniWorkItem :=
            FBackgroundPingWorker.CreateWorkItem(
              'ping ' + pWebApp.Request.RemoteAddress + ' -n 10');
        dctTracert:
          TempOmniWorkItem :=
            FBackgroundTracertWorker.CreateWorkItem(
              'tracert ' + pWebApp.Request.RemoteAddress);
        dctNSLookup:
          TempOmniWorkItem :=
            FBackgroundNSLookupWorker.CreateWorkItem(
              'nslookup ' + pWebApp.Request.RemoteAddress);
      end;

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

      case SurferCmdType of
        dctPing:
          FBackgroundPingWorker.Schedule(TempOmniWorkItem);
        dctTracert:
          FBackgroundTracertWorker.Schedule(TempOmniWorkItem);
        dctNSLookup:
          FBackgroundNSLookupWorker.Schedule(TempOmniWorkItem);
      end;

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


function TdmAsyncDemo.FindFirstTaskForSessionID(const InCmdType: TDosCmdType;
  const InValue: Cardinal): Integer;
const
  cFn = 'FindFirstTaskForSessionID';
var
  i: Integer;
begin
  CSEnterMethod(Self, cFn);
  // CSSend('InValue', S(InValue));
  Result := -1;
  // CSSend('FSurferTasks.Count', S(FSurferTasks.Count));

  for i := 0 to Pred(FSurferTasks.Count) do
  begin
    CSSend('List #' + S(i), Format('for SessionNumber %d',
      [FSurferTasks[i].SessionNumber]));
    if (FSurferTasks[i].SessionNumber = InValue) and
      (FSurferTasks[i].CmdType = InCmdType) then
    begin
      CSSend('found');
      Result := i;
      break;
    end;
  end;
  // CSSend(cFn + ' Result', S(Result));
  CSExitMethod(Self, cFn);
end;

function TdmAsyncDemo.FindTaskByUniqueID(const InCmdType: TDosCmdType;
  const InValue: Int64): Integer;
const
  cFn = 'FindTaskByUniqueID';
var
  i: Integer;
begin
  CSEnterMethod(Self, cFn);
  CSSend('InValue', S(InValue));
  Result := -1;
  /// CSSend('FSurferTasks.Count', S(FSurferTasks.Count));

  for i := 0 to Pred(FSurferTasks.Count) do
  begin
    CSSend('list #' + S(i) + ' has OmniUniqueID',
      S(FSurferTasks[i].OmniUniqueID));
    // CSSend('StartedOnAt',
    // FormatDateTime('ddd hh:nn', FSurferTasks[i].StartedOnAt));
    if (FSurferTasks[i].OmniUniqueID = InValue) and
      (FSurferTasks[i].CmdType = InCmdType) then
    begin
      CSSend('found');
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
  actionKeyword: string;
  TaskCmdType: TDosCmdType;
begin
  CSEnterMethod(Self, cFn);

  CSSend('workItem.UniqueID', S(workItem.UniqueID));
  actionKeyword := LeftOfS(' ', workItem.Data.AsString);
  CSSend('actionKeyword', actionKeyword);
  CSSend('workItem.Result', workItem.Result.AsString);

  if actionKeyword = 'ping' then
    TaskCmdType := dctping
  else
  if actionKeyword = 'tracert' then
    TaskCmdType := dctTracert
  else
  if actionKeyword = 'nslookup' then
    TaskCmdType := dctNSLookup
  else
    TaskCmdType := dctInvalid;

  otListLock.EnterWriteLock;
  try
    i := FindTaskByUniqueID(TaskCmdType, workItem.UniqueID);
    if i > -1 then
    begin
      rec := FSurferTasks[i];
      rec.Output := workItem.Result.AsString;
      rec.FinishedOnAt := Now;
      FSurferTasks[i] := rec;
    end
    else
      CSSendError('Unable to find task in list for UniqueID=' +
        IntToStr(workItem.UniqueID));
  finally
    otListLock.ExitWriteLock;
  end;

  CSExitMethod(Self, cFn);
end;

const
  cNumTasksEachType = 2;

function TdmAsyncDemo.Init(out ErrorText: string): Boolean;
begin
  ErrorText := '';
  FBackgroundPingWorker := Parallel.BackgroundWorker
    .NumTasks(cNumTasksEachType)
    .OnRequestDone(dmAsyncDemo.HandleDosWorkDone)
    .Execute(dmAsyncDemo.ProcessPingWorkItem);

  FBackgroundTracertWorker := Parallel.BackgroundWorker
    .NumTasks(cNumTasksEachType)
    .OnRequestDone(dmAsyncDemo.HandleDosWorkDone)
    .Execute(dmAsyncDemo.ProcessTracertWorkItem);

  FBackgroundNSlookupWorker := Parallel.BackgroundWorker
    .NumTasks(cNumTasksEachType)
    .OnRequestDone(dmAsyncDemo.HandleDosWorkDone)
    .Execute(dmAsyncDemo.ProcessNSLookupWorkItem);

  RefreshWebActions(Self);
  Result := waAsyncAction.IsUpdated;
  if NOT Result then
    ErrorText := 'Unable to refresh waAsyncAction';
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
  DosCmd := workItem.Data.AsString; // nslookup
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
  DosCmd := workItem.Data.AsString; // ping 192.168.0.1 -n 10
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
  DosCmd := workItem.Data.AsString; // tracert
  CSSend('DosCmd', DosCmd);
  aa := GetDosOutputA(AnsiString(DosCmd), nil, ErrorCode);
  s1 := AnsiCodePageToUnicode(aa, 1252);
  workItem.Result := s1;
  CSSend('workItem.Result', workItem.Result);
  CSExitMethod(Self, cFn);
end;

end.
