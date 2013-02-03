object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Convert Paradox to XML'
  ClientHeight = 744
  ClientWidth = 918
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 25
  object tpComponentPanel1: TtpComponentPanel
    Left = 0
    Top = 0
    Width = 145
    Height = 744
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 145
    Top = 0
    Width = 773
    Height = 744
    Align = alClient
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 145
    Top = 0
    Width = 773
    Height = 744
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Select'
      object LabeledEditParadox: TLabeledEdit
        Left = 16
        Top = 32
        Width = 689
        Height = 33
        EditLabel.Width = 159
        EditLabel.Height = 25
        EditLabel.Caption = 'Paradox DB Filespec'
        TabOrder = 0
      end
      object Button2: TButton
        Left = 711
        Top = 36
        Width = 35
        Height = 25
        Caption = '...'
        TabOrder = 1
        OnClick = Button2Click
      end
      object LabeledEditXML: TLabeledEdit
        Left = 16
        Top = 96
        Width = 689
        Height = 33
        EditLabel.Width = 102
        EditLabel.Height = 25
        EditLabel.Caption = 'XML Filespec'
        TabOrder = 2
      end
      object Button1: TButton
        Left = 16
        Top = 176
        Width = 689
        Height = 49
        Action = ActionConvert
        TabOrder = 3
      end
      object CheckBox1: TCheckBox
        Left = 16
        Top = 145
        Width = 313
        Height = 17
        Caption = 'Write CDS to output folder'
        TabOrder = 4
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Source'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object LabelSource: TLabel
        Left = 0
        Top = 0
        Width = 95
        Height = 25
        Align = alTop
        Caption = 'LabelSource'
      end
      object DBNavigator1: TDBNavigator
        Left = 0
        Top = 25
        Width = 765
        Height = 25
        DataSource = DataSource1
        Align = alTop
        TabOrder = 0
      end
      object DBGrid1: TDBGrid
        Left = 0
        Top = 50
        Width = 765
        Height = 654
        Align = alClient
        DataSource = DataSource1
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -18
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Target'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object LabelTarget: TLabel
        Left = 0
        Top = 0
        Width = 91
        Height = 25
        Align = alTop
        Caption = 'LabelTarget'
      end
      object DBGridTarget: TDBGrid
        Left = 0
        Top = 50
        Width = 765
        Height = 654
        Align = alClient
        DataSource = DataSourceTarget
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -18
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
      object DBNavigatorTarget: TDBNavigator
        Left = 0
        Top = 25
        Width = 765
        Height = 25
        DataSource = DataSourceTarget
        Align = alTop
        TabOrder = 1
      end
    end
  end
  object ClientDataSetTarget: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProviderTarget'
    Left = 48
    Top = 400
  end
  object DataSetProviderTarget: TDataSetProvider
    DataSet = TableSource
    ResolveToDataSet = True
    Exported = False
    Options = [poReadOnly, poUseQuoteChar]
    Left = 48
    Top = 344
  end
  object TableSource: TTable
    DatabaseName = 'D:\Projects\webhubdemos\Live\Database\whFishStore'
    Left = 56
    Top = 128
  end
  object FileOpenDialog1: TFileOpenDialog
    DefaultExtension = '*.db'
    DefaultFolder = 'd:\Projects\WebHubDemos\Live\Database'
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 56
    Top = 216
  end
  object MainMenu1: TMainMenu
    Left = 40
    Top = 16
    object File1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Action = FileExit1
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Action = ActionAbout
      end
    end
  end
  object ActionList1: TActionList
    Left = 56
    Top = 272
    object FileExit1: TFileExit
      Category = 'File'
      Caption = 'E&xit'
      Hint = 'Exit|Quits the application'
      ImageIndex = 43
    end
    object ActionConvert: TAction
      Category = 'File'
      Caption = 'Convert Paradox to XML'
      OnExecute = ActionConvertExecute
    end
    object ActionAbout: TAction
      Category = 'File'
      Caption = 'About'
      OnExecute = ActionAboutExecute
    end
  end
  object DataSource1: TDataSource
    DataSet = TableSource
    Left = 56
    Top = 88
  end
  object DataSourceTarget: TDataSource
    DataSet = ClientDataSetTarget
    Left = 56
    Top = 552
  end
end
