object Read: TRead
  Left = 192
  Top = 114
  BorderStyle = bsToolWindow
  Caption = 'Reading log file...'
  ClientHeight = 41
  ClientWidth = 202
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnStop: TButton
    Left = 48
    Top = 8
    Width = 105
    Height = 25
    Caption = 'Stop'
    TabOrder = 0
    OnClick = btnStopClick
  end
end
