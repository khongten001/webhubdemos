inherited fmEmployee: TfmEmployee
  Left = 522
  Top = 368
  Width = 321
  Height = 245
  Caption = '&Employee'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 313
    Height = 188
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 303
      BorderWidth = 5
      TabOrder = 0
    end
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 303
      Height = 138
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 188
    Width = 313
    Height = 19
    Panels = <
      item
        Text = ''
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
  object ScanEmployee3: TwhdbScan
    ComponentOptions = [tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonsWhere = dsbNone
    ButtonAutoHide = False
    OverlapScroll = False
    OnRowStart = ScanEmployee1RowStart
    OnFinish = ScanEmployee1Finish
    Left = 109
    Top = 13
  end
  object ScanEmployee2: TwhdbScan
    ComponentOptions = [tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    OnRowStart = ScanEmployee1RowStart
    OnFinish = ScanEmployee1Finish
    Left = 69
    Top = 13
  end
  object ScanEmployee1: TwhdbScan
    ComponentOptions = [tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    OnRowStart = ScanEmployee1RowStart
    OnFinish = ScanEmployee1Finish
    Left = 29
    Top = 13
  end
  object waMoney: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waMoneyExecute
    Left = 269
    Top = 13
  end
  object waField: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waFieldExecute
    Left = 237
    Top = 13
  end
end
