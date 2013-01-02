unit webactns; // custom web actions for the DPR program.

/////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1999-2003 HREF Tools Corp.  All Rights Reserved.         //
//  Author: Ann Lynnworth @HREF                                 March 1999 //
/////////////////////////////////////////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UTPANFRM, ExtCtrls, StdCtrls, TpMenu, UpdateOk, tpAction, IniLink,
  Toolbar, tpCompPanel, Restorer, ComCtrls, tpStatus, WebTypes, WebLink,
  DBCtrls, Grids, DBGrids, Db, DBTables, wbdeSource, WdbLink, WdbScan,
  wbdeGrid, WDBAlpha, Buttons, WebLogin, wbdeForm, wbdePost, TpShell;

type
  TfmAppDataScan = class(TutParentForm)
    ToolBar: TtpToolBar;
    dm: TtpDataModule;{}
    tpComponentPanel2: TtpComponentPanel;
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
    WindowsShell1: TWindowsShell;
    waAdminDelete: TwhWebActionEx;
    procedure ManPrefInit(Sender: TObject);
    procedure ManPrefRowStart(Sender: TwhdbScan;
      aWebDataSource: TwhbdeSource; var ok: Boolean);
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
    procedure WebCommandLineFrontDoorTriggered(Sender: TObject);
  end;

var
  fmAppDataScan: TfmAppDataScan;

implementation

uses
  webapp,   //access to pWebApp which points to the currently active app object for th duration of the page
  ucBase64, //encoding and decoding the of the primary key of the component prefix.. not really needed in this case
  ucString, //string utilities, splitstring, startswith, isequal, etc..
  ucFile,   //ForceDirectories insures that a legal path exists
  ucDlgs,   //admin/non-web confirmation questions 
  BDE,      //Copy and Flush Tables
  DBConsts;  //Copy and Flush Tables

const
  cManPrefDatabase='ManPrefDatabase';

{$R *.DFM}

//------------------------------------------------------------------------------

procedure TfmAppDataScan.FormCreate(Sender: TObject);
begin
  inherited;
  WebDBAlphabet := TWebDBAlphabet.Create(TForm(Sender));
  with WebDBAlphabet do
  begin
    Name := 'WebDBAlphabet';
    WebDataSource := wdsManPref;
    if Assigned(pWebApp) then
    begin
      WebIni := pWebApp.WebIni;
      // let the webmaster adjust the # of alphabet letters on a row.
      NumPerRow:=StrToIntDef(pWebApp.AppDefault['AlphaLetters'],26);
    end;
    Refresh;
  end;
end;

procedure TfmAppDataScan.FormDestroy(Sender: TObject);
begin
  inherited;
  WebDBAlphabet.Free;
  WebDBAlphabet := nil;
end;

//------------------------------------------------------------------------------

function TfmAppDataScan.Init:Boolean;
var
  a1:string;
begin
  Result:= inherited Init;
  if not result then
    exit;
  with Table1 do begin
    close;
    a1:=pWebApp.AppDefault[cManPrefDatabase];
    databasename:=a1;
    filtered:=true;
    open;
    end;
  with TableAdmin do begin
    close;
    a1:=pWebApp.AppDefault[cManPrefDatabase];
    databasename:=a1;
    filtered:=false;
    open;
    end;
end;

//------------------------------------------------------------------------------

procedure TfmAppDataScan.ManPrefInit(Sender: TObject);
begin
  inherited;
  with TwhdbScan(Sender) do
    // HtmlParam is used to differentiate one grid from another.
    // e.g. %=manPref.execute|Approved=%
    WebApp.SendMacro('Scan'+HtmlParam+'Init');
end;

procedure TfmAppDataScan.ManPrefRowStart(Sender:TwhdbScan;aWebDataSource:TwhbdeSource;var ok:Boolean);
begin
  inherited;
  with Sender do
    WebApp.SendMacro('Scan'+HtmlParam+'Row');
end;

procedure TfmAppDataScan.ManPrefFinish(Sender: TObject);
begin
  inherited;
  with TwhdbScan(Sender) do
    WebApp.SendMacro('Scan'+HtmlParam+'Finish');
end;

procedure TfmAppDataScan.Table1FilterRecord(DataSet:TDataSet; var Accept:Boolean);
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

procedure TfmAppDataScan.WebAppOutputClose(Sender: TObject);
begin
  inherited;
  pWebApp.Response.Headers.Add('Cache-Control: no-cache');
end;

procedure TfmAppDataScan.tpToolButton1Click(Sender: TObject);
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


procedure TfmAppDataScan.waPrefixLinkExecute(Sender: TObject);
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

procedure TfmAppDataScan.WebDataFormSetCommand(Sender:TObject;var Command:String);
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

procedure TfmAppDataScan.tpToolButton2Click(Sender: TObject);
var
  i:integer;
begin
  //concept code... disabled for your own good.
  exit;
  //
  if NOT askQuestionOk('Are you utterly sure that you want to create new sequential IDs for the primary key field in the ManPref.db?') then
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

procedure TfmAppDataScan.WebDataFormField(Sender:TwhbdeForm;aField:TField;var Text,Value:String);
begin
  inherited;
  // indicate that the primary key is off limits
  if aField.fieldname='MpfID' then begin
    text:='ID*';
    value:='<b><font color="#666667">'+aField.asString+'</font></b>';
    end;
end;

procedure TfmAppDataScan.waModifyExecute(Sender: TObject);
//field-data comes in looking like this: wdsAdmin.Mpf Status@46=A
var
  a1,aKey,aFieldname:string;
  i,iKey:integer;
begin
  inherited;
  iKey:=-1; //
  with TwhWebActionEx(Sender), wdsAdmin, TTable(DataSet) do begin
    for i:=0 to pred(webserver.dbFields.count) do
      if SplitString(LeftOfEqual(webserver.dbFields[i]),'@',a1,aKey)
      and SplitString(a1,'.',a1,aFieldname)
      and IsEqual(a1,'wdsAdmin') then begin
        if iKey=-1 then begin
          iKey:=StrToIntDef(aKey,-1);
          if not Locate('MpfID',iKey,[]) then
            raise exception.create('no such MpfID '+aKey);
          Edit;
          end;
        FieldByName(aFieldName).asString:=RightOfEqual(webserver.dbFields[i]);
        end;
    //if editmode then
    Post;
    Flush(TTable(DataSet));
    end;
end;

procedure TfmAppDataScan.waAddExecute(Sender: TObject);
var
  PriorIndex, aFieldname:string;
  i,iKey:integer;
begin
  inherited;
  //example literal syntax: Mpf EMail=info@href.com
  with TwhWebActionEx(Sender), Table1 do begin
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
    FieldByName('Mpf Notes').asString:=Session.TxtVars.List['txtComment'].text;
    for i:=0 to pred(Session.StringVars.count) do begin
      aFieldName:=LeftOfEqual(Session.StringVars[i]);
      if StartsWith(aFieldName,'Mpf ') //ucstring
      and (FindField(aFieldName)<>nil) then
        FieldByName(aFieldName).asString:=RightOfEqual(Session.StringVars[i]);
      end;
    Post;
    Flush(Table1);
    IndexName:= PriorIndex;
    Filtered:=true;
    end;
end;

procedure TfmAppDataScan.waAdminDownloadExecute(Sender: TObject);
var
  aTargetDir:string;
begin
  inherited;
  with TwhWebActionEx(Sender) do begin
    aTargetDir:=TrailingBackSlash(WebApp.AppDefault[cManPrefDatabase])+'admin\';
    ForceDirectories(aTargetDir);
    //
    CopyTable(table1,aTargetDir+'manpref.db');
    with WindowsShell1 do begin
      Command:='pkzip.exe';
      Parameters:=TrailingBackSlash(WebApp.AppDefault['ManPrefAdminZipDir'])
        +'mpfadmin.zip'
        +' '+aTargetDir+'manpref.*'
        +' -o';
      Flags:=[shlWaitTillDone];
      Execute;
      end;
    end;
end;

procedure TfmAppDataScan.waAdminDeleteExecute(Sender: TObject);
begin
  inherited;
  with TQuery.create(nil) do try
    Databasename:=pWebApp.AppDefault[cManPrefDatabase];
    sql.text:='DELETE'
      +' FROM "Manpref.db"'
      +' WHERE ("Manpref.db"."Mpf Status" = ''D'')';
    ExecSql;
  finally
    free;
    end;
end;

//------------------------------------------------------------------------------

procedure TfmAppDataScan.Flush(tbl:TTable);
begin
  with tbl do
    if State = dsBrowse then
      Check(DbiSaveChanges(Handle)); //table.handle
end;

procedure TfmAppDataScan.CopyTable(srcTbl:TTable; const Destination: string);
var
  szCopyFrom,
  szCopyTo: DBITBLNAME;
begin
  with srcTbl do begin
    if State = dsInactive then
      DatabaseError(SDataSetClosed);
    LockTable(ltReadLock);
    try
      AnsiToNative(Locale, Destination, szCopyTo, sizeof(szCopyTo)-1);
      AnsiToNative(Locale, TableName, szCopyFrom, sizeof(szCopyFrom)-1);
      Check(DbiCopyTable(Database.Handle, True, szCopyFrom, nil, szCopyTo));
    finally
      UnLockTable(ltReadLock);
      end;
    end;
end;

//------------------------------------------------------------------------------

procedure TfmAppDataScan.WebCommandLineFrontDoorTriggered(Sender: TObject);
var 
  aDesiredPage:string;  begin
  inherited;
  aDesiredPage := pWebApp.Session.PriorPageID;  // this is the page the user agent requested
  if (pWebApp.Session = pWebApp.WebRobotSession) and
    AnsiSameText(aDesiredPage,'pgWebEye') then
    pWebApp.PageID := aDesiredPage;  // this reroutes the request to run aDesiredPage
end;

//------------------------------------------------------------------------------

end.
