unit TestLiteDemos_fmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    memoLog: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Timer1: TTimer;
    Label1: TLabel;
    editStartOn: TEdit;
    Label2: TLabel;
    editThreads: TEdit;
    Label3: TLabel;
    editDuration: TEdit;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TMyThread = class(TThread)
  private
    m_id: integer;
  protected
    procedure Execute; override;
  public
    constructor Create(id: integer);
  end;

var
  Form1: TForm1;

implementation

uses
  DateUtils,
  uISelenium, uDefaultSelenium;

{$R *.dfm}

procedure Log(s: string);
begin
  Form1.memoLog.Lines.Add(s + sLineBreak);
end;

const
  selenium_server: string = 'localhost';
  selenium_server_port: integer = 5555;
  test_url: string = 'http://demos.href.com/';
  browser: string = '*firefox';

procedure TForm1.Button1Click(Sender: TObject);
var
  selenium: ISelenium;
begin
  Log('Start......');
  try
    selenium := DefaultSelenium.Create(selenium_server, selenium_server_port, browser, test_url);
    selenium.Start();
    selenium.Open('/scripts/runisa.dll?adv:speed::');
    selenium.Click('link=Start Animation');
    selenium.WaitForPageToLoad('60000');
    selenium.Click('link=Stop Animation');
    selenium.WaitForPageToLoad('60000');
    selenium.Stop();
  except
    on E: Exception do
      Log('Exception: ' + e.Message);
  end;
  Log('End.');
end;

var
  startOn: TDateTime;
  threadCount: integer;
  duration: integer;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Log('Start......');

  try
    startOn := Today;
    startOn := IncHour(startOn, StrToInt(Copy(editStartOn.Text, 1, 2)));
    startOn := IncMinute(startOn, StrToInt(Copy(editStartOn.Text, 4, 2)));
    startOn := IncSecond(startOn, StrToInt(Copy(editStartOn.Text, 7, 2)));
    threadCount := StrToInt(editThreads.Text);
    duration := StrToInt(editDuration.Text);
  except
    Log('Invalid parameters!');
    exit;
  end;

  Log('Selenium test case will start on ' + DateTimeToStr(startOn) + ' ......');
  Timer1.Interval := 1000;
  Timer1.Enabled := true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i: integer;
  thread : TMyThread;
begin
  if (Now < startOn) then
    exit;
  timer1.Enabled := false;
  Log('Selenium test case start......');
  for i := 0 to threadCount - 1 do
  begin
      thread := TMyThread.Create(i);
      thread.FreeOnTerminate := True;
      thread.Resume;
  end;
end;

constructor TMyThread.Create(id: integer);
begin
  inherited Create(true);
  m_id := id;
end;

procedure TMyThread.Execute;
var
  selenium: ISelenium;
begin
  Log(Format('Selenium instance [%d] started......', [m_id]));
  selenium := nil;
  try
    selenium := DefaultSelenium.Create(selenium_server, selenium_server_port, browser, test_url);
    selenium.Start();
    Log(Format('Selenium instance [%d]: %s', [m_id, 'open /scripts/runisa.dll?adv:speed::']));
    selenium.Open('/scripts/runisa.dll?adv:speed::');
    Log(Format('Selenium instance [%d]: %s', [m_id, 'click "Start Animation"']));
    selenium.Click('link=Start Animation');
    Log(Format('Selenium instance [%d]: %s', [m_id, 'wait ' + IntToStr(duration) + 'seconds']));
    Sleep(duration * 1000);
    Log(Format('Selenium instance [%d]: %s', [m_id, 'click "Stop Animation"']));
    selenium.Click('link=Stop Animation');
    selenium.WaitForPageToLoad('60000');
    Sleep(3000);
    Log(Format('Selenium instance [%d]: %s', [m_id, 'close instance']));
    selenium.Stop();
  except
    on E: Exception do
      Log('Exception: ' + e.Message);
  end;
  Log(Format('Selenium instance [%d]: stopped.', [m_id]));
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  selenium: ISelenium;
begin
  Log('Start......');
  try
    selenium := DefaultSelenium.Create('localhost', 5555, '*firefox',
      'http://demos.href.com/');
    selenium.Start();
    selenium.Open('/showcase::1204');

    selenium.Click('//div[@id=''menuThisWebHubDemo'']/ul/li[2]/a');
    selenium.WaitForPageToLoad('3000');

    Log('---Star:1.Easier HTML......');
    selenium.Click('link=Easier HTML');
    selenium.WaitForPageToLoad('3000');

    Log('---1.1......');
    selenium.Click('//img[@alt=''Down'']');
    selenium.WaitForPageToLoad('90000');

    Log('---1.1.1......');
    selenium.Click('//img[@alt=''Down'']');
    selenium.WaitForPageToLoad('90000');

    //selenium.Stop();
  except
    on E: Exception do
      Log(Format('Exception: %s', [e.Message]));
  end;
  Log('End.');
end;

end.

