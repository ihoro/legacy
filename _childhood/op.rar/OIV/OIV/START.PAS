unit start;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, mmsystem;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  AllTime:LongInt = 0;

implementation

{$R *.DFM}

procedure TForm1.Timer1Timer(Sender: TObject);
begin
inc(AllTime);
if AllTime=40 then halt
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
PlaySound('chimes.wav',0,snd_async)
end;

end.
