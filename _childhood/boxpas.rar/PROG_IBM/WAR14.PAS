program text;
uses Crt,Graph;
label start;
type
    dim=array[1..300] of integer;
var
    r,t,no,f,d,g,rr,tt,days,zol,nomer,
    war,knop,vid,number,den           :integer;
    b,h         :char;
    go,faza,zdanie,x,y,flag,fx,fy,all,
    energy,tip,xxx,yyy,xx,yy,gox,goy,goxx,goyy,going,goins,obhod,first      :dim;
    day :string;
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
 b:= ReadKey ; ClearDevice;setBkcolor(6);
 END;
procedure warrior1(nom,x,y,c:integer);
  var c1,c2,c3,c4:integer;
    begin
         if c<>0 then
                     begin
                       c1:=14;
                       c2:=146;
                       c3:=13;
                       c4:=1
                     end
                 else
                     begin
                       c1:=6;
                       c2:=6;
                       c3:=6;
                       c4:=6
                     end;
         if go[nom]=1 then
            BEGIN
                 setcolor(c1);
                 rectangle(x+7,y+7,x+12,y+8);
                 rectangle(x+8,y+6,x+11,y+9);
                 line(x+9,y+5,x+10,y+5);
                 setcolor(c2);
                 rectangle(x+5,y+8,x+6,y+11);
                 rectangle(x+4,y+9,x+7,y+10);
                 line(x+8,y+10,x+11,y+10);
                 rectangle(x+7,y+11,x+12,y+12);
                 line(x+17,y+5,x+17,y+8);
                 rectangle(x+13,y+8,x+14,y+11);
                 line(x+12,y+9,x+12,y+10);
                 setcolor(c3);
                 line(x+15,y+7,x+15,y+11);
                 line(x+16,y+5,x+16,y+12);

             if faza[nom]=1  then
               begin
                 setcolor(c2);
                 line(x+3,y+9,x+3,y+12);
                 line(x+2,y+10,x+2,y+13);
                 setcolor(c4);
                 rectangle(x+6,y+5,x+7,y+6);
                 putpixel(x+6,y+7,c4);
                 rectangle(x+12,y+13,x+13,y+14);
                 putpixel(x+13,y+12,c4)
               end;
             if (faza[nom]=2) or (faza[nom]=10) then
               begin
                 setcolor(c2);
                 rectangle(x+2,y+10,x+3,y+11);
                 putpixel(x+3,y+9,c2);
                 setcolor(c4);
                 line(x+6,y+6,x+6,y+7);
                 putpixel(x+7,y+6,c4);
                 line(x+13,y+12,x+13,y+13);
                 putpixel(x+12,y+13,c4)
               end;
             if (faza[nom]=3) or (faza[nom]=9) then
               begin
                 setcolor(c2);
                 rectangle(x+2,y+9,x+3,y+10);
                 putpixel(x+6,y+7,c4);
                 putpixel(x+13,y+12,c4)
               end;
             if (faza[nom]=4) or (faza[nom]=8) then
               begin
                 setcolor(c2);
                 rectangle(x+2,y+9,x+3,y+10);
                 putpixel(x+2,y+8,c2)
               end;
             if (faza[nom]=5) or (faza[nom]=7) then
               begin
                 setcolor(c2);
                 line(x+2,y+7,x+2,y+9);
                 line(x+3,y+9,x+3,y+10);
                 putpixel(x+6,y+12,c4);
                 putpixel(x+13,y+7,c4)
               end;
             if faza[nom]=6 then
               begin
                 setcolor(c2);
                 line(x+2,y+6,x+2,y+9);
                 line(x+3,y+8,x+3,y+10);
                 setcolor(c4);
                 rectangle(x+6,y+13,x+7,y+14);
                 putpixel(x+6,y+12,c4);
                 rectangle(x+12,y+5,x+13,y+6);
                 putpixel(x+13,y+7,c4)
               end;
         END;  {  go[nom]=1   }
    if go[nom]=2 then
         BEGIN
              setcolor(c1);
              rectangle(x+11,y+7,x+12,y+12);
              rectangle(x+10,y+8,x+13,y+11);
              line(x+14,y+9,x+14,y+10);
              setcolor(c2);
              rectangle(x+9,y+4,x+10,y+7);
              rectangle(x+8,y+5,x+11,y+6);
              rectangle(x+7,y+7,x+8,y+12);
              line(x+9,y+8,x+9,y+11);
              line(x+9,y+12,x+10,y+12);
              rectangle(x+8,y+13,x+11,y+14);
              line(x+11,y+17,x+14,y+17);
              setcolor(c3);
              line(x+8,y+15,x+12,y+15);
              line(x+7,y+16,x+14,y+16);
          if faza[nom]=1 then
            begin
              setcolor(c2);
              line(x+6,y+2,x+9,y+2);
              line(x+8,y+3,x+10,y+3);
              setcolor(c4);
              rectangle(x+13,y+6,x+14,y+7);
              rectangle(x+5,y+12,x+6,y+13);
              putpixel(x+12,y+6,c4);
              putpixel(x+7,y+13,c4)
            end;
          if (faza[nom]=2) or (faza[nom]=10) then
            begin
              setcolor(c2);
              rectangle(x+8,y+2,x+9,y+3);
              putpixel(x+10,y+3,c2);
              setcolor(c4);
              line(x+13,y+6,x+13,y+7);
              line(x+6,y+12,x+6,y+13);
              putpixel(x+7,y+13,c4);
              putpixel(x+12,y+6,c4)
            end;
          if (faza[nom]=3) or (faza[nom]=9) then
            begin
              setcolor(c2);
              rectangle(x+9,y+2,x+10,y+3);
              putpixel(x+12,y+6,c4);
              putpixel(x+7,y+13,c4)
            end;
          if (faza[nom]=4) or (faza[nom]=8) then
            begin
              setcolor(c2);
              rectangle(x+9,y+2,x+10,y+3);
              putpixel(x+11,y+2,c4)
            end;
          if (faza[nom]=5) or (faza[nom]=7) then
            begin
              setcolor(c2);
              line(x+10,y+2,x+12,y+2);
              line(x+9,y+3,x+10,y+3);
              putpixel(x+7,y+6,c4);
              putpixel(x+12,y+13,c4)
            end;
          if faza[nom]=6 then
            begin
              setcolor(c2);
              line(x+10,y+2,x+13,y+2);
              line(x+9,y+3,x+11,y+3);
              setcolor(c4);
              rectangle(x+5,y+6,x+6,y+7);
              rectangle(x+13,y+12,x+14,y+13);
              putpixel(x+7,y+6,c4);
              putpixel(x+12,y+13,c4)
            end;
        END; { go[nom]=2  }
     if go[nom]=3 then
        BEGIN
          setcolor(c1);
          rectangle(x+7,y+11,x+12,y+12);
          rectangle(x+8,y+10,x+11,y+13);
          line(x+9,y+14,x+10,y+14);
          setcolor(c2);
          rectangle(x+12,y+9,x+15,y+10);
          rectangle(x+13,y+8,x+14,y+11);
          rectangle(x+7,y+7,x+12,y+8);
          line(x+8,y+9,x+11,y+9);
          line(x+7,y+9,x+7,y+10);
          rectangle(x+5,y+8,x+6,y+11);
          line(x+2,y+11,x+2,y+14);
          setcolor(c3);
          line(x+3,y+7,x+3,y+14);
          line(x+4,y+8,x+4,y+12);
      if faza[nom]=1 then
        begin
          setcolor(c2);
          line(x+16,y+8,x+16,y+10);
          line(x+17,y+6,x+17,y+9);
          setcolor(c4);
          rectangle(x+6,y+5,x+7,y+6);
          putpixel(x+6,y+7,c4);
          rectangle(x+12,y+13,x+13,y+14);
          putpixel(x+13,y+12,c4)
        end;
      if (faza[nom]=2) or (faza[nom]=10) then
        begin
          setcolor(c2);
          rectangle(x+16,y+8,x+17,y+9);
          putpixel(x+16,y+10,c2);
          setcolor(c4);
          line(x+6,y+6,x+7,y+6);
          line(x+12,y+13,x+13,y+13);
          putpixel(x+6,y+7,c4);
          putpixel(x+13,y+12,c4)
        end;
      if (faza[nom]=3) or (faza[nom]=9) then
        begin
          setcolor(c2);
          rectangle(x+16,y+9,x+17,y+10);
          putpixel(x+13,y+12,c4);
          putpixel(x+6,y+7,c4)
        end;
      if (faza[nom]=4) or (faza[nom]=8) then
        begin
          setcolor(c2);
          rectangle(x+16,y+9,x+17,y+10);
          putpixel(x+17,y+11,c2)
        end;
      if (faza[nom]=5) or (faza[nom]=7) then
        begin
          setcolor(c2);
          line(x+16,y+9,x+16,y+10);
          line(x+17,y+10,x+17,y+12);
          putpixel(x+13,y+7,c4);
          putpixel(x+6,y+12,c4)
        end;
      if faza[nom]=6 then
        begin
          setcolor(c2);
          line(x+16,y+9,x+16,y+11);
          line(x+17,y+10,x+17,y+13);
          setcolor(c4);
          rectangle(x+12,y+5,x+13,y+6);
          rectangle(x+6,y+13,x+7,y+14);
          putpixel(x+13,y+7,c4);
          putpixel(x+6,y+12,c4)
        end;
      END;  { go[nom]=3  }
    if go[nom]=4 then
      BEGIN
          setcolor(c1);
          rectangle(x+6,y+8,x+9,y+11);
          rectangle(x+7,y+7,x+8,y+12);
          line(x+5,y+9,x+5,y+10);
          setcolor(c2);
          rectangle(x+8,y+13,x+11,y+14);
          rectangle(x+9,y+12,x+10,y+15);
          rectangle(x+11,y+7,x+12,y+12);
          line(x+10,y+8,x+10,y+11);
          line(x+9,y+7,x+10,y+7);
          rectangle(x+8,y+5,x+11,y+6);
          line(x+5,y+2,x+8,y+2);
          setcolor(c3);
          line(x+5,y+3,x+12,y+3);
          line(x+7,y+4,x+11,y+4);
      if faza[nom]=1 then
        begin
          setcolor(c2);
          line(x+9,y+16,x+11,y+16);
          line(x+10,y+17,x+13,y+17);
          setcolor(c4);
          rectangle(x+13,y+6,x+14,y+7);
          rectangle(x+5,y+12,x+6,y+13);
          putpixel(x+7,y+13,c4);
          putpixel(x+12,y+6,c4)
        end;
      if (faza[nom]=2) or (faza[nom]=10) then
        begin
          setcolor(c2);
          line(x+9,y+16,x+11,y+16);
          line(x+10,y+17,x+11,y+17);
          setcolor(c4);
          line(x+13,y+6,x+13,y+7);
          line(x+6,y+12,x+6,y+13);
          putpixel(x+12,y+6,c4);
          putpixel(x+7,y+13,c4)
        end;
      if (faza[nom]=3) or (faza[nom]=9) then
        begin
          setcolor(c2);
          rectangle(x+9,y+16,x+10,y+17);
          putpixel(x+12,y+6,c4);
          putpixel(x+7,y+13,c4)
        end;
      if (faza[nom]=4) or (faza[nom]=8) then
        begin
          setcolor(c2);
          rectangle(x+9,y+16,x+10,y+17);
          putpixel(x+8,y+17,c2)
        end;
      if (faza[nom]=5) or (faza[nom]=7) then
        begin
          setcolor(c2);
          line(x+9,y+16,x+10,y+16);
          line(x+7,y+17,x+9,y+17);
          putpixel(x+7,y+6,c4);
          putpixel(x+12,y+13,c4)
        end;
      if faza[nom]=6 then
        begin
          setcolor(c2);
          line(x+8,y+16,x+10,y+16);
          line(x+6,y+17,x+9,y+17);
          setcolor(c4);
          rectangle(x+5,y+6,x+6,y+7);
          rectangle(x+13,y+12,x+14,y+13);
          putpixel(x+12,y+13,c4);
          putpixel(x+7,y+6,c4)
        end;
        end;  { go[nom]=4  }
 end;  { procedure warrior1 }
procedure building(a,x,y:integer);
  begin
    if a=1 then
     begin
            setcolor(1);
            line(x+1,y+30,x+15,y+15);
            line(x+15,y+15,x+25,y+30);
            line(x+25,y+30,x+1,y+30);
            line(x+16,y+14,x+23,y+7);
            line(x+24,y+7,x+36,y+19);
            line(x+36,y+19,x+26,y+29);
            line(x+20,y+16,x+25,y+21);
            line(x+27,y+14,x+31,y+18);
            line(x+23,y+14,x+25,y+16);
            line(x+23,y+24,x+25,y+26);
            line(x+15,y+15,x+15,y+30);
            setfillstyle(1,2);
            floodfill(x+14,y+22,1);
            floodfill(x+16,y+22,1);
            floodfill(x+26,y+18,1);
            setcolor(12);
            line(x+9,y+24,x+13,y+24);
            putpixel(x+11,y+24,2);
            putpixel(x+10,y+23,13);
            putpixel(x+12,y+23,13);
            putpixel(x+11,y+25,13);
            setcolor(9);
            line(x+15,y+14,x+15,y+9);
            setcolor(11);
            line(x+33,y+27,x+35,y+25);
            line(x+36,y+25,x+38,y+27);
            line(x+37,y+28,x+36,y+29);
            line(x+35,y+29,x+34,y+28);
            line(x+33,y+28,x+33,y+29);
            line(x+38,y+28,x+38,y+33);
            line(x+37,y+34,x+36,y+35);
            putpixel(x+35,y+35,11);
            line(x+29,y+31,x+31,y+29);
            line(x+32,y+29,x+34,y+31);
            line(x+33,y+32,x+32,y+33);
            line(x+30,y+32,x+31,y+33);
            line(x+29,y+32,x+29,y+36);
            line(x+29,y+37,x+31,y+39);
            line(x+32,y+39,x+34,y+37);
            line(x+34,y+32,x+34,y+36);
            setfillstyle(1,9);
            floodfill(x+35,y+27,11);
            floodfill(x+36,y+31,11);
            floodfill(x+31,y+31,11);
            floodfill(x+31,y+35,11);
            rectangle(x+2,y+9,x+8,y+14);
            line(x+3,y+8,x+10,y+1);
            line(x+6,y+7,x+7,y+8);
            line(x+11,y+2,x+12,y+3);
            line(x+9,y+8,x+12,y+5);
            line(x+13,y+4,x+13,y+9);
            line(x+9,y+13,x+12,y+10);
            setfillstyle(1,5);
            floodfill(x+5,y+8,11);
            floodfill(x+9,y+5,11);
            floodfill(x+5,y+11,11);
            floodfill(x+10,y+9,11);
             setcolor(10);
             rectangle(x+16,y+9,x+18,y+11);
             putpixel(x+17,y+10,9);
             rectangle(x+19,y+10,x+20,y+12);
             rectangle(x+21,y+9,x+22,y+11)
          end;
    end;
procedure flags(a,x,y:integer);
  var f:integer;
    begin
    setcolor(9);
      if (flag[a]=1) or (flag[a]=5) then
          begin
             rectangle(x,y,x+2,y+2);
             putpixel(x+1,y+1,9);
             rectangle(x+3,y+1,x+4,y+3);
             rectangle(x+5,y,x+6,y+2)
           end;
      if (flag[a]=2) or (flag[a]=4) then
          begin
             rectangle(x,y,x+2,y+2);
             line(x+2,y+1,x+2,y+3);
             rectangle(x+3,y+2,x+4,y+4);
             line(x+5,y+1,x+5,y+3);
             line(x+6,y,x+6,y+2)
           end;
      if flag[a]=3 then
           begin
             line(x,y,x,y+2);
             line(x+1,y+1,x+1,y+3);
             line(x+2,y+2,x+2,y+4);
             rectangle(x+3,y+3,x+4,y+5);
             line(x+5,y+2,x+5,y+4);
             line(x+6,y+1,x+6,y+3)
           end;
      if (flag[a]=6) or (flag[a]=10) then
           begin
             rectangle(x,y,x+2,y+2);
             putpixel(x+1,y+1,9);
             rectangle(x+3,y-1,x+4,y+1);
             rectangle(x+5,y,x+6,y+2)
           end;
      if (flag[a]=7) or (flag[a]=9) then
           begin
             rectangle(x,y,x+1,y+2);
             line(x+2,y-1,x+2,y+1);
             rectangle(x+3,y-2,x+4,y);
             line(x+5,y-1,x+5,y+1);
             line(x+6,y,x+6,y+2)
           end;
     if flag[a]=8 then
           begin
             line(x,y,x,y+2);
             line(x+1,y-1,x+1,y+1);
             line(x+2,y-2,x+2,y);
             rectangle(x+3,y-3,x+4,y-1);
             line(x+5,y-2,x+5,y);
             line(x+6,y-1,x+6,y+1)
           end;
     flag[a]:=flag[a]+1;
     if flag[a]=11 then flag[a]:=1
  end;
procedure cel(a,x,y:integer);
  begin
    setcolor(a);
    line(x+7,y+1,x+12,y+1);
    line(x+4,y+2,x+6,y+2);
    line(x+3,y+3,x+5,y+5);
    line(x+2,y+4,x+2,y+6);
    line(x+1,y+7,x+1,y+12);
    line(x+2,y+13,x+2,y+15);
    line(x+3,y+16,x+5,y+14);
    line(x+4,y+17,x+6,y+17);
    line(x+7,y+18,x+12,y+18);
    line(x+13,y+17,x+15,y+17);
    line(x+16,y+16,x+14,y+14);
    line(x+17,y+15,x+17,y+13);
    line(x+18,y+12,x+18,y+7);
    line(x+17,y+6,x+17,y+4);
    line(x+16,y+3,x+14,y+5);
    line(x+13,y+2,x+15,y+2)
  end;
procedure so;
   begin
   for f:= 1 to 2 do
   begin
    sound(2000+f*1000);
    delay(200);
    nosound
   end;
     for f:= 1 to 1 do
   begin
    sound(2000+f*1000);
    delay(200);
    nosound
   end;
  end;
procedure iff;
 begin
    if (rr>=x[1]) and (rr<=x[1]+30) and (tt>=y[1]) and (tt<=y[1]+30) then
                 begin
                   setcolor(6);
                   for f:=1 to 40 do line(x[1],y[1]-1+f,x[1]+40,y[1]-1+f);
                 end;
    for f:=1 to all[1] do
      if (rr>=x[219+f]-10) and (rr<=x[219+f]+10) and (tt>=y[219+f]-10)
                     and  (tt<=y[219+f]+10) then
                     begin
                      nomer:=219+f;
                      setcolor(6);
                      for d:=1 to 20 do line(x[219+f],y[219+f]-1+d,x[219+f]+20,y[219+f]-1+d);
                     end;
 end;
procedure allwar;
 begin
    for f:= 1 to all[1] do warrior1(219+f,x[219+f],y[219+f],1);
 end;
procedure wind;
 begin
   setcolor(10);
   rectangle(480,0,639,479);
   setfillstyle(1,7);
   floodfill(490,20,10);
   line(480,30,640,30);
   line(480,50,640,50);
   settextstyle(4,0,1);
   setcolor(7);
   str(den,day);
   outtextxy(540,29,day);
   setcolor(9);
   outtextxy(490,29,'День: ');
   outtextxy(540,29,day);
   setcolor(146);
   outtextxy(500,10,'1000');
   settextstyle(2,0,5);
   setcolor(12);
   outtextxy(490,0,'золотых:');
   setcolor(13);
   rectangle(490,90,630,180);
   rectangle(489,89,631,181);
   setcolor(9);
   rectangle(509,369,611,471);
   rectangle(508,368,612,472);
   setfillstyle(1,6);
   floodfill(540,460,9);
   floodfill(540,110,13);
   for f:=0 to 1 do
   for d:=0 to 1 do
   putpixel(510+f+x[1] div 10,470-(48-y[1] div 10)+d,10);
   for f:= 1 to all[1] do
   putpixel(510+x[219+f] div 10,470-(48-y[219+f] div 10),10);
 {  putpixel(510+rr div 10,470-(48-tt div 10),6);
   putpixel(510+rr div 10,470-(48-tt div 10),15);}
    setcolor(1);
    outtextxy(520,195,'Энергия:');
    line(490,232,490,235);
    line(560,232,560,235);
    line(630,232,630,235);
            setcolor(1);
            settextstyle(2,0,5);
            outtextxy(520,250,'Действия:');
 end;
procedure steret;
 begin
   setcolor(7);
   for f:=1 to 30 do line(481,52+f,630,52+f);
   for f:=1 to 140 do line(489+f,220,489+f,230);
   for f:=1 to 90 do line(481,270+f,630,270+f);
   setcolor(6);
   for f:= 1 to 69 do line(491,110+f,629,110+f);
 end;
procedure goin(n:integer);
 begin
  warrior1(n,x[n],y[n],0);
  if number=n then  warrior1(n,540,125,0);
   putpixel(510+x[n] div 10,470-(48-y[n] div 10),6);
  if xxx[n]<>0 then
       begin
        if gox[n]=1 then
                  begin
                    x[n]:=x[n]-10;
                    faza[n]:=faza[n]+1;
                    if faza[n]=11 then faza[n]:=1;
                    go[n]:=4
                  end;
        if gox[n]=2 then
                  begin
                    x[n]:=x[n]+10;
                    faza[n]:=faza[n]+1;
                    if faza[n]=11 then faza[n]:=1;
                    go[n]:=2
                  end;
          xxx[n]:=xxx[n]-10;
       end;
  if (xxx[n]=0) and (yyy[n]<>0) then
     begin
          if goy[n]=1 then
                  begin
                    y[n]:=y[n]-10;
                    faza[n]:=faza[n]+1;
                    if faza[n]=11 then faza[n]:=1;
                    go[n]:=1
                  end;
          if goy[n]=2 then
                  begin
                    y[n]:=y[n]+10;
                    faza[n]:=faza[n]+1;
                    if faza[n]=11 then faza[n]:=1;
                    go[n]:=3
                  end;
           yyy[n]:=yyy[n]-10;
       end;
   for f:= 220 to all[1]+219 do
   if  (x[n]=x[f]) and (y[n]=y[f]) and (n<>f) then
           begin
              tip[n]:=3;
              faza[n]:=faza[n]-1;
              if faza[n]=0 then faza[n]:=10;
              if (gox[n]=1) and (xxx[n]<>0)  then x[n]:=x[n]+10;
              if (gox[n]=2) and (xxx[n]<>0) then x[n]:=x[n]-10;
              if (goy[n]=1) and (xxx[n]=0) then y[n]:=y[n]+10;
              if (goy[n]=2) and (xxx[n]=0) then y[n]:=y[n]-10
           end
                                    else
                          begin
     warrior1(n,x[n],y[n],1);
     if number=n then warrior1(n,540,125,1);
     putpixel(510+x[n] div 10,470-(48-y[n] div 10),10);
     if (xxx[n]=0) and (yyy[n]=0) then tip[n]:=3;
     going[n]:=0;
     cel(15,rr,tt)
                          end;
      if (x[n]>=x[1]-10) and (x[n]<=x[1]+30) and (y[n]>=y[1]-10) and (y[n]<=y[1]+30)
           then
           begin
              tip[n]:=3;
              faza[n]:=faza[n]-1;
              if faza[n]=0 then faza[n]:=10;
              if (gox[n]=1) and (xxx[n]<>0) then x[n]:=x[n]+10;
              if (gox[n]=2) and (xxx[n]<>0) then x[n]:=x[n]-10;
              if (goy[n]=1) and (xxx[n]=0) then y[n]:=y[n]+10;
              if (goy[n]=2) and (xxx[n]=0) then y[n]:=y[n]-10
           end
                                               else
                          begin
     warrior1(n,x[n],y[n],1);
     if number=n then warrior1(n,540,125,1);
     putpixel(510+x[n] div 10,470-(48-y[n] div 10),10);
     if (xxx[n]=0) and (yyy[n]=0) then tip[n]:=3;
     going[n]:=0;
     cel(15,rr,tt)
                          end;
end;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then begin writeln('инициализация не закончена!');
   halt end;
randomize;
oiv;
for f:=1 to 2 do
 begin
   sound(f);
   delay(300+f);
   nosound
 end;
 zdanie[1]:=1; x[1]:=120; y[1]:=400; energy[1]:=140;
   day:='1';
   den:=1;
   knop:=0;
   vid:=0;
   zol:=1000;
    r:=50;
     t:=400;
      rr:=200;
       tt:=300;
        all[1]:=3;
        war:=219;
         x[220]:=100; y[220]:=100;
               faza[220]:=1; go[220]:=1;
               energy[220]:=10; tip[220]:=3;
         x[221]:=100; y[221]:=150;
               faza[221]:=1; go[221]:=4;
               energy[221]:=10;tip[221]:=3;
         x[222]:=200; y[222]:=200;
               faza[222]:=1; go[222]:=1;
               energy[222]:=10;tip[222]:=1;
               xxx[222]:=200; yyy[222]:=100;
               gox[222]:=2; goy[222]:=2;
               going[222]:=0;
 building(1,x[1],y[1]);
 allwar;
 wind;

           start:
repeat
days:=days+1;
             if days=40000 then
             begin
             setcolor(7);
             str(den,day);
             outtextxy(540,29,day);
             den:=den+1;
             wind;
             days:=0
             end;
war:=war+1;
if war=220+all[1] then war:=220;
 going[war]:=going[war]+1;
if (tip[war]=1) and (going[war]=30000) then goin(war);
until keypressed;
repeat until keypressed;
 h:=readkey;
{   putpixel(510+rr div 10,470-(48-tt div 10),6);   }
 if h='i' then
   begin
     cel(6,rr,tt);
     iff;
     building(1,x[1],y[1]);
     allwar;
     tt:=tt-10;
     cel(15,rr,tt);

   end;
 if h='l' then
   begin
     cel(6,rr,tt);
     iff;
     building(1,x[1],y[1]);
     allwar;
     rr:=rr+10;
     cel(15,rr,tt);

   end;
 if h='k' then
   begin
    cel(6,rr,tt);
     iff;
    building(1,x[1],y[1]);
    allwar;
    tt:=tt+10;
    cel(15,rr,tt);

   end;
 if h='j' then
   begin
      cel(6,rr,tt);
      iff;
      building(1,x[1],y[1]);
      allwar;
      rr:=rr-10;
      cel(15,rr,tt);

   end;
   if (h='s') and (knop<>0) then
       begin
           sound(4000);delay(200);nosound;
           sound(404);delay(2000);nosound;
           sound(60000);delay(1000);nosound;
           tip[number]:=3
       end;
   if (h='d') and (knop<>0) then
            begin
             for f:= 1 to 3 do
              begin
                sound(4000-f*50);delay(2000);nosound;
              end;
             vid:=1;
             setcolor(7);
             for f:=1 to 90 do line(481,270+f,630,270+f);
             setcolor(5);
             settextstyle(2,0,5);
             outtextxy(500,270,'Укажите');
             outtextxy(520,290,'куда');
             outtextxy(500,310,'двигаться!')
            end;
   if (h=' ') and (vid=1) then
            begin
              for f:= 1 to 5 do
              begin
                sound(4000+f*50);delay(2000);nosound;
              end;
              setcolor(7);
              for f:=1 to 90 do line(481,270+f,630,270+f);
              setcolor(5);
              outtextxy(500,270,'D - движение');
              outtextxy(500,290,'F - битва');
              outtextxy(500,310,'S - стоп');
              tip[number]:=1;
              xxx[number]:=abs(x[number]-rr);
              yyy[number]:=abs(y[number]-tt);
              if rr>x[number] then gox[number]:=2
                              else gox[number]:=1;
              if tt>y[number] then goy[number]:=2
                              else goy[number]:=1;
              going[number]:=0;
              vid:=0
            end;
 { Г Л А В Н Ы Й   Л А Г Е Р Ь }

  if (h=' ') and (rr>=x[1]) and (rr<=x[1]+30) and (tt>=y[1]) and (tt<=y[1]+30) then
          begin
            steret;
            setcolor(5);
            settextstyle(2,0,6);
            outtextxy(490,60,'Главный лагерь');
            building(1,540,120);
            setcolor(2);
            for f:=1 to energy[1] do line(489+f,220,489+f,230);
            number:=nomer
          end;
 { М О Б И Л Ь }

   if (h=' ') and (rr>=x[nomer]-10) and (rr<=x[nomer]+10) and (tt>=y[nomer]-10)
   and  (tt<=y[nomer]+10) then
          begin
            steret;
            setcolor(5);
            settextstyle(2,0,6);
            outtextxy(520,60,'Мобиль');
            warrior1(nomer,540,125,1);
            setcolor(2);
            for f:= 1 to energy[nomer] do line(489+f,220,489+f,230);
            setcolor(5);
            settextstyle(2,0,5);
            outtextxy(500,270,'D - движение');
            outtextxy(500,290,'F - битва');
            outtextxy(500,310,'S - стоп');
            knop:=nomer;
            number:=nomer
          end;

  if h=#27 then halt;
           goto start;
CloseGraph
end.