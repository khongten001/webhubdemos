unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  uISelenium_1_0_3, uDefaultSelenium_1_0_3;

type
  TForm1 = class(TForm)
    memoLog: TMemo;
    Panel1: TPanel;
    btnTestA: TButton;
    btnTest: TButton;
    btnTestB: TButton;
    btnStop: TButton;
    Button1: TButton;
    Button2: TButton;
    procedure btnTestAClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

uses
  ucLogFil,
  uSeleniumShared;

{$R *.dfm}

procedure Log(const s: string);
begin
  HREFTestLog('info', '', S);
  Form1.memoLog.Lines.Add(DateTimeToStr(Now()) + ': ' + s + #13);
  Application.ProcessMessages;
end;

procedure SaveText(const filename: string; const content: UTF8String);
begin
  UTF8StringWriteToFile(filename, content);
end;

var
  flagStop : boolean;

procedure TForm1.btnTestAClick(Sender: TObject);
var
  LogContents: string;
begin
  Log('Start......');

  selenium_server := 'localhost'; //'nexthelp.webhub.com'
  selenium_server_port := 5555; //4444

  try
    try
      //string[] files = Directory.GetFiles(log_path + "a');
      //for (int i = 0; i < files.Length; i++)
      //    File.Delete(files[i]);
      //files = Directory.GetFiles(log_path + "b');
      //for (int i = 0; i < files.Length; i++)
      //    File.Delete(files[i]);

      if SameText(TButton(Sender).Caption, 'test a') then
      begin
        currentTestID := 'a';
        currectBaseUrl := 'http://demos.href.com/';
        currentLogPath := ExtractFilePath(Application.ExeName) + 'showcase_result_a\';
      end
      else
      begin
        currentTestID := 'b';
        currectBaseUrl := 'http://demos.href.com/';
        currentLogPath := ExtractFilePath(Application.ExeName) + 'showcase_result_b\';
      end;

      PageIndex:= 0;
      selenium := DefaultSelenium.Create(selenium_server, selenium_server_port,
        browser, currectBaseUrl);
      Log(Format('Start selenium instance: host=%s', [currectBaseUrl]));
      selenium.Start();

      flagStop := false;
      {$I test_showcase.inc}
      
      //selenium.Stop();
    except
      on E: Exception do
      begin
        Log('************* Exception ***********');
        Log(Format('Exception: %s', [e.Message]));
      end;
    end;
  finally
  end;
  Log('End.');
  Sleep(1000);  // wait for OS to close the log file
  LogContents := StringLoadFromFileDef(GetTestLogFilespec, '');
  Form1.memoLog.Lines.Text := LogContents;
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  flagStop := true;
end;

procedure TForm1.btnTestClick(Sender: TObject);
var
  selenium: ISelenium;
//  s: string;
begin
  Log('Start......');
  try
    {selenium := DefaultSelenium.Create('localhost', 5555, '*firefox', 'http://demos.href.com');
    selenium.Start();
    selenium.Open('/scripts/runisa.dll?hubvers:pgVersion');

    //selenium := DefaultSelenium.Create('localhost', 5555, '*firefox', 'http://demos.href.com');
    //selenium.Start();
    //selenium.Open('/showcase');

    //s := selenium.GetHtmlSource();
    //SaveText(ExtractFilePath(Application.ExeName) + '0_GetHtmlSource.txt', s);

    //s_old_location := Selenium.getEval('window.location');
    Selenium.getEval('window.location = ''view-source:'' + window.location;');
    s := Selenium.getBodyText();
    SaveText(ExtractFilePath(Application.ExeName) + '0_getBodyText.txt', s);

    //Selenium.getEval('window.location = ''' + s_old_location + '''');
    //s := selenium.GetHtmlSource();
    //SaveText(ExtractFilePath(Application.ExeName) + '0_GetHtmlSource2.txt', s);

    Selenium.GoBack();
    Selenium.WaitForPageToLoad('30000');
    //SaveText(ExtractFilePath(Application.ExeName) + '0_getBodyText.txt', s);

    //Selenium.SelectFrame('relative=top');
    //Selenium.getEval('window.history.go(-1)');

    //selenium.Stop();}

    selenium := DefaultSelenium.Create('localhost', 5555, '*firefox', 'http://demos.href.com');
    selenium.Start();
    selenium.Open('/showcase::1204');
    selenium.ClickAndWait('//div[@id=''menuThisWebHubDemo'']/ul/li[2]/a');

    //selenium.Stop();
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(Format('Exception: %s', [e.Message]));
    end;
  end;
  Log('End.');

  //ShowMessage(RegReplace('aaa:12345bbb', ':[0-9]+(?=[^0-9])', ''));
  //ShowMessage(RegReplace('aaa:12345.123:bbb', ':[0-9]+\.[0-9]+:', ''));
  //ShowMessage(RegReplace('aaa<span class="changing">ccc</span>bbb', '<span class="changing">.*</span>', ''));
	//ShowMessage(RegReplace('aaa<!-- changing:start-->ccc<!-- changing:stop-->bbb', '<!-- changing:start-->.*<!-- changing:stop-->', ''));
  //ShowMessage(RegReplace('aaa/* changing:start */ccc/* changing:stop */bbb', '/\* changing:start \*/.*/\* changing:stop \*/', ''));
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  selenium: ISelenium;
begin
  Log('Start......');
  try
    selenium := DefaultSelenium.Create('localhost', 5555, '*firefox', 'http://www.google.com');
    selenium.Start();
    selenium.Open('/');
    selenium.ClickAndWait('link=Images');

    //selenium.Stop();
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(Format('Exception: %s', [e.Message]));
    end;
  end;
  Log('End.');
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  selenium: ISelenium;
  s: UTF8String;
begin
  Log('Start......');
  try
    selenium := DefaultSelenium.Create('localhost', 5555, '*firefox', 'http://www.google.com');
    selenium.Start('captureNetworkTraffic=true');
    selenium.Open('/');
    s := selenium.captureNetworkTraffic('plain');
    UTF8StringWriteToFile(
      ExtractFilePath(Application.ExeName) + '0captureNetworkTraffic.txt',
      s);
    selenium.ClickAndWait('link=Images');

    //selenium.Stop();
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(Format('Exception: %s', [e.Message]));
    end;
  end;
  Log('End.');
end;

end.

