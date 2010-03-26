unit DSP_fmPanelSearch;
//
//WebHub-App Dependencies:
//(none)
//

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   TpMenu, UpdateOk, tpAction, IniLink, {} Toolbar, ExtCtrls,
   StdCtrls, ComCtrls, DBCtrls, Grids, DBGrids, TxtGrid,
   Dbstrgrd, db, DSP_fmPanel, tpCompPanel;

type
   TfmSearchForm = class(TfmPanel)
      tsWords: TTabSheet;
      DBGrid1: TDBGrid;
      DBNavigator1: TDBNavigator;
      tsFiles: TTabSheet;
      DBGrid2: TDBGrid;
      DBNavigator2: TDBNavigator;
      Panel1: TPanel;
      btMake: TButton;
      SearchPanel: TPanel;
      SearchValue: TMemo;
      ListBox: TListBox;
      coGroup: TComboBox;
      Label1: TLabel;
      Label2: TLabel;
      SearchExclude: TMemo;
      Label3: TLabel;
      GroupBox1: TGroupBox;
      cbD10: TCheckBox;
      cbD20: TCheckBox;
      cbD30: TCheckBox;
      cbD40: TCheckBox;
      cbD50: TCheckBox;
      cbD60: TCheckBox;
      cbD70: TCheckBox;
      cbD80: TCheckBox;
      cbD2K5: TCheckBox;
      GroupBox2: TGroupBox;
      Panel2: TPanel;
      mDetails: TMemo;
      mWords: TMemo;
      coFuzzy: TComboBox;
      Label4: TLabel;
      Panel3: TPanel;
      tpLabel1: TLabel;
      Button1: TButton;
      cbC10: TCheckBox;
      cbC30: TCheckBox;
      cbC40: TCheckBox;
      cbC50: TCheckBox;
      cbC60: TCheckBox;
      cbK10: TCheckBox;
      cbK20: TCheckBox;
      cbK30: TCheckBox;
      btnShowWords: TButton;
      cbJ10: TCheckBox;
      cbJ20: TCheckBox;
      cbJ60: TCheckBox;
      cbWithSource: TCheckBox;
      cbFree: TCheckBox;
      procedure CheckBox1Click(Sender: TObject);
      procedure btMakeClick(Sender: TObject);
      procedure Button1Click(Sender: TObject);
      procedure ListBoxClick(Sender: TObject);
      procedure btnShowWordsClick(Sender: TObject);
   private
      { Private declarations }
   public
      { Public declarations }
      function Init:boolean; override;
   end;

var
   fmSearchForm: TfmSearchForm;
              
implementation

uses
  ucDlgs, ucString,
  DSP_dmRubicon, DSP_dmDisplayResults, uDSPFuzziness;

{$R *.DFM}

function TfmSearchForm.Init:Boolean;
var i:integer;
begin       //initialization in ancestor sets up the GUI panels.
   Result := inherited Init;
   If not Result then Exit; //we've already initialized the unit exit here, because init was already performed below.
   If assigned(DSPdm) then
      begin
         With DSPdm.GroupNameList, coGroup do
            begin
               Items.Clear;
               For i:= 0 to pred(count) do
                  Items.Add(RightOfEqual(Strings[i]));
               ItemIndex:=0;
            end;
         { Make sure that the DataSource is hooked up; otherwise all searches yield
         zero matches. }
         DBNavigator1.DataSource := DSPdm.dsWords;
      end;
   coFuzzy.ItemIndex:=0;
end;

procedure TfmSearchForm.CheckBox1Click(Sender: TObject);
begin
   Inherited;
{
  with checkbox1,dmSearches do
    if checked then begin
      fLastSearchMemo:=Memo1;
      fLastSearchResult:=Label2;
      fLast:=lbLast;
      fDiff:=lbDiff;
      fWhat:=lbWhat;
      end
    else begin
      fLastSearchMemo:=nil;
      fLastSearchResult:=nil;
      fLast:=nil;
      fDiff:=nil;
      fWhat:=nil;
      end;
  Memo1.lines.clear;
  Label2.caption:='';   {}
end;

procedure TfmSearchForm.btMakeClick(Sender: TObject);
begin
   Inherited;
   With DSPdm do DoMake;
end;

procedure TfmSearchForm.Button1Click(Sender: TObject);
var
   a0,a1,a2,a3,a4:string;
   i,n:integer;
   StartTime, EndTime, ElapsedTime: dword;
   b:boolean;
   bFuzzy:Boolean;
   FuzzLevel:TFuzzyness;
   maxDWord: dword;

   function GetBoolean(Value:TCheckBox): String;
   begin
      If assigned(Value) and Value.Checked then Result:= 'zzz'+copy(Value.Name,3,255)
      Else Result:='';
   end;
begin
   Inherited;
   ToolBar.Caption:='';
   ListBox.Items.Clear;
   mDetails.Lines.Clear;
   mWords.Lines.Clear;

   StartTime:=GetTickCount;
   MaxDword := MaxLongint;  // doing this avoids compiler warning (compared to using
                           // MaxLongint in an expression with dwords).

   a1 := StringReplaceAll(SearchValue.Lines.Text, sLineBreak, ' ');
   a0 := StringReplaceAll(SearchExclude.Lines.Text, sLineBreak, ' ');
   a2:=     GetBoolean(cbD10)
            +' '+ GetBoolean(cbD20)
            +' '+ GetBoolean(cbD30)
            +' '+ GetBoolean(cbD40)
            +' '+ GetBoolean(cbD50)
            +' '+ GetBoolean(cbD60)
            +' '+ GetBoolean(cbD70)
            +' '+ GetBoolean(cbD80)
            +' '+ GetBoolean(cbD2K5)
            +' '+ GetBoolean(cbK10)
            +' '+ GetBoolean(cbK20)
            +' '+ GetBoolean(cbK30)
            +' '+ GetBoolean(cbC10)
            +' '+ GetBoolean(cbC30)
            +' '+ GetBoolean(cbC40)
            +' '+ GetBoolean(cbC50)
            +' '+ GetBoolean(cbC60)
            +' '+ GetBoolean(cbJ10)
            +' '+ GetBoolean(cbJ20)
            +' '+ GetBoolean(cbJ60);
   a3:=     GetBoolean(cbFree)
            +' '+ GetBoolean(cbWithSource);

   With DSPdm do
      begin
         b:=false;
         With GroupNameList do
            For i:= 0 to pred(count) do
               begin
                  b:=RightOfEqual(Strings[i])=coGroup.Text;
                  If b then Break;
               end;
         If b and (i>0) then a3:= a3+' '+GroupSearchPrefix[i]
      end;

   Try
      FuzzLevel:=TFuzzyness(coFuzzy.ItemIndex);
   Except
      FuzzLevel:=fuzAuto;
   End;

   With DSPdm do
      begin
         a1:=ZapTrailing(a1,' ');
         a0:=ZapTrailing(a0,' ');
         a2:=ZapTrailing(a2,' ');
         a3:=ZapTrailing(a3,' ');

         bFuzzy:=false; //not used right now.
         n:=PerformSearch(rbSearch, a1,a0,a2,a3,FuzzLevel,a4, SearchWords);
         If n=0 then
            begin
               If bFuzzy then a0:='Fuzzy search for ['+a4+'] found no matches.'
               Else a0:='Search returned no matches.'
               //none
            end
         Else{if ShowWords then}
            begin //show the words:
               If bFuzzy then a0:='Fuzzy search for ['+a4+'] used these words:'+sLineBreak
               Else a0:='Search used these words:'+sLineBreak;
               //how many instances per word:
               With SearchWords do
                  For i:=0 to pred(count) do
                     a0:=a0+Strings[i]+', '+IntToStr(WordCount(Strings[i]))+sLineBreak;
            end;
         mWords.Lines.Text:=a0;

         // Note that GetTickCount rolls back to 0 after approximately 21 days if NT is not rebooted.
         EndTime := GetTickCount;
         If EndTime > StartTime then ElapsedTime := EndTime-StartTime
         Else ElapsedTime := (MaxDWord-StartTime) + EndTime;

         n:=0;
         With ListBox.Items,rbSearch do
            begin
               i:= MatchBits.FirstSet;
               While (i<>-1) do
                  begin
                     Inc(n);
                     Add(inttostr(i+TextLink.MinIndex));
                     i:= MatchBits.NextSet(i);
                  end;
            end;
      end;

   If n > 0 then
   begin
     ToolBar.Caption := Format(
       '%d Matches found, scroll through the listbox to see the details.', [n]);
     Application.MainForm.Activecontrol := ListBox;
     ListBox.ItemIndex:=0;
   end
   Else
   begin
     ToolBar.Caption := 'No Matches found.';
     If coGroup.ItemIndex>0 then
       Application.MainForm.ActiveControl := coGroup
     Else
     If searchvalue.lines.text<>'' then
       Application.MainForm.ActiveControl := searchvalue
     Else
     If SearchExclude.lines.text<>'' then
       Application.MainForm.ActiveControl := SearchExclude
     Else
       Application.MainForm.ActiveControl := searchvalue;
   end;
   ToolBar.Caption:= ToolBar.Caption + '  ('+IntToStr(ElapsedTime)+'ms)';
   ListBoxClick(nil);
end;

procedure TfmSearchForm.ListBoxClick(Sender: TObject);
begin
   Inherited;
   if ListBox.ItemIndex > -1 then
   With DSPdm,dmDisplayResults,ListBox do
      If tblFiles.FindKey([Items[ItemIndex]]) then
        mDetails.Lines.Text := FileDetails(False)
      Else
        mDetails.Lines.Text := 'File *NOT* Found!';
end;

procedure TfmSearchForm.btnShowWordsClick(Sender: TObject);
begin
   Inherited;
   With DBGrid1 do
      begin
         If Assigned(DataSource) then DataSource := nil
         Else
            begin
               DataSource := DSPdm.dsWords;
               If NOT DSPdm.dsWords.DataSet.Active then DSPdm.dsWords.DataSet.Open;
            end;
      end;
end;

end.
