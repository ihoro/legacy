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
  object pcTabs: TPageControl
    Left = 0
    Top = 0
    Width = 793
    Height = 507
    ActivePage = tsStudents
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    OnChange = pcTabsChange
    object tsStudents: TTabSheet
      Caption = #1057#1090#1091#1076#1077#1085#1090#1099
      object lblCountStudents: TLabel
        Left = 8
        Top = 431
        Width = 80
        Height = 13
        Caption = 'lblCountStudents'
      end
      object sgStudents: TStringGrid
        Left = 0
        Top = 0
        Width = 785
        Height = 425
        ColCount = 7
        Ctl3D = True
        DefaultColWidth = 100
        DefaultRowHeight = 20
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goThumbTracking]
        ParentCtl3D = False
        TabOrder = 0
        OnSelectCell = sgStudentsSelectCell
        OnSetEditText = sgStudentsSetEditText
      end
      object btnAddNewStudent: TButton
        Left = 8
        Top = 448
        Width = 97
        Height = 25
        Caption = #1053#1086#1074#1099#1081' '#1089#1090#1091#1076#1077#1085#1090
        TabOrder = 1
        OnClick = btnAddNewStudentClick
      end
      object btnDeleteSelected: TButton
        Left = 216
        Top = 448
        Width = 97
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 3
        OnClick = btnDeleteSelectedClick
      end
      object btnSaveModify: TButton
        Left = 112
        Top = 448
        Width = 97
        Height = 25
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1089#1077
        TabOrder = 2
        OnClick = btnSaveModifyClick
      end
      object cbEditMode: TCheckBox
        Left = 320
        Top = 448
        Width = 113
        Height = 25
        Caption = #1088#1077#1078#1080#1084' '#1088#1077#1076#1072#1082#1090#1086#1088#1072
        Enabled = False
        TabOrder = 4
        OnClick = cbEditModeClick
      end
    end
    object tsPlan: TTabSheet
      Caption = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090
      ImageIndex = 1
      object lblCountPlans: TLabel
        Left = 8
        Top = 431
        Width = 64
        Height = 13
        Caption = 'lblCountPlans'
      end
      object lblTestsCount2: TLabel
        Left = 16
        Top = 448
        Width = 70
        Height = 13
        Caption = 'lblTestsCount2'
        Visible = False
      end
      object sgPlans: TStringGrid
        Left = 0
        Top = 0
        Width = 729
        Height = 417
        DefaultRowHeight = 20
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
        TabOrder = 0
        OnExit = sgPlansExit
        OnGetEditText = sgPlansGetEditText
        OnSetEditText = sgPlansSetEditText
      end
      object btnNewPlan: TButton
        Left = 8
        Top = 448
        Width = 97
        Height = 25
        Caption = #1053#1086#1074#1099#1081' '#1087#1083#1072#1085
        TabOrder = 1
        OnClick = btnNewPlanClick
      end
      object btnSaveModifyPlans: TButton
        Left = 112
        Top = 448
        Width = 97
        Height = 25
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1089#1077
        TabOrder = 2
        OnClick = btnSaveModifyPlansClick
      end
      object btnDeletePlan: TButton
        Left = 216
        Top = 448
        Width = 97
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1083#1072#1085
        TabOrder = 3
        OnClick = btnDeletePlanClick
      end
      object cbEditMode2: TCheckBox
        Left = 320
        Top = 448
        Width = 113
        Height = 25
        Caption = #1088#1077#1078#1080#1084' '#1088#1077#1076#1072#1082#1090#1086#1088#1072
        TabOrder = 4
        OnClick = cbEditMode2Click
      end
      object btnChooseTest: TButton
        Left = 432
        Top = 448
        Width = 97
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100' '#1090#1077#1089#1090
        TabOrder = 5
        OnClick = btnChooseTestClick
      end
      object sgTests2: TStringGrid
        Left = 0
        Top = 0
        Width = 729
        Height = 425
        ColCount = 2
        DefaultRowHeight = 20
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 6
        Visible = False
        OnDblClick = sgTests2DblClick
      end
    end
    object tsTest: TTabSheet
      Caption = #1058#1077#1089#1090#1099
      ImageIndex = 2
      object lblTestsCount: TLabel
        Left = 24
        Top = 304
        Width = 64
        Height = 13
        Caption = 'lblTestsCount'
      end
      object leTestName: TLabeledEdit
        Left = 8
        Top = 16
        Width = 281
        Height = 21
        EditLabel.Width = 84
        EditLabel.Height = 13
        EditLabel.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1077#1089#1090#1072':'
        TabOrder = 0
        OnExit = leTestNameExit
      end
      object leTestSubject: TLabeledEdit
        Left = 8
        Top = 56
        Width = 161
        Height = 21
        EditLabel.Width = 48
        EditLabel.Height = 13
        EditLabel.Caption = #1055#1088#1077#1076#1084#1077#1090':'
        TabOrder = 2
        OnExit = leTestSubjectExit
      end
      object leTestTeacher: TLabeledEdit
        Left = 176
        Top = 56
        Width = 225
        Height = 21
        EditLabel.Width = 82
        EditLabel.Height = 13
        EditLabel.Caption = #1055#1088#1077#1087#1086#1076#1072#1074#1072#1090#1077#1083#1100':'
        TabOrder = 3
        OnExit = leTestTeacherExit
      end
      object leTimeTest: TLabeledEdit
        Left = 296
        Top = 16
        Width = 105
        Height = 21
        EditLabel.Width = 105
        EditLabel.Height = 13
        EditLabel.Caption = #1042#1088#1077#1084#1103' '#1085#1072' '#1090#1077#1089#1090' ('#1084#1080#1085'):'
        TabOrder = 1
        OnChange = leTimeTestChange
        OnExit = leTimeTestExit
      end
      object gbQuestion: TGroupBox
        Left = 8
        Top = 80
        Width = 393
        Height = 217
        Enabled = False
        TabOrder = 4
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
        Left = 56
        Top = 328
        Width = 89
        Height = 25
        Caption = #1053#1086#1074#1099#1081' '#1090#1077#1089#1090
        TabOrder = 5
        OnClick = btnNewTestClick
      end
      object btnOpenTest: TButton
        Left = 160
        Top = 328
        Width = 89
        Height = 25
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1090#1077#1089#1090
        TabOrder = 6
        OnClick = btnOpenTestClick
      end
      object btnDeleteTest: TButton
        Left = 264
        Top = 328
        Width = 89
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100' '#1090#1077#1089#1090
        TabOrder = 7
        OnClick = btnDeleteTestClick
      end
      object sgTest: TStringGrid
        Left = 408
        Top = 0
        Width = 129
        Height = 89
        DefaultColWidth = 20
        DefaultRowHeight = 20
        TabOrder = 9
        Visible = False
      end
      object sgTests: TStringGrid
        Left = 8
        Top = 0
        Width = 393
        Height = 297
        ColCount = 2
        DefaultColWidth = 50
        DefaultRowHeight = 20
        RowCount = 20
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 8
        Visible = False
        OnDblClick = sgTestsDblClick
      end
      object btnCancel: TButton
        Left = 56
        Top = 328
        Width = 89
        Height = 25
        Caption = #1054#1090#1084#1077#1085#1072
        TabOrder = 10
        Visible = False
        OnClick = btnCancelClick
      end
    end
    object tsResults: TTabSheet
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090#1099
      ImageIndex = 3
      object lblStudent: TLabel
        Left = 0
        Top = 0
        Width = 47
        Height = 13
        Caption = 'lblStudent'
      end
      object sgResults: TStringGrid
        Left = 0
        Top = 24
        Width = 785
        Height = 401
        DefaultRowHeight = 20
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        TabOrder = 0
      end
    end
  end
  object btnExit: TButton
    Left = 704
    Top = 475
    Width = 81
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 1
    OnClick = btnExitClick
  end
  object ibdb: TIBDatabase
    DatabaseName = ':'
    DefaultTransaction = IBTransaction
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    OnLogin = ibdbLogin
    Left = 576
    Top = 472
  end
  object ibq: TIBQuery
    Database = ibdb
    Transaction = IBTransaction
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'select * from  students')
    UniDirectional = True
    Left = 640
    Top = 472
  end
  object IBTransaction: TIBTransaction
    Active = False
    DefaultDatabase = ibdb
    AutoStopAction = saNone
    Left = 608
    Top = 472
  end
  object XPManifest: TXPManifest
    Left = 672
    Top = 472
  end
  object ibq2: TIBQuery
    Database = ibdb
    Transaction = IBTransaction
    BufferChunks = 1000
    CachedUpdates = False
    UniDirectional = True
    Left = 644
    Top = 443
  end
end
