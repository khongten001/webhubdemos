unit uHttpCommandProcessor;

interface
uses
  SysUtils,
  uICommandProcessor, uDefaultRemoteCommand, uIRemoteCommand, uCommon;

type
  HttpCommandProcessor = class(TInterfacedObject, ICommandProcessor)
  private
    sessionId: string;
    serverHost: UTF8String;
    serverPort: integer;
    browserStartCommand: UTF8String;
    browserURL: UTF8String;
  private
    function BuildCommandString(commandString: UTF8String): UTF8String;
  public
    constructor Create(_serverHost: UTF8String; _serverPort: integer; _browserStartCommand: UTF8String; _browserURL: UTF8String); overload;
    //constructor Create(serverURL: string; browserStartCommand: string; browserURL: string); overload;
    function DoCommand(command: UTF8String; args: ArrayOfUTF8String): UTF8String;
    procedure Start();
    procedure Stop();
    function GetString(commandName: UTF8String; args: ArrayOfUTF8String): UTF8String;
    function GetStringArray(commandName: UTF8String; args: ArrayOfUTF8String): ArrayOfUTF8String;
    class function parseCSV(input: UTF8String): ArrayOfUTF8String;
    function GetNumber(commandName: UTF8String; args: ArrayOfUTF8String): double;
    function GetNumberArray(commandName: UTF8String; args: ArrayOfUTF8String): ArrayOfDouble;
    function GetBoolean(commandName: UTF8String; args: ArrayOfUTF8String): boolean;
    function GetBooleanArray(commandName: UTF8String; args: ArrayOfUTF8String): ArrayOfBoolean;
  end;

implementation

uses
  StrUtils,
  ucString, ucLogFil,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

constructor HttpCommandProcessor.Create(_serverHost: UTF8String; _serverPort: integer; _browserStartCommand: UTF8String; _browserURL: UTF8String);
begin
  serverHost:= _serverHost;
  serverPort := _serverPort;
  browserStartCommand := _browserStartCommand;
  browserURL := _browserURL;
end;

{constructor HttpCommandProcessor.Create(serverURL: string; browserStartCommand: string; browserURL: string);
begin
  url := serverURL;
  browserStartCommand := browserStartCommand;
  browserURL := browserURL;
end;}

var
  debugcount: integer = 0;

function HttpCommandProcessor.DoCommand(command: UTF8String; args: ArrayOfUTF8String): UTF8String;
var
  remoteCommand: IRemoteCommand;
  http: TIdHTTP;
  response: string;
  i: integer;
  flag: Boolean;
  part: UTF8String;
begin
  Inc(debugcount);
  remoteCommand := DefaultRemoteCommand.Create(command, args);
  http := TIdHTTP.Create(nil);
  http.URL.Host := string(serverHost);
  http.URL.Port := IntToStr(serverPort);
  http.Response.CharSet := 'utf-8';

  response := http.Get(string(BuildCommandString(remoteCommand.CommandString)));
  // Testing: in showcase, GetHtmlSource returns copyright symbol. We should
  // be getting &copy; instead. Probably we need to use other functions insead
  // of GetHtmlSource.
  // Reference http://groups.google.com/group/selenium-users/browse_thread/thread/9d30035cf39676b8/a093cf7fe8c91a8a?lnk=gst&q=gethtmlsource#a093cf7fe8c91a8a
  (*if (debugcount < 20) and (Length(Response) > 2) then
    StringWriteToFile(Format('%s%d_test_%d.txt',
      [GetLogFolder, debugcount, Length(Response)]),
      Response);*)
  flag := (Pos('Русский', Response) > 0);
  if flag then
  begin
    //HREFTestLog('Russian ok', 'DoCommand', '');
    flag := (Pos('Русский', Copy(Response, Length(Response) - 1500,
      1500)) > 0);
    //HREFTestLog('Russian', 'found after copy', BoolToStr(flag, True));
  end;

  if (http.ResponseCode <> 200) then
    raise Exception.Create(IntToStr(http.ResponseCode));
  i := Pos(#13#10#13#10, response);
  if i > 0 then
    response := Copy(response, i + 4, Length(response) - i - 3);
  if Copy(response, 1, 2) <> 'OK' then
    raise Exception.Create(response);

  Result := utf8encode(Response);
  flag := (Pos(utf8encode('Русский'), Response) > 0);
  //HREFTestLog('Russian', 'found in Result', BoolToStr(flag, True));

  if flag and (debugcount < 20) then
    HREFTestLog('Result', IntToStr(debugcount), Result);
end;

function HttpCommandProcessor.BuildCommandString(commandString: UTF8String): UTF8String;
begin
  result := '/selenium-server/driver/?' + commandString;
  if (sessionId <> '') then
    result := result + '&sessionId=' + UTF8String(sessionId);
end;

procedure HttpCommandProcessor.Start();
begin
  sessionId := string(GetString('getNewBrowserSession',
    ArrayOfUTF8String.Create(browserStartCommand, browserURL)));
end;

procedure HttpCommandProcessor.Stop();
begin
  DoCommand('testComplete', ArrayOfUTF8String.Create(''));
  sessionId := '';
end;

function HttpCommandProcessor.GetString(commandName: UTF8String;
  args: ArrayOfUTF8String): UTF8String;
var
  s : UTF8String;
begin
  s := DoCommand(commandName, args);
  result := Copy(s, 4, Length(s) - 3);
end;

function HttpCommandProcessor.GetStringArray(commandName: UTF8String;
  args: ArrayOfUTF8String): ArrayOfUTF8String;
var
  s: UTF8String;
begin
  s := GetString(commandName, args);
  result := parseCSV(s);
end;

class function HttpCommandProcessor.parseCSV(input: UTF8String): ArrayOfUTF8String;
var
  s: UTF8String;
  i: integer;
begin
  result := ArrayOfUTF8String.Create();
  s := '';
  i := 1;
  while (i <= Length(input)) do
  begin
    case (input[i]) of
      ',':
        begin
          result.Add(s);
          s := '';
          continue;
        end;
      '\':
        begin
          i := i + 1;
          s := s + UTF8String(input[i]);
          continue;
        end;
    else
      begin
        s := s + UTF8String(input[i]);
        break;
      end;
    end;
    result.Add(s);
  end;
end;

function HttpCommandProcessor.GetNumber(commandName: UTF8String; args: ArrayOfUTF8String): double;
var
  s: UTF8String;
begin
  s := GetString(commandName, args);
  result := StrToFloat(string(s));
end;

function HttpCommandProcessor.GetNumberArray(commandName: UTF8String; args: ArrayOfUTF8String): ArrayOfDouble;
var
  ss: ArrayOfUTF8String;
  dd: ArrayOfDouble;
  i: integer;
begin
  ss := GetStringArray(commandName, args);
  dd := ArrayOfDouble.Create;
  for i := 0 to ss.Count - 1 do
    dd.Add(StrToFloat(string(ss[i])));
  result := dd;
end;

function HttpCommandProcessor.GetBoolean(commandName: UTF8String;
  args: ArrayOfUTF8String): boolean;
var
  s: UTF8String;
begin
  s := GetString(commandName, args);
  if SameText(string(s), 'true') then
    result := true
  else if SameText(string(s), 'false') then
    result := false
  else
    raise Exception.Create(Format('result was neither "true" nor "false": %s',
      [string(s)]));
end;

function HttpCommandProcessor.GetBooleanArray(commandName: UTF8String;
  args: ArrayOfUTF8String): ArrayOfBoolean;
var
  ss: ArrayOfUTF8String;
  bb: ArrayOfBoolean;
  i: integer;
begin
  ss := GetStringArray(commandName, args);
  bb := ArrayOfBoolean.Create;
  for i := 0 to ss.Count - 1 do
  begin
    if SameText(string(ss[i]), 'true') then
      bb.Add(true)
    else if SameText(string(ss[i]), 'false') then
      bb.Add(false)
    else
      raise Exception.Create('result was neither "true" nor "false": ' +
        string(ss[i]));
  end;
  result := bb;
end;

end.

