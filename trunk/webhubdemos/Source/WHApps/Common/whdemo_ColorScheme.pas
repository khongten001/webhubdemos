unit whdemo_ColorScheme;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2008-2014 HREF Tools Corp.  All Rights Reserved Worldwide. * }
{ *                                                                          * }
{ * This source code file is part of WebHub v3.1x.  Please obtain a WebHub   * }
{ * development license from HREF Tools Corp. before using this file, and    * }
{ * refer friends and colleagues to http://www.href.com/webhub. Thanks!      * }
{ ---------------------------------------------------------------------------- }

//  Original Author: Ann Lynnworth

interface

uses
  SysUtils, Classes,
  updateOK, tpAction,
  webTypes, webLink;

type
  TDataModuleColorScheme = class(TDataModule)
    waColorScheme: TwhWebAction;
    procedure waColorSchemeUpdate(Sender: TObject);
    procedure waColorSchemeExecute(Sender: TObject);
  private
    { Private declarations }
    FColorSchemeName: string;
    function SchemeToColor(const InColorSchemeName, InColorPosition: string)
      : string;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    procedure Init;
    function TestRawVMR: string;
  end;

var
  DataModuleColorScheme: TDataModuleColorScheme;

const
  cGuestKolori = '_guestkolori';  // name of stringvar storing personal override

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

function TDataModuleColorScheme.SchemeToColor(const InColorSchemeName,
  InColorPosition: string): string;
var
  ColorList: TStringList;
  I: Integer;
  AMacroName, AColor: string;
begin
  Result := '';
  if InColorSchemeName = '' then
    Exit;

  ColorList := nil;
  try
    ColorList := TStringList.Create;
    ColorList.Text := pWebApp.Tekero['drColorScheme' + InColorSchemeName];
    for I := 0 to pred(ColorList.Count) do
    begin
      if Trim(ColorList[i]) = '' then Continue;
      if Copy(ColorList[i], 1, 1) = '.' then
      begin
        //HREFTestLog('info', self.Name, ColorList[i]);
        // .primary-1 { background-color: #FF8B00 }
        SplitString(ColorList[i], ' { background-color: #', AMacroName, AColor);
        if Copy(AMacroName, 2, MaxInt) = InColorPosition then
        begin
          Result := LeftOfS(' ', AColor);
          break;
        end;
      end;
    end;
  finally
    FreeAndNil(ColorList);
  end;
end;

function TDataModuleColorScheme.TestRawVMR: string;
const
  M = '/';
begin
  {for tech support issue on 29-Sep-2010}
  {the result should be something like 'scripts/runisa.dll' }
  Result := pWebApp.Request.VirtualPath + M + pWebApp.Request.Runner;
end;

procedure TDataModuleColorScheme.waColorSchemeExecute(Sender: TObject);
const
  cUsage = 'usage: waColorScheme.execute|[scheme|primary-1]';
var
  Action: string;
  AColor: string;
  a1, a2: string;
  Kolori: string;
begin
  Action := TwhWebAction(Sender).HtmlParam;
  Kolori := pWebApp.StringVar[cGuestKolori];
  if IsEqual(Action, 'scheme') then
  begin
    if Kolori <> '' then
      pWebApp.SendStringImm(Kolori)
    else
      pWebApp.SendStringImm(FColorSchemeName);
  end
  else
  if Kolori <> '' then
  begin
    AColor := '';
    if SplitString(Action, '-', a1, a2) then
      AColor := SchemeToColor(Kolori, Action);
    if AColor <> '' then
      pWebApp.SendStringImm(AColor)
    else
      pWebApp.Debug.AddPageError(cUsage);
  end
  else
  begin
    pWebApp.SendMacro('mc' + Action);
  end;
end;

end.
