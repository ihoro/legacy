unit picsize;

interface

uses
  Forms, Spin, Classes, Controls,
  StdCtrls;

type
  TSize = class(TForm)
    XEdit: TSpinEdit;
    YEdit: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    OkButton: TButton;
    CancelButton: TButton;
    procedure XEditExit(Sender: TObject);
    procedure YEditExit(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure XEditKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Size: TSize;

implementation

uses
  Main;

{$R *.DFM}

procedure TSize.XEditExit(Sender: TObject);
begin
with XEdit do
begin
if Text='' then Value:=MinValue;
if Value>MaxValue then Value:=MaxValue
end
end;

procedure TSize.YEditExit(Sender: TObject);
begin
with YEdit do
begin
if Text='' then Value:=MinValue;
if Value>MaxValue then Value:=MaxValue
end
end;

procedure TSize.OkButtonClick(Sender: TObject);
begin
SaveTemp;
Crossword.CrosswordX:=XEdit.Value;
Crossword.CrosswordY:=YEdit.Value;
ClearLeft;
Saved:=false;
Hide
end;

procedure TSize.CancelButtonClick(Sender: TObject);
begin
Hide
end;

procedure TSize.FormHide(Sender: TObject);
begin
Form1.Enabled:=true;
DrawEdit;
PutAllPoint
end;

procedure TSize.XEditKeyPress(Sender: TObject; var Key: Char);
begin
{if Key=#13 then
  begin
    SaveTemp;
    Crossword.CrosswordX:=XEdit.Value;
    Crossword.CrosswordY:=YEdit.Value;
    Saved:=false;
    Hide
  end;}
if Key=#27 then Hide
end;

end.
