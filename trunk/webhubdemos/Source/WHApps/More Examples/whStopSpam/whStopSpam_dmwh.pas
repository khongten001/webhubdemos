unit whStopSpam_dmwh;

interface

uses
  SysUtils, Classes,
  updateOK, tpAction, 
  webSOAPRegistry, webLink, webTypes;

type
  // sample code 1 - execute method is not published

  IWebMailtoObfuscate = interface(IwhWebAction)
    // hint: press Ctrl+Shift+G at Delphi IDE to generate GUID
    ['{5ED74DF5-6E8E-4593-A89A-606D5EEF9AE1}']
    function MailtoStrObfuscate(const input:string;
      const MakeResultReadyToCopyFromWeb: Boolean): string; stdcall;
    function TestStringTransfer(const MakeStringThisLong: Integer): string;
      stdcall;
  end;

type
  TWebMailtoObfuscate = class(TwhWebAction, IWebMailtoObfuscate)
  public
    function MailtoStrObfuscate(const input:string;
      const MakeResultReadyToCopyFromWeb: Boolean): string; stdcall;
    function TestStringTransfer(const MakeStringThisLong: Integer): string;
      stdcall;
    procedure Execute; override;
  end;

type
  TDMforHTUN = class(TDataModule)
    WebActionNoSaveState1: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure WebActionNoSaveState1Execute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    waSlowSpam: TWebMailtoObfuscate;
    procedure Init;
  end;

var
  DMforHTUN: TDMforHTUN;

implementation

{$R *.dfm}

uses
  ucString,
  webApp, htWebApp;

{ TDMforHTUN }

procedure TDMforHTUN.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

procedure TDMforHTUN.Init;

  procedure CreateWebAction(var Instance; AClass: TComponentClass;
    const AName: string);
  begin
    {See also: http://demos.href.com/scripts/runisa.dll/HTUN/html}
    TComponent(Instance) := AClass.Create(Self);
    with TComponent(Instance) as TwhWebAction do
    begin
      Name := AName;
      DirectCallOk := True;
      SOAPCallOk := True;  // required to allow access via SOAP 
      Refresh;
    end;
  end;

begin
  // reserved for code that should run once, after AppID set
  if FlagInitDone then Exit;

  CreateWebAction(waSlowSpam, TWebMailtoObfuscate, 'waSlowSpam');
  waSlowSpam.OnExecute := WebActionNoSaveState1Execute;

  if Assigned(pWebApp) and pWebApp.IsUpdated then
  begin
    // good idea to refresh all web actions in this datamodule, once
    RefreshWebActions(Self);
    // helpful to know that WebAppUpdate will be called whenever the
    // WebHub app is refreshed.
    AddAppUpdateHandler(WebAppUpdate);
    FlagInitDone := True;
  end;
  
end;

procedure TDMforHTUN.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

procedure TDMforHTUN.WebActionNoSaveState1Execute(Sender: TObject);
var
  phrase,addAmpersand: String;
begin
  inherited;
  with TWebMailtoObfuscate(Sender) do
  begin
    // usage waUnicode|phrase[|true]
    SplitString(HtmlParam,'|',phrase,addAmpersand);
    phrase := WebApp.Expand(phrase);
    Response.Send(MailtoStrObfuscate(phrase,StrToBool(addAmpersand)));
  end;
end;

//------------------------------------------------------------------------------

function TWebMailtoObfuscate.MailtoStrObfuscate(const input:string;
  const MakeResultReadyToCopyFromWeb: Boolean):string;
var
  i: integer;
  c: char;
  amp: string;
begin
  inherited;
  Result := '';
  if MakeResultReadyToCopyFromWeb then
    amp := '&amp;'
  else
    amp := '&';
  for i:=1 to length(input) do
  begin
    c := input[i];
    result := result + amp + '#' + IntToStr(Ord(c)) + ';';
  end;
end;

function TWebMailtoObfuscate.TestStringTransfer(
  const MakeStringThisLong: Integer): string;
var
  x: Integer;
begin
  Result := 'hello' + sLineBreak + '//world' + sLineBreak;
  while Length(Result) < MakeStringThisLong do
  begin
    x := 40 + Random(50);  // range 40 to 90
    Result := Result + Chr(x);
  end;
end;

procedure TWebMailtoObfuscate.Execute;
begin
  inherited;
  // !!! HtmlParam is blank here.
end;

initialization
  RegisterIwhWebAction(TypeInfo(IWebMailtoObfuscate));
  
end.
