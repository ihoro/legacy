object Form2: TForm2
  Left = 207
  Top = 248
  BorderStyle = bsDialog
  Caption = 'Настройки'
  ClientHeight = 152
  ClientWidth = 230
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 65
    Top = 120
    Width = 99
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object RadioGroup1: TRadioGroup
    Left = 3
    Top = 8
    Width = 102
    Height = 97
    Caption = 'Звук'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 24
    Width = 65
    Height = 17
    Caption = 'Секунды'
    TabOrder = 2
    OnClick = CheckBox1Click
  end
  object CheckBox2: TCheckBox
    Left = 16
    Top = 48
    Width = 65
    Height = 17
    Caption = 'Часы'
    TabOrder = 3
    OnClick = CheckBox2Click
  end
  object GroupBox1: TGroupBox
    Left = 112
    Top = 8
    Width = 113
    Height = 97
    Caption = 'Будильник'
    TabOrder = 4
    object Label1: TLabel
      Left = 8
      Top = 43
      Width = 28
      Height = 13
      Caption = 'Часы'
    end
    object Label2: TLabel
      Left = 8
      Top = 67
      Width = 39
      Height = 13
      Caption = 'Минуты'
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Включен'
      TabOrder = 0
      OnClick = CheckBox3Click
    end
    object SpinChas: TSpinEdit
      Left = 56
      Top = 40
      Width = 41
      Height = 22
      MaxLength = 2
      MaxValue = 23
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnExit = SpinChasExit
    end
    object SpinMin: TSpinEdit
      Left = 56
      Top = 64
      Width = 41
      Height = 22
      MaxLength = 2
      MaxValue = 59
      MinValue = 0
      TabOrder = 2
      Value = 0
      OnExit = SpinMinExit
    end
  end
end
