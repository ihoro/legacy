object Form1: TForm1
  Left = 192
  Top = 111
  BorderStyle = bsNone
  Caption = 'Form1'
  ClientHeight = 167
  ClientWidth = 284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Gauge1: TGauge
    Left = 37
    Top = 64
    Width = 209
    Height = 25
    Color = clBtnFace
    ForeColor = clBlue
    ParentColor = False
    Progress = 0
  end
  object Label1: TLabel
    Left = 80
    Top = 16
    Width = 123
    Height = 20
    Caption = 'Installing...'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'Lucida Handwriting'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 68
    Top = 112
    Width = 149
    Height = 13
    Caption = 'Эта программа для ламеров.'
  end
  object Label3: TLabel
    Left = 44
    Top = 136
    Width = 197
    Height = 13
    Caption = 'Для проfи это - ясли (первая четверть)'
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 240
    Top = 16
  end
end
