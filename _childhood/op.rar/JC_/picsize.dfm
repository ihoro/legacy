object Size: TSize
  Left = 248
  Top = 166
  BorderStyle = bsToolWindow
  Caption = 'Размер'
  ClientHeight = 100
  ClientWidth = 169
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 32
    Top = 44
    Width = 41
    Height = 13
    Caption = 'Высота:'
  end
  object Label1: TLabel
    Left = 32
    Top = 12
    Width = 42
    Height = 13
    Caption = 'Ширина:'
  end
  object XEdit: TSpinEdit
    Left = 80
    Top = 8
    Width = 57
    Height = 22
    MaxLength = 4
    MaxValue = 0
    MinValue = 1
    TabOrder = 0
    Value = 0
    OnExit = XEditExit
    OnKeyPress = XEditKeyPress
  end
  object YEdit: TSpinEdit
    Left = 80
    Top = 40
    Width = 57
    Height = 22
    MaxLength = 4
    MaxValue = 0
    MinValue = 1
    TabOrder = 1
    Value = 0
    OnExit = YEditExit
    OnKeyPress = XEditKeyPress
  end
  object OkButton: TButton
    Left = 11
    Top = 72
    Width = 70
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = OkButtonClick
  end
  object CancelButton: TButton
    Left = 91
    Top = 72
    Width = 70
    Height = 25
    Caption = 'Отмена'
    TabOrder = 3
    OnClick = CancelButtonClick
  end
end
