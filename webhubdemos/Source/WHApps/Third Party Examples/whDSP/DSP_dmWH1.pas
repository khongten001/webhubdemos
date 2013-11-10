unit DSP_dmWH1;

interface

uses
  SysUtils, Classes,
  updateOk, tpAction,
  webTypes, webLink, webScan, webGrid, webScanKeys, webRubi,
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
   Inherited;
   waResults:=nil;
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
    With waResults do
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
    Result := True;
  except
    on E: Exception do
    begin
      ErrorText := E.Message;
    end;
  end;
end;

function StringReplace2(const Value,sThis,sWith:String): String;
// will completely remove a substring from the main string.
// Look in http://www.href.com/pub/relnotes/ for WebHub v2-018 to find
// notes about this function.
var a1,a2:string;
begin
   Result:=Value;
   If PosCI(sThis,Value)>0 then
      begin
         While SplitString(Result,sThis,a1,a2) do Result:=a1+sWith+a2;
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
    ARVersion := IntToStr(RubiconVersion);  // e.g. 3997
    pWebApp.SendStringImm(Copy(ARVersion, 1, 1) + '.' + Copy(ARVersion, 2, 3));
  end
  else
  if ActionKeyword = 'RubiconBridge' then
  begin
    InfoMsg := 'B (Borland Database Engine)';
    pWebApp.SendStringImm(InfoMsg);
  end;
end;

var FlagInitOnce: Boolean = False;
procedure TdmDSPWebSearch.waSearchExecute(Sender: TObject);
var
   a0,a4,aFind,aExcl,aOr,aAnd: string;
   S: string;
   i,n: integer;
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
   Inherited;
   Try
      With waResults do
       begin
          If (NOT FlagInitOnce) or (pWebApp.Request.FormData.Values['newsearch']='yes') then
           begin
              {We have just started the app, or just started a new search}
              Update;
              RowKeys:='';
              RowCount:=0;
              Row := 0;   // doing this always makes it impossible to scroll forward
              PageRows:=10;
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
        Else Update;
       end;

      With DSPdm,pWebApp do
         begin
            StartTime:=GetTickCount;
            If NOT tblFiles.Active then tblFiles.Open;

//            aFind := StringReplaceAll(Session.TxtVars.ListText['txtSearch'], sLineBreak, ' ');
//            aExcl := StringReplaceAll(Session.TxtVars.ListText['txtExclude'], sLineBreak, ' ');

            aFind := StringReplaceAll(Session.StringVars.Values['inSearch'], sLineBreak, ' ');
            aExcl := StringReplaceAll(Session.StringVars.Values['inExclude'], sLineBreak, ' ');
            With Request do
               begin
                  s:='waSearchExecute: '+trim(aFind);
                  If trim(aExcl)<>'' then s:=s+', excluding '+aExcl;
                  s:=s+'. '+ QueryString + ' UserAgent=' + UserAgent + ' IP# ' + RemoteAddress + ' Session ' + SessionID;
                  LogInfo(s);
               end;

            aOr:=   GetBoolean('D10')
                  +' '+ GetBoolean('D20')
                  +' '+ GetBoolean('D30')
                  +' '+ GetBoolean('D40')
                  +' '+ GetBoolean('D50')
                  +' '+ GetBoolean('D60')
                  +' '+ GetBoolean('D70')
                  +' '+ GetBoolean('D80')
                  +' '+ GetBoolean('D2K5')
                  +' '+ GetBoolean('K10')
                  +' '+ GetBoolean('K20')
                  +' '+ GetBoolean('K30')
                  +' '+ GetBoolean('C10')
                  +' '+ GetBoolean('C30')
                  +' '+ GetBoolean('C40')
                  +' '+ GetBoolean('C50')
                  +' '+ GetBoolean('C60')
                  +' '+ GetBoolean('J10')
                  +' '+ GetBoolean('J20')
                  +' '+ GetBoolean('J60');

            aAnd:=  GetBoolean('Free') +' '+ GetBoolean('WithSource');
            Try
               i:=Math.Max(0,StringVarInt['SearchGroup']);
            Except
               i:=0;
            End;
            StringVarInt['SearchGroup']:=i;
            If (i>0) then aAnd:= aAnd+' '+GroupSearchPrefix[i];

            Try
               FuzzLevel:=TFuzzyness(StringVarInt['SearchFuzziness']);
            Except
               FuzzLevel:=fuzAuto;
            End;
            StringVarInt['SearchFuzziness']:=ord(FuzzLevel);

            Try
               i:=StringVarInt['SearchLimit'];
               i:=Math.Max(25,Math.Min(500,i));
            Except
               i:=100;
            End;
            StringVarInt['SearchLimit']:=i;
            rbMake.CounterLimit:=i;

            Try
               i:=StringVarInt['SearchNear'];
               i:=Math.Max(2,Math.Min(50,i));
            Except
               i:=8;
            End;
            StringVarInt['SearchNear']:=i;
            rbSearch.NearWord:=i;

            n:=PerformSearch(rbSearch,
               ZapTrailing(aFind,' '),
               ZapTrailing(aExcl,' '),
               ZapTrailing(aOr,' '),
               ZapTrailing(aAnd,' '),
               FuzzLevel,a4, SearchWords);

            StringVarInt['SearchResults']:= n;
            StringVarInt['SearchRecords']:= Math.Min(n,rbMake.CounterLimit);
            If n>rbMake.CounterLimit then StringVar['SearchRecords']:= StringVar['SearchRecords']+' of '+inttostr(n);

            If n=0 then
               begin
                  a0:='Search returned no matches.'
                  //none
               end
            Else
               begin
                  //show the words:
                  //      if bFuzzy then
                  //        a0:='Fuzzy search for ['+a4+'] used these words:'+sLineBreak
                  //      else
                  //        a0:='Search used these words:'+sLineBreak;
                  //how many instances per word:
                  With SearchWords do
                     begin
                        Sort;
                        For i:=0 to pred(count) do a0:=a0+Strings[i]+', '+IntToStr(WordCount(Strings[i]))+'<br>'+sLineBreak;
                     end;
               end;
            //mWords.Lines.Text:=a0;
            Session.TxtVars.ListText['txtWords']:=a0;

            With rbSearch,waResults do
               begin
                  RowKeys:=SearchResults;
                  RowCount:=Math.Min(n,rbMake.CounterLimit);
               end;

            //BoolVar['bNewResults']:=true;  // this means, display the results page, not intro.
            StringVarInt['SearchTime']:= ucMsTime.ElapsedMillisecondsSince(StartTime);

            AppendToLog(DatedFileName(AppSetting['SearchLog'])
                     ,pWebApp.Request.RemoteAddress
                     +','+SessionID
                     +','+StringVar['SearchFuzziness']
                     +','+StringVar['SearchTime']
                     +','+StringVar['SearchResults'] //ucstring
                     +',"'+StringReplaceAll(ZapTrailing(aFind,' '),'"','''')+'"'
                     +',"'+StringReplaceAll(ZapTrailing(aExcl,' '),'"','''')+'"'
                     +','+DefaultsTo(StringReplaceAll(TrimLeft(StringReplace2(ZapTrailing(aAnd,' '),'  ',' ')),' ','+'),'any')
                     +','+DefaultsTo(StringReplaceAll(TrimLeft(StringReplace2(ZapTrailing(aOr,' '),'  ',' ')),' ','*'),'all')
            );

            //SendMacro('BOUNCE|Results');
            StringVar['partb']:='results';
            //1-June changed from Results to waResults
            // 22-April-AML made this render the page directly.  Results is a PageID.
            // 2-June changed to setting the partb literal
         end;
   Except  // try...except block added 16-May-2001 AML.
      On e: exception do
         begin
            pWebApp.SendString(e.message);
         end;
   End;
end;

procedure TdmDSPWebSearch.waResultsExecute(Sender: TObject);
begin
   Inherited;
   With DSPdm, pWebApp do
      begin
         BoolVar['bEmpty'] := False;
         FileRoot := StringVar['DSPURLPrefix'];
         If FileRoot='' then
            begin
               FileRoot := cDSP;
               StringVar['DSPURLPrefix']:=FileRoot;
            end;
      end;
end;

procedure TdmDSPWebSearch.waResultsColStart(Sender: TwhScan; var ok: Boolean);
//var a1:string;
begin
   Inherited;
   With TwhScanKeysGrid(Sender), DSPdm do
      begin
         pWebApp.SendString(FileDetailHTML[RowKey] + sLineBreak);
      end;
end;

procedure TdmDSPWebSearch.waResultsNotify(Sender: TObject; Event: TwhScanNotify);
begin
   Inherited;
   With pWebApp,Response do
      begin
         Case Event of
            wsBeforeScan:     begin
                                 SendMacro('chBeforeScan');
                              end;
            wsAfterScan:      begin
                                 SendMacro('chAfterScan');
                              end;
            wsBeforeButtons:  SendMacro('chBeforeButtons');
            wsAfterExecute:   SendMacro('chAfterExecute');
            wsEmpty:          begin
                                 BoolVar['bEmpty'] := true;
                                 SendMacro('mcNoMatch');
                              end;
         End;
      end;
end;

end.
