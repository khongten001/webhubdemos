object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 293
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Button1: TButton
    Left = 176
    Top = 216
    Width = 251
    Height = 49
    Caption = 'Convert'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ClientDataSet1: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 312
    Top = 152
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = Table1
    Left = 232
    Top = 56
  end
  object Table1: TTable
    Active = True
    DatabaseName = 'D:\Projects\webhubdemos\Live\Database\whFishStore'
    TableName = 'fishcost.DB'
    Left = 352
    Top = 48
  end
end
