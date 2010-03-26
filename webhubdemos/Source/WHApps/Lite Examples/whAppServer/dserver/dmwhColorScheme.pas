unit dmwhColorScheme;

interface

uses
  SysUtils, Classes, updateOK, tpAction, webTypes, webLink;

type
  TDataModuleColorScheme = class(TDataModule)
    waColorScheme: TwhWebAction;
    procedure waColorSchemeUpdate(Sender: TObject);
    procedure waColorSchemeExecute(Sender: TObject);
  private
    { Private declarations }
    FColorSchemeName: string;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    procedure Init;
  end;

var
  DataModuleColorScheme: TDataModuleColorScheme;

implementation

{$R *.dfm}

uses
  ucLogFil, ucString,
  htWebApp, webApp;

{ TDataModuleColorScheme }

procedure TDataModuleColorScheme.Init;
begin
  FColorSchemeName := '';

  if Assigned(pWebApp) then
  begin
    RefreshWebActions(Self);
    AddAppUpdateHandler(WebAppUpdate);
  end;
end;

procedure TDataModuleColorScheme.WebAppUpdate(Sender: TObject);
begin
  waColorScheme.Refresh;
end;

procedure TDataModuleColorScheme.waColorSchemeUpdate(Sender: TObject);
var
  ColorList: TStringList;
  I: Integer;
  AMacroName, AColor: string;
begin
  FColorSchemeName := TwhWebAction(Sender).StringFromConfig('FullColor',
    '0E61Tw0w0K-dg');

  ColorList := nil;
  try
    ColorList := TStringList.Create;
    ColorList.Text := pWebApp.Tekero['drColorScheme' + FColorSchemeName];
    for I := 0 to pred(ColorList.Count) do
    begin
      if Trim(ColorList[i]) = '' then Continue;
      if Copy(ColorList[i], 1, 1) = '.' then
      begin
        //HREFTestLog('info', self.Name, ColorList[i]);
        // .primary-1 { background-color: #FF8B00 }
        SplitString(ColorList[i], ' { background-color: #', AMacroName, AColor);
        AMacroName := 'mc' + Copy(AMacroName, 2, MaxInt);
        AColor := LeftOfS(' ', AColor);
        pWebApp.Macros.Add(AMacroName + '=' + AColor);
      end;
    end;
  finally
    FreeAndNil(ColorList);
  end;
end;

procedure TDataModuleColorScheme.waColorSchemeExecute(Sender: TObject);
var
  Action: string;
begin
  Action := TwhWebAction(Sender).HtmlParam;
  if IsEqual(Action, 'scheme') then
    pWebApp.SendStringImm(FColorSchemeName);
end;

end.
