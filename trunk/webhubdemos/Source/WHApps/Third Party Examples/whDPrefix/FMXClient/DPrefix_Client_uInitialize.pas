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
  end
  else
    Result := 0;
end;

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


function JsonRequestParseHdr(var MJO: TJSONObject;
  const InURL: string; const Keyword: string;
  var AlreadyCached: Boolean;
  var hdr: TDPRAPIResponseHdrRec; out ErrorText: string;
  out ApiInfo_Version: Double; var APIInfoJO: TJSONObject): Boolean;
var
  WebResponse: string;
  DelphiPrefixRegistryResponseJ0: TJSONObject;
  PayloadJO: TJSONObject;
  S1: string;
  VersionsJsonFilespec: string;
  {PreviousVersionsJsonStr8: UTF8String;}
  MainName: string;
  ParseCount: Integer;
begin
  Result := False;

  APIInfoJO := nil;

  WebResponse := HTTPSGet(InURL, ErrorText, cUserAgent, '', False, True);

  if ErrorText = '' then
  begin

    if Keyword = 'Versions' then
    begin
      AlreadyCached := False;
      VersionsJsonFilespec := Client_Documents_Path + PathDelim + Keyword +
        '.json';
      {if FileExists(VersionsJsonFilespec) then
        PreviousVersionsJsonStr8 := UTF8String(StrLoadFromFile(VersionsJsonFilespec))
      else
        PreviousVersionsJsonStr8 := '';
      if string(PreviousVersionsJsonStr8) = WebResponse then
        AlreadyCached := True;

      if NOT AlreadyCached then
        StrSaveToFile(WebResponse, VersionsJsonFilespec, TEncoding.UTF8);}
    end;

    try
      MJO := TJSONObject.Create;
      ParseCount := MJO.Parse(BytesOf(WebResponse), 0);
      if ( NOT MJO.Null ) and (ParseCount > 0) then
      begin
        MainName := NoQuotes(MJO.Pairs[0].JSONString.ToString);

        begin
          if MainName = 'DelphiPrefixRegistryResponse' then
          begin
            DelphiPrefixRegistryResponseJ0 := TJSONObject(MJO.Pairs[0].JsonValue);
            S1 := JSONtoString(DelphiPrefixRegistryResponseJ0, 'Version');
            hdr.Version := StrToFloatDef(S1, 0.0);

            S1 := JSONPairtoString(DelphiPrefixRegistryResponseJ0.Pairs[1]); // JOV), 'WebAPIStatus');
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
      //FreeAndNil(MJO);
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
  MJO: TJSONObject;
  FlagAlreadyCached: Boolean;
  URL_Versions: string;
  URL_ImageList: string;
  URL_TradukoList: string;
  APIInfoJO: TJSONObject;
  S1: string;
  ImageListJO, ImagesJO, ImageJO, JO2: TJSONObject;
  TradukoListJO: TJSONObject;
  TradukiTopJO, TradukiItemJO: TJSONObject;
  n: Integer;
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
      JsonRequestParseHdr(MJO, URL_Versions, 'Versions', FlagAlreadyCached,
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
        JsonRequestParseHdr(MJO, URL_ImageList, 'ImageList', FlagAlreadyCached,
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
        JsonRequestParseHdr(MJO, URL_TradukoList, 'TradukoList', FlagAlreadyCached,
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

            if (DPR_API_TradukoList_Rec.Count = 2) then
            begin
              n := 0;
              SetLength(DPR_API_TradukoList_Rec.TradukiList,
                DPR_API_TradukoList_Rec.Count * DPR_API_TradukoList_Rec.LingvoCount);

              // TradukoList .... Traduki
              TradukiTopJO := TJSONObject(TradukoListJO.Pairs[3].JsonValue);

              DPR_API_TradukoList_Rec.TradukiList[n].Identifier :=
                NoQuotes(TradukiTopJO.Pairs[0].JsonString.ToString); // btnGo
              TradukiItemJO := TJSONObject(TradukiTopJO.Pairs[0].JsonValue);

              S1 := TradukiItemJO.Pairs[0].JSONString.ToString;
              DPR_API_TradukoList_Rec.TradukiList[n].Lingvo3 := NoQuotes(S1);
              S1 := TradukiItemJO.Pairs[0].JSONValue.ToString;
              DPR_API_TradukoList_Rec.TradukiList[n].Translation := NoQuotes(S1);

              Inc(n);  // portuguese
              DPR_API_TradukoList_Rec.TradukiList[n].Identifier :=
                DPR_API_TradukoList_Rec.TradukiList[n - 1].Identifier;

              DPR_API_TradukoList_Rec.TradukiList[n].Lingvo3 :=
                NoQuotes(TradukiItemJO.Pairs[1].JSONString.ToString);
              DPR_API_TradukoList_Rec.TradukiList[n].Translation :=
                NoQuotes(TradukiItemJO.Pairs[1].JSONValue.ToString);


              Inc(n);  // back to english
              DPR_API_TradukoList_Rec.TradukiList[n].Identifier :=
                NoQuotes(TradukiTopJO.Pairs[1].JsonString.ToString); // btnExit
              TradukiItemJO := TJSONObject(TradukiTopJO.Pairs[1].JsonValue);

              S1 := TradukiItemJO.Pairs[0].JSONString.ToString;
              DPR_API_TradukoList_Rec.TradukiList[n].Lingvo3 := NoQuotes(S1);
              S1 := TradukiItemJO.Pairs[0].JSONValue.ToString;
              DPR_API_TradukoList_Rec.TradukiList[n].Translation := NoQuotes(S1);

              Inc(n);  // portuguese
              DPR_API_TradukoList_Rec.TradukiList[n].Identifier :=
                DPR_API_TradukoList_Rec.TradukiList[n - 1].Identifier;

              DPR_API_TradukoList_Rec.TradukiList[n].Lingvo3 :=
                NoQuotes(TradukiItemJO.Pairs[1].JSONString.ToString); // btnExit
              DPR_API_TradukoList_Rec.TradukiList[n].Translation :=
                NoQuotes(TradukiItemJO.Pairs[1].JSONValue.ToString);

              Result := True;
            end;
          end
          else
          begin
            ErrorText := 'invalid count';
            Result := False;
          end;
        end;
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


