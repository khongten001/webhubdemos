unit uPerformanceTest;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
    TOnMessageEvent = procedure(s : string) of object;

    TWorkThread = class(TThread)
    private
        FOnMessage : TOnMessageEvent;
    protected
        procedure Execute; override;
    public
        constructor Create();
        destructor Destroy(); override;
        procedure Stop();

        property OnMessage : TOnMessageEvent
            read FOnMessage write FOnMessage;
    end;

    TPerformanceTest = class(TObject)
    private
        FTimer : TTimer;
        FWorkThread : TWorkThread;
        FOnMessage : TOnMessageEvent;
        procedure OnTimer(Sender: TObject);
        procedure OnThreadMessage(s : String);
        procedure Debug(s : String);
    public
        constructor Create();
        destructor Destroy(); override;
        procedure Start();
        procedure Stop();
        property OnMessage : TOnMessageEvent
            read FOnMessage write FOnMessage;
    end;

implementation

//*************************************************
//***              TWorkThread           ***
//*************************************************
constructor TWorkThread.Create();
begin
  FreeOnTerminate := false;
  inherited Create(true);
end;

destructor TWorkThread.Destroy();
begin
  inherited Destroy();
end;

procedure TWorkThread.Stop();
begin
    Terminate();
end;

//procedure TWorkThread.AccessVcl(s : string);
//begin
//    FStringToWrite := s;
//    Synchronize(DoAccessVcl);
//end;

//procedure TWorkThread.DoAccessVcl;
//begin
//    access vcl component
//    Form1.Memo1.Lines.Add(FStringToWrite);
//end;

//procedure TWorkThread.Debug(s : String);
//begin
//    if Assigned(FOnDebugInfo) then FOnDebugInfo(s);
//end;

procedure TWorkThread.Execute;
var
    ovResult, ovData, ovEmpty: OleVariant;
    s : string;
begin
    while(true)do
        begin
        if Terminated then exit;
        //Debug('execute : ' + FUrl);

        //Debug('terminate.');
        Suspend();
        end;
end;


//*************************************************
//***              TPerformanceTest           ***
//*************************************************
constructor TPerformanceTest.Create();
begin
  inherited Create();

  FWorkThread := TWorkThread.Create();
  FWorkThread.Priority := tpNormal;
  FWorkThread.OnMessage := OnThreadMessage;

  FTimer := TTimer.Create(nil);
  FTimer.Interval := 1000;
  FTimer.OnTimer := OnTimer;
  FTimer.Enabled := false;
end;

destructor TPerformanceTest.Destroy();
begin
  FTimer.Enabled := false;
  FWorkThread.Stop();
  FWorkThread.Free;
  inherited Destroy();
end;

procedure TPerformanceTest.Start();
begin
  FTimer.Enabled := true;
end;

procedure TPerformanceTest.Stop();
begin
  FTimer.Enabled := false;
end;

procedure TPerformanceTest.Debug(s : String);
begin
    if Assigned(FOnMessage) then FOnMessage(s);
end;

procedure TPerformanceTest.OnThreadMessage(s : String);
begin
    Debug(s);
end;

procedure TPerformanceTest.OnTimer(Sender: TObject);
begin
    if FWorkThread.Suspended then
        begin
        FWorkThread.Resume;
        end;
end;

end.
