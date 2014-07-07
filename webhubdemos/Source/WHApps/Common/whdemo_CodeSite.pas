unit whdemo_CodeSite;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this WebHub sample file *)

interface

uses
  SysUtils, Classes,
  webLink, updateOK, tpAction, webTypes;

type
  TdmwhUIHelpers = class(TDataModule)
    waCodeSite: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure waCodeSiteExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  dmwhUIHelpers: TdmwhUIHelpers;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ucCodeSiteInterface, ucString,
  webApp, htWebApp;

{ TDM001 }

procedure TdmwhUIHelpers.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TdmwhUIHelpers.Init(out ErrorText: string): Boolean;
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
  CSSend('Result', Result);
  CSExitMethod(Self, cFn);
end;

procedure TdmwhUIHelpers.waCodeSiteExecute(Sender: TObject);
{$IFDEF CodeSite}
const
  cBoolAsStr: array[Boolean] of string = ('False','True');
var
  ASendType, Params, Param1, Param2: string;
  wa: TwhAppBase;
{$ENDIF}
begin
  {$IFDEF CodeSite}
  wa :=(TwhWebAction(Sender).WebApp);
  SplitString(TwhWebAction(Sender).HtmlParam, '|', ASendType, Params);
  if (ASendType = 'Info') then
  begin
    SplitString(Params, ',', Param1, Param2);
    Param1 := wa.MoreIfParentild(Param1);
    Param2 := wa.MoreIfParentild(Param2);
    CodeSite.Send(Param1, Param2);
  end
  else
  if (ASendType = 'BoolVar') then
  begin
    SplitString(Params, ',', Param1, Param2);
    Param1 := wa.MoreIfParentild(Param1);
    Param2 := wa.MoreIfParentild(Param2);
    CodeSite.Send(Param1, Format('%s="%s"', [Param2,
      cBoolAsStr[pWebApp.BoolVar[Param2]]]));
  end
  else
  if (ASendType = 'StringVar') then
  begin
    SplitString(Params, ',', Param1, Param2);
    Param1 := wa.MoreIfParentild(Param1);
    Param2 := wa.MoreIfParentild(Param2);
    CodeSite.Send(Param1, Format('%s="%s"', [Param2, pWebApp.StringVar[Param2]]));
  end
  else
  begin
    Params := wa.MoreIfParentild(Params);
    if (ASendType = 'Error') then
      CodeSite.SendError(Params)
    else
    if (ASendType = 'Warning') then
      CodeSite.SendWarning(Params)
    else
    //if (ASendType = 'Note') then
      CodeSite.SendNote(Params);
  end;
  {$ENDIF}
end;

procedure TdmwhUIHelpers.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  CSEnterMethod(Self, cFn);
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  CSExitMethod(Self, cFn);
end;

end.
