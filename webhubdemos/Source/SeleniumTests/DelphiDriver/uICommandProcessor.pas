unit uICommandProcessor;

interface
uses
	uCommon;
	
type
  ICommandProcessor = interface
		function DoCommand(command: string; args: ArrayOfString): string;
		procedure Start();
		procedure Stop();
		function GetString(command: String; args: ArrayOfString): String;
		function GetStringArray(command: String; args: ArrayOfString): ArrayOfString;
		function GetNumber(command: String; args: ArrayOfString): double;
		function GetNumberArray(command: String; args: ArrayOfString): ArrayOfDouble;
		function GetBoolean(command: String; args: ArrayOfString): boolean;
		function GetBooleanArray(command: String; args: ArrayOfString): ArrayOfBoolean;
	end;

implementation


end.
