unit AboutFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TGradientXAbout = class(TForm)
    CtlImage: TSpeedButton;
    NameLbl: TLabel;
    OkBtn: TButton;
    CopyrightLbl: TLabel;
    DescLbl: TLabel;
    Label1: TLabel;
  end;

procedure ShowGradientXAbout;

implementation

{$R *.DFM}

procedure ShowGradientXAbout;
begin
  with TGradientXAbout.Create(nil) do
    try
      ShowModal;
    finally
      Free
    end
end;

end.
