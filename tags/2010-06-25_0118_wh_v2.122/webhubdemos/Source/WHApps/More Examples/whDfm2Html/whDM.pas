unit whDM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ApiBuilt, ApiCall, WebCall, CGiVarS, APiStat, WebBase, WebCore, WebSend,
  WebApp, htWebApp, WebTypes, WebVars, HtmlBase, HtmlCore, HtmlSend,
  WebInfoU, CGiServ, WebServ, IniLink,   UpdateOk, tpAction,
  WebLink, f2h, WebCycle;

type
  TwhDataModule = class(TDataModule)
    app: TwhApplication;
    CentralInfo: TwhCentralInfo;
    waF2H: TwhWebActionEx;
    waRESETNOW: TwhWebActionEx;
    procedure waF2HExecute(Sender: TObject);
    procedure appNewSession(Sender: TObject; Session: Cardinal;
      const Command: String);
    procedure appUpdate(Sender: TObject);
    procedure waRESETNOWExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init;
  end;

   function rdoBF2BF : THBrowserFamily;

var
  whDataModule: TwhDataModule;

const
   RDO_BF = 'rdoBF'; // browsers radio buttons name
   USER_BF = 'userBF';

implementation

{$R *.DFM}

uses
  ucString, typinfo, sample, stdCtrls;             // f2h.txt

function rdoBF2BF : THBrowserFamily;
var
   i : integer;
begin
   i := GetEnumValue(TypeInfo(THBrowserFamily), pWebApp.StringVar[RDO_BF]);
   if i < 0 then
      result := bfDefault
   else
     result := THBrowserFamily(i);
end;

function BF2RadioBFName(bf : THBrowserFamily) : string;
begin
   result := GetEnumName(TypeInfo(THBrowserFamily), integer(bf));
end;

procedure setBrowserRadioFromBF(bf : THBrowserFamily);
begin
   with pWebApp do
      StringVar[RDO_BF] := BF2RadioBFName(bf);
end;

procedure resetData;
var
   f2hObject: TwhForm2HTML;
begin
   if not assigned(sampleFrm) then exit;
   f2hObject:=sampleFrm.WHForm2HTML1;
   with f2hObject, pWebApp do begin
      WHChunkDeclaration := False;
      WHChunkOutputScope := cosReset;
      // Initialize the browsers radio buttons to the user's actual browser
      f2hObject.CgiUserAgent:= pWebApp.Request.UserAgent;
      setBrowserRadioFromBF(BrowserFamily);
      StringVar[USER_BF] := BF2RadioBFName(BrowserFamily);
      StringVar['lboBorder'] := 'Neither';
      StringVar['cboBGColor'] := '[None]';
      //
//      Response.Send(WHChunk); Ann moved and commented this out. 6/23/98.
   end;
end;

procedure TwhDataModule.Init;
begin
  RefreshWebActions(Self);
end;

procedure TwhDataModule.appNewSession(Sender: TObject;
  Session: Cardinal; const Command: String);
begin
   resetData;
end;

//

function nsWarningIsNeeded : Boolean;
begin
   with pWebApp do begin
      result := not BoolVar['bWarned'];
      if result then
         result := isIn(pWebApp.StringVar[USER_BF],'bfNS3,bfNS4', ',');
      if result then
         result := CompareText(StringVar['lboBorder'], 'Neither') <> 0;
      if result then
         BoolVar['bWarned']:=True;
   end;
end;

procedure TwhDataModule.waF2HExecute(Sender: TObject);
var
  a1:string;
  f2hObject: TwhForm2HTML;
begin
   with TwhWebActionEx(Sender) do begin
      a1:=lowercase(HTMLParam);
      if a1 = 'sample' then
         begin
            if nsWarningIsNeeded then begin
               pWebApp.pageid := 'nsWarning';
               abort;
            end;
            f2hObject:=sampleFrm.WHForm2HTML1;
            with f2hObject,HMainContainer do begin
               bgColor:='[Same]';
               Attributes['ShowCaption'].BooleanValue:= True;
            end;
         end
      else begin
         Response.Send('Invalid option');
         exit;
      end;
      //
      f2hObject.CgiUserAgent:= WebApp.Request.UserAgent;
      with f2hObject do begin
         WHChunkDeclaration := False;
         WHChunkOutputScope := cosForm;
         Response.Send(WHChunk);
      end;
   end;
end;
{}
//

procedure TwhDataModule.appUpdate(Sender: TObject);
var
  a1:string;
begin
  with TwhAppBase(Sender) do begin
    a1:=AppSetting['ScreenShotJPEG'];
    if a1='' then begin
      a1:=ExtractFilePath(pWebApp.ConfigFilespec) + 'original.jpg';
      AppSetting['ScreenShotJPEG']:=a1;
      end;
    end;
end;

procedure TwhDataModule.waRESETNOWExecute(Sender: TObject);
begin
   resetData;
end;

end.
