inherited fmCommon: TfmCommon
  Height = 271
  Caption = 'Common'
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Height = 233
    object laDBAlias: TLabel
      Left = 16
      Top = 136
      Width = 74
      Height = 13
      Caption = 'Database Alias:'
    end
    object Label1: TLabel
      Left = 16
      Top = 160
      Width = 64
      Height = 13
      Caption = 'Words Table:'
    end
    object rg: TRadioGroup
      Left = 8
      Top = 8
      Width = 185
      Height = 105
      Items.Strings = (
        '1-Close'
        '2-WebInfo.Refresh'
        '3-WebApp.Refresh'
        '4-WebCommandLine.Suspend'
        '5-WebCommandLine.Active')
      TabOrder = 0
    end
    object Button1: TButton
      Left = 200
      Top = 80
      Width = 75
      Height = 25
      Caption = 'Go'
      TabOrder = 1
      OnClick = Button1Click
    end
    object edDBAlias: TEdit
      Tag = 1
      Left = 96
      Top = 133
      Width = 153
      Height = 21
      TabOrder = 2
    end
    object btSet: TButton
      Left = 200
      Top = 192
      Width = 75
      Height = 25
      Caption = 'Set'
      TabOrder = 3
    end
    object edWords: TEdit
      Tag = 1
      Left = 96
      Top = 157
      Width = 153
      Height = 21
      TabOrder = 4
    end
  end
  object Global: TtpSharedInt32
    GlobalValue = 0
    IgnoreOwnChanges = True
    OnChange = GlobalChange
    Left = 248
    Top = 7
  end
  object tpAppRole1: TtpAppRole
    Left = 216
    Top = 8
  end
end
