program DPrefix_Client;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2014 HREF Tools Corp.  All Rights Reserved Worldwide.      * }
{ *                                                                          * }
{ * This source code file is part of the Delphi Prefix Registry.             * }
{ *                                                                          * }
{ * This file is licensed under a Creative Commons Attribution 2.5 License.  * }
{ * http://creativecommons.org/licenses/by/2.5/                              * }
{ * If you use this file, please keep this notice intact.                    * }
{ *                                                                          * }
{ * Author: Ann Lynnworth                                                    * }
{ *                                                                          * }
{ * Refer friends and colleagues to www.href.com/whvcl. Thanks!              * }
{ ---------------------------------------------------------------------------- }

uses
  System.StartUpCopy,
  {$IFDEF NEXTGEN}
  // This patch makes AnsiString etc available for use in FireMonkey apps.
  // http://andy.jgknet.de/blog/2014/09/system-bytestrings-support-for-xe7/
  System.ByteStrings,
  {$ENDIF}
  FMX.Forms,
  DPrefix_Client_uMain in 'DPrefix_Client_uMain.pas' {WebBrowserForm},
  ucHttps in 'K:\WebHub\tpack\ucHttps.pas',
  DPrefix_Client_uInitialize in 'DPrefix_Client_uInitialize.pas';

{$R *.res}

var
  s8: UTF8String = '';  // this compiles for Android when System.ByteStrings is patched

begin
  Application.Initialize;
  Application.CreateForm(TWebBrowserForm, WebBrowserForm);
  Application.Run;
end.
