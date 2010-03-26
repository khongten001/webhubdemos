unit DSP_dmWhDreamSecurity;

interface

uses
  SysUtils, Classes;

type
  TDataModuleDreamSecurity = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init;
    procedure DesignPageCalled(var AllowAccess: Boolean; out ErrorText: String);
    procedure NewSessionInURL(const Session: Cardinal;
      var ForceNewSession: Boolean);
    procedure FrontDoorTriggered(Sender: TObject);
  end;

var
  DataModuleDreamSecurity: TDataModuleDreamSecurity;

implementation

{$R *.dfm}

uses
  webCall, whdw_RemotePages, webApp,
  ucString, ucPos, dmWHApp, whsample_EvtHandlers;

procedure TDataModuleDreamSecurity.Init;
begin
  pConnection.OnFrontDoorTriggered := FrontDoorTriggered;
  DataModuleDreamWeaver.OnDesignPage   := DesignPageCalled;
  whdmCommonEventHandlers.OnNewSessionInURL := NewSessionInURL;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure TDataModuleDreamSecurity.DesignPageCalled(var AllowAccess: Boolean;
  out ErrorText: String);
var
  RemoteUserIP: Longint;
begin
  ErrorText := '';

  {Note AllowAccess is always true when this procedure is called.}

  RemoteUserIP := IP2LongInt(pWebApp.Request.RemoteAddress);
  if RemoteUserIP = IP2LongInt('127.0.0.1') then  // local user
    Exit;

  if ((RemoteUserIP >= IP2LongInt('192.168.1.1')) and
      (RemoteUserIP <= IP2LongInt('192.168.1.254'))) then   // "home" LAN
    Exit;

  if ((RemoteUserIP >= IP2LongInt('208.201.252.2')) and
      (RemoteUserIP <= IP2LongInt('208.201.252.62'))) then  // HREF data center
    Exit;

  if RemoteUserIP = IP2LongInt('218.214.11.229') then    // Ann Sydney
    Exit;

  ErrorText := 'Invalid IP#';
  AllowAccess := False;  // no one else is allowed to edit on dsp.href.com
end;

//------------------------------------------------------------------------------

procedure TDataModuleDreamSecurity.NewSessionInURL(const Session: Cardinal;
  var ForceNewSession: Boolean);
begin
  {Note ForceNewSession defaults to True}
  if (Session >= 1870) and (Session <= 1875) then
    ForceNewSession := False; 
end;

//------------------------------------------------------------------------------

procedure TDataModuleDreamSecurity.FrontDoorTriggered(Sender: TObject);
var
  aDesiredPage: String;
begin
  // determine which page the surfer requested
  aDesiredPage:=pWebApp.Session.PriorPageID;

  if ( posci(',' + aDesiredPage + ',',
    ',remotedesign,remotepreview,remoterefresh,') > 0) then
  begin
    // allow those pages to go through by resetting pWebApp.PageID
    pWebApp.PageID:=aDesiredPage;
  end
  else
  begin
    ;// else the surfer will be bounced to the Frontdoor.
  end;
end;

//------------------------------------------------------------------------------

end.
