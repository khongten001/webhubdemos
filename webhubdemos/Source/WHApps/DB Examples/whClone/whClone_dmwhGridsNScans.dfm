object DMGridsNScans: TDMGridsNScans
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 306
  Width = 577
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
    Left = 64
    Top = 24
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
    Left = 176
    Top = 24
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
    Left = 440
    Top = 24
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
    Left = 64
    Top = 112
  end
  object ScanXMLCloned: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpCXSetIfFoundDuringUpdate]
    OnExecute = ScanOnExecutePageHeader
    AfterExecute = ScanAfterExecute
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    WebDataSource = DMData2Clone.whdbxSourceXMLCloned
    OnRowStart = ScanRowStart
    OnInit = ScanInit
    OnFinish = ScanFinish
    OnEmptyDataSet = ScanXMLEmptyDataSet
    Left = 176
    Top = 112
  end
  object ScanDBxDBf: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpCXSetIfFoundDuringUpdate]
    OnExecute = ScanOnExecutePageHeader
    AfterExecute = ScanAfterExecute
    DirectCallOk = True
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    WebDataSource = DMData2Clone.whdbxSourceDBF
    OnRowStart = ScanRowStart
    OnInit = ScanInit
    OnFinish = ScanFinish
    OnEmptyDataSet = ScanXMLEmptyDataSet
    Left = 64
    Top = 200
  end
end
