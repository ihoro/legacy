object MainForm: TMainForm
  Left = 222
  Top = 111
  Width = 801
  Height = 534
  Caption = 'Testing System - Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblCountStudents: TLabel
    Left = 16
    Top = 639
    Width = 80
    Height = 13
    Caption = 'lblCountStudents'
  end
  object lblCountPlans: TLabel
    Left = 472
    Top = 599
    Width = 64
    Height = 13
    Caption = 'lblCountPlans'
  end
  object lblTestsCount2: TLabel
    Left = 464
    Top = 616
    Width = 70
    Height = 13
    Caption = 'lblTestsCount2'
    Visible = False
  end
  object lblTestsCount: TLabel
    Left = 40
    Top = 368
    Width = 64
    Height = 13
    Caption = 'lblTestsCount'
  end
  object lblStudent: TLabel
    Left = 568
    Top = 48
    Width = 47
    Height = 13
    Caption = 'lblStudent'
  end
  object btnExit: TButton
    Left = 936
    Top = 675
    Width = 81
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 0
    OnClick = btnExitClick
  end
  object sgStudents: TStringGrid
    Left = 8
    Top = 544
    Width = 289
    Height = 65
    ColCount = 7
    Ctl3D = True
    DefaultColWidth = 100
    DefaultRowHeight = 20
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goThumbTracking]
    ParentCtl3D = False
    TabOrder = 1
    OnSelectCell = sgStudentsSelectCell
    OnSetEditText = sgStudentsSetEditText
  end
  object btnAddNewStudent: TButton
    Left = 16
    Top = 664
    Width = 97
    Height = 25
    Caption = #1053#1086#1074#1099#1081' '#1089#1090#1091#1076#1077#1085#1090
    TabOrder = 2
    OnClick = btnAddNewStudentClick
  end
  object btnDeleteSelected: TButton
    Left = 208
    Top = 664
    Width = 97
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 3
    OnClick = btnDeleteSelectedClick
  end
  object btnSaveModify: TButton
    Left = 112
    Top = 664
    Width = 97
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1089#1077
    TabOrder = 4
    OnClick = btnSaveModifyClick
  end
  object cbEditMode: TCheckBox
    Left = 304
    Top = 664
    Width = 113
    Height = 25
    Caption = #1088#1077#1078#1080#1084' '#1088#1077#1076#1072#1082#1090#1086#1088#1072
    Enabled = False
    TabOrder = 5
    OnClick = cbEditModeClick
  end
  object sgPlans: TStringGrid
    Left = 640
    Top = 496
    Width = 217
    Height = 129
    DefaultRowHeight = 20
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    TabOrder = 6
    OnExit = sgPlansExit
    OnGetEditText = sgPlansGetEditText
    OnSetEditText = sgPlansSetEditText
  end
  object btnNewPlan: TButton
    Left = 440
    Top = 648
    Width = 97
    Height = 25
    Caption = #1053#1086#1074#1099#1081' '#1087#1083#1072#1085
    TabOrder = 7
    OnClick = btnNewPlanClick
  end
  object btnSaveModifyPlans: TButton
    Left = 520
    Top = 656
    Width = 97
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1089#1077
    TabOrder = 8
    OnClick = btnSaveModifyPlansClick
  end
  object btnDeletePlan: TButton
    Left = 608
    Top = 648
    Width = 97
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1083#1072#1085
    TabOrder = 9
    OnClick = btnDeletePlanClick
  end
  object cbEditMode2: TCheckBox
    Left = 680
    Top = 640
    Width = 113
    Height = 25
    Caption = #1088#1077#1078#1080#1084' '#1088#1077#1076#1072#1082#1090#1086#1088#1072
    TabOrder = 10
    OnClick = cbEditMode2Click
  end
  object btnChooseTest: TButton
    Left = 768
    Top = 648
    Width = 97
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100' '#1090#1077#1089#1090
    TabOrder = 11
    OnClick = btnChooseTestClick
  end
  object sgTests2: TStringGrid
    Left = 816
    Top = 480
    Width = 169
    Height = 89
    ColCount = 2
    DefaultRowHeight = 20
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 12
    Visible = False
    OnDblClick = sgTests2DblClick
    RowHeights = (
      20
      20)
  end
  object leTestSubject: TLabeledEdit
    Left = 8
    Top = 104
    Width = 161
    Height = 21
    EditLabel.Width = 48
    EditLabel.Height = 13
    EditLabel.Caption = #1055#1088#1077#1076#1084#1077#1090':'
    TabOrder = 14
    OnExit = leTestSubjectExit
  end
  object leTestTeacher: TLabeledEdit
    Left = 176
    Top = 104
    Width = 225
    Height = 21
    EditLabel.Width = 82
    EditLabel.Height = 13
    EditLabel.Caption = #1055#1088#1077#1087#1086#1076#1072#1074#1072#1090#1077#1083#1100':'
    TabOrder = 15
    OnExit = leTestTeacherExit
  end
  object leTimeTest: TLabeledEdit
    Left = 296
    Top = 64
    Width = 105
    Height = 21
    EditLabel.Width = 105
    EditLabel.Height = 13
    EditLabel.Caption = #1042#1088#1077#1084#1103' '#1085#1072' '#1090#1077#1089#1090' ('#1084#1080#1085'):'
    TabOrder = 16
    OnChange = leTimeTestChange
    OnExit = leTimeTestExit
  end
  object gbQuestion: TGroupBox
    Left = 8
    Top = 128
    Width = 393
    Height = 217
    Enabled = False
    TabOrder = 17
    object lblQuestion: TLabel
      Left = 8
      Top = 16
      Width = 52
      Height = 13
      Caption = 'lblQuestion'
    end
    object memQuestion: TMemo
      Left = 8
      Top = 40
      Width = 377
      Height = 81
      TabOrder = 0
      OnExit = memQuestionExit
    end
    object btnDelQ: TButton
      Left = 320
      Top = 8
      Width = 65
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 6
      OnClick = btnDelQClick
    end
    object btnNextQ: TButton
      Left = 232
      Top = 8
      Width = 89
      Height = 25
      Caption = #1057#1083#1077#1076#1091#1102#1097#1080#1081' -->'
      TabOrder = 5
      OnClick = btnNextQClick
    end
    object btnPrevQ: TButton
      Left = 136
      Top = 8
      Width = 97
      Height = 25
      Caption = '<-- '#1055#1088#1077#1076#1099#1076#1091#1097#1080#1081
      TabOrder = 4
      OnClick = btnPrevQClick
    end
    object leAsks: TLabeledEdit
      Left = 8
      Top = 144
      Width = 377
      Height = 21
      EditLabel.Width = 249
      EditLabel.Height = 13
      EditLabel.Caption = #1042#1072#1088#1080#1072#1085#1090#1099' '#1086#1090#1074#1077#1090#1086#1074' ('#1082' '#1087#1088#1080#1084#1077#1088#1091': "'#1088#1099#1073#1072';'#1086#1088#1077#1083';'#1082#1080#1090';"):'
      TabOrder = 1
      OnExit = leAsksExit
    end
    object leTrueAsks: TLabeledEdit
      Left = 8
      Top = 184
      Width = 249
      Height = 21
      EditLabel.Width = 201
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1088#1072#1074#1080#1083#1100#1085#1099#1077' '#1086#1074#1090#1077#1090#1099' ('#1082' '#1087#1088#1080#1084#1077#1088#1091': "1;3;"):'
      TabOrder = 2
      OnExit = leTrueAsksExit
    end
    object leQTime: TLabeledEdit
      Left = 264
      Top = 184
      Width = 121
      Height = 21
      EditLabel.Width = 119
      EditLabel.Height = 13
      EditLabel.Caption = #1042#1088#1077#1084#1103' '#1085#1072' '#1074#1086#1087#1088#1086#1089' ('#1084#1080#1085'):'
      TabOrder = 3
      OnChange = leQTimeChange
      OnExit = leQTimeExit
    end
  end
  object btnNewTest: TButton
    Left = 24
    Top = 408
    Width = 89
    Height = 25
    Caption = #1053#1086#1074#1099#1081' '#1090#1077#1089#1090
    TabOrder = 18
    OnClick = btnNewTestClick
  end
  object btnOpenTest: TButton
    Left = 112
    Top = 408
    Width = 89
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1090#1077#1089#1090
    TabOrder = 19
    OnClick = btnOpenTestClick
  end
  object btnDeleteTest: TButton
    Left = 192
    Top = 408
    Width = 89
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1090#1077#1089#1090
    TabOrder = 20
    OnClick = btnDeleteTestClick
  end
  object sgTest: TStringGrid
    Left = 416
    Top = 168
    Width = 129
    Height = 89
    DefaultColWidth = 20
    DefaultRowHeight = 20
    TabOrder = 21
    Visible = False
  end
  object sgTests: TStringGrid
    Left = 416
    Top = 272
    Width = 129
    Height = 89
    ColCount = 2
    DefaultColWidth = 50
    DefaultRowHeight = 20
    RowCount = 20
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 22
    Visible = False
    OnDblClick = sgTestsDblClick
  end
  object btnCancel: TButton
    Left = 24
    Top = 392
    Width = 89
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 23
    Visible = False
    OnClick = btnCancelClick
  end
  object leTestName: TLabeledEdit
    Left = 8
    Top = 64
    Width = 281
    Height = 21
    EditLabel.Width = 84
    EditLabel.Height = 13
    EditLabel.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1077#1089#1090#1072':'
    TabOrder = 13
    OnExit = leTestNameExit
  end
  object sgResults: TStringGrid
    Left = 600
    Top = 96
    Width = 249
    Height = 177
    DefaultRowHeight = 20
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 24
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 1017
    Height = 29
    ButtonHeight = 25
    ButtonWidth = 25
    Caption = 'ToolBar'
    EdgeBorders = [ebLeft, ebRight, ebBottom]
    TabOrder = 25
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      Caption = 'ToolButton1'
      ImageIndex = 0
    end
    object ToolButton2: TToolButton
      Left = 25
      Top = 2
      Caption = 'ToolButton2'
      ImageIndex = 1
    end
  end
  object ibdb: TIBDatabase
    DatabaseName = '\\\'
    Params.Strings = (
      'user_name=sysdba')
    DefaultTransaction = IBTransaction
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    OnLogin = ibdbLogin
    Left = 904
    Top = 40
  end
  object ibq: TIBQuery
    Database = ibdb
    Transaction = IBTransaction
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'select * from  students')
    UniDirectional = True
    Left = 968
    Top = 16
  end
  object IBTransaction: TIBTransaction
    Active = False
    DefaultDatabase = ibdb
    AutoStopAction = saNone
    Left = 936
    Top = 40
  end
  object XPManifest: TXPManifest
    Left = 992
    Top = 16
  end
  object ibq2: TIBQuery
    Database = ibdb
    Transaction = IBTransaction
    BufferChunks = 1000
    CachedUpdates = False
    UniDirectional = True
    Left = 972
    Top = 43
  end
end
