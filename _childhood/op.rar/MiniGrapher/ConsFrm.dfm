object ConsForm: TConsForm
  Left = 192
  Top = 108
  BorderStyle = bsToolWindow
  Caption = 'Константы'
  ClientHeight = 364
  ClientWidth = 316
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
  object Label1: TLabel
    Left = 5
    Top = 0
    Width = 53
    Height = 13
    Caption = 'Название:'
  end
  object Label2: TLabel
    Left = 112
    Top = 0
    Width = 51
    Height = 13
    Caption = 'Значение:'
  end
  object sgCons: TStringGrid
    Left = 0
    Top = 16
    Width = 313
    Height = 313
    ColCount = 2
    DefaultColWidth = 170
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 200
    FixedRows = 0
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    ColWidths = (
      103
      188)
  end
  object btnOK: TButton
    Left = 117
    Top = 336
    Width = 81
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
end
