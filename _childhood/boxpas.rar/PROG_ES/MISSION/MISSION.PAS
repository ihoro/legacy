uses TextWind, Crt, Dos;
type
     TypType = 13..17;
     CXYType = 1..100;
     GoType = 1..4;
     AttrType = 1..3;
var
    p:array[1..100,1..100] of Byte;
    Total:Byte;
    TotalYouSold:0..61;
    YouSold:array[1..61] of
              record
                Typ:TypType;
                CX,CY:CXYType;
                TX,TY:CXYType;
                Attr:AttrType;
                Go:GoType;
                Life:0..100;
                Potron:0..200;
                Mine:0..10
              end;
    TotalComSold:0..60;
    ComSold:array[1..60] of
              record
                Typ:TypType;
                CX,CY:CXYType;
                TX,TY:CXYType;
                Attr:AttrType;
                Go:GoType;
                Life:0..100;
                Potron:0..200;
                Mine:0..10
              end;
    TotalDom:0..200;
    Dom:array[1..200] of
          record
            CX,CY:CXYType
          end;
    TotalDoor:0..10;
    Door:array[1..10] of
           record
             CX,CY:CXYType
           end;
    TotalWolf:0..5;
    Wolf:array[1..5] of
           record
             CX,CY:CXYType;
             Go:GoType
           end;
    Move:0..2;{1-Move,2-Fire}
    Time:Word;
    WorkX,WorkY:Byte;
    WorkYouN:Byte;
    l,f,Level,Men,ScreenX,ScreenY,MaxX,MaxY,YouX,YouY,X,Y:Byte;
    NameFile:string[12];
    map:text;
    Err:Integer;
    h:Char;
    s:string;
    m:MenuType;
procedure DrawBlock(x,y,Block:Byte);
begin
gotoxy(x,y);
case Block of
0:begin
    textbackground(2);
    textcolor(6);
    write('°°')
  end;
1:begin
    textbackground(2);
    textcolor(0);
    write('°°')
  end;
2:begin
    textbackground(1);
    textcolor(11);
    write('²²')
  end;
3:begin
    textbackground(0);
    textcolor(1);
    write('°°')
  end;
4:begin
    textbackground(0);
    textcolor(7);
    write('ÀÙ')
  end;
5:begin
    textbackground(7);
    textcolor(8);
    write('ÉÍ')
  end;
6:begin
    textbackground(7);
    textcolor(8);
    write('ÈÍ')
  end;
7:begin
    textbackground(7);
    textcolor(8);
    write('Í»')
  end;
8:begin
    textbackground(7);
    textcolor(8);
    write('Í¼')
  end;
9:begin
    textbackground(7);
    textcolor(8);
    write('ÍÍ')
  end;
10:begin
    textbackground(7);
    textcolor(8);
    write('º ')
  end;
11:begin
    textbackground(7);
    textcolor(8);
    write(' º')
  end;
12:begin
    textbackground(7);
    textcolor(8);
    write('  ')
  end;
13:begin
    textbackground(2);
    textcolor(10);
    write('Ôµ')
  end;
14:begin
    textbackground(2);
    textcolor(10);
    write('Ô¹')
  end;
15:begin
    textbackground(2);
    textcolor(10);
    write('È¼')
  end;
16:begin
    textbackground(2);
    textcolor(10);
    write('Ô¾')
  end;
17:begin
    textbackground(2);
    textcolor(10);
    write('ÀÙ')
  end;
18:begin
    textbackground(1);
    textcolor(9);
    write('Ôµ')
  end;
19:begin
    textbackground(1);
    textcolor(9);
    write('Ô¹')
  end;
20:begin
    textbackground(1);
    textcolor(9);
    write('È¼')
  end;
21:begin
    textbackground(1);
    textcolor(9);
    write('Ô¾')
  end;
22:begin
    textbackground(1);
    textcolor(9);
    write('ÀÙ')
  end;
23:begin
    textbackground(6);
    textcolor(13);
    write('##')
  end;
25:begin
    textbackground(7);
    textcolor(8);
    write('[]')
  end;
end;
SetCursor
end;
procedure Screen(x,y:Byte);
var f,l:byte;
begin
for l:=1 to 10 do
  for f:=1 to 10 do
    DrawBlock(f*2,l+6,p[y+l-1,x+f-1]);
SetCursor
end;
procedure You(Clear:Boolean);
begin
if Clear then
  DrawBlock(X,Y,p[YouY,YouX])
         else
  begin
    textbackground(0);
    textcolor(13);
    gotoxy(X,Y);
    write('ÛÛ')
  end;
SetCursor
end;
procedure WorkYou(N:Byte);
begin
TextWindow(23,6,30,12,'');
if n=0 then Exit;
TxtColor:=11;
with YouSold[N] do
begin
case Typ of
13:begin
     SetText(3,3,'‘®«¤ â');
     str(Life,s);
     SetText(3,5,'­¥à£¨ï: '+s+'%');
     str(Potron,s);
     SetText(3,7,'®âà®­ë: '+s)
   end;
14:begin
     SetText(3,3,' §ãª¨áâ');
     str(Life,s);
     SetText(3,5,'­¥à£¨ï: '+s+'%');
     str(Potron,s);
     SetText(3,7,'®âà®­ë: '+s)
   end;
15:begin
     SetText(3,3,'í¬¡®');
     str(Life,s);
     SetText(3,5,'­¥à£¨ï: '+s+'%')
   end;
16:begin
     SetText(3,3,'Œ¨­¥à');
     str(Life,s);
     SetText(3,5,'­¥à£¨ï: '+s+'%');
     str(Potron,s);
     SetText(3,7,'®âà®­ë: '+s);
     str(Mine,s);
     SetText(3,9,'Œ¨­ë: '+s);
   end;
17:begin
     SetText(3,3,'‘ ­¨â à');
     str(Life,s);
     SetText(3,5,'­¥à£¨ï: '+s+'%')
   end;
end
end;
SetText(19,5,'D-„¢¨¦¥­¨¥');
SetText(19,7,'S-‘âà¥«ïâì');
end;
procedure Work(x,y:Byte);
var f:byte;
begin
if ((x=0) and (y=0)) or not ((p[y,x]>=13) and (p[y,x]<=17)) then
  begin
    WorkX:=0;
    WorkY:=0;
    WorkYou(0);
    Exit
  end;
if (p[y,x]>=13) and (p[y,x]<=17) then
  begin
    for f:=1 to TotalYouSold do
      if (YouSold[f].CX=x) and (YouSold[f].CY=y) then
        begin
          WorkYouN:=f;
          WorkYou(f);
          f:=TotalYouSold
        end;
  end;
end;
function OnScreen(x,y:Byte):Boolean;
begin
if (x>=ScreenX) and (x<=ScreenX+9)
   and (y>=ScreenY) and (y<=ScreenY+9) then OnScreen:=true
                                       else OnScreen:=false
end;
procedure Wolfs;
var f:byte;
begin
if TotalWolf=0 then Exit;
for f:=1 to TotalWolf do
  With Wolf[f] do
  begin
    p[CY,CX]:=0;
    if OnScreen(CX,CY) then
      DrawBlock((CX-ScreenX+1)*2,7+CY-ScreenY,p[CY,CX]);
    Go:=Random(4)+1;
    case Go of
    1:if ((CY-1)<>0) and (p[CY-1,CX]=0) then
      begin
        CY:=CY-1;
        p[CY,CX]:=4;
        if OnScreen(CX,CY) then
          DrawBlock((CX-ScreenX+1)*2,7+CY-ScreenY,p[CY,CX]);
      end;
    2:if ((CX+1)<>(MaxX+1)) and (p[CY,CX+1]=0) then
      begin
        CX:=CX+1;
        p[CY,CX]:=4;
        if OnScreen(CX,CY) then
          DrawBlock((CX-ScreenX+1)*2,7+CY-ScreenY,p[CY,CX]);
      end;
    3:if ((CY+1)<>(MaxY+1)) and (p[CY+1,CX]=0) then
      begin
        CY:=CY+1;
        p[CY,CX]:=4;
        if OnScreen(CX,CY) then
          DrawBlock((CX-ScreenX+1)*2,7+CY-ScreenY,p[CY,CX]);
      end;
    4:if ((CX-1)<>0) and (p[CY,CX-1]=0) then
      begin
        CX:=CX-1;
        p[CY,CX]:=4;
        if OnScreen(CX,CY) then
          DrawBlock((CX-ScreenX+1)*2,7+CY-ScreenY,p[CY,CX]);
      end;
    end;
  end;
end;
procedure YouSoldiers;
var q,f,r,t,l,d,s:Byte;
begin
if TotalYouSold=0 then Exit;
for f:=1 to TotalYouSold do
  with YouSold[f] do
    begin
      if Attr=1 then
        begin
          case Typ of
          13,16:l:=2;
          14:l:=3;
          15:l:=1;
          17:l:=0
          end;
                  for t:=CY downto CY-l do
                    if ((p[t,CX]>=18) and (p[t,CX]<=22)) or (p[t,CX]=4) then
                      begin
                        Go:=1;
                        Attr:=3
                      end;
                  for t:=CY to CY+l do
                    if ((p[t,CX]>=18) and (p[t,CX]<=22)) or (p[t,CX]=4) then
                      begin
                        Go:=3;
                        Attr:=3
                      end;
                  for r:=CX downto CY-l do
                    if ((p[CY,r]>=18) and (p[CY,r]<=22)) or (p[CY,r]=4) then
                      begin
                        Go:=4;
                        Attr:=3
                      end;
                  for r:=CX to CY+l do
                    if ((p[CY,r]>=18) and (p[CY,r]<=22)) or (p[CY,r]=4) then
                      begin
                        Go:=2;
                        Attr:=3
                      end;
        end;
        if Attr=3 then
          begin
            Sound(1000);
            Delay(3);
            NoSound;
            case Typ of
            13,16:l:=2;
            14:l:=3;
            15:l:=1;
            17:l:=0
            end;
            case Go of
              1:for t:=CY downto CY-l do
                  if ((p[t,CX]>=18) and (p[t,CX]<=22)) or (p[t,CX]=4) then
                    begin
                      if p[t,CX]<>4 then
                        begin
                          for q:=1 to TotalComSold do
                            if (ComSold[q].CX=CX) and (ComSold[q].CY=t) then
                              begin
                                case l of
                                2:s:=1;
                                3:s:=2;
                                1:s:=4
                                end;
                                ComSold[q].Life:=ComSold[q].Life-s;
                                if ComSold[q].Life<=0 then
                                  begin
                                    Total:=Total-1;
                                    p[ComSold[q].CY,ComSold[q].CX]:=0;
                                    if OnScreen(ComSold[q].CX,ComSold[q].CY) then
                                       DrawBlock((ComSold[q].CX-ScreenX+1)*2,7+ComSold[q].CY-ScreenY,p[ComSold[q].CY,
                                                 ComSold[q].CX]);
                                    TotalComSold:=TotalComSold-1;
                                    for d:=q to TotalComSold do
                                      begin
                                        ComSold[d].CX:=ComSold[d+1].CX;
                                        ComSold[d].CY:=ComSold[d+1].CY
                                      end;
                                  end;
                                q:=TotalComSold;
                              end;
                        end;
                      if p[t,CX]=4 then
                        begin
                          Total:=Total-1;
                          for q:=1 to TotalWolf do
                            if (Wolf[q].CX=CX) and (Wolf[q].CY=t) then
                              begin
                                p[Wolf[q].CY,Wolf[q].CX]:=0;
                                if OnScreen(Wolf[q].CX,Wolf[q].CY) then
                                  DrawBlock((Wolf[q].CX-ScreenX+1)*2,7+Wolf[q].CY-ScreenY,p[Wolf[q].CY,Wolf[q].CX]);
                                TotalWolf:=TotalWolf-1;
                                for d:=q to TotalWolf do
                                  begin
                                    Wolf[d].CX:=Wolf[d+1].CX;
                                    Wolf[d].CY:=Wolf[d+1].CY
                                  end;
                                q:=TotalWolf
                              end;
                        end;
                    end
                                                                      else
                    if t=(CY-l) then Attr:=1;
              3:for t:=CY to CY+l do
                  if ((p[t,CX]>=18) and (p[t,CX]<=22)) or (p[t,CX]=4) then
                    begin
                      if p[t,CX]<>4 then
                        begin
                          for q:=1 to TotalComSold do
                            if (ComSold[q].CX=CX) and (ComSold[q].CY=t) then
                              begin
                                case l of
                                2:s:=1;
                                3:s:=2;
                                1:s:=4
                                end;
                                ComSold[q].Life:=ComSold[q].Life-s;
                                if ComSold[q].Life<=0 then
                                  begin
                                    Total:=Total-1;
                                    p[ComSold[q].CY,ComSold[q].CX]:=0;
                                    if OnScreen(ComSold[q].CX,ComSold[q].CY) then
                                       DrawBlock((ComSold[q].CX-ScreenX+1)*2,7+ComSold[q].CY-ScreenY,p[ComSold[q].CY,
                                                 ComSold[q].CX]);
                                    TotalComSold:=TotalComSold-1;
                                    for d:=q to TotalComSold do
                                      begin
                                        ComSold[d].CX:=ComSold[d+1].CX;
                                        ComSold[d].CY:=ComSold[d+1].CY
                                      end;
                                  end;
                                q:=TotalComSold;
                              end;
                        end;
                      if p[t,CX]=4 then
                        begin
                          Total:=Total-1;
                          for q:=1 to TotalWolf do
                            if (Wolf[q].CX=CX) and (Wolf[q].CY=t) then
                              begin
                                p[Wolf[q].CY,Wolf[q].CX]:=0;
                                if OnScreen(Wolf[q].CX,Wolf[q].CY) then
                                  DrawBlock((Wolf[q].CX-ScreenX+1)*2,7+Wolf[q].CY-ScreenY,p[Wolf[q].CY,Wolf[q].CX]);
                                TotalWolf:=TotalWolf-1;
                                for d:=q to TotalWolf do
                                  begin
                                    Wolf[d].CX:=Wolf[d+1].CX;
                                    Wolf[d].CY:=Wolf[d+1].CY
                                  end;
                                q:=TotalWolf
                              end;
                        end;
                    end
                                                                      else
                    if t=(CY+l) then Attr:=1;
              2:for t:=CX to CX+l do
                  if ((p[CY,t]>=18) and (p[CY,t]<=22)) or (p[CY,t]=4) then
                    begin
                      if p[CY,t]<>4 then
                        begin
                          for q:=1 to TotalComSold do
                            if (ComSold[q].CX=t) and (ComSold[q].CY=CY) then
                              begin
                                case l of
                                2:s:=1;
                                3:s:=2;
                                1:s:=4
                                end;
                                ComSold[q].Life:=ComSold[q].Life-s;
                                if ComSold[q].Life<=0 then
                                  begin
                                    Total:=Total-1;
                                    p[ComSold[q].CY,ComSold[q].CX]:=0;
                                    if OnScreen(ComSold[q].CX,ComSold[q].CY) then
                                       DrawBlock((ComSold[q].CX-ScreenX+1)*2,7+ComSold[q].CY-ScreenY,p[ComSold[q].CY,
                                                 ComSold[q].CX]);
                                    TotalComSold:=TotalComSold-1;
                                    for d:=q to TotalComSold do
                                      begin
                                        ComSold[d].CX:=ComSold[d+1].CX;
                                        ComSold[d].CY:=ComSold[d+1].CY
                                      end;
                                  end;
                                q:=TotalComSold;
                              end;
                        end;
                      if p[CY,t]=4 then
                        begin
                          Total:=Total-1;
                          for q:=1 to TotalWolf do
                            if (Wolf[q].CX=t) and (Wolf[q].CY=CY) then
                              begin
                                p[Wolf[q].CY,Wolf[q].CX]:=0;
                                if OnScreen(Wolf[q].CX,Wolf[q].CY) then
                                  DrawBlock((Wolf[q].CX-ScreenX+1)*2,7+Wolf[q].CY-ScreenY,p[Wolf[q].CY,Wolf[q].CX]);
                                TotalWolf:=TotalWolf-1;
                                for d:=q to TotalWolf do
                                  begin
                                    Wolf[d].CX:=Wolf[d+1].CX;
                                    Wolf[d].CY:=Wolf[d+1].CY
                                  end;
                                q:=TotalWolf
                              end;
                        end;
                    end
                                                                      else
                    if t=(CX+l) then Attr:=1;
              4:for t:=CX downto CX-l do
                  if ((p[CY,t]>=18) and (p[CY,t]<=22)) or (p[CY,t]=4) then
                    begin
                      if p[CY,t]<>4 then
                        begin
                          for q:=1 to TotalComSold do
                            if (ComSold[q].CX=t) and (ComSold[q].CY=CY) then
                              begin
                                case l of
                                2:s:=1;
                                3:s:=2;
                                1:s:=4
                                end;
                                ComSold[q].Life:=ComSold[q].Life-s;
                                if ComSold[q].Life<=0 then
                                  begin
                                    Total:=Total-1;
                                    p[ComSold[q].CY,ComSold[q].CX]:=0;
                                    if OnScreen(ComSold[q].CX,ComSold[q].CY) then
                                       DrawBlock((ComSold[q].CX-ScreenX+1)*2,7+ComSold[q].CY-ScreenY,p[ComSold[q].CY,
                                                 ComSold[q].CX]);
                                    TotalComSold:=TotalComSold-1;
                                    for d:=q to TotalComSold do
                                      begin
                                        ComSold[d].CX:=ComSold[d+1].CX;
                                        ComSold[d].CY:=ComSold[d+1].CY
                                      end;
                                  end;
                                q:=TotalComSold;
                              end;
                        end;
                      if p[CY,t]=4 then
                        begin
                          Total:=Total-1;
                          for q:=1 to TotalWolf do
                            if (Wolf[q].CX=t) and (Wolf[q].CY=CY) then
                              begin
                                p[Wolf[q].CY,Wolf[q].CX]:=0;
                                if OnScreen(Wolf[q].CX,Wolf[q].CY) then
                                  DrawBlock((Wolf[q].CX-ScreenX+1)*2,7+Wolf[q].CY-ScreenY,p[Wolf[q].CY,Wolf[q].CX]);
                                TotalWolf:=TotalWolf-1;
                                for d:=q to TotalWolf do
                                  begin
                                    Wolf[d].CX:=Wolf[d+1].CX;
                                    Wolf[d].CY:=Wolf[d+1].CY
                                  end;
                                q:=TotalWolf
                              end;
                        end;
                    end
                                                                      else
                    if t=(CX-l) then Attr:=1;
            end;
          end;
      if Attr=2 then
        begin
          r:=ABS(CX-TX);
          t:=ABS(CY-TY);
          if r=t then
            if Random(2)+1=1 then r:=r+1
                             else t:=t+1;
          if r>t then
            begin
              if CX>TX then Go:=4;
              if CX<TX then Go:=2
            end;
          if r<t then
            begin
              if CY>TY then Go:=1;
              if CY<TY then Go:=3
            end;
          r:=p[CY,CX];
          p[CY,CX]:=0;
          if OnScreen(CX,CY) then DrawBlock((CX-ScreenX+1)*2,7+CY-ScreenY,p[CY,CX]);
          case Go of
            1:begin
              if p[CY-1,CX]<>0 then
                begin
                  if p[CY-1,CX-1]=0 then CX:=CX-1
                                    else
                    if p[CY-1,CX+1]=0 then CX:=CX+1
                                      else
                      CY:=CY+1;
                end;
              CY:=CY-1;
              if (CX=TX) and (CY=TY) then Attr:=1;
              p[CY,CX]:=r;
              if OnScreen(CX,CY) then DrawBlock((CX-ScreenX+1)*2,7+CY-ScreenY,p[CY,CX]);
              end;
            2:begin
              if p[CY,CX+1]<>0 then
                begin
                  if p[CY-1,CX+1]=0 then CY:=CY-1
                                    else
                    if p[CY+1,CX+1]=0 then CY:=CY+1
                                      else
                      CX:=CX-1;
                end;
              CX:=CX+1;
              if (CX=TX) and (CY=TY) then Attr:=1;
              p[CY,CX]:=r;
              if OnScreen(CX,CY) then DrawBlock((CX-ScreenX+1)*2,7+CY-ScreenY,p[CY,CX]);
              end;
            3:begin
              if p[CY+1,CX]<>0 then
                begin
                  if p[CY+1,CX-1]=0 then CX:=CX-1
                                    else
                    if p[CY+1,CX+1]=0 then CX:=CX+1
                                      else
                      CY:=CY-1;
                end;
              CY:=CY+1;
              if (CX=TX) and (CY=TY) then Attr:=1;
              p[CY,CX]:=r;
              if OnScreen(CX,CY) then DrawBlock((CX-ScreenX+1)*2,7+CY-ScreenY,p[CY,CX]);
              end;
            4:begin
              if p[CY,CX-1]<>0 then
                begin
                  if p[CY-1,CX-1]=0 then CY:=CY-1
                                    else
                    if p[CY+1,CX-1]=0 then CY:=CY+1
                                      else
                      CX:=CX+1;
                end;
              CX:=CX-1;
              if (CX=TX) and (CY=TY) then Attr:=1;
              p[CY,CX]:=r;
              if OnScreen(CX,CY) then DrawBlock((CX-ScreenX+1)*2,7+CY-ScreenY,p[CY,CX]);
              end;
          end;
        end;
    end;
end;
begin
Level:=1;
Randomize;
FirstActive:=1;
MenuY:=2;
repeat
textbackground(0);
ClrScr;
WindowColor:=1;
LimitColor:=15;
TxtColor:=14;
TextWindow(36,8,8,7,'');
m[1]:='Œ¨áá¨ï';
m[2]:=' à®«ì';
m[3]:=' ˆ£à  ';
m[4]:='®¬®éì';
m[5]:='‚ëå®¤!';
Men:=Menu(2,2,m,5);
case Men of
1:begin
    textbackground(0);
    ClrScr;
    str(Level,s);
    s:='level'+s+'.map';
    Assign(map,s);
    Reset(map);
    readln(map,MaxX);readln(map,MaxY);
    TotalYouSold:=0;
    TotalComSold:=0;
    TotalDom:=0;
    TotalDoor:=0;
    for l:=1 to MaxY do
      for f:=1 to MaxX do
        begin
          readln(map,p[l,f]);
          if (p[l,f]>=13) and (p[l,f]<=17) then
            begin
              inc(TotalYouSold);
              with YouSold[TotalYouSold] do
                begin
                  Typ:=p[l,f];
                  CX:=f;
                  CY:=l;
                  Attr:=1;
                  Go:=1;
                  Life:=100;
                  case Typ of
                  13:Potron:=200;
                  14,16:Potron:=100;
                  15,17:Potron:=0
                  end;
                  if Typ=16 then Mine:=10
                            else Mine:=0
                end;
            end;
          if (p[l,f]>=18) and (p[l,f]<=22) then
            begin
              inc(TotalComSold);
              with ComSold[TotalComSold] do
                begin
                  Typ:=p[l,f];
                  CX:=f;
                  CY:=l;
                  Attr:=1;
                  Go:=1;
                  Life:=100;
                  case Typ of
                  18:Potron:=200;
                  19,21:Potron:=100;
                  20,22:Potron:=0
                  end;
                  if Typ=21 then Mine:=10
                            else Mine:=0
                end;
            end;
          if (p[l,f]>=5) and (p[l,f]<=12) then
            begin
              inc(TotalDom);
              with Dom[TotalDom] do
                begin
                  CX:=f;
                  CY:=l
                end;
            end;
          if p[l,f]=25 then
            begin
              inc(TotalDoor);
              with Door[TotalDoor] do
                begin
                  CX:=f;
                  CY:=l
                end;
            end;
          if p[l,f]=4 then
            begin
              inc(TotalWolf);
              with Wolf[TotalWolf] do
                begin
                  CX:=f;
                  CY:=l
                end;
            end;
          if p[l,f]=24 then
            begin
              YouX:=f;
              YouY:=l;
              ScreenX:=YouX-4;
              ScreenY:=YouY-4;
              X:=10;
              Y:=11;
              p[l,f]:=0
            end;
        end;
    Close(map);
    WindowColor:=0;
    LimitColor:=10;
    TextWindow(1,6,22,12,'');
    Screen(ScreenX,ScreenY);
    You(false);
    Total:=TotalYouSold+TotalComSold+TotalWolf;
    Time:=0;
    WorkX:=0;
    WorkY:=0;
    Work(WorkX,WorkY);
    Move:=0;
    repeat
    repeat
    Time:=Time+1;
    if Time>=(655-Total) then
      begin
        Wolfs;
        YouSoldiers;
        Time:=0
      end;
    until KeyPressed;
    h:=ReadKey;
    if (UpCase(h)='D') and (p[WorkY,WorkX]>=13) and (p[WorkY,WorkX]<=17) then Move:=1;
    if (h=#13) and (Move=1) then
      begin
        YouSold[WorkYouN].TX:=YouX;
        YouSold[WorkYouN].TY:=YouY;
        YouSold[WorkYouN].Attr:=2;
        Move:=0
      end;
    if (h=#13) and (Move=0) then
      begin
        WorkX:=YouX;
        WorkY:=YouY;
        Work(WorkX,WorkY)
      end;
    if h=#0 then
      begin
        h:=ReadKey;
        if (h=#72) and (YouY<>1) then
          begin
            You(true);
            YouY:=YouY-1;
            if Y=7 then
              begin
                ScreenY:=ScreenY-1;
                Screen(ScreenX,ScreenY)
              end
                   else
              Y:=Y-1;
            You(false)
          end;
        if (h=#73) and (YouY<>1) then
          begin
            if (YouY-10)<1 then
              begin
                ScreenY:=1;
                YouY:=1;
                Y:=7
              end
                           else
              begin
                ScreenY:=ScreenY-10;
                YouY:=YouY-10
              end;
            Screen(ScreenX,ScreenY);
            You(false)
          end;
        if (h=#80) and (YouY<>MaxY) then
          begin
            You(true);
            YouY:=YouY+1;
            if Y=16 then
              begin
                ScreenY:=ScreenY+1;
                Screen(ScreenX,ScreenY)
              end
                    else
              Y:=Y+1;
            You(false)
          end;
        if (h=#81) and (YouY<>MaxY) then
          begin
            if (YouY+10)>MaxY then
              begin
                ScreenY:=MaxY-9;
                YouY:=MaxY;
                Y:=16
              end
                           else
              begin
                ScreenY:=ScreenY+10;
                YouY:=YouY+10
              end;
            Screen(ScreenX,ScreenY);
            You(false)
          end;
        if (h=#75) and (YouX<>1) then
          begin
            You(true);
            YouX:=YouX-1;
            if X=2 then
              begin
                ScreenX:=ScreenX-1;
                Screen(ScreenX,ScreenY)
              end
                   else
              X:=X-2;
            You(false)
          end;
        if (h=#71) and (YouX<>1) then
          begin
            if (YouX-10)<1 then
              begin
                ScreenX:=1;
                YouX:=1;
                X:=2
              end
                           else
              begin
                ScreenX:=ScreenX-10;
                YouX:=YouX-10
              end;
            Screen(ScreenX,ScreenY);
            You(false)
          end;
        if (h=#77) and (YouX<>MaxX) then
          begin
            You(true);
            YouX:=YouX+1;
            if X=20 then
              begin
                ScreenX:=ScreenX+1;
                Screen(ScreenX,ScreenY)
              end
                   else
              X:=X+2;
            You(false)
          end;
        if (h=#79) and (YouX<>MaxX) then
          begin
            if (YouX+10)>MaxX then
              begin
                ScreenX:=MaxX-9;
                YouX:=MaxX;
                X:=20
              end
                           else
              begin
                ScreenX:=ScreenX+10;
                YouX:=YouX+10
              end;
            Screen(ScreenX,ScreenY);
            You(false)
          end;
      end; {h=#0}
    until h=#27;
  end; {case Men of 1}
end;
until Men=5;
textbackground(0);
ClrScr
end.