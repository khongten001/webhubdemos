inherited dmDSPWebSearch: TdmDSPWebSearch
  OnCreate = DataModuleCreate
  Height = 152
  Width = 263
  object waSearch: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waSearchExecute
    DirectCallOk = True
    Left = 64
    Top = 8
  end
  object waFeedback: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waFeedbackExecute
    Left = 136
    Top = 8
  end
  object waMirrors: TwhScanGrid
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waMirrorsExecute
    Row = 0
    RowCount = 0
    Col = 1
    ColCount = 4
    PageHeight = 0
    PageRows = 0
    PageRow = 0
    ColStyle = scData
    FixCols = 0
    FixRows = 1
    FixRowHeader = False
    FixColHeader = False
    OverlapScroll = False
    ScanMode = dsByKey
    ControlAutoHide = True
    Buttons = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ButtonMode = bmJump
    ButtonStyle = bsLink
    ButtonAutoHide = True
    TABLE = '<table id="">'
    TR = '<tr>'
    TH = '<th>'
    TD = '<td>'
    BR = '<br />'
    Left = 136
    Top = 56
  end
end
