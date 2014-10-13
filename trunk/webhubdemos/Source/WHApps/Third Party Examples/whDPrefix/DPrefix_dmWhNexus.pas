{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 1999-2014 HREF Tools Corp.  All Rights Reserved Worldwide. * }
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

unit DPrefix_dmWhNexus;

interface

uses
  SysUtils, Classes,
  webLink, updateOK, tpAction, webTypes;

type
  TDMWHNexus = class(TDataModule)
    waAdminDelete: TwhWebAction;
    waModify: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure waAdminDeleteExecute(Sender: TObject);
    procedure waModifyExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMWHNexus: TDMWHNexus;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  nxDB,
  webApp, htWebApp,
  ucString, ucCodeSiteInterface,
  DPrefix_dmNexus, DPrefix_dmWhActions;

procedure TDMWHNexus.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMWHNexus.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  CSEnterMethod(Self, cFn);
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin
    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      RefreshWebActions(Self);
      FlagInitDone := True;
    end;
  end;
  Result := FlagInitDone;
  CSSend('Result', S(Result));
  CSExitMethod(Self, cFn);
end;

procedure TDMWHNexus.waAdminDeleteExecute(Sender: TObject);
begin
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

procedure TDMWHNexus.waModifyExecute(Sender: TObject);
const cFn = 'waModifyExecute';
//field-data comes in looking like this: wdsAdmin.Mpf Status@46=A
var
  a1,aKey,aFieldname: string;
  i, iKey, iKeyDone: Integer;
  bEditing: Boolean;
  InfoMsg: string;
begin
  CSEnterMethod(Self, cFn);
  inherited;
  iKeyDone := -1;
  bEditing := False;

  if Assigned(DMDPRWebAct) and Assigned(DMDPRWebAct.wdsAdmin) and
    Assigned(DMDPRWebAct.wdsAdmin.DataSet) and
    (DMDPRWebAct.wdsAdmin.DataSet is TnxTable) then
  begin
    { just make sure that the dataset is not readonly }
    if Tnxtable(DMDPRWebAct.wdsAdmin.DataSet).ReadOnly then
      CSSendError('DMDPRWebAct.wdsAdmin.DataSet is READONLY');
  end;

  with TwhWebActionEx(Sender), DMDPRWebAct.wdsAdmin.DataSet do
  begin
    CSSend('Count of posted fields', S(pWebApp.Request.dbFields.Count));

    for i := 0 to Pred(pWebApp.Request.dbFields.Count) do
    begin
      CSSend('posted data #' + S(i), LeftOfEqual(pWebApp.Request.dbFields[i]));

      if SplitString(LeftOfEqual(pWebApp.Request.dbFields[i]),'@',a1,aKey)
      and SplitString(a1,'.',a1,aFieldname)
      and IsEqual(a1, DMDPRWebAct.wdsAdmin.Name) then
      begin
        CSSend('a1', a1);
        CSSend('aKey', aKey);
        CSSend('aFieldname', aFieldname);
        CSSend('IsAllowedRemoteDataEntryField',
          S(DMNexus.IsAllowedRemoteDataEntryField(a1)));

        if DMNexus.IsAllowedRemoteDataEntryField(a1) then
        begin
          iKey := StrToIntDef(aKey, -1);
          CSSend('iKey', S(iKey));
          CSSend('iKeyDone', S(iKeyDone));
          if (iKeyDone = -1) or (iKeyDone <> iKey) then
          begin

            if not Locate('MpfID', iKey,[]) then
            begin
              InfoMsg := 'no such MpfID ' + aKey;
              pWebApp.Debug.AddPageError(InfoMsg);
            end
            else
            begin
              if IsEqual(FieldByName('Mpf EMail').AsString,
                pWebApp.StringVar['_email']) then
              begin
                // surfer has permission to work on this record
                iKeyDone := iKey;
                CSSend('About to Edit; iKeyDone', S(iKeyDone));
                try
                  Edit;
                  bEditing := True;
                except
                  on E: Exception do
                  begin
                    CSSendException(E);
                    bEditing := False;
                  end;
                end;
              end
              else
              begin
                CSSendWarning(Format(
                  '_email mismatch between stringvar %s and db data %s',
                  [pWebApp.StringVar['_EMail'],
                   FieldByName('Mpf EMail').AsString]));
              end;
            end;
          end;
        end
        else
          CSSendWarning('Disallow posting to ' + a1);
        if bEditing then
        begin
          CSSend('Posting data into aFieldName', aFieldName);
          FieldByName(aFieldName).asString:=
            RightOfEqual(pWebApp.Request.dbFields[i]);
        end;
      end;
    end;
    if bEditing then
    begin
      (*if pWebApp.StringVar['ReplaceWithEMail'] <> '' then
      begin
        if DemoExtensions.IsSuperUser(pWebApp.Request.RemoteAddress) then
          FieldByName('Mpf EMail').AsString :=
            pWebApp.StringVar['ReplaceWithEMail']
        else
          LogSendError('Bad ip. Rejected use of ' +
            pWebApp.StringVar['ReplaceWithEMail'], cFn);
      end;*)
      DMNexus.RecordNoAmpersand(DMNexus.TableAdmin);
      DMNexus.Stamp(DMDPRWebAct.wdsAdmin.DataSet, 'srf');
      CSSendnote('ready to post');
      try
        Post;
      except
        on E: Exception do
        begin
          CSSendException(E);
        end;
      end;
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

end.
