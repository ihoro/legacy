program text;
uses Crt,Dos,Graph;
label ooo;
var
    comp,camp,fire,fore,mis,mos,fine,fune,enu,
    ene,life,gun,gan,r,t,no,gon,f,d,g,beg,left,
    etaj1x,etaj1y,zones                          :integer;

    b,h,lefts,right,fi,select,go,pause           :char;
    p                                            :string;
procedure man(x,y,k1,k2,k3:integer);
          begin
          setcolor(k2);
          setfillstyle(1,k2);
          circle(x,y-3,2);
          floodfill(x,y-3,k2);
          putpixel(x,y,k2);
          setcolor(k1);setfillstyle(1,k1);
          rectangle(x-2,y+1,x+2,y+7);
          floodfill(x,y+3,k1);
          putpixel(x-2,y+7,0);
          putpixel(x+2,y+7,0);
          setcolor(k3);
          line(x-1,y+8,x+1,y+8);
          end;
procedure an1(x,y,k:integer);
          var c1,c2,c3,c4:integer;
          begin
          if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
          man(x,y,c1,c2,c3);
          setcolor(c2);
          rectangle(x+3,y+9,x+2,y+10);
          line(x-8,y+4,x-8,y+5);
          putpixel(x-7,y+4,c2);
          setcolor(c1);
          line(x+3,y+1,x+3,y+2);
          putpixel(x+4,y+1,c1);
          rectangle(x+5,y+2,x+4,y+5);
          putpixel(x+5,y+6,c1);
          line(x+4,y+7,x+4,y+8);
          line(x-3,y+1,x-3,y+2);
          putpixel(x-4,y+1,c1);
          rectangle(x-4,y+2,x-5,y+5);
          line(x-5,y+6,x-7,y+6);
          rectangle(x+1,y+9,x-2,y+10);
          rectangle(x+1,y+11,x,y+14);
          line(x+1,y+15,x+5,y+19);
          line(x+4,y+19,x+3,y+19);
          line(x-2,y+11,x-5,y+14);
          line(x-3,y+11,x-5,y+13);
          line(x-4,y+14,x-4,y+15);
          putpixel(x-5,y+14,c1);
          line(x-3,y+16,x-3,y+17);
          putpixel(x-2,y+18,c1);
          line(x-2,y+19,x-4,y+19);
             setcolor(c4);
     if gun=1 then begin line(x-11,y,x-7,y+4);
                         line(x-9,y+3,x-9,y+6);
                         putpixel(x-9,y,c4);
                         putpixel(x-10,y+2,c4);
                         putpixel(x-8,y+5,c4)
                   end;
     if gun=2 then begin line(x-5,y+4,x-12,y-3);
                       line(x-7,y+3,x-12,y-2);
                       line(x-9,y+2,x-10,y+4);
                       line(x-9,y-2,x-10,y-2);
                       putpixel(x-10,y-3,c4);
                       putpixel(x-8,y-3,c4);
                       putpixel(x-9,y-4,c4)
                   end;
     if gun=3 then begin line(x-8,y+3,x-9,y+3);
                       line(x-9,y+2,x-11,y);
                       line(x-8,y+2,x-9,y+1);
                       line(x-12,y,x-13,y-1);
                       line(x-11,y+3,x-11,y+4);
                       putpixel(x-11,y+5,c4)
                 end;
          end;
procedure man1(x,y,k:integer);
          var c1,c2,c3,c4:integer;
          begin
          if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
          man(x,y,c1,c2,c3);
          setcolor(c2);
          rectangle(x-3,y+9,x-2,y+10);
          line(x+8,y+4,x+8,y+5);
          putpixel(x+7,y+4,c2);
          setcolor(c1);
          line(x-3,y+1,x-3,y+2);
          putpixel(x-4,y+1,c1);
          rectangle(x-5,y+2,x-4,y+5);
          putpixel(x-5,y+6,c1);
          line(x-4,y+7,x-4,y+8);
          line(x+3,y+1,x+3,y+2);
          putpixel(x+4,y+1,c1);
          rectangle(x+4,y+2,x+5,y+5);
          line(x+5,y+6,x+7,y+6);
          rectangle(x-1,y+9,x+2,y+10);
          rectangle(x-1,y+11,x,y+14);
          line(x-1,y+15,x-5,y+19);
          line(x-4,y+19,x-3,y+19);
          line(x+2,y+11,x+5,y+14);
          line(x+3,y+11,x+5,y+13);
          line(x+4,y+14,x+4,y+15);
          putpixel(x+5,y+14,c1);
          line(x+3,y+16,x+3,y+17);
          putpixel(x+2,y+18,c1);
          line(x+2,y+19,x+4,y+19);
             setcolor(c4);
     if gun=1 then begin line(x+11,y,x+7,y+4);
                       line(x+9,y+3,x+9,y+6);
                       putpixel(x+9,y,c4);
                       putpixel(x+10,y+2,c4);
                       putpixel(x+8,y+5,c4)
                 end;
     if gun=2 then begin line(x+5,y+4,x+12,y-3);
                       line(x+7,y+3,x+12,y-2);
                       line(x+9,y+2,x+10,y+4);
                       line(x+9,y-2,x+10,y-2);
                       putpixel(x+10,y-3,c4);
                       putpixel(x+8,y-3,c4);
                       putpixel(x+9,y-4,c4)
                   end;
   if gun=3 then begin line(x+8,y+3,x+9,y+3);
                       line(x+9,y+2,x+11,y);
                       line(x+8,y+2,x+9,y+1);
                       line(x+12,y,x+13,y-1);
                       line(x+11,y+3,x+11,y+4);
                       putpixel(x+11,y+5,c4)
                 end;
          end;
procedure man2(x,y,k:integer);
          var c1,c2,c3,c4:integer;
          begin
          if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
          man(x,y,c1,c2,c3);
          setcolor(c1);
          line(x+3,y+1,x+3,y+5);
          line(x+4,y+2,x+4,y+6);
          line(x+5,y+7,x+6,y+7);
          line(x-3,y+1,x-3,y+5);
          line(x-4,y+2,x-4,y+6);
          line(x-3,y+7,x-2,y+7);
           line(x,y+9,x,y+12);
           line(x+1,y+9,x+1,y+15);
           line(x+2,y+9,x+2,y+14);
           putpixel(x+2,y+12,0);
           line(x+3,y+11,x+3,y+12);
           line(x+4,y+12,x+4,y+15);
           line(x+5,y+13,x+5,y+14);
           line(x,y+16,x-1,y+17);
           line(x-2,y+17,x,y+18);
           line(x+3,y+16,x+3,y+17);
           line(x+2,y+19,x+4,y+19);
           putpixel(x+2,y+18,c1);
           setcolor(c2);
           rectangle(x-1,y+8,x,y+9);
           rectangle(x+7,y+8,x+8,y+9);
             setcolor(c4);
        if gun=1 then  begin line(x+7,y+7,x+12,y+7);
                               putpixel(x+11,y+6,c4);
                               putpixel(x+10,y+8,c4);
                               line(x+9,y+8,x+9,y+10)
                         end;
        if gun=2 then  begin line(x+4,y+6,x+14,y+6);
                               line(x+7,y+7,x+13,y+7);
                               line(x+9,y+8,x+9,y+9);
                               putpixel(x+7,y+8,c4);
                               putpixel(x+12,y+5,c4);
                               putpixel(x+13,y+4,c4);
                               putpixel(x+11,y+4,c4);
                               putpixel(x+12,y+3,c4)
                       end;
        if gun=3 then begin line(x+6,y+6,x+11,y+6);
                            line(x+11,y+7,x+14,y+7);
                            putpixel(x+11,y+6,c4);
                            line(x+7,y+7,x+7,y+9);
                            line(x+8,y+8,x+9,y+7);
                            putpixel(x+8,y+7,c4);
                            line(x+8,y+5,x+9,y+5)
                      end;
           end;
procedure an2(x,y,k:integer);
          var c1,c2,c3,c4:integer;
          begin
          if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
          man(x,y,c1,c2,c3);
          setcolor(c1);
          line(x-3,y+1,x-3,y+5);
          line(x-4,y+2,x-4,y+6);
          line(x-5,y+7,x-6,y+7);
          line(x+3,y+1,x+3,y+5);
          line(x+4,y+2,x+4,y+6);
          line(x+3,y+7,x+2,y+7);
           line(x,y+9,x,y+12);
           line(x-1,y+9,x-1,y+15);
           line(x-2,y+9,x-2,y+14);
           putpixel(x-2,y+12,0);
           line(x-3,y+11,x-3,y+12);
           line(x-4,y+12,x-4,y+15);
           line(x-5,y+13,x-5,y+14);
           line(x,y+16,x+1,y+17);
           line(x+2,y+17,x,y+18);
           line(x-3,y+16,x-3,y+17);
           line(x-2,y+19,x-4,y+19);
           putpixel(x-2,y+18,c1);
           setcolor(c2);
           rectangle(x+1,y+8,x,y+9);
           rectangle(x-7,y+8,x-8,y+9);
             setcolor(c4);
     if gun=1 then begin line(x-7,y+7,x-12,y+7);
                         putpixel(x-11,y+6,c4);
                         putpixel(x-10,y+8,c4);
                         line(x-9,y+8,x-9,y+10)
                   end;
     if gun=2 then  begin line(x-4,y+6,x-14,y+6);
                               line(x-7,y+7,x-13,y+7);
                               line(x-9,y+8,x-9,y+9);
                               putpixel(x-7,y+8,c4);
                               putpixel(x-12,y+5,c4);
                               putpixel(x-13,y+4,c4);
                               putpixel(x-11,y+4,c4);
                               putpixel(x-12,y+3,c4)
                       end;
     if gun=3 then begin line(x-6,y+6,x-11,y+6);
                            line(x-11,y+7,x-14,y+7);
                            putpixel(x-11,y+6,c4);
                            line(x-7,y+7,x-7,y+9);
                            line(x-8,y+8,x-9,y+7);
                            putpixel(x-8,y+7,c4);
                            line(x-8,y+5,x-9,y+5)
                      end;
           end;
procedure man3(x,y,k:integer);
           var c1,c2,c3,c4:integer;
           begin
           if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
           man(x,y,c1,c2,c3);
           setcolor(c1);
           rectangle(x,y+9,x+2,y+10);
           rectangle(x+1,y+11,x+2,y+12);
           line(x+3,y+12,x+4,y+12);
           rectangle(x+4,y+13,x+5,y+14);
           line(x+4,y+15,x+4,y+17);
           line(x+5,y+17,x+6,y+18);
           line(x+1,y+13,x+2,y+13);
           line(x+2,y+14,x+2,y+16);
           line(x+1,y+17,x,y+18);
           line(x,y+19,x+2,y+19);
           putpixel(x+3,y+14,c1);
            line(x-3,y+1,x-3,y+4);
            line(x+3,y+1,x+3,y+5);
            putpixel(x+3,y+7,c1);
            setcolor(c2);
            rectangle(x+1,y+6,x+2,y+7);
            rectangle(x+4,y+8,x+5,y+9);
                setcolor(c4);
     if gun=1 then begin  line(x+3,y+7,x+8,y+7);
                          putpixel(x+7,y+6,c4);
                          putpixel(x+6,y+8,c4);
                          line(x+3,y+8,x+3,y+10);
                   end;
      if gun=2 then  begin line(x+1,y+6,x+11,y+6);
                               line(x+4,y+7,x+10,y+7);
                               line(x+6,y+8,x+6,y+9);
                               putpixel(x+4,y+8,c4);
                               putpixel(x+9,y+5,c4);
                               putpixel(x+10,y+4,c4);
                               putpixel(x+8,y+4,c4);
                               putpixel(x+9,y+3,c4)
                       end;
      if gun=3 then begin line(x+3,y+6,x+8,y+6);
                            line(x+8,y+7,x+11,y+7);
                            putpixel(x+8,y+6,c4);
                            line(x+4,y+7,x+4,y+9);
                            line(x+5,y+8,x+6,y+7);
                            putpixel(x+5,y+7,c4);
                            line(x+5,y+5,x+6,y+5)
                      end;
           end;
procedure an3(x,y,k:integer);
           var c1,c2,c3,c4:integer;
           begin
           if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
           man(x,y,c1,c2,c3);
           setcolor(c1);
           rectangle(x,y+9,x-2,y+10);
           rectangle(x-1,y+11,x-2,y+12);
           line(x-3,y+12,x-4,y+12);
           rectangle(x-4,y+13,x-5,y+14);
           line(x-4,y+15,x-4,y+17);
           line(x-5,y+17,x-6,y+18);
           line(x-1,y+13,x-2,y+13);
           line(x-2,y+14,x-2,y+16);
           line(x-1,y+17,x,y+18);
           line(x,y+19,x-2,y+19);
           putpixel(x-3,y+14,c1);
            line(x+3,y+1,x+3,y+4);
            line(x-3,y+1,x-3,y+5);
            putpixel(x-3,y+7,c1);
            setcolor(c2);
            rectangle(x-1,y+6,x-2,y+7);
            rectangle(x-4,y+8,x-5,y+9);
                setcolor(c4);
    if gun=1 then begin  line(x-3,y+7,x-8,y+7);
                         putpixel(x-7,y+6,c4);
                         putpixel(x-6,y+8,c4);
                         line(x-3,y+8,x-3,y+10)
                  end;
    if gun=2 then  begin line(x-1,y+6,x-11,y+6);
                               line(x-4,y+7,x-10,y+7);
                               line(x-6,y+8,x-6,y+9);
                               putpixel(x-4,y+8,c4);
                               putpixel(x-9,y+5,c4);
                               putpixel(x-10,y+4,c4);
                               putpixel(x-8,y+4,c4);
                               putpixel(x-9,y+3,c4)
                       end;
    if gun=3 then begin line(x-3,y+6,x-8,y+6);
                            line(x-8,y+7,x-11,y+7);
                            putpixel(x-8,y+6,c4);
                            line(x-4,y+7,x-4,y+9);
                            line(x-5,y+8,x-6,y+7);
                            putpixel(x-5,y+7,c4);
                            line(x-5,y+5,x-6,y+5)
                      end;
           end;
procedure man4(x,y,k:integer);
            var c1,c2,c3,c4:integer;
            begin
            if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
            man(x,y,c1,c2,c3);
            setcolor(c1);
            rectangle(x,y+9,x+1,y+11);
            putpixel(x+2,y+9,c1);
            line(x+2,y+10,x+6,y+10);
            putpixel(x,y+12,c1);
            line(x-1,y+12,x-2,y+13);
            putpixel(x+5,y+11,c1);
            line(x+6,y+11,x+4,y+13);
            putpixel(x+4,y+14,c1);
            putpixel(x+3,y+15,c1);
            line(x+3,y+16,x+5,y+16);
            putpixel(x-1,y+13,c1);
            line(x-2,y+14,x-4,y+16);
            line(x-4,y+17,x-6,y+19);
            line(x-5,y+19,x-4,y+19);
             line(x-3,y+3,x-6,y+6);
             line(x-3,y+2,x-5,y+4);
             putpixel(x-3,y+1,c1);
             putpixel(x-6,y+7,c1);
             line(x+3,y+3,x+5,y+6);
             putpixel(x+3,y+3,c1);
             putpixel(x+6,y+6,c1);
             setcolor(c2);
             rectangle(x-6,y+8,x-5,y+9);
             rectangle(x+7,y+5,x+8,y+6);
                 setcolor(c4);
       if gun=1 then begin line(x-4,y+8,x-4,y+12);
                           line(x-7,y+10,x-5,y+10);
                           putpixel(x-3,y+11,c4);
                           putpixel(x-5,y+11,c4)
                     end;
       if gun=2 then begin line(x-3,y+5,x-3,y+15);
                           line(x-4,y+8,x-4,y+14);
                           line(x-5,y+10,x-6,y+10);
                           putpixel(x-5,y+8,c4);
                           putpixel(x-2,y+13,c4);
                           putpixel(x-1,y+12,c4)
                    end;
       if gun=3 then begin line(x-6,y+8,x-4,y+8);
                           line(x-5,y+9,x-4,y+10);
                           putpixel(x-4,y+9,c4);
                           line(x-3,y+7,x-3,y+11);
                           line(x-2,y+9,x-2,y+10);
                           line(x-4,y+12,x-4,y+14);
                           putpixel(x-3,y+12,c4)
                     end;
            end;
procedure an4(x,y,k:integer);
            var c1,c2,c3,c4:integer;
            begin
            if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
            man(x,y,c1,c2,c3);
            setcolor(c1);
            rectangle(x,y+9,x-1,y+11);
            putpixel(x-2,y+9,c1);
            line(x-2,y+10,x-6,y+10);
            putpixel(x,y+12,c1);
            line(x+1,y+12,x+2,y+13);
            putpixel(x-5,y+11,c1);
            line(x-6,y+11,x-4,y+13);
            putpixel(x-4,y+14,c1);
            putpixel(x-3,y+15,c1);
            line(x-3,y+16,x-5,y+16);
            putpixel(x+1,y+13,c1);
            line(x+2,y+14,x+4,y+16);
            line(x+4,y+17,x+6,y+19);
            line(x+5,y+19,x+4,y+19);
             line(x+3,y+3,x+6,y+6);
             line(x+3,y+2,x+5,y+4);
             putpixel(x+3,y+1,c1);
             putpixel(x+6,y+7,c1);
             line(x-3,y+3,x-5,y+6);
             putpixel(x-3,y+3,c1);
             putpixel(x-6,y+6,c1);
             setcolor(c2);
             rectangle(x+6,y+8,x+5,y+9);
             rectangle(x-7,y+5,x-8,y+6);
                 setcolor(c4);
      if gun=1 then begin line(x+4,y+8,x+4,y+12);
                          line(x+7,y+10,x+5,y+10);
                          putpixel(x+3,y+11,c4);
                          putpixel(x+5,y+11,c4)
                    end;
      if gun=2 then begin line(x+3,y+5,x+3,y+15);
                           line(x+4,y+8,x+4,y+14);
                           line(x+5,y+10,x+6,y+10);
                           putpixel(x+5,y+8,c4);
                           putpixel(x+2,y+13,c4);
                           putpixel(x+1,y+12,c4)
                    end;
       if gun=3 then begin line(x+6,y+8,x+4,y+8);
                           line(x+5,y+9,x+4,y+10);
                           putpixel(x+4,y+9,c4);
                           line(x+3,y+7,x+3,y+11);
                           line(x+2,y+9,x+2,y+10);
                           line(x+4,y+12,x+4,y+14);
                           putpixel(x+3,y+12,c4)
                     end;
            end;
procedure man5(x,y,k:integer);
            var c1,c2,c3,c4:integer;
            begin
            if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
            man(x,y,c1,c2,c3);
            setcolor(c1);
            rectangle(x,y+9,x+2,y+10);
            rectangle(x,y+11,x+1,y+12);
            putpixel(x+3,y+10,c1);
            line(x+3,y+11,x+5,y+13);
            line(x+2,y+11,x+5,y+14);
            line(x+6,y+15,x+6,y+17);
            line(x+10,y+17,x+8,y+19);
            putpixel(x+7,y+18,c1);
            rectangle(x-1,y+13,x,y+14);
            line(x-2,y+15,x-2,y+16);
            line(x-3,y+17,x-4,y+18);
            line(x-4,y+19,x-3,y+19);
            putpixel(x-5,y+18,c1);
             line(x-3,y+1,x-3,y+4);
            line(x+3,y+1,x+3,y+5);
            putpixel(x+3,y+7,c1);
            setcolor(c2);
            rectangle(x+1,y+6,x+2,y+7);
            rectangle(x+4,y+8,x+5,y+9);
                 setcolor(c4);
    if gun=1 then begin  line(x+3,y+7,x+8,y+7);
                         putpixel(x+7,y+6,c4);
                         putpixel(x+6,y+8,c4);
                         line(x+3,y+8,x+3,y+10)
                  end;
     if gun=2 then  begin line(x+1,y+6,x+11,y+6);
                               line(x+4,y+7,x+10,y+7);
                               line(x+6,y+8,x+6,y+9);
                               putpixel(x+4,y+8,c4);
                               putpixel(x+9,y+5,c4);
                               putpixel(x+10,y+4,c4);
                               putpixel(x+8,y+4,c4);
                               putpixel(x+9,y+3,c4)
                    end;
     if gun=3 then begin line(x+3,y+6,x+8,y+6);
                            line(x+8,y+7,x+11,y+7);
                            putpixel(x+8,y+6,c4);
                            line(x+4,y+7,x+4,y+9);
                            line(x+5,y+8,x+6,y+7);
                            putpixel(x+5,y+7,c4);
                            line(x+5,y+5,x+6,y+5)
                      end;
           end;
procedure an5(x,y,k:integer);
            var c1,c2,c3,c4:integer;
            begin
            if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
            man(x,y,c1,c2,c3);
            setcolor(c1);
            rectangle(x,y+9,x-2,y+10);
            rectangle(x,y+11,x-1,y+12);
            putpixel(x-3,y+10,c1);
            line(x-3,y+11,x-5,y+13);
            line(x-2,y+11,x-5,y+14);
            line(x-6,y+15,x-6,y+17);
            line(x-10,y+17,x-8,y+19);
            putpixel(x-7,y+18,c1);
            rectangle(x+1,y+13,x,y+14);
            line(x+2,y+15,x+2,y+16);
            line(x+3,y+17,x+4,y+18);
            line(x+4,y+19,x+3,y+19);
            putpixel(x+5,y+18,c1);
             line(x+3,y+1,x+3,y+4);
            line(x-3,y+1,x-3,y+5);
            putpixel(x-3,y+7,c1);
            setcolor(c2);
            rectangle(x-1,y+6,x-2,y+7);
            rectangle(x-4,y+8,x-5,y+9);
                 setcolor(c4);
     if gun=1 then begin  line(x-3,y+7,x-8,y+7);
                          putpixel(x-7,y+6,c4);
                          putpixel(x-6,y+8,c4);
                          line(x-3,y+8,x-3,y+10)
                   end;
     if gun=2 then  begin line(x-1,y+6,x-11,y+6);
                               line(x-4,y+7,x-10,y+7);
                               line(x-6,y+8,x-6,y+9);
                               putpixel(x-4,y+8,c4);
                               putpixel(x-9,y+5,c4);
                               putpixel(x-10,y+4,c4);
                               putpixel(x-8,y+4,c4);
                               putpixel(x-9,y+3,c4)
                    end;
     if gun=3 then begin line(x-3,y+6,x-8,y+6);
                            line(x-8,y+7,x-11,y+7);
                            putpixel(x-8,y+6,c4);
                            line(x-4,y+7,x-4,y+9);
                            line(x-5,y+8,x-6,y+7);
                            putpixel(x-5,y+7,c4);
                            line(x-5,y+5,x-6,y+5)
                      end;
           end;
procedure man6(x,y,k:integer);
            var c1,c2,c3,c4:integer;
            begin
            if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
            man(x,y,c1,c2,c3);
            setcolor(c1);
            rectangle(x,y+9,x+2,y+10);
            line(x,y+11,x+1,y+11);
            putpixel(x+3,y+10,c1);
            rectangle(x+3,y+11,x+4,y+12);
            rectangle(x+4,y+13,x+5,y+14);
            rectangle(x-1,y+12,x,y+14);
            putpixel(x+4,y+15,c1);
            line(x-1,y+15,x-5,y+15);
            line(x-6,y+16,x-6,y+17);
            line(x+4,y+15,x+4,y+19);
            line(x+5,y+19,x+6,y+19);
             line(x-3,y+3,x-6,y+6);
             line(x-3,y+2,x-5,y+4);
             putpixel(x-3,y+1,c1);
             putpixel(x-6,y+7,c1);
             line(x+3,y+3,x+5,y+6);
             putpixel(x+3,y+3,c1);
             putpixel(x+6,y+6,c1);
             setcolor(c2);
             rectangle(x-6,y+8,x-5,y+9);
             rectangle(x+7,y+5,x+8,y+6);
                    setcolor(c4);
   if gun=1 then begin line(x+11,y,x+7,y+4);
                       line(x+9,y+3,x+9,y+6);
                       putpixel(x+9,y,c4);
                       putpixel(x+10,y+2,c4);
                       putpixel(x+8,y+5,c4)
                 end;
   if gun=2 then begin line(x+5,y+4,x+12,y-3);
                       line(x+7,y+3,x+12,y-2);
                       line(x+9,y+2,x+10,y+4);
                       line(x+9,y-2,x+10,y-2);
                       putpixel(x+10,y-3,c4);
                       putpixel(x+8,y-3,c4);
                       putpixel(x+9,y-4,c4)
                   end;
    if gun=3 then begin line(x+6,y+6,x+11,y+6);
                            line(x+11,y+7,x+14,y+7);
                            putpixel(x+11,y+6,c4);
                            line(x+7,y+7,x+7,y+9);
                            line(x+8,y+8,x+9,y+7);
                            putpixel(x+8,y+7,c4);
                            line(x+8,y+5,x+9,y+5)
                      end;
            end;
procedure an6(x,y,k:integer);
            var c1,c2,c3,c4:integer;
            begin
            if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
            man(x,y,c1,c2,c3);
            setcolor(c1);
            rectangle(x,y+9,x-2,y+10);
            line(x,y+11,x-1,y+11);
            putpixel(x-3,y+10,c1);
            rectangle(x-3,y+11,x-4,y+12);
            rectangle(x-4,y+13,x-5,y+14);
            rectangle(x+1,y+12,x,y+14);
            putpixel(x-4,y+15,c1);
            line(x+1,y+15,x+5,y+15);
            line(x+6,y+16,x+6,y+17);
            line(x-4,y+15,x-4,y+19);
            line(x-5,y+19,x-6,y+19);
             line(x+3,y+3,x+6,y+6);
             line(x+3,y+2,x+5,y+4);
             putpixel(x+3,y+1,c1);
             putpixel(x+6,y+7,c1);
             line(x-3,y+3,x-5,y+6);
             putpixel(x-3,y+3,c1);
             putpixel(x-6,y+6,c1);
             setcolor(c2);
             rectangle(x+6,y+8,x+5,y+9);
             rectangle(x-7,y+5,x-8,y+6);
                   setcolor(c4);
     if gun=1 then begin line(x-11,y,x-7,y+4);
                         line(x-9,y+3,x-9,y+6);
                         putpixel(x-9,y,c4);
                         putpixel(x-10,y+2,c4);
                         putpixel(x-8,y+5,c4)
                   end;
    if gun=2 then begin line(x-5,y+4,x-12,y-3);
                       line(x-7,y+3,x-12,y-2);
                       line(x-9,y+2,x-10,y+4);
                       line(x-9,y-2,x-10,y-2);
                       putpixel(x-10,y-3,c4);
                       putpixel(x-8,y-3,c4);
                       putpixel(x-9,y-4,c4)
                   end;
   if gun=3 then begin line(x-6,y+6,x-11,y+6);
                            line(x-11,y+7,x-14,y+7);
                            putpixel(x-11,y+6,c4);
                            line(x-7,y+7,x-7,y+9);
                            line(x-8,y+8,x-9,y+7);
                            putpixel(x-8,y+7,c4);
                            line(x-8,y+5,x-9,y+5)
                      end;
            end;
procedure fir1(x,y,k:integer);
            var c1,c2,c3,c4:integer;
            begin
            if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
            man(x,y,c1,c2,c3);
            setcolor(c1);
          rectangle(x-1,y+9,x+2,y+10);
          rectangle(x-1,y+11,x,y+14);
          line(x-1,y+15,x-5,y+19);
          line(x-4,y+19,x-3,y+19);
          line(x+2,y+11,x+5,y+14);
          line(x+3,y+11,x+5,y+13);
          line(x+4,y+14,x+4,y+15);
          putpixel(x+5,y+14,c1);
          line(x+3,y+16,x+3,y+17);
          putpixel(x+2,y+18,c1);
          line(x+2,y+19,x+4,y+19);
                    rectangle(x+3,y+1,x+4,y+2);
                putpixel(x+5,y+1,c1);
                line(x+3,y+4,x+6,y+4);
             setcolor(c2);
             rectangle(x+6,y+1,x+7,y+2);
             rectangle(x+7,y+3,x+8,y+4);
               setcolor(c4);
             line(x+7,y+2,x+12,y+2);
             line(x+9,y+3,x+9,y+5);
             putpixel(x+11,y+1,c4);
             putpixel(x+7,y+3,c4);
            end;
procedure fir11(x,y,k:integer);
            var c1,c2,c3,c4:integer;
            begin
            if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
            man(x,y,c1,c2,c3);
            setcolor(c1);
          rectangle(x+1,y+9,x-2,y+10);
          rectangle(x+1,y+11,x,y+14);
          line(x+1,y+15,x+5,y+19);
          line(x+4,y+19,x+3,y+19);
          line(x-2,y+11,x-5,y+14);
          line(x-3,y+11,x-5,y+13);
          line(x-4,y+14,x-4,y+15);
          putpixel(x-5,y+14,c1);
          line(x-3,y+16,x-3,y+17);
          putpixel(x-2,y+18,c1);
          line(x-2,y+19,x-4,y+19);
                    rectangle(x-3,y+1,x-4,y+2);
                putpixel(x-5,y+1,c1);
                line(x-3,y+4,x-6,y+4);
             setcolor(c2);
             rectangle(x-6,y+1,x-7,y+2);
             rectangle(x-7,y+3,x-8,y+4);
               setcolor(c4);
             line(x-7,y+2,x-12,y+2);
             line(x-9,y+3,x-9,y+5);
             putpixel(x-11,y+1,c4);
             putpixel(x-7,y+3,c4);
            end;
procedure fir2(x,y,k:integer);
            var c1,c2,c3,c4:integer;
     begin
            if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
            man(x,y,c1,c2,c3);
            setcolor(c1);
          rectangle(x-1,y+9,x+2,y+10);
          rectangle(x-1,y+11,x,y+14);
          line(x-1,y+15,x-5,y+19);
          line(x-4,y+19,x-3,y+19);
          line(x+2,y+11,x+5,y+14);
          line(x+3,y+11,x+5,y+13);
          line(x+4,y+14,x+4,y+15);
          putpixel(x+5,y+14,c1);
          line(x+3,y+16,x+3,y+17);
          putpixel(x+2,y+18,c1);
          line(x+2,y+19,x+4,y+19);
                    rectangle(x+3,y+1,x+4,y+2);
                putpixel(x+5,y+1,c1);
                line(x+3,y+4,x+6,y+4);
             setcolor(c2);
             rectangle(x+6,y+1,x+7,y+2);
             rectangle(x+7,y+3,x+8,y+4);
                setcolor(c4);
                line(x+4,y+1,x+14,y+1);
                line(x+7,y+2,x+13,y+2);
                line(x+9,y+3,x+9,y+4);
                putpixel(x+7,y+3,c4);
                putpixel(x+11,y,c4);
                putpixel(x+10,y-1,c4);
                putpixel(x+12,y-1,c4);
                putpixel(x+11,y-2,c4)
  end;
procedure fir22(x,y,k:integer);
            var c1,c2,c3,c4:integer;
     begin
            if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
            man(x,y,c1,c2,c3);
            setcolor(c1);
             rectangle(x+1,y+9,x-2,y+10);
          rectangle(x+1,y+11,x,y+14);
          line(x+1,y+15,x+5,y+19);
          line(x+4,y+19,x+3,y+19);
          line(x-2,y+11,x-5,y+14);
          line(x-3,y+11,x-5,y+13);
          line(x-4,y+14,x-4,y+15);
          putpixel(x-5,y+14,c1);
          line(x-3,y+16,x-3,y+17);
          putpixel(x-2,y+18,c1);
          line(x-2,y+19,x-4,y+19);
                    rectangle(x-3,y+1,x-4,y+2);
                putpixel(x-5,y+1,c1);
                line(x-3,y+4,x-6,y+4);
             setcolor(c2);
             rectangle(x-6,y+1,x-7,y+2);
             rectangle(x-7,y+3,x-8,y+4);
                setcolor(c4);
                line(x-4,y+1,x-14,y+1);
                line(x-7,y+2,x-13,y+2);
                line(x-9,y+3,x-9,y+4);
                putpixel(x-7,y+3,c4);
                putpixel(x-11,y,c4);
                putpixel(x-10,y-1,c4);
                putpixel(x-12,y-1,c4);
                putpixel(x-11,y-2,c4)
  end;
procedure fir3(x,y,k:integer);
                    var c1,c2,c3,c4:integer;
     begin
            if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
            man(x,y,c1,c2,c3);
            setcolor(c1);
          rectangle(x-1,y+9,x+2,y+10);
          rectangle(x-1,y+11,x,y+14);
          line(x-1,y+15,x-5,y+19);
          line(x-4,y+19,x-3,y+19);
          line(x+2,y+11,x+5,y+14);
          line(x+3,y+11,x+5,y+13);
          line(x+4,y+14,x+4,y+15);
          putpixel(x+5,y+14,c1);
          line(x+3,y+16,x+3,y+17);
          putpixel(x+2,y+18,c1);
          line(x+2,y+19,x+4,y+19);
                    rectangle(x+3,y+1,x+4,y+2);
                putpixel(x+5,y+1,c1);
                line(x+3,y+4,x+6,y+4);
             setcolor(c2);
             rectangle(x+6,y+1,x+7,y+2);
             rectangle(x+7,y+3,x+8,y+4);
                setcolor(c4);
                line(x+8,y,x+9,y);
                line(x+6,y+1,x+11,y+1);
                line(x+11,y+2,x+14,y+2);
                line(x+7,y+2,x+7,y+4);
                line(x+8,y+2,x+8,y+3);
                putpixel(x+9,y+2,c4)
      end;
procedure fir33(x,y,k:integer);
                    var c1,c2,c3,c4:integer;
     begin
            if k=0 then begin c1:=0; c2:=0; c3:=0;c4:=0 end else begin c1:=10;c2:=14;c3:=9;c4:=13 end;
            man(x,y,c1,c2,c3);
            setcolor(c1);
          rectangle(x+1,y+9,x-2,y+10);
          rectangle(x+1,y+11,x,y+14);
          line(x+1,y+15,x+5,y+19);
          line(x+4,y+19,x+3,y+19);
          line(x-2,y+11,x-5,y+14);
          line(x-3,y+11,x-5,y+13);
          line(x-4,y+14,x-4,y+15);
          putpixel(x-5,y+14,c1);
          line(x-3,y+16,x-3,y+17);
          putpixel(x-2,y+18,c1);
          line(x-2,y+19,x-4,y+19);
                    rectangle(x-3,y+1,x-4,y+2);
                putpixel(x-5,y+1,c1);
                line(x-3,y+4,x-6,y+4);
             setcolor(c2);
             rectangle(x-6,y+1,x-7,y+2);
             rectangle(x-7,y+3,x-8,y+4);
                setcolor(c4);
                line(x-8,y,x-9,y);
                line(x-6,y+1,x-11,y+1);
                line(x-11,y+2,x-14,y+2);
                line(x-7,y+2,x-7,y+4);
                line(x-8,y+2,x-8,y+3);
                putpixel(x-9,y+2,c4)
      end;
procedure ifa(nom,c:integer);
             begin
             if nom=7 then begin nom:=1;no:=1 end;
             if nom=1 then man1(r,t,c);
             if nom=2 then man2(r,t,c);
             if nom=3 then man3(r,t,c);
             if nom=4 then man4(r,t,c);
             if nom=5 then man5(r,t,c);
             if nom=6 then man6(r,t,c)
             end;
procedure ifu(nom,c:integer);
             begin
             if nom=7 then begin nom:=1;no:=1 end;
             if nom=1 then an1(r,t,c);
             if nom=2 then an2(r,t,c);
             if nom=3 then an3(r,t,c);
             if nom=4 then an4(r,t,c);
             if nom=5 then an5(r,t,c);
             if nom=6 then an6(r,t,c)
             end;

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
procedure od1(x,y:integer);
   var j,f,c:integer;
        begin
        c:= trunc(random(14)+1);
        for f:= 1 to y do begin
                          setcolor(c);
                          putpixel(x,f,c);
                          setcolor(0);
                          putpixel(x,f,0)
                          end;
        setcolor(c);
        putpixel(x,y,c)
        end;
procedure od(x,y:integer);
   var f,c:integer;
        begin
        c:= trunc(random(14)+1);
        for f:= 1 to 1000 do setcolor(c);
        putpixel(x,y,c);
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
     var f:integer;
    begin
     for f:= 12 to 36 do foy(228,72,f);
     for f:= 228 downto 216 do fox(588,624,f);
     for f:= 228 downto 216 do fox(168,228,f);
     for f:= 108 downto 72 do fox(456,468,f);
     for f:= 276 to 300 do foy(228,84,f);
     for f:= 612 to 636 do foy(216,144,f);
     for f:= 168 downto 156 do fox(36,96,f);
     for f:= 228 downto 216 do fox(348,408,f);
     for f:= 492 to 504 do foy(180,156,f);
     for f:= 228 to 252 do foy(228,180,f);
     for f:= 216 downto 192 do fox(564,600,f);
     for f:= 96 to 120 do foy(228,72,f);
     for f:= 156 downto 132 do fox(348,384,f);
     for f:= 144 downto 132 do fox(576,624,f);
     for f:= 24 to 108 do foy(72,60,f);
     for f:= 516 to 540 do foy(228,60,f);
     for f:= 72 downto 60 do fox(276,300,f);
     for f:= 468 to 480 do foy(132,108,f);
     for f:= 72 downto 60 do fox(348,408,f);
     for f:= 96 downto 72 do fox(600,636,f);
     for f:= 144 to 168 do foy(228,60,f);
     for f:= 564 to 588 do foy(132,72,f);
     for f:= 324 to 348 do foy(228,60,f);
     for f:= 504 to 516 do foy(216,180,f);
     for f:= 72 downto 60 do fox(576,612,f);
     for f:= 480 to 492 do foy(156,132,f);
     for f:= 432 to 456 do foy(228,60,f)
    end;
procedure titri;
      var f:integer;
      begin
      cleardevice;
      f:=3000;
      settextstyle(1,0,6);
       repeat
             f:= f-5;
             setcolor(15);
             outtextxy(150,f,'1999  year');
             outtextxy(100,f+200,'OIV  Company');
             outtextxy(150,f+260,'presents...');
             setcolor(0);
             outtextxy(150,f,'1999  year');
             outtextxy(100,f+200,'OIV  Company');
             outtextxy(150,f+260,'presents...');
      until (f=-3000);
      end;
procedure titri2;
      var f,l,t:integer;
      begin
      cleardevice;
      settextstyle(1,0,4);
      t:=0;
      repeat
        l:=0; t:=t+1;
       for f:= 0 to 19 do
                      begin
                       setcolor(14);
                       outtextxy(180+l,200+f,'O');
                       setcolor(10);
                       outtextxy(200+l,220-f,'I');
                       setcolor(9);
                       outtextxy(220+l,200+f,'V');
                       setcolor(12);
                       outtextxy(240+l,220-f,'C');
                       setcolor(11);
                       outtextxy(260+l,200+f,'o');
                       setcolor(13);
                       outtextxy(280+l,220-f,'m');
                       setcolor(6);
                       outtextxy(300+l,200+f,'p');
                       setcolor(14);
                       outtextxy(320+l,220-f,'a');
                       setcolor(10);
                       outtextxy(340+l,200+f,'n');
                       setcolor(9);
                       outtextxy(360+l,220-f,'y');
                       setcolor(0);
                       outtextxy(180+l,200+f,'O');
                       outtextxy(200+l,220-f,'I');
                       outtextxy(220+l,200+f,'V');
                       outtextxy(240+l,220-f,'C');
                       outtextxy(260+l,200+f,'o');
                       outtextxy(280+l,220-f,'m');
                       outtextxy(300+l,200+f,'p');
                       outtextxy(320+l,220-f,'a');
                       outtextxy(340+l,200+f,'n');
                       outtextxy(360+l,220-f,'y');
                      end;
       for f:= 0 to 19 do
                        begin
                         setcolor(14);
                         outtextxy(180+l,220-f,'O');
                         setcolor(10);
                         outtextxy(200+l,200+f,'I');
                         setcolor(9);
                         outtextxy(220+l,220-f,'V');
                         setcolor(12);
                         outtextxy(240+l,200+f,'C');
                         setcolor(11);
                         outtextxy(260+l,220-f,'o');
                         setcolor(13);
                         outtextxy(280+l,200+f,'m');
                         setcolor(6);
                         outtextxy(300+l,220-f,'p');
                         setcolor(14);
                         outtextxy(320+l,200+f,'a');
                         setcolor(10);
                         outtextxy(340+l,220-f,'n');
                         setcolor(9);
                         outtextxy(360+l,200+f,'y');
                         setcolor(0);
                         outtextxy(180+l,220-f,'O');
                         outtextxy(200+l,200+f,'I');
                         outtextxy(220+l,220-f,'V');
                         outtextxy(240+l,200+f,'C');
                         outtextxy(260+l,220-f,'o');
                         outtextxy(280+l,200+f,'m');
                         outtextxy(300+l,220-f,'p');
                         outtextxy(320+l,200+f,'a');
                         outtextxy(340+l,220-f,'n');
                         outtextxy(360+l,200+f,'y');
                        end;
         until t=15;
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
    settextstyle(3,0,4);setcolor(9);outtextxy(200,440,'Company Ltd.');
    settextstyle(4,0,1);setcolor(1);outtextxy(100,1,'Press any key...');
 b:= ReadKey ; ClearDevice;setBkcolor(0);
 END;
procedure fire1(x,y:integer);
          var l,f,a,b:integer;
          begin
          a:=0 ;
          for f:= (x+16) to 600 do begin
                                   a:=a+1;setcolor(14);
                                   if a=3 then a:=1;
                                   circle(f,y+1,a);
                 for l:=1 to 700 do begin setcolor(0) end;
                                   circle(f,y+1,a)
                                   end;
          end;
 procedure fire11(x,y:integer);
          var l,f,a,b:integer;
          begin
          a:=0 ;
          for f:= (x-16) downto 0 do begin
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
          for f:= 1 to 100 do begin
                              a:=trunc(random(6)+x+14);
                              b:=trunc(random(5)+y);
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
  procedure fire22(x,y:integer);
          var a,b,f:integer;l:word;
          begin
          for f:= 1 to 100 do begin
                              a:=trunc(random(6)+x-19);
                              b:=trunc(random(5)+y);
                              putpixel(a,b,7);
                           for l:=1 to 60000 do begin end;
                              putpixel(a,b,0)
                              end;
          for f:= (x-24) downto 0 do begin
                                   a:=trunc(random(4)+f+4);
                                   b:=trunc(random(3)+y-2);
                                   setcolor(9);
                               line(f,y-1,f-6,y-1);
                               line(f-4,y-2,f-4,y);
                               setcolor(12);
                               line(a+1,b,a,b);
                          for l:= 1 to 60000 do begin end;
                                   setcolor(0);
                               line(f,y-1,f-6,y-1);
                               line(f-4,y-2,f-4,y);
                               line(a+1,b,a,b)
                                   end;
         end;
procedure fire3(x,y:integer);
         var j,f,l:integer;
         begin
       for j:= 1 to 100 do
     begin
          for f:= 1 to 70 do if trunc(random(2))=1 then putpixel(x+14+f,y+2,12);
          for f:=1 to 40 do
              for l:= 1 to 2 do if trunc(random(2))=1 then putpixel(x+44+f,y-1+l,12);
         { for f:= 1 to 20 do
              for l:= 1 to 5 do if trunc(random(2))=1 then putpixel(x+74+f,y-2-l,12);}
          for l:= 1 to 5 do if trunc(random(2))=1 then putpixel(x+85,y+2-l,12);
          for l:= 1 to 6 do if trunc(random(2))=1 then putpixel(x+86,y-4+l,12);
          for l:= 1 to 8 do if trunc(random(2))=1 then putpixel(x+87,y-6+l,12);
          for l:= 1 to 10 do if trunc(random(2))=1 then putpixel(x+88,y-7+l,12);
          for f:= 1 to 2 do
              for l:= 1 to 12 do if trunc(random(2))=1 then putpixel(x+88+f,y-10+l,12);
          for l:= 1 to 14 do if trunc(random(2))=1 then putpixel(x+91,y-11+l,12);
          for l:= 1 to 16 do if trunc(random(2))=1 then putpixel(x+92,y-13+l,12);
          for l:= 1 to 17 do if trunc(random(2))=1 then putpixel(x+93,y-13+l,12);
          for l:= 1 to 18 do if trunc(random(2))=1 then putpixel(x+94,y-14+l,12);
          for f:= 1 to 2 do
              for l:= 1 to 19 do if trunc(random(2))=1 then putpixel(x+94+f,y-14+l,12);
          for f:= 1 to 4 do
              for l:= 1 to 20 do if trunc(random(2))=1 then putpixel(x+96+f,y-15+l,12);
          for l:= 1 to 18 do if trunc(random(2))=1 then putpixel(x+101,y-14+l,12);
          for l:= 1 to 17 do if trunc(random(2))=1 then putpixel(x+102,y-13+l,12);
          for l:= 1 to 13 do if trunc(random(2))=1 then putpixel(x+103,y-11+l,12);
          for l:= 1 to 7  do if trunc(random(2))=1 then putpixel(x+104,y-8+l,12);
          setcolor(0);
      for f:= 1 to 25 do line(x+15,y-20+f,x+104,y-20+f);
          sound(40000);
          delay(100);
          nosound;
       end;
   end;
procedure fire33(x,y:integer);
         var j,f,l:integer;
         begin
       for j:= 1 to 100 do
     begin
          for f:= 1 to 70 do if trunc(random(2))=1 then putpixel(x-14-f,y+2,12);
          for f:=1 to 40 do
              for l:= 1 to 2 do if trunc(random(2))=1 then putpixel(x-44-f,y-1+l,12);
         { for f:= 1 to 20 do
              for l:= 1 to 5 do if trunc(random(2))=1 then putpixel(x-74-f,y-2-l,12);}
          for l:= 1 to 5 do if trunc(random(2))=1 then putpixel(x-85,y+2-l,12);
          for l:= 1 to 6 do if trunc(random(2))=1 then putpixel(x-86,y-4+l,12);
          for l:= 1 to 8 do if trunc(random(2))=1 then putpixel(x-87,y-6+l,12);
          for l:= 1 to 10 do if trunc(random(2))=1 then putpixel(x-88,y-7+l,12);
          for f:= 1 to 2 do
              for l:= 1 to 12 do if trunc(random(2))=1 then putpixel(x-88-f,y-10+l,12);
          for l:= 1 to 14 do if trunc(random(2))=1 then putpixel(x-91,y-11+l,12);
          for l:= 1 to 16 do if trunc(random(2))=1 then putpixel(x-92,y-13+l,12);
          for l:= 1 to 17 do if trunc(random(2))=1 then putpixel(x-93,y-13+l,12);
          for l:= 1 to 18 do if trunc(random(2))=1 then putpixel(x-94,y-14+l,12);
          for f:= 1 to 2 do
              for l:= 1 to 19 do if trunc(random(2))=1 then putpixel(x-94-f,y-14+l,12);
          for f:= 1 to 4 do
              for l:= 1 to 20 do if trunc(random(2))=1 then putpixel(x-96-f,y-15+l,12);
          for l:= 1 to 18 do if trunc(random(2))=1 then putpixel(x-101,y-14+l,12);
          for l:= 1 to 17 do if trunc(random(2))=1 then putpixel(x-102,y-13+l,12);
          for l:= 1 to 13 do if trunc(random(2))=1 then putpixel(x-103,y-11+l,12);
          for l:= 1 to 7  do if trunc(random(2))=1 then putpixel(x-104,y-8+l,12);
          sound(200);
          delay(2000);
          nosound;
          setcolor(0);
      for f:= 1 to 25 do line(x-15,y-20+f,x-104,y-20+f);

       end;
   end;
procedure wind;
  var f:integer;
 begin
    setcolor(13);
    rectangle(0,350,639,479);
    rectangle(2,352,637,477);
    setcolor(10);
    rectangle(4,354,54,384);
    setcolor(9);
    rectangle(4,386,54,475);
     gon:=gun;
     gun:=0;
    man1(20,400,1);
    gun:=gon;
    setcolor(6);
    circle(20,440,10);
    setcolor(14);
    settextstyle(0,0,1);
    outtextxy(18,437,'1');
    setcolor(11);
    rectangle(56,354,206,475);
    settextstyle(3,0,1);
    outtextxy(60,360,'Energy');
    if ene<>enu then begin
                     enu:=ene;
                     setcolor(0);
                     for f:= 1 to 100 do line(160,471-f,180,471-f);
                     setcolor(12);
                     for f:= 1 to ene do line(160,471-f,180,471-f);
                     settextstyle(10,0,1);setcolor(9);
                     outtextxy(135,460,'0 %');
                     outtextxy(127,415,'50 %');
                     outtextxy(120,370,'100 %')
                   end;
    setcolor(10);
    rectangle(208,354,508,475);
    setcolor(0);
    if gun<>gan then  for f:=1 to 299 do line(208+f,355,208+f,474);
    if gun=1 then begin
                   gan:=gun;
                   setcolor(9);
                   line(238,374,348,374);
                   line(348,374,348,394);
                   line(348,394,258,394);
                   line(258,394,248,404);
                   line(248,404,248,434);
                   line(248,434,238,444);
                   line(238,444,218,454);
                   line(218,454,218,394);
                   line(218,394,238,374);
                    line(248,384,258,384);
                    line(258,384,238,404);
                    line(238,404,238,424);
                    line(238,424,228,434);
                    line(228,434,228,404);
                    line(228,404,248,384);
                     line(298,394,278,414);
                     line(278,414,248,414);
                      line(268,394,258,404);
                      line(258,404,258,394);
                       line(328,374,338,364);
                       line(338,364,338,374);
                        rectangle(318,379,338,389);
                         rectangle(349,376,353,386);
                   setfillstyle(1,1);
                   floodfill(298,384,9);
                   floodfill(337,373,9);
                   floodfill(259,395,9);
                   setfillstyle(6,6);
                   floodfill(328,384,9);
                   floodfill(238,396,9);
                   settextstyle(2,0,6);
                   outtextxy(360,364,'Weapon: fine gun');
                   outtextxy(360,384,'Power : 10 %');
                   outtextxy(360,404,'Status:');
                   setcolor(13);
                   for f:= 0 to fine*2 do line(298+f,444,298+f,464);
                   if fine<>fune then
                                  begin
                                    fune:=fine;
                                    setcolor(0);
                                    for f:= 0 to 200 do line(298+f,444,298+f,464);
                                    setcolor(13);
                                    for f:= 0 to fine*2 do line(298+f,444,298+f,464);
                                  end;
                  end;

     if gun=2 then begin
                    gan:=gun;
                    setcolor(10);
                    line(218,384,348,384);
                    line(348,384,348,404);
                    line(348,404,328,404);
                    line(328,404,323,409);
                    line(323,409,303,409);
                    line(303,409,298,404);
                    line(298,404,268,404);
                    line(268,404,238,434);
                    line(238,434,238,424);
                    line(238,424,248,414);
                    line(248,414,248,404);
                    line(248,404,228,404);
                    line(228,404,228,394);
                    line(228,394,218,384);
                     line(268,383,268,378);
                     line(268,378,258,378);
                     line(258,378,258,374);
                     line(258,374,288,374);
                     line(288,374,288,378);
                     line(288,378,273,378);
                     line(273,378,273,383);
                      line(328,383,328,379);
                      circle(328,375,4);
                      putpixel(328,375,2);
                       rectangle(349,389,353,399);
                        rectangle(273,389,323,399);
                        setfillstyle(1,2);
                        floodfill(238,394,10);
                        floodfill(268,375,10);
                        setfillstyle(11,6);
                        floodfill(298,394,10);
                        settextstyle(2,0,6);
                        setcolor(9);
                        outtextxy(360,364,'Weapon: Missle');
                        outtextxy(360,384,'Power : 20 %');
                        outtextxy(360,404,'Status:');
                        setcolor(13);
                        for f:= 0 to mis*2 do line(298+f,444,298+f,464);
                        if mis<>mos then
                                  begin
                                    mos:=mis;
                                    setcolor(0);
                                    for f:= 0 to 200 do line(298+f,444,298+f,464);
                                    setcolor(13);
                                    for f:= 0 to mis*2 do line(298+f,444,298+f,464);
                                  end;
                   end;
     if gun=3 then begin
                    gan:=gun;
                    setcolor(6);
                    line(228,394,258,394);
                    line(258,394,268,384);
                    line(268,384,308,384);
                    line(308,384,328,404);
                    line(328,404,348,404);
                    line(348,404,348,409);
                    line(348,409,338,409);
                    line(338,409,338,414);
                    line(338,414,318,414);
                    line(318,414,308,404);
                    line(308,404,268,404);
                    line(268,404,258,414);
                    line(258,414,248,414);
                    line(248,414,238,424);
                    line(238,424,238,444);
                    line(238,444,228,444);
                    line(228,444,218,434);
                    line(218,434,218,414);
                    line(218,414,228,404);
                    line(228,404,228,394);
                     rectangle(273,389,303,399);
                     setfillstyle(1,4);
                     floodfill(238,395,6);
                     setfillstyle(9,5);
                     floodfill(298,394,6);
                     settextstyle(2,0,6);
                     setcolor(9);
                     outtextxy(360,364,'Weapon: fire gun');
                     outtextxy(360,384,'Power : 40 %');
                     outtextxy(360,404,'Status:');
                    setcolor(13);
                        for f:= 0 to fire*2 do line(298+f,444,298+f,464);
                        if fire<>fore then
                                  begin
                                    fore:=fire;
                                    setcolor(0);
                                    for f:= 0 to 200 do line(298+f,444,298+f,464);
                                    setcolor(13);
                                    for f:= 0 to fire*2 do line(298+f,444,298+f,464);
                                  end;
                   end;
     if comp<>camp then begin
                        camp:=comp;
                        setcolor(12);
                        rectangle(510,354,634,474);
                        settextstyle(7,0,1);
                        setcolor(10);
                        outtextxy(515,370,'Complete');
                        outtextxy(540,420,'0  %');
                      end;
    end;
procedure keys;
   var xx:integer; kk:string; hh:char;
      begin
          cleardevice;
          settextstyle(7,0,6);
          setfillstyle(7,6);
          setcolor(6);
          rectangle(30,30,610,450);
          floodfill(31,31,6);
          setcolor(11);
          outtextxy(200,50,'Options');
          outtextxy(210,200,'Start');
          outtextxy(210,250,'Keys');
          outtextxy(210,300,'Game');
          xx:=200; kk:='Start';
          setcolor(13);
          outtextxy(210,xx,kk);
     repeat
          hh:= readkey ;
    if hh=' ' then
         begin
            setcolor(11);
            outtextxy(210,xx,kk);
             xx:=xx+50;
             if xx=350 then xx:=200;
            if xx=200 then kk:='Start';
            if xx=250 then kk:='Keys';
            if xx=300 then kk:='Game';
            setcolor(13);
            outtextxy(210,xx,kk)
         end;
    until hh='m';
    if xx=250 then begin
                      cleardevice;
                      settextstyle(7,0,4);
                      setfillstyle(7,6);
                      setcolor(6);
                      rectangle(30,30,610,450);
                      floodfill(31,31,6);
                      setcolor(11);
                      outtextxy(200,50,'Keys');
                      outtextxy(190,150,'left -');
                      lefts:=readkey;
                      outtextxy(300,150,lefts);
                      outtextxy(190,200,'right-');
                      right:=readkey;
                      outtextxy(310,200,right);
                      outtextxy(190,250,'fire -');
                      fi:= readkey;
                      outtextxy(300,250,fi);
                      outtextxy(190,300,'go   -');
                      go:= readkey;
                      outtextxy(300,300,go);
                      outtextxy(190,350,'select-');
                      select:= readkey;
                      outtextxy(320,350,select);
                      hh:= readkey;
                   end;
       end;
procedure zone2;
 var f,l,k:integer;
 begin
    setcolor(6);
    line(0,80,640,80);
    line(360,80,400,40);
    line(400,40,410,80);
    line(410,80,440,60);
    line(440,60,460,80);
    line(460,80,480,40);
    line(480,40,500,80);
    line(500,80,520,60);
    line(520,60,530,80);
    setfillstyle(1,6);
    floodfill(440,79,6);
    floodfill(380,79,6);
    floodfill(480,79,6);
    floodfill(520,79,6);
    setcolor(2);
    rectangle(0,200,640,350);
    for f:=1 to 30 do line(0,200+5*f,640,200+5*f);
    for f:=1 to 30 do
            begin
                if odd(f)=true then k:=-5
                               else k:=0;
                for l:=1 to 64 do line(10*l+k,195+5*f,10*l+k,195+5*f+5);
            end;
       line(539,200,539,350);
       line(580,200,580,350);
    setcolor(9);
    line(360,140,380,120);
    line(380,120,640,120);
    line(640,120,640,140);
    line(640,140,360,140);
    setfillstyle(11,9);
    floodfill(380,139,9);
    line(639,140,639,199);

    setcolor(0);
    for f:=1 to 40 do line(539+f,200,539+f,350);
    setcolor(10);
    for f:=1 to 3 do line(540,199+f,580,199+f);

        etaj1x:=630;etaj1y:=0
 end;
procedure lift(x,y,tot:integer);
 var f,l,n:integer;
   begin
    no:=1;
     for f:=y to tot do
                     begin
                       if left=0 then  ifa(no,1);
                       if left=1 then  ifu(no,1);
                       setcolor(10);
                       for l:=1 to 3 do line(x,f,x+40,f);
                       if left=0 then  ifa(no,0);
                       if left=1 then  ifu(no,0);
                       setcolor(0);
                       for l:=1 to 3 do line(x,f,x+40,f);
                       t:=t+1;
                       for l:= 1 to 10 do begin for n:=1 to 20000
                                       do begin end;
                                          end;
                     end;
   end;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then begin writeln('инициализация не закончена!');
   halt end;
oiv;
 life:=1;
  no:=0;
   r:=20;
    t:=180;
     gun:=1;
      gan:=1;
      left:=0;
       beg:=0;
           fine:=20;
            fune:=20;
             mis:=10;
              mos:=10;
               fire:=2;
                fore:=0;
                 comp:=0;
                  lefts:='o';
                   right:='p';
                   select:='z';
                   fi:=' ';
                    go:='x';
                     zones:=2;
 cleardevice;
 keys;
 cleardevice;
 {titri;
 titri2;
 oddworld;}
 zone2;
 wind;
    ene:=100; enu:=9; wind; enu:=100;
    p:='Шаг';settextstyle(1,0,1);setcolor(14);outtextxy(13,360,p);
    settextstyle(2,0,7);
  ooo:
    repeat

    h:= ReadKey ;
    until ( (h=select) or (h=go) or (h=lefts) or (h=right)
     or (h=fi) or (h='q') );
    if left=0 then  ifa(no,0);
    if left=1 then  ifu(no,0);

    if h='q' then halt;
    if zones=2 then
             if (r>550) and (r<570) and (h=fi) then
                              begin
                                  lift(540,200,349);
                                  goto ooo
                              end;
    if h=go then  begin
                beg:=beg+1;
                settextstyle(1,0,1);
              setcolor(0);
              outtextxy(13,360,p);
                 if beg=2 then begin
                               beg:=0;
                                p:='Шаг'
                                 end
                                  else
                                   p:='Бег';

                      setcolor(14);
                      outtextxy(13,360,p)
                   end;
    if (h=right) and (beg=0) then begin left:=0; r:=r+2; no:=no+1 end;
    if (h=lefts) and (beg=0) then begin left:=1; r:=r-2; no:=no+1 end;
    if (h=right) and (beg=1) then begin left:=0; r:=r+7; no:=no+1 end;
    if (h=lefts) and (beg=1) then begin left:=1; r:=r-7; no:=no+1 end;
    if (h=fi) and (gun=1) and (left=0) and (fine>0) then begin  fine:=fine-1;fir1(r,t,1);fire1(r,t);fir1(r,t,0);no:=1 end;
    if (h=fi) and (gun=1) and (left=1) and (fine>0) then begin  fine:=fine-1;fir11(r,t,1);fire11(r,t);fir11(r,t,0);no:=1 end;
    if (h=fi) and (gun=2) and (left=0) and (mis>0)  then begin  mis:=mis-1;fir2(r,t,1); fire2(r,t); fir2(r,t,0); no:=1 end;
    if (h=fi) and (gun=2) and (left=1) and (mis>0)  then begin  mis:=mis-1;fir22(r,t,1); fire22(r,t); fir22(r,t,0); no:=1 end;
    if (h=fi) and (gun=3) and (left=0) and (fire>0) and (r+103<etaj1x) then begin
                                   fire:=fire-1; fir3(r,t,1); fire3(r,t); fir3(r,t,0); no:=1 end;
    if (h=fi) and (gun=3) and (left=1) and (fire>0) and (r-103>0) then begin  fire:=fire-1; fir33(r,t,1);
                                                          fire33(r,t); fir33(r,t,0); no:=1 end;
    if h=select then begin gun:=gun+1;if gun=4 then gun:=1 end;
           if r+10>etaj1x then r:=etaj1x-10;
               if left=0 then  ifa(no,1);
               if left=1 then  ifu(no,1);
      wind;
       goto ooo;
CloseGraph;
end.