var f: text ;
begin
assign(f,'text.txt ');
rewrite(f);
writeln(f,'OIV Company Ltd.');
writeln(f,'present...');
close(f)
end.