unit whSchedule_dmKeywordSearch;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this file *)

interface

uses
  SysUtils, Classes,
  IB_Components, IBODataSet,
  rbBridge_i_ibobjects, rbCache, rbSearch, rbRank,
  webLink, webRubi;

type
  TDMRubiconSearch = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    IBOQueryText: TIBOQuery;
    IBOQueryWords: TIBOQuery;
    rbCache1: TrbCache;
    rbSearch1: TrbSearch;
    rbTextIBOLink1: TrbTextIBOLink;
    rbWordsIBOLink1: TrbWordsIBOLink;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    waRubiSearch: TwhRubiconSearch;
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMRubiconSearch: TDMRubiconSearch;

implementation

{$R *.dfm}

uses
  webApp, htWebApp, uFirebird_Connect_CodeRageSchedule;

{ TDMRubiconSearch }

procedure TDMRubiconSearch.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
  IBOQueryText := nil;
  IBOQueryWords := nil;
  rbTextIBOLink1 := nil;
  rbWordsIBOLink1 := nil;
  rbCache1 := nil;
  waRubiSearch := nil;
end;

procedure TDMRubiconSearch.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(IBOQueryText);
  FreeAndNil(IBOQueryWords);
  FreeAndNil(rbTextIBOLink1);
  FreeAndNil(rbWordsIBOLink1);
  FreeAndNil(rbCache1);
  FreeAndNil(waRubiSearch);
end;

function TDMRubiconSearch.Init(out ErrorText: string): Boolean;
begin
  ErrorText := '';
  Result := FlagInitDone;
  // reserved for code that should run once, after AppID set
  if Result then Exit;

  if NOT Assigned(rbCache1) then
  begin
    rbCache1 := TrbCache.Create(Self);
    rbCache1.Name := 'rbCache1';

    rbTextIBOLink1 := TrbTextIBOLink.Create(Self);
    rbTextIBOLink1.Name := 'rbTextIBOLink1';
    rbTextIBOLink1.TableName := 'Schedule';

    IBOQueryWords := TIBOQuery.Create(Self);
    IBOQueryWords.Name := 'IBOQueryWords';
    IBOQueryWords.IB_Connection := gCodeRageSchedule_Conn;
    IBOQueryWords.ReadOnly := True;

    rbWordsIBOLink1 := TrbWordsIBOLink.Create(Self);
    rbWordsIBOLink1.Name := 'rbWordsIBOLink1';
    rbWordsIBOLink1.IBOQuery := IBOQueryWords;

    rbSearch1 := TrbSearch.Create(Self);
    rbSearch1.Name := 'rbSearch1';

    with rbSearch1 do
    begin
      Cache := rbCache1;
      TextLink := rbTextIBOLink1;
      WordsLink := rbWordsIBOLink1;
    end;

    waRubiSearch := TwhRubiconSearch.Create(Self);
    waRubiSearch.Name := 'waRubiSearch';
    waRubiSearch.SearchDictionary := rbSearch1;
  end;

  if Assigned(pWebApp) and pWebApp.IsUpdated then
  begin

    RefreshWebActions(Self);

    // helpful to know that WebAppUpdate will be called whenever the
    // WebHub app is refreshed.
    AddAppUpdateHandler(WebAppUpdate);
    FlagInitDone := True;
  end;
end;

procedure TDMRubiconSearch.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

end.
