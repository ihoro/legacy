unit stepeni;
Interface
function stepen(a:real; n:word):real;
Implementation
function stepen;
 var step :real;
     i    :word;
 begin
   step:=1;
   for i:=1 to n do step:=step*a;
   stepen:=step
 end;
begin
end.