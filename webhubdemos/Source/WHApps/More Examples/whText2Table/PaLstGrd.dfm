inherited fmWebListGridPanel: TfmWebListGridPanel
  Left = 331
  Top = 173
  Width = 391
  Height = 262
  Caption = '&WebListGrid'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 383
    Height = 209
    object Label1: TLabel
      Left = 5
      Top = 45
      Width = 373
      Height = 41
      Align = alTop
      AutoSize = False
      Caption = 
        'This custom panel houses features related to the TwhListGrid co' +
        'mponent, used in the HTGR demo.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 373
      Height = 40
      Align = alTop
      BorderWidth = 5
      TabOrder = 0
      LeaveSpace = False
      object tpToolButton1: TtpToolButton
        Left = 5
        Top = 6
        Width = 86
        Height = 28
        Caption = 'Edit Files for Grid'
        OnClick = tpToolButton1Click
        LeaveSpace = True
        MinWidth = 24
      end
      object tpToolButton2: TtpToolButton
        Left = 92
        Top = 6
        Width = 105
        Height = 28
        Caption = 'Refresh WebListGrid'
        OnClick = tpToolButton2Click
        LeaveSpace = False
        MinWidth = 24
      end
      object tpToolButton3: TtpToolButton
        Left = 198
        Top = 6
        Width = 88
        Height = 28
        Caption = 'Check Properties'
        OnClick = tpToolButton3Click
        LeaveSpace = False
        MinWidth = 24
      end
      object tpToolButton4: TtpToolButton
        Left = 287
        Top = 6
        Width = 29
        Height = 28
        Caption = 'Help'
        OnClick = tpToolButton4Click
        LeaveSpace = False
        MinWidth = 24
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 209
    Width = 383
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
  end
  object WebListGrid: TwhListGrid
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    LinesMode = wlgAsGrid
    Left = 16
    Top = 96
  end
  object wg2: TwhListGrid
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    Controls = wboNone
    Lines.Strings = (
      'Hi there --'
      'I thought this '
      'was neat!')
    LinesMode = wlgAsGrid
    Left = 96
    Top = 104
  end
end
