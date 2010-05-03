unit SimpleDm;
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

////////////////////////////////////////////////////////////////////////
{ Example of WebHub background processing with dedicated threads
not shown:
using a shared background thread
using a temporary data object .. although the hookups are shown
keeping the connection to the surfer open
aborting when the surfer switches away from the open page
..see the demo provided with the ht+ pack for a guide to the full
featureset provided with the component.
//
this bare bones demo is a work in progress. last updated 6/16/99 m.ax
{}
////////////////////////////////////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UTPANFRM, ExtCtrls, StdCtrls, UpdateOk, tpAction, IniLink,
  Toolbar, Restorer, ComCtrls, tpStatus, WebTypes, WebLink,
  whAsync;

type
  TdmSimpleAsync = class(TDatamodule)
    waAsyncSimple1: TwhAsyncAction;
    procedure waAsyncSimple1Execute(Sender: TObject);
    procedure waAsyncSimple1ThreadOnInit(Sender: TObject);
    procedure waAsyncSimple1ThreadOnDestroy(Sender: TObject);
    procedure waAsyncSimple1ThreadOnExecute(Sender: TObject);
  private
    procedure SetAsyncState(Value:TAsyncState);
  public
    end;

var
  dmSimpleAsync: TdmSimpleAsync;

implementation

{$R *.DFM}

uses
  TypInfo,   // for translating the Async-state into a literal
  Math,      // integer helpers (min/max)
  WebApp,    // for access to pWebApp in the thread's constructor
  ucString;  // string functions (IsIn...)

//..private helper method to map the async state into a wh-literal.
//also used to change the reported state for convenience when canceling.

procedure TdmSimpleAsync.SetAsyncState(Value:TAsyncState);
begin
  waAsyncSimple1.AsyncState:=Value;
  pWebApp.StringVar['AsyncState']:= copy(GetEnumName(TypeInfo(TAsyncState),ord(Value)),3,255);
end;

//..the code to drive the async activities..

procedure TdmSimpleAsync.waAsyncSimple1Execute(Sender: TObject);
var
  i: Cardinal;

  function StartNewThread: Boolean;
  begin
    Result:=False;
    with waAsyncSimple1 do
      //double check that the session is not already running a thread
      if FindSession(pWebapp.SessionID) then
        if SurfersObject.Done then
          SetAsyncState(asPrior)
        else
          SetAsyncState(asBusy)
      else begin
        //clear whatever last result we might have buffered for this session.
        if FindResult(pWebapp.SessionID,i) then begin
          SurfersObject.DeleteTask; //remove thread result
          SurfersObject:=nil;
          SurfersThread:=nil;
          end;
        Result:=True;
        SetAsyncState(asStarted);
        NewThread;
        end;
  end;

begin
  with pWebApp, waAsyncSimple1 do begin
    //deal with commands sent to waAsyncAction.
    //please note that waAsyncAction DOES NOT look at either its command
    //or htmlparam properies. It simply reports back one of FOUR states
    //(recursion that you get to trigger from below her in this proc
    //takes that up to the available SIX states, plus a SEVENTH state is
    //available on exit in case you're using this with an external buffer)
    //process commands sent to the component

    if (AsyncState = asInit)
    and IsIn('NewThread',pWebApp.Command,',') then begin
      Command:='';
      StartNewThread; //will recurse here and call asStarted!
      exit;
      end;

    if {assigned(SurfersObject)
    and }(AsyncState in [asBusy,asFinished,asPrior,asAborted,asFailed])
    and IsIn('ClearThread',pWebApp.Command,',') then
    begin
      pWebApp.RemoveCommandPortion:='ClearThread'; //elim part(or all) of url supplied commandline
      if AsyncState=asBusy then
      begin
        if assigned(SurfersObject) then
          SurfersObject.Aborted:=True;
        exit;
      end
      else
      begin
        if assigned(SurfersObject) then
        begin
          with SurfersObject do
          begin
            DeleteTask; //remove thread result
            SurfersObject:=nil;
            SurfersThread:=nil;
          end;
        end;
        SetAsyncState(AsInit);
      end;
    end;

    //translate the state to a literal for easy access
    SetAsyncState(AsyncState);

    //prep temporary StringVars
    if assigned(SurfersObject) then
      with SurfersObject do begin
        if (AsyncState in [asFinished,asPrior,asAborted,asFailed]) then begin
          //it is safe to access these propertyes now that there is no more
          //activity by the async object.. do not access while asBusy/asStarted!
          //StringVar['dyn1']:=ResultString;  // AML
          StringVar['asResultString'] := ResultString;
          //StringVarInt['dyn2']:=ResultValue;    // AML
          StringVarInt['asResultInteger'] := ResultValue;
          end;
        //PercentComplete and Time* are always threadsafe.
        {StringVarInt['dyn3']:=PercentComplete;
        StringVarInt['dyn4']:=TimeElapsed;
        StringVarInt['dyn5']:=TimeRemaining;}
        StringVarInt['asResultPercentDone'] := PercentComplete;
        StringVarInt['asResultTimeElapsed']:=TimeElapsed;
        StringVarInt['asResultTimeRemaining']:=TimeRemaining;
        end;

    //might rename the macros/chunks to match the contents of
    //StringVar['AsyncState'] in the next iteration.
    case AsyncState of
      AsInit:     SendMacro('CLEAR|asResult*');  // Demo1AsyncNone');
      asStarted:  SendMacro('Demo1AsyncStarted');
      //asBusy:     SendMacro('Demo1AsyncBusy');
      //asFinished: SendMacro('Demo1AsyncFinished');
      asPrior:    SendMacro('Demo1AsyncPrior');
      asAborted:  SendMacro('Demo1AsyncAborted');
      asFailed:   SendMacro('Demo1AsyncFailed');
      end;

    end;
end;

//..three procedures to init, run and finish async operations.

procedure TdmSimpleAsync.waAsyncSimple1ThreadOnInit(Sender: TObject);
//runs from the main-thread with Session set for the right surfer!
var
  S8: System.UTF8String;
begin
  inherited;
  //create and initialize the object's extra data-packet.
  if assigned(Sender)
  and (Sender is TwhAsyncObject) then
  with TwhAsyncObject(Sender) do
  begin
    Done := False;
    //set the resultstring property here to provide input to the object
    S8 :=
      pWebApp.Expand(UTF8String(System.UTF8ToString(RawByteString(waAsyncSimple1.HtmlParam))));
    ResultString := UTF8ToString(S8);
    //if you want to create a data/input object for use by the thread
    //you'd probably instantiate and initialize it here
    //Data:=TThreadInput.Create;
    //TThreadInput(Data).urlstr:=Expand(..);
  end;
end;

procedure TdmSimpleAsync.waAsyncSimple1ThreadOnExecute(Sender: TObject);
//runs in its own thread.. sessions change in the main thread
//as pages are served there. do not access StringVars etc from here!
var
  i,SleepTime:integer;
  a1,a2:string;
begin
  inherited;
  with TwhAsyncObject(Sender) do begin
    // on entry htmlparam has been expanded into ResultString. lets now
    // parse it into substrings that we use below:
    // we expect the following format:
    //  TimeToSleepInSeconds|FinalTextForResultString
    // this might be provided from wh-html like this:
    //  %=waAsyncSimple1.execute|%=SleepMS=%|The Answer is [%=UserName=%]!=%
    // expanding the htmlparm into resulttext might result in:
    //  %=waAsyncSimple1.execute|5|The Answer is [(your name)]!=%
    // lets set up the vars now:

    //if not splitstring(ResultString,'|',a1,a2) then //one or no parameters
    //  ExchangeStrings(a1,a2);
    a1 := ResultString;

    SleepTime:=StrToIntDef(a1,5); //if blank or not a number, make it 5sec
    SleepTime:=Math.Max(1,Math.Min(100,SleepTime)); //fit into bounds of >=1sec, <=100sec
    SleepTime:=SleepTime*(1000 div 100); //convert to ms to wait per percent complete
    //
    //no reason not to create a data-object here if you can pass all the
    //init info into here through the ResultString/ResultValues properties.
    //do a 'blocking' loop to simulate work..
    for i:=1 to 100 do
      if not Aborted then begin
        PercentComplete:=i;
        sleep(SleepTime); //takes from +0..25% msec
        end;
    //on the way out, if not aborted, make up a result
    if not Aborted then begin
      //store the answer here:
      ResultString:= DefaultsTo(a2,'Done!'); //return 'something' if a2=''
      Done:= True;
      end;
    //YOU MUST SET DONE (or Aborted, or raise an exception) to indicate
    //the the thread servicing this event can stop calling it!
    end;
end;

procedure TdmSimpleAsync.waAsyncSimple1ThreadOnDestroy(Sender: TObject);
//runs in its own thread
//the worker object is about to be destroyed by 'DeleteTask' which
//is called by you or the background house-cleaning task.
begin
  inherited;
  if assigned(Sender)
  and (Sender is TwhAsyncObject) then
  with TwhAsyncObject(Sender) do
    //if there is a data object, free it here/now.
    if assigned(Data) then
    begin
      Data.Free;
      Data:=nil;
    end;
end;

end.
