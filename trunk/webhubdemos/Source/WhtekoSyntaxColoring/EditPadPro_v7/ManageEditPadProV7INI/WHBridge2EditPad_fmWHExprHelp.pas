unit WHBridge2EditPad_fmWHExprHelp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  WHBridge2EditPad_uLoadWHCommands, FMX.Layouts, FMX.Edit,
  WebHubDWSourceUtil_uGlobal, WebHubDWSourceUtil_uSyntaxRegex,
  WHBridge2EditPad_uExpressionReplacement;

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
    ButtonHelp: TButton;
    StyleBook1: TStyleBook;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PrimaryComboEnter(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
  private
    { Private declarations }
    FActiveIdx: Integer;
    LabelCommandP: TLabel;
    LabelCommand: TComboEdit;
    LabelHintP, LabelHint: TLabel;
    LabelSyntaxP, LabelSyntax: TLabel;
    //WebHubCommandInfoList: TWebHubCommandInfoList;
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
  uCode, ucPos, ucShell, ucCodeSiteInterface;

procedure TfmWebHubExpressionHelp.Button1Click(Sender: TObject);
var
  ActiveCommandDef: TwhCommandDef;
  whSyntax: TwhSyntax;
begin
  ActiveCommandDef := whCommands[fActiveIdx];
  ExtractSyntax(ActiveCommandDef, whSyntax);
  ExtractParseParams(ActiveCommandDef, whSyntax);
  CSSend('SyntaxRegEx', whSyntax.SyntaxRegEx);
  //Self.Close;
end;

procedure TfmWebHubExpressionHelp.ButtonHelpClick(Sender: TObject);
var
  keyword: string;
begin
  keyword := Lowercase(ParamString('-word'));
  WinShellOpen('http://www.href.com/pub/docsnhelp/whQuickRefForCommands.html#' +
    keyword);
end;

procedure TfmWebHubExpressionHelp.CreateInputForm(const AWebHubCommand: string);
const cFn = 'CreateInputForm';
var
  n: Integer;
  AGroupID: string;
  GroupCategoryIdx, CategoryCommandIdx: Integer;
  ActiveCommandDef: TwhCommandDef;
  paramidx: Integer;
const
  TopLine = 1;
  LineInc = 18;
  AnyLineInc = 25;
  cPromptTabStop = 2;
var
  cTabStop: Single;
begin
  CSEnterMethod(Self, cFn);
  CSSend('AWebHubCommand', AWebHubCommand);

  if FindCommandInArrays(AWebHubCommand, AGroupID, GroupCategoryIdx,
    CategoryCommandIdx, fActiveIdx) then
  begin
    //CSSend(AGroupID + ' ' + 'CommandIDX=' + S(fActiveIdx));
    ActiveCommandDef := whCommands[fActiveIdx];

    CSSend('MaxCommandParamNameLength', S(ActiveCommandDef.MaxCommandParamNameLength));
    cTabStop := 120; // 20 + (5 * ActiveCommandDef.MaxCommandParamNameLength); //120;

    LabelCommandNames.Text := ActiveCommandDef.CommandName[0];
    //CSSend('CommandNamesCommaSep', ActiveCommandDef.CommandNamesCommaSep);
    CSSend('Template', ActiveCommandDef.Template);

    if High(ActiveCommandDef.CommandName) > 0 then
      LabelCommandNames.Text := LabelCommandNames.Text + ' or ' +
        ActiveCommandDef.CommandName[1];
    LabelCommandNames.Text := LabelCommandNames.Text + ' command';

    LabelCommandP := TLabel.Create(Self);
    LabelCommandP.Name := 'LabelCommandP';
    with LabelCommandP do
    begin
      Parent := ScaledLayout1;
      Position.X := cPromptTabStop;
      Position.Y := TopLine;
      Width := 100;
      Text := 'Command:';
      TextSettings.HorzAlign := TTextAlign.Trailing;
      StyleName := 'labelstyle';
    end;
    (*
    LabelHintP := TLabel.Create(Self);
    LabelHintP.Name := 'LabelHintP';
    with LabelHintP do
    begin
      Parent := ScaledLayout1;
      Position.X := cPromptTabStop;
      Position.Y := TopLine + (1.4 * LineInc);
      Width := LabelCommandP.Width;
      Text := 'Hint:';
      TextSettings.HorzAlign := TTextAlign.Trailing;
      StyleName := 'labelstyle';
    end;*)
    LabelSyntaxP := TLabel.Create(Self);
    LabelSyntaxP.Name := 'LabelSyntaxP';
    with LabelSyntaxP do
    begin
      Parent := ScaledLayout1;
      Position.X := cPromptTabStop;
      Position.Y := (TopLine + (1.4 * LineInc)) + LineInc + LineInc;
      Width := LabelCommandP.Width;
      Text := 'Syntax:';
      TextSettings.HorzAlign := TTextAlign.Trailing;
      StyleName := 'labelstyle';
    end;

    LabelCommand := TComboEdit.Create(Self);
    LabelCommand.Name := 'LabelCommand';
    with LabelCommand do
    begin
      Parent := ScaledLayout1;
      Position.X := cTabStop;
      Position.Y := TopLine;
      Text := AWebHubCommand;
      OnEnter := PrimaryComboEnter;
      Items.Add(ActiveCommandDef.CommandName[0]);
      if High(ActiveCommandDef.CommandName) > 0 then
        Items.Add(ActiveCommandDef.CommandName[1]);
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
      Text := ActiveCommandDef.CommandSummary; // hint
      //CSSend('CommandSummary', Text);
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
      Text := ActiveCommandDef.Syntax; // WebHubCommandInfoList[idx].WHSyntax;
      AutoSize := True;
      //CSSend('WHSyntax', WebHubCommandInfoList[idx].WHSyntax);
      StyleName := 'labelstyle';
    end;


    n := 0;

    for paramidx := 0 to High(ActiveCommandDef.CommandParams) do
    begin
      SetLength(AnyP, n + 1);
      SetLength(AnyE, n + 1);
      AnyP[n] := TLabel.Create(Self);
      AnyP[n].Name := 'AnyP' + IntToStr(n);
      with AnyP[n] do
      begin
        Parent := ScaledLayout1;
        Position.X := cPromptTabStop;
        Position.Y := LabelSyntax.Position.Y + LabelSyntax.Height +
          (Succ(N) * AnyLineInc);
        Width := LabelCommandP.Width * 1.2;
        Text := ActiveCommandDef.CommandParams[paramidx].Prompt;
        //Text := WebHubCommandInfoList[jdx].WHCaption;
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
        Scale.X := 0.95;
        Scale.Y := 0.95;
      end;
      Inc(n);
    end;
    if FindImportantInputText then
      LabelHelp.Text := ActiveWebHubExtract;
  end
  else
    Self.Caption := 'ERROR. Keyword not found.';

  CSExitMethod(Self, cFn);
end;

procedure TfmWebHubExpressionHelp.Edit1Enter(Sender: TObject);
const cFn = 'Edit1Enter';
var
  i: Integer;
begin
  for i := 0 to High(AnyE) do
  begin
    if TEdit(Sender) = AnyE[i] then
    begin
      //CSSend(cFn + ' i', S(i));
      LabelHelp.Text :=
        whCommands[fActiveIdx].CommandParams[i].Hint;
    end;
  end;
end;

procedure TfmWebHubExpressionHelp.FormCreate(Sender: TObject);
var
  AWebHubCommand: string;
  sList: TStringList;
  InfoMessage: string;
begin
  sList := nil;
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
  ScaledLayout1.Scale.X := 1.7;
  ScaledLayout1.Scale.Y := 1.7;

  Self.Caption := 'WebHub Expression Editor';

  try
    sList := GetStringListResource('WebHubCommandsTabDelim');
    if Assigned(sList) then
    begin
      if NOT LoadCommandDefinitions(sList, InfoMessage) then
        CSSendError('LoadCommandDefinitions FAILED');
      if InfoMessage <> '' then
        CSSend(InfoMessage);
    end;
  finally
    FreeAndNil(sList);
  end;

  AWebHubCommand := ParamString('-word');
  if AWebHubCommand = '' then
  begin
    LabelCommandNames.Text := '(blank)';
  end
  else
  begin
    CreateInputForm(AWebHubCommand);
  end;
end;

procedure TfmWebHubExpressionHelp.PrimaryComboEnter(Sender: TObject);
begin
  LabelHelp.Text := 'hint pending'; //WebHubCommandInfoList[fActiveIdx].WHHint;
end;

initialization

end.
