uses Dos;
var
    regs:Registers;
    h:Char;
    ScanCode:Boolean;
    s:Byte;
begin
with regs do
begin
repeat
ScanCode:=false;
al:=0;
Intr($16,regs);
s:=al;
if s=0 then
  begin
    ScanCode:=true;
    s:=ah
  end;
if not ScanCode and (s=27) then halt;
until ScanCode and (s=118);
writeln('Вы нажали Ctrl+PgDown');
end
end.