inherited fmSearchForm: TfmSearchForm
  Left = 288
  Top = 125
  Width = 705
  Height = 672
  Caption = 'DSP Search, 2-7-98'
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 697
    Height = 628
    inherited PageControl1: TPageControl
      Width = 687
      Height = 618
      inherited TabSheet1: TTabSheet
        Caption = '&Search'
        inherited Panel: TPanel
          Width = 679
          Height = 550
          BorderWidth = 5
          object SearchPanel: TPanel
            Left = 5
            Top = 5
            Width = 146
            Height = 536
            Align = alLeft
            BevelOuter = bvLowered
            Caption = ' '
            TabOrder = 0
            object Label1: TLabel
              Left = 8
              Top = 8
              Width = 38
              Height = 13
              Caption = 'Look in:'
            end
            object Label2: TLabel
              Left = 8
              Top = 48
              Width = 52
              Height = 13
              Caption = 'Search for:'
            end
            object Label3: TLabel
              Left = 8
              Top = 101
              Width = 59
              Height = 13
              Caption = 'But exclude:'
            end
            object Label4: TLabel
              Left = 9
              Top = 448
              Width = 52
              Height = 13
              Caption = 'Fuzzyness:'
            end
            object GroupBox2: TGroupBox
              Left = 8
              Top = 376
              Width = 130
              Height = 57
              Caption = 'Must be:'
              TabOrder = 4
              object cbWithSource: TCheckBox
                Left = 8
                Top = 14
                Width = 81
                Height = 17
                Caption = 'with Source'
                TabOrder = 0
              end
              object cbFree: TCheckBox
                Left = 8
                Top = 29
                Width = 49
                Height = 17
                Caption = 'Free'
                TabOrder = 1
              end
            end
            object SearchValue: TMemo
              Left = 8
              Top = 64
              Width = 130
              Height = 32
              ScrollBars = ssVertical
              TabOrder = 0
            end
            object coGroup: TComboBox
              Left = 8
              Top = 24
              Width = 130
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 1
              Items.Strings = (
                'All Categories')
            end
            object SearchExclude: TMemo
              Left = 8
              Top = 117
              Width = 130
              Height = 19
              ScrollBars = ssVertical
              TabOrder = 2
            end
            object GroupBox1: TGroupBox
              Left = 8
              Top = 139
              Width = 130
              Height = 230
              Caption = 'Select only:'
              TabOrder = 3
              object cbD10: TCheckBox
                Left = 8
                Top = 145
                Width = 46
                Height = 17
                Caption = 'D10'
                TabOrder = 0
              end
              object cbD20: TCheckBox
                Left = 8
                Top = 128
                Width = 46
                Height = 17
                Caption = 'D20'
                TabOrder = 1
              end
              object cbD30: TCheckBox
                Left = 8
                Top = 111
                Width = 46
                Height = 17
                Caption = 'D30'
                TabOrder = 2
              end
              object cbD40: TCheckBox
                Left = 8
                Top = 95
                Width = 46
                Height = 17
                Caption = 'D40'
                TabOrder = 3
              end
              object cbC10: TCheckBox
                Left = 56
                Top = 131
                Width = 46
                Height = 17
                Caption = 'C10'
                TabOrder = 4
              end
              object cbC30: TCheckBox
                Left = 56
                Top = 114
                Width = 46
                Height = 17
                Caption = 'C30'
                TabOrder = 5
              end
              object cbD50: TCheckBox
                Left = 8
                Top = 79
                Width = 46
                Height = 17
                Caption = 'D50'
                TabOrder = 6
              end
              object cbD60: TCheckBox
                Left = 8
                Top = 63
                Width = 46
                Height = 17
                Caption = 'D60'
                TabOrder = 7
              end
              object cbK10: TCheckBox
                Left = 56
                Top = 47
                Width = 46
                Height = 17
                Caption = 'K10'
                TabOrder = 8
              end
              object cbC50: TCheckBox
                Left = 56
                Top = 82
                Width = 46
                Height = 17
                Caption = 'C50'
                TabOrder = 9
              end
              object cbC40: TCheckBox
                Left = 56
                Top = 98
                Width = 46
                Height = 17
                Caption = 'C40'
                TabOrder = 10
              end
              object cbK20: TCheckBox
                Left = 56
                Top = 31
                Width = 46
                Height = 17
                Caption = 'K20'
                TabOrder = 11
              end
              object cbC60: TCheckBox
                Left = 56
                Top = 64
                Width = 46
                Height = 17
                Caption = 'C60'
                TabOrder = 12
              end
              object cbJ10: TCheckBox
                Left = 8
                Top = 205
                Width = 46
                Height = 17
                Caption = 'J10'
                TabOrder = 13
              end
              object cbJ20: TCheckBox
                Left = 8
                Top = 188
                Width = 46
                Height = 17
                Caption = 'J20'
                TabOrder = 14
              end
              object cbJ60: TCheckBox
                Left = 8
                Top = 171
                Width = 46
                Height = 17
                Caption = 'J60'
                TabOrder = 15
              end
              object cbD70: TCheckBox
                Left = 8
                Top = 47
                Width = 46
                Height = 17
                Caption = 'D70'
                TabOrder = 16
              end
              object cbK30: TCheckBox
                Left = 56
                Top = 15
                Width = 46
                Height = 17
                Caption = 'K30'
                TabOrder = 17
              end
              object cbD80: TCheckBox
                Left = 8
                Top = 31
                Width = 46
                Height = 17
                Caption = 'D80'
                TabOrder = 18
              end
              object cbD2K5: TCheckBox
                Left = 8
                Top = 15
                Width = 46
                Height = 17
                Caption = 'D2K5'
                TabOrder = 19
              end
            end
            object coFuzzy: TComboBox
              Left = 75
              Top = 444
              Width = 63
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 5
              Items.Strings = (
                'Auto'
                'None'
                'Some'
                'Fuzzy'
                'Fuzzier')
            end
          end
          object ListBox: TListBox
            Left = 151
            Top = 5
            Width = 60
            Height = 536
            Align = alLeft
            ItemHeight = 13
            TabOrder = 1
            OnClick = ListBoxClick
          end
          object Panel2: TPanel
            Left = 211
            Top = 5
            Width = 459
            Height = 536
            Align = alClient
            BevelOuter = bvNone
            Caption = ' '
            TabOrder = 2
            object mDetails: TMemo
              Left = 0
              Top = 26
              Width = 459
              Height = 225
              Align = alTop
              Lines.Strings = (
                'mDetails')
              TabOrder = 0
            end
            object mWords: TMemo
              Left = 0
              Top = 251
              Width = 459
              Height = 285
              Align = alClient
              Lines.Strings = (
                'mWords')
              TabOrder = 1
            end
            object Panel3: TPanel
              Left = 0
              Top = 0
              Width = 459
              Height = 26
              Align = alTop
              BevelOuter = bvLowered
              Caption = ' '
              TabOrder = 2
              object tpLabel1: TLabel
                Left = 8
                Top = 7
                Width = 115
                Height = 13
                Caption = 'http://delphi.icm.edu.pl/'
                Color = clBtnFace
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentColor = False
                ParentFont = False
              end
            end
          end
        end
        inherited ToolBar: TtpToolBar
          Width = 679
          Caption = 'Welcome.'
          object Button1: TButton
            Left = 8
            Top = 7
            Width = 131
            Height = 25
            Caption = 'FIND'
            TabOrder = 0
            OnClick = Button1Click
          end
        end
      end
      object tsWords: TTabSheet
        Caption = '&Words'
        object DBGrid1: TDBGrid
          Left = 0
          Top = 41
          Width = 679
          Height = 524
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
          Top = 565
          Width = 679
          Height = 25
          Align = alBottom
          TabOrder = 1
        end
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 679
          Height = 41
          Align = alTop
          Caption = ' '
          TabOrder = 2
          object btMake: TButton
            Left = 8
            Top = 8
            Width = 131
            Height = 25
            Caption = 'Make Dictionary'
            TabOrder = 0
            OnClick = btMakeClick
          end
          object btnShowWords: TButton
            Left = 152
            Top = 8
            Width = 75
            Height = 25
            Caption = 'Show Words'
            TabOrder = 1
            OnClick = btnShowWordsClick
          end
        end
      end
      object tsFiles: TTabSheet
        Caption = '&Files'
        object DBGrid2: TDBGrid
          Left = 0
          Top = 0
          Width = 679
          Height = 565
          Align = alClient
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
        object DBNavigator2: TDBNavigator
          Left = 0
          Top = 565
          Width = 679
          Height = 25
          Align = alBottom
          TabOrder = 1
        end
      end
    end
  end
end
