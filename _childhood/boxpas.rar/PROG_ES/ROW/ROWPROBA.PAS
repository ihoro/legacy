uses ROW;
var
 W,nam,famil:string;
begin
inna;
nam:='';
famil:='';
SetGround;
StatusLine('X','Выход');
StatusLine('A','Анкета');
StatusLine('D','Данные');
ReturnCursor;
Mouse_On;
repeat
W:=ButtonOptions;
 if W='Выход' then begin EnterOptions('Выход');halt end;
What:=MousePush;
 if (What='Анкета') or (W='Анкета') then
BEGIN
EnterOptions('Анкета');
Window(25,5,30,12,'Анкета');
WindowText(5,2,'Введите свои данные:');
WindowButton(10,9,10,1,'Ok');
WindowInputLine(3,5,20,'Фамилия:',famil);
WindowInputLine(3,7,10,'Имя:',nam);
ReturnCursor;
REPEAT
repeat
What:=MousePush;
until What<>'';
 if (What='Фамилия:') or (What='Имя:') then
  begin
   if What='Фамилия:' then InputLineOn('Фамилия:');
   if What='Имя:' then InputLineOn('Имя:');
   repeat
    if NILine='Фамилия:' then InputWhat(famil);
    if NILine='Имя:' then InputWhat(nam);
    What:='';
    What:=MousePush;
    if (What='Фамилия:') and (NILine<>'Фамилия:') then InputLineOn('Фамилия:');
    if (What='Имя:') and (NILine<>'Имя:') then InputLineOn('Имя:');
   until (What='Ok') or (What='CloseWindow');
  end;
UNTIL (What='Ok') or (What='CloseWindow');
END;

 if (What='Данные') or (W='Данные') then
BEGIN
EnterOptions('Данные');
Window(25,5,30,12,'Данные');
if (nam='') and (famil='') then
begin
WindowText(3,6,'Я о вас ничего не знаю!');
end;
if (nam<>'') and (famil='') then
begin
WindowText(3,4,'Вас зовут '+nam);
WindowText(3,6,'Вашу фамилию я не знаю!');
end;
if (nam='') and (famil<>'') then
begin
WindowText(3,4,'Ваша фамилия '+famil);
WindowText(3,6,'Ваше имя я не знаю!');
end;
WindowButton(10,9,10,1,'Ok');
ReturnCursor;
repeat
What:=MousePush;
until (What='Ok') or (What='CloseWindow')
END;

 if What='CloseWindow' then CloseWindow;
 if What='Ok' then begin PushButton('Ok');CloseWindow end;
until What='Выход';
EnterOptions('Выход');
Mouse_Off
end.