uses dos;
var god,mes,den,den_ned,chas,min,sec,sotki:word;
    ok:char;
begin
 getdate(god,mes,den,den_ned);
 writeln('сегодня  ',den,'.',mes,' ',god,' года');
 gettime(chas,min,sec,sotki);
 writeln(' сейчас ',chas,' час. ',min,' мин. и ',sec,' сек.');
 writeln('введите год,месяц и день:');
 readln(god,mes,den);
 writeln('введите часы,минуты,секунды и сотые доли секунды:');
 readln(chas,min,sec,sotki);
 writeln('Установить это время?(1-да,2-нет)');
 readln(ok);
 if not (ok='1') then begin writeln('Тогда выходим!'); halt end;
 writeln('Устанавливаю время и дату!');
 setdate(god,mes,den);
 settime(chas,min,sec,sotki);
 writeln('Установка закончена!');
 readln
end.