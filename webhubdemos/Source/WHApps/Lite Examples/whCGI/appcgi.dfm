object fmWebAppCGI: TfmWebAppCGI
  Left = 472
  Top = 385
  Width = 420
  Height = 288
  Caption = 'fmWebAppCGI'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object tpStatusBar: TtpStatusBar
    Left = 0
    Top = 322
    Width = 393
    Height = 19
    Panels = <
      item
        Text = 'WebOutput: Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
  object WebBrowser: TWebBrowser
    Left = 4
    Top = 172
    Width = 300
    Height = 150
    TabOrder = 1
    ControlData = {
      4C000000021F0000810F00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object WebInfo: TwhCentralInfo
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet, tpStatusPanel]
    Left = 4
    Top = 109
  end
  object Request: TwhRequest
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet, tpStatusPanel]
    ShowInput = False
    ExcludeNameStem = '_'
    HTTP = '80'
    HTTPS = '443'
    Left = 68
    Top = 108
  end
  object WebCommandLine: TwhConnection
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet, tpStatusPanel]
    OnExecute = WebCommandLineExecute
    Active = True
    WebAppLockDown = False
    WebOutput = WebOutput
    BeepOnPage = False
    Request = Request
    CgiDirect = False
    NoSuchPage = nspError
    EnableMultiThreading = False
    Left = 4
    Top = 141
  end
  object tpApplication1: TtpApplication
    OnIdle = tpApplication1Idle
    Left = 68
    Top = 172
  end
  object WebOutput: TwhResponseSimple
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet, tpStatusPanel]
    CrLfMode = HtmlCrLf
    PrologueMode = proSkip
    Request = Request
    GUIShowResponse = outQuick
    Left = 40
    Top = 144
  end
  object MainMenu1: TMainMenu
    Left = 152
    Top = 56
    object File1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Action = FileExit1
      end
    end
  end
  object ActionList1: TActionList
    Left = 184
    Top = 56
    object FileExit1: TFileExit
      Category = 'File'
      Caption = 'E&xit'
      Hint = 'Exit|Quits the application'
      ImageIndex = 43
    end
  end
end
