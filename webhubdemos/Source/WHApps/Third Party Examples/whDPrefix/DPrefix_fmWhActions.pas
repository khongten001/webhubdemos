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

unit DPrefix_fmWhActions; // custom web actions with GUI

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, Grids, DBGrids, DB, DBCtrls, ExtCtrls, StdCtrls,
  utPanFrm, updateOk, tpAction, toolbar, tpCompPanel, restorer, tpStatus,
  webTypes, webLink, webCall, webLogin, wbdeSource, wdbLink, wdbScan, wbdeGrid,
  wnxdbAlpha,
  wbdeForm, wbdePost, wdbSSrc, System.Actions, Vcl.ActnList;

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
    WebLogin: TwhLogin;
    waPrefixLink: TwhWebActionEx;
    GroupBox4: TGroupBox;
    WebDataForm: TwhbdeForm;
    waModify: TwhWebActionEx;
    tpToolButton2: TtpToolButton;
    GroupBox5: TGroupBox;
    wdsAdmin: TwhbdeSource;
    dsAdmin: TDataSource;
    waAdd: TwhWebActionEx;
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
    procedure ManPrefInit(Sender: TObject);
    procedure ManPrefRowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure ManPrefFinish(Sender: TObject);
    procedure tpToolButton1Click(Sender: TObject);
    procedure waPrefixLinkExecute(Sender: TObject);
    procedure WebDataFormSetCommand(Sender: TObject; var Command: String);
    procedure tpToolButton2Click(Sender: TObject);
    procedure WebDataFormField(Sender: TwhbdeForm; aField: TField;
      var Text, Value: String);
    procedure waModifyExecute(Sender: TObject);
    procedure waAddExecute(Sender: TObject);
    procedure waAdminDeleteExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Act1stLetterExecute(Sender: TObject);
    procedure ActCleanURLExecute(Sender: TObject);
    procedure ActUpcaseStatusExecute(Sender: TObject);
    procedure ActDeleteStatusDExecute(Sender: TObject);
    procedure ActCreateIndicesExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    WebDBAlphabet: TWebnxdbAlphabet;
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
  ucBase64, //encoding and decoding the of the primary key of the component prefix.. not really needed in this case
  ucString, //string utilities, splitstring, startswith, isequal, etc..
  ucFile,   //ForceDirectories insures that a legal path exists
  ucDlgs,   //admin/non-web confirmation questions
  ucShell,
  ucLogFil,
  ucCodeSiteInterface,
  webapp,   //access to pWebApp which points to the currently active app object for th duration of the page
  webScan, DPrefix_dmNexus;

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

procedure TfmWhActions.FormCreate(Sender: TObject);
begin
  inherited;
  WebDBAlphabet := TWebnxdbAlphabet.Create(TForm(Sender));
  with WebDBAlphabet do
  begin
    Name := 'WebDBAlphabet';
    WebDataSource := wdsManPref;
    if Assigned(pWebApp) then
    begin
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

function TfmWhActions.Init: boolean;
begin
  Result := inherited Init;
  if Result then
  begin
    wdsManPref.KeyFieldNames := 'MpfID';
    DataSource1.DataSet := DMNexus.Table1;
    dsAdmin.DataSet := DMNexus.TableAdmin;

    ManPref.ButtonsWhere := dsNone;
    ManPref.PageHeight := 115;  // max for single letter as of 11-Dec-2008 AML
    ManPref.ControlsWhere := dsNone;
  end;
end;

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
      DataSource:=dsAdmin;
      DBNavigator1.DataSource:=dsAdmin;
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

procedure TfmWhActions.WebDataFormSetCommand(Sender:TObject;var Command:String);
var
  a1:string;
begin
  inherited;
  SplitString(Command,'.',Command,a1);
  a1:=Uncode64String(a1);
  with pWebApp.Response, wdsAdmin.DataSet do
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
  with DMNexus.Table1 do
  begin
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
    //Table1.Flush;
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
  with TwhWebActionEx(Sender), wdsAdmin, DataSet do
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

procedure TfmWhActions.waAddExecute(Sender: TObject);
const cFn = 'waAddExecute';
var
  aFieldname: string;
  i,iKey: integer;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;

  iKey := 0;
  with DMNexus.TableAdmin do
  begin
    First;
    while not EOF do
    begin
      if FieldByName('MpfID').AsInteger > iKey then
        iKey := FieldByName('MpfID').AsInteger;
      Next;
    end;
  end;

  Inc(iKey);
  CSSend('iKey', S(iKey));

  with TwhWebActionEx(Sender), DMNexus.TableAdmin do
  begin
    Filtered := False;
    Insert;
    FieldByName('MpfID').asInteger:=iKey;
    FieldByName('Mpf Status').asString:='P';  // pending
    FieldByName('Mpf Date Registered').asDateTime:=now;
    FieldByName('Mpf Notes').asString :=
      pWebApp.Session.TxtVars.List['txtComment'].text;
    CSSend('Mpf Notes', FieldByName('Mpf Notes').asString);

    for i:=0 to Pred(pWebApp.Session.StringVars.count) do
    begin
      //example stringvar: Mpf EMail=info@href.com
      aFieldName:=LeftOfEqual(pWebApp.Session.StringVars[i]);
      CSSend(S(i) + ' aFieldName', aFieldName);
      if StartsWith(aFieldName,'Mpf ') //ucstring
      and (FindField(aFieldName)<>nil) then
        FieldByName(aFieldName).asString :=
          RightOfEqual(pWebApp.Session.StringVars[i]);
    end;
    if Copy(FieldByName('Mpf Webpage').AsString, 1, 7) = 'http://' then
      FieldByName('Mpf Webpage').AsString := Copy(
        FieldByName('Mpf Webpage').AsString, 8, MaxInt);
    try
      Post;
    except
      on E: Exception do
      begin
        LogSendException(E);
      end;
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
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
