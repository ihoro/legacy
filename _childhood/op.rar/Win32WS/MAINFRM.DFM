object Main: TMain
  Left = 192
  Top = -200
  Width = 195
  Height = 27
  Caption = 'Win32 WindowsSpy'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Timer: TTimer
    Interval = 1
    OnTimer = TimerTimer
  end
end
