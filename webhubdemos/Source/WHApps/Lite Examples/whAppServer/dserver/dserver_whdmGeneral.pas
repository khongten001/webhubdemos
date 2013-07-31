unit dserver_whdmGeneral;

interface

uses
  SysUtils, Classes, updateOK, tpAction, webTypes, webLink, webCall;

type
  TdmwhGeneral = class(TDataModule)
    waMakeBadVars: TwhWebAction;
    procedure waMakeBadVarsExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
    procedure LoadProjectSyntax(Sender: TObject);
    procedure LoadProjectLingvo(Sender: TObject);
    procedure ControlPageCalcTime(Sender: TwhConnection;
      var ExecutionAverageMS: Integer);
  end;

var
  dmwhGeneral: TdmwhGeneral;

implementation

{$R *.dfm}

uses
  Math,
  ucString, ucPos,
  webApp, htmConst, htWebApp;

procedure TdmwhGeneral.ControlPageCalcTime(Sender: TwhConnection;
  var ExecutionAverageMS: Integer);
begin
  {prevent testing of extraordinarily slow web pages from blocking further
  requests}
  ExecutionAverageMS := Math.Max(ExecutionAverageMS, 200);
end;

function TdmwhGeneral.Init(out ErrorText: string): Boolean;
begin
  ErrorText := '';
  Result := False;
  if assigned(pWebApp) then
  begin
    pWebApp.OnLoadProjectSyntax := dmwhGeneral.LoadProjectSyntax;
    pWebApp.OnLoadProjectLingvo := dmwhGeneral.LoadProjectLingvo;
    if Assigned(pConnection) then
    begin
      pConnection.OnPageCalcTime := ControlPageCalcTime;
      Result := True;
    end
    else
      ErrorText := 'nil pConnection';
  end;
end;

procedure TdmwhGeneral.LoadProjectSyntax(Sender: TObject);
begin
  with TwhAppBase(Sender) do
    ProjectSyntax := cSyntaxStage;  {19-May-2004}
end;

procedure TdmwhGeneral.waMakeBadVarsExecute(Sender: TObject);
var
  dd: Double;
  x: Integer;
  s1: string;
begin
  if pWebApp.Session.StringVars.Count < 20 then
  begin
    x := Random(999);
    dd := 1000 * 1000 / x;
    pWebApp.StringVar['data' + IntToStr(x)] := FloatToStr(dd);
  end;
  s1 := pWebApp.StringVar['inVarName'];
  if s1 = '' then
  begin
    pWebApp.StringVar['shtml'] := '<table>' + #10 + '<tr><td>abc</td></tr>' +
      #10 + '</table>';
    pWebApp.StringVar['withcrlf'] := '<table>' + sLineBreak +
      '<tr><td>def</td></tr>' +
      sLineBreak + '</table>';
    pWebApp.StringVar['hexer'] := '1.0000' +
      #12 +  // $0C            }
      #251 + // $FB            } invalid string - becomes 0C C3 BB 31 20 20
      #49 +  // $29            }
      #32#32; // $20 $20;      }
  end
  else
  begin
    pWebApp.SendStringImm('<p>The value of StringVar[<b>' + s1 + '</b>] is ' +
      pWebApp.StringVar[s1] + '.</p>');
  end;
  pWebApp.SendStringImm('<p>Now there are ' +
    IntToStr(pWebApp.Session.StringVars.Count) + ' StringVars.</p>');

end;

procedure TdmwhGeneral.LoadProjectLingvo(Sender: TObject);
begin
  with TwhAppBase(Sender) do
    ProjectLingvo := 'eng';     {08-May-2004}
end;


end.
