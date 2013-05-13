unit dmwhSoapActions;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this WebHub sample file *)

interface

uses
  SysUtils, Classes,
  webLink, updateOK, tpAction, webTypes;

type
  TDMSOAPClient = class(TDataModule)
    waIp2Country: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure waIp2CountryExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMSOAPClient: TDMSOAPClient;

function ConvertIPv4ToCountry(const InIPv4, InReferer: string;
  out CountryCode, CountryName, ErrorText: string): Boolean;

implementation

{$R *.dfm}

uses
{$IFDEF CodeSite}CodeSiteLogging, {$ENDIF}
  NativeXml, ZaphodsMap,
  ucHttps, ucCodeSiteInterface,
  webApp, htWebApp;

{ TDMSOAPClient }

procedure TDMSOAPClient.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMSOAPClient.Init(out ErrorText: string): Boolean;
const
  cFn = 'Init';
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      RefreshWebActions(Self);

      // helpful to know that WebAppUpdate will be called whenever the
      // WebHub app is refreshed.
      AddAppUpdateHandler(WebAppUpdate);  // placeholder - not used yet
      FlagInitDone := True;
    end;
  end;
  Result := FlagInitDone;
{$IFDEF CodeSite}CodeSite.Send('Result', Result);
  CodeSite.ExitMethod(Self, cFn); {$ENDIF}
end;

function ConvertIPv4ToCountry(const InIPv4, InReferer: string;
  out CountryCode, CountryName, ErrorText: string): Boolean;
const
  cFn = 'IP2Country';
var
  ADoc: TNativeXml;
  ANode: TXmlNode;
  S1: string;
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(cFn); {$ENDIF}
  Result := True;
  ErrorText := '';

  { This does not require SOAP. it is simpler. Response can be JSON or XML.
    We are using XML here. }
  ADoc := nil;
  try
    try
      S1 := HttpsGet('http://ip2country.sourceforge.net/ip2c.php?' +
        'format=XML&' + 'ip=' + InIPv4, ErrorText, cDefaultUserAgentName,
        InReferer, // not required; seems friendly to include
        False, // no use for headers
        True); // this one runs on http only
      if ErrorText <> '' then
      begin
        Result := False;
        LogSendError(ErrorText);
      end
      else
      begin
        CSSend('S1', S1);
        S1 := StringReplace(S1, '<?xml version="1.0"?>',
          '<?xml version="1.0" encoding="UTF-8"?>', []);
        CSSend('S1 with encoding', S1);

        ADoc := TNativeXml.Create;

        ADoc.ReadFromString(S1);

        ANode := ADoc.Root.FindNode('country_code');
        if ANode <> nil then
          CountryCode := ANode.ValueAsString
        else
          CountryCode := '';
        ANode := ADoc.Root.FindNode('country_name');
        if ANode <> nil then
          CountryName := ANode.ValueAsString
        else
          CountryName := '';
      end;
    except
      on E: Exception do
      begin
        pWebApp.SendStringImm('Exception: ' + E.Message);
      end;
    end;
  finally
    FreeAndNil(ADoc);
  end;

{$IFDEF CodeSite}CodeSite.ExitMethod(cFn); {$ENDIF}
end;

procedure TDMSOAPClient.waIp2CountryExecute(Sender: TObject);
const
  cFn = 'waIp2CountryExecute';
var
  CountryCode: string;
  CountryName: string;
  ErrorText: string;
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  { This does not require SOAP. it is simpler. Response can be JSON or XML.
    We are using XML here. }

  if ConvertIPv4ToCountry(pWebApp.Request.RemoteAddress,
    pWebApp.DynURL.ToSessionID, CountryCode, CountryName, ErrorText) then
  begin
    pWebApp.SendStringImm('<b>Country Code:</b> ' + CountryCode +
       ' <b>Name:</b> ' + CountryName);
  end
  else
  begin
    pWebApp.SendStringImm('ERROR: ' + ErrorText);
  end;

{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); {$ENDIF}
end;

procedure TDMSOAPClient.WebAppUpdate(Sender: TObject);
const
  cFn = 'WebAppUpdate';
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); {$ENDIF}
end;

end.
