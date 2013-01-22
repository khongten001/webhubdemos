unit DMWHGoogleSitemap;

interface

uses
  SysUtils, Classes, 
  {$I xe_actnlist}
  updateOK, tpAction, webTypes, webLink;

type
  TDataModuleGoogleSitemap = class(TDataModule)
    ActionList1: TActionList;
    actGoogleSitemap: TAction;
    actKeywordReport: TAction;
    waGoogleKeywordReport: TwhWebAction;
    procedure actGoogleSitemapExecute(Sender: TObject);
    procedure actKeywordReportExecute(Sender: TObject);
    procedure waGoogleKeywordReportExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModuleGoogleSitemap: TDataModuleGoogleSitemap;

implementation

{$R *.dfm}

uses
  Forms,
  NativeXml,
  ucWinAPI, ucDlgs, ucString,
  whMacroAffixes, webApp, webPHub, webInfoU;

procedure TDataModuleGoogleSitemap.actGoogleSitemapExecute(Sender: TObject);
const
  cDomainRoot = 'http://dsp.href.com/';
var
  ADoc: TNativeXml;
  I: Integer;
  savePageID, aPageID: string;
  genTime: TDateTime;
  y: TStringList;
begin
  inherited;

  if pWebApp.AppSetting['GoogleSitemapFile'] = '' then
  begin
    ucDlgs.MsgErrorOk('AppSetting[''GoogleSitemapFile''] is blank!');
    Exit;
  end;

  pWebApp.ApplicationStatus := 'starting now';  // no effect, 26-Jun-2005.

  savePageID := pWebApp.PageID;
  genTime := ucWinAPI.nowGMT;

  ADoc := TNativeXml.CreateName('urlset');
  ADoc.Utf8Encoded := True;
  ADoc.EncodingString := 'UTF-8';
  
  ADoc.Root.AttributeAdd('xmlns','http://www.google.com/schemas/sitemap/0.84');
  ADoc.Root.AttributeAdd('xmlns:xsi',
    'http://www.w3.org/2001/XMLSchema-instance');
  ADoc.Root.AttributeAdd('xsi:schemaLocation',
    'http://www.google.com/schemas/sitemap/0.84' + ' '
    +'http://www.google.com/schemas/sitemap/0.84/sitemap.xsd');

  with ADoc.Root.NodeNew('url') do
  begin
    aPageID := pWebApp.Situations.HomePageID;
    pWebApp.PageID := aPageID;
    y := TwhPage(pWebApp.WebPage).PageSettings;

    NodeNew('loc').ValueAsString := cDomainRoot;
    NodeNew('lastmod').ValueAsString :=
      FormatDateTime('yyyy-mm-dd', genTime);
    NodeNew('changefreq').ValueAsString := y.values['googlechangefreq'];
    NodeNew('priority').ValueAsString := y.Values['googlepriority'];
  end;

  for I := 0 to pred(pWebApp.Pages.Count) do
  begin
    aPageID := LeftOfEqual(pWebApp.Pages[i]);
    pWebApp.PageID := aPageID;

    y := TwhPage(pWebApp.WebPage).PageSettings;
    if NOT Assigned(y) then
      y := nil;
    if Assigned(y) and (pos('include', y.Values['googlesitemap'])>0) then
    begin

      begin

        begin

          with ADoc.Root.NodeNew('url') do
          begin
              NodeNew('loc').ValueAsString := cDomainRoot + aPageID;

            NodeNew('lastmod').ValueAsString :=
              FormatDateTime('yyyy-mm-dd', genTime) + 'T' +
              FormatDateTime('hh:nn:ss+00:00', genTime);
            if y.Values['googlechangefreq'] <> '' then
              NodeNew('changefreq').ValueAsString := y.Values['googlechangefreq']
            else
              NodeNew('changefreq').ValueAsString := 'monthly';
            if y.Values['googlepriority'] <> '' then
              NodeNew('priority').ValueAsString := y.Values['googlepriority'];
          end;
        end;


      end;
    end;
  end;

  ADoc.XmlFormat := xfReadable;
  ADoc.SaveToFile(pWebApp.AppSetting['GoogleSitemapFile']);
  FreeAndNil(ADoc);

  pWebApp.PageID := savePageID;

  pWebApp.ApplicationStatus := pWebApp.AppSetting['GoogleSitemapFile']
    + ' ready at ' + FormatDateTime('dd-MMM-yyyy hh:nn', now);
end;



procedure TDataModuleGoogleSitemap.actKeywordReportExecute(
  Sender: TObject);
var
  I: Integer;
  savePageID, aPageID: string;
  y: TStringList;
  aTitle: string;
begin
  inherited;


  savePageID := pWebApp.PageID;

  for I := 0 to pred(pWebApp.Pages.Count) do
  begin
    aPageID := LeftOfEqual(pWebApp.Pages[i]);
    pWebApp.PageID := aPageID;
    aTitle := RightOfS('=,,,', pWebApp.Pages[i]); 
    y := TwhPage(pWebApp.WebPage).PageSettings;
    if NOT Assigned(y) then
      y := nil;
    if Assigned(y) and (pos('include', y.Values['googlesitemap'])>0) then
    begin

      begin

        pWebApp.SendMacro('PARAMS|drPageAttributes,dyn,^|' +
          aPageID + '^' +
          aTitle + '^' +
          y.Values['metarobot'] + '^' +
          y.Values['metadescription'] + '^' +
          y.Values['metakeywords'] + '^' +
          y.Values['googlepriority'] + '^' +
          y.Values['googlechangefreq'] );

      end;
    end;
  end;


  pWebApp.PageID := savePageID;

end;

procedure TDataModuleGoogleSitemap.waGoogleKeywordReportExecute(
  Sender: TObject);
begin
  actKeywordReportExecute(Sender);
end;

end.
