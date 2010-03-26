unit whSchedule_dmwhActions;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this file *)

interface

uses
  SysUtils, Classes, DB, Controls,
  {IBODataSet, }IB_Components,
  whibds, webLink, updateOK, tpAction, webTypes,
  wdbLink, wdbSSrc, wdbScan, webScan;

type
  TDMCodeRageActions = class(TDataModule)
    ScanSchedule: TwhdbScan;
    waOnAt: TwhWebAction;
    waRepeatOf: TwhWebAction;
    ScanAbout: TwhdbScan;
    procedure DataModuleCreate(Sender: TObject);
    procedure IBNativeQuery1BeforeOpen(DataSet: TIB_DataSet);
    procedure IBNativeQueryAboutBeforeOpen(DataSet: TIB_DataSet);
    procedure ScanScheduleInit(Sender: TObject);
    procedure ScanScheduleRowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure ScanScheduleFinish(Sender: TObject);
    procedure waOnAtExecute(Sender: TObject);
    procedure ScanScheduleExecute(Sender: TObject);
    procedure waRepeatOfExecute(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ScanAboutRowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    wds: TwhdbSourceIB;
    ds: TIB_DataSource;
    q: TIB_Query;
    c: TIB_Cursor;
    wdsA: TwhdbSourceIB;
    dsA: TIB_DataSource;
    qA: TIB_Query;
    priorDate: TDate;
    priorTime: TTime;
    ActiveScheduleID: Integer;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init: Boolean;
    function ResetDBConnection: Boolean;
  end;

var
  DMCodeRageActions: TDMCodeRageActions;

implementation

{$R *.dfm}

uses
  DateUtils,
  ucLogFil,
  webApp, htWebApp, webSend,
  CodeRage_dmCommon, ucCalifTime;

{ TDM001 }

procedure TDMCodeRageActions.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMCodeRageActions.Init: Boolean;
begin
  Result := True;
  // reserved for code that should run once, after AppID set
  if FlagInitDone then Exit;

  q := TIB_Query.Create(Self);
  q.Name := 'q';
  q.IB_Connection := dmCommon.cn1;
  q.BeforeOpen := IBNativeQuery1BeforeOpen;
  q.SQL.Text := 'select distinct ' +
      'S.SCHID, S.SCHTITLE, S.SCHONATPDT, ' +
      'DATEADD(hour, 7, S.SCHONATPDT) as GMT, ' +
      'DATEADD(hour, 7 + :OFFSET, S.SCHONATPDT) as LocalTime, ' +
      'S.SCHMINUTES, S.SCHPRESENTERFULLNAME, ' +
      'S.SCHPRESENTERORG, S.SCHLOCATION, S.SCHBLURB, ' +
      'S.UPDATECOUNTER, S.UPDATEDONAT, ' +
      'S.SCHREPEATOF, S.SCHTAGC, S.SCHTAGD, S.SCHTAGPRISM ' +
      'from schedule S, about a ' +
      'WHERE (S.SchID = A.SchID) ' +
      'and (' +
      ' (A.ProductID = :p1) or ' +
      ' (A.ProductID = :p2) or ' +
      ' (A.ProductID = :p3) or ' +
      ' (A.ProductID = :p4) or ' +
      ' (A.ProductID = :p5) or ' +
      ' (A.ProductID = :p6) or ' +
      ' (A.ProductID = :p7) or ' +
      ' (A.ProductID = :p8) or ' +
      ' (A.ProductID = :p9) or ' +
      ' (A.ProductID = :p10) or ' +
      ' (A.ProductID = :p11) or ' +
      ' (A.ProductID = :p12) or ' +
      ' (A.ProductID = :p13) or ' +
      ' (A.ProductID = :p14) or ' +
      ' (A.ProductID = :p15) ' +
      ') ' + sLineBreak +
      'and (SCHONATPDT >= :Recently) ' +  // '9/8/2009 15:00'
      'order by S.SchOnAtPDT, S.SchLocation ';
  q.Prepare;

  c := TIB_Cursor.Create(Self);
  c.Name := 'c';
  c.IB_Connection := dmCommon.cn1;
  c.SQL.Text := 'select ' +
     'A.SCHID, A.SCHTITLE, A.SCHONATPDT, ' +
     'DATEADD(hour, 7, A.SCHONATPDT) as GMT, ' +
     'DATEADD(hour, 7 + :OFFSET, A.SCHONATPDT) as LocalTime ' +
     'from schedule A ' +
     'where (A.SchID = :ID) ';
  c.Prepare;

  ds := TIB_DataSource.Create(Self);
  ds.Name := 'ds';
  ds.DataSet := q;

  wds := TwhdbSourceIB.Create(Self);
  wds.Name := 'wds';
  wds.DataSource := ds;
  wds.MaxOpenDataSets := 1;

  ScanSchedule.WebDataSource := wds;
  ScanSchedule.PageHeight := 0;
  ScanSchedule.ControlsWhere := dsNone;
  ScanSchedule.ButtonsWhere := dsNone;


  qA := TIB_Query.Create(Self);
  qA.Name := 'qA';
  qA.IB_Connection := dmCommon.cn1;
  qA.BeforeOpen := IBNativeQueryAboutBeforeOpen;
  qA.SQL.Text := 'select distinct P.ProductName ' +
    'from ABOUT A, XPRODUCT P ' +
    'where (A.ProductID = P.ProductID) ' +
    'and (A.SchID = :Event) ';
  qA.Prepare;


  dsA := TIB_DataSource.Create(Self);
  dsA.Name := 'dsA';
  dsA.DataSet := qA;

  wdsA := TwhdbSourceIB.Create(Self);
  wdsA.Name := 'wdsA';
  wdsA.DataSource := dsA;
  wdsA.MaxOpenDataSets := 1;

  ScanAbout.WebDataSource := wdsA;
  ScanAbout.PageHeight := 0;
  ScanAbout.ControlsWhere := dsNone;
  ScanAbout.ButtonsWhere := dsNone;

  if Assigned(pWebApp) and pWebApp.IsUpdated then
  begin
    // good idea to refresh all web actions in this datamodule, once
    RefreshWebActions(Self);
    // helpful to know that WebAppUpdate will be called whenever the
    // WebHub app is refreshed.
    AddAppUpdateHandler(WebAppUpdate);
    FlagInitDone := True;
  end;
end;

procedure TDMCodeRageActions.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

procedure TDMCodeRageActions.IBNativeQuery1BeforeOpen(
  DataSet: TIB_DataSet);
var
  TheOffsetInHours: Integer;
  j: Integer;
  Recently: string;
begin
  with DataSet as TIB_Query do
  begin
    TheOffsetInHours :=
      StrToIntDef(pWebApp.StringVar['inOffset'], 0);
    Params[0].AsInteger := TheOffsetInHours;
    //HREFTestLog('info', 'paramcount', IntToStr(ParamCount)); //16
    //HREFTestLog('sql', SQL.Text, '');
    for j := 1 to 15 do
    begin
      if pWebApp.BoolVar['inProd' + IntToStr(j)] then
        Params[j].AsInteger := j
      else
        Params[j].AsInteger := 0;
    end;
    // '9/8/2009 15:00'
    Recently := FormatDateTime('m/d/yyyy hh:nn',
      IncMinute(NowCalifornia, -75));
    Params[16].AsString := Recently;
  end;
end;

procedure TDMCodeRageActions.ScanScheduleInit(Sender: TObject);
var
  dn: string;
begin
  with Sender as TwhdbScan do
  begin
    dn := HtmlParam;  // droplet name to base off
    WebApp.SendDroplet(dn, drBeforeWhrow);
  end;
  if Sender = ScanSchedule then
  begin
    priorDate := 0;
    priorTime := 0;
  end;
end;

procedure TDMCodeRageActions.ScanScheduleRowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
var
  dn: string;
  dt: TDateTime;
  S: string;
begin
  with Sender as TwhdbScan do
  begin
    dn := HtmlParam;  // droplet name to base off
    dt := wds.DataSet.FieldByName('LocalTime').asDateTime;
    ActiveScheduleID := wds.DataSet.Fields[0].asInteger;
    if (priorDate = 0) or (priorDate <> DateOf(dt)) then
    begin
      S := WebApp.Expand(Format('(~~day%s~)',
        [FormatDateTime('dddd', dt)]));
      WebApp.SendMacro('PARAMS|drStartDate|' + S);
    end
    else
    if (priorTime <> TimeOf(dt)) then
      WebApp.SendMacro('drStartTime');
    WebApp.SendDroplet(dn, drWithinWhrow);
    priorDate := DateOf(dt);
    priorTime := TimeOf(dt);
  end;
end;

procedure TDMCodeRageActions.ScanScheduleFinish(Sender: TObject);
var
  dn: string;
begin
  with Sender as TwhdbScan do
  begin
    dn := HtmlParam;  // droplet name to base off
    WebApp.SendDroplet(dn, drAfterWhrow);
  end;
end;

procedure TDMCodeRageActions.waOnAtExecute(Sender: TObject);
var
  dt: TDateTime;
  useFormat: string;
begin
  with Sender as TwhWebAction do
  begin
    useFormat := HtmlParam;
    dt := wds.DataSet.FieldByName('LocalTime').asDateTime;

    if useFormat = '' then
      WebApp.SendStringImm(
        Format('<span class="day-span">%s</span> ' +
        '<span class="time-span">%s</span>',
        [FormatDateTime('dd-MMM', dt),
        FormatDateTime('hh:nn', dt)]))
    else
      WebApp.SendStringImm(FormatDateTime(useFormat, dt));
  end;
end;

procedure TDMCodeRageActions.ScanScheduleExecute(Sender: TObject);
begin
  (Sender as TwhdbScan).PageHeight := 0;
end;

function TDMCodeRageActions.ResetDBConnection: Boolean;
begin
  wds.Close;
  wds.HouseClean;
  c.Prepare;
  Result := True;
end;

procedure TDMCodeRageActions.waRepeatOfExecute(Sender: TObject);
var
  x: Integer;
  TheOffsetInHours: Integer;
  ASign: string;
begin
  with Sender as TwhWebAction do
  begin
    c.Close;
    x := wds.DataSet.FieldByName('SchRepeatOf').asInteger;
    with c do
    begin
      TheOffsetInHours :=
        StrToIntDef(pWebApp.StringVar['inOffset'], 0);
      Params[0].AsInteger := TheOffsetInHours;
      Params[1].AsInteger := x;
      c.Open;
    end;
    if TheOffsetInHours > 0 then
      ASign := '+'
    else
      ASign := '';  // minus sign is included in %d
    Response.SendImm(Format('%s (utc %s%d)',
      [FormatDateTime('dd-MMM hh:nn',
         c.FieldByName('LocalTime').asDateTime),
       ASign, TheOffSetInHours]));
    c.Close;
  end;
end;

procedure TDMCodeRageActions.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(q);
  FreeAndNil(c);
  FreeAndNil(ds);
  FreeAndNil(wds);
end;

procedure TDMCodeRageActions.ScanAboutRowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
var
  dn: string;
begin
  with Sender as TwhdbScan do
  begin
    dn := HtmlParam;  // droplet name to base off
    WebApp.SendDroplet(dn, drWithinWhrow);
  end;
end;

procedure TDMCodeRageActions.IBNativeQueryAboutBeforeOpen(
  DataSet: TIB_DataSet);
begin
  with DataSet as TIB_Query do
  begin
    Params[0].asInteger := ActiveScheduleID;
  end;
end;

end.
