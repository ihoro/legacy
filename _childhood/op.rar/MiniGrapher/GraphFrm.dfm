object GraphForm: TGraphForm
  Left = 195
  Top = 108
  Width = 393
  Height = 306
  Caption = 'GraphForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Menu = mmGraph
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 385
    Height = 25
    Caption = 'ToolBar1'
    EdgeBorders = [ebTop, ebBottom]
    TabOrder = 0
  end
  object mmGraph: TMainMenu
    Images = MainForm.ImageList
    Left = 152
    Top = 80
    object mmiFile: TMenuItem
      Caption = '&Файл'
      object N1: TMenuItem
        Caption = '-'
      end
      object N2: TMenuItem
        Caption = 'В&ыход'
      end
    end
  end
end
