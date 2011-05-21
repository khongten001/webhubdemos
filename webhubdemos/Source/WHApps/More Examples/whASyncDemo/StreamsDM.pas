unit StreamsDM;
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

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UpdateOk, tpAction, WebTypes,   WebLink;

type
  TdmStreams = class(TDataModule)
    waDocStreams: TwhWebActionEx;
    procedure waDocStreamsExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmStreams: TdmStreams;

implementation

{$R *.DFM}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webApp,    //pWebApp
  whMacros,  //SplitTerms()
  ucString,  //isEqual()
  whAsync,   //Task globals
  htStrWWW;  //Stream globals

{Task globals: maintained by TwhAsyncObject in whAsync.pas:
       ActiveTasks - # of asyn actions currently under way (in dedicated or bg thread)
          MaxTasks - # maximum number of a concurrent activities performed in the past (since the exe started)
    TasksAttempted - how many async activities were started since the exe started
     TasksFinished - how many async activities were neither aborted nor exited with exceptions.}

{Stream globals: maintained by TwhResponseStream in htStrWWW.pas:
     activestreams - # of currently active macro expansion streams.
        maxstreams - maximum number of nested/stacked streams (the parser recurses into new streams as needed)
gcStreamDepthLimit - CAPACITY that the system will PRE-ALLOCATE for macro
                     expansion stream objects (pre-allocation takes place
                     for the object controlling the stream, not the stream
                     data itself fwiw, and its an execution time-saver.
                     TO CHANGE the capacity limit, change gcStreamDepthLimit
                     when activestreams is zero. gcStreamDepthLimit defaults
                     to 100 and represents THE ONLY limit to concurrent
                     'disconnected' streams in the system at this time.}

//%=waDocStreams.execute|Streams|Streams: [Active:%=dyn1=% Max:%=dyn2=% Cap:%=dyn3=%]=%
//%=waDocStreams.execute|Tasks|Tasks: [Active:%=dyn1=% Max:%=dyn2=% Total:%=dyn3=% Finished:%=dyn4=%]=%

procedure TdmStreams.waDocStreamsExecute(Sender: TObject);
const cFn = 'waDocStreamsExecute';
var
  a1,a2: string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(cFn);
  CodeSite.Send('HtmlParam', TwhWebActionEx(Sender).HtmlParam);
  {$ENDIF}
  with pWebApp, TwhWebActionEx(Sender) do
  begin
    SplitTerms(HtmlParam,'|',a1,a2);
    Macros.Values[Name] := a2;      //Create the macro used in Parameterize
    if isEqual(a1,'Streams') then // (the macro is not cleared as we intend to re-use the array entry (the macro name) often)
      Parameterize(Name,'dyn',    //syntax: macro to parameterize, paramname, parameters
        Format('%d,%d,%d',[activestreams,maxstreams,gcStreamDepthLimit]))
    else
    if isEqual(a1,'Tasks') then
      Parameterize(Name,'dyn',
        Format('%d,%d,%d,%d',[ActiveTasks,MaxTasks,TasksAttempted,TasksFinished]))
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(cFn);{$ENDIF}
end;

end.
