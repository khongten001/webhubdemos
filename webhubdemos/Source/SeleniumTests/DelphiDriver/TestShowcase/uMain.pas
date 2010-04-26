unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  uISelenium, uDefaultSelenium;

type
  TForm1 = class(TForm)
    memoLog: TMemo;
    Panel1: TPanel;
    btnTestA: TButton;
    btnTest: TButton;
    btnTestB: TButton;
    btnStop: TButton;
    procedure btnTestAClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
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
      
      selenium.Stop();
    except
      on E: Exception do
      begin
        Log('************* Exception ***********');
        Log(Format('Exception: %s', [e.Message]));
      end;
    end;
  finally
    try
      //selenium.Stop();
      //selenium2.Stop();
    except
      on E: Exception do
      begin
        Log('************* Exception ***********');
        Log(Format('Exception: %s', [e.Message]));
      end;
    end;
  end;
  Log('End.');
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
  LogContents: string;
begin
  Log('Start......');
  try
    selenium := DefaultSelenium.Create('localhost', 5555, '*chrome',
      'http://demos.href.com/');
    selenium.Start();
    selenium.Open('/showcase::1204');
		//selenium.ClickAndWait('//div[@id=''menuThisWebHubDemo'']/ul/li[2]/a');
		//selenium.ClickAndWait('link=Easier HTML');
    //selenium.Stop();
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(Format('Exception: %s', [e.Message]));
    end;
  end;
  Log('End.');
  LogContents := StringLoadFromFileDef(GetTestLogFilespec, '');
  Form1.memoLog.Lines.Text := LogContents;

  //ShowMessage(RegReplace('aaa:12345bbb', ':[0-9]+(?=[^0-9])', ''));
  //ShowMessage(RegReplace('aaa:12345.123:bbb', ':[0-9]+\.[0-9]+:', ''));
  //ShowMessage(RegReplace('aaa<span class="changing">ccc</span>bbb', '<span class="changing">.*</span>', ''));
	//ShowMessage(RegReplace('aaa<!-- changing:start-->ccc<!-- changing:stop-->bbb', '<!-- changing:start-->.*<!-- changing:stop-->', ''));
  //ShowMessage(RegReplace('aaa/* changing:start */ccc/* changing:stop */bbb', '/\* changing:start \*/.*/\* changing:stop \*/', ''));
end;

end.

