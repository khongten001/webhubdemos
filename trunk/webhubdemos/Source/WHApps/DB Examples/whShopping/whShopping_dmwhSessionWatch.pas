unit whShopping_dmwhSessionWatch;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this WebHub sample file *)

interface

uses
  SysUtils, Classes,
  webLink, updateOK, tpAction, webTypes;

type
  TDMSessWatch = class(TDataModule)
    waCountActiveSessions: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure waCountActiveSessionsExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
    function NumberActiveSessions: Integer;
  end;

var
  DMSessWatch: TDMSessWatch;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ucString, ZM_CodeSiteInterface,
  webApp, htWebApp, webVars;

{ TDMSessWatch }

procedure TDMSessWatch.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMSessWatch.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  CSEnterMethod(Self, cFn);
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
  CSSend(cFn + ': Result', S(Result));
  CSExitMethod(Self, cFn);
end;

function TDMSessWatch.NumberActiveSessions: Integer;
const cFn = 'NumberActiveSessions';
var
  i: Integer;
  ASessionID: string;
  VarFilespec: string;
begin
  CSEnterMethod(Self, cFn);
  with pWebApp.CentralInfo.WebOpenSessions do
  begin
    Result := Count;
    for i := 0 to Pred(Count) do
    begin
      if Objects[i] <> nil then
      begin
        if Objects[i] is TwhSession then
        begin
          CSSend(S(i), S(TwhSession(Objects[i]).RawSessionNumber));
          ASessionID := RightOfS('x', TwhSession(Objects[i]).Name);
          VarFilespec := pWebApp.CentralInfo.SessionsDir + ASessionID + '.var';
          if NOT FileExists(VarFilespec) then
          begin
            CSSend('Session has been deleted', ASessionID);
            Dec(Result);
          end;
        end
        else
        begin
          {$IFDEF CodeSite}
          // extremely unlikely but conceivable ...
          LogProgrammerErrorToCodeSite(
            'Alert! All objects in WebOpenSessions SHOULD be TwhSession!');
          {$ENDIF}
        end;
      end;
    end;
  end;
  CSExitMethod(Self, cFn);
end;

procedure TDMSessWatch.waCountActiveSessionsExecute(Sender: TObject);
var
  n: Integer;
begin
  n := NumberActiveSessions;
  pWebApp.SendStringImm(IntToStr(n));
end;

procedure TDMSessWatch.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  CSEnterMethod(Self, cFn);
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  CSExitMethod(Self, cFn);
end;

end.
