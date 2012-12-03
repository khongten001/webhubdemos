unit whSchedule_dmwhActions;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2008-2012 HREF Tools Corp.  All Rights Reserved Worldwide. * }
{ *                                                                          * }
{ * This source code file is part of WebHub Demos.                           * }
{ *                                                                          * }
{ * Compilation requires WebHub v2.180+ or v3.180+                           * }
{ ---------------------------------------------------------------------------- }

interface

{$I IB_Directives.inc}

uses
  SysUtils, Classes, DB, Controls,
  IB_Components,
{$IFDEF IBO_49_OR_GREATER}
  IB_Access, // part of IBObjects 4.9.5 and 4.9.9 but not part of v4.8.6
{$ENDIF}
  wdbIBObjNSource, webLink, updateOK, tpAction, webTypes,
  wdbLink, wdbSSrc, wdbScan, webScan, ucIBObjPrepare;

const
  cCalifOffset = 8; // for Code Rage November 2012  (use 7 during PDT in 2008)

type
  TDMCodeRageActions = class(TDataModule)
    ScanSchedule: TwhdbScan;
    waOnAt: TwhWebAction;
    waRepeatOf: TwhWebAction;
    ScanAbout: TwhdbScan;
    waFindSchedule: TwhWebAction;
    waDownload: TwhWebAction;
    waPKtoStringVars: TwhWebAction;
    waUpdateFromStringVars: TwhWebAction;
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
    procedure waFindScheduleExecute(Sender: TObject);
    procedure waDownloadExecute(Sender: TObject);
    procedure waPKtoStringVarsExecute(Sender: TObject);
    procedure waUpdateFromStringVarsExecute(Sender: TObject);
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
    function Init(out ErrorText: string): Boolean;
    function ResetDBConnection: Boolean;
  end;

var
  DMCodeRageActions: TDMCodeRageActions;

implementation

{$R *.dfm}

uses
{$IFDEF CodeSite}CodeSiteLogging, {$ENDIF}
  IB_Header,
  DateUtils,
  ucLogFil, ucCodeSiteInterface, ucString,
  webApp, htWebApp, webSend,
  ucCalifTime,
  uFirebird_Connect_CodeRageSchedule,
  whdemo_DMIBObjCodeGen, ucIbAndFbCredentials;

{ TDMCodeRageActions }

procedure TDMCodeRageActions.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMCodeRageActions.Init(out ErrorText: string): Boolean;
const
  cFn = 'Init';
var
  DBName, DBUser, DBPass: string;
begin
  Result := FlagInitDone;
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if FlagInitDone then
    Exit;
  ZMLookup_Firebird_Credentials(DMIBObjCodeGen.ProjectAbbreviationNoSpaces,
    DBName, DBUser, DBPass);

  CreateifNil(DBName, DBUser, DBPass);
  gCodeRageSchedule_Conn.CharSet := 'UTF8';
  try
    gCodeRageSchedule_Conn.Connect;
  except
    on E: Exception do
    begin
{$IFDEF CodeSite}CodeSite.SendException(E); {$ENDIF}
      ErrorText := E.Message;
      Result := False;
      Exit;
    end;
  end;

  q := TIB_Query.Create(Self);
  q.Name := 'q';
  q.ReadOnly := True;
  q.BeforeOpen := IBNativeQuery1BeforeOpen;
  q.SQL.Text := 'select distinct ' + 'S.SCHNo, S.SCHTITLE, S.SCHONATPDT, ' +
    'DATEADD(hour, ' + IntToStr(cCalifOffset) + ', S.SCHONATPDT) as GMT, ' +
    'DATEADD(hour, ' + IntToStr(cCalifOffset) +
    ' + :OFFSET, S.SCHONATPDT) as LocalTime, ' +
    'S.SCHMINUTES, S.SCHPRESENTERFULLNAME, ' +
    'S.SCHPRESENTERORG, S.SCHLOCATION, S.SCHBLURB, ' +
    'S.UPDATECOUNTER, S.UPDATEDONAT, ' +
    'S.SCHREPEATOF, S.SCHTAGC, S.SCHTAGD, S.SCHTAGPRISM ' +
    'from schedule S, about a ' + 'WHERE (S.SchNo = A.SchNo) ' + 'and (' +
    ' (A.ProductNo = :p1) or ' + ' (A.ProductNo = :p2) or ' +
    ' (A.ProductNo = :p3) or ' + ' (A.ProductNo = :p4) or ' +
    ' (A.ProductNo = :p5) or ' + ' (A.ProductNo = :p6) or ' +
    ' (A.ProductNo = :p7) or ' + ' (A.ProductNo = :p8) or ' +
    ' (A.ProductNo = :p9) or ' + ' (A.ProductNo = :p10) or ' +
    ' (A.ProductNo = :p11) or ' + ' (A.ProductNo = :p12) or ' +
    ' (A.ProductNo = :p13) or ' + ' (A.ProductNo = :p14) or ' +
    ' (A.ProductNo = :p15) ' + ') ' + sLineBreak +
    'and (SCHONATPDT >= :Recently) ' + // '9/8/2009 15:00'
    'order by S.SchOnAtPDT, S.SchLocation ';

  c := TIB_Cursor.Create(Self);
  c.Name := 'c';
  c.ReadOnly := True;
  c.SQL.Text := 'select ' + 'A.SCHNo, A.SCHTITLE, A.SCHONATPDT, ' + sLineBreak +
    'DATEADD(hour, ' + IntToStr(cCalifOffset) + ', ' + sLineBreak +
  // Code Rage #7 in November thus PST
    'A.SCHONATPDT) as GMT, ' + sLineBreak + 'DATEADD(hour, ' +
    IntToStr(cCalifOffset) + ' + ' + ':OFFSET, A.SCHONATPDT) as LocalTime ' +
    sLineBreak + 'from schedule A ' + sLineBreak + 'where (A.SchNo = :ID) ';

  qA := TIB_Query.Create(Self);
  qA.Name := 'qA';
  qA.ReadOnly := True;
  qA.BeforeOpen := IBNativeQueryAboutBeforeOpen;
  qA.SQL.Text := 'select distinct P.ProductName ' + sLineBreak +
    'from ABOUT A, XPRODUCT P ' + sLineBreak +
    'where (A.ProductNo = P.ProductNo) ' + sLineBreak +
    'and (A.SchNo = :Event) ';

  try
    IbObj_PrepareAllQueriesAndProcs(Self, gCodeRageSchedule_Conn,
      gCodeRageSchedule_Tr, gCodeRageSchedule_Sess);
  except
    on E: Exception do
    begin
      Result := False;
      Exit; // no point to continue if SQL is wrong
    end;
  end;

  ds := TIB_DataSource.Create(Self);
  ds.Name := 'ds';
  ds.DataSet := q;

  wds := TwhdbSourceIB.Create(Self);
  wds.Name := 'wds';
  wds.DataSource := ds;
  wds.MaxOpenDataSets := 1;
  wds.ValidateConfig := True;

  ScanSchedule.WebDataSource := wds;
  ScanSchedule.PageHeight := 0;
  ScanSchedule.ControlsWhere := dsNone;
  ScanSchedule.ButtonsWhere := dsNone;

  dsA := TIB_DataSource.Create(Self);
  dsA.Name := 'dsA';
  dsA.DataSet := qA;

  wdsA := TwhdbSourceIB.Create(Self);
  wdsA.Name := 'wdsA';
  wdsA.DataSource := dsA;
  wdsA.MaxOpenDataSets := 1;
  wdsA.ValidateConfig := True;

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
    Result := True;
  end;
end;

procedure TDMCodeRageActions.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

procedure TDMCodeRageActions.IBNativeQuery1BeforeOpen(DataSet: TIB_DataSet);
const
  cFn = 'IBNativeQuery1BeforeOpen';
var
  TheOffsetInHours: Integer;
  j: Integer;
  Recently: string;
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  with DataSet as TIB_Query do
  begin
    TheOffsetInHours := StrToIntDef(pWebApp.StringVar['inOffset'], 0);
    Params[0].AsInteger := TheOffsetInHours;
    // CSSend('paramcount', IntToStr(ParamCount)); //16
    // CSSend('sql', S(SQL));
    for j := 1 to 15 do
    begin
      if pWebApp.BoolVar['inProd' + IntToStr(j)] then
        Params[j].AsInteger := j
      else
        Params[j].AsInteger := 0;
    end;
    // '9/8/2009 15:00'
    Recently := FormatDateTime('m/d/yyyy hh:nn', IncMinute(NowCalifornia, -75));
    // Recently := FormatDateTime('m/d/yyyy hh:nn', IncYear(Now, -3));
    Params[16].AsString := Recently;
  end;
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); {$ENDIF}
end;

procedure TDMCodeRageActions.ScanScheduleInit(Sender: TObject);
const
  cFn = 'ScanScheduleInit';
var
  dn: string;
begin
  // FSavCat := CodeSite.Category;
{$IFDEF CodeSite}
  CodeSite.Category := TComponent(Sender).Name;
  CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  with Sender as TwhdbScan do
  begin
    dn := HtmlParam; // droplet name to base off
    webApp.SendDroplet(dn, drBeforeWhrow);
  end;
  if Sender = ScanSchedule then
  begin
    priorDate := 0;
    priorTime := 0;
  end;
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); {$ENDIF}
  // CodeSite.Category := FSavCat;
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
    dn := HtmlParam; // droplet name to base off
    dt := wds.DataSet.FieldByName('LocalTime').asDateTime;
    ActiveScheduleID := wds.DataSet.Fields[0].AsInteger;
    if (priorDate = 0) or (priorDate <> DateOf(dt)) then
    begin
      S := webApp.Expand(Format('(~~day%s~)', [FormatDateTime('dddd', dt)]));
      webApp.SendMacro('PARAMS|drStartDate|' + S);
    end
    else if (priorTime <> TimeOf(dt)) then
      webApp.SendMacro('drStartTime');
    webApp.SendDroplet(dn, drWithinWhrow);
    priorDate := DateOf(dt);
    priorTime := TimeOf(dt);
  end;
end;

procedure TDMCodeRageActions.ScanScheduleFinish(Sender: TObject);
const
  cFn = 'ScanScheduleFinish';
var
  dn: string;
begin
{$IFDEF CodeSite}
  CodeSite.Category := TComponent(Sender).Name;
  CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  with Sender as TwhdbScan do
  begin
    dn := HtmlParam; // droplet name to base off
    webApp.SendDroplet(dn, drAfterWhrow);
  end;
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);
  CodeSite.Category := ''; {$ENDIF}
end;

procedure TDMCodeRageActions.waDownloadExecute(Sender: TObject);
var
  outputFilename: String;
begin
  inherited;
  { Test new feature in v2.170; SendFileIIS will catch this invalid filespec. }
  with TwhWebActionEx(Sender) do
  begin
    outputFilename := 'd:\temp\nonsensefile.pdf';
    Response.SendFileIIS(outputFilename, 'application/pdf', False);
    // delete after send = False
  end;

end;

procedure TDMCodeRageActions.waFindScheduleExecute(Sender: TObject);
const
  cFn = 'waFindScheduleExecute';
var
  q: TIB_Cursor;
  SelectSQL: string;
  i: Integer;
  FieldContent: string;
  FlagFwd: Boolean;
  {$IFDEF CodeSite}FSavCat: string;{$ENDIF}
begin
{$IFDEF CodeSite}
  FSavCat := CodeSite.Category;
  CodeSite.Category := TwhWebAction(Sender).Name;
  CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  CSSend('Name', TwhWebAction(Sender).Name);
  CSSend('HtmlParam', TwhWebAction(Sender).HtmlParam);

  FlagFwd := True;
  q := nil;
  try
    q := TIB_Cursor.Create(Self);
    q.Name := 'qScheduleFind';
    q.IB_Connection := gCodeRageSchedule_Conn;
    if NOT gCodeRageSchedule_Conn.Connected then
      gCodeRageSchedule_Conn.Connect;
    SelectSQL := TwhWebAction(Sender).HtmlParam;
    SelectSQL := pWebApp.Expand(SelectSQL);
    q.SQL.Text := SelectSQL;
    q.ReadOnly := True;
    if NOT IbObj_PrepareEx(q, gCodeRageSchedule_Conn, gCodeRageSchedule_Tr,
      gCodeRageSchedule_Sess) then
    begin
      pWebApp.Debug.AddPageError(TwhWebAction(Sender).Name + Chr(183) + q.Name);
      // clue
      FlagFwd := False; // no point to continue if SQL is wrong
    end;

    if FlagFwd then
    begin
      q.First;
      pWebApp.SendStringImm('<table class="' + lowercase(TwhWebAction(Sender)
        .Name) + '-table">' + sLineBreak);
      pWebApp.SendStringImm('<tr>' + sLineBreak);
      for i := 0 to Pred(q.FieldCount) do
      begin
        pWebApp.SendStringImm(' <th>');
        pWebApp.SendMacro('mcLabel-' + 'Schedule' + '-' + q.Fields[i]
          .FieldName);
        pWebApp.SendStringImm(' </th>' + sLineBreak);
      end;
      pWebApp.SendStringImm('</tr>' + sLineBreak);
      CSSend('RecordCount', S(q.RecordCount));
      while not q.eof do
      begin
        pWebApp.SendStringImm('<tr>' + sLineBreak);
        for i := 0 to Pred(q.FieldCount) do
        begin
          pWebApp.SendStringImm(' <td>');
          FieldContent := q.Fields[i].AsString;
          // CSSend(FieldContent);
          if i = 0 then
          begin
            pWebApp.SendMacro(Format('JUMP|pgEditScheduleLayout1,%s|%s',
              [FieldContent, FieldContent]));
          end
          else
            pWebApp.SendStringImm(FieldContent);
          pWebApp.SendStringImm(' </td>' + sLineBreak);
        end;
        pWebApp.SendStringImm('</tr>' + sLineBreak);
        q.Next;
      end;
      pWebApp.SendStringImm('</table>' + sLineBreak);
    end;

    q.Close;
    q.Unprepare;
  finally
    FreeAndNil(q);
  end;
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);
  CodeSite.Category := FSavCat; {$ENDIF}
end;

procedure TDMCodeRageActions.waOnAtExecute(Sender: TObject);
const
  cFn = 'waOnAtExecute';
var
  dt: TDateTime;
  useFormat: string;
  s1: string;
begin
  // FSavCat := CodeSite.Category;
  // CodeSite.Category := TwhWebAction(Sender).Name;
  // {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  with Sender as TwhWebAction do
  begin
    useFormat := HtmlParam;
    // CSSend('useFormat', useFormat);
    dt := wds.DataSet.FieldByName('LocalTime').asDateTime;

    if useFormat = '' then
      s1 := Format('<span class="day-span">%s</span> ' +
        '<span class="time-span">%s</span>', [FormatDateTime('dd-MMM', dt),
        FormatDateTime('hh:nn', dt)])
    else
      s1 := FormatDateTime(useFormat, dt);
    // CSSend('S1', S1);
    webApp.SendStringImm(s1);
  end;
  // {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
  // CodeSite.Category := FSavCat;
end;

procedure TDMCodeRageActions.waPKtoStringVarsExecute(Sender: TObject);
const
  cFn = 'waPKtoStringVarsExecute';
  { Find the record matching querying pk value
    Return results in edit or view mode
  }
var
  CurrentTable: string; { table of entities }
  CurrentPK: string; { table pri key }
  CurrentFieldname: string;
  PKValue: string;
  q: TIB_Cursor;
  i: Integer;
  SVName: string;
  ThisFieldTypeRaw: Integer;
  HumanReadable: string;
  FSavCat: string;
begin
{$IFDEF CodeSite}
  FSavCat := CodeSite.Category;
  CodeSite.Category := TwhWebAction(Sender).Name;
  CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  q := nil;
  if SplitThree(TwhWebAction(Sender).HtmlParam, ',', CurrentTable, CurrentPK,
    PKValue) then
  begin
    PKValue := pWebApp.MoreIfParentild(PKValue);
    CSSend('CurrentTable', CurrentTable);
    CSSend('CurrentPK', CurrentPK);
    CSSend('PKValue', PKValue);

    if NOT gCodeRageSchedule_Conn.Connected then
      gCodeRageSchedule_Conn.Connect;
    try
      q := TIB_Cursor.Create(gCodeRageSchedule_Sess);
      q.Name := 'q' + CurrentTable;
      q.SQL.Text := Format('select * from %s where (%s=:PK)',
        [CurrentTable, CurrentPK]);
      CSSend(q.Name, S(q.SQL));
      q.ReadOnly := True;
      if IbObj_PrepareEx(q, gCodeRageSchedule_Conn, gCodeRageSchedule_Tr,
        gCodeRageSchedule_Sess) then
      begin
        q.Params[0].AsString := PKValue;
        q.Open;
        for i := 0 to Pred(q.FieldCount) do
        begin
          CurrentFieldname := q.Fields[i].FieldName;
          if (i = 0) or IsEqual(CurrentFieldname,
            DMIBObjCodeGen.UpdatedOnAtFieldname) or
            IsEqual(CurrentFieldname, DMIBObjCodeGen.UpdateCounterFieldname)
          then
          begin
            SVName := 'readonly-' + CurrentTable + '-' + CurrentFieldname;
          end
          else
            SVName := 'edit-' + CurrentTable + '-' + CurrentFieldname;

          ThisFieldTypeRaw := q.Fields[i].SQLType;
          case ThisFieldTypeRaw of
            blr_sql_date:
              HumanReadable := FormatDateTime('dd-MMM-yyyy',
                q.Fields[i].AsDate);
            blr_sql_time:
              HumanReadable := FormatDateTime('hh:nn:ss',
                q.Fields[i].asDateTime); // ???
            blr_timestamp, SQL_DATE_:
              HumanReadable := FormatDateTime('dd-MMM-yyyy hh:nn',
                q.Fields[i].asDateTime);
          else
            HumanReadable := q.Fields[i].AsString;
          end;

          pWebApp.StringVar[SVName] := HumanReadable;
        end;
      end;
      q.Close;
      q.Unprepare;
    finally
      FreeAndNil(q);
    end;
  end;
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); 
  CodeSite.Category := FSavCat;{$ENDIF}
end;

procedure TDMCodeRageActions.ScanScheduleExecute(Sender: TObject);
begin
  (Sender as TwhdbScan).PageHeight := 0;
end;

function TDMCodeRageActions.ResetDBConnection: Boolean;
const
  cFn = 'ResetDBConnection';
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  wds.Close;
  wds.HouseClean;
  Result := IbObj_Prepare(c);
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); {$ENDIF}
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
    x := wds.DataSet.FieldByName('SchRepeatOf').AsInteger;
    with c do
    begin
      TheOffsetInHours := StrToIntDef(pWebApp.StringVar['inOffset'], 0);
      Params[0].AsInteger := TheOffsetInHours;
      Params[1].AsInteger := x;
      c.Open;
    end;
    if TheOffsetInHours > 0 then
      ASign := '+'
    else
      ASign := ''; // minus sign is included in %d
    Response.SendImm(Format('%s (utc %s%d)', [FormatDateTime('dd-MMM hh:nn',
      c.FieldByName('LocalTime').asDateTime), ASign, TheOffsetInHours]));
    c.Close;
  end;
end;

procedure TDMCodeRageActions.waUpdateFromStringVarsExecute(Sender: TObject);
const
  cFn = 'waUpdateFromStringVarsExecute';
var
  q: TIB_DSQL;
  UpdateSQL: string;
  DrName: string;
  i: Integer;
  CurrentTableName: string;
  FldName: string;
  a1, a2: string;
  FlagFwd: Boolean;
  FSavCat: string;
begin
{$IFDEF CodeSite}
  FSavCat := CodeSite.Category;
  CodeSite.Category := TwhWebAction(Sender).Name;
  CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  q := nil;
  DrName := TwhWebAction(Sender).HtmlParam;
  UpdateSQL := pWebApp.Tekeros.TekeroAsString(DrName);
  if SplitString(UpdateSQL, 'set', a1, a2) then
  begin
    a1 := Trim(a1);
    if SplitString(a1, ' ', a1, a2) then
    begin
      CurrentTableName := a2; // update_thistable_set

      if NOT gCodeRageSchedule_Conn.Connected then
        gCodeRageSchedule_Conn.Connect;

      try
        q := TIB_DSQL.Create(Self);
        q.Name := 'qUpdateSchedule';
        q.SQL.Text := pWebApp.Expand(UpdateSQL);
        CSSend(q.Name, S(q.SQL));

        FlagFwd := IbObj_PrepareEx(q, gCodeRageSchedule_Conn,
          gCodeRageSchedule_Tr, gCodeRageSchedule_Sess);
        for i := 0 to Pred(q.ParamCount) do
        begin
          FldName := q.Params[i].FieldName;
          q.Params[i].AsString := pWebApp.StringVar
            ['edit-' + CurrentTableName + '-' + FldName];
          CSSend('Parameter ' + IntToStr(i), q.Params[i].AsString);
        end;
        if NOT FlagFwd then
          pWebApp.Debug.AddPageError(q.Name)
        else
        begin
          try
            q.IB_Transaction.StartTransaction;
            q.ExecSQL;
            CSSend('RowsAffected', S(q.RowsAffected)); 
            q.IB_Transaction.Commit;
            q.Unprepare;
          except
            on E: Exception do
            begin
              LogSendException(E);
              q.IB_Transaction.Rollback;
              pWebApp.Debug.AddPageError(E.Message);
            end;
          end;
        end;
      finally
        FreeAndNil(q);
      end;
    end;
  end;
  pWebApp.Response.SendBounceToPageR('pgAdminMenu', '');
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); 
  CodeSite.Category := FSavCat;{$ENDIF}
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
const
  cFn = 'ScanAboutRowStart';
var
  dn: string;
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  with Sender as TwhdbScan do
  begin
    dn := HtmlParam; // droplet name to base off
    // CSSend('about to SendDroplet', dn);
    webApp.SendDroplet(dn, drWithinWhrow);
  end;
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); {$ENDIF}
end;

procedure TDMCodeRageActions.IBNativeQueryAboutBeforeOpen(DataSet: TIB_DataSet);
const
  cFn = 'IBNativeQueryAboutBeforeOpen';
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  CSSend('ActiveScheduleID', S(ActiveScheduleID));
  with DataSet as TIB_Query do
  begin
    Params[0].AsInteger := ActiveScheduleID;
  end;
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); {$ENDIF}
end;

end.
