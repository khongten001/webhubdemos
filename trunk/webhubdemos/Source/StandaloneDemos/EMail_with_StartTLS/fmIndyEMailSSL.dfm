object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Test Secure EMail with Indy'
  ClientHeight = 702
  ClientWidth = 1164
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 28
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1164
    Height = 702
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitTop = -8
    object edTo: TLabeledEdit
      Left = 32
      Top = 56
      Width = 513
      Height = 36
      EditLabel.Width = 156
      EditLabel.Height = 28
      EditLabel.Caption = 'EMail Message To'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'webmaster@href.com'
    end
    object edFrom: TLabeledEdit
      Left = 32
      Top = 208
      Width = 513
      Height = 36
      EditLabel.Width = 46
      EditLabel.Height = 28
      EditLabel.Caption = 'From'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'info@href.com'
    end
    object edSubject: TLabeledEdit
      Left = 32
      Top = 288
      Width = 513
      Height = 36
      EditLabel.Width = 65
      EditLabel.Height = 28
      EditLabel.Caption = 'Subject'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 'testing aws email'
    end
    object Memo1: TMemo
      Left = 32
      Top = 335
      Width = 513
      Height = 175
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = []
      Lines.Strings = (
        'Test  message'
        'line 2'
        'and line 3.'
        'Bye.')
      ParentFont = False
      TabOrder = 3
    end
    object BitBtn2: TBitBtn
      Left = 38
      Top = 623
      Width = 1091
      Height = 49
      Caption = 'Test Secure EMail'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = []
      Kind = bkYes
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 4
      OnClick = BitBtn2Click
    end
    object CheckBox1: TCheckBox
      Left = 32
      Top = 516
      Width = 241
      Height = 42
      Caption = 'Include Attachment'
      TabOrder = 5
    end
    object RadioGroup1: TRadioGroup
      Left = 576
      Top = 335
      Width = 249
      Height = 282
      Caption = 'Errors'
      ItemIndex = 0
      Items.Strings = (
        'no intentional errors'
        'bad smtp server'
        'bad username'
        'bad password'
        'bad sender'
        'bad recipient'
        'missing file attachment')
      TabOrder = 6
    end
    object GroupBox1: TGroupBox
      Left = 576
      Top = 16
      Width = 553
      Height = 313
      Caption = 'SMTP Login'
      TabOrder = 7
      object editSMTP: TLabeledEdit
        Left = 16
        Top = 72
        Width = 513
        Height = 36
        EditLabel.Width = 110
        EditLabel.Height = 28
        EditLabel.Caption = 'SMTP Server'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = 'email-smtp.us-east-1.amazonaws.com'
      end
      object EditUser: TLabeledEdit
        Left = 16
        Top = 160
        Width = 513
        Height = 36
        EditLabel.Width = 87
        EditLabel.Height = 28
        EditLabel.Caption = 'Username'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object editPass: TLabeledEdit
        Left = 16
        Top = 240
        Width = 513
        Height = 36
        EditLabel.Width = 82
        EditLabel.Height = 28
        EditLabel.Caption = 'Password'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
    end
    object editFilespec: TLabeledEdit
      Left = 32
      Top = 581
      Width = 513
      Height = 36
      EditLabel.Width = 176
      EditLabel.Height = 28
      EditLabel.Caption = 'Attachment Filespec'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object rbAttachmentTechnique: TRadioGroup
      Left = 831
      Top = 335
      Width = 298
      Height = 273
      Caption = 'Attachment'
      ItemIndex = 0
      Items.Strings = (
        '01 simplest PDF attachment'
        '02 explicit content type'
        '03 ContentTransfer 8BIT'
        '04 TIdMessageBuilderPlain')
      TabOrder = 9
    end
    object EdCC: TLabeledEdit
      Left = 32
      Top = 128
      Width = 513
      Height = 36
      EditLabel.Width = 24
      EditLabel.Height = 28
      EditLabel.Caption = 'CC'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
    end
  end
end
