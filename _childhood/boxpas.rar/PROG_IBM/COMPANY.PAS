unit Company;
interface
procedure oiv;
implementation
uses Crt,Graph;
var b:char;d,g:integer;
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
 b:= ReadKey ; ClearDevice;setBkcolor(6)
 END;
begin
d:=detect;
initgraph(d,g,'');
if graphresult <> 0 then
         begin
           writeln('Иницилизация незакончена!');
           halt
         end
end.