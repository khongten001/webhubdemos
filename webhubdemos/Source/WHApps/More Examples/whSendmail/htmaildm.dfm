object FormLetterDM: TFormLetterDM
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 216
  object WebFormLetter: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = WebFormLetterExecute
    Left = 40
    Top = 16
  end
  object WebAppOutputFormLtr: TwhResponse
    ComponentOptions = []
    CrLfMode = HtmlCrLf
    PrologueMode = proHTML
    Left = 120
    Top = 64
  end
end
