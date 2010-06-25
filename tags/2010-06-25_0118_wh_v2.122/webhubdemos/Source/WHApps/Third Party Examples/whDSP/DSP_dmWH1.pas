unit DSP_dmWH1;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   dmBasic, TpMenu, UpdateOk, tpAction,
   webTypes, webLink, webScan, webGrid, webScanKeys, webRubi,
   uDSPFuzziness;

type
   TdmDSPWebSearch = class(TdmBasicDatamodule)
      waSearch: TwhWebActionEx;
      waFeedback: TwhWebActionEx;
      waMirrors: TwhScanGrid;
      procedure waSearchExecute(Sender: TObject);
      procedure waFeedbackExecute(Sender: TObject);
      procedure waResultsExecute(Sender: TObject);
      procedure waResultsColStart(Sender: TwhScan; var ok: Boolean);
      procedure waResultsNotify(Sender: TObject; Event: TwhScanNotify);
      procedure waMirrorsExecute(Sender: TObject);
      procedure waMirrorsRowStart(Sender: TwhScan; var ok: Boolean);
      procedure waMirrorsColStart(Sender: TwhScan; var ok: Boolean);
      procedure DataModuleCreate(Sender: TObject);
   private
      { Private declarations }
   public
      waResults: TwhScanKeysGrid;
      function Init: Boolean; override;
   end;

var
   dmDSPWebSearch: TdmDSPWebSearch;

implementation

uses
   Math, ucWinAPI, ucPos, ucString, ucLogFil, ucInteg, ucMsTime,
   webApp, htmConst, whMacroAffixes, DSP_dmRubicon, DSP_u1;

{$R *.DFM}

procedure TdmDSPWebSearch.DataModuleCreate(Sender: TObject);
begin
   Inherited;
   waResults:=nil;
end;

function TdmDSPWebSearch.Init: Boolean;
begin
   Result:=Inherited Init;
   If not Result then Exit;
   With waMirrors do
      begin
         TD := MacroStart + 'mcMirrTD' + MacroEnd;
         TH := MacroStart + 'mcMirrTD' + MacroEnd;
         OnColStart := waMirrorsColStart;
         OnRowStart := waMirrorsRowStart;
         TABLE := '<table>';
         BR := '<br />';
      end;
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
end;

function StringReplace2(const Value,sThis,sWith:String): String;
// will completely remove a substring from the main string.
// see http://www.href.com/pub/relnotes/v2-018.htm for notes about this function.
var a1,a2:string;
begin
   Result:=Value;
   If PosCI(sThis,Value)>0 then
      begin
         While SplitString(Result,sThis,a1,a2) do Result:=a1+sWith+a2;
      end;
end;

var FlagInitOnce: Boolean = False;
procedure TdmDSPWebSearch.waSearchExecute(Sender: TObject);
var
   a0,a4,aFind,aExcl,aOr,aAnd: string;
   S: string;
   i,n: integer;
   StartTime: dword;
   FuzzLevel: TFuzzyness;

   function GetBoolean(aChecked:String): String;
   begin
      //    if pWebApp.BoolVar[aChecked] then
      // 1-June-2001 AML: due to the use of frames, the Checked array stays empty.
      If pWebApp.Request.FormData.Count > 0 then
         begin
            If AnsiSameText(pWebApp.Request.FormData.Values[aChecked],'Yes') then
               begin
                  Result:= 'zzz'+aChecked;
                  pWebApp.BoolVar[aChecked]:=true;   // try to remember the setting!
               end
            Else
               begin
                  Result:= '';
                  pWebApp.BoolVar[aChecked]:=false;
               end;
         end
      Else
         begin
            If pWebApp.BoolVar[aChecked] then Result := 'zzz' + aChecked
            Else Result := '';
         end;
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

procedure TdmDSPWebSearch.waFeedbackExecute(Sender: TObject);
begin
   Inherited;
   LogInfo('waFeedbackExecute');
   With pWebApp do
      begin
         AppendToLog(DatedFileName(AppSetting['FeedBackFile'])
                  ,pWebApp.Request.RemoteAddress
                  +','+SessionID
                  +','+StringVar['firstname']
                  +','+TrimLeft(StringVar['firstname']+' '+StringVar['lastname']+' <'+StringVar['email']+'>')
                  +','+StringReplaceAll(Session.TxtVars.ListText['txtMessage'],#13#10,'\n')
         );
      end;
end;

procedure TdmDSPWebSearch.waMirrorsExecute(Sender: TObject);
begin
   Inherited;
   LogInfo('waMirrorsExecute');
   With waMirrors, DSPdm.Mirrors do
      begin
         RowCount := Count+1;
         Row := 1;
         PageHeight := 0
      end;
end;

var c0,c1,c2,c3: String;
procedure TdmDSPWebSearch.waMirrorsRowStart(Sender: TwhScan; var ok: Boolean);
   function GetC1:String;
   begin
      //if waMirrors.Row=2 then
      //  Result:=UpperCase(c1)
      //else
      Result:=c1;
   end;
begin
   Inherited;
   With waMirrors, DSPdm.Mirrors do
      If Row>0 then
         If Row=1 then
            begin
               c0:='&nbsp';
               c1:='URL';
               c2:='Country';
               c3:='Continent';
            end
         Else
            begin
               splitstring(strings[Row-2],'=',c1,c2);
               splitstring(c2,',',c2,c3);

               c0 := '';
               If pWebApp.StringVar['DSPUrlPrefix'] = c1 then c0 := 'checked="checked" ';
               c0:='<input type="radio" name="DSPUrlPrefix" ' + c0 + 'value="' + c1 + '"/>';

               c1:='<a href="'+c1+'" target="_top">'+GetC1;
               If c2='United States' then c3:='North America';
            end;
end;

procedure TdmDSPWebSearch.waMirrorsColStart(Sender: TwhScan; var ok: Boolean);
begin
   Inherited;
   With waMirrors, pWebApp do
      Case col of
         1: SendString(c0);
         2: SendString(c3);
         3: SendString(c2);
         4: SendString(c1);
      End;
end;

end.

