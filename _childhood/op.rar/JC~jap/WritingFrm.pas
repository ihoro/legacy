unit WritingFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls;

type
  TWriting = class(TForm)
    Animate1: TAnimate;
    Bevel1: TBevel;
    Label1: TLabel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Start;
    { Public declarations }
  end;

var
  Writing: TWriting;

implementation

uses main;

{$R *.DFM}

procedure TWriting.Start;
begin
  Form1.Enabled:=false;
  Show
end;

procedure TWriting.Timer1Timer(Sender: TObject);
begin
  Form1.Enabled:=true;
  Hide
end;

procedure TWriting.FormShow(Sender: TObject);
begin
  Timer1.Enabled:=true;
  Animate1.Active:=true
end;

procedure TWriting.FormHide(Sender: TObject);
begin
  Timer1.Enabled:=false;
  Animate1.Active:=false
end;

end.
