unit About;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    Image1: TImage;
    Bevel1: TBevel;
    lblMail: TLabel;
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Execute;
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

uses main;

{$R *.DFM}

procedure TAboutBox.Execute;
begin
  Form1.Enabled:=false;
  ShowModal;
  Form1.Enabled:=true
end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
  Close
end;

end.

