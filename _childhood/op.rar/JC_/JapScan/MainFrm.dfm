object MainForm: TMainForm
  Left = 193
  Top = 107
  BorderStyle = bsNone
  Caption = 'MainForm'
  ClientHeight = 38
  ClientWidth = 134
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 13
  object g: TGauge
    Left = 0
    Top = 0
    Width = 134
    Height = 38
    Align = alClient
    BackColor = clBtnFace
    BorderStyle = bsNone
    ForeColor = 1759523
    Progress = 0
    ShowText = False
  end
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 134
    Height = 38
    Align = alClient
    Style = bsRaised
  end
  object Lab: TLabel
    Left = 6
    Top = 1
    Width = 123
    Height = 32
    Caption = 'Loading...'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -27
    Font.Name = 'Futura Lt BT'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Transparent = True
    OnMouseUp = FormMouseUp
  end
  object dlb: TDirectoryListBox
    Left = 376
    Top = 16
    Width = 241
    Height = 473
    ItemHeight = 16
    TabOrder = 0
    Visible = False
  end
  object flb: TFileListBox
    Left = 264
    Top = 8
    Width = 265
    Height = 417
    ItemHeight = 13
    Mask = '*.jce'
    TabOrder = 1
    Visible = False
  end
  object Timer: TTimer
    Interval = 2000
    OnTimer = TimerTimer
    Left = 112
    Top = 32
  end
end
