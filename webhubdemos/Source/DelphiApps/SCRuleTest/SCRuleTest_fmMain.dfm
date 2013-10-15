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
    Top = 209
    Width = 941
    Height = 8
    Cursor = crVSplit
    Align = alTop
    Color = clMenuHighlight
    ParentColor = False
    ExplicitLeft = -8
    ExplicitTop = 201
  end
  object Splitter3: TSplitter
    Left = 0
    Top = 614
    Width = 941
    Height = 8
    Cursor = crVSplit
    Align = alTop
    Color = clMenuHighlight
    ParentColor = False
    ExplicitTop = 622
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 49
    Width = 941
    Height = 160
    Align = alTop
    Caption = 'Regex Macros'
    TabOrder = 0
    object MemoMacros: TMemo
      Left = 2
      Top = 27
      Width = 937
      Height = 131
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
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
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 217
    Width = 941
    Height = 72
    Align = alTop
    Caption = 'Regex'
    TabOrder = 1
    ExplicitTop = 209
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
      ParentFont = False
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 369
    Width = 941
    Height = 245
    Align = alTop
    Caption = 'Target URLs'
    TabOrder = 2
    ExplicitTop = 361
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
      ScrollBars = ssVertical
      TabOrder = 0
      WordWrap = False
    end
    object MemoMatchCount: TMemo
      Left = 473
      Top = 27
      Width = 466
      Height = 216
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 1
      WordWrap = False
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
      Left = 352
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
      Width = 330
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
    Top = 622
    Width = 941
    Height = 165
    Align = alClient
    Caption = 'Groups Matched'
    TabOrder = 4
    ExplicitTop = 614
    ExplicitHeight = 173
    object MemoMatched: TMemo
      Left = 2
      Top = 27
      Width = 937
      Height = 136
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      ExplicitHeight = 144
    end
  end
  object GroupBox5: TGroupBox
    Left = 0
    Top = 289
    Width = 941
    Height = 80
    Align = alTop
    Caption = 'Expanded Regex'
    TabOrder = 5
    ExplicitTop = 281
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
    end
  end
  object MainMenu1: TMainMenu
    Left = 544
    Top = 112
    object File1: TMenuItem
      Caption = '&File'
      object Open2: TMenuItem
        Caption = 'Open'
        OnClick = Open2Click
      end
      object LoadDefaults1: TMenuItem
        Caption = 'Load &Defaults'
        OnClick = LoadDefaults1Click
      end
      object Save1: TMenuItem
        Caption = '&Save As'
        OnClick = Save1Click
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object iming1: TMenuItem
      Caption = 'Timing'
      object m1x: TMenuItem
        Caption = '1x'
        Checked = True
        RadioItem = True
        OnClick = m1xClick
      end
      object mi1000x: TMenuItem
        Caption = '1000x'
        RadioItem = True
        OnClick = mi1000xClick
      end
      object mi10000x: TMenuItem
        Caption = '10,000x'
        RadioItem = True
        OnClick = mi10000xClick
      end
      object m100000x: TMenuItem
        Caption = '100,000x'
        RadioItem = True
        OnClick = m100000xClick
      end
      object m1000000x: TMenuItem
        Caption = '1,000,000x'
        RadioItem = True
        OnClick = m1000000xClick
      end
    end
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Streamcatcher WebHub Rule Test'
        FileMask = '*.swrt'
      end>
    Options = [fdoOverWritePrompt, fdoNoChangeDir, fdoPathMustExist, fdoFileMustExist]
    Left = 656
    Top = 112
  end
  object FileSaveDialog1: TFileSaveDialog
    DefaultExtension = '.swrt'
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'StreamCatcher WebHub Rule Test'
        FileMask = '*.swrt'
      end>
    Options = [fdoOverWritePrompt, fdoStrictFileTypes, fdoNoChangeDir, fdoPathMustExist]
    Title = 'Save As ... Rule Test'
    Left = 416
    Top = 112
  end
end
