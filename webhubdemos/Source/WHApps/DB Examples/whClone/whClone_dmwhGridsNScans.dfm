object DMGridsNScans: TDMGridsNScans
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 390
  Width = 691
  object Scan1: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel, tpCXSetIfFoundDuringUpdate]
    AfterExecute = ScanAfterExecute
    DirectCallOk = True
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 3
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    OnRowStart = ScanRowStart
    OnInit = ScanInit
    OnFinish = ScanFinish
    Left = 128
    Top = 32
  end
  object Scan2: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel, tpCXSetIfFoundDuringUpdate]
    OnExecute = ScanOnExecutePageHeader
    AfterExecute = ScanAfterExecute
    DirectCallOk = True
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 3
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    OnRowStart = ScanRowStart
    OnInit = ScanInit
    OnFinish = ScanFinish
    Left = 120
    Top = 128
  end
  object WebDataGrid1: TwhbdeGrid
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel, tpCXSetIfFoundExactlyDuringUpdate]
    OnExecute = WebDataGrid1Execute
    AfterExecute = WebDataGrid1AfterExecute
    DirectCallOk = True
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    TR = '<tr>'
    TD = '<td>'
    Caption = ''
    Preformat = False
    Left = 128
    Top = 280
  end
  object ScanXML: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpCXSetIfFoundDuringUpdate]
    OnExecute = ScanOnExecutePageHeader
    AfterExecute = ScanAfterExecute
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    WebDataSource = DMData2Clone.whdbxSourceXML
    OnRowStart = ScanRowStart
    OnInit = ScanInit
    OnFinish = ScanFinish
    OnEmptyDataSet = ScanXMLEmptyDataSet
    Left = 128
    Top = 216
  end
  object gridxml: TwhbdeGrid
    ComponentOptions = [tpUpdateOnLoad, tpCXSetIfFoundDuringUpdate, tpCXSetIfFoundExactlyDuringUpdate]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    TR = '<tr>'
    TD = '<td>'
    Caption = ''
    Preformat = False
    Left = 328
    Top = 176
  end
end
