uses Crt,Graph;
const dddd = 80;
var x,y,d,g,f:integer;
    h:char;
procedure i;
begin
 for f:= 1 to 10 do
 begin
   setcolor(0);
   rectangle(x+1-f,y+1-f,x+f,y+f);
   Delay(dddd);
   setcolor(10);
   rectangle(x+1-f,y+1-f,x+f,y+f);
   Delay(dddd);
   setcolor(0);
   rectangle(x+1-f,y+1-f,x+f,y+f);
   Delay(dddd)
 end;
end;
procedure put(c:integer);
var k:integer;
begin
 if c=1 then k:=10
        else k:=0;
 putpixel(x,y,k);
 putpixel(x+1,y,k);
 putpixel(x,y+1,k);
 putpixel(x+1,y+1,k);
end;
begin
d:=detect;
InitGraph(d,g,'');
x:=40; y:=40;
put(1);
repeat
 h:=readkey;
 if h=#27 then halt;
 put(0);
 if h='j' then x:=x-5;
 if h='l' then x:=x+5;
 if h='i' then y:=y-5;
 if h='k' then y:=y+5;
 if h=' ' then i;
put(1);
until (x=-1) or (x=640) or (y=-1) or (y=480);
end.
