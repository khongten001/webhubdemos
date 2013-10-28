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
    Top = 0
    Width = 633
    Height = 471
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 0
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
        Caption = '&Google'
        OnClick = miGoogleClick
      end
      object GooglePlus1: TMenuItem
        Caption = 'Google Plus'
        OnClick = GooglePlus1Click
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
        Caption = '--'
      end
      object QuickLogin1: TMenuItem
        Caption = 'Quick Login'
        OnClick = QuickLogin1Click
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
