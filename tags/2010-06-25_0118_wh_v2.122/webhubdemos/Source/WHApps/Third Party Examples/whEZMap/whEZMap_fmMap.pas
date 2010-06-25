unit whEZMap_fmMap;

{ This file was created using the WebHub Wizard, and selecting appPanel as
  a starting point. The Save and Load procedures were removed, and the Init
  was customized to define the data location for the GIS component. }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UTPANFRM, ExtCtrls, StdCtrls, UpdateOk, tpAction, IniLink,
    Toolbar, Restorer, EzBaseGIS, EzBasicCtrls, EzCtrls, WebEZMap,
  Buttons;

type
  TfmMap = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    Gis1: TEzGIS;
    DrawBox1: TEzDrawBox;
    btnGISVersion: TtpToolButton;
    Panel1: TPanel;
    Label1: TLabel;
    procedure btnGISVersionClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
  published
    WebEZMap1: TWebEZMap;         // declared this way so that TWebEZMap component does not have to be installed in Delphi
    WebEZMap2: TWebEZMap;
    WebEZMap3: TWebEZMap;
    end;

var
  fmMap: TfmMap;

implementation

{$R *.DFM}

uses ucString, uCode, webapp;

procedure TfmMap.FormCreate(Sender: TObject);
begin
  inherited;
  { Anyone who wants to install the TWebEZMap component is welcome to do so,
    and would then be able to skip steps done here in FormCreate and FormDestroy
    events.  The reason for showing the code this way is to demonstrate how to
    use custom WebHub action components without registering them on the palette,
    which can be very handy for components that one doesn't use all the time,
    and when changing between versions of Delphi. }
  WebEZMap1 := TWebEZMap.Create(fmMap);
  WebEZMap1.Name := 'WebEZMap1';
  WebEZMap2 := TWebEZMap.Create(fmMap);
  WebEZMap2.Name := 'WebEZMap2';
  WebEZMap3 := TWebEZMap.Create(fmMap);
  WebEZMap3.Name := 'WebEZMap3';

  WebEZMap1.CurrentAction := caPickEntity;
  WebEZMap2.CurrentAction := caZoomIn;
  WebEZMap3.CurrentAction := caZoomOut;
end;

function TfmMap.Init:Boolean;
var
  i: Integer;
begin
  Result:= inherited Init;
  if not result then
    exit;
  Gis1.Filename:= DefaultsTo(pWebApp.AppSetting['EZMapData'],'Data\Animate.ezm');
  if FileExists(Gis1.Filename) then
  begin
    Gis1.Open;
    Label1.Caption := Gis1.Filename;
  end
  else
  begin
    Label1.Caption := 'File not found: ' + Gis1.Filename;
    {webmaster will need to fix reference in INI file, then File|Exit, and
     restart to fix this (as currently programmed)}
    Exit;
  end;

  for i:=0 to pred(fmMap.ComponentCount) do
  begin
    if Components[i] is TWebEZMap then
    with TWebEZMap(Components[i]) do
    begin
      DirectCallOK := True;
      DrawBox := DrawBox1;
      { Note, these are the defaults as used on demos.href.com. The locations
        are loaded from the HTMP.ini file through the use of AppSetting below.
        FilePath := 'd:\Projects\WebHubDemos\Live\WebRoot\demos\whEZMap\';
        FileURL := 'http://localhost:8000/webhub/demos/whEZMap/'; }
      FilePath := DefaultsTo(pWebApp.AppSetting['EZMapFilePath'],
        'C:\Inetpub\wwwroot\webhub\');
      FileURL := DefaultsTo(pWebApp.AppSetting['EZMapFileURL'],
        'http://localhost:8000/webhub/');
      Refresh;
    end;
  end;
end;

procedure TfmMap.FormDestroy(Sender: TObject);
begin
  inherited;
  {See comment in FormCreate method.}
  WebEZMap1.Free;
  WebEZMap2.Free;
  WebEZMap3.Free;
  WebEZMap1 := nil;
  WebEZMap2 := nil;
  WebEZMap3 := nil;
end;

procedure TfmMap.btnGISVersionClick(Sender: TObject);
begin
  inherited;
  {This is completely unnecessary. It seemed a good idea to demonstrate one
   possible use for the toolbar on the standard panel.}
  ShowMessage(GIS1.About);
end;

end.
