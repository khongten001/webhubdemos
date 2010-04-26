unit uDefaultRemoteCommand;

interface
uses
  SysUtils,
  uIRemoteCommand, uCommon;

type
	DefaultRemoteCommand = class(TInterfacedObject, IRemoteCommand)
  public
    args: ArrayOfUTF8String;
		command: UTF8String;
  public
    constructor Create(_command: UTF8String; _args: ArrayOfUTF8String);
		function CommandString: UTF8String;
		class function Parse(commandString: UTF8String): DefaultRemoteCommand;
  end;

  const
    PARSE_ERROR_MESSAGE = 'Command must contain 4 pipe characters and should start with a ''|''. Unable to parse command';

implementation

uses
  ucString;

    constructor DefaultRemoteCommand.Create(_command: UTF8String; _args: ArrayOfUTF8String);
    begin
			command := _command;
			args := _args;
    end;

		function  DefaultRemoteCommand.CommandString: UTF8String;
    var
      i : Integer;
    begin
				result := 'cmd=';
				result := result + UrlEncode(command);
				if args.Count = 0 then
          exit;
				for i := 0 to args.Count - 1 do
					result := result + '&' + IntToStr(i+1) + '=' + UrlEncode(args[i]);
		end;

		class function DefaultRemoteCommand.Parse(commandString: UTF8String): DefaultRemoteCommand;
    //var
    // commandArray: ArrayOfUTF8String;
		begin
			{if (commandString = '') or (Trim(commandString) = '') or (Copy(commandString, 1, 1) <> '|') then
			begin
				raise Exception.Create(PARSE_ERROR_MESSAGE + '"' + commandString + '".');
			end;
			commandArray := commandString.Split('|');
			if (commandArray.Length != 5)
			begin
				raise Exception.Create(PARSE_ERROR_MESSAGE + '"' + commandString + '".');
			end;

			result :=  DefaultRemoteCommand.Create(commandArray[1], [commandArray[2], commandArray[3]]);}
    end;

end.
