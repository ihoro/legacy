object Form1: TForm1
  Left = 317
  Top = 107
  VertScrollBar.Increment = 29
  Align = alClient
  BiDiMode = bdLeftToRight
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '�������� ���������'
  ClientHeight = 367
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  ParentBiDiMode = False
  Visible = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnMouseDown = FormMouseDown
  PixelsPerInch = 96
  TextHeight = 16
  object Cross: TImage
    Left = 0
    Top = 0
    Width = 465
    Height = 367
    Align = alClient
    OnMouseDown = CrossMouseDown
    OnMouseMove = CrossMouseMove
    OnMouseUp = CrossMouseUp
  end
  object imgImportPic: TImage
    Left = 10
    Top = 10
    Width = 90
    Height = 80
    Visible = False
  end
  object ImportImg: TImage
    Left = 108
    Top = 10
    Width = 90
    Height = 80
    AutoSize = True
    Visible = False
  end
  object MediaPlayer1: TMediaPlayer
    Left = 256
    Top = 167
    Width = 307
    Height = 25
    Visible = False
    TabOrder = 0
  end
  object MainMenu1: TMainMenu
    Left = 432
    Top = 8
    object N1: TMenuItem
      Caption = '���������'
      object N7: TMenuItem
        Caption = '�������'
        Enabled = False
        ShortCut = 16462
        Visible = False
        OnClick = N7Click
      end
      object mmiImportPic: TMenuItem
        Caption = '������ �������'
        ShortCut = 16457
        Visible = False
        OnClick = mmiImportPicClick
      end
      object N8: TMenuItem
        Caption = '�������'
        Enabled = False
        ShortCut = 16463
        Visible = False
        OnClick = N8Click
      end
      object N9: TMenuItem
        Caption = '���������'
        Enabled = False
        ShortCut = 16467
        Visible = False
        OnClick = N9Click
      end
      object N10: TMenuItem
        Caption = '��������� ���...'
        Enabled = False
        Visible = False
        OnClick = N10Click
      end
      object N2: TMenuItem
        Caption = '�����'
        ShortCut = 16462
        OnClick = N2Click
      end
      object N3: TMenuItem
        Caption = '���������'
        ShortCut = 16463
        OnClick = N3Click
      end
      object N4: TMenuItem
        Caption = '���������'
        ShortCut = 16467
        OnClick = N4Click
      end
      object N18: TMenuItem
        Caption = '��������� ���...'
        OnClick = N18Click
      end
      object mmiSaveAsBMP: TMenuItem
        Caption = '��������� � BMP'
        Enabled = False
        OnClick = mmiSaveAsBMPClick
      end
      object N21: TMenuItem
        Caption = '-'
      end
      object mmiBuffer: TMenuItem
        Caption = '���������� � �����'
        Enabled = False
        ShortCut = 16451
        OnClick = mmiBufferClick
      end
      object N22: TMenuItem
        Caption = '-'
      end
      object mmiEnter: TMenuItem
        Caption = '������ ���������...'
        OnClick = mmiEnterClick
      end
      object mmiDecision: TMenuItem
        Caption = '������� ����������...'
        Enabled = False
        OnClick = mmiDecisionClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mmiPrint: TMenuItem
        Caption = '������'
        Enabled = False
        object mmiPrintColor: TMenuItem
          Caption = '�������'
          OnClick = mmiPrintColorClick
        end
        object mmiPrintMon: TMenuItem
          Caption = '�����-�����'
          OnClick = mmiPrintMonClick
        end
      end
      object N19: TMenuItem
        Caption = '-'
      end
      object N6: TMenuItem
        Caption = '�����'
        OnClick = N6Click
      end
    end
    object N11: TMenuItem
      Caption = '��������'
      OnClick = N11Click
    end
    object N12: TMenuItem
      Caption = '������'
      object N17: TMenuItem
        Caption = '��������'
        Enabled = False
        ShortCut = 16474
        OnClick = N17Click
      end
      object N13: TMenuItem
        Caption = '��������'
        OnClick = N13Click
      end
      object N14: TMenuItem
        Caption = '������'
        OnClick = N14Click
      end
      object N15: TMenuItem
        Caption = '��������'
        OnClick = N15Click
      end
      object N16: TMenuItem
        Caption = '��������'
        OnClick = N16Click
      end
    end
    object mmiOptions: TMenuItem
      Caption = '���������'
      object mmiMusic: TMenuItem
        Caption = '������� ������'
        object mmiMusicOnOff: TMenuItem
          Caption = '��������'
          Enabled = False
          OnClick = mmiMusicOnOffClick
        end
        object mmiMusicFile: TMenuItem
          Caption = '������'
          OnClick = mmiMusicFileClick
        end
      end
      object mmiBakground: TMenuItem
        Caption = '������� �������'
        OnClick = mmiBakgroundClick
      end
      object miScale: TMenuItem
        Caption = '�������'
        OnClick = miScaleClick
      end
      object mmiColors: TMenuItem
        Caption = '�����'
        OnClick = mmiColorsClick
      end
    end
    object mmiHelp: TMenuItem
      Caption = '�������'
      object mmiDoHelp: TMenuItem
        Caption = '����� �������'
        ShortCut = 112
        OnClick = mmiDoHelpClick
      end
      object N20: TMenuItem
        Caption = '-'
      end
      object mmiAbout: TMenuItem
        Caption = '� ���������'
        OnClick = mmiAboutClick
      end
    end
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 400
    Top = 8
  end
  object SavePic: TSaveDialog
    OnShow = SavePicShow
    DefaultExt = 'jap'
    Filter = '�������� ���������� (*.jap)|*.jap'
    Title = '����������'
    Left = 432
    Top = 40
  end
  object LoadPic: TOpenDialog
    OnShow = LoadPicShow
    DefaultExt = 'jap'
    Filter = '�������� ���������� (*.jap)|*.jap'
    Title = '�������'
    Left = 400
    Top = 40
  end
  object SaveJCD: TSaveDialog
    OnShow = SaveJCDShow
    DefaultExt = 'jcd'
    Filter = '�������� ���������� (*.jcd)|*.jcd'
    Title = '���������'
    Left = 432
    Top = 72
  end
  object LoadJCD: TOpenDialog
    OnShow = LoadJCDShow
    DefaultExt = 'jcd'
    Filter = '�������� ���������� (*.jcd)|*.jcd'
    Title = '�������'
    Left = 400
    Top = 72
  end
  object opdImportPic: TOpenPictureDialog
    OnShow = opdImportPicShow
    Filter = 
      'All (*.bmp;*.emf;*.wmf)|*.bmp;*.emf;*.wmf|Bitmaps (*.bmp)|*.bmp|' +
      'Enhanced Metafiles (*.emf)|*.emf|Metafiles (*.wmf)|*.wmf'
    Title = '�������'
    Left = 368
    Top = 72
  end
  object odMusic2: TOpenDialog
    OnShow = odMusic2Show
    Filter = 'All files(*.wav;*.mp3;*.mid)|*.wav;*.mp3;*.mid'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 368
    Top = 40
  end
  object tmrMusic: TTimer
    Interval = 1
    OnTimer = tmrMusicTimer
    Left = 368
    Top = 8
  end
  object opdBackground: TOpenPictureDialog
    OnShow = opdBackgroundShow
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Title = '�������'
    Left = 432
    Top = 104
  end
  object PrintDialog1: TPrintDialog
    Left = 336
    Top = 8
  end
  object opdBuffer: TSavePictureDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 400
    Top = 104
  end
end
