unit BackupEditPadProColors_fmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Memo;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  IniFiles;

procedure TForm1.Button1Click(Sender: TObject);
var
  ini: TIniFile;
  SyntaxColorsSection: string;
  SyntaxColors0, SyntaxColors1, SyntaxColors2: string;
  SyntaxColorsRegex0, SyntaxColorsRegex1, SyntaxColorsRegex2: string;
  y: TStringList;

  function SectionToStr(const InSectionName: string): string;
  begin
    if NOT Assigned(y) then
      y := TStringList.Create;
    ini.ReadSectionValues (InSectionName, y);
    Result := '[' + InSectionName + ']' + sLineBreak + y.Text;
  end;
begin
  ini := nil;
  y := nil;
  Memo1.Lines.Clear;
  try
    ini := TIniFile.Create('C:\Users\orchid\AppData\Roaming\JGsoft\' +
      'EditPad Pro 7\EditPadPro7.ini');
    SyntaxColorsSection := SectionToStr('SyntaxColors');
    Memo1.Lines.Add(SyntaxColorsSection);

    SyntaxColors0 := SectionToStr('SyntaxColors0');
    Memo1.Lines.Add(SyntaxColors0);

    SyntaxColorsRegex0 := SectionToStr('SyntaxColorsRegex0');
    Memo1.Lines.Add(SyntaxColorsRegex0);

    SyntaxColors1 := SectionToStr('SyntaxColors1');
    Memo1.Lines.Add(SyntaxColors1);

    SyntaxColorsRegex1 := SectionToStr('SyntaxColorsRegex1');
    Memo1.Lines.Add(SyntaxColorsRegex1);

    SyntaxColors2 := SectionToStr('SyntaxColors2');
    Memo1.Lines.Add(SyntaxColors2);

    SyntaxColorsRegex2 := SectionToStr('SyntaxColorsRegex2');
    Memo1.Lines.Add(SyntaxColorsRegex2);

  finally
    FreeAndNil(y);
    FreeAndNil(ini);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
const
  cSaveAs = 'D:\Projects\webhubdemos\Source\WhtekoSyntaxColoring\' +
    'EditPadPro_v7\EditPad_Colors_Backup.ini';
begin
  //StringWriteToFile(cSaveAs, Memo1.Lines.Text);   // uses ucLogFil
  Memo1.Lines.SaveToFile(cSaveAs);
end;

end.
