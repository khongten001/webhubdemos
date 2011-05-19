inherited fmShopPanel: TfmShopPanel
  Left = 433
  Top = 239
  Width = 486
  Height = 293
  Caption = '&Shopping'
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel [0]
    Left = 16
    Top = 144
    Width = 58
    Height = 13
    Caption = 'E-Mail From:'
  end
  inherited pa: TPanel
    Width = 478
    Height = 236
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 468
      TabOrder = 0
      LeaveSpace = True
      object tpToolButton1: TtpToolButton
        Left = 6
        Top = 1
        Width = 111
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
      Width = 156
      Height = 186
      TabOrder = 1
      object GroupBox1: TGroupBox
        Left = 1
        Top = 97
        Width = 154
        Height = 72
        Align = alTop
        Caption = 'EMail Feature'
        TabOrder = 0
      end
      object GroupBox2: TGroupBox
        Left = 1
        Top = 1
        Width = 154
        Height = 96
        Align = alTop
        Caption = 'Shopping Cart'
        TabOrder = 1
      end
    end
    object PageControl1: TPageControl
      Left = 161
      Top = 45
      Width = 312
      Height = 186
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 2
      object TabSheet1: TTabSheet
        Caption = '&Table'
        object DBGrid1: TDBGrid
          Left = 0
          Top = 0
          Width = 304
          Height = 133
          Align = alClient
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
        object DBNavigator1: TDBNavigator
          Left = 0
          Top = 133
          Width = 304
          Height = 25
          Align = alBottom
          TabOrder = 1
        end
      end
      object tsEConfig: TTabSheet
        Caption = 'Configure E-Mail'
        object Label4: TLabel
          Left = 16
          Top = 16
          Width = 58
          Height = 13
          Caption = 'E-Mail From:'
        end
        object Label5: TLabel
          Left = 16
          Top = 40
          Width = 48
          Height = 13
          Caption = 'E-Mail To:'
        end
        object Label6: TLabel
          Left = 24
          Top = 64
          Width = 45
          Height = 13
          Caption = 'Mail host:'
        end
        object Label8: TLabel
          Left = 32
          Top = 88
          Width = 22
          Height = 13
          Caption = 'Port:'
        end
        object Label9: TLabel
          Left = 24
          Top = 112
          Width = 39
          Height = 13
          Caption = 'Subject:'
        end
        object EditEMailFrom: TEdit
          Left = 88
          Top = 16
          Width = 121
          Height = 21
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Text = 'EditEMailFrom'
        end
        object EditEMailTo: TEdit
          Left = 88
          Top = 38
          Width = 121
          Height = 21
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Text = 'EditEMailTo'
        end
        object EditMailhost: TEdit
          Left = 88
          Top = 60
          Width = 121
          Height = 21
          Hint = 'e.g. mail.sonic.net'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Text = 'EditMailhost'
        end
        object EditSubject: TEdit
          Left = 88
          Top = 104
          Width = 121
          Height = 21
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Text = 'EditSubject'
        end
        object EditMailPort: TEdit
          Left = 89
          Top = 83
          Width = 121
          Height = 21
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
    Top = 236
    Width = 478
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
  object waScrollGrid: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waScrollGridExecute
    Left = 86
    Top = 102
  end
  object WebDataGrid1: TwhbdeGrid
    ComponentOptions = [tpUpdateOnGet, tpStatusPanel]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    Border = 'BORDER'
    TR = '<TR>'
    TD = '<TD>'
    ShowRecno = False
    Preformat = False
    WebDataSource = WebDataSource1
    Left = 16
    Top = 68
  end
  object WebActionOrderList: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = WebActionOrderListExecute
    Left = 16
    Top = 100
  end
  object WebActionPostLit: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = WebActionPostLitExecute
    Left = 48
    Top = 100
  end
  object WebDataSource1: TwhbdeSource
    ComponentOptions = [tpUpdateOnGet, tpStatusPanel]
    GotoMode = wgGotoKey
    KeyFieldNames = 'PartNo'
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource1
    Left = 48
    Top = 68
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 80
    Top = 68
  end
  object Table1: TTable
    TableName = 'PARTS.DB'
    Left = 112
    Top = 68
    object Table1PartNo: TFloatField
      Alignment = taLeftJustify
      FieldName = 'PartNo'
      DisplayFormat = 'PN-00000'
    end
    object Table1VendorNo: TFloatField
      FieldName = 'VendorNo'
      DisplayFormat = 'VN 0000'
      MaxValue = 9999.000000000000000000
      MinValue = 1000.000000000000000000
    end
    object Table1Description: TStringField
      FieldName = 'Description'
      Size = 30
    end
    object Table1OnHand: TFloatField
      FieldName = 'OnHand'
    end
    object Table1OnOrder: TFloatField
      FieldName = 'OnOrder'
    end
    object Table1Cost: TCurrencyField
      FieldName = 'Cost'
    end
    object Table1ListPrice: TCurrencyField
      FieldName = 'ListPrice'
    end
    object Table1Qty: TSmallintField
      FieldKind = fkCalculated
      FieldName = 'Qty'
      OnGetText = Table1QtyGetText
      Calculated = True
    end
  end
  object WebActionMailer: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = WebActionMailerExecute
    Left = 43
    Top = 164
  end
end
