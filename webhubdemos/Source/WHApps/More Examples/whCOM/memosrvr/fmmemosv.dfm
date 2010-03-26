object Form1: TForm1
  Left = 505
  Top = 326
  Width = 313
  Height = 126
  Caption = 'MemoServer'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 305
    Height = 99
    Align = alClient
    Lines.Strings = (
      'These contents will be cleared when the memo server is used. '
      ''
      'The memo is being used as a memory region, and was '
      'chosen instead of a TStringList because you can see it!')
    TabOrder = 0
  end
end
