unit WHBridge2EditPad_fmWHExprHelp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  WHBridge2EditPad_uLoadWHCommands, FMX.Layouts;

type
  TfmWebHubExpressionHelp = class(TForm)
    WinStyleBookJet: TStyleBook;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    ScaledLayout1: TScaledLayout;
    WinStyleBookDiamond: TStyleBook;
    Label2: TLabel;
    LabelCommandNames: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    LabelCommandP, LabelCommand: TLabel;
    LabelHintP, LabelHint: TLabel;
    LabelSyntaxP, LabelSyntax: TLabel;
    WebHubCommandInfoList: TWebHubCommandInfoList;
  public
    { Public declarations }
    procedure CreateInputForm(const AWebHubCommand: string);
  end;

var
  fmWebHubExpressionHelp: TfmWebHubExpressionHelp;

implementation

{$R *.fmx}

uses
  uCode, ucPos, ucCodeSiteInterface;

procedure TfmWebHubExpressionHelp.CreateInputForm(const AWebHubCommand: string);
var
  i, j, idx: Integer;
const
  TopLine = 10;
  LineInc = 18;
  cTabStop: Single = 80;
begin

  idx := -1;
  for i := 0 to High(WebHubCommandInfoList) do
  begin
    for j := 0 to High(WebHubCommandInfoList[i].WHCommandNames) do
    begin
      if (SameText(AWebHubCommand, WebHubCommandInfoList[i].WHCommandNames[j]))
      then
      begin
        if WebHubCommandInfoList[i].WHSort = 0 then
        begin
          idx := i;
          LabelCommandNames.Text := WebHubCommandInfoList[i].WHCommandNames[0];
          if High(WebHubCommandInfoList[i].WHCommandNames) > 0 then
            LabelCommandNames.Text := LabelCommandNames.Text + ' or ' +
              WebHubCommandInfoList[i].WHCommandNames[1];
          LabelCommandNames.Text := LabelCommandNames.Text + ' command';
          break;
        end;
      end;
    end;
  end;

  LabelCommandP := TLabel.Create(Self);
  LabelCommandP.Name := 'LabelCommandP';
  with LabelCommandP do
  begin
    Parent := ScaledLayout1;
    Position.X := 10;
    Position.Y := TopLine;
    Width := 60;
    Text := 'Command:';
    //Align := TAlignLayout.Right;
    StyleName := 'labelstyle';
  end;
  LabelHintP := TLabel.Create(Self);
  LabelHintP.Name := 'LabelHintP';
  with LabelHintP do
  begin
    Parent := ScaledLayout1;
    Position.X := 10;
    Position.Y := TopLine + LineInc;
    Width := 60;
    Text := 'Hint:';
    //Align := TAlignLayout.Right;
    StyleName := 'labelstyle';
  end;
  LabelSyntaxP := TLabel.Create(Self);
  LabelSyntaxP.Name := 'LabelSyntaxP';
  with LabelSyntaxP do
  begin
    Parent := ScaledLayout1;
    Position.X := 10;
    Position.Y := LabelHintP.Position.Y + LineInc;
    Width := 60;
    Text := 'Syntax:';
    //Align := TAlignLayout.Right;
    StyleName := 'labelstyle';
  end;

  if idx >= 0 then
  begin
    LabelCommand := TLabel.Create(Self);
    LabelCommand.Name := 'LabelCommand';
    LabelCommand.Parent := ScaledLayout1;
    LabelCommand.Position.X := cTabStop;
    LabelCommand.Position.Y := TopLine;
    LabelCommand.Text := WebHubCommandInfoList[idx].WHCommandNames[0];
    CSSend('Name 0', WebHubCommandInfoList[idx].WHCommandNames[0]);
    LabelCommand.StyleName := 'labelstyle';
    //LabelCommand.Scale.X := -0.5;
    //LabelCommand.Scale.Y := -0.5;
    Application.ProcessMessages;

    LabelHint := TLabel.Create(Self);
    LabelHint.Name := 'LabelHint';
    LabelHint.Parent := ScaledLayout1;
    LabelHint.Position.X := cTabStop;
    LabelHint.Position.Y := LabelCommand.Position.Y + LineInc;
    LabelHint.Width := 400;
    LabelHint.Text := WebHubCommandInfoList[idx].WHHint;
    CSSend('WHHint', WebHubCommandInfoList[idx].WHHint);
    LabelHint.StyleName := 'labelstyle';
    //LabelCommand.Scale.X := -0.6;
    //LabelCommand.Scale.Y := -0.6;

    LabelSyntax := TLabel.Create(Self);
    LabelSyntax.Name := 'LabelSyntax';
    with LabelSyntax do
    begin
      Parent := ScaledLayout1;
      Position.X := cTabStop;
      Position.Y := LabelHint.Position.Y + LineInc;
      Width := 900;
      WordWrap := True;
      Text := WebHubCommandInfoList[idx].WHSyntax;
      AutoSize := True;
      CSSend('WHSyntax', WebHubCommandInfoList[idx].WHSyntax);
      StyleName := 'labelstyle';
    end;

  end
  else
    Self.Caption := 'ERROR. Keyword not found.';

end;

procedure TfmWebHubExpressionHelp.FormCreate(Sender: TObject);
var
  AWebHubCommand: string;
begin
  LabelCommand := nil;
  LabelHint := nil;
  LabelSyntax := nil;
  LabelCommandP := nil;
  LabelHintP := nil;
  LabelSyntaxP := nil;

  fmWebHubExpressionHelp.StyleBook := nil;

  fmWebHubExpressionHelp.StyleBook := WinStyleBookDiamond;
  ScaledLayout1.Scale.X := 1.8;
  ScaledLayout1.Scale.Y := 1.8;

  Self.Caption := 'WebHub Expression Editor';

  WebHubCommandInfoList := LoadWebHubCommandInfo;

  AWebHubCommand := ParamString('-word');
  if AWebHubCommand = '' then
   AWebHubCommand := '(blank)';
  CreateInputForm(AWebHubCommand);
end;

procedure TfmWebHubExpressionHelp.FormDestroy(Sender: TObject);
begin
  SetLength(WebHubCommandInfoList, 0);
end;

initialization

end.
