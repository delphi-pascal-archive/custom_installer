object Form1: TForm1
  Left = 371
  Top = 125
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Custom installer'
  ClientHeight = 351
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    554
    351)
  PixelsPerInch = 120
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 304
    Width = 554
    Height = 47
    Align = alBottom
    Shape = bsTopLine
  end
  object btnInstall: TButton
    Left = 387
    Top = 316
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Install'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    Visible = False
    OnClick = btnInstallClick
  end
  object paMain: TPanel
    Left = 0
    Top = 0
    Width = 554
    Height = 302
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    object pcSteps: TPageControl
      Left = 0
      Top = 0
      Width = 554
      Height = 302
      ActivePage = tsInstall
      Align = alClient
      TabOrder = 0
      Visible = False
      object tsWelcome: TTabSheet
        Caption = 'tsWelcome'
        object paWelcome: TPanel
          Left = 0
          Top = 0
          Width = 546
          Height = 274
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object Label1: TLabel
            Left = 208
            Top = 24
            Width = 298
            Height = 19
            Caption = 'Welcome to the MyApp setup wizard'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label2: TLabel
            Left = 208
            Top = 80
            Width = 194
            Height = 13
            Caption = 'This will install MyApp on your computer.'
          end
          object Label3: TLabel
            Left = 208
            Top = 104
            Width = 240
            Height = 13
            Caption = 'Click "Next" to continue, or "Cancel" to exit setup.'
          end
          object imgMyApp: TImage
            Left = 0
            Top = 0
            Width = 180
            Height = 274
            Align = alLeft
          end
        end
      end
      object tsTargetFolder: TTabSheet
        Caption = 'tsTargetFolder'
        ImageIndex = 1
        object paTargetFolder: TPanel
          Left = 0
          Top = 0
          Width = 546
          Height = 274
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object Label13: TLabel
            Left = 24
            Top = 80
            Width = 221
            Height = 13
            Caption = 'Setup will install MyApp in the following folder:'
          end
          object Label14: TLabel
            Left = 24
            Top = 144
            Width = 301
            Height = 13
            Caption = '(Click "Next" to continue, or "Change" to select another folder)'
          end
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 546
            Height = 57
            Align = alTop
            BevelOuter = bvLowered
            Color = clWhite
            TabOrder = 0
            DesignSize = (
              546
              57)
            object imgTargetFolder: TImage
              Left = 492
              Top = 3
              Width = 52
              Height = 52
              Anchors = [akTop, akRight]
            end
            object Label11: TLabel
              Left = 16
              Top = 12
              Width = 176
              Height = 13
              Caption = 'Select target installation folder'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label12: TLabel
              Left = 32
              Top = 32
              Width = 206
              Height = 13
              Caption = 'Where do you want MyApp to be installed?'
            end
          end
          object edTargetFolder: TEdit
            Left = 24
            Top = 104
            Width = 409
            Height = 21
            TabOrder = 1
          end
          object btnChangeFolder: TButton
            Left = 440
            Top = 103
            Width = 65
            Height = 25
            Caption = 'Change...'
            TabOrder = 2
            OnClick = btnChangeFolderClick
          end
        end
      end
      object tsShortcuts: TTabSheet
        Caption = 'tsShortcuts'
        ImageIndex = 2
        object paShortcuts: TPanel
          Left = 0
          Top = 0
          Width = 546
          Height = 274
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object Panel3: TPanel
            Left = 0
            Top = 0
            Width = 546
            Height = 57
            Align = alTop
            BevelOuter = bvLowered
            Color = clWhite
            TabOrder = 0
            DesignSize = (
              546
              57)
            object imgShortcuts: TImage
              Left = 492
              Top = 3
              Width = 52
              Height = 52
              Anchors = [akTop, akRight]
            end
            object Label17: TLabel
              Left = 16
              Top = 12
              Width = 116
              Height = 13
              Caption = 'Shortcuts for MyApp'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label18: TLabel
              Left = 32
              Top = 32
              Width = 269
              Height = 13
              Caption = 'Where do you want shortcuts for MyApp to be created?'
            end
          end
          object chShortcutInPrograms: TCheckBox
            Left = 24
            Top = 72
            Width = 225
            Height = 17
            Caption = 'In "Programs" menu'
            Checked = True
            Enabled = False
            State = cbChecked
            TabOrder = 1
          end
          object chShortcutOnDesktop: TCheckBox
            Left = 24
            Top = 96
            Width = 225
            Height = 17
            Caption = 'On the Desktop'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
          object chShortcutInStartMenu: TCheckBox
            Left = 24
            Top = 120
            Width = 225
            Height = 17
            Caption = 'In "Start" menu'
            Checked = True
            State = cbChecked
            TabOrder = 3
          end
        end
      end
      object tsReadyToInstall: TTabSheet
        Caption = 'tsReadyToInstall'
        ImageIndex = 6
        object paReadyToInstall: TPanel
          Left = 0
          Top = 0
          Width = 546
          Height = 274
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object Panel4: TPanel
            Left = 0
            Top = 0
            Width = 546
            Height = 57
            Align = alTop
            BevelOuter = bvLowered
            Color = clWhite
            TabOrder = 0
            DesignSize = (
              546
              57)
            object imgReadyToInstall: TImage
              Left = 492
              Top = 3
              Width = 52
              Height = 52
              Anchors = [akTop, akRight]
            end
            object Label22: TLabel
              Left = 16
              Top = 12
              Width = 233
              Height = 13
              Caption = 'Setup is now ready to start installing files'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label23: TLabel
              Left = 32
              Top = 32
              Width = 185
              Height = 13
              Caption = 'Click "Install" to start the installation...'
            end
          end
        end
      end
      object tsInstall: TTabSheet
        Caption = 'tsInstall'
        ImageIndex = 3
        object paInstall: TPanel
          Left = 0
          Top = 0
          Width = 546
          Height = 274
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            546
            274)
          object Label19: TLabel
            Left = 16
            Top = 80
            Width = 77
            Height = 13
            Caption = 'Installing files...'
          end
          object laCurrentFile: TLabel
            Left = 88
            Top = 120
            Width = 441
            Height = 13
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = '...'
          end
          object Label21: TLabel
            Left = 16
            Top = 120
            Width = 65
            Height = 13
            AutoSize = False
            Caption = 'Current file:'
          end
          object Label20: TLabel
            Left = 16
            Top = 160
            Width = 513
            Height = 17
            Alignment = taCenter
            AutoSize = False
            Caption = 
              '>>> Use the progress bar and the labels to display progress info' +
              'rmation while extracting files <<<'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            Visible = False
          end
          object Panel5: TPanel
            Left = 0
            Top = 0
            Width = 546
            Height = 57
            Align = alTop
            BevelOuter = bvLowered
            Color = clWhite
            TabOrder = 0
            DesignSize = (
              546
              57)
            object imgInstall: TImage
              Left = 492
              Top = 3
              Width = 52
              Height = 52
              Anchors = [akTop, akRight]
            end
            object Label15: TLabel
              Left = 16
              Top = 12
              Width = 88
              Height = 13
              Caption = 'Installing files...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label16: TLabel
              Left = 32
              Top = 32
              Width = 199
              Height = 13
              Caption = 'Please wait while setup is installing files...'
            end
          end
          object pbSetup: TProgressBar
            Left = 16
            Top = 104
            Width = 513
            Height = 9
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 1
          end
        end
      end
      object tsFinish: TTabSheet
        Caption = 'tsFinish'
        ImageIndex = 4
        object paFinish: TPanel
          Left = 0
          Top = 0
          Width = 546
          Height = 274
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object Label4: TLabel
            Left = 208
            Top = 24
            Width = 255
            Height = 19
            Caption = 'MyApp installation is complete.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label5: TLabel
            Left = 208
            Top = 64
            Width = 142
            Height = 13
            Caption = 'To uninstall MyApp, you may:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object Label6: TLabel
            Left = 280
            Top = 88
            Width = 242
            Height = 26
            Caption = 
              'Go to Control Panel -> Add / remove programs -> select "MyApp" a' +
              'nd click "Remove" button.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            WordWrap = True
          end
          object imgFinish: TImage
            Left = 0
            Top = 0
            Width = 180
            Height = 274
            Align = alLeft
          end
          object Label8: TLabel
            Left = 280
            Top = 128
            Width = 239
            Height = 26
            Caption = 
              'Under "Programs" menu, select "MyApp" and click "Uninstall MyApp' +
              '"'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            WordWrap = True
          end
          object Label7: TLabel
            Left = 232
            Top = 88
            Width = 37
            Height = 13
            Caption = 'either:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label9: TLabel
            Left = 232
            Top = 128
            Width = 15
            Height = 13
            Caption = 'or:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label10: TLabel
            Left = 208
            Top = 208
            Width = 186
            Height = 13
            Caption = 'Click "Finish" to close the setup wizard.'
          end
          object chLaunch: TCheckBox
            Left = 208
            Top = 240
            Width = 97
            Height = 17
            Caption = 'Launch MyApp'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
        end
      end
      object tsSwap: TTabSheet
        Caption = 'tsSwap'
        ImageIndex = 5
      end
    end
  end
  object btnCancel: TButton
    Left = 467
    Top = 316
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object btnNext: TButton
    Left = 387
    Top = 316
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Next'
    TabOrder = 2
    OnClick = btnNextClick
  end
  object btnBack: TButton
    Left = 307
    Top = 316
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Back'
    TabOrder = 1
    Visible = False
    OnClick = btnBackClick
  end
  object btnFinish: TButton
    Left = 467
    Top = 316
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Finish'
    TabOrder = 4
    Visible = False
    OnClick = btnFinishClick
  end
end
