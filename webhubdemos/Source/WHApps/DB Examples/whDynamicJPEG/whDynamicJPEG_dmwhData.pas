unit whDynamicJPEG_dmwhData;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this WebHub sample file *)

interface

uses
  SysUtils, Classes,
  webLink, Xml.xmldom, Data.DB, Datasnap.Provider, Xmlxform, Datasnap.DBClient,
  updateOK, tpAction, webTypes;

type
  TDMBIOLIFE = class(TDataModule)
    ClientDataSet1: TClientDataSet;
    XMLTransformProvider1: TXMLTransformProvider;
    DataSourceBiolife: TDataSource;
    waAnimalNav: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure waAnimalNavExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMBIOLIFE: TDMBIOLIFE;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webApp, htWebApp, ucCodeSiteInterface, whdemo_ViewSource;

{ TDM001 }

procedure TDMBIOLIFE.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
  XMLTransformProvider1.TransformRead.TransformationFile :=
    getHtDemoDataRoot + 'embSample\BiolifeToDp.xtr';
  XMLTransformProvider1.XMLDataFile := getHtDemoDataRoot + 'embSample\' +
    'biolife.xml';
  ClientDataSet1.ReadOnly := True;
end;

function TDMBIOLIFE.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      try
        ClientDataSet1.Active := True;
      except
        on E: Exception do
        begin
          ErrorText := E.Message;
          {$IFDEF CodeSite}
          CodeSite.SendException(E);
          {$ENDIF}
        end;
      end;

      if ErrorText = '' then
      begin
        // Call RefreshWebActions here only if it is not called within a TtpProject event
        RefreshWebActions(Self);

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

procedure TDMBIOLIFE.waAnimalNavExecute(Sender: TObject);
const cFn = 'waAnimalNavExecute';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // Move pointer within the table to the next record so that the
  // the display shows a different image.
  with TwhWebAction(Sender) do
  begin
    CSSend(TwhWebAction(Sender).Name + '.Command', Command);
    if (Command = 'Prev') then
    begin
      ClientDataSet1.Prior;
      if ClientDataSet1.BOF then
        ClientDataSet1.Last
    end
    else
    begin
      ClientDataSet1.Next;
      if ClientDataSet1.EOF then
        ClientDataSet1.First;
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMBIOLIFE.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

end.
