unit ConsFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids;

type
  TConsForm = class(TForm)
    sgCons: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    btnOK: TButton;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    FTotalC: Byte;
    { Public declarations }
  end;

var
  ConsForm: TConsForm;

implementation

uses
  Analyser;

{$R *.DFM}

{DONE: При выходе делать проверку названий и значений констант!}

procedure TConsForm.btnOKClick(Sender: TObject);
var
  f,l: Integer;
  s: string;
begin
  for f:=199 downto 0 do
    if (sgCons.Cells[0,f]<>'') or (sgCons.Cells[1,f]<>'') then
      begin
        FTotalC:=f+1;
        Break
      end;
  f:=0;
  repeat
    inc(f);
    if (sgCons.Cells[0,f-1]='') and (sgCons.Cells[1,f-1]='') then
      begin
        for l:=f-1 to FTotalC-1 do
          begin
            sgCons.Cells[0,l]:=sgCons.Cells[0,l+1];
            sgCons.Cells[1,l]:=sgCons.Cells[1,l+1]
          end;
        dec(FTotalC);
        dec(f)
      end
  until f>=FTotalC;
  for f:=0 to FTotalC-1 do
    begin
      if Length(sgCons.Cells[0,f])>MaxNameSize then
        begin
          MessageDlg('Название константы должно быть не больше '+IntToStr(MaxNameSize)+
            ' символов.',mtWarning,[mbOk],0);
          sgCons.Col:=0;
          sgCons.Row:=f;
          Exit
        end;
      if Length(sgCons.Cells[1,f])>MaxValueSize then
        begin
          MessageDlg('Значение константы должно быть не больше '+IntToStr(MaxValueSize)+
            ' символов.',mtWarning,[mbOk],0);
          sgCons.Col:=1;
          sgCons.Row:=f;
          Exit
        end;
    end;
  {DONE: Invalid Name or Value!..}
  {DONE: Нет значения или имени!...}
  {DONE: Имя константы совпадает с именем стандартной функции!...}
  for f:=0 to FTotalC-1 do
    begin
      for l:=1 to TotalSimpleFunc+1 do
        if DefaultFunc[l]=sgCons.Cells[0,f] then
          begin
            MessageDlg('Это зарезервированное название функции.',mtWarning,[mbOK],0);
            sgCons.Col:=0;
            sgCons.Row:=f;
            Exit
          end;
      if (sgCons.Cells[0,f]<>'') and (sgCons.Cells[1,f]='') then
        begin
          MessageDlg('Не найдено значение константы.',mtWarning,[mbOK],0);
          sgCons.Col:=1;
          sgCons.Row:=f;
          Exit
        end;
      if (sgCons.Cells[0,f]='') and (sgCons.Cells[1,f]<>'') then
        begin
          MessageDlg('Не найдено имя константы.',mtWarning,[mbOK],0);
          sgCons.Col:=0;
          sgCons.Row:=f;
          Exit
        end;
      for l:=1 to Length(sgCons.Cells[0,f]) do
        if l=1 then
          begin
            if not (UpCase(sgCons.Cells[0,f][l]) in NameOfCons1) then
              begin
                MessageDlg('Ошибка в имени константы.',mtWarning,[mbOk],0);
                sgCons.Col:=0;
                sgCons.Row:=f;
                Exit
              end
          end
               else
          if not (UpCase(sgCons.Cells[0,f][l]) in NameOfCons1+NameOfCons2) then
            begin
              MessageDlg('Ошибка в имени константы.',mtWarning,[mbOk],0);
              sgCons.Col:=0;
              sgCons.Row:=f;
              Exit
            end;
      try
        s:=sgCons.Cells[1,f];
        for l:=1 to Length(s) do
          if s[l]='.' then s[l]:=',';
        sgCons.Cells[1,f]:=s;  
        StrToFloat(s)
      except
        MessageDlg('Ошибка в значении константы.',mtWarning,[mbOk],0);
        sgCons.Col:=1;
        sgCons.Row:=f;
        Exit
      end
    end;
  Close
end;

end.
