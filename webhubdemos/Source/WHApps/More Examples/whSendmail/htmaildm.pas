unit htmaildm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UpdateOk, WebTypes,   WebLink, HtmlBase,
  HtmlCore, HtmlSend, CGiVarS, APiStat, WebBase, WebCore, WebSend, WebApp,
  tpAction;

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
  webPrologue, whMail, whpanel_Mail, webMail;

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
var
  app: TwhAppBase;
  sav: TwhResponse;
begin
  //Sender is a TwhWebActionEx component.
  with WebAppOutputFormLtr do
  begin
    {connect this output component to the app and vice versa}
    app:=TwhWebActionEx(Sender).WebApp;
    sav:=app.Response;

    WebApp:=app;
    app.Response:=WebAppOutputFormLtr;

    app.Response.SetContentType(ProSkip, '');  {skip the HTTP PrologueMode!}
    ResponseFilespec := '';
    Open;

    {SendFile will expand macros while it sends the data, because
     it is called from a TwhResponse rather than TwhResponseSimple component.}
    SendFile(app.AppSetting['FormLetterFile']);  {get filename from configuration file}

    with DataModuleWHMail.WebMail do
    begin
      Sender.EMail:=app.StringVar['MsgTo'];
      Mailto.text:=app.StringVar['MsgTo'];
      Subject:=app.StringVar['Subject'];
      {stream.text contains the output document from SendFile above.
       We want that to become the e-mail message through the .Lines property.}
      Lines.Text := string(Stream.Text);
      end;
    Close;  {close temp output stream}
    DataModuleWHMail.WebMail.Execute;

    {reconnect the app to the main output component}
    app.Response:=sav;
  end;
end;

end.
