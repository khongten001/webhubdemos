object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'StreamCatcher / WebHub Rule Tester'
  ClientHeight = 787
  ClientWidth = 941
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 25
  object Splitter2: TSplitter
    Left = 0
    Top = 606
    Width = 941
    Height = 8
    Cursor = crVSplit
    Align = alTop
    Color = clMenuHighlight
    ParentColor = False
    ExplicitLeft = -8
    ExplicitTop = 618
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 49
    Width = 941
    Height = 160
    Align = alTop
    Caption = 'Regex Macros'
    TabOrder = 0
    ExplicitTop = 41
    ExplicitWidth = 633
    object MemoMacros: TMemo
      Left = 2
      Top = 27
      Width = 937
      Height = 131
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      Lines.Strings = (
        #171'sessionid'#187'=([0-9]+(\.[0-9]+)?)'
        #171'appid'#187'=(csweb|csorder)'
        #171'lingvow'#187'=([a-z]{2}(-[a-z]{2})?/)'
        #171'pageid'#187'=([A-Za-z0-9_]{1,35})'
        #171'command'#187'=([^?@]*)'
        #171'seotail'#187'=([^@]*)')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      ExplicitWidth = 629
      ExplicitHeight = 174
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 209
    Width = 941
    Height = 72
    Align = alTop
    Caption = 'Regex'
    TabOrder = 1
    ExplicitTop = 201
    ExplicitWidth = 633
    object MemoRegex: TMemo
      Left = 2
      Top = 27
      Width = 937
      Height = 43
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        '^/'#171'pageid'#187'?([:/]'#171'sessionid'#187'?([:/]'#171'command'#187')?)?$')
      ParentFont = False
      TabOrder = 0
      ExplicitLeft = 224
      ExplicitTop = 8
      ExplicitWidth = 185
      ExplicitHeight = 89
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 361
    Width = 941
    Height = 245
    Align = alTop
    Caption = 'Target URLs'
    TabOrder = 2
    ExplicitTop = 484
    ExplicitWidth = 633
    object Splitter1: TSplitter
      Left = 465
      Top = 27
      Width = 8
      Height = 216
      Color = clMenuHighlight
      ParentColor = False
      ExplicitLeft = 257
      ExplicitHeight = 178
    end
    object MemoURLs: TMemo
      Left = 2
      Top = 27
      Width = 463
      Height = 216
      Align = alLeft
      Lines.Strings = (
        '/contact'
        '/'
        '/contact:123'
        '/?gclid=123xyz'
        '/creditapp'
        '/feedback')
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object MemoMatchCount: TMemo
      Left = 473
      Top = 27
      Width = 466
      Height = 216
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 1
      ExplicitLeft = 265
      ExplicitWidth = 366
      ExplicitHeight = 178
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 941
    Height = 49
    Align = alTop
    TabOrder = 3
    object Button1: TButton
      Left = 264
      Top = 8
      Width = 433
      Height = 35
      Caption = 'Test'
      TabOrder = 0
      OnClick = Button1Click
    end
    object EditTestName: TEdit
      Left = 16
      Top = 10
      Width = 201
      Height = 33
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlightText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'StartWithPageID'
    end
  end
  object GroupBox4: TGroupBox
    Left = 0
    Top = 614
    Width = 941
    Height = 173
    Align = alClient
    Caption = 'Groups Matched'
    TabOrder = 4
    ExplicitTop = 387
    ExplicitWidth = 633
    ExplicitHeight = 207
    object MemoMatched: TMemo
      Left = 2
      Top = 27
      Width = 937
      Height = 144
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      ExplicitWidth = 629
      ExplicitHeight = 178
    end
  end
  object GroupBox5: TGroupBox
    Left = 0
    Top = 281
    Width = 941
    Height = 80
    Align = alTop
    Caption = 'Expanded Regex'
    TabOrder = 5
    ExplicitTop = 273
    ExplicitWidth = 633
    object MemoExpandedRegex: TMemo
      Left = 2
      Top = 27
      Width = 937
      Height = 51
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ExplicitLeft = 224
      ExplicitTop = 8
      ExplicitWidth = 185
      ExplicitHeight = 89
    end
  end
  object MainMenu1: TMainMenu
    Left = 544
    Top = 112
    object File1: TMenuItem
      Caption = '&File'
      object Open1: TMenuItem
        Caption = 'L&oad'
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = '&Save'
        OnClick = Save1Click
      end
    end
  end
end
