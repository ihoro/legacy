uses ROW;
var
 W,nam,famil:string;
begin
a;
nam:='';
famil:='';
SetGround;
StatusLine('X','��室');
StatusLine('A','�����');
StatusLine('D','�����');
ReturnCursor;
Mouse_On;
repeat
W:=ButtonOptions;
 if W='��室' then begin EnterOptions('��室');halt end;
What:=MousePush;
 if (What='�����') or (W='�����') then
BEGIN
EnterOptions('�����');
Window(25,5,30,12,'�����');
WindowText(5,2,'������ ᢮� �����:');
WindowButton(10,9,10,1,'Ok');
WindowInputLine(3,5,20,'�������:',famil);
WindowInputLine(3,7,10,'���:',nam);
ReturnCursor;
REPEAT
repeat
What:=MousePush;
until What<>'';
 if (What='�������:') or (What='���:') then
  begin
   if What='�������:' then InputLineOn('�������:');
   if What='���:' then InputLineOn('���:');
   repeat
    if NILine='�������:' then InputWhat(famil);
    if NILine='���:' then InputWhat(nam);
    What:='';
    What:=MousePush;
    if (What='�������:') and (NILine<>'�������:') then InputLineOn('�������:');
    if (What='���:') and (NILine<>'���:') then InputLineOn('���:');
   until (What='Ok') or (What='CloseWindow');
  end;
UNTIL (What='Ok') or (What='CloseWindow');
END;

 if (What='�����') or (W='�����') then
BEGIN
EnterOptions('�����');
Window(25,5,30,12,'�����');
if (nam='') and (famil='') then
begin
WindowText(3,6,'� � ��� ��祣� �� ����!');
end;
if (nam<>'') and (famil='') then
begin
WindowText(3,4,'��� ����� '+nam);
WindowText(3,6,'���� 䠬���� � �� ����!');
end;
if (nam='') and (famil<>'') then
begin
WindowText(3,4,'��� 䠬���� '+famil);
WindowText(3,6,'��� ��� � �� ����!');
end;
WindowButton(10,9,10,1,'Ok');
ReturnCursor;
repeat
What:=MousePush;
until (What='Ok') or (What='CloseWindow')
END;

 if What='CloseWindow' then CloseWindow;
 if What='Ok' then begin PushButton('Ok');CloseWindow end;
until What='��室';
EnterOptions('��室');
Mouse_Off
end.