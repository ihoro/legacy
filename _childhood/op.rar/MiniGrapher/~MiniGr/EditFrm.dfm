object EditForm: TEditForm
  Left = 192
  Top = 123
  BorderStyle = bsToolWindow
  Caption = 'Редактирование'
  ClientHeight = 155
  ClientWidth = 315
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sp7: TSpeedButton
    Left = 168
    Top = 32
    Width = 20
    Height = 20
    Caption = '7'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = sp7Click
  end
  object sp8: TSpeedButton
    Left = 192
    Top = 32
    Width = 20
    Height = 20
    Caption = '8'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = sp8Click
  end
  object sp4: TSpeedButton
    Left = 168
    Top = 56
    Width = 20
    Height = 20
    Caption = '4'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = sp4Click
  end
  object sp5: TSpeedButton
    Left = 192
    Top = 56
    Width = 20
    Height = 20
    Caption = '5'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = sp5Click
  end
  object sp9: TSpeedButton
    Left = 216
    Top = 32
    Width = 20
    Height = 20
    Caption = '9'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = sp9Click
  end
  object sp6: TSpeedButton
    Left = 216
    Top = 56
    Width = 20
    Height = 20
    Caption = '6'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = sp6Click
  end
  object sp1: TSpeedButton
    Left = 168
    Top = 80
    Width = 20
    Height = 20
    Caption = '1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = sp1Click
  end
  object sp2: TSpeedButton
    Left = 192
    Top = 80
    Width = 20
    Height = 20
    Caption = '2'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = sp2Click
  end
  object sp3: TSpeedButton
    Left = 216
    Top = 80
    Width = 20
    Height = 20
    Caption = '3'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = sp3Click
  end
  object sp0: TSpeedButton
    Left = 168
    Top = 104
    Width = 20
    Height = 20
    Caption = '0'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = sp0Click
  end
  object spT: TSpeedButton
    Left = 192
    Top = 104
    Width = 20
    Height = 20
    Caption = ','
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = spTClick
  end
  object spOpenP: TSpeedButton
    Left = 264
    Top = 32
    Width = 20
    Height = 20
    Caption = '('
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = spOpenPClick
  end
  object spCloseP: TSpeedButton
    Left = 288
    Top = 32
    Width = 20
    Height = 20
    Caption = ')'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = spClosePClick
  end
  object spOpenKP: TSpeedButton
    Left = 264
    Top = 56
    Width = 20
    Height = 20
    Caption = '['
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = spOpenKPClick
  end
  object spCloseKP: TSpeedButton
    Left = 288
    Top = 56
    Width = 20
    Height = 20
    Caption = ']'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = spCloseKPClick
  end
  object spOpenFP: TSpeedButton
    Left = 264
    Top = 80
    Width = 20
    Height = 20
    Caption = '{'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = spOpenFPClick
  end
  object spCloseFP: TSpeedButton
    Left = 288
    Top = 80
    Width = 20
    Height = 20
    Caption = '}'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = spCloseFPClick
  end
  object SpeedButton8: TSpeedButton
    Left = 288
    Top = 104
    Width = 20
    Height = 20
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
  end
  object spDiv: TSpeedButton
    Left = 240
    Top = 32
    Width = 20
    Height = 20
    Caption = '/'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = spDivClick
  end
  object spUmn: TSpeedButton
    Left = 240
    Top = 56
    Width = 20
    Height = 20
    Caption = '*'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = spUmnClick
  end
  object spMinus: TSpeedButton
    Left = 240
    Top = 80
    Width = 20
    Height = 20
    Caption = '-'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = spMinusClick
  end
  object spPlus: TSpeedButton
    Left = 240
    Top = 104
    Width = 20
    Height = 20
    Caption = '+'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = spPlusClick
  end
  object spStep: TSpeedButton
    Left = 216
    Top = 104
    Width = 20
    Height = 20
    Caption = '^'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = spStepClick
  end
  object spDelChar: TSpeedButton
    Left = 264
    Top = 104
    Width = 20
    Height = 20
    Caption = '<-'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Spacing = 0
    OnClick = spDelCharClick
  end
  object edtVir: TEdit
    Left = 1
    Top = 5
    Width = 313
    Height = 21
    MaxLength = 65000
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 1
    Top = 27
    Width = 160
    Height = 94
    Caption = 'Функции и константы:'
    TabOrder = 2
    object lblDes: TLabel
      Left = 8
      Top = 46
      Width = 145
      Height = 13
      Alignment = taCenter
      AutoSize = False
    end
    object cbFunc: TComboBox
      Left = 8
      Top = 16
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbFuncChange
      Items.Strings = (
        'abs(x)'
        'sin(x)'
        'cos(x)'
        'tg(x)'
        'ctg(x)'
        'arcsin(x)'
        'arccos(x)'
        'arctg(x)'
        'arcctg(x)'
        'log(a);(x)'
        'ln(x)'
        'lg(x)')
    end
    object btnAddFunc: TButton
      Left = 48
      Top = 67
      Width = 65
      Height = 22
      Caption = 'Вставить'
      TabOrder = 1
      OnClick = btnAddFuncClick
    end
  end
  object btnOk: TButton
    Left = 117
    Top = 128
    Width = 81
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = btnOkClick
  end
end
