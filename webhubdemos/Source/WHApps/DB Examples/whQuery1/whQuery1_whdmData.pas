unit whQuery1_whdmData;

(*
Copyright (c) 1999-2013 HREF Tools Corp.

Permission is hereby granted, on 26-Jan-2013, free of charge, to any person
obtaining a copy of this file (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*)

interface

uses
  SysUtils, Classes,
  webLink, wdbScan, wdbGrid, wbdeGrid{bde}, updateOK, tpAction, webTypes, wdbSSrc, wdbSource,
  wbdeSource, Bde.DBTables, Data.DB;

type
  TDMHTQ1 = class(TDataModule)
    Query1: TQuery;
    DataSource1: TDataSource;
    WebDataSource1: TwhbdeSource;
    answergrid: TwhbdeGrid;
    procedure DataModuleCreate(Sender: TObject);
    procedure Query1AfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    FReportSQL: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
    property ReportSQL: Boolean read FReportSQL write FReportSQL;
  end;

var
  DMHTQ1: TDMHTQ1;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webApp, htWebApp, ucCodeSiteInterface, whdemo_ViewSource;

{ TDMHTQ1 }

procedure TDMHTQ1.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMHTQ1.Init(out ErrorText: string): Boolean;
begin
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      {make sure MaxOpenDataSets is 1 because www params are used.
       23-May-2004 v2.034}
      WebDataSource1.MaxOpenDataSets := 1;
      WebDataSource1.KeyFieldNames := 'LangIndexNo';
      {set the initial page height to 5 rows}
      answergrid.PageHeight := 5;
      {clear the border property for XHTML compliance}
      answergrid.Border := '';

      //set database directory
      with query1 do
      begin
        DatabaseName := getHtDemoDataRoot + 'iso639\Paradox\';
        SQL.Text := 'SELECT d.LangIndexNo, d.LangID, c1.CountryName, ' +
          'd.NameType, d.LangName ' +
          'FROM "LanguageIndex.db" d, "CountryCode.db" c1 ' +
          'WHERE(d.CountryID = c1.CountryID) ' +
          'AND (d.LangID=:wwwLangID) ' +
          'AND (d.NameType= :wwwNameType ) ';
        try
          Prepare; // Delphi TQuery
        except
          on E: exception do
          begin
            {in case the table becomes corrupt or some other unexpected condition
             arises... catch the error and prevent use of the components}
            ErrorText := SQL.Text + sLineBreak + e.Message;
            LogSendError(ErrorText, query1.Name);
          end;
        end;
      end;

      if ErrorText = '' then
      begin
        //Always refresh the webactions once as the application starts.
        RefreshWebActions(Self);
        // helpful to know that WebAppUpdate will be called whenever the
        // WebHub app is refreshed.
        AddAppUpdateHandler(WebAppUpdate);
        FlagInitDone := True;
      end;
    end;
  end;
  Result := FlagInitDone;
end;

procedure TDMHTQ1.Query1AfterOpen(DataSet: TDataSet);
begin
  {see the HTML for Page2 to see how this is used to
   conditionally show warning message or record count.}
  pWebApp.StringVarInt['RecordCount'] := DataSet.RecordCount;

  {use this to output the query syntax for debugging purposes}
  //Any data in the Summary property will automatically be sent at the end
  //of the page.  This is built into WebHub.  You do not need to explicitly
  //request the summary in any way.
  if FReportSQL then
  begin
    with pWebApp, TQuery(DataSet) do
    begin
      Summary.Add('<h2>SQL Syntax for query</h2>' );
      Summary.AddStrings(sql);
    end;
  end;
end;

procedure TDMHTQ1.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

end.
