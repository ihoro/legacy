var k:text;
begin
 assign(k,'LPT1');
 rewrite(k);
 writeln(k,'Hello World...');
 close(k)
end.