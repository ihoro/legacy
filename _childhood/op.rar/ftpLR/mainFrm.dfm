object Main: TMain
  Left = 192
  Top = 115
  Width = 711
  Height = 487
  Caption = 'FTP Logs Reader v1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 457
    Top = 28
    Height = 385
    Color = clBtnFace
    Constraints.MinWidth = 3
    MinSize = 3
    ParentColor = False
  end
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 703
    Height = 28
    ButtonWidth = 22
    Caption = 'ToolBar'
    TabOrder = 0
    object sep2: TToolButton
      Left = 0
      Top = 2
      Width = 6
      Caption = 'sep2'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object Load: TToolButton
      Left = 6
      Top = 2
      Caption = 'Load log file...'
      MenuItem = mmiLoad
    end
  end
  object lwFiles: TListView
    Left = 460
    Top = 28
    Width = 243
    Height = 385
    Align = alClient
    Columns = <
      item
        Caption = '#'
        Width = 30
      end
      item
        AutoSize = True
        Caption = 'File Name'
        WidthType = (
          -6)
      end
      item
        Caption = 'Size'
        Width = 45
      end
      item
        Caption = 'D/U'
        Width = 25
      end
      item
        AutoSize = True
        Caption = 'Av. Speed'
        WidthType = (
          -5)
      end
      item
        Caption = 'Path'
        Width = 100
      end
      item
        Caption = 'Error Message'
      end>
    HideSelection = False
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = lwFilesColumnClick
    OnSelectItem = lwFilesSelectItem
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 413
    Width = 703
    Height = 20
    Panels = <
      item
        Width = 110
      end>
  end
  object lwTime: TListView
    Left = 0
    Top = 28
    Width = 457
    Height = 385
    Align = alLeft
    Columns = <
      item
        Caption = 'ID'
        Width = 40
      end
      item
        Caption = 'IP'
        Width = 65
      end
      item
        Caption = 'Host Name'
        Width = 65
      end
      item
        Caption = 'Open Time'
        Width = 110
      end
      item
        Caption = 'Close Time'
        Width = 110
      end
      item
        Caption = 'Timed Out'
        Width = 20
      end
      item
        Caption = 'Work Time'
        Width = 80
      end
      item
        Caption = 'User Name'
      end
      item
        Caption = 'Password'
      end
      item
        Caption = 'Files'
      end>
    HideSelection = False
    RowSelect = True
    TabOrder = 3
    ViewStyle = vsReport
    OnColumnClick = lwTimeColumnClick
    OnSelectItem = lwTimeSelectItem
  end
  object MainMenu: TMainMenu
    Left = 672
    Top = 8
    object mmiFile: TMenuItem
      Caption = 'File'
      object mmiLoad: TMenuItem
        Caption = 'Load log file...'
        ShortCut = 16460
        OnClick = mmiLoadClick
      end
      object sep3: TMenuItem
        Caption = '-'
      end
      object mmiOptions: TMenuItem
        Caption = 'Options'
      end
      object sep1: TMenuItem
        Caption = '-'
      end
      object mmiExit: TMenuItem
        Caption = 'Exit'
        OnClick = mmiExitClick
      end
    end
    object Settings1: TMenuItem
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'All Files|*.*'
    Options = [ofHideReadOnly, ofShowHelp, ofPathMustExist, ofEnableSizing, ofDontAddToRecent]
    Left = 640
    Top = 8
  end
end
