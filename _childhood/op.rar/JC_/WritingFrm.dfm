object Writing: TWriting
  Left = 190
  Top = 107
  BorderStyle = bsNone
  Caption = 'Writing'
  ClientHeight = 79
  ClientWidth = 104
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 104
    Height = 79
    Align = alClient
    Shape = bsFrame
    Style = bsRaised
  end
  object Label1: TLabel
    Left = 5
    Top = 56
    Width = 94
    Height = 13
    Caption = 'Идет запись...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Animate1: TAnimate
    Left = 28
    Top = 3
    Width = 47
    Height = 47
    Active = False
    StopFrame = 36
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 700
    OnTimer = Timer1Timer
    Left = 80
    Top = 8
  end
end
