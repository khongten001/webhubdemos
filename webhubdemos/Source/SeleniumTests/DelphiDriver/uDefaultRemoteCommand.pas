unit uDefaultRemoteCommand;

interface
uses
  SysUtils,
  uIRemoteCommand, uCommon;

type
	DefaultRemoteCommand = class(TInterfacedObject, IRemoteCommand)
  public
    args: ArrayOfString;
		command: string;
  public
    constructor Create(_command: string; _args: ArrayOfString);
		function CommandString:string;
		class function Parse(commandString: string): DefaultRemoteCommand;
  end;

  const
    PARSE_ERROR_MESSAGE = 'Command string must contain 4 pipe characters and should start with a ''|''. Unable to parse command string';

implementation
uses
  ucString;

    constructor DefaultRemoteCommand.Create(_command: string; _args: ArrayOfString);
    begin
			command := _command;
			args := _args;
    end;

		function  DefaultRemoteCommand.CommandString: string;
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

		class function DefaultRemoteCommand.Parse(commandString: string): DefaultRemoteCommand;
    var
     commandArray: ArrayOfString;
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
