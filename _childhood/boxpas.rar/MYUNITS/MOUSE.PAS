unit Mouse;
{Intr(<номер прерывания>,<переменная типа Registers>);
Для мыши прерывание номер $33.
Функции прерывания $33(не все):
$0 - инициализация мыши
$1 - включение курсора
$2 - выключение курсора
$3 - определение положения курсора
$4 - установка курсора
$5 - определение положения курсора при нажатии клавиши
$6 - -!!- -!!- -!!- при отпускании клавиши
$7 - задание диапазона движения мыши по горизонтали
$8 - -!!- -!!- -!!- по вертикали
$9 - задание формы курсора в графическом режиме
$A - -!!- -!!- -!!- в текстовом режиме
$10 - установка области исключения для курсора
}
Interface
uses WinDos;
{type
     TRegisters = record
                   case integer of
                     0:(AX,BX,CX,BP,SI,DI,DS,ES,Flags:word);
                     1:(AL,AH,BL,BH,CL,CH,DL,DH:byte)
                 end;}
var
    regs:TRegisters;
procedure InitMouse(var ButtonCount,ErrorCode:byte);
procedure MouseOn;
procedure MouseOff;
procedure GetMouseXY(var x,y:word;var LeftButton,RightButton,ThirdButton:boolean);
procedure SetMouseXY(x,y:word);
procedure GetMouseXYOnDown(var x,y:word;ButtonNumber:byte;var Count:byte;LB,RB,TB:boolean);
procedure GetMouseXYOnUp(var x,y:word;ButtonNumber:byte;var Count:byte;LB,RB,TB:boolean);
procedure SetXRange(xmin,xmax:word);
procedure SetYRange(ymin,ymax:word);
procedure SetExeptionRegion(x1,y1,x2,y2:word);
procedure SetCursorForm(xPointer,YPointer:ShortInt;Form:Pointer);

Implementation

procedure InitMouse(var ButtonCount,ErrorCode:byte);
begin
with regs do
  begin
    AX:=$0; {задан номер функции}
    Intr($33,regs); {вызвано прерывание}
    if AX=$FFFF then ErrorCode:=0  {Ok}
                else ErrorCode:=1; {Error}
    ButtonCount:=BX {код числа клавиш: 2 - 2 клавиши, 0 - больше или меньше чем 2,
                     3 - мышь системы Mouse Systems (3 клавиши)}
  end;
end;
procedure MouseOn;
begin
regs.AX:=$1;
Intr($33,regs)
end;
procedure MouseOff;
begin
regs.AX:=$2;
Intr($33,regs)
end;
procedure GetMouseXY(var x,y:word;var LeftButton,RightButton,ThirdButton:boolean);
var
    ButtonCode:byte;
begin
with regs do
  begin
    AX:=$3;
    Intr($33,regs);
    X:=CX;
    Y:=DX;
    ButtonCode:=BX; {получен код нажатых клавиш}
  end;
LeftButton:=(ButtonCode and 1)=1; {левая кнопка бит 0 в ButtonCode}
RightButton:=(ButtonCode and 2)=2;
ThirdButton:=(ButtonCode and 4)=4
end;
procedure SetMouseXY(x,y:word);
begin
with regs do
  begin
    AX:=$4;
    CX:=x;
    DX:=y;
    Intr($33,regs)
  end
end;
procedure GetMouseXYOnDown(var x,y:word;ButtonNumber:byte;var Count:byte;LB,RB,TB:boolean);
{Сщгте - число нажатий заданной клавиши после последнего вызова функции GetMouseXYOnDown}
var
    ButtonCode:Byte;
begin
with regs do
  begin
    AX:=$5;
    BX:=ButtonNumber; {задан номер клавиши}
    Intr($33,regs);
    ButtonCode:=AX;
    Count:=BX;
    x:=CX;
    y:=DX
  end;
LB:=(ButtonCode and 1)=1; {левая кнопка бит 0 в ButtonCode}
RB:=(ButtonCode and 2)=2;
TB:=(ButtonCode and 4)=4
end;
procedure GetMouseXYOnUp(var x,y:word;ButtonNumber:byte;var Count:byte;LB,RB,TB:boolean);
{Сщгте - число нажатий заданной клавиши после последнего вызова функции GetMouseXYOnDown}
var
    ButtonCode:Byte;
begin
with regs do
  begin
    AX:=$6;
    BX:=ButtonNumber; {задан номер клавиши}
    Intr($33,regs);
    ButtonCode:=AX;
    Count:=BX;
    x:=CX;
    y:=DX
  end;
LB:=(ButtonCode and 1)=1; {левая кнопка бит 0 в ButtonCode}
RB:=(ButtonCode and 2)=2;
TB:=(ButtonCode and 4)=4
end;
procedure SetXRange(xmin,xmax:word);
{устанавливает ограничение перемещения курсора мыши по горизонтали}
begin
with regs do
  begin
    AX:=$7;
    CX:=xmin;
    DX:=xmax;
    Intr($33,regs)
  end
end;
procedure SetYRange(ymin,ymax:word);
{устанавливает ограничение перемещения курсора мыши по вертикали}
begin
with regs do
  begin
    AX:=$8;
    CX:=ymin;
    DX:=ymax;
    Intr($33,regs)
  end
end;
procedure SetExeptionRegion(x1,y1,x2,y2:word);
{устанавливает прямоугольную область, в которой курсор не отображается}
begin
with regs do
  begin
    AX:=$10;
    CX:=x1; DX:=y1;
    SI:=x2; DI:=y2;
    Intr($33,regs);
  end
end;
procedure SetCursorForm(xPointer,YPointer:ShortInt;Form:Pointer);
{установка новой формы курсора(16x16) в графическом режиме.
type Cursor = array[0..31] of word;  0..15 - маска AND, 16..31 - маска XOR
var Form:^Cursor
xPointer,yPointer - координаты горячей точки}
begin
MouseOff;
with regs do
  begin
    AX:=$9;
    BX:=xPointer;
    CX:=yPointer;
    ES:=seg(Form^);
    DX:=ofs(Form^);
    Intr($33,regs)
  end;
MouseOn
end;

end.