unit Mouse;
{Intr(<����� ���뢠���>,<��६����� ⨯� Registers>);
��� ��� ���뢠��� ����� $33.
�㭪樨 ���뢠��� $33(�� ��):
$0 - ���樠������ ���
$1 - ����祭�� �����
$2 - �몫�祭�� �����
$3 - ��।������ ��������� �����
$4 - ��⠭���� �����
$5 - ��।������ ��������� ����� �� ����⨨ ������
$6 - -!!- -!!- -!!- �� ���᪠��� ������
$7 - ������� ��������� �������� ��� �� ��ਧ��⠫�
$8 - -!!- -!!- -!!- �� ���⨪���
$9 - ������� ��� ����� � ����᪮� ०���
$A - -!!- -!!- -!!- � ⥪�⮢�� ०���
$10 - ��⠭���� ������ �᪫�祭�� ��� �����
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
    AX:=$0; {����� ����� �㭪樨}
    Intr($33,regs); {�맢��� ���뢠���}
    if AX=$FFFF then ErrorCode:=0  {Ok}
                else ErrorCode:=1; {Error}
    ButtonCount:=BX {��� �᫠ ������: 2 - 2 ������, 0 - ����� ��� ����� 祬 2,
                     3 - ���� ��⥬� Mouse Systems (3 ������)}
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
    ButtonCode:=BX; {����祭 ��� ������� ������}
  end;
LeftButton:=(ButtonCode and 1)=1; {����� ������ ��� 0 � ButtonCode}
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
{��� - �᫮ ����⨩ �������� ������ ��᫥ ��᫥����� �맮�� �㭪樨 GetMouseXYOnDown}
var
    ButtonCode:Byte;
begin
with regs do
  begin
    AX:=$5;
    BX:=ButtonNumber; {����� ����� ������}
    Intr($33,regs);
    ButtonCode:=AX;
    Count:=BX;
    x:=CX;
    y:=DX
  end;
LB:=(ButtonCode and 1)=1; {����� ������ ��� 0 � ButtonCode}
RB:=(ButtonCode and 2)=2;
TB:=(ButtonCode and 4)=4
end;
procedure GetMouseXYOnUp(var x,y:word;ButtonNumber:byte;var Count:byte;LB,RB,TB:boolean);
{��� - �᫮ ����⨩ �������� ������ ��᫥ ��᫥����� �맮�� �㭪樨 GetMouseXYOnDown}
var
    ButtonCode:Byte;
begin
with regs do
  begin
    AX:=$6;
    BX:=ButtonNumber; {����� ����� ������}
    Intr($33,regs);
    ButtonCode:=AX;
    Count:=BX;
    x:=CX;
    y:=DX
  end;
LB:=(ButtonCode and 1)=1; {����� ������ ��� 0 � ButtonCode}
RB:=(ButtonCode and 2)=2;
TB:=(ButtonCode and 4)=4
end;
procedure SetXRange(xmin,xmax:word);
{��⠭�������� ��࠭�祭�� ��६�饭�� ����� ��� �� ��ਧ��⠫�}
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
{��⠭�������� ��࠭�祭�� ��६�饭�� ����� ��� �� ���⨪���}
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
{��⠭�������� ��אַ㣮���� �������, � ���ன ����� �� �⮡ࠦ�����}
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
{��⠭���� ����� ��� �����(16x16) � ����᪮� ०���.
type Cursor = array[0..31] of word;  0..15 - ��᪠ AND, 16..31 - ��᪠ XOR
var Form:^Cursor
xPointer,yPointer - ���न���� ����祩 �窨}
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