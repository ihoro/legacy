object Global: TGlobal
  Left = 192
  Top = 107
  BorderStyle = bsNone
  Caption = 'Global'
  ClientHeight = 104
  ClientWidth = 104
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
  object Timer: TTimer
    Interval = 3000
    OnTimer = TimerTimer
    Left = 48
    Top = 8
  end
end
