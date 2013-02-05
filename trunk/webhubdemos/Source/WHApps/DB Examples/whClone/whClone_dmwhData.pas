unit whClone_dmwhData;

(*
Copyright (c) 1997-2013 HREF Tools Corp.

Permission is hereby granted, on 03-Feb-2013, free of charge, to any person
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
  webLink, Data.DB, wdbScan, wdbSSrc, wdbSource, wbdeSource, Bde.DBTables,
  updateOK, tpAction, webTypes, wdbGrid, wbdeGrid{bde},, Datasnap.DBClient, SimpleDS,
  wdbxSource, Datasnap.Provider;

type
  TDMData2Clone = class(TDataModule)
    Table1: TTable;
    Table2: TTable;
    TableDBase: TTable;
    DataSource2: TDataSource;
    WebDataSource2: TwhbdeSource;
    DataSource1: TDataSource;
    WebDataSource1: TwhbdeSource;
    whdbxSourceXML: TwhdbxSource;
    SimpleDataSetXML: TSimpleDataSet;
    DataSourceXML: TDataSource;
    whdbxSourceXMLCloned: TwhdbxSource;
    whdbxSourceDBF: TwhdbxSource;
    DataSourceDBF4DBX: TDataSource;
    ClientDataSetDBF: TClientDataSet;
    DataSetProviderDBF: TDataSetProvider;
    DataSourceXmlCloned: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure WebDataSource1Execute(Sender: TObject);
    procedure WebDataSource1FindKeys(Sender: TwhdbSourceBase; var Value: string;
      var Handled: Boolean);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMData2Clone: TDMData2Clone;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webApp, htWebApp, ucCodeSiteInterface, whdemo_ViewSource;

{ TDMData2Clone }

procedure TDMData2Clone.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

procedure TDMData2Clone.DataModuleDestroy(Sender: TObject);
begin
  { This saves the .DBF to a ClientSet binary .CDS file for use the next time
    the demo runs...  used for testing both ways }
  if NOT FileExists(getHtDemoDataRoot + 'whClone\holdings.cds') then
  begin
    ClientDataSetDBF.Open;
    ClientDataSetDBF.SaveToFile(getHtDemoDataRoot + 'whClone\holdings.cds',
      dfBinary);
    ClientDataSetDBF.Close;
  end;
end;

function TDMData2Clone.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';

  { Note: sharing a TDataSet is okay in the datamodule. Sharing a TDataSource
    causes changes in one Scan to show up in the other one -- not usually good.}


  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin

      whdbxSourceXML.KeyFieldNames := 'CountryID';
      whdbxSourceXML.MaxOpenDataSets := 1; // no cloning
      SimpleDataSetXML.Open;
      if NOT whdbxSourceXML.IsUpdated then
        ErrorText := whdbxSourceXML.Name + ' would not update. ';

      if ErrorText = '' then
      begin
        whdbxSourceXMLCloned.KeyFieldNames := 'CountryID';
        whdbxSourceXMLCloned.MaxOpenDataSets := 3; // yes cloning
        if NOT whdbxSourceXMLCloned.IsUpdated then
          ErrorText := ErrorText + whdbxSourceXMLCloned.Name +
            ' would not update. ';
      end;

      if ErrorText = '' then
      begin
        WebDataSource1.DataSource := DataSource1;
        DataSource1.DataSet := Table1;
        WebDataSource1.KeyFieldNames := 'HOLDINGNO'; // 'ACCT_NBR;SYMBOL';
        WebDataSource1.OpenDataSetVisual := False;

        WebDataSource2.DataSource := DataSource2;
        DataSource2.DataSet := Table2;
        WebDataSource2.KeyFieldNames := 'SpeciesNo';
        WebDataSource2.OpenDataSetVisual := False;

        with Table1 do
        begin
          DatabaseName := getHtDemoDataRoot + 'whClone\';
          TableName := 'HOLDINGS.DBF';
          IndexName := 'HoldingNo';
          Open;
          FieldByName('HOLDINGNO').Visible := True;
        end;

        whdbxSourceDBF.KeyFieldNames := 'HOLDINGNO';
        if FileExists(getHtDemoDataRoot + 'whClone\holdings.cds') then
        begin
          FreeAndNil(DataSetProviderDBF);
          FreeAndNil(TableDBase);
          ClientDataSetDBF.ProviderName := '';
          ClientDataSetDBF.FileName := getHtDemoDataRoot +
            'whClone\holdings.cds';
        end
        else
        with TableDBase do
        begin
          DatabaseName := getHtDemoDataRoot + 'whClone\';
          TableName := 'HOLDINGS.DBF';
          Open;
        end;

        with Table2 do
        begin
          DatabaseName := getHtDemoDataRoot + 'whClone\';
          TableName := 'BIOLIFE.DB';
          Open;
        end;
      end;

      if ErrorText = '' then
      begin
        RefreshWebActions(Self);

        // helpful to know that WebAppUpdate will be called whenever the
        // WebHub app is refreshed.
        AddAppUpdateHandler(WebAppUpdate);
        FlagInitDone := True;
      end;
    end;
  end;
  Result := FlagInitDone;
  {$IFDEF CodeSite}CodeSite.Send('Result', Result);
  CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMData2Clone.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMData2Clone.WebDataSource1Execute(Sender: TObject);
//bend existing field-pointers to the clone's fields
begin
{there are THREE CHOICES when bending pointers:
 #1: activate WebDataSource.BendPointers.
     that's whats been done here, and why there is no code.
     there's usually little need to 'straighten' the pointers again,
     but if you need to, call TwhbdeSource(sender).ResetClonePointers.
 #2: call the WebDataSource BendClonePointers method.
     as in: TwhbdeSource(sender).BendClonePointers.
     to undo: TwhbdeSource(sender).ResetClonePointers.
 #3: directly call the ucClonDB utility function responsible:
     as in: with TwhbdeSource(sender) do
              BendDataSetPointers(OriginalDataSet,DataSet);
     to undo call: BendDataSetPointers(OriginalDataSet,nil);}
end;

procedure TDMData2Clone.WebDataSource1FindKeys(Sender: TwhdbSourceBase;
  var Value: string; var Handled: Boolean);
begin
  //scrolling through the holdings table.
  //we are not supporting 'finding' values here
  //but simply signal that we're scrolling through
  //a cloned table that does not have a unique or primary index.
  //This would be the place to write code to locate items.
  /////////////Handled:=true;
end;

(*
    Table2SpeciesNo: TFloatField;
    Table2Category: TStringField;
    Table2Common_Name: TStringField;
    Table2SpeciesName: TStringField;
    Table2Lengthcm: TFloatField;
    Table2Length_In: TFloatField;
    Table2Notes: TMemoField;
    Table2Graphic: TGraphicField;

        FloatField1: TFloatField;
    StringField1: TStringField;
    FloatField2: TFloatField;
    FloatField3: TFloatField;
    DateField1: TDateField;
    Table1SYMBOL: TStringField;

*)
end.
