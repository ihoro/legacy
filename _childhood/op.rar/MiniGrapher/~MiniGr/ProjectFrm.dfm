object ProjectForm: TProjectForm
  Left = 216
  Top = 105
  Width = 397
  Height = 295
  Caption = 'ProjectForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlSystem: TPanel
    Left = 0
    Top = 0
    Width = 109
    Height = 268
    Align = alLeft
    BevelOuter = bvNone
    Color = clSilver
    TabOrder = 0
  end
  object sgSystem: TStringGrid
    Left = 109
    Top = 0
    Width = 280
    Height = 268
    Align = alClient
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
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
