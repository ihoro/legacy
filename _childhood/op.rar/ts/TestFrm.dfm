object TestForm: TTestForm
  Left = 232
  Top = 109
  BorderStyle = bsNone
  Caption = 'TestForm'
  ClientHeight = 388
  ClientWidth = 407
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
  object bvlTest: TBevel
    Left = 0
    Top = 0
    Width = 407
    Height = 388
    Align = alClient
    Shape = bsFrame
    Style = bsRaised
  end
  object lblTestTime: TLabel
    Left = 16
    Top = 32
    Width = 76
    Height = 13
    Caption = #1042#1088#1077#1084#1103' '#1085#1072' '#1090#1077#1089#1090':'
  end
  object lblTestName: TLabel
    Left = 16
    Top = 8
    Width = 59
    Height = 13
    Caption = 'lblTestName'
  end
  object lblQuestionTime: TLabel
    Left = 16
    Top = 56
    Width = 90
    Height = 13
    Caption = #1042#1088#1077#1084#1103' '#1085#1072' '#1074#1086#1087#1088#1086#1089':'
  end
  object lblTime1: TLabel
    Left = 160
    Top = 34
    Width = 39
    Height = 13
    Caption = 'lblTime1'
  end
  object lblTime2: TLabel
    Left = 160
    Top = 58
    Width = 39
    Height = 13
    Caption = 'lblTime2'
  end
  object gbQuestion: TGroupBox
    Left = 8
    Top = 88
    Width = 393
    Height = 297
    Caption = 'gbQuestion'
    TabOrder = 0
    object memQuestion: TMemo
      Left = 8
      Top = 16
      Width = 377
      Height = 81
      TabStop = False
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'memQuestion')
      ReadOnly = True
      TabOrder = 0
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 104
      Width = 377
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 1
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 120
      Width = 377
      Height = 17
      Caption = 'CheckBox2'
      TabOrder = 2
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 136
      Width = 377
      Height = 17
      Caption = 'CheckBox3'
      TabOrder = 3
    end
    object CheckBox4: TCheckBox
      Left = 8
      Top = 152
      Width = 377
      Height = 17
      Caption = 'CheckBox4'
      TabOrder = 4
    end
    object CheckBox5: TCheckBox
      Left = 8
      Top = 168
      Width = 377
      Height = 17
      Caption = 'CheckBox5'
      TabOrder = 5
    end
    object CheckBox6: TCheckBox
      Left = 8
      Top = 184
      Width = 377
      Height = 17
      Caption = 'CheckBox6'
      TabOrder = 6
    end
    object CheckBox7: TCheckBox
      Left = 8
      Top = 200
      Width = 377
      Height = 17
      Caption = 'CheckBox7'
      TabOrder = 7
    end
    object CheckBox8: TCheckBox
      Left = 8
      Top = 216
      Width = 377
      Height = 17
      Caption = 'CheckBox8'
      TabOrder = 8
    end
    object CheckBox9: TCheckBox
      Left = 8
      Top = 232
      Width = 377
      Height = 17
      Caption = 'CheckBox9'
      TabOrder = 9
    end
    object CheckBox10: TCheckBox
      Left = 8
      Top = 248
      Width = 377
      Height = 17
      Caption = 'CheckBox10'
      TabOrder = 10
    end
    object btnAsk: TButton
      Left = 148
      Top = 264
      Width = 97
      Height = 25
      Caption = #1054#1090#1074#1077#1090#1080#1090#1100
      TabOrder = 11
      OnClick = btnAskClick
    end
  end
  object pbTestTime: TProgressBar
    Left = 200
    Top = 32
    Width = 193
    Height = 17
    TabOrder = 1
  end
  object pbQuestionTime: TProgressBar
    Left = 200
    Top = 56
    Width = 193
    Height = 17
    TabOrder = 2
  end
  object tmrTest: TTimer
    Enabled = False
    OnTimer = tmrTestTimer
    Left = 320
    Top = 8
  end
  object tmrQuestion: TTimer
    Enabled = False
    OnTimer = tmrQuestionTimer
    Left = 352
    Top = 8
  end
end
