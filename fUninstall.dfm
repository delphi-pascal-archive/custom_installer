object frmUninstall: TfrmUninstall
  Left = 417
  Top = 188
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'MyApp Uninstaller'
  ClientHeight = 118
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  DesignSize = (
    441
    118)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 273
    Height = 13
    Caption = 'This will permanently remove "MyApp" from your system.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 381
    Height = 13
    Caption = 
      'If you are sure you want to continue, click "Uninstall", otherwi' +
      'se, click "Cancel".'
  end
  object btnUninstall: TButton
    Left = 272
    Top = 80
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Uninstall'
    TabOrder = 0
    OnClick = btnUninstallClick
  end
  object btnCancel: TButton
    Left = 352
    Top = 80
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
end
