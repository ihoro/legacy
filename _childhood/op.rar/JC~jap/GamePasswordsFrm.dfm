object GP: TGP
  Left = 206
  Top = 109
  BorderStyle = bsDialog
  Caption = 'All Passwords'
  ClientHeight = 206
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 99
    Top = 8
    Width = 125
    Height = 19
    Caption = 'All Passwords'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Lucida Handwriting'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object memData: TMemo
    Left = 8
    Top = 32
    Width = 305
    Height = 137
    Lines.Strings = (
      'memData')
    ReadOnly = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 105
    Top = 176
    Width = 113
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
end
