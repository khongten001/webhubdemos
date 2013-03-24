unit dmwhGoogleAPIActions;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this WebHub sample file *)

interface

uses
  SysUtils, Classes,
  webLink, updateOK, tpAction, webTypes;

type
  TDMGAPI = class(TDataModule)
    waTestGeoLocation: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure waTestGeoLocationExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMGAPI: TDMGAPI;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webApp, htWebApp, ucCodeSiteInterface, ucHttps, ucGoogleAPICredentials,
  whdemo_ViewSource;

{ TDMGAPI}

procedure TDMGAPI.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMGAPI.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      // Call RefreshWebActions here only if it is not called within a TtpProject event
      // RefreshWebActions(Self);

      // helpful to know that WebAppUpdate will be called whenever the
      // WebHub app is refreshed.
      AddAppUpdateHandler(WebAppUpdate);
      FlagInitDone := True;
    end;
  end;
  Result := FlagInitDone;
  {$IFDEF CodeSite}CodeSite.Send('Result', Result);
  CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMGAPI.waTestGeoLocationExecute(Sender: TObject);
var
  ClientID, ClientSecret, SimpleAPIKey: string;
  ResponseJSON: string;
begin
  if ZMLookup_GoogleAPI_Credentials('WebHub Demo', ClientID, ClientSecret,
    SimpleAPIKey) then
  begin
    ResponseJSON :=
      HTTPSPost('https://www.googleapis.com/geolocation/v1/geolocate?key=' +
        SimpleAPIKey,
        getHtDemoCodeRoot + 'DB Examples\whShopping\google_geoloc_sample.json',
        'HREF Tools WebHub Demo Agent',
        'application/json', '', True);
    pWebApp.SendStringImm('<pre>' + ResponseJSON + '</pre>');
  end;
end;

procedure TDMGAPI.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

end.
