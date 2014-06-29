unit WHBridge2EditPad_uLoadWHCommands;

interface

uses
  Classes, SysUtils;

type
  TWebHubCommandInfoRec = record
    WHVersion: string;
    WHCommandNames: array of string;
    WHSyntax: string;
    WHTemplate: string;
    WHCaption: string;
    WHExpand: string;
    WHHint: string;
    WHGrp: string;
    WHCategory: string;
    WHCatNum: Integer;
    WHSeq: Integer;
    WHSort: Integer;
    WHTest: string;
  end;
type
  TWebHubCommandInfoList = Array of TWebHubCommandInfoRec;

function GetStringListResource(const inResName: string): TStringList;
function LoadWebHubCommandInfo: TWebHubCommandInfoList;

implementation

uses
  Windows,
  ucString, ucLogFil, ucCodeSiteInterface;

function GetStringListResource(const inResName: string): TStringList;
const cFn = 'GetStringListResource';
var
  res: TResourceStream;
  pTrg: PByte;
  Data8: UTF8String;
begin
  CSEnterMethod(nil, cFn);
  Result := nil;
  CSSend('inResName', inResName);
  res := nil;
  try
    try
      res := TResourceStream.Create(HInstance, InResName, RT_RCDATA);
      res.Seek(0, soBeginning);
      CSSend('res.Size', S(res.Size));
      SetLength(Data8, res.Size);
      pTrg := Addr(Data8[1]);
      res.Read(pTrg^, res.Size);
      StripUTF8BOM(Data8);
      Result := TStringList.Create;
      Result.Text := string(Data8);
    except
      on E: Exception do
      begin
        CSSendException(E);
        FreeAndNil(Result);
      end;
    end;
  finally
    FreeAndNil(res);
  end;
  LogToCodeSiteKeepCRLF('Result', Copy(Result.Text, 1, 1024));
  CSExitMethod(nil, cFn);
end;

function LoadWebHubCommandInfo: TWebHubCommandInfoList;
const cFn = 'LoadWebHubCommandInfo';
var
  y: TStringList;
  i, n: Integer;
  temp: string;
  a1, a2, a3: string;
  ANames: string;
begin
  CSEnterMethod(nil, cFn);
  SetLength(Result, 0);
  y := nil;
  try
    y := GetStringListResource('WebHubCommandsTabDelim');
    n := y.Count;
    SetLength(Result, n);

    for i := 0 to Pred(n) do
    begin
      a1 := y[i];
      if SplitFive(y[i], #9, Result[i].WHVersion, ANames,
        Result[i].WHSyntax, Result[i].WHTemplate, temp) then
      begin
        SplitString(ANames, ',', a1, a2);
        if a2 <> '' then
        begin
          SetLength(Result[i].WHCommandNames, 2);
          Result[i].WHCommandNames[1] := a2;
          //CSSend(S(i), a2);
        end
        else
          SetLength(Result[i].WHCommandNames, 1);
        Result[i].WHCommandNames[0] := a1;
        //CSSend(S(i), a1);

        if SplitFive(temp, #9, Result[i].WHCaption, Result[i].WHExpand,
          Result[i].WHHint, Result[i].WHGrp, a1) then
        begin
          temp := a1;
          if SplitFive(temp, #9, Result[i].WHCategory, a1, a2, a3,
            Result[i].WHTest) then
          begin
            Result[i].WHCatNum := StrToIntDef(a1, -1);
            Result[i].WHSeq := StrToIntDef(a2, -1);
            Result[i].WHSort := StrToIntDef(a3, -1);
            //CSSend('WHSort', a3);
          end;
        end;
      end;
    end;

  finally
    FreeAndNil(y);
  end;
  CSSend('Length', S(Length(Result)));
  CSExitMethod(nil, cFn);
end;


end.
