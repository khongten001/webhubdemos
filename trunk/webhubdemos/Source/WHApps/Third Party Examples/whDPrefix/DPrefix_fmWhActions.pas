/////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1999-2012 HREF Tools Corp.  All Rights Reserved.         //
//  Author: Ann Lynnworth                                       March 1999 //
/////////////////////////////////////////////////////////////////////////////

unit DPrefix_fmWhActions; // custom web actions for the Delphi Prefix program.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UTPANFRM, ExtCtrls, StdCtrls, TpMenu, UpdateOk, tpAction, IniLink,
  Toolbar, tpCompPanel, Restorer, ComCtrls, tpStatus, WebTypes, WebLink,
  DBCtrls, Grids, DBGrids, Db, DBTables, wbdeSource, WdbLink, WdbScan,
  webCall,
  wbdeGrid, wdbAlpha, Buttons, WebLogin, wbdeForm, wbdePost, wdbSSrc;

type
  TfmWhActions = class(TutParentForm)
    ToolBar: TtpToolBar;    tpComponentPanel2: TtpComponentPanel;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    wdsManPref: TwhbdeSource;
    DataSource1: TDataSource;
    Table1: TTable;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    tpStatusBar1: TtpStatusBar;
    ManPref: TwhdbScan;
    tpToolButton1: TtpToolButton;
    GroupBox3: TGroupBox;
    WebLogin: TwhLogin;
    waPrefixLink: TwhWebActionEx;
    GroupBox4: TGroupBox;
    WebDataForm: TwhbdeForm;
    waModify: TwhWebActionEx;
    tpToolButton2: TtpToolButton;
    GroupBox5: TGroupBox;
    wdsAdmin: TwhbdeSource;
    dsAdmin: TDataSource;
    TableAdmin: TTable;
    waAdd: TwhWebActionEx;
    GroupBox6: TGroupBox;
    waAdminDownload: TwhWebActionEx;
    waAdminDelete: TwhWebActionEx;
    procedure ManPrefInit(Sender: TObject);
    procedure ManPrefRowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure ManPrefFinish(Sender: TObject);
    procedure Table1FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure tpToolButton1Click(Sender: TObject);
    procedure waPrefixLinkExecute(Sender: TObject);
    procedure WebDataFormSetCommand(Sender: TObject; var Command: String);
    procedure tpToolButton2Click(Sender: TObject);
    procedure WebDataFormField(Sender: TwhbdeForm; aField: TField;
      var Text, Value: String);
    procedure waModifyExecute(Sender: TObject);
    procedure waAddExecute(Sender: TObject);
    procedure waAdminDownloadExecute(Sender: TObject);
    procedure waAdminDeleteExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure CopyTable(srcTbl:TTable; const Destination: string);
    procedure Flush(tbl:TTable);
  public
    { Public declarations }
    WebDBAlphabet: TWebDBAlphabet;
    function Init: Boolean; override;
    procedure WebAppOutputClose(Sender: TObject);
    procedure WebCommandLineFrontDoorTriggered(Sender: TwhConnection;
      const ADesiredPageID: string);
  end;

var
  fmWhActions: TfmWhActions = nil;

implementation

uses
  BDE,      //Copy and Flush Tables
  DBConsts,  //Copy and Flush Tables
  ucBase64, //encoding and decoding the of the primary key of the component prefix.. not really needed in this case
  ucString, //string utilities, splitstring, startswith, isequal, etc..
  ucFile,   //ForceDirectories insures that a legal path exists
  ucDlgs,   //admin/non-web confirmation questions
  ucShell,
  ucLogFil,
  webapp,   //access to pWebApp which points to the currently active app object for th duration of the page
  webScan;

const
  cManPrefDatabase='ManPrefDatabase';

{$R *.DFM}

//------------------------------------------------------------------------------

procedure TfmWhActions.FormCreate(Sender: TObject);
begin
  inherited;
  WebDBAlphabet := TWebDBAlphabet.Create(TForm(Sender));
  with WebDBAlphabet do
  begin
    Name := 'WebDBAlphabet';
    WebDataSource := wdsManPref;
    if Assigned(pWebApp) then
    begin
      (* off v2.054 31-Mar-2006 WebIni := pWebApp.WebIni; *)
      // let the webmaster adjust the # of alphabet letters on a row.
      NumPerRow:=StrToIntDef(pWebApp.AppSetting['AlphaLetters'],26);
    end;
    Refresh;
  end;
end;

procedure TfmWhActions.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(WebDBAlphabet);
  fmWhActions := nil;
end;

//------------------------------------------------------------------------------

function TfmWhActions.Init:Boolean;
var
  a1:string;
begin
  Result:= inherited Init;
  if not result then
    exit;
  with Table1 do begin
    close;
    a1:=pWebApp.AppSetting[cManPrefDatabase];
    databasename:=a1;
    filtered:=true;
    open;
    end;
  with TableAdmin do begin
    close;
    a1:=pWebApp.AppSetting[cManPrefDatabase];
    databasename:=a1;
    filtered:=false;
    open;
    end;
  ManPref.ButtonsWhere := dsNone;
  ManPref.PageHeight := 115;  // max for single letter as of 11-Dec-2008 AML
  ManPref.ControlsWhere := dsNone;
end;

//------------------------------------------------------------------------------

procedure TfmWhActions.ManPrefInit(Sender: TObject);
begin
  inherited;
  with TwhdbScan(Sender) do
    // HtmlParam is used to differentiate one grid from another.
    // e.g. %=manPref.execute|Approved=%
    WebApp.SendMacro('Scan'+HtmlParam+'Init');
end;

procedure TfmWhActions.ManPrefRowStart(Sender:TwhdbScanBase;
  aWebDataSource:TwhdbSourceBase; var ok:Boolean);
begin
  inherited;
  with Sender do
    WebApp.SendMacro('Scan'+HtmlParam+'Row');
end;

procedure TfmWhActions.ManPrefFinish(Sender: TObject);
begin
  inherited;
  with TwhdbScan(Sender) do
    WebApp.SendMacro('Scan'+HtmlParam+'Finish');
end;

procedure TfmWhActions.Table1FilterRecord(DataSet:TDataSet; var Accept:Boolean);
var
  aStatus: String;
begin
  inherited;
  //improvements to do:
  //get the checked values before the scan (onexecute) and put them into vars.
  //use pre-instantiated fields or get a field pointer ahead of time
  with pWebApp do
  begin
    aStatus := UpperCase(DataSet.FieldByName('Mpf Status').asString);
    if BoolVar['_bAdminMode'] then
      if BoolVar['bShowAll'] then
        Accept:=true
      else
        Accept:=(aStatus='P')  //pending
    else
      Accept:=(aStatus='A');   //approved
  end;
end;

procedure TfmWhActions.WebAppOutputClose(Sender: TObject);
begin
  inherited;
  pWebApp.Response.Headers.Add('Cache-Control: no-cache');
end;

procedure TfmWhActions.tpToolButton1Click(Sender: TObject);
begin
  inherited;
  //use dis/en-ablecontrols!
  with DBGrid1 do
    if DataSource=nil then begin
      DataSource:=DataSource1;
      DBNavigator1.DataSource:=DataSource1;
      end
    else begin
      DataSource:=nil;
      DBNavigator1.DataSource:=nil;
      end;
end;


procedure TfmWhActions.waPrefixLinkExecute(Sender: TObject);
var
  a1,a2:string;
begin
  inherited;
  with TwhWebActionEx(Sender) do begin
    with TTable(wdsManPref.DataSet) do begin
      a1:=fieldByName('MpfID').asString;
      a2:=fieldByName('Mpf Prefix').asString;
      end;
    WebApp.SendMacro('JUMP|pgEdit,'
      +'webdataform.edit.'+Code64String(a1)+'|'+a2);
    end;
end;

procedure TfmWhActions.WebDataFormSetCommand(Sender:TObject;var Command:String);
var
  a1:string;
begin
  inherited;
  SplitString(Command,'.',Command,a1);
  a1:=Uncode64String(a1);
  with pWebApp.Response, TTable(wdsAdmin.DataSet) do
    if Locate('MpfID',StrToIntDef(a1,-1),[]) then
      SendComment('found ok')
    else
      SendHdr('2','Error - prefix '+a1+' not found.');
  // edit.key syntax does not work in v1.713 version of wbdeForm.pas. AML 22-Mar-1999
  //a1:=Command+'.'+a1;
  //Command:=a1;
end;

procedure TfmWhActions.tpToolButton2Click(Sender: TObject);
var
  i:integer;
begin
  //concept code... disabled for your own good.
  exit;
  //
  if NOT askQuestionOk('Are you utterly sure that you want to create new ' +
   'sequential IDs for the primary key field in the ManPref.db?') then
    exit;
  with table1 do begin
    filtered:=false;
    i:=1;
    while true do begin
      first;
      if fields[0].asInteger>0 then break;
      edit;
      fields[0].asInteger:=i;
      inc(i);
      post;
      end;
    flush(table1);
    filtered:=true;
    end;
end;

procedure TfmWhActions.WebDataFormField(Sender:TwhbdeForm;aField:TField;var Text,Value:String);
begin
  inherited;
  // indicate that the primary key is off limits
  if aField.fieldname='MpfID' then begin
    text:='ID*';
    value:='<b><font color="#666667">'+aField.asString+'</font></b>';
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
  with TwhWebActionEx(Sender), wdsAdmin, TTable(DataSet) do begin
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
        FieldByName(aFieldName).asString:=RightOfEqual(pWebApp.Request.dbFields[i]);
        end;
    //if editmode then
    Post;
    Flush(TTable(DataSet));
    end;
end;

procedure TfmWhActions.waAddExecute(Sender: TObject);
var
  PriorIndex, aFieldname:string;
  i,iKey:integer;
begin
  inherited;
  //example literal syntax: Mpf EMail=info@href.com
  with TwhWebActionEx(Sender), Table1 do
  begin
    Filtered:=false;
    //if IndexName<>'' then begin
    //close;
    PriorIndex:=IndexName;
    IndexName:='';  // must be by primary key to get next id
    //open;
    //end;
    Last;
    iKey:=fieldByName('MpfID').asInteger+1; //autoinc would help..
    Append;
    FieldByName('MpfID').asInteger:=iKey;
    FieldByName('Mpf Status').asString:='P';
    FieldByName('Mpf Date Registered').asDateTime:=now;
    FieldByName('Mpf Notes').asString :=
      pWebApp.Session.TxtVars.List['txtComment'].text;
    for i:=0 to pred(pWebApp.Session.StringVars.count) do begin
      aFieldName:=LeftOfEqual(pWebApp.Session.StringVars[i]);
      if StartsWith(aFieldName,'Mpf ') //ucstring
      and (FindField(aFieldName)<>nil) then
        FieldByName(aFieldName).asString :=
          RightOfEqual(pWebApp.Session.StringVars[i]);
      end;
    Post;
    Flush(Table1);
    IndexName:= PriorIndex;
    Filtered:=true;
    end;
end;

procedure TfmWhActions.waAdminDownloadExecute(Sender: TObject);
var
  aTargetDir: string;
  commandstr, parameters: string;
  ErrorMessage: string;
begin
  inherited;
  with TwhWebActionEx(Sender) do
  begin
    aTargetDir:=TrailingBackSlash(WebApp.AppSetting[cManPrefDatabase])+'admin\';
    ForceDirectories(aTargetDir);
    //
    CopyTable(table1,aTargetDir+'manpref.db');
    Commandstr := 'pkzip.exe';
    Parameters:=TrailingBackSlash(WebApp.AppSetting['ManPrefAdminZipDir'])
        +'mpfadmin.zip'
        +' '+aTargetDir+'manpref.*'
        +' -o';
    Launch(Commandstr, Parameters, '', False, 30000, ErrorMessage);
    if ErrorMessage <> '' then
    begin
      tpLogMessage(ErrorMessage);
      Response.Send(ErrorMessage);
    end;
  end;
end;

procedure TfmWhActions.waAdminDeleteExecute(Sender: TObject);
begin
  inherited;
  with TQuery.create(nil) do try
    Databasename:=pWebApp.AppSetting[cManPrefDatabase];
    sql.text:='DELETE'
      +' FROM "Manpref.db"'
      +' WHERE ("Manpref.db"."Mpf Status" = ''D'')';
    ExecSql;
  finally
    free;
    end;
end;

//------------------------------------------------------------------------------

procedure TfmWhActions.Flush(tbl:TTable);
begin
  with tbl do
    if State = dsBrowse then
      Check(DbiSaveChanges(Handle)); //table.handle
end;

procedure TfmWhActions.CopyTable(srcTbl:TTable; const Destination: string);
var
  szCopyFrom,
  szCopyTo: DBITBLNAME;
begin
  with srcTbl do begin
    if State = dsInactive then
      DatabaseError(SDataSetClosed);
    LockTable(ltReadLock);
    try
      AnsiToNative(Locale, AnsiString(Destination), szCopyTo,
        sizeof(szCopyTo)-1);
      AnsiToNative(Locale, AnsiString(TableName), szCopyFrom,
        sizeof(szCopyFrom)-1);
      Check(DbiCopyTable(Database.Handle, True, szCopyFrom, nil, szCopyTo));
    finally
      UnLockTable(ltReadLock);
      end;
    end;
end;

//------------------------------------------------------------------------------

procedure TfmWhActions.WebCommandLineFrontDoorTriggered(Sender: TwhConnection;
  const ADesiredPageID: string);
begin
  //aDesiredPage := pWebApp.Session.PriorPageID;  // this is the page the user agent requested
  if (pWebApp.SessionNumber = pWebApp.WebRobotSession) and
    AnsiSameText(aDesiredPageID, 'pgWebEye') then
    pWebApp.PageID := aDesiredPageID;  // this reroutes the request to run aDesiredPageID
end;

//------------------------------------------------------------------------------

end.
