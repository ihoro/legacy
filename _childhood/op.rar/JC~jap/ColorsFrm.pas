unit ColorsFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TAColors = array[1..6] of TColor;
  
  TColors = class(TForm)
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    cdColors: TColorDialog;
    cbThing: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure FormShow(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cbThingChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FColors: TAColors;
    FOk: Boolean;
    { Private declarations }
  public
    function Execute(var AColors: TAColors): Boolean;
    { Public declarations }
  end;

var
  Colors: TColors;

implementation

{$R *.DFM}

uses
  Main;

function TColors.Execute(var AColors: TAColors): Boolean;
begin
  FColors:=AColors;
  ShowModal;
  AColors:=FColors;
  Result:=FOk
end;

procedure TColors.FormShow(Sender: TObject);
begin
  FOk:=false;
  cbThing.ItemIndex:=0;
  Panel1.Color:=FColors[cbThing.ItemIndex+1]
end;

procedure TColors.Panel1Click(Sender: TObject);
begin
  cdColors.Color:=FColors[cbThing.ItemIndex+1];
  if cdColors.Execute then
    FColors[cbThing.ItemIndex+1]:=cdColors.Color;
  Panel1.Color:=FColors[cbThing.ItemIndex+1]
end;

procedure TColors.btnOkClick(Sender: TObject);
begin
  FOk:=true;
  Close
end;

procedure TColors.btnCancelClick(Sender: TObject);
begin
  FOk:=false;
  Close
end;

procedure TColors.cbThingChange(Sender: TObject);
begin
  Panel1.Color:=FColors[cbThing.ItemIndex+1]
end;

procedure TColors.Button3Click(Sender: TObject);
begin
  cdColors.Color:=FColors[cbThing.ItemIndex+1];
  if cdColors.Execute then
    FColors[cbThing.ItemIndex+1]:=cdColors.Color;
  Panel1.Color:=FColors[cbThing.ItemIndex+1]
end;

procedure TColors.Button1Click(Sender: TObject);
begin
  case cbThing.ItemIndex+1 of
    1:FColors[cbThing.ItemIndex+1]:=StandartTitle;
    2:FColors[cbThing.ItemIndex+1]:=StandartPoint;
    3:FColors[cbThing.ItemIndex+1]:=StandartClear;
    4:FColors[cbThing.ItemIndex+1]:=StandartFonFigures;
    5:FColors[cbThing.ItemIndex+1]:=StandartFon2Figures;
    6:FColors[cbThing.ItemIndex+1]:=StandartFigures
  end;
  Panel1.Color:=FColors[cbThing.ItemIndex+1]
end;

procedure TColors.Button2Click(Sender: TObject);
begin
  FColors[1]:=StandartTitle;
  FColors[2]:=StandartPoint;
  FColors[3]:=StandartClear;
  FColors[4]:=StandartFonFigures;
  FColors[5]:=StandartFon2Figures;
  FColors[6]:=StandartFigures;
  Panel1.Color:=FColors[cbThing.ItemIndex+1]
end;

end.
