inherited fmEmployee: TfmEmployee
  Left = 522
  Top = 368
  Caption = '&Employee'
  ClientHeight = 200
  ClientWidth = 303
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 321
  ExplicitHeight = 245
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 303
    Height = 181
    ExplicitWidth = 313
    ExplicitHeight = 188
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
    Top = 181
    Width = 303
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
    ExplicitTop = 188
    ExplicitWidth = 313
  end
  object ScanEmployee3: TwhdbScan
    ComponentOptions = [tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
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
    ComponentOptions = []
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
