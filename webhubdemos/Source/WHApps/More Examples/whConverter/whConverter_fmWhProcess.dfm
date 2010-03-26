inherited fmWhProcess: TfmWhProcess
  Left = 406
  Top = 158
  Width = 484
  Height = 270
  Caption = '&Converter Process'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 476
    Height = 207
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 466
      BorderWidth = 5
      TabOrder = 0
      object tpToolButton2: TtpToolButton
        Left = 11
        Top = 6
        Width = 65
        Caption = 'Save Config'
        OnClick = tpToolButton2Click
        LeaveSpace = True
        MinWidth = 28
      end
      object tpToolButton1: TtpToolButton
        Left = 82
        Top = 6
        Width = 76
        Caption = 'Run Converter'
        OnClick = tpToolButton1Click
        LeaveSpace = True
        MinWidth = 28
      end
    end
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 466
      Height = 157
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
      object ConverterFilename: TGroupBox
        Left = 0
        Top = 0
        Width = 462
        Height = 153
        Align = alClient
        Caption = 'd:\Projects\WebHub Demos\Live\DelphiApps\CharReplace.exe'
        TabOrder = 0
        object tpMemoConfig: TtpMemo
          Left = 2
          Top = 15
          Width = 458
          Height = 136
          Align = alClient
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
          ConfirmReadOnly = False
          ClearLines = True
        end
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 207
    Width = 476
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
  object iniconfig: TIniFileLink
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    FileType = ftNamed
    FileLocation = flNamed
    IniName = 'Temp.INI'
    IniPath = 'C:\'
    Section = '(blank)'
    Entry = '(blank)'
    LeaveOpen = False
    Left = 213
    Top = 13
  end
  object waValidateCoupon: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waValidateCouponExecute
    Left = 253
    Top = 13
  end
  object waConvert: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waConvertExecute
    Left = 285
    Top = 13
  end
  object waDownload: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waDownloadExecute
    Left = 317
    Top = 13
  end
end
