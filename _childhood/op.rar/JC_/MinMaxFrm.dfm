object MinMax: TMinMax
  Left = 192
  Top = 107
  Width = 112
  Height = 156
  Caption = 'MinMax'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 19
    Top = 13
    Width = 19
    Height = 13
    Caption = 'max'
  end
  object Label2: TLabel
    Left = 19
    Top = 101
    Width = 16
    Height = 13
    Caption = 'min'
  end
  object tbMashtab: TTrackBar
    Left = 43
    Top = 8
    Width = 41
    Height = 113
    Max = 5
    Min = 1
    Orientation = trVertical
    Frequency = 1
    Position = 1
    SelEnd = 0
    SelStart = 0
    TabOrder = 0
    TickMarks = tmTopLeft
    TickStyle = tsAuto
    OnChange = tbMashtabChange
  end
end
