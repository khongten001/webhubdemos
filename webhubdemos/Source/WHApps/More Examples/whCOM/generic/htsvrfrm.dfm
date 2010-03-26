object ServerForm: TServerForm
  Left = 200
  Top = 108
  Width = 207
  Height = 80
  Caption = 'Simple COM Server'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 199
    Height = 53
    Hint = 
      'Check out this example of a WebHub compatible COM Server! It'#39's e' +
      'asy to do. Ask us.'
    Align = alClient
    BorderStyle = bsNone
    Color = clSilver
    Lines.Strings = (
      'Memo1')
    ReadOnly = True
    TabOrder = 0
    WordWrap = False
  end
end
