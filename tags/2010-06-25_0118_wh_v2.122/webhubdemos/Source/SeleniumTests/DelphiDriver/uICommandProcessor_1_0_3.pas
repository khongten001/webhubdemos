unit uICommandProcessor_1_0_3;

interface
uses
	uCommon;
	
type
  ICommandProcessor = interface
		function DoCommand(command: UTF8String; args: ArrayOfUTF8String)
      : UTF8String;
    procedure SetExtensionJs(extensionJs: UTF8String);
		procedure Start(); overload;
		procedure Start(optionsString: UTF8String); overload;
		procedure Stop();
		function GetString(command: UTF8String; args: ArrayOfUTF8String)
      : UTF8String;
		function GetStringArray(command: UTF8String; args: ArrayOfUTF8String)
      : ArrayOfUTF8String;
		function GetNumber(command: UTF8String; args: ArrayOfUTF8String): double;
		function GetNumberArray(command: UTF8String; args: ArrayOfUTF8String)
      : ArrayOfDouble;
		function GetBoolean(command: UTF8String; args: ArrayOfUTF8String): boolean;
		function GetBooleanArray(command: UTF8String; args: ArrayOfUTF8String)
      : ArrayOfBoolean;
	end;

implementation


end.
