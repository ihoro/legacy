object Form1: TForm1
  Left = 192
  Top = 107
  Width = 544
  Height = 375
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 32
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object Label2: TLabel
    Left = 16
    Top = 56
    Width = 27
    Height = 13
    Caption = 'Value'
  end
  object Label3: TLabel
    Left = 144
    Top = 32
    Width = 34
    Height = 13
    Caption = 'Current'
  end
  object Label4: TLabel
    Left = 144
    Top = 56
    Width = 24
    Height = 13
    Caption = 'Total'
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 521
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 448
    Top = 32
    Width = 81
    Height = 25
    Caption = 'Do it!'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 56
    Top = 32
    Width = 81
    Height = 21
    TabOrder = 2
    OnChange = Edit2Change
  end
  object Edit3: TEdit
    Left = 56
    Top = 56
    Width = 81
    Height = 21
    TabOrder = 3
    OnChange = Edit3Change
  end
  object sp1: TSpinEdit
    Left = 184
    Top = 32
    Width = 49
    Height = 22
    MaxValue = 200
    MinValue = 1
    TabOrder = 4
    Value = 1
    OnChange = sp1Change
  end
  object sp2: TSpinEdit
    Left = 184
    Top = 56
    Width = 49
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 5
    Value = 0
  end
end
