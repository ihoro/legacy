object Enter: TEnter
  Left = 211
  Top = 107
  BorderStyle = bsToolWindow
  Caption = 'Ввод кроссворда'
  ClientHeight = 346
  ClientWidth = 531
  Color = clBtnFace
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
  object Label1: TLabel
    Left = 440
    Top = 176
    Width = 42
    Height = 13
    Caption = 'Ширина:'
  end
  object Label2: TLabel
    Left = 440
    Top = 192
    Width = 41
    Height = 13
    Caption = 'Высота:'
  end
  object Label3: TLabel
    Left = 483
    Top = 176
    Width = 3
    Height = 13
  end
  object Label4: TLabel
    Left = 483
    Top = 192
    Width = 3
    Height = 13
  end
  object sgEnterY: TStringGrid
    Left = 0
    Top = 0
    Width = 433
    Height = 345
    DefaultColWidth = 20
    DefaultRowHeight = 20
    FixedCols = 0
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goTabs]
    ParentFont = False
    TabOrder = 5
    OnGetEditMask = sgEnterYGetEditMask
  end
  object sgEnterX: TStringGrid
    Left = 0
    Top = 0
    Width = 433
    Height = 345
    DefaultColWidth = 20
    DefaultRowHeight = 20
    FixedCols = 0
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goTabs]
    ParentFont = False
    TabOrder = 0
    OnGetEditMask = sgEnterXGetEditMask
  end
  object btnX: TButton
    Left = 440
    Top = 8
    Width = 89
    Height = 25
    Caption = 'Данные столб.'
    Enabled = False
    TabOrder = 1
    OnClick = btnXClick
  end
  object btnY: TButton
    Left = 440
    Top = 40
    Width = 89
    Height = 25
    Caption = 'Данные строк'
    TabOrder = 2
    OnClick = btnYClick
  end
  object btnEnterOk: TButton
    Left = 440
    Top = 280
    Width = 89
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = btnEnterOkClick
  end
  object btnEnterCancel: TButton
    Left = 440
    Top = 312
    Width = 89
    Height = 25
    Caption = 'Отмена'
    TabOrder = 4
    OnClick = btnEnterCancelClick
  end
  object btnClearRow: TButton
    Left = 440
    Top = 80
    Width = 89
    Height = 25
    Caption = 'Очист. строку'
    TabOrder = 6
    OnClick = btnClearRowClick
  end
  object btnClearCol: TButton
    Left = 440
    Top = 112
    Width = 89
    Height = 25
    Caption = 'Очист. столбец'
    TabOrder = 7
    OnClick = btnClearColClick
  end
  object btnClearAll: TButton
    Left = 440
    Top = 144
    Width = 89
    Height = 25
    Caption = 'Очистить все'
    TabOrder = 8
    OnClick = btnClearAllClick
  end
  object btnSave: TButton
    Left = 440
    Top = 216
    Width = 89
    Height = 25
    Caption = 'Сохранить'
    TabOrder = 9
    OnClick = btnSaveClick
  end
  object btnLoad: TButton
    Left = 440
    Top = 248
    Width = 89
    Height = 25
    Caption = 'Загрузить'
    TabOrder = 10
    OnClick = btnLoadClick
  end
  object sdJCP: TSaveDialog
    DefaultExt = 'jcp'
    Filter = 'JCP Files (*.jcp)|*.jcp'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 328
    Top = 32
  end
  object odJCP: TOpenDialog
    DefaultExt = 'jcp'
    Filter = 'JCP Files (*.jcp)|*.jcp'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 328
    Top = 64
  end
end
