object dmWhQuote: TdmWhQuote
  OldCreateOrder = True
  Left = 285
  Top = 161
  Height = 479
  Width = 741
  object waQuoteMessage: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waQuoteMessageExecute
    Left = 56
    Top = 16
  end
  object ExtraOutput: TwhResponse
    ComponentOptions = [tpUpdateOnLoad, tpHideFromVerbBar]
    CrLfMode = HtmlCrLf
    PrologueMode = proHTML
    Left = 168
    Top = 32
  end
end
