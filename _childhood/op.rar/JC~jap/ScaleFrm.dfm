object Scale: TScale
  Left = 196
  Top = 111
  BorderStyle = bsNone
  Caption = 'Scale'
  ClientHeight = 129
  ClientWidth = 104
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 104
    Height = 129
    Align = alClient
    Style = bsRaised
  end
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
  object tbScale: TTrackBar
    Left = 43
    Top = 8
    Width = 41
    Height = 113
    Max = 5
    Min = 1
    Orientation = trVertical
    PageSize = 1
    Frequency = 1
    Position = 1
    SelEnd = 0
    SelStart = 0
    TabOrder = 0
    TickMarks = tmTopLeft
    TickStyle = tsAuto
    OnChange = tbScaleChange
    OnKeyPress = tbScaleKeyPress
  end
end
