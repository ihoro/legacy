object Form1: TForm1
  Left = 192
  Top = 106
  BorderStyle = bsNone
  Caption = 'Form1'
  ClientHeight = 137
  ClientWidth = 287
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
  object Label1: TLabel
    Left = 67
    Top = 16
    Width = 152
    Height = 20
    Caption = 'UnInstalling...'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'Lucida Handwriting'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Gauge1: TGauge
    Left = 31
    Top = 56
    Width = 225
    Height = 25
    ForeColor = clBlue
    Progress = 0
  end
  object Label2: TLabel
    Left = 62
    Top = 96
    Width = 163
    Height = 20
    Caption = 'Нервишки сдали?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 248
    Top = 8
  end
end
