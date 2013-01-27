inherited fmHTQ1Panel: TfmHTQ1Panel
  Left = 235
  Top = 121
  Caption = 'HTQ1'
  ClientHeight = 174
  ClientWidth = 416
  ExplicitWidth = 434
  ExplicitHeight = 219
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 416
    Height = 155
    ExplicitWidth = 416
    ExplicitHeight = 155
    object CheckBox1: TCheckBox
      Left = 8
      Top = 46
      Width = 209
      Height = 17
      Caption = 'Show SQL statement'
      TabOrder = 0
      OnClick = CheckBox1Click
      OnEnter = CheckBox1Enter
      OnExit = CheckBox1Exit
    end
    object tpToolBar2: TtpToolBar
      Left = 5
      Top = 5
      Width = 406
      Height = 28
      TabOrder = 1
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 155
    Width = 416
    Height = 19
    Panels = <
      item
        Text = 'WebDataSource1: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimpleText = ''
    PanelStatusIndex = 0
  end
end
