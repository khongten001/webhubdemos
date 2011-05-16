unit AsyncDm;
(*
Copyright (c) 1999 HREF Tools Corp.
Author: Michael Ax

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

//----------------------------------------------------------------------

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UpdateOk, tpAction, WebTypes,   WebLink, WebVars, whAsync,
  HtmlCore;

//----------------------------------------------------------------------

type
  //TwhAsyncAction might not be on your palette.  If it is not, and you want 
  //it to be, you could cheat and redefine TwhWebActionEx for this unit to
  //'splice' in the new code for you.
  //  TwhWebAction = class(TwhAsyncAction);

  TdmAsyncDemo = class(TDataModule)
    waAsyncAction: TwhAsyncAction;
    procedure ExecuteSynchronized(Sender:TObject);
    procedure waAsyncActionExecute(Sender: TObject);
    procedure ExecuteDosCmd(Sender: TObject);
    procedure ExecuteStepByStep(Sender:TObject);
    procedure ThreadInit(Sender: TObject);
    procedure ExecuteAsOneBlock(Sender: TObject);
    procedure ThreadFinish(Sender: TObject);
    procedure ThreadDestroy(Sender: TObject);
  private
    procedure SetAsyncState(Value:TAsyncState);
  public
    end;

var
  dmAsyncDemo: TdmAsyncDemo;

implementation

{$R *.DFM}

uses
  TypInfo,         // for translating the Async-state into a literal
  webApp,          // for access to pWebApp in the thread's constructor
  whMacroAffixes,  // MacroStart and MacroEnd
  webSend,
  htStrWWW,
  htWebApp,        // for subscribing to the AfterWebAppExecute event list.
  htThread,        // backgroundthread class to subscribe TNotifyevents to.
  ipcMail,
  whMacros,
  ucAnsiUtil,      // explicit conversion using specified CodePage number
  uCode,           // tpRaise, tpRaiseHere
  ucString,        // string function (IsIn..)
  ucPipe,          // access to dos output
  ucWinAPI,        // winpath
  whAsyncDemo_fmWhRequests;

//----------------------------------------------------------------------
//----------------------------------------------------------------------
// process your custom async action through these datamodule events.
// below you'll find init/finish procs and code for both the onexecute
// events used in the demo application

// this code sets up an object which is then attached to the
// thread to provide it input data to operate on. As the built-in
// default thread-class already supports a ResultString property
// which you can use to pass strings into the background thread
// this code should serve to show how one might use these event
// for either case:

type
  TThreadInput= class(TObject)  //simple object.
    DosCmd: AnsiString;         //add and initialize fields as needed.
    temp: string;
    //
    //stream and stream related
    bStreaming: LongBool;
    Stream: TwhResponseStream; //HtStrWWW
    chForEach,chDone,chTail:string;
    bAbort: Boolean;
      //if true aborts when switching away from open page.
      //if false - continues processing!
    bUsedGetAnsiStrProc: Boolean;
      //if true then GetAnsiStrProc has been called and we've sent
      //some actual in-progress message as opposed to 'just a dot
      //to update the display'.. when that happens we know that per
      //the design of this demo that ALL of the result-text will flow
      //through GetAnsiStrProc right back to the user and that therefore
      //we don't need to send the resulttext when finished/done.
    procedure GetAnsiStrProc(const Value: AnsiString);
      //GetAnsiStrProc is called back, roughly line by line, by
      //the GetDosOutputA function for the 'split-off' dos-cmd
      //demo.
    function SendUpdate(PercentComplete:integer):Boolean;
      //SendUpdate is used to deliver chForEach to the surfer.
    procedure Finished(const ResultString:String);
      //Finished closes out the stream when the task is done.
    procedure TakeOver(Response:TwhResponseSimple);
      //
      end;

procedure TThreadInput.GetAnsiStrProc(const Value: AnsiString);
var
  a8: UTF8String;
  S: string;
begin
  if bStreaming and assigned(Stream) then
  begin
    S := StringReplaceAll(AnsiCodePageToUnicode(Value, 1252),
      sLineBreak, '<br/>' + sLineBreak);
    {$IFDEF UNICODE}
    a8 := UnicodeToUTF8(S);
    {$ELSE}
    a8 := AnsiCodePageToUTF8(S, 1252);
    {$ENDIF}
    if CommOutBufferToMailBox(Stream.Name, '+', a8) then
      bUsedGetAnsiStrProc := True
  end;
end;

function TThreadInput.SendUpdate(PercentComplete:integer):Boolean;
var
  S: string;
  a1: UTF8String;
begin
  Result:=True;
  if bStreaming and assigned(Stream) then
  begin
    with Stream do
    begin

      if temp <> Stream.name then
      begin
        Sleep(100);
        temp := Stream.name;
      end;

      S := chForEach;
      StringRepl(S, 'XXX', IntToStr(PercentComplete));
      a1 := UTF8Encode(S);
      if not CommOutBufferToMailBox(Name, '+', a1) then
      begin
        Result := not bAbort;
      end;
    end;
  end;
end;

procedure TThreadInput.Finished(const ResultString:String);
begin
  if assigned(Stream) then begin
    with stream do begin
      if bStreaming then begin
        //note.. up to here any and all intermediate output that
        //we may have been sending into the surfer's output stream
        //has been prefixed by the '+' concatenation symbol. this
        //time around we're completely done though and use the
        //absence of the concatenation operator to signal to the
        //runner that it's time to close the connection now.
        //(btw, if YOU close the connection at any time the runner
        //will cause CommOutBufferToMailBox to fail. you can see that
        //used below to conditionally abort the balance of the process.
        if bUsedGetAnsiStrProc then
          Writes(chDone+chTail)
        else
          Writes(chDone+ResultString+chTail);
        end
      else
        Flush;
      Free;
      end;
    Stream:=nil;
    end;
end;

procedure TThreadInput.TakeOver(Response:TwhResponseSimple);
var
  a1,a2: string;
  s8: UTF8String;
begin
  InterLockedExchange(Integer(bStreaming),Integer(False));
  if assigned(Stream) then
  begin
    Stream.Flush;
    Stream.Free;
    Stream:=Nil;
  end;

  with Response do
  begin
    if not assigned(Stream) then
      exit;
    if SplitString(Headers.Text,sLineBreak+sLineBreak,a1,a2) then
      a1:=a1+sLineBreak;
    Headers.Clear;
    //
    Self.Stream:=Stream;
    Stream.Flush;
    Stream:=Nil;
    Close;
    end;

  if temp='' then
    temp:=stream.name;

  with pWebApp do
  begin
    chForEach:=Expand(MacroStart + 'AsyncPageForEach' + MacroEnd);
    chTail:=Expand(MacroStart + 'AsyncPageTail' + MacroEnd);
    chDone:=Expand(MacroStart + 'AsyncPageDone' + MacroEnd);
    bAbort:=BoolVar['AsUnHookAbort'];

    a1:=a1
      +sLineBreak
      +Expand(MacroStart + 'AsyncPageTop' + MacroEnd);
    end;

  S8 := UTF8Encode(a1);
  CommOutBufferToMailBox(Stream.Name, '+', S8);
  InterLockedExchange(Integer(bStreaming),Integer(True));

  pWebApp.Save; //save before aborting the official page production
  raise eAbortPrimary.create(''); //process through eAbortPrimary
end;

//----------------------------------------------------------------------
//----------------------------------------------------------------------
//respond to being called by this surfer.
//the webaction has just decided on one of seven states..

//this procedure has been written with the different ways in which
//you may be wanting to use the component in mind. as such you will see
//several references to StringVars and dbfields which are used in the
//demonstration project - interwoven with SendMacro references as may
//be found in any project.

//uses sendmacro to communicate these states:
//AsyncNone
//AsyncPrior
//AsyncStarted
//AsyncBusy
//AsyncAborted
//AsyncFinished
//AsyncFailed

//the asyncstate is also available as string literal 'AsyncState'

procedure TdmAsyncDemo.SetAsyncState(Value:TAsyncState);
begin
  waAsyncAction.AsyncState:=Value;
  pWebApp.StringVar['AsyncState']:= copy(GetEnumName(TypeInfo(TAsyncState),ord(Value)),3,255);
end;

procedure TdmAsyncDemo.waAsyncActionExecute(Sender: TObject);
var
  i: Cardinal;
  a1,a2: string;

  function StartNewThread: Boolean;
  begin
    Result:=False;
    //in order to accomodate different examples we call StartNewThread
    //to start a new thread of the right type and with the right events.
    with pWebApp, waAsyncAction do
      //double check that the session is not already running a thread
      if FindSession(SessionID) then
        if SurfersObject.Done then
          SetAsyncState(asPrior)
        else
          SetAsyncState(asBusy)
      else begin
        //clear whatever last result we might have buffered for this session.
        if FindResult(SessionID,i) then begin
          SurfersObject.DeleteTask; //remove thread result
          SurfersObject:=nil;
          SurfersThread:=nil;
          end;

        //setup for the demos:
        ThreadOnInit:= ThreadInit;
        ThreadOnFinish:= ThreadFinish;
        ThreadOnDestroy:= ThreadDestroy;

        //see the notes on serializing to see how you can
        //integrate the generic worker thread mechanism provided
        //by htThread's global ThtBackgroundTaskThread into this
        //webapplication. The idea here is that no class is assigned
        //and that you will see how to use the whAsyncAction 
        //from the TwhAsyncObject above.
        if BoolVar['AsBg'] then
          ThreadClass:= nil
        else
          ThreadClass:= TwhAsyncThread;

        //look at the bottom of the unit for notes on
        //how to pass data to the thread using these events
        if StringVar['AsyncDemo']='Percent' then
          if BoolVar['AsInc'] then
            ThreadOnExecute:= ExecuteStepByStep
          else //'Percent complete'
            ThreadOnExecute:= ExecuteAsOneBlock
        else
          ThreadOnExecute:= ExecuteDosCmd;
        //go and let the async component take control.
        //it will recurse into this event to handle the
        //asStarted condition.
        Result:=True;
        SetAsyncState(asStarted);
        NewThread;
        end;
  end;

begin
  fmWhRequests.LogRequest(#9
    +pWebapp.SessionID
    +#9
    +copy(GetEnumName(TypeInfo(TAsyncState),ord(waAsyncAction.AsyncState)),3,255)
    );

  with pWebApp, waAsyncAction do begin
    //deal with commands send to waAsyncAction.
    //please note that waAsyncAction DOES NOT look at either its command
    //or htmlparam properies. It simply reports back one of FOUR states
    //(recursion that you get to trigger from below her in this proc
    //takes that up to the available SIX states, plus a SEVENTH state is
    //available on exit in case you're using this with an external buffer)
    //process commands sent to the component

    if IsIn('NewThread',Command,',')
    or (Request.dbFields.Values['@Start']<>'') then begin
      Command:='';
      Request.dbFields.Values['@Start']:='';
      StartNewThread; //will recurse here and call asStarted!
      exit;
      end;

    if assigned(SurfersObject) then
      with SurfersObject do
        if IsIn('Clear',Command,',')
        or (Request.dbFields.Values['@Clear']<>'') then begin
          Command:='';
          Request.dbFields.Values['@Clear']:='';
          DeleteTask; //remove thread result
          SurfersObject := nil;
          SurfersThread := nil;
          AsyncState := AsInit; // was AsNone until 18-Jun-2008
          end;

    //translate the state to a string for easy access
    SetAsyncState(AsyncState);
    //we did not get a command from the user (the normal and expected
    //condition) .. respond to the session's Async-State

    SplitTerms(HtmlParam, '|', a1, a2);
    if IsEqual(a1,'send') then
      Response.Send(a2)
    else
      case AsyncState of

           //waAsyncAction.SurfersThread is valid:

      asStarted:
          SendMacro('AsyncStarted');

      asAborted:
          if assigned(SurfersObject) then
            SendMacro('PARAMS|AsyncAborted|' //aborted but not done
              +inttostr(SurfersObject.PercentComplete));

         asBusy:
          if IsIn('Abort',Command,',')
          or (WebApp.Request.dbFields.Values['@Abort']<>'') then begin
            Command:='';
            Request.dbFields.Values['@Abort']:='';
            Aborted; //will recurse here and call asAborted!
            end
          else
            if assigned(SurfersObject) then
              with SurfersObject do begin
                if not done
                and assigned(Data)
                and (Data is TThreadInput)
                and assigned(TThreadInput(Data).Stream)
                and TThreadInput(Data).bStreaming
                then begin
                  if assigned(Thread) then
                    Thread.Suspend
                  else
                  if assigned(BackgroundTasks) then
                    BackgroundTasks.Suspend;
                  try
                    with tThreadInput(Data) do
                      TakeOver(Response);
                  finally
                    if assigned(Thread) then
                      Thread.Resume
                    else
                    if assigned(BackgroundTasks) then
                      BackgroundTasks.Resume;
                    end;
                  end
                else
                  SendMacro('PARAMS|AsyncBusy|'    //busy but not done
                   +inttostr(PercentComplete));
                end;

          //waAsyncAction.SurfersThread is not valid:

     asFinished: begin
          if assigned(SurfersObject) then begin
            StringVar['dyn1']:= SurfersObject.ResultString;
            SendMacro('AsyncFinished');
            StringVar['dyn1']:='';
            end;
          ResetFinished; //turns 'finished' into 'prior' result
          //without calling TwhAsynAction.ResetFinished, asPrior
          //is never generated.
          end;

        asPrior: begin
          if assigned(SurfersObject) then
            with SurfersObject do begin
              StringVar['dyn1']:=ResultString;
              StringVarInt['dyn2']:=ResultValue;
              SendMacro('AsyncPrior');
              StringVar['dyn1']:='';
              StringVar['dyn2']:='';
              end;
          end;

       asFailed: begin
          if assigned(SurfersObject) then
            with SurfersObject do begin
              StringVar['dyn1']:=ResultString;
              StringVarInt['dyn2']:=ResultValue;
              SendMacro('AsyncFailed');
              StringVar['dyn1']:='';
              StringVar['dyn2']:='';
              end;
          end;

          //no activity for the current surfer

         asInit: begin
          SendMacro('AsyncNone');
          end;
      end;
    end;
end;

//----------------------------------------------------------------------
//----------------------------------------------------------------------

procedure TdmAsyncDemo.ThreadInit(Sender: TObject);
begin
  //create and initialize the object's extra data-packet.
  if assigned(Sender)
  and (Sender is TwhAsyncObject) then
  with pWebApp, TwhAsyncObject(Sender) do begin
    Data:=TThreadInput.Create;
    TThreadInput(Data).DosCmd :=
      {$IFDEF UNICODE}
      UnicodeToAnsiCodePage(Expand(waAsyncAction.HtmlParam), 1252);
      {$ELSE}
      Expand(waAsyncAction.HtmlParam);
      {$ENDIF}

    if BoolVar['AsUnHook'] then
    begin
      SetAsyncState(asStarted);
      TThreadInput(Data).Takeover(Response);
    end;

    //might just set the resultstring here and ignore the data object!
    ResultString:='';
    end;
end;

procedure TdmAsyncDemo.ThreadFinish(Sender: TObject);
//called from a thread when an object becomes 'Done.'
//the TwhAsyncObject stays around, but we now need to
//call the Finished method to close & free the output
//which may still be connecting us to the current surfer
//if the output stream had been unhooked and output was
//sent asynchronously.
//
//Please notice that _all_ logic revolving around keeping
//an output stream open is contained in this unit's implementation
//of the TThreadInput class!
//
begin
  if assigned(Sender)
  and (Sender is TwhAsyncObject) then
  with TwhAsyncObject(Sender) do begin
    if (data<>nil)
    and (data is TThreadInput) then
      TThreadInput(Data).Finished(ResultString);
    end;
end;

procedure TdmAsyncDemo.ThreadDestroy(Sender: TObject);
//the worker object is about to be destroyed, free the
//data object.
begin
  if assigned(Sender)
  and (Sender is TwhAsyncObject) then
  with TwhAsyncObject(Sender) do begin
    Data.Free;
    Data:=nil;
    end;
end;

//----------------------------------------------------------------------
//----------------------------------------------------------------------
//execute methods doing asyn work for the surfer

//----------------------------------------------------------------------
//Execute example retrieves DOS output and preps it for the web.

procedure TdmAsyncDemo.ExecuteDosCmd(Sender: TObject);
var
  aa: AnsiString;
  a1: string;
  ErrorCode: Integer;
begin
  if assigned(Sender)
  and (Sender is TwhAsyncObject) then
  with TwhAsyncObject(Sender) do
    if not Done then
    begin
      try
        if assigned(Data) then
          with TThreadInput(Data) do
          begin
            aa:= GetDosOutputA(DosCmd, GetAnsiStrProc, ErrorCode);
            {$IFDEF UNICODE}
            a1 := AnsiCodePageToUnicode(aa, 1252);
            {$ELSE}
            a1 := aa;
            {$ENDIF}
          end
        else
        begin
          aa := GetDosOutputA(AnsiString(ResultString), nil, ErrorCode);
          {$IFDEF UNICODE}
          a1 := AnsiCodePageToUnicode(aa, 1252);
          {$ELSE}
          a1 := aa;
          {$ENDIF}
        end;
      except on E: Exception do
      begin
        ResultValue := -1;
        a1 := E.Message;
      end;
    end;
    StringRepl(a1, sLineBreak, '<brx>');
    StringRepl(a1, '<brx><brx>', '<brx>&nbsp;<brx>');
    StringRepl(a1, '<brx>', '<br />'#13#10);
    ResultString := a1;
    Done := True;
  end;
end;

//----------------------------------------------------------------------
//Execute example counting from 0..100% complete in 10 seconds.
//(not intended for use with a background thread! -- this will block
//everyone else scheduled in the background while running!)

procedure TdmAsyncDemo.ExecuteAsOneBlock(Sender: TObject);
var
  i:integer;
begin
  if assigned(Sender)
  and (Sender is TwhAsyncObject) then
  with TwhAsyncObject(Sender) do try
    for i:=1 to 100 do                    //notice the FOR LOOP
      if not Done then begin
        //do nothing..
        Sleep(100);
        PercentComplete:=i;
        if (data<>nil)
        and not Aborted
        and not TThreadInput(Data).SendUpdate(PercentComplete) then
          Aborted:=True; //important! do not reset the flag by accident!
        end;
    //TThreadInput(TwhAsyncObject(Sender).Data).Stream.Text
    if not Aborted then
      ResultString:='OK! Here is your random #: '+floattostr(random);
    Done:=True;
  except
    //make up an error code.
    ResultValue:=(1+Random(10));
    end;
end;

//----------------------------------------------------------------------
//Execute example, starting with 0% done increments the completion %
//each time called. at 100% it signals completion.

procedure TdmAsyncDemo.ExecuteSynchronized(Sender:TObject);
begin
  with TwhAsyncObject(Sender) do
    if not Aborted then begin
      ResultString:='OK! Here is your random #: '+floattostr(random);
      Done:=True;
      end;
end;

procedure TdmAsyncDemo.ExecuteStepByStep(Sender:TObject);
//to make integrating StringVars and webaction output that depends
//on answers gotten by the async thread processing a possibility,
//this execute method shows how to trigger the ExecuteSynchronized
//procedure shown above
begin
  with TwhAsyncObject(Sender) do
    if Done then
      Synchronized:= False
    else
    if not Aborted then
      if (PercentComplete=100) then begin
        if not Synchronizing
        and not Synchronized then
          //setting OnSynchronized activates a SECOND background thread.
          //this background thread will synchronize the event we are
          //assigning to the object here. It will execute that event once
          //before resetting OnSynchronized to nil. Assigning this event
          //will take-over the Synchronized and Synchronizing properties
          //to insure the thread safe execution of ExecuteSynchronized.
          OnSynchronized:= ExecuteSynchronized;
        end
      else begin
        //do nothing..
        Sleep(100);
        PercentComplete:=PercentComplete+1;
        //
        if (data<>nil)
        and not Aborted
        and not TThreadInput(Data).SendUpdate(PercentComplete) then
          Aborted:=True; //important! do not reset the flag by accident!
        end;
end;

//----------------------------------------------------------------------
//----------------------------------------------------------------------

initialization
end.
