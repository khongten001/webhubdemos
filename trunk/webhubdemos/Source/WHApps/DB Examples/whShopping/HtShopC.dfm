inherited fmShopPanel: TfmShopPanel
  Left = 433
  Top = 239
  Caption = '&Shopping'
  ClientHeight = 450
  ClientWidth = 883
  ExplicitWidth = 901
  ExplicitHeight = 495
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 883
    Height = 431
    ExplicitWidth = 883
    ExplicitHeight = 431
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 873
      TabOrder = 0
      LeaveSpace = True
      object tpToolButton1: TtpToolButton
        Left = 6
        Top = 1
        Width = 179
        Hint = 'Toggle table display'
        Caption = 'Display the parts table'
        ParentShowHint = False
        ShowHint = True
        OnClick = tpToolButton1Click
        MinWidth = 24
      end
    end
    object tpComponentPanel2: TtpComponentPanel
      Left = 5
      Top = 45
      Width = 204
      Height = 381
      TabOrder = 1
      object GroupBox1: TGroupBox
        Left = 1
        Top = 1
        Width = 202
        Height = 104
        Align = alTop
        Caption = 'EMail Feature'
        TabOrder = 0
        ExplicitTop = 201
      end
    end
    object PageControl1: TPageControl
      Left = 209
      Top = 45
      Width = 669
      Height = 381
      ActivePage = tsEConfig
      Align = alClient
      TabOrder = 2
      object TabSheet1: TTabSheet
        Caption = '&Table'
        object DBGrid1: TDBGrid
          Left = 0
          Top = 0
          Width = 661
          Height = 323
          Align = alClient
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -15
          TitleFont.Name = 'Lucida Sans Unicode'
          TitleFont.Style = []
        end
        object DBNavigator1: TDBNavigator
          Left = 0
          Top = 323
          Width = 661
          Height = 25
          Align = alBottom
          Kind = dbnHorizontal
          TabOrder = 1
        end
      end
      object tsEConfig: TTabSheet
        Caption = 'Configure E-Mail'
        object Label4: TLabel
          Left = 16
          Top = 16
          Width = 94
          Height = 18
          Caption = 'E-Mail From:'
        end
        object Label5: TLabel
          Left = 16
          Top = 40
          Width = 76
          Height = 18
          Caption = 'E-Mail To:'
        end
        object Label6: TLabel
          Left = 24
          Top = 64
          Width = 71
          Height = 18
          Caption = 'Mail host:'
        end
        object Label8: TLabel
          Left = 32
          Top = 88
          Width = 36
          Height = 18
          Caption = 'Port:'
        end
        object Label9: TLabel
          Left = 24
          Top = 112
          Width = 60
          Height = 18
          Caption = 'Subject:'
        end
        object EditEMailFrom: TEdit
          Left = 144
          Top = 13
          Width = 121
          Height = 26
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Text = 'EditEMailFrom'
        end
        object EditEMailTo: TEdit
          Left = 144
          Top = 37
          Width = 121
          Height = 26
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Text = 'EditEMailTo'
        end
        object EditMailhost: TEdit
          Left = 144
          Top = 61
          Width = 121
          Height = 26
          Hint = 'e.g. mail.sonic.net'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Text = 'EditMailhost'
        end
        object EditSubject: TEdit
          Left = 144
          Top = 109
          Width = 121
          Height = 26
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Text = 'EditSubject'
        end
        object EditMailPort: TEdit
          Left = 144
          Top = 85
          Width = 121
          Height = 26
          Hint = 'Port 25 is usually right.'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          Text = 'EditMailPort'
        end
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 431
    Width = 883
    Height = 19
    Panels = <
      item
        Text = 'whdbScan2: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
  object WebActionMailer: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = WebActionMailerExecute
    Left = 67
    Top = 89
  end
end
