unit whLoadFromDB_dmwhData;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this WebHub sample file *)

interface

uses
  SysUtils, Classes,
  webLink, Data.DB, Datasnap.DBClient;

type
  TDMContent = class(TDataModule)
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMContent: TDMContent;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webApp, htWebApp, ucCodeSiteInterface, whdemo_ViewSource;

{ TDM001 }

procedure TDMContent.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMContent.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      ClientDataSet1.FileName := getHtDemoDataRoot + 'whLoadFromDB\' +
        'whContent.xml';
      try
        ClientDataSet1.Open;
      except
        on E: Exception do
        begin
          ErrorText := E.Message;
        end;
      end;

      if ErrorText = '' then
      begin
        // helpful to know that WebAppUpdate will be called whenever the
        // WebHub app is refreshed.
        AddAppUpdateHandler(WebAppUpdate);
        FlagInitDone := True;
      end;
    end;
  end;
  Result := FlagInitDone;
  {$IFDEF CodeSite}CodeSite.Send('Result', Result);
  CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMContent.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

end.
