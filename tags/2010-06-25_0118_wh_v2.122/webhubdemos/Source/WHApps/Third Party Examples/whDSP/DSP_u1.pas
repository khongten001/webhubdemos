unit DSP_u1;

interface

uses
   Websend,           // TwhRespondingApp
   SysUtils,          // Exception
   uCode, ucLogFil,   // HaveParam, AppendToLog
   ucString,          // IP2Longint
   Webapp             // pWebApp
   ;


type
   TDSPAppHandler = class(TObject)
   public
      procedure DSPAppUpdate(Sender: TObject);
      procedure DSPAppExecute(Sender: TObject);
      procedure DSPAppNewSession(Sender:TObject;Session:Cardinal;const Command:String);
      procedure DSPAppExecDone(Sender: TObject);
      procedure DSPAppEventMacro(Sender: TwhRespondingApp; const aMacro, aParams, aID: String);
      procedure DSPAppError(Sender: TObject; E: Exception; var Handled, ReDoPage: Boolean);
      procedure DSPAppBadBrowser(Sender: TwhRespondingApp; var bContinue: Boolean);
      procedure DSPAppBadIP(Sender: TwhRespondingApp; var bContinue:Boolean);
      procedure DSPMacrosUpdate;
   end;

procedure LogInfo(const S: string);
function OnHrefNetwork:boolean;

var
   DSPAppHandler: TDSPAppHandler = nil;

implementation

uses
   whMacroAffixes,
   DSP_dmRubicon,             // DSPdm
   Weblist,                   // TwhList
   whsample_EvtHandlers,      // Request component is here
   ucPos,                     // posci
   webInfoU,                  // CentralInfo
   ucvers                     // access file version information
   ;


var
   iLogInfo: shortint = -1;
{-}
procedure LogInfo(const S: string);
begin
   If iLogInfo=0 then Exit;
   If iLogInfo=-1 then
      If HaveParam('/LogInfo') then iLogInfo:=1
      Else
         begin
            iLogInfo:=0;
            Exit;
         end;
   AppendToLog(DatedFileName(ExtractFilePath(ParamStr(0))+'DSP.info.log'), S);
end;

{-}
function OnHrefNetwork:boolean;
const
   cHrefNW='208.201.252.0';  // network
   cHrefNM='255.255.255.192';  // netmask
begin
   Result := (IP2Longint(pWebApp.Request.RemoteAddress) and IP2Longint(cHrefNM)) = IP2Longint(cHrefNW);
end;

{-}
procedure TDSPAppHandler.DSPAppUpdate(Sender: TObject);
var
   i,j:integer;
   a0,a1,a2:string;
begin
   Inherited;

   LogInfo('DSPAppUpdate');
   LogInfo('ZM Default Map Context is ' + pWebApp.ZMDefaultMapContext);

   {Note: Custom changes to chunks, macros, settings for DSP }
   With pWebApp do
      begin  // d:\delphi\30\source\vcl\classes.pas
         EventMacros.Text := 'AppendToLog=ok';
         i:=Tekeros.IndexOfName('chSearchGroupItems');
         If i>-1 then
            begin
               //<option value=All>All Categories
               a0:='';
               If assigned(DSPdm) then
                  begin
                     If assigned(DSPdm.GroupNameList) then
                        begin
                           With DSPdm.GroupNameList do
                              begin
                                 For j:=0 to pred(count) do
                                    begin
                                       splitstring(strings[j],'=',a1,a2);
                                       a0:=a0+MacroStart+'<option value='+a1+'>'+a2+sLineBreak;
                                    end;
                              end;
                           TwhList(Tekeros.objects[i]).text:=a0;
                        end;
                  end
               Else
                  begin
                     LogInfo('WARNING! DSPdm is nil');
                  end;
            end;

         If assigned(DSPdm) then
            begin
               DSPdm.ImgSrc:=Macros.Values['mcImgSrc'];
               DSPdm.Timeout:=StrToIntDef(Macros.Values['Timeout'],cTimeout);

               DSPdm.WordsDatabasename:=AppSetting['WordsTablePath'];
               DSPdm.FilesDatabasename:=AppSetting['DatabaseAlias'];
            end;
      end;
   DSPMacrosUpdate;
end;

procedure TDSPAppHandler.DSPMacrosUpdate;
begin
   If (NOT HaveParam('/NoDatabase')) and Assigned(pWebApp) and (pWebApp.IsUpdated) then
      With pWebApp do
         begin
            If Assigned(dspdm) then
               begin
                  Macros.Values['mcNrAsOf']:=dspdm.FilesAsOf;
                  Macros.Values['mcNrFiles']:=format('%.0f',[0.0+dspdm.FilesCount]);
               end;
            Macros.Values['mcAppVersion'] := GetVersionDigits(False);
         end;
end;

var fNewSession: boolean;
{-}
procedure TDSPAppHandler.DSPAppExecute(Sender: TObject);
var a1,a2:string;
begin
   //  with pWebApp, Request do
   //    LogInfo('DSPAppExecute: ' +
   //           QueryString +
   //           ' PageID='+PageID +
   //           ' UserAgent=' + TWhBrowserInfo(WebBrowserInfo).UserAgentHash +
   //           ' IP# ' + RemoteAddress +
   //           ' Session ' + SessionID);

   With pWebApp do
      begin
         //if StringVar['DSPURLPrefix']='' then
         //  StringVar['DSPURLPrefix'] := cDSP;
         a1:=Request.Referer;
         If fNewSession then
            begin
               If a1='' then a1:='a bookmark';
               StringVar['Referer']:=a1;
            end;
         {if AnsiSameText(PageID,'getlost') then exit;}

         If not assigned(DSPdm) or DSPdm.IsValidReferer(a1,a2) or OnHrefNetwork or (posCI('RefererOK',Command)>0) then
            If fNewSession and (a2<>'') then StringVar['DSPURLPrefix']:=a2
            Else
      end;
end;

{-}
function ServerDomain(const HostName:String):String;
//helper function to extract the domain from a url..
//does not cope with, for example, machine.domain.ac.jp
var a1:string;
begin
   //determine the domain
   SplitRight(HostName,'.',Result,a1);
   // www.domain.net -> www.domain & net
   // domain.net -> domain & net
   If pos(Result,'.')>0 then SplitRight(Result,'.',a1,Result);
   // www.domain -> Result=domain & a1=www
end; {-}

{-}
procedure TDSPAppHandler.DSPAppNewSession(Sender:TObject;Session:Cardinal;const Command:String);
begin
   Inherited;
   If Session=0 then Exit;
   With pWebApp, Request do
      LogInfo('DSPAppNewSession: ' +
            QueryString +
            ' UserAgent=' + UserAgent +
            ' IP# ' + RemoteAddress +
            ' Session ' + SessionID);
   With pWebApp, Request do
      begin
         If (pos(SessionID,QueryString)>0) and (posci(ServerDomain(Host)+'.',Referer)=0) then
            begin
               LogInfo('Would RejectSession. '+QueryString+' from referer '+Referer + ' and IP# '+RemoteAddress);
               //RejectSession;
            end;
      end;

   fNewSession := True;
   With pWebApp do
      begin
         StringVar['DSPURLPrefix'] := cDSP;
         BoolVar['bDebug'] := HaveParam('Debug');

         AppendToLog(DatedFileName(AppSetting['RefererLog'])
               ,Request.RemoteAddress
               +','+SessionID
               +','+AddToString(pageid,command,':')
               +','+pWebApp.Request.ServerVariables.Values['Referer']
         );
         //
         (*if Session.LoadFromDisk then
         begin
            StringVar['liAppMsg']:=Macros.Values['mcAppReloaded'];
            BoolVar['bLogin']:=False;
            also check time-last activated and reject (bounce to hub) if expired
            //also add check to prompt for a password
         end;*)
      end;
   pWebApp.SendMacro('chNewSession');
   //LogInfo('Completed DSPAppNewSession for #'+SessionID);
end;

{-}
procedure TDSPAppHandler.DSPAppExecDone(Sender: TObject);
begin
   fNewSession:=False;
end;

{-}
procedure TDSPAppHandler.DSPAppEventMacro(Sender: TwhRespondingApp; const aMacro, aParams, aID: String);
var a1,a2:string;
begin
   a1:=uppercase(aMacro);
   With pWebApp do //uclogfil
      If a1='APPENDTOLOG' then
         begin//
            splitstring(aParams,'|',a1,a2);
            AppendToLog(DatedFileName(compareTo(a1))
               ,Request.RemoteAddress
               +','+SessionID
               +','+AddToString(pageid,command,':')  //ucstring
               +','+compareTo(a2)
            );
         end;
end;

{-}
procedure TDSPAppHandler.DSPAppError(Sender: TObject; E: Exception; var Handled, ReDoPage: Boolean);
begin
   With pWebApp do //uclogfil
      AppendToLog(DatedFileName(AppSetting['ErrorLog'])
         ,Request.RemoteAddress
         +','+SessionID
         +','+AddToString(pageid,command,':')  //ucstring
         +','+e.classname
         +','+e.message
      );
end;

procedure TDSPAppHandler.DSPAppBadBrowser(Sender: TwhRespondingApp; var bContinue: Boolean);
begin
   Inherited;
   bContinue:=True;

   With Sender do
      begin
         //PageID:=AppDefault[cPageIDBadBrowser];
         //RejectSession;
         With pWebApp, Request do
            LogInfo('DSPAppBadBrowser: ' +
               QueryString +
               ' UserAgent=' + UserAgent +
               ' IP# ' + RemoteAddress +
               ' Session ' + SessionID);
      end;
end;

procedure TDSPAppHandler.DSPAppBadIP(Sender: TwhRespondingApp; var bContinue:Boolean);
begin
   Inherited;
   bContinue:= true;
   With Sender, Request do
      begin
         If posci(ServerDomain(Host)+'.',Referer)>0 then Exit;

         //PageID:=AppDefault[cPageIDBadIP];
         //RejectSession;
         With pWebApp, Request do
            LogInfo('DSPAppBadIP: '+
               QueryString +
               ' UserAgent=' + UserAgent +
               ' IP# ' + RemoteAddress +
               ' Session ' + SessionID);
      end;
end;

initialization
   DSPAppHandler := nil; // TDSPAppHandler.create;

finalization
   FreeAndNil(DSPApphandler);

end.
