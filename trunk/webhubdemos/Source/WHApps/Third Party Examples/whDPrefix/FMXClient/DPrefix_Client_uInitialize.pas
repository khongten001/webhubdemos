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
    LocalFilespec: string;
  end;
  TDPRAPIResponseImageListRec = record
    hdr: TDPRAPIResponseHdrRec;
    ApiInfo_Version: Double;
    ImageList_Version: Integer;
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
  System.JSON,
//  {$IFNDEF FMACTIVE}ucJSONWrapper,{$ENDIF}
  ucHttps;

const
  cUserAgent = 'TIdHttp on Android';

function Client_Documents_Path: string;
begin
  Result := TPath.GetDocumentsPath + PathDelim + 'DelphiPrefixRegistry' +
    PathDelim;
end;

function NoQuotes(const Value: string): string;
begin
  Result := Copy(Value, 2, Length(Value) - 2);
end;

function JsonRequestParseHdr(const InURL: string;
  out hdr: TDPRAPIResponseHdrRec; out ErrorText: string;
  out ApiInfo_Version: Double; out APIInfoJO: TJSONObject): Boolean;
var
  WebResponse: string;
  pair: TJSONPair;
  DelphiPrefixRegistryResponseJ0: TJSONObject;
  PayloadJO: TJSONObject;
  JO: TJSONObject;
  TempStr: string;
  S1: string;
begin
  Result := False;

  DelphiPrefixRegistryResponseJ0 := nil;
  PayloadJO := nil;
  APIInfoJO := nil;

  WebResponse := HTTPSGet(InURL, ErrorText, cUserAgent, '', False, True);
  if ErrorText = '' then
  begin

    try
      JO := TJSONObject.Create;
      if (JO.Parse(BytesOf(WebResponse), 0) >= 0) then
      begin
        if JO.Count = 1 then
        begin
          pair := JO.Pairs[0];
          TempStr := pair.JsonString.Value;
          if TempStr = 'DelphiPrefixRegistryResponse' then
          begin
            S1 := pair.JsonValue.ToString;
            DelphiPrefixRegistryResponseJ0 := TJSONObject.Create;
            DelphiPrefixRegistryResponseJ0.Parse(BytesOf(S1), 0);

            pair := DelphiPrefixRegistryResponseJ0.Pairs[0];  // version
            S1 := NoQuotes(pair.JsonValue.ToString);
            hdr.Version := StrToFloatDef(S1, 0.0);

            pair := DelphiPrefixRegistryResponseJ0.Pairs[1];  // WebAPIStatus
            S1 := NoQuotes(pair.JsonValue.ToString);
            hdr.WebAPIStatus := S1;

            pair := DelphiPrefixRegistryResponseJ0.Pairs[4];  // DPRAPIErrorCode
            S1 := NoQuotes(pair.JsonValue.ToString);
            hdr.DPRAPIErrorCode := StrToIntDef(S1, 5);

            pair := DelphiPrefixRegistryResponseJ0.Pairs[5];  // DPRAPIErrorMessage
            S1 := NoQuotes(pair.JsonValue.ToString);
            hdr.DPRAPIErrorMessage := S1;


            if hdr.DPRAPIErrorCode = 0 then
            begin

              pair := DelphiPrefixRegistryResponseJ0.Pairs[6];  // Payload
              S1 := pair.JsonValue.ToString;
              PayloadJO := TJSONObject.Create;
              PayloadJO.Parse(BytesOf(S1), 0);

              pair := PayloadJO.Pairs[0];  // APIInfo
              S1 := pair.JsonValue.ToString;
              APIInfoJO := TJSONObject.Create;
              APIInfoJO.Parse(BytesOf(S1), 0);

              pair := APIInfoJO.Pairs[0];  // Version
              S1 := NoQuotes(pair.JsonValue.ToString);
              ApiInfo_Version := StrToFloatDef(S1, 0.0);

              Result := True;

            end;
          end;
        end;
      end;
    finally
      FreeAndNil(DelphiPrefixRegistryResponseJ0);
      FreeAndNil(PayloadJO);
      // do not free APIInfoJO
    end;
  end;
end;


function Client_Init(out ErrorText: string): Boolean;
var
  WebResponse: string;
const
  cStartDomain = 'delphiprefix.modulab.com';   // local testing 192.168.x.x
  cStartPath = 'win64';
  cStartRunner = 'runisa_x_d21_win64.dll';
var
  URL_Versions: string;
  URL_ImageList: string;
  //JSONV: Variant;
  //DelphiPrefixRegistryResponse: Variant;
  APIInfoJO: TJSONObject;
  S1: string;
  sb: TStringList;
  ImageListJO, ImagesJO, ImageJO, JO, JO2: TJSONObject;
  pair: TJSONPair;
begin
  Result := False;
  JO := nil;
  JO2 := nil;
  APIInfoJO := nil;
  ImageListJO := nil;
  ImagesJO := nil;  // plural
  ImageJO := nil;   // singular

  //WebResponse := HTTPSGet('http://lite.demos.href.com/adv:pgwhatismyip',
  //  ErrorText, 'TIdHttp', '', False, True);
  // <span id="ip">110.32.255.112</span>

  URL_Versions := Format('http://%s/%s/%s?dpr:jsonapirequest:999999:' +
    'Version=1.0;RequestType=APIInfo;RequestTypeVersion=1.0;' +
    'DetailLevel=%s;%s',
    [cStartDomain, cStartPath, cStartRunner, 'Versions',
      FormatDateTime('hhnn', Now)  // 4 digits that vary sufficiently
    ]);
  JsonRequestParseHdr(URL_Versions, DPR_API_Versions_Rec.hdr, ErrorText,
    DPR_API_Versions_Rec.ApiInfo_Version, APIInfoJO);

  if ErrorText = '' then
  begin

    if DPR_API_Versions_Rec.hdr.DPRAPIErrorCode = 0 then
    begin

      pair := APIInfoJO.Pairs[2];  // WebAppAPISpec

      S1 := pair.JsonValue.ToString;
      JO2 := TJSONObject.Create;
      JO2.Parse(BytesOf(S1), 0);

      pair := JO2.Pairs[0];        // WebAppAPISpec Version
      S1 := NoQuotes(pair.JsonValue.ToString);
      DPR_API_Versions_Rec.WebAppAPISpec_Version := StrToIntDef(S1, 0);

      pair := APIInfoJO.Pairs[3];  // ImageList

      S1 := pair.JsonValue.ToString;
      JO2 := TJSONObject.Create;
      JO2.Parse(BytesOf(S1), 0);

      pair := JO2.Pairs[0];        // ImageList Version
      S1 := NoQuotes(pair.JsonValue.ToString);
      DPR_API_Versions_Rec.ImageList_Version := StrToIntDef(S1, 0);

      pair := APIInfoJO.Pairs[4];  // LingvoList

      S1 := pair.JsonValue.ToString;
      JO2 := TJSONObject.Create;
      JO2.Parse(BytesOf(S1), 0);

      pair := JO2.Pairs[0];        // LingvoList Version
      S1 := NoQuotes(pair.JsonValue.ToString);
      DPR_API_Versions_Rec.LingvoList_Version := StrToIntDef(S1, 0);

      pair := APIInfoJO.Pairs[5];  // TradukoList

      S1 := pair.JsonValue.ToString;
      JO2 := TJSONObject.Create;
      JO2.Parse(BytesOf(S1), 0);

      pair := JO2.Pairs[0];        // TradukoList Version
      S1 := NoQuotes(pair.JsonValue.ToString);
      DPR_API_Versions_Rec.TradukoList_Version := StrToIntDef(S1, 0);
      Result := True;
    end;
  end;

  if Result then
  begin
    URL_ImageList := Format('http://%s/%s/%s?dpr:jsonapirequest:999999:' +
      'Version=1.0;RequestType=APIInfo;RequestTypeVersion=1.0;' +
      'DetailLevel=%s;%s',
      [cStartDomain, cStartPath, cStartRunner, 'ImageList',
        FormatDateTime('hhnn', Now)  // 4 digits that vary sufficiently
      ]);

    FreeAndNil(APIInfoJO);

    JsonRequestParseHdr(URL_ImageList, DPR_API_ImageList_Rec.hdr, ErrorText,
      DPR_API_ImageList_Rec.ApiInfo_Version, APIInfoJO);


    if DPR_API_ImageList_Rec.hdr.DPRAPIErrorCode = 0 then
    begin

      pair := APIInfoJO.Pairs[2];  // ImageList
      S1 := pair.JsonValue.ToString;
      ImageListJO := TJSONObject.Create;
      ImageListJO.Parse(BytesOf(S1), 0);

      pair := ImageListJO.Pairs[0];  // ImageList Version
      S1 := NoQuotes(pair.JsonValue.ToString);
      DPR_API_ImageList_Rec.ImageList_Version := StrToIntDef(S1, 0);

      pair := ImageListJO.Pairs[1];  // ImageList Count
      S1 := pair.JsonValue.ToString;  // do not strip quotes from true integer
      DPR_API_ImageList_Rec.Count := StrToIntDef(S1, 0);
      if (DPR_API_ImageList_Rec.Count = 2) then
      begin
        SetLength(DPR_API_ImageList_Rec.ImageList, DPR_API_ImageList_Rec.Count);
        DPR_API_ImageList_Rec.ImageList[0].ImageIdentifier := 'Welcome';

        pair := ImageListJO.Pairs[2];  // ImageList .... Images
        S1 := pair.JsonValue.ToString;
        ImagesJO := TJSONObject.Create;
        ImagesJO.Parse(BytesOf(S1), 0);

        pair := ImagesJO.Pairs[0];  // start Welcome Image
        S1 := pair.JsonValue.ToString;
        ImageJO := TJSONObject.Create;
        ImageJO.Parse(BytesOf(S1), 0);

        pair := ImageJO.Pairs[0];  // Image Version
        S1 := NoQuotes(pair.JsonValue.ToString);
        DPR_API_ImageList_Rec.ImageList[0].Version := StrToIntDef(S1, 0);

        pair := ImageJO.Pairs[1];  // Image URL
        S1 := NoQuotes(pair.JsonValue.ToString);
        DPR_API_ImageList_Rec.ImageList[0].URL := S1;

        pair := ImagesJO.Pairs[1];  // start Goodbye Image
        S1 := pair.JsonValue.ToString;
        ImageJO := TJSONObject.Create;
        ImageJO.Parse(BytesOf(S1), 0);

        pair := ImageJO.Pairs[0];  // Image Version
        S1 := NoQuotes(pair.JsonValue.ToString);
        DPR_API_ImageList_Rec.ImageList[1].Version := StrToIntDef(S1, 0);

        pair := ImageJO.Pairs[1];  // Image URL
        S1 := NoQuotes(pair.JsonValue.ToString);
        DPR_API_ImageList_Rec.ImageList[1].URL := S1;

        Result := True;
      end;
    end;



  end;

  FreeAndNil(ImageListJO);
  FreeAndNil(ImagesJO);
  FreeAndNil(ImageJO);
  FreeAndNil(APIInfoJO);
  FreeAndNil(JO);
  FreeAndNil(JO2);


(* ok to use ucJSONWrapper on windows but not Android
    JSONV := VarJSONCreate(TJSONObject.ParseJSONValue(WebResponse), True);
    DelphiPrefixRegistryResponse := JSONV.DelphiPrefixRegistryResponse;
    S1 := DelphiPrefixRegistryResponse.Version;
    DPR_API_Versions_Rec.hdr.Version := StrToFloatDef(S1, 0.0);
    DPR_API_Versions_Rec.hdr.WebAPIStatus :=
      DelphiPrefixRegistryResponse.WebAPIStatus;
    DPR_API_Versions_Rec.hdr.DPRAPIErrorCode :=
      StrToIntDef(DelphiPrefixRegistryResponse.DPRAPIErrorCode, 5);
    DPR_API_Versions_Rec.hdr.DPRAPIErrorMessage :=
      DelphiPrefixRegistryResponse.DPRAPIErrorMessage;
*)

(*
    if DPR_API_Versions_Rec.hdr.DPRAPIErrorCode = 0 then
    begin
      S1 := DelphiPrefixRegistryResponse.Payload.APIInfo.Version;
      DPR_API_Versions_Rec.ApiInfo_Version := StrToFloatDef(S1, 0.0);
      DPR_API_Versions_Rec.WebAppAPISpec_Version :=
        StrToIntDef(DelphiPrefixRegistryResponse.Payload.APIInfo.
          WebAppAPISpec.Version, 0);
      DPR_API_Versions_Rec.ImageList_Version :=
        StrToIntDef(DelphiPrefixRegistryResponse.Payload.APIInfo.
          ImageList.Version, 0);
      DPR_API_Versions_Rec.LingvoList_Version :=
        StrToIntDef(DelphiPrefixRegistryResponse.Payload.APIInfo.
          LingvoList.Version, 0);
      DPR_API_Versions_Rec.TradukoList_Version :=
        StrToIntDef(DelphiPrefixRegistryResponse.Payload.APIInfo.
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
      JSONV := VarJSONCreate(TJSONObject.ParseJSONValue(WebResponse), True);
      DelphiPrefixRegistryResponse := JSONV.DelphiPrefixRegistryResponse;
      S1 := DelphiPrefixRegistryResponse.Version;
      DPR_API_ImageList_Rec.hdr.Version := StrToFloatDef(S1, 0.0);
      DPR_API_ImageList_Rec.hdr.WebAPIStatus :=
        DelphiPrefixRegistryResponse.WebAPIStatus;
      DPR_API_ImageList_Rec.hdr.DPRAPIErrorCode :=
        StrToIntDef(DelphiPrefixRegistryResponse.DPRAPIErrorCode, 5);
      DPR_API_ImageList_Rec.hdr.DPRAPIErrorMessage :=
        DelphiPrefixRegistryResponse.DPRAPIErrorMessage;

      if DPR_API_ImageList_Rec.hdr.DPRAPIErrorCode = 0 then
      begin
        S1 := DelphiPrefixRegistryResponse.Payload.APIInfo.Version;
        DPR_API_ImageList_Rec.ApiInfo_Version := StrToFloatDef(S1, 0.0);
        DPR_API_ImageList_Rec.Count :=
          DelphiPrefixRegistryResponse.Payload.APIInfo.ImageList.Count;
        if DPR_API_ImageList_Rec.Count = 2 then
        begin
          SetLength(DPR_API_ImageList_Rec.ImageList, DPR_API_ImageList_Rec.Count);
          DPR_API_ImageList_Rec.ImageList[0].ImageIdentifier := 'Welcome';
          DPR_API_ImageList_Rec.ImageList[0].Version :=
            DelphiPrefixRegistryResponse.Payload.APIInfo.ImageList.Images.Welcome.Version;
          DPR_API_ImageList_Rec.ImageList[0].URL :=
            DelphiPrefixRegistryResponse.Payload.APIInfo.ImageList.Images.Welcome.URL;
          DPR_API_ImageList_Rec.ImageList[1].ImageIdentifier := 'Goodbye';
          DPR_API_ImageList_Rec.ImageList[1].Version :=
            DelphiPrefixRegistryResponse.Payload.APIInfo.ImageList.Images.Goodbye.Version;
          DPR_API_ImageList_Rec.ImageList[1].URL :=
            DelphiPrefixRegistryResponse.Payload.APIInfo.ImageList.Images.Goodbye.URL;


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
    *)

  if Result then
  begin
    if High(DPR_API_ImageList_Rec.ImageList) > 0 then
    begin
      WebResponse := HTTPSGet(DPR_API_ImageList_Rec.ImageList[0].URL,
        ErrorText, cUserAgent, '', False, True);

      sb := nil;
      try
        sb := TStringList.Create;
        sb.Text := WebResponse;
        ForceDirectories(Client_Documents_Path);
        DPR_API_ImageList_Rec.ImageList[0].LocalFilespec :=
          IncludeTrailingPathDelimiter(Client_Documents_Path) +
          'welcome.svg';
        sb.SaveToFile(DPR_API_ImageList_Rec.ImageList[0].LocalFilespec);
      finally
        FreeAndNil(sb);
      end;
    end;
  end;
end;

end.
