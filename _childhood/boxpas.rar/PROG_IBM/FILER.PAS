var f: text ; h,j: string;
begin
assign(f,'text.txt ');
reset(f);
{readln(f,h);}
seek(f,20);
readln(f,j);
close(f) ;
writeln(h,'  ',j);
readln
end.