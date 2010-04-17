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
    btnStart: TButton;
    btnTest: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

  selenium_server: string;
  selenium_server_port: integer;
  browser: string;

  selenium: ISelenium;
  currentTestID: string;
  currectBaseUrl: string;
  currentLogPath: string;
  PageCounter: integer;

implementation
{$R *.dfm}

procedure Log(s: string);
begin
  Form1.memoLog.Lines.Add(s + #13);
end;

function selenium_save(title: string): boolean;
var
  s_org: string;
  s: string;
  filename: string;
  F: Text;
begin
(*
  //s1_org := selenium.GetHtmlSource();
  //s2_org := selenium2.GetHtmlSource();
  //s1 := StringReplace(s1_org, '<span class="changing">.*</span>', '',[rfReplaceAll, rfIgnoreCase]);
  //s2 := StringReplace(s2_org, '<span class="changing">.*</span>', '',[rfReplaceAll, rfIgnoreCase]);
  //s1 := StringReplace(s1_org, ':1204\..*"', ':1204"', [rfReplaceAll, rfIgnoreCase]);
  //s2 := StringReplace(s2_org, ':1204\..*"', ':1204"', [rfReplaceAll, rfIgnoreCase]);
  //s1 := StringReplace(s1_org, 'demos.href.com', 'demos.href.com',[rfReplaceAll, rfIgnoreCase]);
  //s2 := StringReplace(s2_org, 'localhost', 'demos.href.com',[rfReplaceAll, rfIgnoreCase]);

  //for (int i = 0; i < Math.Min(s1.Length, s2.Length); i++)
  //{
  //    if (s1[i] != s2[i])
  //    {
  //        Console.WriteLine("  Diff:\n\r    HtmlSource1={0}\n\r    HtmlSource2={1}",
  //            s1.Substring(i, (s1.Length - i - 1 >= 20 ? 20 : s1.Length - i - 1)),
  //            s2.Substring(i, (s2.Length - i - 1 >= 20 ? 20 : s2.Length - i - 1)));
  //        break;
  //    }
  //}
  //if (s1 != s2)
  //{
  Inc(error_count);
  file1 := log_path + 'a\' + IntToStr(error_count) + '.txt';
  if (FileExists(file1)) then
    DeleteFile(file1);
  AssignFile(F, file1);
  Rewrite(F);
  Writeln(F, title);
  Writeln(F, s1);
  CloseFile(F);

  file2 := log_path + 'b\' + IntToStr(error_count) + '.txt';
  if (FileExists(file2)) then
    DeleteFile(file2);
  AssignFile(F, file2);
  Rewrite(F);
  Writeln(F, title);
  Writeln(F, s2);
  CloseFile(F);

  result := (s1 = s2);*)

  s_org := selenium.GetHtmlSource();
  if currentTestID = 'a' then
  begin
	  s := StringReplace(s_org, '<span class="changing">.*</span>', '',[rfReplaceAll, rfIgnoreCase]);
  	s := StringReplace(s_org, ':1204\..*"', ':1204"', [rfReplaceAll, rfIgnoreCase]);
  	s := StringReplace(s_org, 'demos.href.com', 'demos.href.com',[rfReplaceAll, rfIgnoreCase]);
  end
  else
  begin
  	s := StringReplace(s_org, '<span class="changing">.*</span>', '',[rfReplaceAll, rfIgnoreCase]);
  	s := StringReplace(s_org, ':1204\..*"', ':1204"', [rfReplaceAll, rfIgnoreCase]);
  	s := StringReplace(s_org, 'localhost', 'demos.href.com',[rfReplaceAll, rfIgnoreCase]);
  end;

  Inc(PageCounter);
  filename := currentLogPath + IntToStr(PageCounter) + '.txt';
  if (FileExists(filename)) then
    DeleteFile(filename);
  AssignFile(F, filename);
  Rewrite(F);
  Writeln(F, title);
  Writeln(F, s);
  CloseFile(F);
  result := true;
end;

function selenium_Open(url: string): boolean;
var
  cmd: string;
begin
  Application.ProcessMessages;
  try
    cmd := Format('Open(%s)', [url]);
    Log(Format('host:(%s) cmd:%s', [currectBaseUrl, cmd]));
    selenium.Open(url);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.Open(url);
    result := selenium_save(cmd);
  except
    on E: Exception do
    begin
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_Click(locator: String): boolean;
var
  cmd: string;
begin
  Application.ProcessMessages;
  try
    cmd := Format('Click(%s)', [locator]);
    Log(Format('host:(%s) cmd:%s', [currectBaseUrl, cmd]));
    selenium.Click(locator);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.Click(locator);
    result := selenium_save(cmd);
  except
    on E: Exception do
    begin
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_ClickAndWait(locator: String): boolean;
var
  cmd: string;
begin
  Application.ProcessMessages;
  try
    cmd := Format('ClickAndWait(%s)', [locator]);
    Log(Format('host:(%s) cmd:%s', [currectBaseUrl, cmd]));
    selenium.ClickAndWait(locator);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.ClickAndWait(locator);
    result := selenium_save(cmd);
  except
    on E: Exception do
    begin
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_WaitForPageToLoad(timeout: String): boolean;
var
  cmd: string;
begin
  Application.ProcessMessages;
  try
    cmd := Format('WaitForPageToLoad(%s)', [timeout]);
    Log(Format('host:(%s) cmd:%s', [currectBaseUrl, cmd]));
    selenium.WaitForPageToLoad(timeout);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.WaitForPageToLoad(timeout);
    result := true;
  except
    on E: Exception do
    begin
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_Type(locator: String;value: string): boolean;
var
  cmd: string;
begin
  Application.ProcessMessages;
  try
    cmd := Format('Type(%s, %s)', [locator, value]);
    Log(Format('host:(%s) cmd:%s', [currectBaseUrl, cmd]));
    selenium.Type_(locator, value);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.Type_(locator, value);
    result := true;
  except
    on E: Exception do
    begin
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_GoBack(): boolean;
var
  cmd: string;
begin
  Application.ProcessMessages;
  try
    cmd := Format('GoBack()', []);
    Log(Format('host:(%s) cmd:%s', [currectBaseUrl, cmd]));
    selenium.GoBack();
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.GoBack();
    result := selenium_save(cmd);
  except
    on E: Exception do
    begin
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_Check(locator: string): boolean;
var
  cmd: string;
begin
  Application.ProcessMessages;
  try
    cmd := Format('Check(%s)', [locator]);
    Log(Format('host:(%s) cmd:%s', [currectBaseUrl, cmd]));
    selenium.Check(locator);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.Check(locator);
    result := true;
  except
    on E: Exception do
    begin
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_Uncheck(locator: string): boolean;
var
  cmd: string;
begin
  Application.ProcessMessages;
  try
    cmd := Format('Uncheck(%s)', [locator]);
    Log(Format('host:(%s) cmd:%s', [currectBaseUrl, cmd]));
    selenium.Uncheck(locator);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.Uncheck(locator);
    result := true;
  except
    on E: Exception do
    begin
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_Select(selectLocator: string; optionLocator: string): boolean;
var
  cmd: string;
begin
  Application.ProcessMessages;
  try
    cmd := Format('Select(%s, %s)', [selectLocator, optionLocator]);
    Log(Format('host:(%s) cmd:%s', [currectBaseUrl, cmd]));
    selenium.Select(selectLocator, optionLocator);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.Select(selectLocator, optionLocator);
    result := true;
  except
    on E: Exception do
    begin
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_AddSelection(locator: String;optionLocator: string): boolean;
var
  cmd: string;
begin
  Application.ProcessMessages;
  try
    cmd := Format('AddSelection(%s, %s)', [locator, optionLocator]);
    Log(Format('host:(%s) cmd:%s', [currectBaseUrl, cmd]));
    selenium.AddSelection(locator, optionLocator);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.AddSelection(locator, optionLocator);
    result := true;
  except
    on E: Exception do
    begin
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_RemoveSelection(locator: String;optionLocator: string): boolean;
var
  cmd: string;
begin
  Application.ProcessMessages;
  try
    cmd := Format('RemoveSelection(%s, %s)', [locator, optionLocator]);
    Log(Format('host:(%s) cmd:%s', [currectBaseUrl, cmd]));
    selenium.RemoveSelection(locator, optionLocator);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.RemoveSelection(locator, optionLocator);
    result := selenium_save(cmd);
  except
    on E: Exception do
    begin
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

procedure test_showcase();
begin
{$I test_showcase.inc}
end;


procedure TForm1.btnStartClick(Sender: TObject);
begin
  Log('Start......');

  selenium_server := 'localhost'; //'nexthelp.webhub.com'
  selenium_server_port := 5555; //4444
  browser := '*chrome'; //'*firefox'; //'*iexplore';
  //browser := '*custom C:\\Program Files\\Mozilla Firefox\\firefox.exe -no-remote -profile d:\\apps\\selenium\\server\\firefoxselenium';

  try
    try
      //string[] files = Directory.GetFiles(log_path + "a');
      //for (int i = 0; i < files.Length; i++)
      //    File.Delete(files[i]);
      //files = Directory.GetFiles(log_path + "b');
      //for (int i = 0; i < files.Length; i++)
      //    File.Delete(files[i]);

      currentTestID := 'a';
      currectBaseUrl := 'http://demos.href.com/';
      currentLogPath := ExtractFilePath(Application.ExeName) + currentTestID + '\';
      PageCounter:= 0;
      selenium := DefaultSelenium.Create(selenium_server, selenium_server_port, browser, currectBaseUrl);
      Log(Format('Start selenium instance: host=%s', [currectBaseUrl]));
      selenium.Start();
      test_showcase();
      selenium.Stop();

      currentTestID := 'b';
      currectBaseUrl := 'http://demos.href.com/';
      currentLogPath := ExtractFilePath(Application.ExeName) + currentTestID + '\';
      PageCounter:= 0;
      selenium := DefaultSelenium.Create(selenium_server, selenium_server_port, browser, currectBaseUrl);
      Log(Format('Start selenium instance: host=%s', [currectBaseUrl]));
      selenium.Start();
      test_showcase();
      selenium.Stop();
    except
      on E: Exception do
        Log(Format('Exception: %s', [e.Message]));
    end;
  finally
    try
      //selenium.Stop();
      //selenium2.Stop();
    except
      on E: Exception do
        Log(Format('Exception: %s', [e.Message]));
    end;
  end;
  Log('End.');
end;

procedure TForm1.btnTestClick(Sender: TObject);
var
  selenium: ISelenium;
begin
  Log('Start......');
  try
    selenium := DefaultSelenium.Create('localhost', 5555, '*chrome', 'http://demos.href.com/');
    selenium.Start();
    selenium.Open('/showcase');
		selenium.ClickAndWait('//div[@id=''menuThisWebHubDemo'']/ul/li[2]/a');
		selenium.ClickAndWait('link=Easier HTML');
		selenium.ClickAndWait('//img[@alt=''Down'']');
    selenium.ClickAndWait('//img[@alt=''Down'']');
    selenium.Click('//img[@alt=''Next'']');
    selenium.Click('//img[@alt=''Next'']');
    selenium.Click('//img[@alt=''Next'']');
    selenium.Click('//img[@alt=''Next'']');
    //selenium.Stop();
  except
    on E: Exception do
      Log(Format('Exception: %s', [e.Message]));
  end;
  Log('End.');
end;

end.

