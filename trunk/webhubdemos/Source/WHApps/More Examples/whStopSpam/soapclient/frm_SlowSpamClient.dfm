object frmSlowSpamClient: TfrmSlowSpamClient
  Left = 168
  Top = 139
  BorderStyle = bsDialog
  Caption = 'Slow Spam Client'
  ClientHeight = 301
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 25
  object lblInput: TLabel
    Left = 16
    Top = 16
    Width = 42
    Height = 25
    Caption = 'Input'
  end
  object lblOutput: TLabel
    Left = 16
    Top = 137
    Width = 57
    Height = 25
    Caption = 'Output'
  end
  object edtInput: TEdit
    Left = 16
    Top = 40
    Width = 425
    Height = 33
    TabOrder = 0
    Text = 'Sample Text'
  end
  object chkReadyForWeb: TCheckBox
    Left = 16
    Top = 90
    Width = 425
    Height = 17
    Caption = 'Make Result Ready To Copy From Web'
    TabOrder = 1
    WordWrap = True
  end
  object edtOutput: TEdit
    Left = 16
    Top = 168
    Width = 425
    Height = 33
    ReadOnly = True
    TabOrder = 2
  end
  object btnTest: TBitBtn
    Left = 360
    Top = 79
    Width = 178
    Height = 40
    Caption = '1. Request'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 3
    OnClick = btnTestClick
  end
  object btnClose: TBitBtn
    Left = 360
    Top = 253
    Width = 178
    Height = 40
    Caption = 'E&xit'
    Kind = bkClose
    NumGlyphs = 2
    TabOrder = 4
  end
  object BtnShowResult: TBitBtn
    Left = 360
    Top = 207
    Width = 178
    Height = 40
    Caption = '2/ Show Result'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 5
    OnClick = BtnShowResultClick
  end
  object BitBtnTestString: TBitBtn
    Left = 16
    Top = 253
    Width = 241
    Height = 40
    Caption = '3. Test String Response'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 6
    OnClick = BitBtnTestStringClick
  end
end
