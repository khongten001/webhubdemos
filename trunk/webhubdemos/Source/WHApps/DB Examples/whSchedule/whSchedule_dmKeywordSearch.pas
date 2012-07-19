unit whSchedule_dmKeywordSearch;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2012 HREF Tools Corp.  All Rights Reserved Worldwide.      * }
{ *                                                                          * }
{ * WebHub datamodule for searching the keyword index using Rubicon.         * }
{ *                                                                          * }
{ * Requires: Firebird SQL                                                   * }
{ *           Rubicon components from HREF Tools Corp.                       * }
{ ---------------------------------------------------------------------------- }

interface

uses
  SysUtils, Classes,
  IB_Components, IBODataSet,
  rbBridge_i_ibobjects, rbCache, rbSearch, rbRank,
  webLink, webRubi, updateOK, tpAction, webTypes, webScan, webScanKeys, webGrid;

type
  TDMRubiconSearch = class(TDataModule)
    waSelectSearchLogic: TwhWebAction;
    waShowIndex: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure waRubiSearchExecute(Sender: TObject);
    procedure waSelectSearchLogicExecute(Sender: TObject);
    procedure waShowIndexExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    FScheduleGeneratorNumber: Integer;
    IBOQueryText: TIBOQuery;
    IBOQueryWords: TIBOQuery;
    rbCache1: TrbCache;
    rbSearch1: TrbSearch;
    rbTextIBOLink1: TrbTextIBOLink;
    rbWordsIBOLink1: TrbWordsIBOLink;
    procedure WebAppUpdate(Sender: TObject);
    procedure waRubiSearchColStart(Sender: TwhScan; var ok: Boolean);
    procedure waRubiSearchNotify(Sender: TObject;
      Event: TwhScanNotify);
    function ScheduleMaxIndex(Sender: TObject): Integer;
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
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  TypInfo, Character,
  ucCodeSiteInterface, ucString,
  webApp, htWebApp, whMacroAffixes, webSend,
  uFirebird_Connect_CodeRageSchedule;

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
  FScheduleGeneratorNumber := -1;
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

    IBOQueryText := TIBOQuery.Create(Self);
    IBOQueryText.Name := 'IBOQueryText';
    IBOQueryText.IB_Connection := gCodeRageSchedule_Conn;
    IBOQueryText.SQL.Text := 'select * from schedule';
    IBOQueryText.Prepare;
    IBOQueryText.Open;

    rbTextIBOLink1 := TrbTextIBOLink.Create(Self);
    rbTextIBOLink1.Name := 'rbTextIBOLink1';
    rbTextIBOLink1.TableName := 'Schedule';
    rbTextIBOLink1.IBOQuery := IBOQueryText;
    rbTextIBOLink1.OnMaxIndex := ScheduleMaxIndex;
    rbTextIBOLink1.SelectAll := True;

    IBOQueryWords := TIBOQuery.Create(Self);
    IBOQueryWords.Name := 'IBOQueryWords';
    IBOQueryWords.IB_Connection := gCodeRageSchedule_Conn;
    IBOQueryWords.ReadOnly := True;

    rbWordsIBOLink1 := TrbWordsIBOLink.Create(Self);
    rbWordsIBOLink1.Name := 'rbWordsIBOLink1';
    rbWordsIBOLink1.IBOQuery := IBOQueryWords;
    rbWordsIBOLink1.TableName := 'WORDS';

    rbSearch1 := TrbSearch.Create(Self);
    rbSearch1.Name := 'rbSearch1';
    rbSearch1.International := True;
    rbSearch1.SearchLogic := slOr;

    with rbSearch1 do
    begin
      Cache := rbCache1;
      TextLink := rbTextIBOLink1;
      WordsLink := rbWordsIBOLink1;
    end;

    waRubiSearch := TwhRubiconSearch.Create(Self);
    waRubiSearch.Name := 'waRubiSearch';
    with waRubiSearch do
    begin
      Col := 1;
      ColCount := 1;
      ControlsPos := dsNone;
      ButtonAutoHide := True;
      SearchDictionary := rbSearch1;
      OnExecute := waRubiSearchExecute;
      OnNotify := waRubiSearchNotify;
      OnColStart := waRubiSearchColStart;
      RecordLimit := 1500;
    end;
  end;

  if Assigned(pWebApp) and pWebApp.IsUpdated then
  begin

    RefreshWebActions(Self);

    // helpful to know that WebAppUpdate will be called whenever the
    // WebHub app is refreshed.
    AddAppUpdateHandler(WebAppUpdate);
    FlagInitDone := True;
    Result := True;
  end;
end;

procedure TDMRubiconSearch.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

procedure TDMRubiconSearch.waRubiSearchColStart(Sender: TwhScan;
  var ok: Boolean);
var
  i:integer;
  S: string;
begin
  inherited;

  { The code rage schedule information happens to all be shown within one table
    data cell. }

  i := TwhRubiconSearch(Sender).RowKey;

  pWebApp.Response.SendComment('SchNo ' + IntToStr(i));
  if IBOQueryText.Locate('SchNo', i, []) then
  begin
    with pWebApp do
    begin
      StringVar['readonly-SCHEDULE-SchTitle'] := IBOQueryText.FieldByName('SchTitle').AsString;
      StringVar['readonly-SCHEDULE-CalcPresenter'] :=
        IBOQueryText.FieldByName('SCHPRESENTERFULLNAME').AsString;
      S := IBOQueryText.FieldByName('SCHPRESENTEROrg').AsString;
      if S <> '' then
        StringVar['readonly-SCHEDULE-CalcPresenter'] :=
        StringVar['readonly-SCHEDULE-CalcPresenter'] +
          ' &ndash; ' + S;

      StringVar['readonly-SCHEDULE-SchCodeRageConfNo'] :=
       IBOQueryText.FieldByName('SchCodeRageConfNo').AsString;

      StringVar['readonly-SCHEDULE-SCHONATPDT'] :=
       FormatDateTime('dd-MMM-yyyy',
         IBOQueryText.FieldByName('SCHONATPDT').AsDateTime);

      S := IBOQueryText.FieldByName('SCHBlurb').AsString;
      if S <> '' then
        S := S + '<br/>';
      StringVar['readonly-SCHEDULE-SCHBlurb'] := S;

      S := IBOQueryText.FieldByName('SCHREPLAYDOWNLOADURL').AsString;
      StringVar['readonly-SCHEDULE-SCHREPLAYDOWNLOADURL'] := S;

      // 18-July-2012: the "watch now" URLs are all not working, not even from
      // within the Embarcadero web site.  They were working 3 days ago.

      S := IBOQueryText.FieldByName('SCHREPLAYWATCHNOWURL').AsString;
      StringVar['readonly-SCHEDULE-SCHREPLAYWATCHNOWURL'] := S;

      SendMacro('drReplayMatchCell');
    end;
  end
  else
    pWebApp.SendStringImm(Format('SchNo %d not found?!?', [i]));

end;

procedure TDMRubiconSearch.waRubiSearchExecute(Sender: TObject);
var
  i: TSearchLogic;
  S: string;
begin
  with TwhRubiconSearch(Sender) do
  begin
    SearchValue := pWebApp.StringVar['inKeywords'];
    {$IFDEF CodeSite}CodeSite.Send('SearchValue', SearchValue);{$ENDIF}
    rbSearch1.SearchLogic := slSmart;
    for i := slAnd to slSmart do
    begin
      S := GetEnumName(TypeInfo(TSearchLogic), Ord(i));
      if pWebApp.StringVar['inSearchLogic'] = S then
      begin
        rbSearch1.SearchLogic := i;
        break;
      end;
    end;
    if gCodeRageSchedule_Conn.ConnectionWasLost then
    begin
      gCodeRageSchedule_Conn.DisconnectToPool;
      gCodeRageSchedule_Conn.Connect;
    end;

    Search;
    //pWebApp.Summary.Add(IBOQueryText.SQL.text);
  end;
end;

procedure TDMRubiconSearch.waRubiSearchNotify(Sender: TObject;
  Event: TwhScanNotify);
(* These are all the possible Event constants for this procedure. They are
   defined on TwhScan.
     wsAfterInit
     wsBeforeControls, wsAfterControls
     wsBeforeButtons,  wsAfterButtons
     wsBeforeScan,     wsAfterScan
     wsBeforeRow,      wsAfterRow
     wsBeforeCol,      wsAfterCol
     wsAfterExecute
     wsEmpty
     wsBeforeCHd,      wsAfterCHd
     wsButtonsPrep
*)
begin
  inherited;
  with TwhRubiconSearch(Sender),Response do
  begin
    //SendComment(GetEnumName(TypeInfo(TwhScanNotify),ord(Event)));
    case Event of
//    wsBefore:
    wsBeforeCol:
      if Row mod 2 = 0 then
        td := '<td class="alteven">'
      else
        td := '<td class="altodd">';
    wsBeforeRow:
      begin
        IBOQueryText.Close;
        IBOQueryText.Params[0].AsInteger := RowKey;
        IBOQueryText.Open;
      end;
    wsBeforeScan:
      if PageHeight<0 then
        TABLE:=''
      else
        TABLE:='<table class="' + waRubiSearch.ClassName + '">';
//    wsAfter:
    wsAfterCol: ;
    wsAfterRow: ;
    wsAfterScan: ;
    //
    wsAfterInit: ;
    wsAfterExecute:;
    //
    wsBeforeButtons:
      //SendLine('<hr><center>')
      ;
    wsAfterButtons:
      //SendLine('</center>')
      ;
    wsBeforeControls: ;
    wsAfterControls: ;
    //
    wsEmpty:
      SendHDR('3','Zero matches.');
      end;
    end;
end;

procedure TDMRubiconSearch.waSelectSearchLogicExecute(Sender: TObject);
var
  i: TSearchLogic;
  Macro4Select: string;
  S: string;

begin
  Macro4Select := '';
  for i := slAnd to slSmart do
  begin
    S := GetEnumName(TypeInfo(TSearchLogic), Ord(i));
    Macro4Select := Macro4Select + S + '-' + Copy(S, 3, MaxInt);
    if i < slSmart then
      Macro4Select := Macro4Select + ',';
  end;

  pWebApp.Macros.Values['mcSearchLogicList'] := Macro4Select;
  pWebApp.SendMacro('INPUTSELECT|inSearchLogic,mcSearchLogicList,1,No');
end;

procedure TDMRubiconSearch.waShowIndexExecute(Sender: TObject);
var
  Q: TIB_Cursor;
  DrLetterName, DrWordName: string;
  PrevLetter, ThisLetter: char;
  ThisWord: string;
begin
  if NOT gCodeRageSchedule_Conn.Connected then
    gCodeRageSchedule_Conn.Connect;

  if SplitString(waShowIndex.HtmlParam, ',', DrLetterName, DrWordName) then
  begin
    try
      Q := TIB_Cursor.Create(Self);
      Q.Name := 'QWordList';
      Q.IB_Connection := gCodeRageSchedule_Conn;
      Q.IB_Session := gCodeRageSchedule_Sess;
      Q.SQL.Text := 'SELECT RbWord, RbCount from Words order by RbWord';
      if gCodeRageSchedule_Conn.ConnectionWasLost then
        gCodeRageSchedule_Conn.Connect;
      try
        Q.Prepare;
        Q.Open;
      except
        on E: Exception do
        begin
          {$IFDEF CodeSite}CodeSite.SendException(E);{$ENDIF}
          LogSendInfo(Q.Name, Q.SQL.Text);
        end;
      end;
      pWebApp.SendDroplet(DrWordName, drBeforeWhrow);
      Q.First;
      PrevLetter := #0;
      while NOT Q.EOF do
      begin
        with pWebApp do
        begin
          ThisWord := Q.Fields[0].AsString;
          if Length(ThisWord) > 0 then
          begin
            Thisletter := ThisWord[1];
            { be sure to skip the special __Properties__ entry in WORDS table }
            if (NOT IsDigit(ThisLetter)) and (Ord(ThisLetter) <> 127) then
            begin
              StringVar['readonly-WORDS-rbLetter'] := ThisLetter;
              if ThisLetter <> PrevLetter then
              begin
                pWebApp.SendMacro(DrLetterName);
                PrevLetter := ThisLetter;
              end;
              StringVar['readonly-WORDS-RbWord'] := ThisWord;
              StringVarInt['readonly-WORDS-RbCount'] := Q.Fields[1].AsInteger;
              SendDroplet(DrWordName, drWithinWhrow);
            end;
          end;
        end;
        Q.Next;
      end;
      Q.Close;
      pWebApp.SendDroplet(DrWordName, drAfterWhrow);
    finally
      FreeAndNil(Q);
    end;
  end;
end;

function TDMRubiconSearch.ScheduleMaxIndex(Sender: TObject): Integer;
//const cFn = 'ScheduleMaxIndex';
var
  Q: TIB_Cursor;
begin
  Q := nil;
///  FScheduleGeneratorNumber := 200;  // !!! code below fails. not sure why yet.
  if FScheduleGeneratorNumber = -1 then
  begin
    try
      Q := TIB_Cursor.Create(Self);
      Q.Name := 'QGENSCHEDULENO';
      Q.IB_Connection := gCodeRageSchedule_Conn;
      Q.IB_Session := gCodeRageSchedule_Sess;
      Q.ReadOnly := True;
      Q.SQL.Text := 'SELECT GEN_ID(GENSCHEDULENO, 0) FROM RDB$DATABASE';
      if NOT gCodeRageSchedule_Conn.Connected then
        gCodeRageSchedule_Conn.Connect;
      try
        Q.Prepare;
        Q.Open;
      except
        on E: Exception do
        begin
          {$IFDEF CodeSite}CodeSite.SendException(E);{$ENDIF}
          LogSendInfo(Q.Name, Q.SQL.Text);
        end;
      end;
      FScheduleGeneratorNumber := Q.Fields[0].AsInteger;
      Q.Close;
    finally
      FreeAndNil(Q);
    end;
  end;

  Result := FScheduleGeneratorNumber; // 200 as of 2011
end;

end.
