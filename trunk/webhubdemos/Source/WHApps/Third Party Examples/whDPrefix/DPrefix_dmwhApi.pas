unit DPrefix_dmwhApi;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this WebHub sample file *)

interface

uses
  SysUtils, Classes,
  webLink, updateOK, tpAction, webTypes;

type
  TDMWHAPI = class(TDataModule)
    waJsonApiRequest: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure waJsonApiRequestExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMWHAPI: TDMWHAPI;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webApp, htWebApp, ucCodeSiteInterface;

{ TDM001 }

procedure TDMWHAPI.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMWHAPI.Init(out ErrorText: string): Boolean;
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
  CSSend('Result', S(Result));
  CSExitMethod(Self, cFn);
end;

procedure TDMWHAPI.waJsonApiRequestExecute(Sender: TObject);
var
  URL_Command: string;
  AJSONResponseStr: string;
begin
  AJSONResponseStr := '';
// http://delphiprefix.href.com/eng/
// dpr:jsonapirequest:999999:Version=1.0;RequestType=APIInfo;RequestTypeVersion=1.0;32533
  URL_Command := pWebApp.Command;
  if Pos('Version=1.0;', URL_Command) > 0 then
  begin
    if Pos('RequestType=APIInfo;', URL_Command) > 0 then
    begin
      if Pos('RequestTypeVersion=1.0', URL_Command) > 0 then
      begin
        if Pos('DetailLevel=Versions;', URL_Command) > 0 then
        begin
          AJSONResponseStr := pWebApp.Tekero['drJsonDetailLevel_Versions_1_0'];
        end;
      end;
    end;
  end;
  pWebApp.SendStringImm(AJSONResponseStr);
end;

procedure TDMWHAPI.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  CSEnterMethod(Self, cFn);
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  CSExitMethod(Self, cFn);
end;

end.
