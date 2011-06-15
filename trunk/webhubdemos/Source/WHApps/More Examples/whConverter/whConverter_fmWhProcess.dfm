inherited fmWhProcess: TfmWhProcess
  Left = 406
  Top = 158
  Caption = '&Converter Process'
  ClientHeight = 225
  ClientWidth = 466
  ExplicitWidth = 484
  ExplicitHeight = 270
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 466
    Height = 206
    ExplicitWidth = 466
    ExplicitHeight = 206
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 456
      BorderWidth = 5
      TabOrder = 0
      object tpToolButton2: TtpToolButton
        Left = 11
        Top = 6
        Width = 95
        Caption = 'Save Config'
        OnClick = tpToolButton2Click
        LeaveSpace = True
        MinWidth = 28
      end
      object tpToolButton1: TtpToolButton
        Left = 112
        Top = 6
        Width = 113
        Caption = 'Run Converter'
        OnClick = tpToolButton1Click
        LeaveSpace = True
        MinWidth = 28
      end
    end
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 456
      Height = 156
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
      object ConverterFilename: TGroupBox
        Left = 0
        Top = 0
        Width = 452
        Height = 152
        Align = alClient
        Caption = 'd:\Projects\WebHubDemos\Live\DelphiApps\CharReplace.exe'
        TabOrder = 0
        object tpMemoConfig: TtpMemo
          Left = 2
          Top = 20
          Width = 448
          Height = 130
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Lucida Sans Unicode'
          Font.Style = []
          ParentFont = False
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
    Top = 206
    Width = 466
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
