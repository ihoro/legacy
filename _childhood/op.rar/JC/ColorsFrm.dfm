object Colors: TColors
  Left = 194
  Top = 109
  BorderStyle = bsDialog
  Caption = 'Цвета'
  ClientHeight = 239
  ClientWidth = 364
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 345
    Height = 193
    Caption = 'Настройка цвета:'
    TabOrder = 0
    object Panel1: TPanel
      Left = 8
      Top = 48
      Width = 329
      Height = 105
      TabOrder = 0
      OnClick = Panel1Click
    end
    object Button1: TButton
      Left = 120
      Top = 160
      Width = 105
      Height = 25
      Caption = '&Стандартный'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 232
      Top = 160
      Width = 105
      Height = 25
      Caption = 'Стандартные &все'
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 8
      Top = 160
      Width = 105
      Height = 25
      Caption = '&Цвет'
      Default = True
      TabOrder = 3
      OnClick = Button3Click
    end
  end
  object btnOk: TButton
    Left = 70
    Top = 208
    Width = 105
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 190
    Top = 208
    Width = 105
    Height = 25
    Caption = 'Отмена'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object cbThing: TComboBox
    Left = 16
    Top = 24
    Width = 329
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 3
    OnChange = cbThingChange
    Items.Strings = (
      'Фон рабочего поля'
      'Закрашеная клетка'
      'Пометка клетки'
      'Фон числового поля'
      'Пометка числового поля'
      'Цвет чисел')
  end
  object cdColors: TColorDialog
    Ctl3D = True
    Options = [cdFullOpen]
    Left = 336
  end
end
