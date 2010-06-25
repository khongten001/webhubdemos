unit uSeleniumShared;

interface

uses
  uISelenium;

function selenium_Open(url: UTF8String): boolean;
function selenium_Click(locator: UTF8String): boolean;
function selenium_ClickAndWait(locator: UTF8String): boolean;
function selenium_save(title: UTF8String): boolean;
function selenium_Type(locator: UTF8String;value: UTF8String): boolean;
function selenium_GoBack(): boolean;

var
  selenium_server: UTF8String = '';
  selenium_server_port: integer;
  browser: UTF8String = '*chrome'; //'*firefox'; //'*iexplore';
  //browser := '*custom C:\\Program Files\\Mozilla Firefox\\firefox.exe -no-remote -profile d:\\apps\\selenium\\server\\firefoxselenium';
  currentTestID: UTF8String;
  currectBaseUrl: UTF8String;
  currentLogPath: string;
  selenium: ISelenium;
  PageIndex: integer;

implementation

uses
  Forms, SysUtils, Windows,
  ucLogFil,
  ldiRegEx,   // search path use H:\ or K:\WebHub\regex
  uDefaultSelenium;



procedure Log(const S: UTF8String); overload;
begin
  HREFTestLog('info', '', string(S));
end;

procedure Log(const S: string); overload;
begin
  HREFTestLog('info', '', S);
end;


function RegReplace(const src: UTF8String; const Pattern: UTF8String;
  const replaceWith: UTF8String): UTF8String;
var
  Reg : TldiRegExMulti;
  PatternStatus: TPatternStatus;
  PatternID : Integer;
begin
  Reg := TldiRegExMulti.Create(nil);
  if not Reg.AddPattern(Pattern, [coIgnoreCase, coUnGreedy], PatternID,
    PatternStatus) then
    raise Exception.Create('AddPattern error! ' + PatternStatus.ErrorMessage);
  result := Reg.Replace(PatternID, src, replaceWith);
end;

function selenium_Open(url: UTF8String): boolean;
var
  cmd: UTF8String;
begin
  Application.ProcessMessages;
  try
    cmd := UTF8String(Format('Index=%d, Open(%s)', [PageIndex, url]));
    Log(string(cmd));
    selenium.Open(url);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.Open(url);
    result := selenium_save(cmd);
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_Click(locator: UTF8String): boolean;
var
  cmd: UTF8String;
begin
  Application.ProcessMessages;
  try
    cmd := UTF8String(Format('Index=%d, Click(%s)', [PageIndex, locator]));
    Log(cmd);
    selenium.Click(locator);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.Click(locator);
    result := selenium_save(cmd);
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_ClickAndWait(locator: UTF8String): boolean;
var
  cmd: UTF8String;
begin
  Application.ProcessMessages;
  try
    cmd := UTF8String(Format('Index=%d, ClickAndWait(%s)',
      [PageIndex, locator]));
    Log(cmd);
    selenium.ClickAndWait(locator);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.ClickAndWait(locator);
    result := selenium_save(cmd);
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_GoBack(): boolean;
var
  cmd: UTF8String;
begin
  Application.ProcessMessages;
  try
    cmd := UTF8String(Format('Index=%d, GoBack()', [PageIndex]));
    Log(cmd);
    selenium.GoBack();
    selenium.WaitForPageToLoad('30000');
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.GoBack();
    result := selenium_save(cmd);
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;


function selenium_WaitForPageToLoad(timeout: UTF8String): boolean;
var
  cmd: UTF8String;
begin
  Application.ProcessMessages;
  try
    cmd := UTF8String(Format('WaitForPageToLoad(%s)', [timeout]));
    Log(cmd);
    selenium.WaitForPageToLoad(timeout);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.WaitForPageToLoad(timeout);
    result := true;
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_Type(locator: UTF8String;value: UTF8String): boolean;
var
  cmd: UTF8String;
begin
  Application.ProcessMessages;
  try
    cmd := UTF8String(Format('Type(%s, %s)', [locator, value]));
    Log(cmd);
    selenium.Type_(locator, value);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.Type_(locator, value);
    result := true;
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;


function selenium_Check(locator: UTF8String): boolean;
var
  cmd: UTF8String;
begin
  Application.ProcessMessages;
  try
    cmd := UTF8String(Format('Check(%s)', [locator]));
    Log(cmd);
    selenium.Check(locator);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.Check(locator);
    result := true;
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_Uncheck(locator: UTF8String): boolean;
var
  cmd: UTF8String;
begin
  Application.ProcessMessages;
  try
    cmd := UTF8String(Format('Uncheck(%s)', [string(locator)]));
    Log(cmd);
    selenium.Uncheck(locator);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.Uncheck(locator);
    result := true;
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_Select(selectLocator: UTF8String; optionLocator: UTF8String): boolean;
var
  cmd: UTF8String;
begin
  Application.ProcessMessages;
  try
    cmd := UTF8String(Format('Select(%s, %s)', [string(selectLocator),
      string(optionLocator)]));
    Log(cmd);
    selenium.Select(selectLocator, optionLocator);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.Select(selectLocator, optionLocator);
    result := true;
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_AddSelection(locator: UTF8String;optionLocator: UTF8String): boolean;
var
  cmd: UTF8String;
begin
  Application.ProcessMessages;
  try
    cmd := UTF8String(Format('AddSelection(%s, %s)', [string(locator),
      string(optionLocator)]));
    Log(cmd);
    selenium.AddSelection(locator, optionLocator);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.AddSelection(locator, optionLocator);
    result := true;
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(Format('Exception: %s', [e.Message]));
      result := false;
    end;
  end;
end;

function selenium_RemoveSelection(locator: UTF8String;optionLocator: UTF8String): boolean;
var
  cmd: UTF8String;
begin
  Application.ProcessMessages;
  try
    cmd := UTF8String(Format('RemoveSelection(%s, %s)',
      [locator, optionLocator]));
    Log(cmd);
    selenium.RemoveSelection(locator, optionLocator);
    //Log(Format('host:(%s) cmd:%s', [selenium2_url, cmd]));
    //selenium2.RemoveSelection(locator, optionLocator);
    result := true;
  except
    on E: Exception do
    begin
      Log('************* Exception ***********');
      Log(UTF8String(Format('Exception: %s', [e.Message])));
      result := false;
    end;
  end;
end;

function selenium_save(title: UTF8String): boolean;
var
  s_org: UTF8String;
  s: UTF8String;
  filename: string;
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

  // Reference http://groups.google.com/group/selenium-users/browse_thread/thread/9d30035cf39676b8/a093cf7fe8c91a8a?lnk=gst&q=gethtmlsource#a093cf7fe8c91a8a
  //s_org := selenium.GetHtmlSource();
  Selenium.getEval('window.location = ''view-source:'' + window.location;');
  s_org := Selenium.getBodyText();

  // Joshua: need to set the window.location back to normal here

if true then
begin
  s := RegReplace(s_org, ':[0-9]+(?=[^0-9])', ':1234');
  s := RegReplace(s, ':[0-9]+\.[0-9]+:', ':1234.5678:');
  //s := RegReplace(s, ':[0-9]+"', ':1204"');
  //s := RegReplace(s, ':[0-9]+:', ':1204:');
  //s := RegReplace(s, ':1204\..*"', ':1204"');
	s := RegReplace(s, '<span class="changing">.*</span>', '');
	s := RegReplace(s, '<!-- changing:start-->.*<!-- changing:stop-->', '');
  s := RegReplace(s, '/\* changing:start \*/.*/\* changing:stop \*/', '');
end
else
  s := s_org;

  filename := currentLogPath + IntToStr(PageIndex) + '.txt';
  UTF8StringWriteToFile(filename, Title + sLineBreak + s);

  Inc(PageIndex);
  result := true;
end;



end.
