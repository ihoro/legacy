uses Crt;
var
    Flag,o:Byte;
    h:Char;
    p:^Byte;
begin
o:=1;
writeln('Press any key...');
repeat
repeat
h:=' ';
if KeyPressed then h:=ReadKey;
if h=#27 then halt
until h<>' ';
clrscr;
p:=ptr(0,$0417);
Flag:=p^;
write('Left Shift: ');
if (Flag and 1)=1 then writeln('On')
                  else writeln('Off');
write('Right Shift: ');
if (Flag and 2)=2 then writeln('On')
                  else writeln('Off');
write('Ctrl: ');
if (Flag and 4)=4 then writeln('On')
                  else writeln('Off');
write('Alt: ');
if (Flag and 8)=8 then writeln('On')
                  else writeln('Off');
write('ScrollLock: ');
if (Flag and 16)=16 then writeln('On')
                    else writeln('Off');
write('NumLock: ');
if (Flag and 32)=32 then writeln('On')
                    else writeln('Off');
write('CapsLock: ');
if (Flag and 64)=64 then writeln('On')
                    else writeln('Off');
write('Insert: ');
if (Flag and 128)=128 then writeln('On')
                      else writeln('Off');
until o=0;
end.