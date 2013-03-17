object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'Simulate having no real CodeSite units'
  ClientHeight = 225
  ClientWidth = 518
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 20
  object Button1: TButton
    Left = 239
    Top = 152
    Width = 250
    Height = 49
    Caption = 'Log to CodeSite via TtpSharedBuf'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 24
    Top = 24
    Width = 169
    Height = 177
    ItemHeight = 20
    Items.Strings = (
      '1 Info'
      '2 Warning'
      '3 Error'
      '4 Note'
      '5 Exception'
      '6 EnterMethod'
      '7 ExitMethod'
      '8 Destination Logfile')
    TabOrder = 1
  end
  object LabeledEdit1: TLabeledEdit
    Left = 239
    Top = 40
    Width = 250
    Height = 28
    EditLabel.Width = 60
    EditLabel.Height = 20
    EditLabel.Caption = 'String #1'
    TabOrder = 2
  end
  object LabeledEdit2: TLabeledEdit
    Left = 239
    Top = 93
    Width = 250
    Height = 28
    EditLabel.Width = 60
    EditLabel.Height = 20
    EditLabel.Caption = 'String #2'
    TabOrder = 3
  end
end
