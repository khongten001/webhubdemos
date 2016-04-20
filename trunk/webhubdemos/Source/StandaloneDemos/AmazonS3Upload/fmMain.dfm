object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Delphi TAmazonStorageService'
  ClientHeight = 925
  ClientWidth = 941
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -23
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 31
  object Panel1: TPanel
    Left = 0
    Top = 614
    Width = 941
    Height = 311
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    TabOrder = 0
    object Button1: TButton
      Left = 726
      Top = 8
      Width = 173
      Height = 131
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Upload to S3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object GroupBox2: TGroupBox
      Left = 1
      Top = 1
      Width = 338
      Height = 309
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Source folder'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = []
      Padding.Left = 13
      ParentFont = False
      TabOrder = 1
      object DriveComboBox1: TDriveComboBox
        Left = 15
        Top = 27
        Width = 321
        Height = 31
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
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
        Left = 15
        Top = 58
        Width = 321
        Height = 249
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
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
      end
    end
    object GroupBox3: TGroupBox
      Left = 339
      Top = 1
      Width = 380
      Height = 309
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'File to upload'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = []
      Padding.Left = 13
      ParentFont = False
      TabOrder = 2
      object Label1: TLabel
        Left = 15
        Top = 27
        Width = 363
        Height = 25
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'C:\WINDOWS\system32'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 194
      end
      object FileListBox1: TFileListBox
        Left = 15
        Top = 52
        Width = 363
        Height = 255
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemHeight = 25
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 941
    Height = 577
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object LabeledEditBucket: TLabeledEdit
      Left = 50
      Top = 41
      Width = 373
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      EditLabel.Width = 52
      EditLabel.Height = 25
      EditLabel.Margins.Left = 4
      EditLabel.Margins.Top = 4
      EditLabel.Margins.Right = 4
      EditLabel.Margins.Bottom = 4
      EditLabel.Caption = 'Bucket'
      TabOrder = 0
      Text = 'samples3.embarcadero.com'
    end
    object LabeledEditAccessKey: TLabeledEdit
      Left = 53
      Top = 155
      Width = 373
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      EditLabel.Width = 143
      EditLabel.Height = 25
      EditLabel.Margins.Left = 4
      EditLabel.Margins.Top = 4
      EditLabel.Margins.Right = 4
      EditLabel.Margins.Bottom = 4
      EditLabel.Caption = 'Bucket Access Key'
      TabOrder = 1
    end
    object LabeledEditSecret: TLabeledEdit
      Left = 50
      Top = 245
      Width = 723
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      EditLabel.Width = 128
      EditLabel.Height = 25
      EditLabel.Margins.Left = 4
      EditLabel.Margins.Top = 4
      EditLabel.Margins.Right = 4
      EditLabel.Margins.Bottom = 4
      EditLabel.Caption = 'Secret Password'
      TabOrder = 2
    end
    object LabeledEditTargetPath: TLabeledEdit
      Left = 50
      Top = 313
      Width = 723
      Height = 39
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      EditLabel.Width = 443
      EditLabel.Height = 25
      EditLabel.Margins.Left = 4
      EditLabel.Margins.Top = 4
      EditLabel.Margins.Right = 4
      EditLabel.Margins.Bottom = 4
      EditLabel.Caption = 'Upload Target Path ( blank or end with / example data/ )'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object GroupBox1: TGroupBox
      Left = 463
      Top = 13
      Width = 438
      Height = 223
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Messages (when processing)'
      TabOrder = 4
      object Memo1: TMemo
        Left = 2
        Top = 27
        Width = 434
        Height = 194
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        Lines.Strings = (
          'Memo1')
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object GroupBox4: TGroupBox
    Left = 52
    Top = 373
    Width = 849
    Height = 180
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Custom Header(s)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object MemoCustomHeaders: TMemo
      Left = 2
      Top = 27
      Width = 845
      Height = 151
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = []
      Lines.Strings = (
        'Content-Type=text/html'
        'Cache-Control=max-age=31557600'
        '')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object ComboRegion: TComboBox
    Left = 53
    Top = 82
    Width = 370
    Height = 33
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    ItemIndex = 0
    ParentFont = False
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
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 577
    Width = 941
    Height = 37
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    UseSystemFont = False
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
  end
  object AmazonConnectionInfo1: TAmazonConnectionInfo
    TableEndpoint = 'sdb.amazonaws.com'
    QueueEndpoint = 'queue.amazonaws.com'
    StorageEndpoint = 's3.amazonaws.com'
    Left = 504
    Top = 144
  end
  object MainMenu1: TMainMenu
    Left = 720
    Top = 88
    object File1: TMenuItem
      Caption = '&File'
      object Exit1: TMenuItem
        Action = FileExit1
      end
    end
    object ools1: TMenuItem
      Caption = '&Tools'
      object ActionCreateBucket: TMenuItem
        Action = Action1
        Caption = 'Create Bucket in Region'
      end
    end
  end
  object ActionList1: TActionList
    Left = 504
    Top = 88
    object FileExit1: TFileExit
      Category = 'File'
      Caption = 'E&xit'
      Hint = 'Exit|Quits the application'
      ImageIndex = 43
    end
    object Action1: TAction
      Caption = 'Action1'
      OnExecute = Action1Execute
    end
  end
end
