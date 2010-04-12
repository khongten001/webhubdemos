unit uHttpCommandProcessor;

interface
uses
  SysUtils,
  uICommandProcessor, uDefaultRemoteCommand, uIRemoteCommand, uCommon;

type
  HttpCommandProcessor = class(TInterfacedObject, ICommandProcessor)
  private
    sessionId: string;
    serverHost: string;
    serverPort: integer;
    browserStartCommand: string;
    browserURL: string;
  private
    function BuildCommandString(commandString: string): string;
  public
    constructor Create(_serverHost: string; _serverPort: integer; _browserStartCommand: string; _browserURL: string); overload;
    //constructor Create(serverURL: string; browserStartCommand: string; browserURL: string); overload;
    function DoCommand(command: string; args: ArrayOfString): string;
    procedure Start();
    procedure Stop();
    function GetString(commandName: string; args: ArrayOfString): string;
    function GetStringArray(commandName: string; args: ArrayOfString): ArrayOfString;
    class function parseCSV(input: string): ArrayOfString;
    function GetNumber(commandName: string; args: ArrayOfString): double;
    function GetNumberArray(commandName: string; args: ArrayOfString): ArrayOfDouble;
    function GetBoolean(commandName: string; args: ArrayOfString): boolean;
    function GetBooleanArray(commandName: string; args: ArrayOfString): ArrayOfBoolean;
  end;

implementation
uses
  webTelnt, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

constructor HttpCommandProcessor.Create(_serverHost: string; _serverPort: integer; _browserStartCommand: string; _browserURL: string);
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

function HttpCommandProcessor.DoCommand(command: string; args: ArrayOfString): string;
var
  remoteCommand: IRemoteCommand;
  http: TIdHTTP;
  response: string;
  i: integer;
begin
  remoteCommand := DefaultRemoteCommand.Create(command, args);
  http := TIdHTTP.Create(nil);
  http.URL.Host := serverHost;
  http.URL.Port := IntToStr(serverPort);
  response := http.Get(BuildCommandString(remoteCommand.CommandString));
  if (http.ResponseCode <> 200) then
    raise Exception.Create(IntToStr(http.ResponseCode));
  i := Pos(#13#10#13#10, response);
  if i > 0 then
    response := Copy(response, i + 4, Length(response) - i - 3);
  if Copy(response, 1, 2) <> 'OK' then
    raise Exception.Create(response);
  result := response;
end;

function HttpCommandProcessor.BuildCommandString(commandString: string): string;
begin
  result := '/selenium-server/driver/?' + commandString;
  if (sessionId <> '') then
    result := result + '&sessionId=' + sessionId;
end;

procedure HttpCommandProcessor.Start();
begin
  sessionId := GetString('getNewBrowserSession', ArrayOfString.Create(browserStartCommand, browserURL));
end;

procedure HttpCommandProcessor.Stop();
begin
  DoCommand('testComplete', ArrayOfString.Create(''));
  sessionId := '';
end;

function HttpCommandProcessor.GetString(commandName: string; args: ArrayOfString): string;
var
  s : string;
begin
  s := DoCommand(commandName, args);
  result := Copy(s, 4, Length(s) - 3);
end;

function HttpCommandProcessor.GetStringArray(commandName: string; args: ArrayOfString): ArrayOfString;
var
  s: string;
begin
  s := GetString(commandName, args);
  result := parseCSV(s);
end;

class function HttpCommandProcessor.parseCSV(input: string): ArrayOfString;
var
  s: string;
  i: integer;
begin
  result := ArrayOfString.Create();
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
          s := s + input[i];
          continue;
        end;
    else
      begin
        s := s + input[i];
        break;
      end;
    end;
    result.Add(s);
  end;
end;

function HttpCommandProcessor.GetNumber(commandName: string; args: ArrayOfString): double;
var
  s: string;
begin
  s := GetString(commandName, args);
  result := StrToFloat(s);
end;

function HttpCommandProcessor.GetNumberArray(commandName: string; args: ArrayOfString): ArrayOfDouble;
var
  ss: ArrayOfString;
  dd: ArrayOfDouble;
  i: integer;
begin
  ss := GetStringArray(commandName, args);
  dd := ArrayOfDouble.Create;
  for i := 0 to ss.Count - 1 do
    dd.Add(StrToFloat(ss[i]));
  result := dd;
end;

function HttpCommandProcessor.GetBoolean(commandName: string; args: ArrayOfString): boolean;
var
  s: string;
begin
  s := GetString(commandName, args);
  if SameText(s, 'true') then
    result := true
  else if SameText(s, 'false') then
    result := false
  else
    raise Exception.Create('result was neither "true" nor "false": ' + s);
end;

function HttpCommandProcessor.GetBooleanArray(commandName: string; args: ArrayOfString): ArrayOfBoolean;
var
  ss: ArrayOfString;
  bb: ArrayOfBoolean;
  i: integer;
begin
  ss := GetStringArray(commandName, args);
  bb := ArrayOfBoolean.Create;
  for i := 0 to ss.Count - 1 do
  begin
    if SameText(ss[i], 'true') then
      bb.Add(true)
    else if SameText(ss[i], 'false') then
      bb.Add(false)
    else
      raise Exception.Create('result was neither "true" nor "false": ' + ss[i]);
  end;
  result := bb;
end;

end.

