object TransColor: TTransColor
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = #1048#1084#1087#1086#1088#1090' '#1088#1080#1089#1091#1085#1082#1072
  ClientHeight = 150
  ClientWidth = 243
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
  object Button1: TButton
    Left = 73
    Top = 121
    Width = 98
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 114
    Height = 106
    Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072
    TabOrder = 1
    object Shape1: TShape
      Left = 7
      Top = 16
      Width = 99
      Height = 50
      Pen.Color = clNone
      OnMouseUp = Shape1MouseUp
    end
    object Button2: TButton
      Left = 8
      Top = 73
      Width = 98
      Height = 25
      Caption = #1048#1079' '#1088#1080#1089#1091#1085#1082#1072
      TabOrder = 0
      OnClick = Button2Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 129
    Top = 8
    Width = 106
    Height = 106
    Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1099
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 28
      Width = 10
      Height = 13
      Caption = 'X:'
    end
    object Label2: TLabel
      Left = 8
      Top = 68
      Width = 10
      Height = 13
      Caption = 'Y:'
    end
    object SpinEdit1: TSpinEdit
      Left = 32
      Top = 25
      Width = 66
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object SpinEdit2: TSpinEdit
      Left = 32
      Top = 65
      Width = 66
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 208
  end
end
