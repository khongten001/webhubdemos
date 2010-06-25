object FormTest: TFormTest
  Left = 286
  Top = 107
  Width = 333
  Height = 262
  Caption = 'Meaningless Converter Utility'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 24
    Width = 43
    Height = 13
    Caption = 'Input File'
  end
  object Label2: TLabel
    Left = 48
    Top = 72
    Width = 23
    Height = 13
    Caption = 'From'
  end
  object Label3: TLabel
    Left = 48
    Top = 96
    Width = 13
    Height = 13
    Caption = 'To'
  end
  object Label4: TLabel
    Left = 40
    Top = 40
    Width = 51
    Height = 13
    Caption = 'Output File'
  end
  object BitBtn1: TBitBtn
    Left = 104
    Top = 120
    Width = 121
    Height = 25
    Caption = '&Ok Convert Now'
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkYes
  end
  object BitBtn2: TBitBtn
    Left = 104
    Top = 153
    Width = 121
    Height = 25
    Caption = 'E&xit'
    TabOrder = 1
    Kind = bkClose
  end
  object EditInputFile: TEdit
    Left = 104
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 
      'd:\Projects\WebHubDemos\Source\DelphiApps\CharReplace\SampleInp' +
      'ut.txt'
  end
  object EditFrom: TEdit
    Left = 104
    Top = 64
    Width = 121
    Height = 21
    MaxLength = 1
    TabOrder = 3
    Text = 'A'
  end
  object EditTo: TEdit
    Left = 104
    Top = 88
    Width = 121
    Height = 21
    MaxLength = 1
    TabOrder = 4
    Text = 'B'
  end
  object EditOutputFile: TEdit
    Left = 104
    Top = 40
    Width = 121
    Height = 21
    TabOrder = 5
    Text = 
      'd:\Projects\WebHubDemos\Source\DelphiApps\CharReplace\SampleOut' +
      'put.txt'
  end
end
