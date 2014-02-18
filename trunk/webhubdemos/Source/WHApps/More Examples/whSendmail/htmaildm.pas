unit htmaildm;

interface
{$I hrefdefines.inc}
  {$IF Defined(Delphi17UP)}
  {$DEFINE INDYSMTP}
  {$ELSE}
  {$UNDEF INDYSMTP}
  {$IFEND}

uses
  Windows, Messages, SysUtils, Classes,
  updateOk, tpAction,
  webTypes,   webLink, HtmlBase,
  HtmlCore, HtmlSend, WebBase, WebCore, WebSend, WebApp;

type
  TFormLetterDM = class(TDataModule)
    WebFormLetter: TwhWebActionEx;
    WebAppOutputFormLtr: TwhResponse;
    procedure WebFormLetterExecute(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure RedirectExecute(Sender: TObject);
  public
    { Public declarations }
    waRedirect301: TwhWebAction;
    procedure Init;
  end;

var
  FormLetterDM: TFormLetterDM;

implementation

uses
  ucCodeSiteInterface, ucLogFil,
  webPrologue, whMail, whpanel_Mail;

{$R *.DFM}

{----------------------------------------------------------------------------------------}
{----------------------------------------------------------------------------------------}
{ The TwhMail component is intentionally NOT a WebAction component,
  so you can not invoke it by name.  But we can wrap it in a WebAction
  component as shown here.
}
procedure TFormLetterDM.DataModuleCreate(Sender: TObject);
begin
  waRedirect301 := TwhWebAction.Create(Self);
  waRedirect301.Name := 'waRedirect301';
  waRedirect301.OnExecute := RedirectExecute;
end;

procedure TFormLetterDM.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(waRedirect301);
end;

procedure TFormLetterDM.Init;
begin
  WebAppOutputFormLtr.GUI.SetShowResponse(outQuick);
  RefreshWebActions(Self);
end;

procedure TFormLetterDM.RedirectExecute(Sender: TObject);
var
  TargetURL: string;
begin
  TargetURL := TwhWebAction(Sender).HtmlParam;
  pWebApp.Response.SendRedirection301(TargetURL);
end;

procedure TFormLetterDM.WebFormLetterExecute(Sender: TObject);
const
  cFn = 'WebFormLetterExecute';
var
  FileContentUnexpanded: string;
  FileContentExpanded: string;
begin
  CSEnterMethod(Self, cFn);

  FileContentUnexpanded := StringLoadFromFile
    (pWebApp.AppSetting['FormLetterFile']);
  LogToCodeSiteKeepCRLF('FileContentUnexpanded', FileContentUnexpanded);

  if FileContentUnexpanded <> '' then
  begin
    FileContentExpanded := pWebApp.Expand(FileContentUnexpanded);

    if FileContentExpanded <> '' then
    begin

      with DataModuleWHMail do
      begin
{$IFDEF INDYSMTP}
        WebMailForm.IndyMessage.From.Address := pWebApp.StringVar['MsgTo'];
        WebMailForm.IndyMessage.Recipients.Clear;
        WebMailForm.IndyMessage.Recipients.EMailAddresses :=
          pWebApp.StringVar['MsgTo'];
        WebMailForm.IndyMessage.Subject := pWebApp.StringVar['Subject'];
        WebMailForm.IndyMessage.Body.Text := FileContentExpanded;
{$ELSE}
        WebMailForm.WebMail.Sender.EMail := pWebApp.StringVar['MsgTo'];
        WebMailForm.WebMail.Mailto.Text := pWebApp.StringVar['MsgTo'];
        WebMailForm.WebMail.Subject := pWebApp.StringVar['Subject'];
        WebMailForm.WebMail.Lines.Text := FileContentExpanded;
{$ENDIF}

{$IFDEF INDYSMTP}
      WebMailForm.IndySMTP.Connect;
      WebMailForm.IndySMTP.Send(WebMailForm.IndyMessage);
      WebMailForm.IndySMTP.Disconnect;
{$ELSE}
      WebMailForm.WebMail.Execute;
{$ENDIF}
      end;
    end;
  end;
  CSExitMethod(Self, cFn);
end;

end.
