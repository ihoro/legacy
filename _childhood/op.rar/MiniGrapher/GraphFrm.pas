unit GraphFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ToolWin, ComCtrls;

type
  TGraphForm = class(TForm)
    mmGraph: TMainMenu;
    mmiFile: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    ToolBar1: TToolBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GraphForm: TGraphForm;

implementation

{$R *.DFM}

end.
