object ServerForm: TServerForm
  Left = 259
  Top = 121
  Width = 308
  Height = 135
  Caption = 'Server Form'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 300
    Height = 108
    Align = alClient
    Color = clSilver
    Lines.Strings = (
      'If you want to use this counter in your own application, copy '
      'the W-HTML droplets from the WebHub Help File.'
      ''
      '[? COM Macro ]')
    ReadOnly = True
    TabOrder = 0
  end
  object tpSystemPopup: TtpSystemPopup
    AutoPopup = False
    Left = 248
    Top = 64
    object miViewExampleSource: TMenuItem
      Caption = '&View Example Source'
      Checked = True
      OnClick = miViewExampleSourceClick
    end
    object miSaveList: TMenuItem
      Caption = '&Save Page-Counts'
      OnClick = SaveList
    end
    object miLoadList: TMenuItem
      Caption = '&Load Page-Counts'
      OnClick = LoadList
    end
    object miEditCounts: TMenuItem
      Caption = '&Edit Page-Counts'
      OnClick = EditList
    end
  end
end
