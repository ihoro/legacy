unit ReadFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TRead = class(TForm)
    btnStop: TButton;
    procedure btnStopClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Read: TRead;

implementation

uses
  MainFrm;

{$R *.dfm}

procedure TRead.btnStopClick(Sender: TObject);
begin
  StopFlag:=true;
  if DoneFlag then
    DoneFlag:=false;
  Hide;
  Main.Show
end;

procedure TRead.FormShow(Sender: TObject);
begin
  Main.ReadLogFile
end;

end.
