unit dmwhAnsiUmlauts;

interface

uses
  SysUtils, Classes, updateOK, tpAction, webTypes, webLink;

type
  TDataModule1 = class(TDataModule)
    waUUmlauts: TwhWebAction;
    procedure waUUmlautsExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init;
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

uses
  ucAnsiUtil,
  webApp;

procedure TDataModule1.Init;
begin
  RefreshWebActions(Self);
end;

procedure TDataModule1.waUUmlautsExecute(Sender: TObject);
begin
  pWebApp.SendMacro('drmatchtest');
  pWebApp.SendString('<hr/>');
  pWebApp.SendStringA('single u umlaut symbol: ü<br/>');

  {Test these SendMacro examples in D07 and D14.
   Right now they work in D14, not D07. 21-Jun-2010 08:58 gmt}
  pWebApp.Response.Send('Should now show match result of 4: ');
  pWebApp.SendMacro('MATCH|a=b|2:üü||4:üüüü');
  pWebApp.SendString('<br/>');
  pWebApp.Response.Send('Should now show match result of 2: ');
  pWebApp.SendMacro('NOMATCH|a=b|2:üü||4:üüüü');
end;

end.
