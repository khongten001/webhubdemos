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

  TDPRAPITradukiRec = record
    Identifier: string;
    Lingvo3: string;
    Translation: string;
  end;
  TDPRAPITradukoListRec = record
    hdr: TDPRAPIResponseHdrRec;
    ApiInfo_Version: Double;
    TradukoList_Version: Integer;
    Count: Integer;
    LingvoCount: Integer;
    TradukiList: array of TDPRAPITradukiRec;
  end;

var
  DPR_API_Versions_Rec: TDPRAPIResponseVersionsRec;
  DPR_API_ImageList_Rec: TDPRAPIResponseImageListRec;
  DPR_API_TradukoList_Rec: TDPRAPITradukoListRec;

function Client_Init(out ErrorText: string): Boolean;

function Translate(const InKeyword, InLingvo3: string): string;

implementation

uses
  SysUtils,
  Classes,
  Variants,
  System.IOUtils,
  System.JSON,
  ucHttps;

const
  cUserAgent = 'TIdHttp on Android';
var
  FlagInitDone: Boolean = False;

function Client_Documents_Path: string;
begin
  Result := TPath.GetDocumentsPath + PathDelim + 'DelphiPrefixRegistry' +
    PathDelim;
end;

function NoQuotes(const Value: string): string;
begin
  Result := Copy(Value, 2, Length(Value) - 2);
end;

procedure StrSaveToFile(const Value, Filespec: string; Encoding: TEncoding);
var
  y: TStringList;
begin
  y := nil;
  try
    y := TStringList.Create;
    y.Text := Value;
    ForceDirectories(ExtractFilePath(Filespec));
    y.SaveToFile(Filespec, Encoding);
  finally
    FreeAndNil(y);
  end;
end;

function StrLoadFromFile(const Filespec: string): string;
var
  y: TStringList;
begin
  y := nil;
  try
    y := TStringList.Create;
    y.LoadFromFile(Filespec);
    Result := y.Text;
  finally
    FreeAndNil(y);
  end;
end;

const
  cTreatAsUTF8 = True;

function JSONtoInteger(AJO: TJSONObject; AFieldName: string;
  const FlagQuotes: Boolean = False): Integer;
var
  AJP: TJSONPair;
begin
  AJP := AJO.Get(AFieldName);
  if (AJP <> nil) then
  begin
    if FlagQuotes then
      Result := StrToIntDef(NoQuotes(AJP.JsonValue.ToString), 0)
    else
      Result := StrToIntDef(AJP.JsonValue.ToString, 0);
  end;
end;

function JSONtoString(AJO: TJSONObject; AFieldName: string): Integer;
var
  AJP: TJSONPair;
begin
  AJP := AJO.Get(AFieldName);
  if (AJP <> nil) then
    Result := NoQuotes(AJP.JsonValue.ToString);
end;


function JsonRequestParseHdr(const InURL: string; const Keyword: string;
  var AlreadyCached: Boolean;
  var hdr: TDPRAPIResponseHdrRec; out ErrorText: string;
  out ApiInfo_Version: Double; var APIInfoJV: TJSONValue): Boolean;
var
  MJO: TJSONObject;
  WebResponse: string;
  WebResponse8: UTF8String;
  pair: TJSONPair;
  DelphiPrefixRegistryResponseJ0: TJSONObject;
  PayloadJO: TJSONObject;
  JO: TJSONObject;
  JOV: TJSONValue;
  TempStr: string;
  S1: string;
  S8: UTF8String;
  VersionsJsonFilespec: string;
  PreviousVersionsJsonStr8: UTF8String;
begin
  Result := False;

  DelphiPrefixRegistryResponseJ0 := nil;
  PayloadJO := nil;
  APIInfoJV := nil;

  MJO := TJSONObject.Create;

  WebResponse := HTTPSGet(InURL, ErrorText, cUserAgent, '', False, True);
  WebResponse8 := UTF8Encode(WebResponse);

  if ErrorText = '' then
  begin

    if Keyword = 'Versions' then
    begin
      AlreadyCached := False;
      VersionsJsonFilespec := Client_Documents_Path + PathDelim + Keyword +
        '.json';
      if FileExists(VersionsJsonFilespec) then
        PreviousVersionsJsonStr8 := UTF8String(StrLoadFromFile(VersionsJsonFilespec))
      else
        PreviousVersionsJsonStr8 := '';
      if string(PreviousVersionsJsonStr8) = string(WebResponse8) then
        AlreadyCached := True;

      if NOT AlreadyCached then
        StrSaveToFile(string(WebResponse8), VersionsJsonFilespec, TEncoding.UTF8);
    end;

    try
      JOV := JO.ParseJSONValue(BytesOf(WebResponse8), 0, cTreatAsUTF8);
      if NOT JOV.Null then
      begin
        JO := TJSONObject(JOV);
        if JO.Count = 1 then
        begin
          pair := JO.Pairs[0];
          TempStr := pair.JsonString.Value;
          if TempStr = 'DelphiPrefixRegistryResponse' then
          begin
            S8 := pair.JsonValue.ToString;
            JOV := DelphiPrefixRegistryResponseJ0.ParseJSONValue(BytesOf(S8), 0, cTreatAsUTF8);
            DelphiPrefixRegistryResponseJ0 := TJSONObject(JOV);

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
              S8 := UTF8String(pair.JsonValue.ToString);
              JOV := PayloadJO.ParseJSONValue(BytesOf(S8), 0, cTreatAsUTF8);
              PayloadJO := TJSONObject(JOV);

              pair := PayloadJO.Pairs[0];  // APIInfo
              S8 := UTF8String(pair.JsonValue.ToString);
              APIInfoJV := PayloadJO.ParseJSONValue(BytesOf(S8), 0, cTreatAsUTF8);

              pair := TJSONObject(APIInfoJV).Pairs[0];  // Version
              S1 := NoQuotes(pair.JsonValue.ToString);
              ApiInfo_Version := StrToFloatDef(S1, 0.0);

              Result := True;

            end;
          end;
        end;
      end
      else
      begin
        // invalid JSON from server
        hdr.DPRAPIErrorCode := 3;
        hdr.DPRAPIErrorMessage := 'JSON could not be parsed.';
      end;
    finally
      //FreeAndNil(DelphiPrefixRegistryResponseJ0);
      //FreeAndNil(PayloadJO);
      // do not free JOV
      // do not free APIInfoJO here
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
  FlagAlreadyCached: Boolean;
  URL_Versions: string;
  URL_ImageList: string;
  URL_TradukoList: string;
  JOV: TJSONValue;
  //DelphiPrefixRegistryResponse: Variant;
  APIInfoJO: TJSONObject;
  APIInfoJV: TJSONValue;
  S8: UTF8String;
  S1: string;
  ImageListJO, ImagesJO, ImageJO, JO, JO2: TJSONObject;
  TradukoListJO: TJSONObject;
  TradukiTopJO, TradukiItemJO: TJSONObject;
  pair: TJSONPair;
  n: Integer;
begin
  ErrorText := '';
  if FlagInitDone then
    Result := True
  else
  begin
    Result := False;
    JO := nil;
    JO2 := nil;
    APIInfoJO := nil;
    ImageListJO := nil;
    ImagesJO := nil;  // plural
    ImageJO := nil;   // singular
    TradukoListJO := nil;
    TradukiTopJO := nil;
    TradukiItemJO := nil;

    try
      URL_Versions := Format('http://%s/%s/%s?dpr:jsonapirequest:999999:' +
        'Version=1.0;RequestType=APIInfo;RequestTypeVersion=1.0;' +
        'DetailLevel=%s;%s',
        [cStartDomain, cStartPath, cStartRunner, 'Versions',
          FormatDateTime('hhnn', Now)  // 4 digits that vary sufficiently
        ]);
      JsonRequestParseHdr(URL_Versions, 'Versions', FlagAlreadyCached,
        DPR_API_Versions_Rec.hdr, ErrorText, DPR_API_Versions_Rec.ApiInfo_Version,
        APIInfoJV);

      if ErrorText = '' then
      begin

        if DPR_API_Versions_Rec.hdr.DPRAPIErrorCode = 0 then
        begin

         APIInfoJO := TJSONObject(APIInfoJV);
          pair := APIInfoJO.Pairs[2];  // WebAppAPISpec

          S8 := UTF8String(pair.JsonValue.ToString);
          JOV := JO2.ParseJSONValue(BytesOf(S8), 0, cTreatAsUTF8);
          JO2 := TJSONObject(JOV);

          pair := JO2.Pairs[0];        // WebAppAPISpec Version
          S1 := NoQuotes(pair.JsonValue.ToString);
          DPR_API_Versions_Rec.WebAppAPISpec_Version := StrToIntDef(S1, 0);

          pair := APIInfoJO.Pairs[3];  // ImageList

          S8 := pair.JsonValue.ToString;
          JOV := JO2.ParseJSONValue(BytesOf(S8), 0, cTreatAsUTF8);
          JO2.Parse(BytesOf(S8), 0);

          pair := JO2.Pairs[0];        // ImageList Version
          S1 := NoQuotes(pair.JsonValue.ToString);
          DPR_API_Versions_Rec.ImageList_Version := StrToIntDef(S1, 0);

          pair := APIInfoJO.Pairs[4];  // LingvoList

          S8 := pair.JsonValue.ToString;
          JOV := JO2.ParseJSONValue(BytesOf(S8), 0, cTreatAsUTF8);
          JO2.Parse(BytesOf(S8), 0);

          pair := JO2.Pairs[0];        // LingvoList Version
          S1 := NoQuotes(pair.JsonValue.ToString);
          DPR_API_Versions_Rec.LingvoList_Version := StrToIntDef(S1, 0);

          pair := APIInfoJO.Pairs[5];  // TradukoList

          S8 := pair.JsonValue.ToString;
          JOV := JO2.ParseJSONValue(BytesOf(S8), 0, cTreatAsUTF8);
          JO2.Parse(BytesOf(S8), 0);

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

        JsonRequestParseHdr(URL_ImageList, 'ImageList', FlagAlreadyCached,
          DPR_API_ImageList_Rec.hdr, ErrorText,
          DPR_API_ImageList_Rec.ApiInfo_Version, APIInfoJV);


        if DPR_API_ImageList_Rec.hdr.DPRAPIErrorCode = 0 then
        begin

          pair := APIInfoJO.Pairs[2];  // ImageList
          S8 := pair.JsonValue.ToString;
          ImageListJO := TJSONObject.Create;
          ImageListJO.Parse(BytesOf(S8), 0);

          pair := ImageListJO.Pairs[0];  // ImageList Version
          S8 := NoQuotes(pair.JsonValue.ToString);
          DPR_API_ImageList_Rec.ImageList_Version := StrToIntDef(S8, 0);

          pair := ImageListJO.Pairs[1];  // ImageList Count
          S8 := pair.JsonValue.ToString;  // do not strip quotes from true integer
          DPR_API_ImageList_Rec.Count := StrToIntDef(S8, 0);
          if (DPR_API_ImageList_Rec.Count = 2) then
          begin
            SetLength(DPR_API_ImageList_Rec.ImageList, DPR_API_ImageList_Rec.Count);
            DPR_API_ImageList_Rec.ImageList[0].ImageIdentifier := 'Welcome';

            pair := ImageListJO.Pairs[2];  // ImageList .... Images
            S8 := pair.JsonValue.ToString;
            ImagesJO := TJSONObject.Create;
            ImagesJO.Parse(BytesOf(S8), 0);

            pair := ImagesJO.Pairs[0];  // start Welcome Image
            S8 := pair.JsonValue.ToString;
            ImageJO := TJSONObject.Create;
            ImageJO.Parse(BytesOf(S8), 0);

            pair := ImageJO.Pairs[0];  // Image Version
            S8 := NoQuotes(pair.JsonValue.ToString);
            DPR_API_ImageList_Rec.ImageList[0].Version := StrToIntDef(S8, 0);

            pair := ImageJO.Pairs[1];  // Image URL
            S8 := NoQuotes(pair.JsonValue.ToString);
            DPR_API_ImageList_Rec.ImageList[0].URL := S8;

            pair := ImagesJO.Pairs[1];  // start Goodbye Image
            S8 := pair.JsonValue.ToString;
            //FreeAndNil(ImageJO);
            ImageJO := TJSONObject.Create;
            ImageJO.Parse(BytesOf(S8), 0);

            pair := ImageJO.Pairs[0];  // Image Version
            S8 := NoQuotes(pair.JsonValue.ToString);
            DPR_API_ImageList_Rec.ImageList[1].Version := StrToIntDef(S8, 0);

            pair := ImageJO.Pairs[1];  // Image URL
            S8 := NoQuotes(pair.JsonValue.ToString);
            DPR_API_ImageList_Rec.ImageList[1].URL := S8;

            Result := True;
          end;
        end;
      end;


      if Result then
      begin
        URL_TradukoList := Format('http://%s/%s/%s?dpr:jsonapirequest:999999:' +
          'Version=1.0;RequestType=APIInfo;RequestTypeVersion=1.0;' +
          'DetailLevel=%s;%s',
          [cStartDomain, cStartPath, cStartRunner, 'TradukoList',
            FormatDateTime('hhnn', Now)  // 4 digits that vary sufficiently
          ]);

        JsonRequestParseHdr(URL_TradukoList, 'TradukoList', FlagAlreadyCached,
          DPR_API_TradukoList_Rec.hdr, ErrorText,
          DPR_API_TradukoList_Rec.ApiInfo_Version, APIInfoJV);

        if DPR_API_TradukoList_Rec.hdr.DPRAPIErrorCode = 0 then
        begin

          pair := APIInfoJO.Pairs[3];  // TradukiList
          S8 := pair.JsonValue.ToString;
          TradukoListJO := TJSONObject.Create;
          TradukoListJO.Parse(BytesOf(S8), 0);

          pair := TradukoListJO.Pairs[0];  // TradukoList Version
          S8 := NoQuotes(pair.JsonValue.ToString);
          DPR_API_TradukoList_Rec.TradukoList_Version := StrToIntDef(S8, 0);

          pair := TradukoListJO.Pairs[1];  // TradukoList Count
          S8 := pair.JsonValue.ToString;  // do not strip quotes from true integer
          DPR_API_TradukoList_Rec.Count := StrToIntDef(S8, 0);

          pair := TradukoListJO.Pairs[2];  // TradukoList LingvoCount
          S8 := pair.JsonValue.ToString;  // true integer
          DPR_API_TradukoList_Rec.LingvoCount := StrToIntDef(S8, 0);

          if (DPR_API_TradukoList_Rec.Count = 2) then
          begin
            n := 0;
            SetLength(DPR_API_TradukoList_Rec.TradukiList,
              DPR_API_TradukoList_Rec.Count * DPR_API_TradukoList_Rec.LingvoCount);

            pair := TradukoListJO.Pairs[3];  // TradukoList .... Traduki
            S8 := pair.JsonValue.ToString;
            TradukiTopJO := TJSONObject.Create;
            TradukiTopJO.Parse(BytesOf(S8), 0);


            pair := TradukiTopJO.Pairs[0];  // btnGo
            DPR_API_TradukoList_Rec.TradukiList[n].Identifier :=
              NoQuotes(pair.JsonString.ToString);
            S8 := pair.JsonValue.ToString;
            JOV := TradukiItemJO.ParseJSONValue(BytesOf(S8), 0, cTreatAsUTF8);
            TradukiItemJO := TJSONObject(JOV);

            pair := TradukiItemJO.Pairs[0];
            S8 := NoQuotes(pair.JsonString.ToString);
            DPR_API_TradukoList_Rec.TradukiList[n].Lingvo3 := S8;
            S8 := NoQuotes(pair.JsonValue.ToString);
            DPR_API_TradukoList_Rec.TradukiList[n].Translation := S8;

            Inc(n);  // portuguese
            DPR_API_TradukoList_Rec.TradukiList[n].Identifier :=
              DPR_API_TradukoList_Rec.TradukiList[n - 1].Identifier;
            pair := TradukiItemJO.Pairs[1];
            S8 := NoQuotes(pair.JsonString.ToString);
            DPR_API_TradukoList_Rec.TradukiList[n].Lingvo3 := S8;
            S8 := NoQuotes(pair.JsonValue.ToString);
            DPR_API_TradukoList_Rec.TradukiList[n].Translation := S8;

            Inc(n);
            pair := TradukiTopJO.Pairs[1];  // btnExit
            DPR_API_TradukoList_Rec.TradukiList[n].Identifier :=
              NoQuotes(pair.JsonString.ToString);
            //FreeAndNil(TradukiItemJO);
            TradukiItemJO := TJSONObject.Create;
            TradukiItemJO.Parse(BytesOf(pair.JsonValue.ToString), 0);

            pair := TradukiItemJO.Pairs[0];  // english first lingvo #
            S8 := NoQuotes(pair.JsonString.ToString);
            DPR_API_TradukoList_Rec.TradukiList[n].Lingvo3 := S8;
            S8 := NoQuotes(pair.JsonValue.ToString);
            DPR_API_TradukoList_Rec.TradukiList[n].Translation := S8;

            Inc(n);  // portuguese
            DPR_API_TradukoList_Rec.TradukiList[n].Identifier :=
              DPR_API_TradukoList_Rec.TradukiList[n - 1].Identifier;
            pair := TradukiItemJO.Pairs[1];   // next lingvo #
            S8 := NoQuotes(pair.JsonString.ToString);
            DPR_API_TradukoList_Rec.TradukiList[n].Lingvo3 := S8;
            S8 := pair.JsonValue.ToString;
            if S8 <> '' then
              S8 := pair.JsonValue.Value;
            DPR_API_TradukoList_Rec.TradukiList[n].Translation := NoQuotes(string(S8));
            Result := True;
          end;
        end;
      end;


    finally
      //FreeAndNil(JOV);
      {FreeAndNil(ImageListJO);
      FreeAndNil(ImagesJO);
      FreeAndNil(ImageJO);
      FreeAndNil(APIInfoJO);
      FreeAndNil(JO);
      FreeAndNil(JO2);
      FreeAndNil(TradukoListJO);
      FreeAndNil(TradukiTopJO);
      FreeAndNil(TradukiItemJO);}
    end;


    if Result then
    begin
      if NOT FlagAlreadyCached then
      begin
        ForceDirectories(Client_Documents_Path);
        if High(DPR_API_ImageList_Rec.ImageList) >= 1 then
        begin
          WebResponse := HTTPSGet(DPR_API_ImageList_Rec.ImageList[0].URL,
            ErrorText, cUserAgent, '', False, True);
          DPR_API_ImageList_Rec.ImageList[0].LocalFilespec :=
            IncludeTrailingPathDelimiter(Client_Documents_Path) +
            'welcome.svg';
          StrSaveToFile(WebResponse,
            DPR_API_ImageList_Rec.ImageList[0].LocalFilespec,
            TEncoding.ASCII);

          WebResponse := HTTPSGet(DPR_API_ImageList_Rec.ImageList[1].URL,
            ErrorText, cUserAgent, '', False, True);
          DPR_API_ImageList_Rec.ImageList[1].LocalFilespec :=
            IncludeTrailingPathDelimiter(Client_Documents_Path) +
            'goodbye.svg';
          StrSaveToFile(WebResponse,
            DPR_API_ImageList_Rec.ImageList[1].LocalFilespec,
            TEncoding.ASCII);
        end;
      end;
    end;
  end;
end;

function Translate(const InKeyword, InLingvo3: string): string;
var
  i, n: Integer;
begin
  Result := '?' + InKeyword + '?';
  n := High(DPR_API_TradukoList_Rec.TradukiList);
  for i := 0 to n do
  begin
    if SameText(InKeyword, DPR_API_TradukoList_Rec.TradukiList[i].Identifier)
    then
    begin
      if InLingvo3 = DPR_API_TradukoList_Rec.TradukiList[i].Lingvo3 then
      begin
        Result := DPR_API_TradukoList_Rec.TradukiList[i].Translation;
        break;
      end;
    end;
  end;
end;


initialization
finalization
  SetLength(DPR_API_ImageList_Rec.ImageList, 0);
  SetLength(DPR_API_TradukoList_Rec.TradukiList, 0);

(* ok to use ucJSONWrapper.pas on FMX win32 but not Android in October 2014

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

end.


