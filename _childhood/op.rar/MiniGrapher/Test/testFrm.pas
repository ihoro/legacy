unit testFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Spin, StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    sp1: TSpinEdit;
    sp2: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure sp1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  Analyser;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Edit2.Text:=Constants[1].Name;
  Edit3.Text:=Constants[1].Value
end;

procedure TForm1.sp1Change(Sender: TObject);
begin
  Edit2.Text:=Constants[sp1.Value].Name;
  Edit3.Text:=Constants[sp1.Value].Value;
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  Constants[sp1.Value].Name:=Edit2.Text
end;

procedure TForm1.Edit3Change(Sender: TObject);
begin
  Constants[sp1.Value].Value:=Edit3.Text
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  s: string;
begin
  TotalConsts:=sp2.Value;
  s:=Edit1.Text;
  if IsItRight(s,false) then
    Edit1.Text:='True'
                        else
    Edit1.Text:='False'                    
end;

end.
