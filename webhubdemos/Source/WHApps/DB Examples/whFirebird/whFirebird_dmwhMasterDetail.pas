unit whFirebird_dmwhMasterDetail;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this WebHub sample file *)

interface

{$I hrefdefines.inc}
{$I IB_Directives.INC} // IbObjects source\common

uses
  SysUtils, Classes, DB,
  IB_Components, IBODataset,
{$IFDEF IBO_49_OR_GREATER}
  IB_Access,  // part of IBObjects 4.9.5 and 4.9.9 but not part of v4.8.6
{$ENDIF}
  webLink, wdbSSrc, wdbScan, wdbIBObjOSource;

type
  TDMMastDet = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    whdsEmployee: TwhdbSourceIBO;
    whdsDept: TwhdbSourceIBO;
    dsDept: TDataSource;
    qDept: TIBOQuery;
    dsEmployee: TDataSource;
    qEmployee: TIBOQuery;
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMMastDet: TDMMastDet;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webApp, htWebApp, ucCodeSiteInterface,
  uFirebird_Connect_Employee;

{ TDMMastDet }

procedure TDMMastDet.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
  whdsEmployee := nil;
    whdsDept := nil;
    dsDept := nil;
    qDept := nil;
    dsEmployee := nil;
    qEmployee := nil;
end;

procedure TDMMastDet.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(whdsEmployee);
  FreeAndNil(whdsDept);
  FreeAndNil(dsDept);
  FreeAndNil(qDept);
  FreeAndNil(dsEmployee);
  FreeAndNil(qEmployee);
end;

function TDMMastDet.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if NOT Assigned(qDept) then
    begin
      qDept := TIBOQuery.Create(Self);
      qDept.Name := 'qDept';
      qDept.SQL.Text := 'select * from Dept order by Dept_No';

      dsDept := TDataSource.Create(Self);
      dsDept.Name := 'dsDept';
    end;
    if NOT Assigned(qEmployee) then
    begin
      qEmployee := TIBOQuery.Create(Self);
      qEmployee.Name := 'qEmployee';
      qEmployee.SQL.Text := 'select * from Employee where (Dept_No=:Dept_No)';
      dsEmployee := TDataSource.Create(Self);
      dsEmployee.Name := 'dsEmployee';
    end;

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      // Call RefreshWebActions here only if it is not called within a TtpProject event
      // RefreshWebActions(Self);

      // helpful to know that WebAppUpdate will be called whenever the
      // WebHub app is refreshed.
      AddAppUpdateHandler(WebAppUpdate);
      FlagInitDone := True;
    end;
  end;
  Result := FlagInitDone;
  {$IFDEF CodeSite}CodeSite.Send('Result', Result);
  CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMMastDet.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

end.
