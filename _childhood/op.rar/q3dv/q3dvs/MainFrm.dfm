object frmMain: TfrmMain
  Left = 209
  Top = 109
  BorderStyle = bsToolWindow
  Caption = 'q3 dvs'
  ClientHeight = 195
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object gbQ3dvs: TGroupBox
    Left = 8
    Top = 3
    Width = 353
    Height = 150
    Caption = ' quake 3 demo viewer setup '
    TabOrder = 0
    object lbdQuake3: TLabeledEdit
      Left = 16
      Top = 40
      Width = 297
      Height = 21
      EditLabel.Width = 256
      EditLabel.Height = 13
      EditLabel.Caption = 'quake3.exe path (i.e. c:\games\quake3\quake3.exe):'
      ReadOnly = True
      TabOrder = 0
    end
    object lbdRar: TLabeledEdit
      Left = 16
      Top = 80
      Width = 297
      Height = 21
      EditLabel.Width = 260
      EditLabel.Height = 13
      EditLabel.Caption = 'rar.exe (v.3.x) path (i.e. c:\program files\winrar\rar.exe):'
      TabOrder = 1
    end
    object lbdCfg: TLabeledEdit
      Left = 16
      Top = 120
      Width = 297
      Height = 21
      EditLabel.Width = 219
      EditLabel.Height = 13
      EditLabel.Caption = '*.cfg path (i.e. c:\games\quake3\osp\my.cfg):'
      TabOrder = 2
    end
    object btnQuake3: TButton
      Left = 320
      Top = 40
      Width = 25
      Height = 20
      Caption = '...'
      TabOrder = 3
      OnClick = btnQuake3Click
    end
    object btnRar: TButton
      Left = 320
      Top = 80
      Width = 25
      Height = 20
      Caption = '...'
      TabOrder = 4
      OnClick = btnRarClick
    end
    object btnCfg: TButton
      Left = 320
      Top = 120
      Width = 25
      Height = 20
      Caption = '...'
      TabOrder = 5
      OnClick = btnCfgClick
    end
  end
  object btnDone: TButton
    Left = 77
    Top = 165
    Width = 89
    Height = 25
    Caption = 'Done'
    TabOrder = 1
    OnClick = btnDoneClick
  end
  object btnCancel: TButton
    Left = 205
    Top = 165
    Width = 89
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object gbCopyright: TGroupBox
    Left = 8
    Top = 200
    Width = 353
    Height = 81
    TabOrder = 3
    object mmCopyright: TMemo
      Left = 8
      Top = 8
      Width = 337
      Height = 65
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'quake3 demo viewer v. 1.0'
        'quake3 demo viewer setup v. 1.0'
        ''
        'copyright (c) 2004 by OIVSoft'
        'mailto: oivsoft@mail.ru')
      TabOrder = 0
    end
  end
  object btnCopyright: TButton
    Left = 352
    Top = 184
    Width = 8
    Height = 8
    TabOrder = 4
    OnClick = btnCopyrightClick
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'exe'
    Filter = 'quake3.exe|quake3.exe'
    Options = [ofShowHelp, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 312
  end
  object XPManifest: TXPManifest
    Left = 336
  end
end
