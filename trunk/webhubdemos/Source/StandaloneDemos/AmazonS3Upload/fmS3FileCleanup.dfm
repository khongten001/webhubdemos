object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Lowercase Files on AWS S3'
  ClientHeight = 291
  ClientWidth = 775
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object tpComponentPanel1: TtpComponentPanel
    Left = 0
    Top = 0
    Width = 169
    Height = 291
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 169
    Top = 0
    Width = 606
    Height = 291
    Align = alClient
    TabOrder = 1
    object Memo1: TMemo
      Left = 233
      Top = 42
      Width = 372
      Height = 248
      Align = alClient
      Lines.Strings = (
        'Memo1')
      TabOrder = 0
    end
    object GroupBox1: TGroupBox
      Left = 1
      Top = 42
      Width = 232
      Height = 248
      Align = alLeft
      Caption = 'Delete if Found'
      TabOrder = 1
      object MemoDeleteFiles: TMemo
        Left = 2
        Top = 18
        Width = 228
        Height = 228
        Align = alClient
        Lines.Strings = (
          'thumbs.db'
          'WS_FTP.log')
        TabOrder = 0
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 604
      Height = 41
      Align = alTop
      TabOrder = 2
      object Button1: TButton
        Left = 6
        Top = 8
        Width = 155
        Height = 25
        Caption = 'lowercase all'
        TabOrder = 0
        OnClick = Button1Click
      end
      object CheckBox1: TCheckBox
        Left = 184
        Top = 12
        Width = 97
        Height = 17
        Caption = 'As If'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
    end
  end
  object AmazonConnectionInfo1: TAmazonConnectionInfo
    TableEndpoint = 'sdb.amazonaws.com'
    QueueEndpoint = 'queue.amazonaws.com'
    StorageEndpoint = 's3.amazonaws.com'
    Left = 72
    Top = 32
  end
end
