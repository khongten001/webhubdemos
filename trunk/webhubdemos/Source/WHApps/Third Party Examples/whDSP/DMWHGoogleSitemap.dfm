object DataModuleGoogleSitemap: TDataModuleGoogleSitemap
  OldCreateOrder = False
  Left = 192
  Top = 107
  Height = 150
  Width = 215
  object ActionList1: TActionList
    Left = 32
    Top = 40
    object actGoogleSitemap: TAction
      Caption = 'Google Sitemap'
      OnExecute = actGoogleSitemapExecute
    end
    object actKeywordReport: TAction
      Caption = 'Keywords'
      OnExecute = actKeywordReportExecute
    end
  end
  object waGoogleKeywordReport: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    OnExecute = waGoogleKeywordReportExecute
    Left = 104
    Top = 48
  end
end
