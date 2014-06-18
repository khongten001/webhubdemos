unit WHBridge2EditPad_uIni;

interface

function EPPExtractFileList(const InEditPadIniFilespec: string): string;

implementation

uses
  Classes, SysUtils, IniFiles,
  ucLogFil, ucString, ucCodeSiteInterface;

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
