{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 1999-2013 HREF Tools Corp.  All Rights Reserved Worldwide. * }
{ *                                                                          * }
{ * This source code file is part of the Delphi Prefix Registry.             * }
{ *                                                                          * }
{ * This file is licensed under a Creative Commons Attribution 2.5 License.  * }
{ * http://creativecommons.org/licenses/by/2.5/                              * }
{ * If you use this file, please keep this notice intact.                    * }
{ *                                                                          * }
{ * Author: Ann Lynnworth                                                    * }
{ *                                                                          * }
{ * Refer friends and colleagues to www.href.com/whvcl. Thanks!              * }
{ ---------------------------------------------------------------------------- }

unit DPrefix_fmWhActions; // GUI

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, Grids, DBGrids, DB, DBCtrls, ExtCtrls, StdCtrls,
  utPanFrm, updateOk, tpAction, toolbar, tpCompPanel, restorer, tpStatus,
  webTypes, webLink, webCall, webLogin, wbdeSource, wdbLink, wdbScan, wbdeGrid,
  wdbForm, wbdePost, wdbSSrc, System.Actions, Vcl.ActnList;

type
  TfmWhActions = class(TutParentForm)
    ToolBar: TtpToolBar;
    tpComponentPanel2: TtpComponentPanel;
    Panel1: TPanel;
    wdsManPref: TwhbdeSource;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    tpStatusBar1: TtpStatusBar;
    ManPref: TwhdbScan;
    tpToolButton1: TtpToolButton;
    GroupBox3: TGroupBox;
    waPrefixLink: TwhWebActionEx;
    GroupBox4: TGroupBox;
    waModify: TwhWebActionEx;
    GroupBox6: TGroupBox;
    waAdminDelete: TwhWebActionEx;
    tpToolButton3: TtpToolButton;
    tpToolButton5: TtpToolButton;
    ActionList1: TActionList;
    ActCleanURL: TAction;
    Act1stLetter: TAction;
    ActUpcaseStatus: TAction;
    ActDeleteStatusD: TAction;
    ActCreateIndices: TAction;
    cbShowOnlyPending: TCheckBox;
    ActCountPending: TAction;
    ActCheckURLs: TAction;
    ActAssignPasswords: TAction;
    ActExportToCSV: TAction;
    procedure ManPrefInit(Sender: TObject);
    procedure ManPrefRowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure ManPrefFinish(Sender: TObject);
    procedure tpToolButton1Click(Sender: TObject);
    procedure waPrefixLinkExecute(Sender: TObject);
    procedure waModifyExecute(Sender: TObject);
    procedure waAdminDeleteExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Act1stLetterExecute(Sender: TObject);
    procedure ActCleanURLExecute(Sender: TObject);
    procedure ActUpcaseStatusExecute(Sender: TObject);
    procedure ActDeleteStatusDExecute(Sender: TObject);
    procedure ActCreateIndicesExecute(Sender: TObject);
    procedure ActCountPendingExecute(Sender: TObject);
    procedure ActCheckURLsExecute(Sender: TObject);
    procedure ActAssignPasswordsExecute(Sender: TObject);
    procedure ActExportToCSVExecute(Sender: TObject);
    procedure ManPrefExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: boolean; override;
    procedure WebAppOutputClose(Sender: TObject);
    procedure WebCommandLineFrontDoorTriggered(Sender: TwhConnection;
      const ADesiredPageID: string);
  end;

var
  fmWhActions: TfmWhActions = nil;

implementation

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  nxDB,
  IdHTTP,
  DateUtils,
  ucBase64, //encoding and decoding the of the primary key of the component prefix.. not really needed in this case
  ucString, //string utilities, splitstring, startswith, isequal, etc..
  ucFile,   //ForceDirectories insures that a legal path exists
  ucDlgs,   //admin/non-web confirmation questions
  ucShell, ucPos, ucLogFil, ucMsTime, ucCodeSiteInterface,
  webapp,   //access to pWebApp
  webSend, webScan, DPrefix_dmNexus, whutil_ValidEmail, DPrefix_dmWhActions;

{$R *.DFM}

//------------------------------------------------------------------------------

procedure TfmWhActions.Act1stLetterExecute(Sender: TObject);
var
  ACap: string;
begin
  inherited;
  with DMNexus.TableAdmin do
  begin
    First;
    while not EOF do
    begin
      ACap := Uppercase(Copy(FieldByName('Mpf Prefix').AsString, 1, 1));
      if FieldByName('MpfFirstLetter').asString <> ACap then
      begin
        Edit;
        FieldByName('MpfFirstLetter').asString := ACap;
        Post;
      end;
      Next;
    end;
  end;
end;

procedure TfmWhActions.ActAssignPasswordsExecute(Sender: TObject);
var
  AEMail: string;
const
  cLettersDigits = 'zqLvXuX8hZhJlYGq0wcsYUZn2jVKKrQs1AozWqsc3weKnJdA4itkexzcmFBAP94';

  function RandomPasswordString: string;
  var
    i, j, n: Integer;
  begin
    Result := '';
    n := 12; // length of password
    for i := 1 to n do
    begin
      j := Random(61);
      Result := Result + cLettersDigits[Succ(j)];
    end;
  end;
begin
  inherited;
  Randomize;
  with DMNexus.TableAdmin do
  begin
    First;
    while not EOF do
    begin
      AEMail := FieldByName('Mpf EMail').AsString;
      if StrIsEMail(AEMail) then
      begin
        Edit;
        FieldByName('MpfPassToken').asString := RandomPasswordString;
        FieldByName('MpfPassUntil').AsDateTime := IncDay(Now, 10);
        DMNexus.Stamp(DMNexus.TableAdmin, 'htc');
        Post;
      end
      else
      begin
        Edit;
        FieldByName('MpfPassToken').asString := 'no';
        FieldByName('MpfPassUntil').AsDateTime := IncDay(Now, -10);
        DMNexus.Stamp(DMNexus.TableAdmin, 'htc');
        Post;
      end;
      Next;
    end;
  end;
  MsgInfoOk('Done at ' + FormatDateTime('dddd dd-MMM hh:nn', NowGMT));
end;

procedure TfmWhActions.ActCheckURLsExecute(Sender: TObject);
var
  AURL: string;
  iStatusCode: Integer;
  Count: Integer;

  function HTTPGet(const URL: string; out HTTPStatusCode: Integer): string;
  const cFn = 'HTTPGet';
  var
    IdHTTP: TIdHTTP;
  begin
    {$IFDEF CodeSite}CodeSite.EnterMethod(cFn);{$ENDIF}
    CSSend('URL', URL);
    IdHTTP := nil;
    HTTPStatusCode := 0;
    try
      IdHTTP := TIdHTTP.Create(nil);
      IdHTTP.Request.UserAgent := 'HREFTools (http://delphiprefix.href.com/)';
      try
        Result := IdHTTP.Get(URL);
        HTTPStatusCode := IdHTTP.Response.ResponseCode;
      except
        on E: Exception do
        begin
          {$IFDEF CodeSite}
          CodeSite.SendException(E);
          {$ENDIF}
          if Pos('Host not found.', E.Message) > 0 then
            HTTPStatusCode := 500
          else
          begin
            if Assigned(IdHTTP) and Assigned(IdHTTP.Response) then
              HTTPStatusCode := IdHTTP.Response.ResponseCode;
          end;
        end;
      end;
      CSSend('HTTPStatusCode', S(HTTPStatusCode));
      {$IFDEF CodeSite}
      LogToCodeSiteKeepCRLF('Result', Result);
      {$ENDIF}
    finally
      FreeAndNil(IdHTTP);
    end;
    {$IFDEF CodeSite}CodeSite.ExitMethod(cFn);{$ENDIF}
  end;

begin
  inherited;
  Count := 0;
  with DMNexus.TableAdmin do
  begin
    Assert(NOT Filtered);
    First;
    while (not EOF) do // and (Count < 5) do
    begin
      Application.ProcessMessages;
      (*if CheckBox1.Checked then
      begin
        CSSendWarning('break');
        break;
      end;*)
      if (NOT FieldByName('MpfURLStatus').IsNull) then
      begin
        AURL := FieldByName('Mpf WebPage').AsString;
        if AURL <> '' then
        begin
          Inc(Count);
          CSSend('Count', S(Count));
          AURL := 'http://' + AURL;
          HTTPGet(AURL, iStatusCode);
          if iStatusCode > 0 then
          begin
            Edit;
            FieldByName('MpfURLStatus').AsInteger := iStatusCode;
            FieldByName('MpfURLTestOnAt').AsDateTime := NowGMT;
            DMNexus.Stamp(DMNexus.TableAdmin, 'htc');
            Post;
          end;
        end
        else
        begin
          if (NOT FieldByName('MpfURLStatus').IsNull) and
            (FieldByName('MpfURLStatus').AsInteger <> -1) then
          begin
            Edit;
            FieldByName('MpfURLStatus').AsInteger := -1;
            FieldByName('MpfURLTestOnAt').AsDateTime := NowGMT;
            DMNexus.Stamp(DMNexus.TableAdmin, 'htc');
            Post;
          end;
        end;
      end;
      Next;
    end;
  end;

end;

procedure TfmWhActions.ActCleanURLExecute(Sender: TObject);
var
  AURL: string;
begin
  inherited;
  with DMNexus.TableAdmin do
  begin
    Assert(NOT Filtered);
    First;
    while not EOF do
    begin
      AURL := FieldByName('Mpf WebPage').AsString;
      if Copy(AURL, 1, 7) = 'http://' then
      begin
        Edit;
        FieldByName('Mpf WebPage').asString := Copy(AURL, 8, MaxInt);
        Post;
      end;
      Next;
    end;
  end;
end;

procedure TfmWhActions.ActCountPendingExecute(Sender: TObject);
begin
  inherited;
  MsgInfoOk('Number Pending = ' + IntToStr(DMNexus.CountPending));
end;

procedure TfmWhActions.ActCreateIndicesExecute(Sender: TObject);
begin
  inherited;
  DMNexus.TableAdmin.Close;
  DMNexus.Table1.Close;
  try
    DMNexus.Table1.DeleteIndex('Prefix');
  except
    on E: Exception do
    begin
      LogSendException(E);
    end;
  end;
  DMNexus.Table1.AddIndex('Prefix', 'Mpf Prefix', [], 'Mpf Prefix');
  MsgInfoOk('Prefix index has been created');
  (*try
    DMNexus.Table1.DeleteIndex('MpfID');
  except
    on E: Exception do
    begin
      LogSendException(E);
    end;
  end;*)
  // NexusDB does not allow deletion when there is a primary key ??!!
  //DMNexus.Table1.AddIndex('MpfID', 'MpfID', [ixPrimary, ixUnique], '', '', True);
  MsgInfoOk('Indexing complete.');
  DMNexus.TableAdmin.Open;
  DMNexus.Table1.Open;
end;

procedure TfmWhActions.ActDeleteStatusDExecute(Sender: TObject);
var
  AStatus: string;
  n: Integer;
begin
  inherited;
  n := 0;
  with DMNexus.TableAdmin do
  begin
    Assert(NOT Filtered);
    First;
    while not EOF do
    begin
      AStatus := FieldByName('Mpf Status').AsString;
      if AStatus = 'D' then
      begin
        Delete;
        Inc(n);
      end
      else
        Next;
    end;
  end;
  MsgInfoOk('Deleted ' + IntToStr(n) + ' records');
end;

type TMarketingRec = record
  Contact: string;
  Company: string;
  Package: string;
  Prefix: string;
  FirstLetter: string;
  Webpage: string;
  email: string;
  RegisteredOn: TDateTime;
  URLStatus: Integer;
  URLTestOnAt: TDateTime;
  PassToken: string;
  PassUntil: TDateTime;
  Beneficiary: string;
end;

procedure TfmWhActions.ActExportToCSVExecute(Sender: TObject);
var
  Data: TMarketingRec;
  Filespec8, Filespec16: string;
  CSVContents: string;

  function QthenTab(const S1: string): string;
  begin
    Result := '"' + S1 + '"' + #9;
  end;

begin
  inherited;
  Filespec8 := 'd:\DelphiPrefixRegistry_Marketing.utf8.csv';
  Filespec16 := 'd:\DelphiPrefixRegistry_Marketing.utf16.csv';
  CSVContents := '';
  with DMNexus.TableAdmin do
  begin
    First;
    while not EOF do
    begin
      Data.EMail := FieldByName('Mpf EMail').AsString;
      if StrIsEMail(Data.EMail) then
      begin
        Data.PassToken := FieldByName('MpfPassToken').asString;
        Data.PassUntil := FieldByName('MpfPassUntil').AsDateTime;
        Data.Contact := FieldByName('Mpf Contact').asString;
        Data.Package := FieldByName('Mpf Package Name').AsString;
        Data.Prefix := FieldByName('Mpf Prefix').AsString;
        Data.FirstLetter := FieldByName('MpfFirstLetter').AsString;
        Data.Webpage := FieldByName('Mpf Webpage').AsString;
        Data.RegisteredOn :=
          FieldByName('Mpf Date Registered').AsDateTime;
        //Data.RegisteredOn := StrToDateDef(
        //  FieldByName('Mpf Date Registered').AsString, IncDay(Now, -(113*365)));
        Data.URLStatus := FieldByName('MpfURLStatus').AsInteger;
        Data.URLTestOnAt := FieldByName('MpfURLTestOnAt').AsDateTime;
        if Data.Package <> '' then
          Data.Beneficiary := Data.Package
        else
        if Data.Company <> '' then
          Data.Beneficiary := Data.Company
        else
          Data.Beneficiary := Data.Contact;
        CSVContents := CSVContents +
          QthenTab(Data.Email) +
          QthenTab(FormatDateTime('dd-MMM-yyyy', data.RegisteredOn)) +
          QthenTab(Data.Contact) +
          QthenTab(Data.Company) +
          QthenTab(Data.Package) +
          QthenTab(Data.Prefix) +
          QthenTab(Data.FirstLetter) +
          QthenTab(Data.WebPage) +
          QthenTab(Data.Beneficiary) +
          QthenTab(IntToStr(data.URLStatus)) +
          QthenTab(FormatDateTime('dd-MMM-yyyy hh:nn', data.URLTestOnAt) + ' gmt') +
          QthenTab(Data.PassToken) +
          QthenTab(FormatDateTime('dd-MMM-yyyy hh:nn', data.PassUntil) + ' gmt') +
          sLineBreak;
      end;
      Next;
    end;
  end;
  UTF8StringWriteToFile(Filespec8, UTF8String(CSVContents));
  StringWriteToFile(Filespec16, CSVContents);
  MsgInfoOk('Done at ' + FormatDateTime('dddd dd-MMM hh:nn', NowGMT));
end;

procedure TfmWhActions.ActUpcaseStatusExecute(Sender: TObject);
var
  AStatus: string;
  n: Integer;
begin
  inherited;
  n := 0;
  with DMNexus.TableAdmin do
  begin
    Assert(NOT Filtered);
    First;
    while not EOF do
    begin
      AStatus := FieldByName('Mpf Status').AsString;
      if AStatus <> Uppercase(AStatus) then
      begin
        Edit;
        FieldByName('Mpf Status').asString := Uppercase(AStatus);
        Post;
        Inc(n);
      end;
      Next;
    end;
  end;
  MsgInfoOk('Cleaned ' + IntToStr(n) + ' records');
end;

procedure TfmWhActions.FormDestroy(Sender: TObject);
begin
  inherited;
  fmWhActions := nil;
end;

//------------------------------------------------------------------------------

function TfmWhActions.Init: boolean;
begin
  Result := inherited Init;
  if Result then
  begin
    wdsManPref.KeyFieldNames := 'MpfID';
    DataSource1.DataSet := DMNexus.Table1;

    ManPref.ButtonsWhere := dsNone;
    ManPref.PageHeight := 115;  // max for single letter as of 11-Dec-2008 AML
    ManPref.ControlsWhere := dsNone;
  end;
  RefreshWebActions(Self);
end;

procedure TfmWhActions.ManPrefInit(Sender: TObject);
const cFn = 'ManPrefInit';
var
  dropletName: string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  with TwhdbScan(Sender) do
  begin
    // HtmlParam is used to differentiate one grid from another.
    // e.g. %=manPref.execute|Approved=%
    dropletName := 'Scan' + HtmlParam;
    WebApp.SendDroplet(dropletName, drBeforeWhrow);
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TfmWhActions.ManPrefRowStart(Sender:TwhdbScanBase;
  aWebDataSource:TwhdbSourceBase; var ok:Boolean);
begin
  inherited;
  with Sender do
    WebApp.SendDroplet('Scan'+HtmlParam, drWithinWhrow);
end;

procedure TfmWhActions.ManPrefExecute(Sender: TObject);
const cFn = 'ManPrefExecute';
var
  DropletKeyword: string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  CSSend('PageID', pWebApp.PageID);
  DropletKeyword := ManPref.HtmlParam;
  CSSend('DropletKeyword', DropletKeyword);
  if DropletKeyword = 'Maintain' then
    DMNexus.Table1OnlyMaintain
  else
    DMNexus.Table1OnlyApproved;
  //WebDBAlphabet.Execute;  // repeat the GotoNearest step after filter change!
  if Assigned(ManPref) and Assigned(ManPref.WebDataSource) then
    CSSend('DataSetIsActive', S(ManPref.WebDataSource.DataSetIsActive));
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TfmWhActions.ManPrefFinish(Sender: TObject);
begin
  inherited;
  with TwhdbScan(Sender) do
    WebApp.SendDroplet('Scan'+HtmlParam, drAfterWhrow);
end;

procedure TfmWhActions.WebAppOutputClose(Sender: TObject);
begin
  inherited;
  // be careful not to add something to ALL pages that is only suitable for SOME pages
end;

procedure TfmWhActions.tpToolButton1Click(Sender: TObject);
begin
  inherited;
  //use dis/en-ablecontrols!
  with DBGrid1 do
    if DataSource=nil then
    begin
      DataSource:=DMDPRWebAct.dsAdmin;
      DBNavigator1.DataSource:=DMDPRWebAct.dsAdmin;
      if cbShowOnlyPending.Checked then
        DMNexus.TableAdminOnlyPending
      else
        DMNexus.TableAdminUnfiltered;
    end
    else
    begin
      DMDPRWebAct.dsAdmin.DataSet.Filtered := False;
      DMDPRWebAct.dsAdmin.DataSet.OnFilterRecord := nil;
      DataSource:=nil;
      DBNavigator1.DataSource:=nil;
    end;
end;


procedure TfmWhActions.waPrefixLinkExecute(Sender: TObject);
var
  a1,a2:string;
begin
  inherited;
  with TwhWebActionEx(Sender) do
  begin
    with wdsManPref.DataSet do
    begin
      a1:=fieldByName('MpfID').asString;
      a2:=fieldByName('Mpf Prefix').asString;
      end;
    WebApp.SendMacro('JUMP|pgEdit,'
      +'webdataform.edit.'+Code64String(a1)+'|'+a2);
    end;
end;

procedure TfmWhActions.waModifyExecute(Sender: TObject);
//field-data comes in looking like this: wdsAdmin.Mpf Status@46=A
var
  a1,aKey,aFieldname:string;
  i,iKey:integer;
begin
  inherited;
  iKey:=-1; //
  with TwhWebActionEx(Sender), DMDPRWebAct.wdsAdmin, DataSet do
  begin
    for i:=0 to pred(pWebApp.Request.dbFields.count) do
      if SplitString(LeftOfEqual(pWebApp.Request.dbFields[i]),'@',a1,aKey)
      and SplitString(a1,'.',a1,aFieldname)
      and IsEqual(a1,'wdsAdmin') then begin
        if iKey=-1 then begin
          iKey:=StrToIntDef(aKey,-1);
          if not Locate('MpfID',iKey,[]) then
            raise exception.create('no such MpfID '+aKey);
          Edit;
          end;
        FieldByName(aFieldName).asString:=
          RightOfEqual(pWebApp.Request.dbFields[i]);
        end;
    //if editmode then
    Post;
    //!!!Flush(TnxTable(DataSet));
    end;
end;

procedure TfmWhActions.waAdminDeleteExecute(Sender: TObject);
begin
  inherited;
  with TnxQuery.create(nil) do
  try
    Database:=DMNexus.nxDatabase1;
    sql.text:='DELETE'
      +' FROM Manpref'
      +' WHERE ("Mpf Status" = ''D'')';
    ExecSql;
  finally
    free;
    end;
end;

//------------------------------------------------------------------------------

procedure TfmWhActions.WebCommandLineFrontDoorTriggered(Sender: TwhConnection;
  const ADesiredPageID: string);
begin
  if (pWebApp.SessionNumber = pWebApp.WebRobotSession) and
    SameText(aDesiredPageID, 'pgWebEye') then
    pWebApp.PageID := aDesiredPageID;  // this reroutes the request to run aDesiredPageID
end;

//------------------------------------------------------------------------------

end.
