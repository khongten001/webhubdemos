object fmChromiumWrapper: TfmChromiumWrapper
  Left = 0
  Top = 0
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  ActiveControl = Panel1
  Caption = 'fmChromiumWrapper'
  ClientHeight = 357
  ClientWidth = 506
  Color = clPurple
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Visible = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 39
    Width = 506
    Height = 318
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    Caption = 'loading...'
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 0
  end
  object PanelURL: TPanel
    Left = 0
    Top = 0
    Width = 506
    Height = 39
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alTop
    Caption = 'PanelURL'
    TabOrder = 1
    object MemoURL: TMemo
      Left = 1
      Top = 1
      Width = 504
      Height = 37
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alClient
      Lines.Strings = (
        'MemoURL')
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object MainMenu1: TMainMenu
    Left = 168
    Top = 72
    object miFile: TMenuItem
      Caption = 'File'
      object miPrintPdf: TMenuItem
        Caption = 'Print to PDF'
        OnClick = miPrintPdfClick
      end
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
      object AmazonAWS1: TMenuItem
        Caption = 'Amazon AWS'
        OnClick = AmazonAWS1Click
      end
      object LogintoAWSemailandpass1: TMenuItem
        Caption = 'Login to AWS, email and pass'
        OnClick = LogintoAWSemailandpass1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object miEnterURL: TMenuItem
        Caption = 'Enter &URL'
        OnClick = miEnterURLClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miGoogleLoginUser: TMenuItem
        Caption = 'Login to Google: fill Username only'
        OnClick = miGoogleLoginUserClick
      end
      object miLoginGooglePass: TMenuItem
        Caption = 'Login to Google: fill Password only'
        OnClick = miLoginGooglePassClick
      end
    end
    object miTest: TMenuItem
      Caption = 'Test'
      object estVideo1: TMenuItem
        Caption = 'Test &Video'
      end
      object SlowPageTest1: TMenuItem
        Caption = 'Slow Page Test'
      end
      object LargePageTest1: TMenuItem
        Caption = 'Large Page Test'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object estJavaScriptAlert1: TMenuItem
        Caption = 'Test JavaScript Alert'
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
