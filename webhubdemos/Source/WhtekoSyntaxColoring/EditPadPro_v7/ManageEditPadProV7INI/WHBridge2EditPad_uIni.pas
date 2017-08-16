unit WHBridge2EditPad_uIni;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2014-2017 HREF Tools Corp.                                 * }
{ *                                                                          * }
{ * This source code file is part of the WebHub plug-in for EditPad Pro.     * }
{ *                                                                          * }
{ * This file is licensed under a Creative Commons Attribution 2.5 License.  * }
{ * http://creativecommons.org/licenses/by/2.5/                              * }
{ * If you use this file, please keep this notice intact.                    * }
{ *                                                                          * }
{ * Author: Ann Lynnworth                                                    * }
{ *                                                                          * }
{ * Refer friends and colleagues to www.href.com/whvcl. Thanks!              * }
{ ---------------------------------------------------------------------------- }

interface

function EPPExtractFileList(const InEditPadIniFilespec: string): string;

implementation

uses
  Classes, SysUtils, IniFiles,
  ucLogFil, ucString, ZM_CodeSiteInterface;

function EPPExtractFileList(const InEditPadIniFilespec: string): string;
const cFn = 'EPPExtractFileList';
var
  sb: TStringBuilder;
  y: TStringList;
  i: Integer;
  Temp1, AFilespec: string;

begin
  CSEnterMethod(nil, cFn);

  //CSSend('InEditPadIniFilespec', InEditPadIniFilespec);

  y := nil;
  sb := nil;
  Result := '';

  if FileExists(InEditPadIniFilespec) then
  try
    y := TStringList.Create;
    sb := TStringBuilder.Create;
    y.LoadFromFile(InEditPadIniFilespec);

    for i := 0 to Pred(y.Count) do
    begin
      SplitString(y[i], '=', Temp1, AFilespec);
      if Temp1 = 'Filename' then
      begin
        //CSSend('AFilespec', AFilespec);
        sb.AppendLine(AFilespec);
      end;
    end;
    Result := sb.ToString;
  finally
    FreeAndNil(sb);
    FreeAndNil(y);
  end;
  CSExitMethod(nil, cFn);
end;


end.
