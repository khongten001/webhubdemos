object fmChromiumWrapper: TfmChromiumWrapper
  Left = 0
  Top = 0
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  Caption = 'fmChromiumWrapper'
  ClientHeight = 471
  ClientWidth = 633
  Color = clPurple
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 23
  object Panel1: TPanel
    Left = 0
    Top = 49
    Width = 633
    Height = 422
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 0
  end
  object PanelURL: TPanel
    Left = 0
    Top = 0
    Width = 633
    Height = 49
    Align = alTop
    Caption = 'PanelURL'
    TabOrder = 1
    object MemoURL: TMemo
      Left = 1
      Top = 1
      Width = 631
      Height = 47
      Align = alClient
      Lines.Strings = (
        'MemoURL')
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object MainMenu1: TMainMenu
    Left = 224
    Top = 168
    object miFile: TMenuItem
      Caption = 'File'
      object miExit: TMenuItem
        Caption = 'E&xit'
        OnClick = miExitClick
      end
    end
    object miBookmarks: TMenuItem
      Caption = '&Bookmarks'
      object miGoogle: TMenuItem
        Caption = '&Google Search'
        OnClick = miGoogleClick
      end
      object GooglePlus1: TMenuItem
        Caption = 'Google &Plus'
        OnClick = GooglePlus1Click
      end
      object miGoogleCalendar1: TMenuItem
        Caption = 'Google &Calendar'
        OnClick = miGoogleCalendar1Click
      end
      object miGoogleWebmasterTools: TMenuItem
        Caption = 'Google &Webmaster Tools'
        OnClick = miGoogleWebmasterToolsClick
      end
      object GoogleAdsense1: TMenuItem
        Caption = 'Google &Adsense'
        OnClick = GoogleAdsense1Click
      end
      object GoogleMail1: TMenuItem
        Caption = 'Google &Mail'
        OnClick = GoogleMail1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object miEnterURL: TMenuItem
        Caption = 'Enter &URL'
        OnClick = miEnterURLClick
      end
      object miTestAlert: TMenuItem
        Caption = 'Test JavaScript Alert'
        OnClick = miTestAlertClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object miTestVideo1: TMenuItem
        Caption = 'Test &Video'
        OnClick = TestVideo1Click
      end
      object SlowPageTest1: TMenuItem
        Caption = 'Slow Page Test'
        OnClick = SlowPageTest1Click
      end
      object LargePageTest1: TMenuItem
        Caption = 'Large Page Test'
        OnClick = LargePageTest1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object QuickLogin1: TMenuItem
        Caption = 'Quick Login'
        OnClick = QuickLogin1Click
      end
    end
    object View1: TMenuItem
      Caption = '&View'
      object miURL: TMenuItem
        Caption = '&URL'
        Checked = True
        OnClick = miURLClick
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object miAbout: TMenuItem
        Caption = '&About'
        OnClick = miAboutClick
      end
    end
  end
end
