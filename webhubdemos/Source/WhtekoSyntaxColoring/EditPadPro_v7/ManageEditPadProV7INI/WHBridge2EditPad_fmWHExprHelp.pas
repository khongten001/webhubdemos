unit WHBridge2EditPad_fmWHExprHelp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  WHBridge2EditPad_uLoadWHCommands, FMX.Layouts, FMX.Edit;

type
  TfmWebHubExpressionHelp = class(TForm)
    WinStyleBookJet: TStyleBook;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    ScaledLayout1: TScaledLayout;
    WinStyleBookDiamond: TStyleBook;
    LabelCommandNames: TLabel;
    Panel3: TPanel;
    LabelHelp: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PrimaryComboEnter(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
  private
    { Private declarations }
    FActiveIdx: Integer;
    LabelCommandP: TLabel;
    LabelCommand: TComboEdit;
    LabelHintP, LabelHint: TLabel;
    LabelSyntaxP, LabelSyntax: TLabel;
    WebHubCommandInfoList: TWebHubCommandInfoList;
    AnyP: Array of TLabel;
    AnyE: Array of TEdit;
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

procedure TfmWebHubExpressionHelp.Button1Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TfmWebHubExpressionHelp.CreateInputForm(const AWebHubCommand: string);
var
  i, j, idx: Integer;
  jdx: Integer;
  n: Integer;
const
  TopLine = 1;
  LineInc = 18;
  AnyLineInc = 25;
  cTabStop: Single = 120;

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
          FActiveIdx := i;
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
    Width := 100;
    Text := 'Command:';
    TextSettings.HorzAlign := TTextAlign.Trailing;
    StyleName := 'labelstyle';
  end;
  LabelHintP := TLabel.Create(Self);
  LabelHintP.Name := 'LabelHintP';
  with LabelHintP do
  begin
    Parent := ScaledLayout1;
    Position.X := 10;
    Position.Y := TopLine + (1.4 * LineInc);
    Width := LabelCommandP.Width;
    Text := 'Hint:';
    TextSettings.HorzAlign := TTextAlign.Trailing;
    StyleName := 'labelstyle';
  end;
  LabelSyntaxP := TLabel.Create(Self);
  LabelSyntaxP.Name := 'LabelSyntaxP';
  with LabelSyntaxP do
  begin
    Parent := ScaledLayout1;
    Position.X := 10;
    Position.Y := LabelHintP.Position.Y + LineInc + LineInc;
    Width := LabelCommandP.Width;
    Text := 'Syntax:';
    TextSettings.HorzAlign := TTextAlign.Trailing;
    StyleName := 'labelstyle';
  end;

  if idx >= 0 then
  begin
    LabelCommand := TComboEdit.Create(Self);
    LabelCommand.Name := 'LabelCommand';
    with LabelCommand do
    begin
      Parent := ScaledLayout1;
      Position.X := cTabStop;
      Position.Y := TopLine;
      Text := AWebHubCommand;
      OnEnter := PrimaryComboEnter;
      Items.Add(WebHubCommandInfoList[idx].WHCommandNames[0]);
      if High(WebHubCommandInfoList[idx].WHCommandNames) > 0 then
        Items.Add(WebHubCommandInfoList[idx].WHCommandNames[1]);
      StyleName := 'labelstyle';
    end;

    LabelHint := TLabel.Create(Self);
    LabelHint.Name := 'LabelHint';
    with LabelHint do
    begin
      Parent := ScaledLayout1;
      Position.X := cTabStop;
      Position.Y := LabelCommand.Position.Y + (1.4 * LineInc);
      Height := 20;
      TextSettings.WordWrap := True;
      TextSettings.VertAlign := TTextAlign.Leading;
      AutoSize := True;
      Width := 400;
      Text := WebHubCommandInfoList[idx].WHHint;
      CSSend('WHHint', WebHubCommandInfoList[idx].WHHint);
      StyleName := 'labelstyle';
    end;

    LabelSyntax := TLabel.Create(Self);
    LabelSyntax.Name := 'LabelSyntax';
    with LabelSyntax do
    begin
      Parent := ScaledLayout1;
      Position.X := cTabStop;
      Position.Y := LabelHint.Position.Y + LineInc + LineInc;
      Width := 500;
      WordWrap := True;
      Text := WebHubCommandInfoList[idx].WHSyntax;
      AutoSize := True;
      CSSend('WHSyntax', WebHubCommandInfoList[idx].WHSyntax);
      StyleName := 'labelstyle';
    end;

    jdx := idx + 1;
    n := 0;
    while WebHubCommandInfoList[jdx].WHSort > 0 do
    begin
      SetLength(AnyP, n + 1);
      SetLength(AnyE, n + 1);
      AnyP[n] := TLabel.Create(Self);
      AnyP[n].Name := 'AnyP' + IntToStr(n);
      with AnyP[n] do
      begin
        Parent := ScaledLayout1;
        Position.X := 10;
        Position.Y := LabelSyntax.Position.Y + LabelSyntax.Height +
          (Succ(N) * AnyLineInc);
        Width := LabelCommandP.Width * 1.2;
        Text := WebHubCommandInfoList[jdx].WHCaption;
        TextSettings.HorzAlign := TTextAlign.Trailing;
        StyleName := 'labelstyle';
        Scale.X := 0.85;
        Scale.Y := 0.85;
      end;
      AnyE[n] := TEdit.Create(Self);
      AnyE[n].Name := 'AnyE' + IntToStr(n);
      with AnyE[n] do
      begin
        Parent := ScaledLayout1;
        OnEnter := Edit1Enter;
        Position.X := cTabStop;
        Position.Y := LabelSyntax.Position.Y + LabelSyntax.Height +
          (Succ(N) * AnyLineInc);
        Text := '';
        TextSettings.HorzAlign := TTextAlign.Leading;
        //Hint := WebHubCommandInfoList[jdx].WHHint;
        Scale.X := 0.95;
        Scale.Y := 0.95;
      end;
      Inc(n);
      Inc(jdx);
    end;



  end
  else
    Self.Caption := 'ERROR. Keyword not found.';

end;

procedure TfmWebHubExpressionHelp.Edit1Enter(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to High(AnyE) do
  begin
    if TEdit(Sender) = AnyE[i] then
      LabelHelp.Text := WebHubCommandInfoList[fActiveIdx + 1 + i].WHHint;
  end;
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
  SetLength(AnyP, 0);
  SetLength(AnyE, 0);

  LabelHelp.Text := '';

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

procedure TfmWebHubExpressionHelp.PrimaryComboEnter(Sender: TObject);
begin
  LabelHelp.Text := WebHubCommandInfoList[fActiveIdx].WHHint;
end;

initialization

end.
