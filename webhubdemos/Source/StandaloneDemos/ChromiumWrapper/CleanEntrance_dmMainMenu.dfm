object DataModuleBrowserMenu: TDataModuleBrowserMenu
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 215
  object MainMenu1: TMainMenu
    Left = 48
    Top = 32
    object miFile: TMenuItem
      Caption = 'File'
      object miPrintPdf: TMenuItem
        Caption = 'Print to PDF'
        OnClick = miPrintPdfClick
      end
      object miExit: TMenuItem
        Caption = 'E&xit'
      end
    end
    object miBookmarks: TMenuItem
      Caption = '&Bookmarks'
      object miEnterURL: TMenuItem
        Caption = 'Enter &URL'
        OnClick = miEnterURLClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
    end
    object miTest: TMenuItem
      Caption = 'Test'
      object miTestVideo: TMenuItem
        Caption = 'Test &QuickTime'
        OnClick = miTestVideoClick
      end
      object SlowPageTest1: TMenuItem
        Caption = 'Slow Page Test'
        OnClick = SlowPageTest1Click
      end
      object LargePageTest1: TMenuItem
        Caption = 'Large Page Test'
        OnClick = LargePageTest1Click
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
