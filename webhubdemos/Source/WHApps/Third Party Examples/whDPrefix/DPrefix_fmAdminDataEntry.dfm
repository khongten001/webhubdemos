inherited fmWhActions: TfmWhActions
  Left = 298
  Top = 150
  Caption = '&ManPref Database'
  ClientHeight = 481
  ClientWidth = 970
  OnDestroy = FormDestroy
  ExplicitWidth = 986
  ExplicitHeight = 520
  PixelsPerInch = 96
  TextHeight = 18
  object tpToolButton3: TtpToolButton [0]
    Left = 256
    Top = 248
    MinWidth = 28
  end
  inherited pa: TPanel
    Width = 970
    Height = 462
    ExplicitWidth = 970
    ExplicitHeight = 462
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 960
      BorderWidth = 5
      TabOrder = 0
      object tpToolButton1: TtpToolButton
        Left = 11
        Top = 6
        Width = 160
        Caption = 'Toggle Grid Display'
        LeaveSpace = True
        MinWidth = 28
      end
      object tpToolButton5: TtpToolButton
        Left = 177
        Top = 6
        Width = 193
        Caption = 'Delete where Status is D'
        LeaveSpace = True
        MinWidth = 28
      end
      object ComboBoxStatus: TComboBox
        Left = 408
        Top = 8
        Width = 145
        Height = 26
        ItemIndex = 0
        TabOrder = 0
        Text = '- All'
        Items.Strings = (
          '- All'
          'P Pending'
          'D Delete'
          'A Approved'
          '! Blank EMails'
          'ampersand')
      end
    end
    object tpComponentPanel2: TtpComponentPanel
      Left = 5
      Top = 45
      Width = 244
      Height = 412
      TabOrder = 1
      object GroupBox3: TGroupBox
        Left = 1
        Top = 1
        Width = 242
        Height = 88
        Align = alTop
        Caption = 'View-only DB Display'
        TabOrder = 0
      end
    end
    object Panel1: TPanel
      Left = 249
      Top = 45
      Width = 716
      Height = 412
      Align = alClient
      TabOrder = 2
      object DBGrid1: TDBGrid
        Left = 1
        Top = 1
        Width = 714
        Height = 385
        Align = alClient
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Lucida Sans Unicode'
        TitleFont.Style = []
      end
      object DBNavigator1: TDBNavigator
        Left = 1
        Top = 386
        Width = 714
        Height = 25
        Align = alBottom
        TabOrder = 1
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 462
    Width = 970
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimpleText = ''
    PanelStatusIndex = 0
  end
end
