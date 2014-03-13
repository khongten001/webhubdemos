unit DSP_dmRubicon;

interface

uses
   Windows, Messages, SysUtils, Classes, Forms,
   UpdateOk, tpAction, DBTables, DB,
   rbBase, rbDS, rbTable, rbBridge_b_bde, rbSearch, rbLogic,
   rbRank, rbPrgDlg, rbCache, rbMake, rbMatch;

const
   cTimeOut = 15;  // in milliseconds
   cDSP='http://delphi.icm.edu.pl/';

type
   ESearchTimeout = class(Exception);

type
   TDSPdm = class(TDatamodule)
      tblAuthors: TTable;
      tblFiles: TTable;
      dbDSP: TDatabase;
      tblFilesAuth: TTable;
      tblFilesCat: TTable;
      tblFilesGroup: TTable;
      tblFilesPlt: TTable;
      tblWords: TTable;
      rbMake: TrbMake;
      rbCache: TrbCache;
      rbProgressDialog: TrbProgressDialog;
      rbSearch: TrbSearch;
      rbMakeTextBDELink: TrbMakeTextBDELink;
      rbMakeWordsBDELink: TrbMakeWordsBDELink;
      dsFiles: TDataSource;
      dsWords: TDataSource;
      procedure DataModuleCreate(Sender: TObject);
      procedure DSPdmDestroy(Sender: TObject);
      procedure tblFilesPltAfterOpen(DataSet: TDataSet);
      procedure tblFilesGroupAfterOpen(DataSet: TDataSet);
      procedure tblFilesCatAfterOpen(DataSet: TDataSet);
      procedure tblWordsAfterOpen(DataSet: TDataSet);
      procedure tblFilesAfterOpen(DataSet: TDataSet);
      procedure rbMakeTextBDELinkProcessField(Sender: TObject; Engine: TrbEngine; Field: TField);
      procedure rbSearchSearch(Sender: TObject);
      procedure tblFilesAuthAfterOpen(DataSet: TDataSet);
      procedure tblAuthorsAfterOpen(DataSet: TDataSet);
   private
      fInit: Boolean;
      fTimeOut: Integer;
      fFileRoot,
      fImgSrc,
      fImgExt: String;
      fDebug:Boolean;
      fPlatFormList: TStringList;
      fGroupPrfxList: TStringList;
      fGroupNameList: TStringList;
      fCatgList: TStringList;
      fCatgDrop: TStringList;
      fSearchWords: TStringList;
      fWordsTable:string;
      fWordCount: TField;
      function GetGroupSearchPrefix(GroupIndex:integer): String;
      function GetSearchResults: String;
      function GetFileDetailHTML(FileID:Integer):String;
   public
      fFileID,
      fFileName,
      fDSPdir,
      fDescription,
      fCondition,
      fFree,
      fD10,
      fD20,
      fD30,
      fD40,
      fD50,
      fD60,
      fD70,
      fD80,
      fD2K5,
      fK10,
      fK20,
      fK30,
      fC10,
      fC30,
      fC40,
      fC50,
      fC60,
      fJ10,
      fJ20,
      fJ60,
      fD10a,
      fD20a,
      fD30a,
      fD40a,
      fD50a,
      fD60a,
      fD70a,
      fD80a,
      fD2K5a,
      fK10a,
      fK20a,
      fC10a,
      fC30a,
      fC40a,
      fC50a,
      fC60a,
      fJ10a,
      fJ20a,
      fJ60a,
      fWithSource,
      fPlatformID,
      fFileGrpID,
      fFileCatID,
      fFileVersion,
      fCreated,
      fChanged,
      fFileSize,
      fExtDescFile,
      fFileIDAuthors,
      fAuthorID,
      fAuthorName,
      fURL,
      fContact,
      fEMail : TField;
      FilesAsOf: String;
      FilesCount: Integer;
      FilesDatabasename: String;
      WordsDatabasename: String;

      function Init(out ErrorText: string): Boolean;
      procedure DoMake;  // Rubicon 1.4 was DoMakeDictionary
      function WordCount(const SearchWord:String):Integer;
      function IsValidReferer(const Referer:String;var Prefix:String):Boolean;

      property FileRoot: String read fFileRoot write fFileRoot;
      property ImgSrc: String read fImgSrc write fImgSrc;
      property ImgExt: String read fImgExt write fImgExt;

      property PlatFormList: TStringList read fPlatformList {write fPlatformList};
      property GroupNameList: TStringList read fGroupNameList;
      property CatgList: TStringList read fCatgList {write fCatgList};

      property TimeOut: Integer read fTimeOut write fTimeOut;
      property Debug: Boolean read fDebug write fDebug;
      property GroupPrfxList: TStringList read fGroupPrfxList;
      property GroupSearchPrefix[GroupIndex:integer]: String read GetGroupSearchPrefix;
      property SearchWords: TStringList read fSearchWords;
      property SearchResults: String read GetSearchResults;
      property FileDetailHTML[FileID:Integer]:String read GetFileDetailHTML;
      property WordsTable:String read fWordsTable write fWordsTable;
   end;

var
   DSPdm: TDSPdm;

implementation

{$R *.DFM}

uses
  ucString, ucPos, ucFile, ucLogFil, ucCodeSiteInterface,
  webApp,
  HTMLText, DSP_dmDisplayResults, DSP_u1;


{$REGION 'Create, Init and Destroy Methods'}
procedure TDSPdm.DataModuleCreate(Sender: TObject);
const cFn = 'DataModuleCreate';
begin
  CSEnterMethod(Self, cFn);

   fTimeOut := cTimeOut;
   fPlatFormList :=TStringList.Create;
   fGroupPrfxList := TStringList.Create;
   fGroupNameList := TStringList.Create;
   fCatgList := TStringList.Create;
   fCatgDrop := TStringList.Create;
   fSearchWords := TStringList.Create;
   fImgExt := 'gif';
   LogInfo('TDSPdm.DataModuleCreate');
   With rbMake do
      begin
         Cache := rbCache;
         TextLink := rbMakeTextBDELink;
         WordsLink := rbMakeWordsBDELink;
      end;
   With rbMakeTextBDELink do
      begin
         Table := tblFiles;
         IndexFieldName := 'FileID';
         FieldNames.Clear;
         FieldNames.Add('Filename');
         FieldNames.Add('Description');
         OnProcessField := rbMakeTextBDELinkProcessField;
      end;
   With rbMakeWordsBDELink do
      begin
         Table := tblWords;
         BlobFieldSize := 64;
      end;
   With rbCache do
      begin
         MemoryLimit := 8000000;
      end;
   With rbProgressDialog do
      begin
         Engine := rbMake;
      end;
   With rbSearch do
      begin
         Cache := rbCache;
         TextLink := rbMakeTextBDELink;
         WordsLink := rbMakeWordsBDELink;
      end;
  CSExitMethod(Self, cFn);
end;

function TDSPdm.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
  procedure SetDatabase(tbl: TTable; const bAlias: Boolean;
    const pathValue: string; const tablenameValue: string);
  begin
    try
      If bAlias then
      begin
        tbl.DatabaseName := 'DSP';
        // use connection through TDatabase component and Alias
        tbl.TableName := tablenameValue;
      end
      Else
      begin
        tbl.DatabaseName := ''; // no Alias
        tbl.TableName := TrailingBackslash(pathValue) + tablenameValue;
      end;
      tbl.ReadOnly := True;
      tbl.open;
      LogInfo('Opened ' + tbl.TableName);
    except
      on e: Exception do
      begin
        LogSendInfo(tbl.TableName);
        LogSendException(E);
      end;
    end;
  end;

var
  bAlias: Boolean;
begin
  CSEnterMethod(Self, cFn);
  ErrorText := '';
  Result := fInit;
  If NOT fInit then
  begin

    fInit := true;

    // Note that TfmWebAppMainForm.htWebAppUpdate sets FilesDatabasename
    dbDSP.Connected := False;
    LogInfo('FilesDatabasename=' + FilesDatabasename);
    If FilesDatabasename = '' then
    begin
      bAlias := true;
      DSPdm.dbDSP.AliasName := '_DSP';
      LogInfo('DSPdm.dbDSP.AliasName defaulted to ' + DSPdm.dbDSP.AliasName);
    end
    Else
    begin
      If (pos(':', FilesDatabasename) > 0) or (pos('\', FilesDatabasename) > 0)
      then
      begin
        bAlias := False;
        dbDSP.AliasName := '';
      end
      Else
      begin
        bAlias := true;
        DSPdm.dbDSP.AliasName := FilesDatabasename;
        LogInfo('DSPdm.dbDSP.AliasName set to' + DSPdm.dbDSP.AliasName);
      end;
    end;

    If bAlias then
    begin
      LogInfo('About to connect dbDSP and use BDE Alias.');
      dbDSP.Connected := true;
      LogInfo('dbDSP connected.');
    end;

    With tblFiles do
    begin
      IndexFieldNames := 'FileID'; // AML 22-April-2001 ???
    end;
    SetDatabase(tblFiles, bAlias, FilesDatabasename, 'files.db');
    SetDatabase(tblFilesAuth, bAlias, FilesDatabasename, 'filesaut.db');
    SetDatabase(tblAuthors, bAlias, FilesDatabasename, 'authors.db');
    SetDatabase(tblFilesPlt, bAlias, FilesDatabasename, 'filesplt.db');
    SetDatabase(tblFilesGroup, bAlias, FilesDatabasename, 'filesgrp.db');
    SetDatabase(tblFilesCat, bAlias, FilesDatabasename, 'filescat.db');

    tblWords.Active := False;
    If (WordsDatabasename = '') then
      WordsDatabasename := pWebApp.AppSetting['WordsTablePath'];
    If (WordsDatabasename = '') then
    begin
      LogInfo('(' + pWebApp.AppSetting['WordsTablePath'] +
        ') Define AppSetting of "WordsTablePath" e.g. WordsTablePath=d:\path\');
      Raise Exception.Create
        ('TDSPdm.Init: ERROR initializing WordsDatabasename.');
      Result := False;
      fInit := False;
      Exit;
    end;
    tblWords.DatabaseName := '';
    tblWords.TableName := TrailingBackslash(WordsDatabasename) + 'words.db';

    LogInfo('WordsDatabasename=' + WordsDatabasename);
    LogInfo('tblWords.Tablename=' + tblWords.TableName);
    If (NOT FileExists(tblWords.TableName)) then
    begin
      LogInfo(tblWords.TableName +
        ' does not exist. Will not be able to open Words table.');
    end;
    Result := fInit;
  end;
  CSExitMethod(Self, cFn);
end;

{-}
procedure TDSPdm.DSPdmDestroy(Sender: TObject);
begin
   Inherited;
   FreeAndNil(fPlatFormList);
   FreeAndNil(fGroupPrfxList);
   FreeAndNil(fGroupNameList);
   FreeAndNil(fCatgList);
   FreeAndNil(fCatgDrop);
   FreeAndNil(fSearchWords);
end;
{$ENDREGION}


{------------------------------------------------------------------------------}
{ Group: Make the Words Table using Rubicon                                    }
{------------------------------------------------------------------------------}
procedure TDSPdm.DoMake;
begin
   Try
      With tblFiles do
         begin
            If IndexName<>'' then
               begin
                  Close;
                  IndexName:='';
               end;
            ReadOnly := True;
            Open;
         end;
      tblWords.Close;
      tblFilesAuth.Open;
      tblAuthors.Open;
      rbMake.Execute;  // Rubicon 1.4 MakeDictionary
   Finally
      tblWords.Close;
      tblWords.Exclusive:=False;
      tblWords.Open;
   End;
end;

procedure TDSPdm.rbMakeTextBDELinkProcessField(Sender: TObject; Engine: TrbEngine; Field: TField);
var Result:String;
   procedure AddString(const Value:String);
   begin
      If Value<>'' then Result:=Result+' '+Value;
   end;

   procedure AddSpecial(const Value:String);
   begin
      If Value<>'' then AddString('zzz'+Value);
   end;

   procedure AddFileName;
   var a1,a2:string;
   begin
      SplitRight(fFileName.AsString,'.',a1,a2);
      If lowercase(a2)<>'zip' then AddString(a1+'.'+a2)
      Else AddString(a1);
   end;

   procedure AddBoolean(fField:TField);
   begin
      If (fField<>nil) and (fField.AsBoolean) then AddSpecial(fField.FieldName);
   end;

   procedure AddPlatForm;
   begin
      AddSpecial(fPlatFormList.Values[fPlatformID.AsString]);
   end;

   procedure AddGroup;
   begin
      AddSpecial(fGroupPrfxList.Values[fFileGrpID.AsString]);
   end;

   procedure AddCategory;
   begin
      AddSpecial(fFileCatID.AsString);
   end;

   procedure AddAuthorDetail;
   begin
      AddString(fAuthorName.AsString);
      AddString(fURL.AsString);
      AddString(fContact.AsString);
      AddString(fEMail.AsString);
   end;

   procedure AddAuthorInfo;
   var i:integer;
   begin
      i:=fFileID.AsInteger;
      With tblFilesAuth do
         begin
            If not active then Open;
            If FindKey([i]) then
               While not eof and (fFileIDAuthors.AsInteger=i) do
                  begin
                     If tblAuthors.FindKey([fAuthorID.AsInteger]) then AddAuthorDetail;
                     Next;
                  end;
         end;
   end;
begin
   Inherited;
   Result:='';
   AddFileName;
   AddString(fDescription.AsString);
   AddString(fCondition.AsString);
   AddString(fFileVersion.AsString);
   AddBoolean(fD10);
   AddBoolean(fD20);
   AddBoolean(fD30);
   AddBoolean(fD40);
   AddBoolean(fD50);
   AddBoolean(fD60);
   AddBoolean(fD70);
   AddBoolean(fD80);
   AddBoolean(fD2K5);
   AddBoolean(fK10);
   AddBoolean(fK20);
   AddBoolean(fK30);
   AddBoolean(fC10);
   AddBoolean(fC30);
   AddBoolean(fC40);
   AddBoolean(fC50);
   AddBoolean(fC60);
   AddBoolean(fJ10);
   AddBoolean(fJ20);
   AddBoolean(fJ60);
   AddBoolean(fFree);
   AddBoolean(fWithSource);
   AddPlatForm;
   AddGroup;
   AddCategory;
   AddAuthorInfo;
   // Rubicon 1.4 was TAbstractDictionary(Sender) do
   Result := TextFromHTML(Result);
   Engine.ProcessString(Result);
end;

{------------------------------------------------------------------------------}
{ G1: Table and Field Initialization Methods                                   }
{------------------------------------------------------------------------------}
procedure TDSPdm.tblFilesPltAfterOpen(DataSet: TDataSet);
begin
   Inherited;
   fPlatFormList.Clear;
   With Dataset do
      begin
         First;
         While not eof do
            begin
               fPlatFormList.Add(FieldByName('PlatFormID').AsString+'='+StripChars(FieldByName('PlatFormName').AsString,'. '));
               Next;
            end;
      end;
end;

procedure TDSPdm.tblFilesGroupAfterOpen(DataSet: TDataSet);
var a1,a2,a3:string;
begin
   Inherited;
   fGroupPrfxList.Clear;
   fGroupNameList.Clear;
   fGroupNameList.Add('0=All Categories');
   With Dataset do
      begin
         First;
         While not eof do
            begin //ucstring
               a1:=FieldByName('FileGrpID').AsString;
               a2:=FieldByName('Prefix').AsString;
               If a2='' then a2:='vcl';
               a3:=FieldByName('FileGrpName').AsString;
               fGroupPrfxList.Add(a1+'='+a2);
               fGroupNameList.Add(a1+'='+a3);
               Next;
            end;
      end;
end;

procedure TDSPdm.tblFilesCatAfterOpen(DataSet: TDataSet);
var a1,a2:string;
begin
   Inherited;
   fCatgList.Clear;
   fCatgDrop.Clear;
   With Dataset do
      begin
         First;
         While not eof do
            begin //ucstring
               a1:=FieldByName('FileCatID').AsString;
               a2:=FieldByName('FileCatName').AsString;
               //a3:=FieldByName('FileGrpID').AsString);
               fCatgList.Add(a1+'='+a2);
               //fCatgDrop.Add(a1+'='+a3);
               Next;
            end;
      end;
end;

procedure TDSPdm.tblWordsAfterOpen(DataSet: TDataSet);
begin
   Inherited;
   fWordCount:= DataSet.FieldByName('rbCount');
end;

//------------------------------------------------------------------------------

procedure TDSPdm.tblFilesAfterOpen(DataSet: TDataSet);
var
  a1: string;
  dt: TDateTime;
begin
   Inherited;
   With DataSet do
      begin
         fFileID        := FieldByName('FileID');
         fFileName      := FieldByName('FileName');
         fDSPdir        := FieldByName('DSPdir');
         fDescription   := FieldByName('Description');
         fCondition     := FieldByName('Condition');
         fFree          := FieldByName('Free');
         fD10           := FieldByName('D10');
         fD20           := FieldByName('D20');
         fD30           := FieldByName('D30');
         fD40           := FieldByName('D40');
         fD50           := FieldByName('D50');
         fD60           := FieldByName('D60');
         fD70           := FieldByName('D70');
         fD80           := FieldByName('D80');
         fD2K5          := FieldByName('D2K5');
         fK10           := FieldByName('K10');
         fK20           := FieldByName('K20');
         fK30           := FieldByName('K30');
         fC10           := FieldByName('C10');
         fC30           := FieldByName('C30');
         fC40           := FieldByName('C40');
         fC50           := FieldByName('C50');
         fC60           := FieldByName('C60');
         fJ10           := FieldByName('J10');
         fJ20           := FieldByName('J20');
         fJ60           := FieldByName('J60');
         fD10a          := FieldByName('D10a');
         fD20a          := FieldByName('D20a');
         fD30a          := FieldByName('D30a');
         fD40a          := FieldByName('D40a');
         fD50a          := FieldByName('D50a');
         fD60a          := FieldByName('D60a');
         fK10a          := FieldByName('K10a');
         fK20a          := FieldByName('K20a');
         fC10a          := FieldByName('C10a');
         fC30a          := FieldByName('C30a');
         fC40a          := FieldByName('C40a');
         fC50a          := FieldByName('C50a');
         fC60a          := FieldByName('C60a');
         fJ10a          := FieldByName('J10a');
         fJ20a          := FieldByName('J20a');
         fJ60a          := FieldByName('J60a');
         fWithSource    := FieldByName('WithSource');
         fPlatformID    := FieldByName('PlatformID');
         fFileGrpID     := FieldByName('FileGrpID');
         fFileCatID     := FieldByName('FileCatID');
         fFileVersion   := FieldByName('FileVersion');
         fCreated       := FieldByName('Created');
         fChanged       := FieldByName('Changed');
         fFileSize      := FieldByName('FileSize');
         fExtDescFile   := FieldByName('ExtDescFile');
      end;
   If dbDsp.Directory<>'' then
      begin
         a1:=dbDsp.Directory;
         a1:=IncludeTrailingPathDelimiter(a1) + TTable(DataSet).Tablename;
      end
   Else
      begin
         a1:=ttable(DataSet).Tablename;
      end;
  FileAge(a1, dt);
  FilesAsOf := FormatDateTime('dd-MMMM-yyyy', dt);
  FilesCount:=ttable(DataSet).RecordCount;
end;


procedure TDSPdm.tblFilesAuthAfterOpen(DataSet: TDataSet);
begin
   Inherited;
   With DataSet do
      begin
         fFileIDAuthors := FieldByName('FileID');
         fAuthorID      := FieldByName('AuthorID');
      end;
end;

procedure TDSPdm.tblAuthorsAfterOpen(DataSet: TDataSet);
begin
   Inherited;
   With DataSet do
      begin
         fAuthorName    := FieldByName('AuthorName');
         fURL           := FieldByName('URL');
         fContact       := FieldByName('Contact');
         fEMail         := FieldByName('EMail');
      end;
end;

{------------------------------------------------------------------------------}
{G1: Web application GUI                                                       }
{------------------------------------------------------------------------------}
function TDSPdm.IsValidReferer(const Referer:String;var Prefix:String):Boolean;
const cHREF='http://www.codenewsfast.com/';
begin
   Prefix:=cDSP;
   Result:=(referer='') or (posci(cHREF,Referer)=1); //i dont like accepting a blank here, but its blank when reloaded from javascript!
end;

function TDSPdm.GetFileDetailHTML(FileID:Integer):String;
begin
   Result := dmDisplayResults.GetFileDetailHTML(FileID);
end;

function TDSPdm.WordCount(const SearchWord:String):Integer;
begin
   With tblWords do
      If FindKey([SearchWord]) then Result:=fWordCount.AsInteger
      Else Result:=-1;
end;

function TDSPdm.GetGroupSearchPrefix(GroupIndex:integer): String;
//look up the name of the group -- fGroupNameList[i] prefix=name
//in the prefix-list -- fGroupPrfxList prefix=code
//and return the special word for the group
begin
   Result:='zzz'+fGroupPrfxList.Values[LeftOfEqual(fGroupNameList[GroupIndex])];
end;

{------------------------------------------------------------------------------}
{G1: Searching with Rubicon                                                    }
{------------------------------------------------------------------------------}
procedure TDSPdm.rbSearchSearch(Sender: TObject);    // Rubicon 1.4 was SearchDictionarySearch(Sender: TObject);
begin
   Inherited;
(*
// Rubicon 1.4 method of doing a timeout. Need to do this another way in v2. !!!
  with TrbSearch(Sender) DO
   if State=[dsStart,dsSearching] then
     Tag:= GetTickCount
   else
     if (GetTickCount-Tag)>fTimeOut*1000 then
       raise ESearchTimeout.Create('');
       //Search exceeded '+inttostr(fTimeOut div 1000)+'sec time limit.')
*)
  // This copied from Rubicon 2 help file.
   Application.ProcessMessages;
  //if NOT fContinue then TrbSearch(Sender).Abort;
end;



function TDSPdm.GetSearchResults: String;
var i,n:integer;
begin
   Result:='';
   n:=0;
   With rbSearch do
      begin
         If not assigned(MatchBits) then Exit;
         i:= MatchBits.FirstSet;
         While (i<>-1) and (n<rbMake.CounterLimit) do
            begin  // Rubicon 1.4 was RecordLimit
               Inc(n);
               Result:=Result+','+inttostr(i+TextLink.MinIndex);       //trbsearch
               i:= MatchBits.NextSet(i);
            end;
         If n>0 then delete(result,1,1);
      end;
end;

end.
