program M_Olymp83_1;
var
   B:array[1..10] of Boolean;
   c,d,f,l:integer;
begin
writeln;
for f:=1 to 9 do B[f]:=false;
B[10]:=true;
for f:=512 to 1023 do
  begin
    write(f,' - ');
    if f<>512 then
      for l:=1 to 9 do
        if not B[l] then
          begin
            B[l]:=true;
            l:=9
          end
                    else
          B[l]:=false;
    for l:=10 downto 1 do
      if B[l] then write('1')
              else write('0');
    write('  >>>  ');
    for l:=1 to 10 do
      if B[l] then write('1')
              else write('0');
    d:=1;
    c:=0;
    for l:=10 downto 1 do
      begin
        if B[l] then c:=c+d;
        d:=d+d
      end;
    write(' - ',c,'      Press <Enter>...');
    readln
  end;
end.