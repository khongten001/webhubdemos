object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Delphi TAmazonStorageService'
  ClientHeight = 740
  ClientWidth = 753
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 25
  object Panel1: TPanel
    Left = 0
    Top = 505
    Width = 753
    Height = 235
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 0
    ExplicitTop = 401
    ExplicitHeight = 276
    object Button1: TButton
      Left = 581
      Top = 6
      Width = 138
      Height = 105
      Caption = 'Upload to S3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object GroupBox2: TGroupBox
      Left = 1
      Top = 1
      Width = 270
      Height = 233
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      Caption = 'Source folder'
      Padding.Left = 10
      TabOrder = 1
      ExplicitHeight = 274
      object DriveComboBox1: TDriveComboBox
        Left = 12
        Top = 27
        Width = 256
        Height = 31
        Align = alTop
        DirList = DirectoryListBox1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object DirectoryListBox1: TDirectoryListBox
        Left = 12
        Top = 58
        Width = 256
        Height = 173
        Align = alClient
        DirLabel = Label1
        FileList = FileListBox1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemHeight = 25
        ParentFont = False
        TabOrder = 1
        ExplicitHeight = 214
      end
    end
    object GroupBox3: TGroupBox
      Left = 271
      Top = 1
      Width = 304
      Height = 233
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      Caption = 'File to upload'
      Padding.Left = 10
      TabOrder = 2
      ExplicitHeight = 274
      object Label1: TLabel
        Left = 12
        Top = 27
        Width = 290
        Height = 25
        Align = alTop
        Caption = 'C:\WINDOWS\system32'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 168
      end
      object FileListBox1: TFileListBox
        Left = 12
        Top = 52
        Width = 290
        Height = 179
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemHeight = 25
        ParentFont = False
        TabOrder = 0
        ExplicitHeight = 220
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 753
    Height = 505
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    TabOrder = 1
    ExplicitLeft = 1
    ExplicitTop = 40
    object LabeledEditBucket: TLabeledEdit
      Left = 40
      Top = 33
      Width = 298
      Height = 33
      EditLabel.Width = 206
      EditLabel.Height = 25
      EditLabel.Caption = 'Bucket (try one in US East)'
      TabOrder = 0
      Text = 'screenshots.href.com'
    end
    object LabeledEditAccessKey: TLabeledEdit
      Left = 40
      Top = 156
      Width = 298
      Height = 33
      EditLabel.Width = 143
      EditLabel.Height = 25
      EditLabel.Caption = 'Bucket Access Key'
      TabOrder = 1
    end
    object LabeledEditSecret: TLabeledEdit
      Left = 40
      Top = 224
      Width = 578
      Height = 33
      EditLabel.Width = 129
      EditLabel.Height = 25
      EditLabel.Caption = 'Secret Password'
      TabOrder = 2
    end
    object LabeledEditTargetPath: TLabeledEdit
      Left = 40
      Top = 289
      Width = 578
      Height = 33
      EditLabel.Width = 446
      EditLabel.Height = 25
      EditLabel.Caption = 'Upload Target Path ( blank or end with / example data/ )'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object GroupBox1: TGroupBox
      Left = 370
      Top = 10
      Width = 351
      Height = 179
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Messages (when uploading)'
      TabOrder = 4
      object Memo1: TMemo
        Left = 2
        Top = 27
        Width = 347
        Height = 150
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Lines.Strings = (
          'Memo1')
        TabOrder = 0
        ExplicitHeight = 102
      end
    end
  end
  object GroupBox4: TGroupBox
    Left = 40
    Top = 330
    Width = 679
    Height = 169
    Caption = 'Custom Header(s)'
    TabOrder = 2
    object MemoCustomHeaders: TMemo
      Left = 2
      Top = 27
      Width = 675
      Height = 140
      Align = alClient
      Lines.Strings = (
        'Content-Type=text/html'
        'Cache-Control=max-age=31557600'
        '')
      ScrollBars = ssVertical
      TabOrder = 0
      ExplicitLeft = 3
      ExplicitTop = 35
      ExplicitHeight = 76
    end
  end
  object ComboRegion: TComboBox
    Left = 42
    Top = 80
    Width = 296
    Height = 33
    ItemIndex = 0
    TabOrder = 3
    Text = 'us-east-1'
    Items.Strings = (
      'us-east-1'
      'us-west-1'
      'us-west-2'
      'eu-west-1'
      'eu-central-1'
      'ap-northeast-1'
      'ap-northeast-2'
      'ap-southeast-1'
      'ap-southeast-2'
      'sa-east-1')
  end
  object AmazonConnectionInfo1: TAmazonConnectionInfo
    TableEndpoint = 'sdb.amazonaws.com'
    QueueEndpoint = 'queue.amazonaws.com'
    StorageEndpoint = 's3.amazonaws.com'
    Left = 520
    Top = 192
  end
end