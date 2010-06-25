inherited fmAppConfigure: TfmAppConfigure
  Left = 341
  Top = 267
  Width = 522
  Height = 179
  Caption = '&Configure'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 514
    Height = 135
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 504
      TabOrder = 0
    end
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 504
      Height = 85
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
      object laDBAlias: TLabel
        Left = 24
        Top = 16
        Width = 74
        Height = 13
        Caption = 'Database Alias:'
      end
      object Label1: TLabel
        Left = 24
        Top = 47
        Width = 64
        Height = 13
        Caption = 'Words Table:'
      end
      object edDBAlias: TEdit
        Tag = 1
        Left = 104
        Top = 13
        Width = 153
        Height = 21
        TabOrder = 0
      end
      object edWords: TEdit
        Tag = 1
        Left = 104
        Top = 39
        Width = 153
        Height = 21
        TabOrder = 1
      end
      object btSet: TButton
        Left = 272
        Top = 35
        Width = 75
        Height = 25
        Caption = 'Set'
        TabOrder = 2
        OnClick = btSetClick
      end
    end
  end
end
