object Decision: TDecision
  Left = 203
  Top = 106
  BorderStyle = bsToolWindow
  Caption = 'Решение кроссворда'
  ClientHeight = 82
  ClientWidth = 294
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnBegin: TButton
    Left = 224
    Top = 5
    Width = 54
    Height = 25
    Caption = 'Начать'
    TabOrder = 0
    OnClick = btnBeginClick
  end
  object btnView: TButton
    Left = 224
    Top = 30
    Width = 70
    Height = 25
    Caption = 'Просмотр'
    TabOrder = 1
    OnClick = btnViewClick
  end
  object btnExit: TButton
    Left = 224
    Top = 55
    Width = 70
    Height = 25
    Caption = 'Свернуть'
    TabOrder = 2
    OnClick = btnExitClick
  end
  object gbStatus: TGroupBox
    Left = 0
    Top = 0
    Width = 225
    Height = 81
    Caption = 'Статистика:'
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 89
      Height = 13
      Caption = 'Всего вариантов:'
    end
    object lblTotal: TLabel
      Left = 128
      Top = 16
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label2: TLabel
      Left = 8
      Top = 36
      Width = 92
      Height = 13
      Caption = 'Текущий вариант:'
    end
    object lblType: TLabel
      Left = 8
      Top = 57
      Width = 3
      Height = 13
    end
    object seR: TSpinEdit
      Left = 128
      Top = 32
      Width = 89
      Height = 22
      Enabled = False
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object MediaPlayer: TMediaPlayer
      Left = 8
      Top = 56
      Width = 29
      Height = 20
      VisibleButtons = [btPlay]
      FileName = 'dec.wav'
      Visible = False
      TabOrder = 1
      TabStop = False
    end
  end
  object btnDec: TButton
    Left = 277
    Top = 5
    Width = 17
    Height = 25
    Caption = '1'
    TabOrder = 4
    OnClick = btnDecClick
  end
  object PopupMenu: TPopupMenu
    MenuAnimation = [maLeftToRight, maTopToBottom]
    Left = 160
    object mmiFull: TMenuItem
      Caption = '1-Решение кроссворда повышенной сложности'
      Checked = True
      OnClick = mmiFullClick
    end
    object mmiPartial: TMenuItem
      Caption = '2-Решение обычного кроссворда'
      OnClick = mmiPartialClick
    end
    object Wall: TMenuItem
      Caption = '-'
    end
    object mmiWav: TMenuItem
      Caption = 'Звуковое оповещение по окончании решения'
      Checked = True
      OnClick = mmiWavClick
    end
  end
end
