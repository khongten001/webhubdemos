object frmSlowSpamClient: TfrmSlowSpamClient
  Left = 168
  Top = 139
  BorderStyle = bsDialog
  Caption = 'Slow Spam Client'
  ClientHeight = 236
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 16
  object lblInput: TLabel
    Left = 16
    Top = 16
    Width = 28
    Height = 16
    Caption = 'Input'
  end
  object lblOutput: TLabel
    Left = 16
    Top = 104
    Width = 38
    Height = 16
    Caption = 'Output'
  end
  object edtInput: TEdit
    Left = 16
    Top = 40
    Width = 425
    Height = 24
    TabOrder = 0
    Text = 'Sample Text'
  end
  object chkReadyForWeb: TCheckBox
    Left = 16
    Top = 80
    Width = 425
    Height = 17
    Caption = 'Make Result Ready To Copy From Web'
    TabOrder = 1
    WordWrap = True
  end
  object edtOutput: TEdit
    Left = 16
    Top = 128
    Width = 425
    Height = 24
    ReadOnly = True
    TabOrder = 2
  end
  object btnTest: TBitBtn
    Left = 144
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 3
    OnClick = btnTestClick
    Kind = bkOK
  end
  object btnClose: TBitBtn
    Left = 248
    Top = 184
    Width = 75
    Height = 25
    TabOrder = 4
    Kind = bkClose
  end
end
