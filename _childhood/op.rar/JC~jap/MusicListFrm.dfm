object MusicList: TMusicList
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Список'
  ClientHeight = 326
  ClientWidth = 463
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 449
    Height = 281
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 382
      Top = 248
      Width = 25
      Height = 25
      Hint = 'Вверх'
      Glyph.Data = {
        B6010000424DB60100000000000036000000280000000A0000000C0000000100
        18000000000080010000C40E0000C40E00000000000000000000C0C0C0C0C0C0
        C0C0C0808080808080808080808080808080C0C0C0C0C0C00000C0C0C0C0C0C0
        800000800000800000800000800000808080C0C0C0C0C0C00000C0C0C0C0C0C0
        FF0000FF0000FF0000FF0000800000808080C0C0C0C0C0C00000C0C0C0C0C0C0
        FF0000FF0000FF0000FF0000800000808080C0C0C0C0C0C00000C0C0C0C0C0C0
        FF0000FF0000FF0000FF0000800000808080C0C0C0C0C0C00000C0C0C0C0C0C0
        FF0000FF0000FF0000FF0000800000808080C0C0C0C0C0C00000C0C0C0C0C0C0
        FF0000FF0000FF0000FF00008000008080808080808080800000FF0000FF0000
        FF0000FF0000FF0000FF0000FF0000FF0000FF0000C0C0C00000C0C0C0FF0000
        FF0000FF0000FF0000FF0000FF0000FF0000C0C0C0C0C0C00000C0C0C0C0C0C0
        FF0000FF0000FF0000FF0000FF0000C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C0
        C0C0C0FF0000FF0000FF0000C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C0
        C0C0C0C0C0C0FF0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000}
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 410
      Top = 248
      Width = 25
      Height = 25
      Hint = 'Вниз'
      Glyph.Data = {
        B6010000424DB60100000000000036000000280000000A0000000C0000000100
        18000000000080010000C40E0000C40E00000000000000000000C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0808080C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C0
        C0C0C0C0C0C0800000808080808080C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C0
        C0C0C0FF0000FF0000800000808080808080C0C0C0C0C0C00000C0C0C0C0C0C0
        FF0000FF0000FF0000FF0000800000808080808080C0C0C00000C0C0C0FF0000
        FF0000FF0000FF0000FF0000FF00008000008080808080800000FF0000FF0000
        FF0000FF0000FF0000FF0000800000800000800000C0C0C00000C0C0C0C0C0C0
        FF0000FF0000FF0000FF0000800000808080C0C0C0C0C0C00000C0C0C0C0C0C0
        FF0000FF0000FF0000FF0000800000808080C0C0C0C0C0C00000C0C0C0C0C0C0
        FF0000FF0000FF0000FF0000800000808080C0C0C0C0C0C00000C0C0C0C0C0C0
        FF0000FF0000FF0000FF0000800000808080C0C0C0C0C0C00000C0C0C0C0C0C0
        FF0000FF0000FF0000FF0000800000808080C0C0C0C0C0C00000C0C0C0C0C0C0
        FF0000FF0000FF0000FF0000800000C0C0C0C0C0C0C0C0C00000}
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object lbMusicList: TListBox
      Left = 8
      Top = 16
      Width = 433
      Height = 225
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbMusicListClick
    end
    object Button1: TButton
      Left = 14
      Top = 248
      Width = 67
      Height = 25
      Caption = '&Добавить'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 86
      Top = 248
      Width = 67
      Height = 25
      Caption = '&Удалить'
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 158
      Top = 248
      Width = 67
      Height = 25
      Caption = '&Очистить'
      TabOrder = 3
      OnClick = Button3Click
    end
    object Button5: TButton
      Left = 230
      Top = 248
      Width = 67
      Height = 25
      Caption = 'Сохранить'
      TabOrder = 4
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 302
      Top = 248
      Width = 67
      Height = 25
      Caption = 'Загрузить'
      TabOrder = 5
      OnClick = Button6Click
    end
  end
  object Button4: TButton
    Left = 187
    Top = 296
    Width = 89
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button4Click
  end
  object odMusic: TOpenDialog
    OnShow = odMusicShow
    Filter = 'All files(*.wav;*.mp3;*.mid)|*.wav;*.mp3;*.mid'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 360
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'MusicList'
    Filter = 'Музыкальный лист|*.MusicList'
    Left = 392
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'MusicList'
    Filter = 'Музыкальный лист|*.MusicList'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 424
    Top = 8
  end
end
