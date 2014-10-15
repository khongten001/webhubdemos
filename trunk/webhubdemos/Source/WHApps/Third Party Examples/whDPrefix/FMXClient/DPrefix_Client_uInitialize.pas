unit DPrefix_Client_uInitialize;

interface

{$I hrefdefines.inc}

{$IFDEF NEXTGEN}
uses
  // This patch makes UTF8String etc available for use in FireMonkey apps.
  // http://andy.jgknet.de/blog/2014/09/system-bytestrings-support-for-xe7/
  System.ByteStrings;
{$ENDIF}

{$IFDEF INHOUSE}
const
  cStartDomain = 'delphiprefix.modulab.com';   // local testing 192.168.x.x
      // use delphiprefix.href.com for public server
  cStartPath = 'win64';
      // use scripts for public server
  cStartRunner = 'runisa_x_d21_win64.dll';
      // use runisa.dll for public server
{$ELSE}
const
  cStartDomain = 'delphiprefix.href.com';  // for public server
  cStartPath = 'scripts';
  cStartRunner = 'runisa.dll';
{$ENDIF}

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

  TDPRAPIInterceptRec = record
    Identifier: string;
    InterceptURLSnip: string;
  end;
  TDPRAPIGenerateRec = record
    Identifier: string;
    GenerateURLSnip: string;
  end;
  TDPRAPIWebAppAPISpecRec = record
    hdr: TDPRAPIResponseHdrRec;
    ApiInfo_Version: Double;
    WebAppAPISpec_Version: Integer;
    URL_ToAppID: string;
    InterceptList: array of TDPRAPIInterceptRec;
    GenerateList: array of TDPRAPIGenerateRec;
  end;


var
  DPR_API_Versions_Rec: TDPRAPIResponseVersionsRec;
  DPR_API_ImageList_Rec: TDPRAPIResponseImageListRec;
  DPR_API_TradukoList_Rec: TDPRAPITradukoListRec;
  DPR_API_WebAppAPISpec_Rec: TDPRAPIWebAppAPISpecRec;

function Client_Init(out ErrorText: string): Boolean;

function Translate(const InKeyword, InLingvo3: string): string;
function GenerateURL(const InIdentifier: string): string;

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

function JSONPairtoInteger(AJP: TJSONPair;
  const FlagQuotes: Boolean = False): Integer;
begin
  if (AJP <> nil) then
  begin
    if FlagQuotes then
      Result := StrToIntDef(NoQuotes(AJP.JsonValue.ToString), 0)
    else
      Result := StrToIntDef(AJP.JsonValue.ToString, 0);
  end
  else
    Result := 0;
end;

function JSONtoString(AJO: TJSONObject; AFieldName: string): string;
var
  AJP: TJSONPair;
begin
  AJP := AJO.Get(AFieldName);
  if (AJP <> nil) then
    Result := NoQuotes(AJP.JsonValue.ToString)
  else
    Result := 'not found';
end;

function JSONPairtoString(AJP: TJSONPair): string;
begin
  if (AJP <> nil) then
    Result := NoQuotes(AJP.JsonValue.ToString)
  else
    Result := 'not found';
end;


function JsonRequestParseHdr(var MPV: TJSONValue; var MJO: TJSONObject;
  const InURL: string; const Keyword: string;
  var AlreadyCached: Boolean;
  var hdr: TDPRAPIResponseHdrRec; out ErrorText: string;
  out ApiInfo_Version: Double; var APIInfoJO: TJSONObject): Boolean;
var
  WebResponse: string;
  WebResponse8: UTF8String;
  DelphiPrefixRegistryResponseJ0: TJSONObject;
  PayloadJO: TJSONObject;
  S1: string;
  VersionsJsonFilespec: string;
  PreviousVersionsJsonStr8: UTF8String;
  MainName: string;
  P: Pointer;
  Idx: Integer;
begin
  Result := False;

  APIInfoJO := nil;

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
      if string(PreviousVersionsJsonStr8) = WebResponse then
        AlreadyCached := True;

      if NOT AlreadyCached then
        StrSaveToFile(WebResponse, VersionsJsonFilespec, TEncoding.UTF8);
    end;

    try
      MJO := TJSONObject.Create;

      Idx := Low(WebResponse8);
      P := Addr(WebResponse8[Idx]);
      MPV := MJO.ParseJSONValue(P, 0, cTreatAsUTF8);

      if ( MPV <> nil ) then
      begin
        MainName := NoQuotes(TJSONObject(MPV).Pairs[0].JSONString.ToString);

        begin
          if MainName = 'DelphiPrefixRegistryResponse' then
          begin
            DelphiPrefixRegistryResponseJ0 :=
              TJSONObject(TJSONObject(MPV).Pairs[0].JsonValue);
            S1 := JSONtoString(DelphiPrefixRegistryResponseJ0, 'Version');
            hdr.Version := StrToFloatDef(S1, 0.0);

            S1 := JSONPairtoString(DelphiPrefixRegistryResponseJ0.Pairs[1]);
            hdr.WebAPIStatus := S1;

            S1 := JSONPairtoString(DelphiPrefixRegistryResponseJ0.Pairs[4]);
            hdr.DPRAPIErrorCode := StrToIntDef(S1, 5);

            S1 := JSONPairtoString(DelphiPrefixRegistryResponseJ0.Pairs[5]); // 'DPRAPIErrorMessage');
            hdr.DPRAPIErrorMessage := S1;

            if hdr.DPRAPIErrorCode = 0 then
            begin
              PayloadJO := TJSONObject(DelphiPrefixRegistryResponseJ0.Pairs[6].JsonValue);
              APIInfoJO := TJSONObject(PayloadJO.Pairs[0].JsonValue);

              S1 := JSONPairtoString(APIInfoJO.Pairs[0]);
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
      // not not FreeAndNil(PV);
      // do not free APIInfoJO here
    end;
  end;
end;


function Client_Init(out ErrorText: string): Boolean;
var
  SVGResponse: string;
var
  MPV: TJSONValue;
  MJO: TJSONObject;
  FlagAlreadyCached: Boolean;
  URL_Versions: string;
  URL_ImageList: string;
  URL_TradukoList: string;
  URL_WebAppAPISpec: string;
  APIInfoJO: TJSONObject;
  S1: string;
  ImageListJO, ImagesJO, ImageJO, JO2: TJSONObject;
  TradukoListJO: TJSONObject;
  TradukiTopJO, TradukiItemJO: TJSONObject;
  WebAppAPIJO, URLQueryStringsJO, InterceptJO, GenerateJO: TJSONObject;
  n: Integer;
  iTrad, iAPI: Integer;
begin
  ErrorText := '';
  if FlagInitDone then
    Result := True
  else
  begin
    Result := False;
    MJO := nil;
    APIInfoJO := nil;

    try
      URL_Versions := Format('http://%s/%s/%s?dpr:jsonapirequest:999999:' +
        'Version=1.0;RequestType=APIInfo;RequestTypeVersion=1.0;' +
        'DetailLevel=%s;%s',
        [cStartDomain, cStartPath, cStartRunner, 'Versions',
          FormatDateTime('hhnn', Now)  // 4 digits that vary sufficiently
        ]);
      JsonRequestParseHdr(MPV, MJO, URL_Versions, 'Versions', FlagAlreadyCached,
        DPR_API_Versions_Rec.hdr, ErrorText, DPR_API_Versions_Rec.ApiInfo_Version,
        APIInfoJO);

      if ErrorText = '' then
      begin

        if DPR_API_Versions_Rec.hdr.DPRAPIErrorCode = 0 then
        begin
          JO2 := TJSONObject(APIInfoJO.Pairs[2].JsonValue); // WebAppAPISpec
          S1 := JSONPairtoString(JO2.Pairs[0]); // WebAppAPISpec Version
          DPR_API_Versions_Rec.WebAppAPISpec_Version := StrToIntDef(S1, 0);

          JO2 := TJSONObject(APIInfoJO.Pairs[3].JsonValue); // ImageList
          S1 := JSONPairtoString(JO2.Pairs[0]); // Version
          DPR_API_Versions_Rec.ImageList_Version := StrToIntDef(S1, 0);

          JO2 := TJSONObject(APIInfoJO.Pairs[4].JsonValue); // LingvoList
          S1 := JSONPairtoString(JO2.Pairs[0]); // Version
          DPR_API_Versions_Rec.LingvoList_Version := StrToIntDef(S1, 0);

          JO2 := TJSONObject(APIInfoJO.Pairs[5].JsonValue); // LingvoList
          S1 := JSONPairtoString(JO2.Pairs[0]); // Version
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

        FreeAndNil(MJO);
        JsonRequestParseHdr(MPV, MJO, URL_ImageList, 'ImageList', FlagAlreadyCached,
          DPR_API_ImageList_Rec.hdr, ErrorText,
          DPR_API_ImageList_Rec.ApiInfo_Version, APIInfoJO);


        if DPR_API_ImageList_Rec.hdr.DPRAPIErrorCode = 0 then
        begin
          ImageListJO := TJSONObject(APIInfoJO.Pairs[2].JsonValue);

          S1 := JSONPairtoString(ImageListJO.Pairs[0]);
          DPR_API_ImageList_Rec.ImageList_Version := StrToIntDef(S1, 0);
          DPR_API_ImageList_Rec.Count := JSONPairtoInteger(ImageListJO.Pairs[1]);

          if (DPR_API_ImageList_Rec.Count = 2) then
          begin
            SetLength(DPR_API_ImageList_Rec.ImageList, 2);
            DPR_API_ImageList_Rec.ImageList[0].ImageIdentifier := 'Welcome';
            DPR_API_ImageList_Rec.ImageList[1].ImageIdentifier := 'Goodbye';

            ImageListJO := TJSONObject(APIInfoJO.Pairs[2].JsonValue); // ImageList .... Images
            ImagesJO  := TJSONObject(ImageListJO.Pairs[2].JsonValue);
            ImageJO  := TJSONObject(ImagesJO.Pairs[0].JsonValue);  // welcome image

            if (ImageJO.Count = 2) then
            begin
              DPR_API_ImageList_Rec.ImageList[0].Version := JSONPairtoInteger(ImageJO.Pairs[0], True);
              DPR_API_ImageList_Rec.ImageList[0].URL := JSONPairtoString(ImageJO.Pairs[1]);
            end;

            ImageJO := TJSONObject(ImagesJO.Pairs[1].JsonValue);  // goodbye image
            DPR_API_ImageList_Rec.ImageList[1].Version := JSONPairtoInteger(ImageJO.Pairs[0], True);
            DPR_API_ImageList_Rec.ImageList[1].URL := JSONPairtoString(ImageJO.Pairs[1]);

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

        FreeAndNil(MJO);
        JsonRequestParseHdr(MPV, MJO, URL_TradukoList, 'TradukoList', FlagAlreadyCached,
          DPR_API_TradukoList_Rec.hdr, ErrorText,
          DPR_API_TradukoList_Rec.ApiInfo_Version, APIInfoJO);

        if DPR_API_TradukoList_Rec.hdr.DPRAPIErrorCode = 0 then
        begin
          if (APIInfoJO.Count = 4) then
          begin

            TradukoListJO := TJSONObject(APIInfoJO.Pairs[3].JsonValue);
            DPR_API_TradukoList_Rec.TradukoList_Version :=
              JSONPairtoInteger(TradukoListJO.Pairs[0], True);

            DPR_API_TradukoList_Rec.Count :=  // do not strip quotes from true integer
              JSONPairtoInteger(TradukoListJO.Pairs[1]);

            DPR_API_TradukoList_Rec.LingvoCount :=
              JSONPairtoInteger(TradukoListJO.Pairs[2]);

            if (DPR_API_TradukoList_Rec.Count = 3) then  // version 0002
            begin
              n := -1;
              SetLength(DPR_API_TradukoList_Rec.TradukiList,
                DPR_API_TradukoList_Rec.Count * DPR_API_TradukoList_Rec.LingvoCount);

              // TradukoList .... Traduki
              TradukiTopJO := TJSONObject(TradukoListJO.Pairs[3].JsonValue);

              for iTrad := 0 to Pred(DPR_API_TradukoList_Rec.Count) do
              begin
                Inc(n);
                DPR_API_TradukoList_Rec.TradukiList[n].Identifier :=
                  NoQuotes(TradukiTopJO.Pairs[iTrad].JsonString.ToString); // btnGo
                TradukiItemJO := TJSONObject(TradukiTopJO.Pairs[iTrad].JsonValue);

                S1 := TradukiItemJO.Pairs[0].JSONString.ToString;
                DPR_API_TradukoList_Rec.TradukiList[n].Lingvo3 := NoQuotes(S1);
                S1 := TradukiItemJO.Pairs[0].JSONValue.ToString;
                DPR_API_TradukoList_Rec.TradukiList[n].Translation := NoQuotes(S1);

                Inc(n);  // next language, maybe portuguese
                DPR_API_TradukoList_Rec.TradukiList[n].Identifier :=
                  DPR_API_TradukoList_Rec.TradukiList[n - 1].Identifier;

                DPR_API_TradukoList_Rec.TradukiList[n].Lingvo3 :=
                  NoQuotes(TradukiItemJO.Pairs[1].JSONString.ToString);
                DPR_API_TradukoList_Rec.TradukiList[n].Translation :=
                  NoQuotes(TradukiItemJO.Pairs[1].JSONValue.ToString);
              end;  // back to english

              Result := True;
            end;
          end
          else
          begin
            ErrorText := 'invalid traduko count';
            Result := False;
          end;
        end;
      end;


      if Result then
      begin
        URL_WebAppAPISpec :=
          Format('http://%s/%s/%s?dpr:jsonapirequest:999999:' +
          'Version=1.0;RequestType=APIInfo;RequestTypeVersion=1.0;' +
          'DetailLevel=%s;%s',
          [cStartDomain, cStartPath, cStartRunner, 'WebAppAPISpec',
            FormatDateTime('hhnn', Now)  // 4 digits that vary sufficiently
          ]);

        FreeAndNil(MJO);
        JsonRequestParseHdr(MPV, MJO, URL_WebAppAPISpec, 'WebAppAPISpec',
          FlagAlreadyCached,
          DPR_API_WebAppAPISpec_Rec.hdr, ErrorText,
          DPR_API_WebAppAPISpec_Rec.ApiInfo_Version, APIInfoJO);

        if DPR_API_WebAppAPISpec_Rec.hdr.DPRAPIErrorCode = 0 then
        begin
          if (APIInfoJO.Count = 3) then
          begin

            WebAppAPIJO := TJSONObject(APIInfoJO.Pairs[2].JsonValue);
            DPR_API_WebAppAPISpec_Rec.WebAppAPISpec_Version :=
              JSONPairtoInteger(WebAppAPIJO.Pairs[0], True);

            DPR_API_WebAppAPISpec_Rec.URL_ToAppID :=
              JSONPairtoString(WebAppAPIJO.Pairs[1]);

            URLQueryStringsJO := TJSONObject(WebAppAPIJO.Pairs[2].JsonValue);
            if (URLQueryStringsJO.Count = 2) then
            begin
              InterceptJO := TJSONObject(URLQueryStringsJO.Pairs[0].JsonValue);
              GenerateJO := TJSONObject(URLQueryStringsJO.Pairs[1].JsonValue);

              SetLength(DPR_API_WebAppAPISpec_Rec.InterceptList,
                InterceptJO.Count);
              SetLength(DPR_API_WebAppAPISpec_Rec.GenerateList,
                GenerateJO.Count);

              for iAPI := 0 to Pred(InterceptJO.Count) do
              begin
                DPR_API_WebAppAPISpec_Rec.InterceptList[iAPI].Identifier :=
                  NoQuotes(InterceptJO.Pairs[iAPI].JSONString.ToString);
                DPR_API_WebAppAPISpec_Rec.InterceptList[iAPI].InterceptURLSnip
                  := NoQuotes(InterceptJO.Pairs[iAPI].JsonValue.ToString);
              end;

              for iAPI := 0 to Pred(GenerateJO.Count) do
              begin
                DPR_API_WebAppAPISpec_Rec.GenerateList[iAPI].Identifier :=
                  NoQuotes(GenerateJO.Pairs[iAPI].JSONString.ToString);
                DPR_API_WebAppAPISpec_Rec.GEnerateList[iAPI].GenerateURLSnip
                  := NoQuotes(GenerateJO.Pairs[iAPI].JsonValue.ToString);
              end;

              Result := True;
            end
            else
            begin
              ErrorText := 'Invalid count of URLQueryStrings';
              Result := False;
            end;
          end
          else
          begin
            ErrorText := 'invalid WebAppAPISpec count';
            Result := False;
          end;
        end
        else
          Result := False;
      end;


    finally
      FreeAndNil(MJO);
    end;


    if Result then
    begin
      if NOT FlagAlreadyCached then
      begin
        ForceDirectories(Client_Documents_Path);
        if High(DPR_API_ImageList_Rec.ImageList) >= 1 then
        begin
          SVGResponse := HTTPSGet(DPR_API_ImageList_Rec.ImageList[0].URL,
            ErrorText, cUserAgent, '', False, True);
          DPR_API_ImageList_Rec.ImageList[0].LocalFilespec :=
            IncludeTrailingPathDelimiter(Client_Documents_Path) +
            'welcome.svg';
          StrSaveToFile(SVGResponse,
            DPR_API_ImageList_Rec.ImageList[0].LocalFilespec,
            TEncoding.ASCII);

          SVGResponse := HTTPSGet(DPR_API_ImageList_Rec.ImageList[1].URL,
            ErrorText, cUserAgent, '', False, True);
          DPR_API_ImageList_Rec.ImageList[1].LocalFilespec :=
            IncludeTrailingPathDelimiter(Client_Documents_Path) +
            'goodbye.svg';
          StrSaveToFile(SVGResponse,
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

function GenerateURL(const InIdentifier: string): string;
var
  i, n: Integer;
begin
  Result := '?' + InIdentifier + '?';
  n := High(DPR_API_WebAppAPISpec_Rec.GenerateList);
  for i := 0 to n do
  begin
    if SameText(InIdentifier,
      DPR_API_WebAppAPISpec_Rec.GenerateList[i].Identifier) then
    begin
      Result := DPR_API_WebAppAPISpec_Rec.URL_ToAppID +
        DPR_API_WebAppAPISpec_Rec.GenerateList[i].GenerateURLSnip;
      break;
    end;
  end;
end;

initialization
finalization
  SetLength(DPR_API_ImageList_Rec.ImageList, 0);
  SetLength(DPR_API_TradukoList_Rec.TradukiList, 0);
  SetLength(DPR_API_WebAppAPISpec_Rec.InterceptList, 0);
  SetLength(DPR_API_WebAppAPISpec_Rec.GenerateList, 0);

end.


