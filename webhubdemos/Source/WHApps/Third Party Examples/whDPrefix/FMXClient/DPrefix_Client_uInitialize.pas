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
  TDPRAPIImageRec = record
    ImageIdentifier: string;
    Version: Integer;
    URL: string;
  end;
  TDPRAPIResponseImageListRec = record
    hdr: TDPRAPIResponseHdrRec;
    ApiInfo_Version: Double;
    Count: Integer;
    ImageList: array of TDPRAPIImageRec;
  end;

var
  DPR_API_Versions_Rec: TDPRAPIResponseVersionsRec;
  DPR_API_ImageList_Rec: TDPRAPIResponseImageListRec;

function Client_Init(out ErrorText: string): Boolean;

implementation

uses
  SysUtils,
  Classes,
  Variants,
  System.IOUtils,
  {$IFDEF Delphi20UP}System.Json, {$ELSE} Data.DBXJSON, {$ENDIF}
  ucJSONWrapper,
  ucHttps, ucShell;

const
  cUserAgent = 'TIdHttp on Android';

function Client_Documents_Path: string;
begin
  Result := TPath.GetDocumentsPath + PathDelim + 'DelphiPrefixRegistry' +
    PathDelim;
end;

function Client_Init(out ErrorText: string): Boolean;
var
  WebResponse: string;
const
  cStartDomain = 'delphiprefix.modulab.com';   // local testing 192.168.x.x
  cStartPath = 'win64'; // or 'scripts'
  cStartRunner = 'runisa_x_d21_win64.dll';
var
  URL_Versions: string;
  URL_ImageList: string;
  JSON: Variant;
  S1: string;
  sb: TStringList;
begin
  //WebResponse := HTTPSGet('http://lite.demos.href.com/adv:pgwhatismyip',
  //  ErrorText, 'TIdHttp', '', False, True);
  // <span id="ip">110.32.255.112</span>

  URL_Versions := Format('http://%s/%s/%s?dpr:jsonapirequest:999999:' +
    'Version=1.0;RequestType=APIInfo;RequestTypeVersion=1.0;' +
    'DetailLevel=%s;%s',
    [cStartDomain, cStartPath, cStartRunner, 'Versions',
      FormatDateTime('hhnn', Now)  // 4 digits that vary sufficiently
    ]);
  WebResponse := HTTPSGet(URL_Versions, ErrorText, cUserAgent, '',
    False, True);

  if ErrorText = '' then
  begin
    JSON := VarJSONCreate(TJSONObject.ParseJSONValue(WebResponse), True);
    S1 := JSON.DelphiPrefixRegistryResponse.Version;
    DPR_API_Versions_Rec.hdr.Version := StrToFloatDef(S1, 0.0);
    DPR_API_Versions_Rec.hdr.WebAPIStatus :=
      JSON.DelphiPrefixRegistryResponse.WebAPIStatus;
    DPR_API_Versions_Rec.hdr.DPRAPIErrorCode :=
      StrToIntDef(JSON.DelphiPrefixRegistryResponse.DPRAPIErrorCode, 5);
    DPR_API_Versions_Rec.hdr.DPRAPIErrorMessage :=
      JSON.DelphiPrefixRegistryResponse.DPRAPIErrorMessage;

    if DPR_API_Versions_Rec.hdr.DPRAPIErrorCode = 0 then
    begin
      S1 := JSON.DelphiPrefixRegistryResponse.Payload.APIInfo.Version;
      DPR_API_Versions_Rec.ApiInfo_Version := StrToFloatDef(S1, 0.0);
      DPR_API_Versions_Rec.WebAppAPISpec_Version :=
        StrToIntDef(JSON.DelphiPrefixRegistryResponse.Payload.APIInfo.
          WebAppAPISpec.Version, 0);
      DPR_API_Versions_Rec.ImageList_Version :=
        StrToIntDef(JSON.DelphiPrefixRegistryResponse.Payload.APIInfo.
          ImageList.Version, 0);
      DPR_API_Versions_Rec.LingvoList_Version :=
        StrToIntDef(JSON.DelphiPrefixRegistryResponse.Payload.APIInfo.
          LingvoList.Version, 0);
      DPR_API_Versions_Rec.TradukoList_Version :=
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

  if Result then
  begin
    URL_ImageList := Format('http://%s/%s/%s?dpr:jsonapirequest:999999:' +
      'Version=1.0;RequestType=APIInfo;RequestTypeVersion=1.0;' +
      'DetailLevel=%s;%s',
      [cStartDomain, cStartPath, cStartRunner, 'ImageList',
        FormatDateTime('hhnn', Now)  // 4 digits that vary sufficiently
      ]);
    WebResponse := HTTPSGet(URL_ImageList, ErrorText, cUserAgent, '',
      False, True);

    if ErrorText = '' then
    begin
      JSON := VarJSONCreate(TJSONObject.ParseJSONValue(WebResponse), True);
      S1 := JSON.DelphiPrefixRegistryResponse.Version;
      DPR_API_ImageList_Rec.hdr.Version := StrToFloatDef(S1, 0.0);
      DPR_API_ImageList_Rec.hdr.WebAPIStatus :=
        JSON.DelphiPrefixRegistryResponse.WebAPIStatus;
      DPR_API_ImageList_Rec.hdr.DPRAPIErrorCode :=
        StrToIntDef(JSON.DelphiPrefixRegistryResponse.DPRAPIErrorCode, 5);
      DPR_API_ImageList_Rec.hdr.DPRAPIErrorMessage :=
        JSON.DelphiPrefixRegistryResponse.DPRAPIErrorMessage;

      if DPR_API_ImageList_Rec.hdr.DPRAPIErrorCode = 0 then
      begin
        S1 := JSON.DelphiPrefixRegistryResponse.Payload.APIInfo.Version;
        DPR_API_ImageList_Rec.ApiInfo_Version := StrToFloatDef(S1, 0.0);
        DPR_API_ImageList_Rec.Count :=
          JSON.DelphiPrefixRegistryResponse.Payload.APIInfo.ImageList.Count;
        if DPR_API_ImageList_Rec.Count = 2 then
        begin
          SetLength(DPR_API_ImageList_Rec.ImageList, DPR_API_ImageList_Rec.Count);
          DPR_API_ImageList_Rec.ImageList[0].ImageIdentifier := 'Welcome';
          DPR_API_ImageList_Rec.ImageList[0].Version :=
            JSON.DelphiPrefixRegistryResponse.Payload.APIInfo.ImageList.Images.Welcome.Version;
          DPR_API_ImageList_Rec.ImageList[0].URL :=
            JSON.DelphiPrefixRegistryResponse.Payload.APIInfo.ImageList.Images.Welcome.URL;
          DPR_API_ImageList_Rec.ImageList[1].ImageIdentifier := 'Goodbye';
          DPR_API_ImageList_Rec.ImageList[1].Version :=
            JSON.DelphiPrefixRegistryResponse.Payload.APIInfo.ImageList.Images.Goodbye.Version;
          DPR_API_ImageList_Rec.ImageList[1].URL :=
            JSON.DelphiPrefixRegistryResponse.Payload.APIInfo.ImageList.Images.Goodbye.URL;

          WebResponse := HTTPSGet(DPR_API_ImageList_Rec.ImageList[0].URL,
            ErrorText, cUserAgent, '', False, True);

          sb := nil;
          try
            sb := TStringList.Create;
            sb.Text := WebResponse;
            ForceDirectories(Client_Documents_Path);
            sb.SaveToFile(IncludeTrailingPathDelimiter(Client_Documents_Path) +
              'welcome.svg');
            WinShellOpen(IncludeTrailingPathDelimiter(Client_Documents_Path) +
              'welcome.svg');
          finally
            FreeAndNil(sb);
          end;

        end
        else
          Result := False;
      end
      else
      begin
        Result := False;
      end;
    end;
  end;
end;

end.
