unit FileOpenFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ComCtrls;

type
  TFileOpenForm = class(TForm)
    ListView1: TListView;
    TreeView1: TTreeView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FileOpenForm: TFileOpenForm;

implementation

{$R *.DFM}

end.
