program text;
uses Crt,Graph;
var gun,r,t,no,f,d,g:integer;b,h:char;
procedure gun1(x,y,k:integer);
          begin
             setcolor(k);
             line(x+6,y+1,x+14,y+1);
             line(x+7,y+2,x+12,y+2);
             putpixel(x+11,y,k);
             putpixel(x+7,y+4,k)
          end;
procedure gun2(x,y,k:integer);
          begin
             setcolor(k);
             line(x-7,y-2,x+18,y-2);
             line(x-7,y-1,x+18,y-1);
             line(x-1,y,x+14,y);
             line(x-1,y,x+11,y);
             line(x+7,y+3,x+9,y+1);
             putpixel(x+7,y+4,k);
             line(x+7,y+1,x+8,y+1);
             putpixel(x+16,y-3,k);
             putpixel(x+17,y-4,k);
             putpixel(x+16,y-5,k);
             putpixel(x+15,y-4,k)
          end;
procedure guno(gu,c:integer);
       begin
         if gu=1 then gun1(r,t,c);
         if gu=2 then gun2(r,t,c)
       end;
procedure od(x,y:integer);
   var j,f,c:integer;
        begin
        c:= trunc(random(14)+1);
        for f:= 1 to y do begin
                          setcolor(c);
                         putpixel(x,f,c);
                     for j:=1 to 200 do begin setcolor(0)  end;
                          putpixel(x,f,0)
                          end;
        setcolor(c);
        putpixel(x,y,c)
        end;
procedure fox(a,b,y1:integer);
        var fi:integer;
        begin
        for fi:= a to b do od(fi,y1)
        end;
procedure foy(a,b,x1:integer);
        var fu:integer;
        begin
        for fu:= a downto b do od(x1,fu)
        end;
procedure oddworld;
    begin
    od(317,300);
    foy(299,294,300);
    od(330,299);
    foy(299,294,340);
    fox(312,313,300);
    fox(323,325,300);
    fox(307,308,300);
    foy(300,293,333);
    fox(301,303,300);
    fox(307,308,293);
    od(319,300);
    foy(299,294,326);
    foy(299,294,314);
    od(331,300);
    fox(338,339,300);
    od(329,298);
    fox(301,303,293);
    foy(299,298,318);
    foy(300,293,328);
    fox(334,335,300);
    foy(299,293,316);
    foy(299,294,304);
    fox(312,313,293);
    fox(323,325,293);
    foy(299,294,309);
    foy(296,294,331);
    fox(338,339,293);
    foy(300,293,306);
    foy(299,294,322);
    foy(300,293,311);
    fox(329,330,297);
    foy(300,293,337);
    fox(329,330,293);
    foy(299,293,320);
    {left,right}
     fox(121,122,395);
     foy(400,389,132);
     foy(400,387,100);
     fox(113,116,400);
     fox(121,124,389);
     foy(389,387,128);
     fox(102,107,400);
     fox(113,116,394);
     foy(400,387,101);
     fox(129,135,387);
     foy(400,387,119);
     foy(400,387,111);
     foy(400,398,108);
     fox(113,116,387);
     foy(389,387,136);
     fox(121,124,387);
     foy(400,387,112);
     foy(400,387,120);
     foy(391,387,125);
     settextstyle(4,0,1);
     outtextxy(142,380,'- o');outtextxy(100,410,'Right - p')
    end;
procedure oiv;
BEGIN
SetBKColor(7);
SetColor(10);
    circle(320,240,150);
    line(220,340,420,340);
    line(220,140,420,140);
    line(310,340,310,141);
    line(330,340,330,140);
    setfillstyle(1,10);
    circle(320,115,20);
    floodfill(320,115,10);
    line(320,355,170,90);
    line(170,90,85,90);
    line(85,90,300,380);
    line(300,380,335,380);
    line(335,380,510,140);
    line(510,140,470,140);
    line(470,140,320,355);
    line(510,140,550,90);
    line(550,90,420,90);
    line(420,90,345,215);
    line(345,215,445,215);
    line(445,215,170,390);
    line(170,390,190,340);
    line(190,340,100,440);
    line(100,440,220,400);
    line(220,400,180,400);
    line(180,400,510,190);
    line(510,190,390,190);
    line(390,190,470,140);
    floodfill(320,240,10);
    floodfill(329,339,10);
    setfillstyle(1,9);
    floodfill(170,140,10);
    floodfill(220,240,10);
    floodfill(295,318,10);
    floodfill(295,339,10);
    floodfill(320,365,10);
    floodfill(370,315,10);
    floodfill(442,216,10);
    floodfill(420,240,10);
    floodfill(445,181,10);
    floodfill(475,141,10);
    floodfill(470,191,10);
    setfillstyle(1,5);
    floodfill(470,91,10);
    floodfill(420,139,10);
    floodfill(474,191,10);
    floodfill(467,215,10);
    floodfill(360,280,10);
    floodfill(320,305,10);floodfill(309,305,10);
    floodfill(270,341,10);floodfill(265,339,10);
    floodfill(170,391,10);
    settextstyle(2,0,10);setcolor(9);outtextxy(200,440,'Company Ltd.');
    settextstyle(4,0,1);setcolor(1);outtextxy(100,1,'Press any key...');
 b:= ReadKey ; ClearDevice;setBkcolor(0);
 END;
   procedure alien(x,y,c1,c2,c3,c4:integer);
             begin
             setcolor(c1); setfillstyle(1,c1);
             line(x+1,y-9,x+7,y-9);
             line(x-3,y-8,x+9,y-8);
             line(x,y-7,x+6,y-7);
             line(x+9,y-7,x+10,y-7);
             line(x+2,y-6,x+11,y-6);
             line(x+4,y-5,x+8,y-5);
             putpixel( x+9 , y-4,c1 );
             rectangle(x+5,y-4,x+6,y-3);
             line(x+4,y-2,x+5,y-2);
             line(x+3,y-1,x+4,y-1);
             rectangle(x,y,x+4,y+6);
             floodfill(x+1,y+1,c1);
             line(x-1,y+1,x-1,y+5);
             line(x+1,y+7,x+3,y+7);
             setcolor(c2);
             line(x+7,y-7,x+8,y-7);
             setcolor(c3);
             rectangle(x+2,y+1,x+3,y+4);
             putpixel(x+1,y+2,c2);
             line(x+1,y+3,x+8,y+3);
             line(x+4,y+4,x+5,y+4);
             guno(gun,c4)
         end;
procedure no1(x,y,c:integer);
             begin
             setcolor(c);
             line(x+1,y+8,x+1,y+9);
             line(x+2,y+10,x+2,y+14);
             line(x+1,y+13,x+1,y+14);
             putpixel(x+3,y+14,c);
             putpixel(x+4,y+8,c);
             line(x+5,y+9,x+5,y+14);
             line(x+6,y+13,x+6,y+14);
             putpixel(x+7,y+14,c)
             end;
procedure no2(x,y,c:integer);
             begin
             setcolor(c);
             putpixel(x+1,y+8,c);
             putpixel(x+3,y+8,c);
             line(x+2,y+9,x+2,y+14);
             line(x+3,y+11,x+3,y+14);
             line(x+4,y+9,x+4,y+10);
             line(x+4,y+13,x+4,y+14);
             putpixel(x+5,y+14,c)
             end;
procedure no3(x,y,c:integer);
             begin
             setcolor(c);
             putpixel(x+2,y+8,c);
             line(x+3,y+8,x+3,y+10);
             line(x+2,y+11,x+2,y+13);
             line(x+1,y+14,x+6,y+14);
             line(x+4,y+10,x+4,y+13);
             putpixel(x+1,y+13,c);
             putpixel(x+5,y+13,c)
             end;
procedure no4(x,y,c:integer);
             begin
             setcolor(c);
             putpixel(x+1,y+8,c);
             line(x+4,y+8,x+4,y+9);
             line(x+2,y+9,x+2,y+11);
             rectangle(x,y+13,x+1,y+14);
             putpixel(x+1,y+12,c);
             putpixel(x+2,y+14,c);
             putpixel(x+5,y+10,c);
             line(x+6,y+11,x+6,y+14);
             line(x+7,y+13,x+7,y+14);
             putpixel(x+8,y+14,c)
             end;
procedure no5(x,y,c:integer);
             begin
             setcolor(c);
             line(x+1,y+8,x+1,y+9);
             putpixel(x+4,y+8,c);
             line(x+2,y+10,x+2,y+11);
             line(x+5,y+9,x+5,y+10);
             rectangle(x,y+13,x+1,y+14);
             putpixel(x+1,y+12,c);
             putpixel(x+2,y+14,c);
             line(x+6,y+11,x+6,y+14);
             line(x+7,y+13,x+7,y+14);
             putpixel(x+8,y+14,c)
             end;
procedure ifi(nom,c:integer);
          var q:integer;
             begin
             if c=1 then q:=9 else q:=0;
             if nom=6 then begin nom:=1;no:=1 end;
             if nom=1 then no1(r,t,q);
             if nom=2 then no2(r,t,q);
             if nom=3 then no3(r,t,q);
             if nom=4 then no4(r,t,q);
             if nom=5 then no5(r,t,q)
             end;
procedure fire1(x,y:integer);
          var l,f,a,b:integer;
          begin
          alien(r,t,10,8,9,13);ifi(no,1);
          a:=0 ;
          for f:= (x+16) to 600 do begin
                                   a:=a+1;setcolor(14);
                                   if a=3 then a:=1;
                                   circle(f,y+1,a);
                 for l:=1 to 700 do begin setcolor(0) end;
                                   circle(f,y+1,a)
                                   end;
          end;
procedure fire2(x,y:integer);
          var a,b,f:integer;l:word;
          begin
          alien(r,t,10,8,9,13);
          ifi(no,1);
          for f:= 1 to 100 do begin
                              a:=trunc(random(6)+x+19);
                              b:=trunc(random(5)+y-4);
                              putpixel(a,b,7);
                           for l:=1 to 60000 do begin end;
                              putpixel(a,b,0)
                              end;
          for f:= (x+24) to 600 do begin
                                   a:=trunc(random(4)+f-4);
                                   b:=trunc(random(3)+y-2);
                                   setcolor(9);
                               line(f,y-1,f+6,y-1);
                               line(f+4,y-2,f+4,y);
                               setcolor(12);
                               line(a-1,b,a,b);
                          for l:= 1 to 60000 do begin end;
                                   setcolor(0);
                               line(f,y-1,f+6,y-1);
                               line(f+4,y-2,f+4,y);
                               line(a-1,b,a,b)
                                   end;
         end;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then begin writeln('инициализация не закончена!');
   halt end;
oiv;
oddworld;
  no:=0;
   r:=20;
    t:=240;
     gun:=1;
     setcolor(6); line(0,255,640,255);
 for f:= 1 to 10000 do begin
    repeat
    h:= ReadKey ;
    until ( (h='z') or (h='o') or (h='p') or (h=' ')  );
     alien(r,t,0,0,0,0);
     ifi(no,0);

    if h='p' then begin  r:=r+1; no:=no+1 end;
    if h='o' then begin  r:=r-1; no:=no+1 end;
    if (h=' ') and (gun=1) then fire1(r,t);
    if (h=' ') and (gun=2) then fire2(r,t);
    if h='z' then begin gun:=gun+1;if gun=3 then gun:=1 end;
           if r>360 then r:=360;
                      alien(r,t,10,8,9,13);
                      ifi(no,1);
                      end;
CloseGraph;
end.