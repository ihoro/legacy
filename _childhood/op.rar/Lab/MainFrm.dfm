object MainForm: TMainForm
  Left = 193
  Top = 107
  Width = 346
  Height = 271
  Caption = 'MainForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 304
    Top = 8
    object New1: TMenuItem
      Caption = '&Labirint'
      object mmiNew: TMenuItem
        Caption = '&New'
        OnClick = mmiNewClick
      end
    end
  end
  object odMap: TOpenDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmaps|*.bmp'
    Left = 272
    Top = 8
  end
end
