unit CodeSiteXFer_fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  tpShareB, Vcl.StdCtrls;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelOnAt: TLabel;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  strict private
    { Private declarations }
    FGuiActive: Boolean;
    FSharedBuf: TtpSharedBuf;
    procedure BufChanged(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses
  CodeSiteLogging,
  ucString;

var
  CSLogFileDestination: TCodeSiteDestination = nil;

procedure TForm3.BufChanged(Sender: TObject);
var
  s1, s2, s3: string;
  i: Integer;
begin
  if FGuiActive then
    LabelOnAt.Caption := FormatDateTime('hh:nn:ss', Now);

  try
    if SplitThree(string(UTF8String(FSharedBuf.GlobalAnsiString)), '^^', s1, s2,
      s3) then
    begin
      FSharedBuf.GlobalAnsiString := '';
      if FGuiActive then
      begin
        Label1.Caption := s1;
        Label2.Caption := s2;
        Label3.Caption := s3;
      end;

      i := StrToIntDef(s1, -1);
      case i of
        1: // info
        begin
          CodeSite.Send(s2, s3);
        end;
        2: // warning
        begin
          CodeSite.SendWarning(s2);
        end;
        3: // error
        begin
          CodeSite.SendError(s2);
        end;
        4: // note
        begin
          CodeSite.SendNote(s2);
        end;
        5: // exception
        begin
          CodeSite.SendError('EXCEPTION: ' + s2);
        end;
        6: // EnterMethod
        begin
          CodeSite.EnterMethod(s2 + ' ' + s3);
        end;
        7: // ExitMethod
        begin
          CodeSite.ExitMethod(s2 + ' ' + s3);
        end;
        8: // Log file destination
        begin
          if CSLogFileDestination = nil then
          begin
            CSLogFileDestination := TCodeSiteDestination.Create(nil);
          end;
          CSLogFileDestination.LogFile.FilePath :=
            IncludeTrailingPathDelimiter(S2);
          CSLogFileDestination.LogFile.FileName := S3;
          CodeSite.Destination := CSLogFileDestination;
        end;
        9: // Set Enabled
        begin
          CodeSiteManager.Enabled := SameText(s2, 'true');
        end;
        10: // Reminder
        begin
          CodeSite.SendReminder(s2);
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Label1.Caption := E.Message;
      Label2.Caption := '';
      Label3.Caption := '';
    end;
  end;

end;


procedure TForm3.CheckBox1Click(Sender: TObject);
begin
  FGuiActive := Checkbox1.Checked;
  Label1.Caption := 'GUI Active: ' + BoolToStr(FGuiActive, True);
  Label2.Caption := '';
  Label3.Caption := '';
  LabelOnAt.Caption := FormatDateTime('hh:nn:ss', Now);
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  FSharedBuf := TtpSharedBuf.CreateNamed(nil, 'CodeSiteFPC', 2048);
  FSharedBuf.Name := 'FSharedBuf';
  FSharedBuf.OnChange := BufChanged;
  FSharedBuf.IgnoreOwnChanges := True;

  FGuiActive := False;
  Checkbox1.Checked := False;
  Label1.Caption := 'GUI Active: ' + BoolToStr(FGuiActive, True);
  Label2.Caption := '';
  Label3.Caption := '';
  LabelOnAt.Caption := FormatDateTime('hh:nn:ss', Now);
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FSharedBuf);
end;

initialization
finalization
  FreeAndNil(CSLogFileDestination);

end.
