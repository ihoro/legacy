object Add: TAdd
  Left = 437
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Добавить'
  ClientHeight = 190
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 0
    Width = 321
    Height = 73
    Caption = 'Файл:'
    TabOrder = 0
    object edtFileName: TEdit
      Left = 8
      Top = 16
      Width = 305
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object btnView: TButton
      Left = 117
      Top = 42
      Width = 86
      Height = 25
      Caption = 'Обзор'
      TabOrder = 1
      OnClick = btnViewClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 80
    Width = 321
    Height = 73
    Caption = 'Hot Keys:'
    TabOrder = 1
    object edtHotKeys: TEdit
      Left = 8
      Top = 16
      Width = 305
      Height = 21
      ReadOnly = True
      TabOrder = 0
      OnExit = edtHotKeysExit
      OnKeyDown = edtHotKeysKeyDown
    end
    object btnClear: TButton
      Left = 168
      Top = 42
      Width = 86
      Height = 25
      Caption = 'Очистить'
      TabOrder = 1
      OnClick = btnClearClick
    end
    object btnNew: TButton
      Left = 67
      Top = 42
      Width = 86
      Height = 25
      Caption = 'Изменить'
      TabOrder = 2
      OnClick = btnNewClick
    end
  end
  object btnOkAdd: TButton
    Left = 73
    Top = 160
    Width = 89
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = btnOkAddClick
  end
  object btnCancelAdd: TButton
    Left = 177
    Top = 160
    Width = 89
    Height = 25
    Caption = 'Отмена'
    TabOrder = 3
    OnClick = btnCancelAddClick
  end
  object OpenDialog: TOpenDialog
    Left = 312
  end
end
