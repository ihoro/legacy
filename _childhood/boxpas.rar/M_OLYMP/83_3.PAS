program Labirint_Olymp83_3;
uses Crt, Dos;
type hod=0..4;
     labi=0..1;
var a:array[1..40,1..40] of word;
    b:array[1..40,1..40] of labi;
    d:array[1..1600] of hod;
    k,h:word;
    f,l,m,n,x,y,xx,yy:byte;
    lab:text;
procedure Tochka;
begin
a[x,y]:=h;
h:=h+1;
end;
procedure Move;
begin
if a[x-1,y]=0 then begin x:=x-1;tochka;d[h]:=1;exit end;
if a[x,y-1]=0 then begin y:=y-1;tochka;d[h]:=2;exit end;
if a[x+1,y]=0 then begin x:=x+1;tochka;d[h]:=3;exit end;
if a[x,y+1]=0 then begin y:=y+1;tochka;d[h]:=4;exit end;
a[x,y]:=1;
case d[h] of
1:x:=x+1;
2:y:=y+1;
3:x:=x-1;
4:y:=y-1;
end;
h:=h-1
end;
procedure mov;
begin
for l:=1 to n do
  for f:=1 to m do if a[f,l]=k then exit;
end;

begin
textbackground(0);
ClrScr;
Assign(lab,'labirint');
Reset(lab);
readln(lab,m);
readln(lab,n);
readln(lab,x);
readln(lab,y);
for l:=1 to n do
  for f:=1 to m do readln(lab,b[f,l]);
Close(lab);
xx:=x;yy:=y;
for l:=1 to n do
  for f:=1 to m do a[f,l]:=b[f,l];
d[2]:=0;
h:=2;
Tochka;
while (x<>1) and (x<>m) and (y<>1) and (y<>n) do Move;
textcolor(1);textbackground(14);
for l:=1 to n do
  for f:=1 to m do
    begin
      gotoxy(f*2-1,l);
      if b[f,l]=1 then write('лл')
                  else write('  ')
    end;
textcolor(10);
for k:=2 to h do
  begin
    mov;
    gotoxy(f*2-1,l);
    write('лл');
    Delay(96);
  end;
repeat
until KeyPressed
end.