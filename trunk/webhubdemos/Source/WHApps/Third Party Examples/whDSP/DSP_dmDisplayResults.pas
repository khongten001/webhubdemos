unit DSP_dmDisplayResults;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
   TdmDisplayResults = class(TDataModule)
   private
      { Private declarations }
   public
      { Public declarations }
      function GetFileDetailHTML(FileID:Integer):String;
      function FileDetails(bHTML:Boolean): String;
   end;

var
   dmDisplayResults: TdmDisplayResults;

implementation

{$R *.DFM}

uses
   db, whMacroAffixes, WebApp, ucString, DSP_u1, DSP_dmRubicon;

{------------------------------------------------------------------------------}
{ Group: FileDetails function sends out the "result" for each matching file    }
{------------------------------------------------------------------------------}
function TdmDisplayResults.FileDetails(bHTML:Boolean): String;
   function GetString(const Value:String):String;
   begin
      If Value<>'' then Result:=Value+sLineBreak
      Else Result:=Value;
   end;

   function GetBoolean(fField:TField): String;
   var
      bFlag: boolean;
      S: string;
      function OddNamesToReadableDelphiVersions(const OddCode: string): string;
      begin
         If OddCode = 'd10' then Result := 'd01'
         Else
            If OddCode = 'd20' then Result := 'd02'
            Else
               If OddCode = 'd30' then Result := 'd03'
               Else
                  If OddCode = 'd40' then Result := 'd04'
                  Else
                     If OddCode = 'd50' then Result := 'd05'
                     Else
                        If OddCode = 'd60' then Result := 'd06'
                        Else
                           If OddCode = 'd70' then Result := 'd07'
                           Else
                              If OddCode = 'd80' then Result := 'd08'
                              Else
                                 If OddCode = 'd2k5' then Result := 'd2005'
                                 Else
                                    If OddCode = 'd2k6' then Result := 'd2006'
                                    Else
                                       If OddCode = 'k10' then Result := 'k01'
                                       Else
                                          If OddCode = 'k20' then Result := 'k02'
                                          Else
                                             If OddCode = 'k30' then Result := 'k03'
                                             Else
                                                If OddCode = 'c10' then Result := 'c01'
                                                Else
                                                   If OddCode = 'c20' then Result := 'c02'
                                                   Else
                                                      If OddCode = 'c30' then Result := 'c03'
                                                      Else
                                                         If OddCode = 'c40' then Result := 'c04'
                                                         Else
                                                            If OddCode = 'c50' then Result := 'c05'
                                                            Else
                                                               If OddCode = 'c60' then Result := 'c06'
                                                               Else
                                                                  If OddCode = 'j10' then Result := 'j01'
                                                                  Else
                                                                     If OddCode = 'j20' then Result := 'j02'
                                                                     Else
                                                                        If OddCode = 'j60' then Result := 'j06'
                                                                        Else Result := OddCode;
      end;
   begin
      Result:='';
      If fField=nil then Exit;
      With fField do
         begin
            bFlag := fField.asBoolean;
            If bFlag then s:='true'
            Else s:='false';
            LogInfo('GetBoolean for '+fField.fieldname+' '+s);
            If AsBoolean then
               begin
                  // field value is true
                  If bHTML then
                     begin
                        If fField=DSPdm.fFree then Result:={'s_'+}lowercase(FieldName)
                        Else
                           If fField=DSPdm.fWithSource then Result:='with-source'
                           Else Result := OddNamesToReadableDelphiVersions(lowercase(FieldName));
                     end
                  Else Result:=FieldName+sLineBreak
               end
            Else
               begin
                  // field value is false
                  If bHTML then
                     begin
                        If fField=DSPdm.fFree then Result:='shareware'
                        Else Result:='';
                     end
                  Else Result:='';
               end;
         end;
   end;

   function GetPlatForm: String;
   begin
      Result:=GetString(DSPdm.PlatFormList.Values[DSPdm.fPlatformID.AsString]);
   end;

   function GetGroup: String;
   begin
      Result:=GetString(DSPdm.GroupNameList.Values[DSPdm.fFileGrpID.AsString]);
   end;

   function GetCategory: String;
   begin
      Result:=GetString(DSPdm.CatgList.Values[DSPdm.fFileCatID.AsString]);
   end;

   function GetExt:String;
   var a1:string;
   begin
      Result:=DSPdm.fExtDescFile.AsString;
      If (Result<>'') and (Result<>'F') then
         //<A HREF="ftp/d10free/rxlib240.txt" TARGET="_blank">
         //<IMG align=top border=0 SRC="gifs/doc.gif"></A>
         If bHTML then
            begin
               a1:=DSPdm.fFileName.AsString;
               If result='T' then a1:=ChangeFileExt(a1,'txt')
               Else a1:=ChangeFileExt(a1,'htm');
               If pos('/',a1)>0 then Result:=''
               Else Result:=' <A HREF="'+DSPdm.FileRoot+'ftp/'+DSPdm.fDSPdir.AsString+'/'+a1
                              +'" TARGET="Other"><IMG align=top border=0 src="'+DSPdm.ImgSrc+'doc.'+
                              DSPdm.ImgExt+'"></A>';
            end
         Else
            If result='T' then Result:=GetString(Result+' -- Robert, i think i need this file :)')
            Else Result:=GetString(Result+' -- Robert, do i need this file :)')
      Else Result:='';
   end;

   function GetSize:String;
   begin
      If DSPdm.fFileSize.AsFloat<>0 then Result:=GetString('('+format('%.0n',[DSPdm.fFileSize.AsFloat])+' bytes)')
      Else Result:='';
   end;

   function SpliceFileRoot(const Text:String):String;
   var a1,a2,a3:string;
   begin
      //descriptions & conditions may have urls in them. splice in the file-root.
      Result:='';
      a2:=Text;
      While splitstring(a2,'>',a1,a2) do
         begin
            If splitstring(a1,'<A HREF="',a1,a3) then
               begin
                  Result:=Result+a1+'<A HREF="';
                  If pos(':/',a3)=0 then Result:=Result+DSPdm.FileRoot+a3+'>'
                  Else Result:=Result+a3+'>'
               end
            Else Result:=Result+a1+'>';
         end;
      Result:=Result+a1+a2;
   end;

   function GetDates:String;
   var a1:string;
   begin
      Result:=DSPdm.fFileVersion.AsString;
      If (Result<>'') and (Result<>'n/a') then Result:='(ver. '+Result+', '
      Else Result:='(';

      If DSPdm.fCreated.AsString=DSPdm.fChanged.AsString then Result:= Result+ 'added '+DSPdm.fCreated.AsString
      Else Result:= Result+ 'added '+DSPdm.fCreated.AsString+', updated '+ DSPdm.fChanged.AsString;

      a1:=DSPdm.PlatFormList.Values[DSPdm.fPlatformID.AsString];
      If a1<>'' then Result:=Result+', '+a1;

      If not DSPdm.fWithSource.AsBoolean then Result:=Result+', no src.';

      If (DSPdm.fCondition.AsString<>'') then Result:=Result+', '+SpliceFileRoot(DSPdm.fCondition.AsString);

      Result:=Result+')'+sLineBreak;
   end;

   function GetAuthorDetail:String;
   var a1,a2:string;
   begin
      If bHTML then
         begin
            Result:='';
            a2:=DSPdm.fContact.AsString;
            a1:=DSPdm.fAuthorName.AsString;
            If (a1<>'') and (a2<>'') and (a2<>a1) then  Result:=Result+a2+sLineBreak;
            If a1<>'' then
               begin
                  a2:=DSPdm.fAuthorID.asString;
                  While length(a2)<7 do a2:='0'+a2;
                  Result:=Result+'&nbsp;&nbsp;<a href="'+cDSP+'authors/a'+a2+'.htm">'+a1+'</a>'+sLineBreak;
               end;
            a1:=DSPdm.fURL.AsString;
            If a1<>'' then
               begin
                  Result:=Result+'&nbsp;&nbsp;'+
                  '<A HREF="'+a1+'" TARGET="Other">'+'website</A>'+
                  '&nbsp;&nbsp;'+sLineBreak;   // put in 2-July-2001 AML
               end;
            // a1:=DSPdm.fEMail.AsString; stop show email addresses 03-Feb-2013
         end
      Else Result := GetString(DSPdm.fAuthorName.AsString)
                     +GetString(DSPdm.fURL.AsString)
                     +GetString(DSPdm.fContact.AsString)
                     //+GetString(DSPdm.fEMail.AsString)
                     ;
   end;

   function GetAuthorInfo:String;
   var
      i:integer;
      b:boolean;
   begin
      Result:='';
      If DSPdm.fFileID=nil then Exit;
      i:=DSPdm.fFileID.AsInteger;
      With DSPdm.tblFilesAuth do
         begin
            If not active then Open;
            If FindKey([i]) then
               begin
                  Result:='<b>by:</b> ';
                  b:=false;
                  While not eof and (DSPdm.fFileIDAuthors.AsInteger=i) do
                     begin
                        If DSPdm.tblAuthors.FindKey([DSPdm.fAuthorID.AsInteger]) then
                           begin
                              If b then Result:=Result+' and ';
                              Result:=Result+GetAuthorDetail;
                           end;
                        b:=True;
                        Next;
                     end;
               end;
         end;
      Result := Result + '&nbsp;';
   end;

   function GetHTMLLink(Field:TField):String;
   var
      i:integer;
      bm:TBookmark;
   begin
      Result:='';
      If Field=nil then Exit;
      i:=Field.AsInteger;
      If i=0 then Exit;
      With DSPdm.tblFiles do
         begin
            bm:=GetBookmark;
            Try
               If FindKey([i]) then
                  begin
                     Result:=DSPdm.fFileName.AsString;
                     If pos('/',Result)>0 then Result:='<A HREF="'+Result+'">'
                     Else Result:='<A HREF="'+DSPdm.FileRoot+'ftp/'+DSPdm.fDSPdir.AsString+'/'+Result+'">';
                     Result:=Result+'<IMG align=top border=0 src="'+DSPdm.ImgSrc+Field.FieldName+'.'+DSPdm.ImgExt+'"></A>'+sLineBreak;
                  end;
            Finally
               GotoBookmark(bm);
               FreeBookmark(bm);
            End;
         end;
   end;

   function GetHTMLFileName:String;
   var a1,a2:string;
   begin
      Result:=DSPdm.fFileName.AsString;
      If splitright(Result,'/',a1,a2) then Result:=GetString('<IMG align=top border=0 src="'+DSPdm.ImgSrc+'link.'+DSPdm.ImgExt+'">'+' <A HREF="'+Result+'">'+RightOf('?',a2)+'</A>')
      Else Result:=GetString('<A HREF="'+DSPdm.FileRoot+'ftp/'+DSPdm.fDSPdir.AsString+'/'+Result+'">'+Result+'</A>')
   end;

   function LogFileDetail(const funcName:string; const S:string):string;
   begin
      LogInfo(FuncName+': '+S);
      Result:=S+'^';
   end;
begin
   If bHTML then
      begin
         LogFileDetail('-----------------','-----------------');
         If DSPdm.Debug then Result:=LogFileDetail('fDebug',GetString('#'+DSPdm.fFileID.AsString))
         Else Result:='';

         If NOT DSPdm.tblAuthors.Active then DSPdm.tblAuthors.Open;

         With DSPdm do
            begin
               Result:= Result
                  +pWebApp.Expand(MacroStart+'PARAMS|chSearchResult,DYN,^|'
                  +LogFileDetail(' DYN1 GetHTMLFileName',GetHTMLFileName)
                  +LogFileDetail(' DYN2 GetSize',GetSize)                  // filesize
                  +LogFileDetail(' DYN3 fDescription',GetString(SpliceFileRoot(DSPdm.fDescription.AsString)))  // description
                  //+GetString(fCondition.AsString)
                  //+GetString(fFileVersion.AsString)
                  +LogFileDetail(' DYN4 GetDates',GetDates)  // file date, version, add/change info, and other details
                  +LogFileDetail(' DYN5 fFree and fWithSource',
                  GetBoolean(fFree)+' '+GetBoolean(fWithSource))
                  +LogFileDetail(' DYN6 fD10etc',
                  GetBoolean(fD10)+' '+    {all of these concatenated into DYN6}
                  GetBoolean(fD20)+' '+
                  GetBoolean(fD30)+' '+
                  GetBoolean(fD40)+' '+
                  GetBoolean(fD50)+' '+
                  GetBoolean(fD60)+' '+
                  GetBoolean(fD70)+' '+
                  GetBoolean(fD80)+' '+
                  GetBoolean(fD2K5)+' '+
                  GetBoolean(fC10)+' '+
                  GetBoolean(fC30)+' '+
                  GetBoolean(fC40)+' '+
                  GetBoolean(fC50)+' '+
                  GetBoolean(fC60)+' '+
                  GetBoolean(fK10)+' '+
                  GetBoolean(fK20)+' '+
                  GetBoolean(fK30)+' '+
                  GetBoolean(fJ10)+' '+
                  GetBoolean(fJ20)+' '+
                  GetBoolean(fJ60))
                  +LogFileDetail('DYN7 GetAuthorInfo',GetAuthorInfo)   // author
                  //      +LogFileDetail('DYN24 GetExt',GetExt)
                  //+GetPlatForm
                  //+GetGroup
                  //+GetCategory
                  +MacroEnd);
            end;
         LogFileDetail('-----------------','-----------------');
      end
   Else
      begin
         LogInfo('Alternate result calculation in process. Notify Ann!');
         With DSPdm do
            begin
               Result:=
                  GetString(fFileID.AsString)
                  +GetString(fFileName.AsString)
                  //+GetString(fFileVersion.AsString)
                  +GetDates
                  +GetSize
                  +GetString(fDescription.AsString)
                  +GetExt
                  //+GetString(fCondition.AsString)
                  +GetBoolean(fFree)
                  +GetBoolean(fD10)
                  +GetBoolean(fD20)
                  +GetBoolean(fD30)
                  +GetBoolean(fD40)
                  +GetBoolean(fD50)
                  +GetBoolean(fD60)
                  +GetBoolean(fD70)
                  +GetBoolean(fD80)
                  +GetBoolean(fD2K5)
                  +GetBoolean(fK10)
                  +GetBoolean(fK20)
                  +GetBoolean(fK30)
                  +GetBoolean(fC10)
                  +GetBoolean(fC30)
                  +GetBoolean(fC40)
                  +GetBoolean(fC50)
                  +GetBoolean(fC60)
                  +GetBoolean(fJ10)
                  +GetBoolean(fJ20)
                  +GetBoolean(fJ60)
                  +GetBoolean(fWithSource)
                  //+GetPlatForm
                  +GetGroup
                  +GetCategory
                  +GetAuthorInfo;
            end;
      end;
end;

function TdmDisplayResults.GetFileDetailHTML(FileID:Integer):String;
begin
   With DSPdm,tblFiles do
      If FindKey([FileID]) then Result:=FileDetails(True)
      Else Result:='DSP#'+IntToStr(FileID)+': ' + MacroStart +'mcFileDetailsMissing' + MacroEnd;
end;

end.
