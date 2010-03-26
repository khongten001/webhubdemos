unit whParadox_dmWhProcess;

interface

uses
  SysUtils, Classes, DB, DBClient, SimpleDS, wdbSSrc, wdbxSource, updateOK,
  tpAction, webTypes, webLink, wdbLink, wdbScan;

type
  TdmwhProcess = class(TDataModule)
    scanTable: TwhdbScan;
    whdbxSource2: TwhdbxSource;
    DataSource1: TDataSource;
    SimpleDataSet1: TSimpleDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init;
  end;

var
  dmwhProcess: TdmwhProcess = nil;

implementation

{$R *.dfm}

{ TdmwhProcess }

procedure TdmwhProcess.Init;
begin
  SimpleDataSet1.DataSet.CommandText := 'select * from tocoutln';
end;

end.
