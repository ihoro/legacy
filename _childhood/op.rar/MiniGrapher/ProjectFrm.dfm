object ProjectForm: TProjectForm
  Left = 228
  Top = 107
  Width = 467
  Height = 348
  Caption = 'ProjectForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Menu = mmProject
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object sgSystem: TStringGrid
    Left = 109
    Top = 0
    Width = 348
    Height = 281
    BiDiMode = bdLeftToRight
    ColCount = 1
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 100
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing]
    ParentBiDiMode = False
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnTopLeftChanged = sgSystemTopLeftChanged
  end
  object tlbProject: TToolBar
    Left = 0
    Top = 0
    Width = 459
    Height = 26
    AutoSize = True
    Caption = 'tlbProject'
    EdgeBorders = [ebTop, ebBottom]
    Flat = True
    Images = MainForm.ImageList
    Indent = 5
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    object tbNew: TToolButton
      Left = 5
      Top = 0
      Hint = '����� ����'
      Caption = '&�����'
      ImageIndex = 6
      OnClick = tbNewClick
    end
    object tbOpen: TToolButton
      Left = 28
      Top = 0
      Hint = '������� ����'
      Caption = '&�������'
      ImageIndex = 7
    end
    object tbSave: TToolButton
      Left = 51
      Top = 0
      Hint = '��������� ����'
      Caption = '&���������'
      ImageIndex = 8
    end
    object ToolButton1: TToolButton
      Left = 74
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 9
      Style = tbsSeparator
    end
    object tbDeleteVir: TToolButton
      Left = 82
      Top = 0
      Hint = '�������'
      Caption = 'tbDeleteVir'
      ImageIndex = 0
      OnClick = tbDeleteVirClick
    end
    object tbAddVir: TToolButton
      Left = 105
      Top = 0
      Hint = '����������'
      Caption = 'tbAddVir'
      ImageIndex = 1
      OnClick = tbAddVirClick
    end
    object tbInsertVir: TToolButton
      Left = 128
      Top = 0
      Hint = '��������'
      Caption = 'tbInsertVir'
      ImageIndex = 2
      OnClick = tbInsertVirClick
    end
    object ToolButton7: TToolButton
      Left = 151
      Top = 0
      Width = 8
      Caption = 'ToolButton7'
      ImageIndex = 24
      Style = tbsSeparator
    end
    object tbEditVir: TToolButton
      Left = 159
      Top = 0
      Hint = '�������������'
      Caption = 'tbEditVir'
      ImageIndex = 26
      OnClick = tbEditVirClick
    end
    object tbCons: TToolButton
      Left = 182
      Top = 0
      Hint = '���������'
      Caption = 'tbCons'
      ImageIndex = 34
      OnClick = tbConsClick
    end
    object tbGraph: TToolButton
      Left = 205
      Top = 0
      Hint = '������'
      Caption = 'tbGraph'
      ImageIndex = 35
      OnClick = tbGraphClick
    end
    object ToolButton3: TToolButton
      Left = 228
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 28
      Style = tbsSeparator
    end
    object tbSys1: TToolButton
      Left = 236
      Top = 0
      Hint = '�������'
      Caption = '&�������'
      ImageIndex = 31
      OnClick = tbSys1Click
    end
    object tbSys2: TToolButton
      Left = 259
      Top = 0
      Hint = '������������'
      Caption = '�&�����������'
      ImageIndex = 32
      OnClick = tbSys2Click
    end
    object tbSysDel: TToolButton
      Left = 282
      Top = 0
      Hint = '�������'
      Caption = '&�������'
      ImageIndex = 33
      OnClick = tbSysDelClick
    end
    object ToolButton9: TToolButton
      Left = 305
      Top = 0
      Width = 8
      Caption = 'ToolButton9'
      ImageIndex = 34
      Style = tbsSeparator
    end
    object ToolButton2: TToolButton
      Left = 313
      Top = 0
      Action = MainForm.WindowCascade
    end
    object ToolButton4: TToolButton
      Left = 336
      Top = 0
      Action = MainForm.WindowTileHorizontal
    end
    object ToolButton5: TToolButton
      Left = 359
      Top = 0
      Action = MainForm.WindowTileVertical
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 282
    Width = 459
    Height = 20
    Panels = <>
    SimplePanel = False
  end
  object mmProject: TMainMenu
    Images = MainForm.ImageList
    Left = 256
    Top = 144
    object mmiFile: TMenuItem
      Caption = '&����'
      object mmiNew: TMenuItem
        Caption = '&�����'
        Hint = '����� ����'
        ImageIndex = 6
        ShortCut = 16462
      end
      object mmiOpen: TMenuItem
        Caption = '&�������'
        Hint = '������� ����'
        ImageIndex = 7
        ShortCut = 16463
      end
      object mmiClose: TMenuItem
        Caption = '&�������'
      end
      object mmiSave: TMenuItem
        Caption = '&���������'
        Hint = '��������� ����'
        ImageIndex = 8
        ShortCut = 16467
      end
      object mmiSaveAs: TMenuItem
        Caption = '��������� &���...'
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object mmiExitProg: TMenuItem
        Caption = '�&����'
      end
    end
    object mmiVir: TMenuItem
      Caption = '&�����������'
      GroupIndex = 1
      object mmiDeleteVir: TMenuItem
        Caption = '&�������'
        ImageIndex = 0
        ShortCut = 16472
        OnClick = mmiDeleteVirClick
      end
      object mmiAddVir: TMenuItem
        Caption = '��&��������'
        ImageIndex = 1
        ShortCut = 16451
        OnClick = mmiAddVirClick
      end
      object mmiInsertVir: TMenuItem
        Caption = '&��������'
        ImageIndex = 2
        ShortCut = 16470
        OnClick = mmiInsertVirClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mmiEditVir: TMenuItem
        Caption = '&�������������'
        ImageIndex = 26
        ShortCut = 16453
        OnClick = mmiEditVirClick
      end
      object mmiCons: TMenuItem
        Caption = '&���������'
        ImageIndex = 34
        ShortCut = 16449
        OnClick = mmiConsClick
      end
      object mmiGraph: TMenuItem
        Caption = '&������'
        ImageIndex = 35
        ShortCut = 16455
        OnClick = mmiGraphClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mmiSys1: TMenuItem
        Caption = '&�������'
        ImageIndex = 31
        OnClick = mmiSys1Click
      end
      object mmiSys2: TMenuItem
        Caption = '�&�����������'
        ImageIndex = 32
        OnClick = mmiSys2Click
      end
      object mmiSysDel: TMenuItem
        Caption = '�&������'
        ImageIndex = 33
        OnClick = mmiSysDelClick
      end
    end
  end
end
