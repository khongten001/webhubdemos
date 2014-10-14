unit DPrefix_Client_uInitialize;

interface

{$I hrefdefines.inc}

type
  TDPRAPIResponseHdrRec = record
    Version: Double;
    WebAPIStatus: string;
    DPRAPIErrorCode: Integer;
    DPRAPIErrorMessage: string;
  end;
  TDPRAPIResponseVersionsRec = record
    hdr: TDPRAPIResponseHdrRec;
    ApiInfo_Version: Double;
    WebAppAPISpec_Version: Integer;
    ImageList_Version: Integer;
    LingvoList_Version: Integer;
    TradukoList_Version: Integer;
  end;

var
  DPR_API_ResponseVersionsRec: TDPRAPIResponseVersionsRec;

implementation

uses
  SysUtils,
  Classes, Variants,
  {$IFDEF Delphi20UP}System.Json, {$ELSE} Data.DBXJSON, {$ENDIF}
  ucJSONWrapper,
  ucHttps;

function Client_Init(out ErrorText: string): Boolean;
var
  WebResponse: string;
const
  cStartDomain = 'delphiprefix.modulab.com';   // local testing 192.168.x.x
  cStartPath = 'win64'; // or 'scripts'
  cStartRunner = 'runisa_x_d21_win64.dll';
var
  URL_Versions: string;
  JSON: Variant;
  S1: string;
begin
  //WebResponse := HTTPSGet('http://lite.demos.href.com/adv:pgwhatismyip',
  //  ErrorText, 'TIdHttp', '', False, True);
  // <span id="ip">110.32.255.112</span>

  URL_Versions := Format('http://%s/%s/%s?dpr:jsonapirequest:999999:' +
    'Version=1.0;RequestType=APIInfo;RequestTypeVersion=1.0;' +
    'DetailLevel=%s;%d',
    [cStartDomain, cStartPath, cStartRunner, 'Versions', 3222]);
  WebResponse := HTTPSGet(URL_Versions, ErrorText, 'TIdHttp on Android', '',
    False, True);

  if ErrorText = '' then
  begin
    JSON := VarJSONCreate(TJSONObject.ParseJSONValue(WebResponse), True);
    S1 := JSON.DelphiPrefixRegistryResponse.Version;
    DPR_API_ResponseVersionsRec.hdr.Version := StrToFloatDef(S1, 0.0);
    DPR_API_ResponseVersionsRec.hdr.WebAPIStatus :=
      JSON.DelphiPrefixRegistryResponse.WebAPIStatus;
    DPR_API_ResponseVersionsRec.hdr.DPRAPIErrorCode :=
      StrToIntDef(JSON.DelphiPrefixRegistryResponse.DPRAPIErrorCode, 5);
    DPR_API_ResponseVersionsRec.hdr.DPRAPIErrorMessage :=
      JSON.DelphiPrefixRegistryResponse.DPRAPIErrorMessage;

    if DPR_API_ResponseVersionsRec.hdr.DPRAPIErrorCode = 0 then
    begin
      S1 := JSON.DelphiPrefixRegistryResponse.Payload.APIInfo.Version;
      DPR_API_ResponseVersionsRec.ApiInfo_Version := StrToFloat(S1, 0.0);
      DPR_API_ResponseVersionsRec.WebAppAPISpec_Version :=
        StrToIntDef(JSON.DelphiPrefixRegistryResponse.Payload.APIInfo.
          WebAppAPISpec.Version, 0);
      DPR_API_ResponseVersionsRec.ImageList_Version :=
        StrToIntDef(JSON.DelphiPrefixRegistryResponse.Payload.APIInfo.
          ImageList.Version, 0);
      DPR_API_ResponseVersionsRec.TradukoList_Version :=
        StrToIntDef(JSON.DelphiPrefixRegistryResponse.Payload.APIInfo.
          TradukoList.Version, 0);
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;
end;

end.
