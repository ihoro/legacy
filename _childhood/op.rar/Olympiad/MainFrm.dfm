object Main: TMain
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Olympiads (Остапенко Игорь г. Смела Лицей)'
  ClientHeight = 298
  ClientWidth = 369
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
  object pcPrograms: TPageControl
    Left = 0
    Top = 0
    Width = 369
    Height = 298
    ActivePage = tsBinary
    Align = alClient
    TabOrder = 0
    object tsBinary: TTabSheet
      Caption = 'Двоичное число'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      object gbInput1: TGroupBox
        Left = 8
        Top = 8
        Width = 345
        Height = 113
        Caption = 'Input'
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Top = 27
          Width = 94
          Height = 13
          Caption = 'Введите Х (0..255):'
        end
        object seX: TSpinEdit
          Left = 128
          Top = 24
          Width = 57
          Height = 22
          MaxLength = 3
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 0
          OnExit = seXExit
        end
      end
      object gbOutput1: TGroupBox
        Left = 8
        Top = 144
        Width = 345
        Height = 113
        Caption = 'Output'
        TabOrder = 1
        object Edit1: TEdit
          Left = 8
          Top = 24
          Width = 81
          Height = 21
          ReadOnly = True
          TabOrder = 0
        end
      end
    end
    object tsJump: TTabSheet
      Caption = 'Прыг-скок'
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 345
        Height = 113
        Caption = 'Input'
        TabOrder = 0
        object Label2: TLabel
          Left = 16
          Top = 27
          Width = 101
          Height = 13
          Caption = 'Введите высоту (м):'
        end
        object Label3: TLabel
          Left = 16
          Top = 67
          Width = 95
          Height = 13
          Caption = 'Введите время (с):'
        end
        object Edit3: TEdit
          Left = 128
          Top = 64
          Width = 201
          Height = 21
          MaxLength = 4932
          TabOrder = 0
        end
        object Edit2: TEdit
          Left = 128
          Top = 24
          Width = 201
          Height = 21
          MaxLength = 4932
          TabOrder = 1
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 144
        Width = 345
        Height = 113
        Caption = 'Output'
        TabOrder = 1
        object Edit4: TEdit
          Left = 8
          Top = 24
          Width = 329
          Height = 21
          ReadOnly = True
          TabOrder = 0
        end
      end
    end
    object tsPlusMinus: TTabSheet
      Caption = 'Расстановка знаков'
      ImageIndex = 2
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 345
        Height = 113
        Caption = 'Input'
        TabOrder = 0
        object Label4: TLabel
          Left = 16
          Top = 27
          Width = 77
          Height = 13
          Caption = 'Введите число:'
        end
        object SpinEdit1: TSpinEdit
          Left = 112
          Top = 24
          Width = 97
          Height = 22
          MaxLength = 9
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 144
        Width = 345
        Height = 113
        Caption = 'Output'
        TabOrder = 1
        object ListBox1: TListBox
          Left = 8
          Top = 16
          Width = 329
          Height = 89
          ItemHeight = 13
          TabOrder = 0
        end
      end
    end
    object tsDate: TTabSheet
      Caption = 'Дата'
      ImageIndex = 3
      object GroupBox5: TGroupBox
        Left = 8
        Top = 8
        Width = 345
        Height = 113
        Caption = 'Input'
        TabOrder = 0
        object Label5: TLabel
          Left = 8
          Top = 27
          Width = 133
          Height = 13
          Caption = 'Введите дату (дд.мм.гггг):'
        end
        object Edit5: TEdit
          Left = 160
          Top = 24
          Width = 113
          Height = 21
          MaxLength = 10
          TabOrder = 0
        end
      end
      object GroupBox6: TGroupBox
        Left = 8
        Top = 144
        Width = 345
        Height = 113
        Caption = 'Output'
        TabOrder = 1
        object Edit6: TEdit
          Left = 8
          Top = 24
          Width = 129
          Height = 21
          ReadOnly = True
          TabOrder = 0
        end
      end
    end
    object tsTumbaYumba: TTabSheet
      Caption = 'Тумба-Юмба'
      ImageIndex = 4
      object GroupBox7: TGroupBox
        Left = 8
        Top = 8
        Width = 345
        Height = 113
        Caption = 'Input'
        TabOrder = 0
        object Label6: TLabel
          Left = 8
          Top = 24
          Width = 135
          Height = 13
          Caption = 'Input files: 1.dat, 2.dat, 3.dat'
        end
      end
      object GroupBox8: TGroupBox
        Left = 8
        Top = 144
        Width = 345
        Height = 113
        Caption = 'Output'
        TabOrder = 1
        object Label7: TLabel
          Left = 8
          Top = 24
          Width = 78
          Height = 13
          Caption = 'Output file: 4.dat'
        end
      end
    end
    object tsMatroskin: TTabSheet
      Caption = 'Кот Матроскин'
      ImageIndex = 5
      object GroupBox9: TGroupBox
        Left = 8
        Top = 8
        Width = 345
        Height = 113
        Caption = 'Input'
        TabOrder = 0
        object Label8: TLabel
          Left = 16
          Top = 27
          Width = 137
          Height = 13
          Caption = 'Введите количество рыбы:'
        end
        object SpinEdit2: TSpinEdit
          Left = 168
          Top = 24
          Width = 65
          Height = 22
          MaxLength = 10
          MaxValue = 2000000000
          MinValue = 1
          TabOrder = 0
          Value = 1
        end
      end
      object GroupBox10: TGroupBox
        Left = 8
        Top = 144
        Width = 345
        Height = 113
        Caption = 'Output'
        TabOrder = 1
        object Edit7: TEdit
          Left = 8
          Top = 24
          Width = 209
          Height = 21
          ReadOnly = True
          TabOrder = 0
        end
      end
    end
    object tsLabirint: TTabSheet
      Caption = 'Лабиринт'
      ImageIndex = 6
      object GroupBox11: TGroupBox
        Left = 8
        Top = 8
        Width = 345
        Height = 113
        Caption = 'Input'
        TabOrder = 0
        object Label9: TLabel
          Left = 8
          Top = 24
          Width = 94
          Height = 13
          Caption = 'Input file: labirint.dat'
        end
      end
      object GroupBox12: TGroupBox
        Left = 8
        Top = 144
        Width = 345
        Height = 113
        Caption = 'Output'
        TabOrder = 1
        object Edit8: TEdit
          Left = 8
          Top = 24
          Width = 329
          Height = 21
          ReadOnly = True
          TabOrder = 0
        end
      end
    end
    object tsTerminator: TTabSheet
      Caption = 'Терминатор 3'
      ImageIndex = 8
      object GroupBox13: TGroupBox
        Left = 8
        Top = 8
        Width = 345
        Height = 113
        Caption = 'Input'
        TabOrder = 0
        object Label14: TLabel
          Left = 16
          Top = 19
          Width = 82
          Height = 13
          Caption = 'Начальное кол.:'
        end
        object Label15: TLabel
          Left = 16
          Top = 51
          Width = 71
          Height = 13
          Caption = 'Кол. в группе:'
        end
        object Label16: TLabel
          Left = 16
          Top = 83
          Width = 59
          Height = 13
          Caption = 'Кол. новых:'
        end
        object Label17: TLabel
          Left = 184
          Top = 19
          Width = 80
          Height = 13
          Caption = 'Кол. лет жизни:'
        end
        object Label18: TLabel
          Left = 184
          Top = 51
          Width = 21
          Height = 13
          Caption = 'Год:'
        end
        object SpinEdit5: TSpinEdit
          Left = 104
          Top = 16
          Width = 65
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
        object SpinEdit6: TSpinEdit
          Left = 104
          Top = 48
          Width = 65
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 1
          Value = 0
        end
        object SpinEdit7: TSpinEdit
          Left = 104
          Top = 80
          Width = 65
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 2
          Value = 0
        end
        object SpinEdit8: TSpinEdit
          Left = 272
          Top = 16
          Width = 65
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 3
          Value = 0
        end
        object SpinEdit9: TSpinEdit
          Left = 272
          Top = 48
          Width = 65
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 4
          Value = 0
        end
      end
      object GroupBox14: TGroupBox
        Left = 8
        Top = 144
        Width = 345
        Height = 113
        Caption = 'Output'
        TabOrder = 1
        object Edit11: TEdit
          Left = 8
          Top = 16
          Width = 329
          Height = 21
          TabOrder = 0
        end
      end
    end
    object tsAutomat: TTabSheet
      Caption = 'Автомат'
      ImageIndex = 9
      object GroupBox15: TGroupBox
        Left = 8
        Top = 8
        Width = 345
        Height = 113
        Caption = 'Input'
        TabOrder = 0
        object Edit12: TEdit
          Left = 8
          Top = 16
          Width = 329
          Height = 21
          TabOrder = 0
        end
      end
      object GroupBox16: TGroupBox
        Left = 8
        Top = 144
        Width = 345
        Height = 113
        Caption = 'Output'
        TabOrder = 1
        object Edit13: TEdit
          Left = 8
          Top = 16
          Width = 329
          Height = 21
          ReadOnly = True
          TabOrder = 0
        end
      end
    end
  end
  object bbOutput: TBitBtn
    Left = 144
    Top = 150
    Width = 81
    Height = 19
    Caption = 'Output'
    Default = True
    ModalResult = 6
    TabOrder = 1
    OnClick = bbOutputClick
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
  end
  object sdCoder: TSaveDialog
    Filter = 'All files|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 332
    Top = 24
  end
end
