object DemoViewSource: TDemoViewSource
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 696
  object waDemoViewSource: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waDemoViewSourceExecute
    DirectCallOk = True
    Left = 229
    Top = 125
  end
  object waDemoViewSourcePascalFile: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waDemoViewSourcePascalFileExecute
    DirectCallOk = True
    Left = 229
    Top = 181
  end
  object waDemoViewSourceWHTMLFile: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waDemoViewSourceWHTMLFileExecute
    DirectCallOk = True
    Left = 280
    Top = 24
  end
  object waDemoViewSourceWHTMLFileList: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waDemoViewSourceWHTMLFileListExecute
    Left = 88
    Top = 24
  end
  object waDemoViewSourceProjectLink: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waDemoViewSourceProjectLinkExecute
    Left = 80
    Top = 104
  end
end
