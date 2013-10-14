unit SCRuleTest_fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  ldi.RegEx.RegularExpressions, Vcl.Menus;

type
  TForm3 = class(TForm)
    GroupBox1: TGroupBox;
    MemoMacros: TMemo;
    GroupBox2: TGroupBox;
    MemoRegex: TMemo;
    GroupBox3: TGroupBox;
    MemoURLs: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    GroupBox4: TGroupBox;
    MemoMatched: TMemo;
    GroupBox5: TGroupBox;
    MemoExpandedRegex: TMemo;
    Splitter1: TSplitter;
    MemoMatchCount: TMemo;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Save1: TMenuItem;
    Open1: TMenuItem;
    EditTestName: TEdit;
    Splitter2: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
  strict private
    { Private declarations }
    FRegEx: TldiRegExMulti;
    function TestDataRegexFilespec: string;
    function TestDataURLsFilespec: string;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses
  ucString, ucLogFil;

procedure TForm3.Button1Click(Sender: TObject);
var
  bContinue: Boolean;
  S1: string;
  APattern8: UTF8String;
  i: Integer;
  MacroName, MacroValue: string;

  iPattern: Integer;
  PatternStatus: TPatternStatus;
  //MatchCollection: TMatchCollection;
  MatchResult: TMatchResult;
  S8: UTF8String;
  b2: Boolean;
  j: Integer;
begin
  MemoMatched.Clear;
  MemoExpandedRegex.Clear;
  MemoMatchCount.Clear;
  MatchResult := nil;

  bContinue := MemoRegex.Lines.Count > 0;
  if bContinue then
  try
    S1 := Trim(MemoRegex.Lines.Text);
    for i := 0 to Pred(MemoMacros.Lines.Count) do
    begin
      if SplitString(MemoMacros.Lines[i], '=', MacroName, MacroValue) then
        S1 := StringReplaceAll(S1, MacroName, MacroValue);
    end;
    MemoExpandedRegex.Lines.Text := S1;
    APattern8 := UTF8String(S1);

    bContinue := FRegEx.AddPattern8(APattern8, iPattern, PatternStatus,
        [poDotMatchesAll] {i.e. NOT poIgnoreCase});
  except
    on E: Exception do
    begin
      MemoMatched.Lines.Text := E.Message;
      bContinue := False;
    end;
  end;

  if bContinue then
  begin
    try
      MatchResult := TMatchResult.Create;

      for i := 0 to Pred(MemoURLs.Lines.Count) do
      begin
        s8 := UTF8String(Trim(MemoURLs.Lines[i]));
        if S8 <> '' then
        begin
          b2 := FRegEx.Match8(iPattern, MatchResult, S8);
          MemoMatchCount.Lines.Add(
            Format('GroupCount =%4d', //BoolToStr(b2, True),
              [MatchResult.GroupCount]));
          if (i=0) and (MatchResult.GroupCount > 0) then
          begin
            for j := 0 to Pred(MatchResult.GroupCount) do
            begin
              MemoMatched.Lines.Add(Format('Group%4d%s%s',
                [j, #9#9, MatchResult.GroupValue8(j)]));   //..GroupValue8(0)]));
            end;
          end;
        end
        else
          MemoMatchCount.Lines.Add('(blank)');
      end;
    finally
      FreeAndNil(MatchResult);
    end;
  end
  else
    MemoMatched.Lines.Add('bContinue False');
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  FRegEx := TldiRegExMulti.Create(Self);
  Self.Top := 10;
  Self.Height := Screen.Height - 50;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FRegex);
end;

function TForm3.TestDataRegexFilespec: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'SCRuleTest_' + EditTestName.Text +
    '_regex.ini';
end;

function TForm3.TestDataURLsFilespec: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'SCRuleTest_' + EditTestName.Text +
    '_urls.ini';
end;

function RegexMacrosFilespec: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'SCRuleTest_Macros.ini';
end;

procedure TForm3.Open1Click(Sender: TObject);
begin
  if FileExists(RegexMacrosFilespec) then
    MemoMacros.Lines.Text := StringLoadFromFile(RegexMacrosFilespec)
  else
    MemoMacros.Lines.Text := RegexMacrosFilespec + ' not found';
  if FileExists(TestDataRegexFilespec) then
    MemoRegex.Lines.Text := StringLoadFromFile(TestDataRegexFilespec)
  else
    MemoRegex.Lines.Text := TestDataRegexFilespec + ' not found';
  if FileExists(TestDataURLsFilespec) then
    MemoURLs.Lines.Text := StringLoadFromFile(TestDataURLsFilespec)
  else
    MemoURLs.Lines.Text := TestDataURLsFilespec + ' not found';
  MemoMatched.Clear;
  MemoExpandedRegex.Clear;
  MemoMatchCount.Clear;
end;

procedure TForm3.Save1Click(Sender: TObject);
begin
  StringWriteToFile(RegexMacrosFilespec,   MemoMacros.Lines.Text);
  StringWriteToFile(TestDataRegexFilespec, MemoRegex.Lines.Text);
  StringWriteToFile(TestDataURLsFilespec,  MemoURLs.Lines.Text);
end;

end.
