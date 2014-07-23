unit WHBridge2EditPad_fmWHExprHelp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  WHBridge2EditPad_uLoadWHCommands, FMX.Layouts, FMX.Edit,
  WebHubDWSourceUtil_uGlobal, WebHubDWSourceUtil_uSyntaxRegex,
  WHBridge2EditPad_uExpressionReplacement, FMX.ListBox, FMX.Memo;

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
    ButtonOK: TButton;
    ButtonHelp: TButton;
    StyleBook1: TStyleBook;
    Panel4: TPanel;
    ButtonPreview: TButton;
    MemoPreview: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure PrimaryComboEnter(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonPreviewClick(Sender: TObject);
  private
    { Private declarations }
    FActiveIdx: Integer;
    LabelCommandP: TLabel;
    LabelCommand: TComboEdit;
    LabelHintP, LabelHint: TLabel;
    LabelSyntaxP, LabelSyntax: TLabel;
    AnyP: Array of TLabel;
    AnyE: TValidControlArray;
  public
    { Public declarations }
    procedure CreateInputForm(const AWebHubCommand: string);
  end;

var
  fmWebHubExpressionHelp: TfmWebHubExpressionHelp;

implementation

{$R *.fmx}

uses
  TypInfo,
  whMacroAffixes,
  uCode, ucString, ucPos, ucShell, ucCodeSiteInterface;

procedure TfmWebHubExpressionHelp.ButtonOKClick(Sender: TObject);
begin
  if ReplaceFileContentsNow(LabelCommand.Text, AnyE) then
    Self.Close;
end;

procedure TfmWebHubExpressionHelp.ButtonPreviewClick(Sender: TObject);
var
  TentativeResult: string;
begin
  TentativeResult := CalculateFullExpression(LabelCommand.Text, AnyE);
  MemoPreview.Lines.Text := TentativeResult;
end;

procedure TfmWebHubExpressionHelp.ButtonHelpClick(Sender: TObject);
begin
  WinShellOpen('http://www.href.com/pub/docsnhelp/whQuickRefForCommands.html#' +
    ActiveWebHubCommandWord);
end;

procedure TfmWebHubExpressionHelp.CreateInputForm(const AWebHubCommand: string);
const cFn = 'CreateInputForm';
var
  n: Integer;
  AGroupID: string;
  GroupCategoryIdx, CategoryCommandIdx: Integer;
  ActiveCommandDef: TwhCommandDef;
  paramidx: Integer;
  iRowStart: Extended;
const
  TopLine = 1;
  LineInc = 18;
  AnyLineInc = 25;
  cPromptTabStop = 2;
var
  cTabStop: Single;
var
  whSyntax: TwhSyntax;
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




    ExtractSyntax(ActiveCommandDef, whSyntax);
    ExtractParseParams(ActiveCommandDef, whSyntax);
    CSSend('SyntaxRegEx', whSyntax.SyntaxRegEx);

(*
    for paramidx := 0 to High(whSyntax.SyntaxParams) do
    begin
      begin
        if whSyntax.SyntaxParams[paramidx].ElementType = etSelect then
        begin
          {EnumeratedPrompts: value#9desc,value#9desc etc}

*)


    n := 0;
    iRowStart := LabelSyntax.Position.Y + LabelSyntax.Height + AnyLineInc;

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
        Position.Y := iRowStart;
        Width := LabelCommandP.Width * 1.2;
        Text := ActiveCommandDef.CommandParams[paramidx].Prompt;
        CSSendNote(Text);
        //Text := WebHubCommandInfoList[jdx].WHCaption;
        TextSettings.HorzAlign := TTextAlign.Trailing;
        StyleName := 'labelstyle';
        Scale.X := 0.85;
        Scale.Y := 0.85;
      end;

      with whSyntax.SyntaxParams[paramidx] do
      begin
        CSSend('ElementName', ElementName); // ElementName: string; {from syntax}
        CSSend('ElementType', GetEnumName(TypeInfo(TwhElementType), Ord(ElementType)));
        CSSend('ElementSelectType', GetEnumName(TypeInfo(TwhSelectType), Ord(ElementSelectType)));
        CSSend('ElementCols', ElementCols); // : string;
        CSSend('ElementRows', ElementRows);
        CSSend('ElementEnumeratedChoices', ElementEnumeratedChoices); // : string;
        CSSend('ElementRequired', S(ElementRequired)); // : Boolean;
        CSSend('ElementRequired', ElementPrefix); //: string;
        CSSend('ElementPrefixReqd', GetEnumName(TypeInfo(TwhPrefixReqd), Ord(ElementPrefixReqd)));
        CSSend('ElementSuffix', ElementSuffix); // : string;
        CSSend('ElementCharsToExclude', ElementCharsToExclude); // : string;  {comma separated}
        CSSend('ElementRegExExclusionSet', ElementRegExExclusionSet); // : string;
        CSSend('ElementNestLevel', S(ElementNestLevel)); // : Integer;
        CSSend('ElementIsSecondAlternate', S(ElementIsSecondAlternate)); // : Boolean;
        CSSend('ElementCaptureGroupNum', S(ElementCaptureGroupNum)); // : Integer;
        CSSend('ElementCompleted', S(ElementCompleted)); // : Boolean;
        //CSSend('ElementTestChoices: TStringList; {used for writing out test data}
        CSSend('ElementExpansionType', GetEnumName(TypeInfo(TwhExpansionType), Ord(ElementExpansionType)));
      end;


      case whSyntax.SyntaxParams[paramidx].ElementType of
        etSelect:
          begin
            {EnumeratedPrompts: value#9desc,value#9desc etc}
            AnyE[n] := TComboEdit.Create(Self);
            with TComboEdit(AnyE[n]) do
            begin
              Items.Text := StringReplaceAll(
                whSyntax.SyntaxParams[paramidx].ElementEnumeratedChoices, ',',
                sLineBreak);
              ItemIndex := 0;
            end;
          end;
        etTextarea:
          begin
            AnyE[n] := TMemo.Create(Self);
            with TMemo(AnyE[n]) do
            begin
              Height := 35;
              Width := 300;
            end;
          end
        else
        begin
          AnyE[n] := TEdit.Create(Self);
          with TEdit(AnyE[n]) do
          begin
            Width := 300;
            Scale.X := 0.95;
            Scale.Y := 0.95;
          end;
        end;
      end;
      AnyE[n].Name := 'AnyE_' + AnyE[n].ClassName + IntToStr(n);
      with AnyE[n] do
      begin
        Parent := ScaledLayout1;
        OnEnter := Edit1Enter;
        Position.X := cTabStop;
        Position.Y := iRowStart;
        if AnyE[n] is TCustomEdit then
          TCustomEdit(AnyE[n]).TextSettings.HorzAlign := TTextAlign.Leading;
      end;
      iRowStart := iRowStart + AnyE[n].Height + 10; //AnyLineInc;
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
  HintText: string;
  Note: string;
var
  ActiveCommandDef: TwhCommandDef;
  whSyntax: TwhSyntax;
begin
  CSEnterMethod(Self, cFn);
  for i := 0 to High(AnyE) do
  begin
    if TEdit(Sender) = AnyE[i] then
    begin
      CSSend(cFn + ' i', S(i));
      HintText := StringReplaceAll(
        whCommands[fActiveIdx].CommandParams[i].Hint, '%command%',
          Uppercase(LabelCommand.Text));
      CSSend(HintText);
      ActiveCommandDef := whCommands[fActiveIdx];
      ExtractSyntax(ActiveCommandDef, whSyntax);
      ExtractParseParams(whCommands[fActiveIdx], whSyntax);
      CSSend('count', S(High(whSyntax.SyntaxParams)));
      if i <= High(whSyntax.SyntaxRegEx) then
      begin
        case whSyntax.SyntaxParams[i].ElementExpansionType of
          etUnknown: Note := '';
          etNever: note := '(n)';
          etAlways: note := '(a)';
          etExplicit: note := '(e)';
          etImplicit: note := '(i)';
          etConditional: note := '(c)';
        end;
      end;

      LabelHelp.Text := HintText + ' ' + Note;
    end;
  end;
  CSExitMethod(Self, cFn);
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
  MemoPreview.Lines.Clear;
  MemoPreview.TextSettings.Font.Style := [TFontStyle.fsBold];
  //MemoPreview.Scale.X := 1.4;
  //MemoPreview.Scale.Y := 1.4;

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
  LabelHelp.Text := '';
end;

initialization

end.
