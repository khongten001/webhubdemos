unit DSP_dmWH1;

interface

uses
  SysUtils, Classes,
  updateOk, tpAction,
  webTypes, webLink, webScan, webGrid, webScanKeys, webRubi, webCall,
  uDSPFuzziness;

type
  TdmDSPWebSearch = class(TDatamodule)
    waSearch: TwhWebActionEx;
    procedure waExtraInfoExecute(Sender: TObject);
    procedure waSearchExecute(Sender: TObject);
    procedure waResultsExecute(Sender: TObject);
    procedure waResultsColStart(Sender: TwhScan; var ok: Boolean);
    procedure waResultsNotify(Sender: TObject; Event: TwhScanNotify);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    waResults: TwhScanKeysGrid;
    waExtraInfo: TwhWebAction;
    function Init(out ErrorText: string): Boolean;
    procedure DSPPageCalcTime(Sender: TwhConnection;
      var ExecutionAverageMS: Integer);
  end;

var
  dmDSPWebSearch: TdmDSPWebSearch;

implementation

uses
  Math,
  ucWinAPI, ucPos, ucString, ucLogFil, ucInteg, ucMsTime,
  webApp, htmConst, whMacroAffixes,
  DSP_dmRubicon, DSP_u1;

{$R *.DFM}

procedure TdmDSPWebSearch.DataModuleCreate(Sender: TObject);
begin
  inherited;
  waResults := nil;
  waExtraInfo := nil;
end;

function TdmDSPWebSearch.Init(out ErrorText: string): Boolean;
begin
  ErrorText := '';
  Result := False;
  try
    waExtraInfo := TwhWebAction.Create(Self);
    waExtraInfo.Name := 'waExtraInfo';
    waExtraInfo.OnExecute := waExtraInfoExecute;

    waResults := TwhScanKeysGrid.Create(Self);
    waResults.Name := 'waResults';
    with waResults do
    begin
      OnExecute := waResultsExecute;
      Row := 0;
      RowCount := 0;
      Col := 1;
      ColCount := 1;
      PageHeight := 10;
      PageRows := 0;
      PageRow := 0;
      ColStyle := scData;
      FixCols := 0;
      FixRows := 0;
      FixRowHeader := False;
      FixColHeader := False;
      OverlapScroll := False;
      ScanMode := dsByKey;
      ControlAutoHide := False;
      Buttons := [dsbFirst, dsbPrior, dsbNext, dsbLast];
      ButtonStyle := bsLink;
      ButtonAutoHide := True;
      OnNotify := waResultsNotify;
      OnColStart := waResultsColStart;
      TABLE := '';
      TR := '<tr>';
      TH := '<th>';
      TD := '<td>';
      BR := '';
    end;
    RefreshWebActions(Self);
    pConnection.OnPageCalcTime := DSPPageCalcTime;
    Result := True;
  except
    on E: Exception do
    begin
      ErrorText := E.Message;
    end;
  end;
end;

procedure TdmDSPWebSearch.DSPPageCalcTime(Sender: TwhConnection;
  var ExecutionAverageMS: Integer);
begin
  { prevent testing of extraordinarily slow web pages from blocking further
    requests }
  ExecutionAverageMS := Math.Min(ExecutionAverageMS, 200);
end;

function StringReplace2(const Value, sThis, sWith: string): string;
// will completely remove a substring from the main string.
// Look in http://www.href.com/pub/relnotes/ for WebHub v2-018 to find
// notes about this function.
var
  a1, a2: string;
begin
  Result := Value;
  if PosCI(sThis, Value) > 0 then
  begin
    while SplitString(Result, sThis, a1, a2) do
      Result := a1 + sWith + a2;
  end;
end;

procedure TdmDSPWebSearch.waExtraInfoExecute(Sender: TObject);
{$I rbVersion.inc}  // const RubiconVersion
var
  ActionKeyword: string;
  ARVersion: string;
  InfoMsg: string;
begin
  ActionKeyword := TwhWebAction(Sender).HtmlParam;
  if ActionKeyword = 'RubiconVersion' then
  begin
    ARVersion := IntToStr(RubiconVersion); // e.g. 3997
    pWebApp.SendStringImm(Copy(ARVersion, 1, 1) + '.' + Copy(ARVersion, 2, 3));
  end
  else if ActionKeyword = 'RubiconBridge' then
  begin
    InfoMsg := 'B (Borland Database Engine)';
    pWebApp.SendStringImm(InfoMsg);
  end;
end;

var
  FlagInitOnce: Boolean = False;

procedure TdmDSPWebSearch.waSearchExecute(Sender: TObject);
var
  a0, a4, aFind, aExcl, aOr, aAnd: string;
  S: string;
  i, n: Integer;
  StartTime: Cardinal;
  FuzzLevel: TFuzzyness;
  bDelphiAll: Boolean;
  bCPPAll: Boolean;

  function GetBoolean(const InBoolVarName: string): string;
  begin
    if pWebApp.BoolVar[InBoolVarName] then
      Result := 'zzz' + InBoolVarName
    else
      Result := '';
  end;

begin
  inherited;
  try
    with waResults do
    begin
      if (not FlagInitOnce) or
        (pWebApp.Request.FormData.Values['newsearch'] = 'yes') then
      begin
        { We have just started the app, or just started a new search }
        Update;
        RowKeys := '';
        RowCount := 0;
        Row := 0; // doing this always makes it impossible to scroll forward
        PageRows := 10;
        FlagInitOnce := True;
        bDelphiAll := pWebApp.BoolVar['DelphiAll'];
        pWebApp.BoolVar['D10'] := bDelphiAll;
        pWebApp.BoolVar['D20'] := bDelphiAll;
        pWebApp.BoolVar['D30'] := bDelphiAll;
        pWebApp.BoolVar['D40'] := bDelphiAll;
        pWebApp.BoolVar['D50'] := bDelphiAll;
        pWebApp.BoolVar['D60'] := bDelphiAll;
        pWebApp.BoolVar['D70'] := bDelphiAll;
        pWebApp.BoolVar['D80'] := bDelphiAll;
        pWebApp.BoolVar['D2K5'] := bDelphiAll;
        pWebApp.BoolVar['K10'] := bDelphiAll;
        pWebApp.BoolVar['K20'] := bDelphiAll;
        pWebApp.BoolVar['K30'] := bDelphiAll;
        bCPPAll := pWebApp.BoolVar['CPPAll'];
        pWebApp.BoolVar['C10'] := bCPPAll;
        pWebApp.BoolVar['C20'] := bCPPAll;
        pWebApp.BoolVar['C30'] := bCPPAll;
        pWebApp.BoolVar['C40'] := bCPPAll;
        pWebApp.BoolVar['C50'] := bCPPAll;
        pWebApp.BoolVar['C60'] := bCPPAll;
      end
      else
        Update;
    end;

    with DSPdm, pWebApp do
    begin
      StartTime := GetTickCount;
      if not tblFiles.Active then
        tblFiles.Open;

      // aFind := StringReplaceAll(Session.TxtVars.ListText['txtSearch'], sLineBreak, ' ');
      // aExcl := StringReplaceAll(Session.TxtVars.ListText['txtExclude'], sLineBreak, ' ');

      aFind := StringReplaceAll(Session.StringVars.Values['inSearch'],
        sLineBreak, ' ');
      aExcl := StringReplaceAll(Session.StringVars.Values['inExclude'],
        sLineBreak, ' ');
      with Request do
      begin
        S := 'waSearchExecute: ' + trim(aFind);
        if trim(aExcl) <> '' then
          S := S + ', excluding ' + aExcl;
        S := S + '. ' + QueryString + ' UserAgent=' + UserAgent + ' IP# ' +
          RemoteAddress + ' Session ' + SessionID;
        LogInfo(S);
      end;

      aOr := GetBoolean('D10') + ' ' + GetBoolean('D20') + ' ' +
        GetBoolean('D30') + ' ' + GetBoolean('D40') + ' ' + GetBoolean('D50') +
        ' ' + GetBoolean('D60') + ' ' + GetBoolean('D70') + ' ' +
        GetBoolean('D80') + ' ' + GetBoolean('D2K5') + ' ' + GetBoolean('K10') +
        ' ' + GetBoolean('K20') + ' ' + GetBoolean('K30') + ' ' +
        GetBoolean('C10') + ' ' + GetBoolean('C30') + ' ' + GetBoolean('C40') +
        ' ' + GetBoolean('C50') + ' ' + GetBoolean('C60') + ' ' +
        GetBoolean('J10') + ' ' + GetBoolean('J20') + ' ' + GetBoolean('J60');

      aAnd := GetBoolean('Free') + ' ' + GetBoolean('WithSource');
      try
        i := Math.Max(0, StringVarInt['SearchGroup']);
      except
        i := 0;
      end;
      StringVarInt['SearchGroup'] := i;
      if (i > 0) then
        aAnd := aAnd + ' ' + GroupSearchPrefix[i];

      try
        FuzzLevel := TFuzzyness(StringVarInt['SearchFuzziness']);
      except
        FuzzLevel := fuzAuto;
      end;
      StringVarInt['SearchFuzziness'] := ord(FuzzLevel);

      try
        i := StringVarInt['SearchLimit'];
        i := Math.Max(25, Math.Min(500, i));
      except
        i := 100;
      end;
      StringVarInt['SearchLimit'] := i;
      rbMake.CounterLimit := i;

      try
        i := StringVarInt['SearchNear'];
        i := Math.Max(2, Math.Min(50, i));
      except
        i := 8;
      end;
      StringVarInt['SearchNear'] := i;
      rbSearch.NearWord := i;

      n := PerformSearch(rbSearch, ZapTrailing(aFind, ' '),
        ZapTrailing(aExcl, ' '), ZapTrailing(aOr, ' '), ZapTrailing(aAnd, ' '),
        FuzzLevel, a4, SearchWords);

      StringVarInt['SearchResults'] := n;
      StringVarInt['SearchRecords'] := Math.Min(n, rbMake.CounterLimit);
      if n > rbMake.CounterLimit then
        StringVar['SearchRecords'] := StringVar['SearchRecords'] + ' of ' +
          IntToStr(n);

      if n = 0 then
      begin
        a0 := 'Search returned no matches.'
        // none
      end
      else
      begin
        // show the words:
        // if bFuzzy then
        // a0:='Fuzzy search for ['+a4+'] used these words:'+sLineBreak
        // else
        // a0:='Search used these words:'+sLineBreak;
        // how many instances per word:
        with SearchWords do
        begin
          Sort;
          for i := 0 to pred(count) do
            a0 := a0 + Strings[i] + ', ' + IntToStr(WordCount(Strings[i])) +
              '<br>' + sLineBreak;
        end;
      end;
      // mWords.Lines.Text:=a0;
      Session.TxtVars.ListText['txtWords'] := a0;

      with rbSearch, waResults do
      begin
        RowKeys := SearchResults;
        RowCount := Math.Min(n, rbMake.CounterLimit);
      end;

      // BoolVar['bNewResults']:=true;  // this means, display the results page, not intro.
      StringVarInt['SearchTime'] := ucMsTime.ElapsedMillisecondsSince
        (StartTime);

      AppendToLog(DatedFileName(AppSetting['SearchLog']),
        pWebApp.Request.RemoteAddress + ',' + SessionID + ',' +
        StringVar['SearchFuzziness'] + ',' + StringVar['SearchTime'] + ',' +
        StringVar['SearchResults'] // ucstring
        + ',"' + StringReplaceAll(ZapTrailing(aFind, ' '), '"', '''') + '"' +
        ',"' + StringReplaceAll(ZapTrailing(aExcl, ' '), '"', '''') + '"' + ','
        + DefaultsTo(StringReplaceAll(TrimLeft(StringReplace2(ZapTrailing(aAnd,
        ' '), '  ', ' ')), ' ', '+'), 'any') + ',' +
        DefaultsTo(StringReplaceAll(TrimLeft(StringReplace2(ZapTrailing(aOr,
        ' '), '  ', ' ')), ' ', '*'), 'all'));

      // SendMacro('BOUNCE|Results');
      StringVar['partb'] := 'results';
      // 1-June changed from Results to waResults
      // 22-April-AML made this render the page directly.  Results is a PageID.
      // 2-June changed to setting the partb literal
    end;
  except // try...except block added 16-May-2001 AML.
    on E: Exception do
    begin
      pWebApp.SendString(E.Message);
    end;
  end;
end;

procedure TdmDSPWebSearch.waResultsExecute(Sender: TObject);
begin
  inherited;
  with DSPdm, pWebApp do
  begin
    BoolVar['bEmpty'] := False;
    FileRoot := StringVar['DSPURLPrefix'];
    if FileRoot = '' then
    begin
      FileRoot := cDSP;
      StringVar['DSPURLPrefix'] := FileRoot;
    end;
  end;
end;

procedure TdmDSPWebSearch.waResultsColStart(Sender: TwhScan; var ok: Boolean);
// var a1:string;
begin
  inherited;
  with TwhScanKeysGrid(Sender), DSPdm do
  begin
    pWebApp.SendString(FileDetailHTML[RowKey] + sLineBreak);
  end;
end;

procedure TdmDSPWebSearch.waResultsNotify(Sender: TObject;
  Event: TwhScanNotify);
begin
  inherited;
  with pWebApp, Response do
  begin
    case Event of
      wsBeforeScan:
        begin
          SendMacro('chBeforeScan');
        end;
      wsAfterScan:
        begin
          SendMacro('chAfterScan');
        end;
      wsBeforeButtons:
        SendMacro('chBeforeButtons');
      wsAfterExecute:
        SendMacro('chAfterExecute');
      wsEmpty:
        begin
          BoolVar['bEmpty'] := True;
          SendMacro('mcNoMatch');
        end;
    end;
  end;
end;

end.
