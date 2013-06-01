unit SimpleDm;
(*
  Copyright (c) 1999 HREF Tools Corp.
  Original Author: Michael Ax

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


{ Example of WebHub background processing with dedicated threads
  not shown in SimpleDM.pas:
  - using a shared background thread
  - using a temporary data object .. although the hookups are shown
  - keeping the connection to the surfer open
  - aborting when the surfer switches away from the open page }

interface

uses
  SysUtils, Classes,
  tpAction, updateOK,
  webTypes, webLink, whAsync;

type
  TdmSimpleAsync = class(TDatamodule)
    waAsyncSimple1: TwhAsyncAction;
    procedure waAsyncSimple1Execute(Sender: TObject);
    procedure waAsyncSimple1ThreadOnInit(Sender: TObject);
    procedure waAsyncSimple1ThreadOnDestroy(Sender: TObject);
    procedure waAsyncSimple1ThreadOnExecute(Sender: TObject);
  private
    procedure SetAsyncState(Value: TAsyncState);
  public
  end;

var
  dmSimpleAsync: TdmSimpleAsync;

implementation

{$R *.DFM}

uses
{$IFDEF CodeSite}CodeSiteLogging, {$ENDIF}
  TypInfo, // for translating the Async-state into a literal
  Math, // integer helpers (min/max)
  webApp, // for access to pWebApp in the thread's constructor
  ucString; // string functions (IsIn...)


procedure TdmSimpleAsync.SetAsyncState(Value: TAsyncState);
begin
{ private helper method to map the async state into a WebHub StringVar.
  also used to change the reported state for convenience when canceling.}
  waAsyncSimple1.AsyncState := Value;
  pWebApp.StringVar['AsyncState'] :=
    Copy(GetEnumName(TypeInfo(TAsyncState), ord(Value)), 3, 255);
{$IFDEF CodeSite}CodeSite.Send('TdmSimpleAsync.SetAsyncState', pWebApp.StringVar['AsyncState']); {$ENDIF}
end;

// ..the code to drive the async activities..

procedure TdmSimpleAsync.waAsyncSimple1Execute(Sender: TObject);
const
  cFn = 'waAsyncSimple1Execute';
var
  i: Cardinal;

  function StartNewThread: Boolean;
  const
    cFn = 'StartNewThread';
  begin
{$IFDEF CodeSite}CodeSite.EnterMethod(cFn); {$ENDIF}
    Result := False;
    with waAsyncSimple1 do
      // double check that the session is not already running a thread
      if FindSession(pWebApp.SessionID) then
        if SurfersObject.Done then
          SetAsyncState(asPrior)
        else
          SetAsyncState(asBusy)
      else
      begin
        // clear whatever last result we might have buffered for this session.
        if FindResult(pWebApp.SessionID, i) then
        begin
          SurfersObject.DeleteTask; // remove thread result
          SurfersObject := nil;
          SurfersThread := nil;
        end;
        Result := True;
        SetAsyncState(asStarted);
        NewThread;
      end;
{$IFDEF CodeSite}CodeSite.ExitMethod(cFn); {$ENDIF}
  end;

begin
{$IFDEF CodeSite}CodeSite.EnterMethod(cFn); {$ENDIF}
  with pWebApp, TwhAsyncAction(Sender) do
  begin
    // deal with commands sent to waAsyncAction.
    // please note that waAsyncAction DOES NOT look at either its command
    // or htmlparam properies. It simply reports back one of FOUR states
    // (recursion that you get to trigger from below here in this proc
    // takes that up to the available SIX states, plus a SEVENTH state is
    // available on exit in case you are using this with an external buffer)
    // process commands sent to the component

    if (AsyncState = asInit) and IsIn('NewThread', pWebApp.Command, ',') then
    begin
      Command := '';
      StartNewThread; // will recurse here and call asStarted!
{$IFDEF CodeSite}CodeSite.ExitMethod(cFn); {$ENDIF}
      Exit;
    end;

    if { assigned(SurfersObject)
      and } (AsyncState in [asBusy, asFinished, asPrior, asAborted, asFailed])
      and IsIn('ClearThread', pWebApp.Command, ',') then
    begin
      pWebApp.RemoveCommandPortion := 'ClearThread';
      // elim part(or all) of url supplied commandline
      if AsyncState = asBusy then
      begin
        if assigned(SurfersObject) then
          SurfersObject.Aborted := True;
{$IFDEF CodeSite}CodeSite.ExitMethod(cFn); {$ENDIF}
        Exit;
      end
      else
      begin
        if assigned(SurfersObject) then
        begin
          with SurfersObject do
          begin
            DeleteTask; // remove thread result
            SurfersObject := nil;
            SurfersThread := nil;
          end;
        end;
        SetAsyncState(asInit);
      end;
    end;

    // translate the state to a literal for easy access
    SetAsyncState(AsyncState);

    // prep temporary StringVars
    if assigned(SurfersObject) then
      with SurfersObject do
      begin
        if (AsyncState in [asFinished, asPrior, asAborted, asFailed]) then
        begin
          { It is safe to access these session properties now that there is no
             more activity by the async object. Do not access while
             asBusy/asStarted! }
          // StringVar['dyn1']:=ResultString;  // AML
          StringVar['asResultString'] := ResultString;
          // StringVarInt['dyn2']:=ResultValue;    // AML
          StringVarInt['asResultInteger'] := ResultValue;
        end;
        { PercentComplete and Time* properties are always threadsafe. }
        { StringVarInt['dyn3']:=PercentComplete;
          StringVarInt['dyn4']:=TimeElapsed;
          StringVarInt['dyn5']:=TimeRemaining; }
        StringVarInt['asResultPercentDone'] := PercentComplete;
        StringVarInt['asResultTimeElapsed'] := TimeElapsed;
        StringVarInt['asResultTimeRemaining'] := TimeRemaining;
      end;

    case AsyncState of
      asInit:
        SendMacro('CLEAR|asResult*'); // Demo1AsyncNone');
      asStarted:
        SendMacro('Demo1AsyncStarted');
      asBusy:
        begin
          //This is called frequently. One could send a WebHub droplet here.
          {$IFDEF CodeSite}CodeSite.Send('AsyncState', 'asBusy');{$ENDIF}
        end;
      asFinished:
        begin
          //SendMacro('Demo1AsyncFinished');
          {$IFDEF CodeSite}CodeSite.SendWarning('asFinished!');{$ENDIF}
        end;
      asPrior:
        SendMacro('Demo1AsyncPrior');
      asAborted:
        SendMacro('Demo1AsyncAborted');
      asFailed:
        SendMacro('Demo1AsyncFailed');
    end;

  end;
{$IFDEF CodeSite}CodeSite.ExitMethod(cFn); {$ENDIF}
end;

// ..three procedures to init, run and finish async operations.

procedure TdmSimpleAsync.waAsyncSimple1ThreadOnInit(Sender: TObject);
const
  cFn = 'waAsyncSimple1ThreadOnInit';
  // runs from the main-thread with Session set for the right surfer!
var
  S: string;
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(cFn); {$ENDIF}
  inherited;
  // create and initialize the object's extra data-packet.
  if assigned(Sender) and (Sender is TwhAsyncObject) then
    with TwhAsyncObject(Sender) do
    begin
      Done := False;
      // set the resultstring property here to provide input to the object
      S := pWebApp.Expand(waAsyncSimple1.HtmlParam);
      {$IFDEF CodeSite}CodeSite.Send('waAsyncSimple1.HtmlParam',
        waAsyncSimple1.HtmlParam); {$ENDIF}
      ResultString := S;
      { If you want to create a data/input object for use by the thread
        you should probably instantiate and initialize it here, e.g.
         Data:=TThreadInput.Create;
         TThreadInput(Data).urlstr:=Expand(..); }
    end;
{$IFDEF CodeSite}CodeSite.ExitMethod(cFn); {$ENDIF}
end;

procedure TdmSimpleAsync.waAsyncSimple1ThreadOnExecute(Sender: TObject);
const
  cFn = 'waAsyncSimple1ThreadOnExecute';
  // runs in its own thread.. sessions change in the main thread
  // as pages are served there.
  // NEVER access StringVars and other session properties from here!
var
  i, SleepTime: integer;
  a1, a2: string;
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(cFn); {$ENDIF}
  inherited;
  with TwhAsyncObject(Sender) do
  begin
    { Earlier, htmlparam was expanded into ResultString. Now
      parse it into substrings that we use below:
      We expect the following format, with 2nd parameter being optional:
      TimeToSleepInSeconds|FinalTextForResultString
      this might be provided from wh-html like this:
      %=waAsyncSimple1.execute|%=SleepMS=%|The Answer is [%=UserName=%]!=%
      expanding the htmlparm into resulttext might result in:
      %=waAsyncSimple1.execute|5|The Answer is [(your name)]!=% }

    {$IFDEF CodeSite}CodeSite.Send('ResultString', ResultString); {$ENDIF}
    a1 := LeftOfS('|', ResultString);
    {$IFDEF CodeSite}CodeSite.Send('a1', a1); {$ENDIF}

    SleepTime := StrToIntDef(a1, 5); // if blank or not a number, make it 5sec
    SleepTime := Math.Max(1, Math.Min(100, SleepTime));
    // fit into bounds of >=1sec, <=100sec
    SleepTime := SleepTime * (1000 div 100);
    {$IFDEF CodeSite}CodeSite.Send('SleepTime (for 100x)', SleepTime); {$ENDIF}

    // convert to ms to wait per percent complete
    //
    // no reason not to create a data-object here if you can pass all the
    // init info into here through the ResultString/ResultValues properties.
    // do a 'blocking' loop to simulate work..
    for i := 1 to 100 do
    if not Aborted then
    begin
      PercentComplete := i;
      Sleep(SleepTime); // takes from +0..25% msec
    end;
    // on the way out, if not aborted, make up a result
    if not Aborted then
    begin
      // store the answer here:
      ResultString := DefaultsTo(a2, 'Done!'); // return 'something' if a2=''
      ResultValue := 0;
      Done := True;
    end;
    // YOU MUST SET DONE (or Aborted, or raise an exception) to indicate
    // the the thread servicing this event can stop calling it!
  end;
{$IFDEF CodeSite}CodeSite.ExitMethod(cFn); {$ENDIF}
end;

procedure TdmSimpleAsync.waAsyncSimple1ThreadOnDestroy(Sender: TObject);
const
  cFn = 'waAsyncSimple1ThreadOnDestroy';
  // runs in its own thread
  // the worker object is about to be destroyed by 'DeleteTask' which
  // is called by you or the background house-cleaning task.
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(cFn); {$ENDIF}
  inherited;
  if assigned(Sender) and (Sender is TwhAsyncObject) then
    with TwhAsyncObject(Sender) do
      // if there is a data object, free it here/now.
      if assigned(Data) then
      begin
        Data.Free;
        Data := nil;
      end;
{$IFDEF CodeSite}CodeSite.ExitMethod(cFn); {$ENDIF}
end;

end.