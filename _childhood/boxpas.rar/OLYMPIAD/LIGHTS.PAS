uses Dos;
var
    inp:text;
    TotalN:2..300;
    TotalM:1..14000;
    StartN,FinishN:1..300;
    Per:array[2..300] of
          record
            C:Char;
            R:0..100;
            Tb,Tp:1..100
          end;
    Way:array[1..14000] of
          record
            i,j:1..14000;
            Lij:1..100
          end;
    h:Char;
    f,l:integer;
    MinTime:LongInt;
    Z:array[1..300] of Boolean;
    M:array[1..300] of
        record
          Num:1..300;
          VibW:1..4
        end;
    KP:array[1..300] of
         record
           TotalW:1..4;
           mW:array[1..4] of 1..300;
         end;
begin
Assign(inp,'lights.inp');
Reset(inp);
read(inp,StartN);read(inp,h);readln(inp,FinishN);
read(inp,TotalN);read(inp,h);readln(inp,TotalM);
for f:=1 to TotalN do
  begin
    read(inp,Per[f].C);read(inp,h);
    read(inp,Per[f].R);read(inp,h);
    read(inp,Per[f].Tb);read(inp,h);
    readln(inp,Per[f].Tp)
  end;
for f:=1 to TotalM do
  begin
    read(inp,Way[f].i);read(inp,h);
    read(inp,Way[f].j);read(inp,h);
    readln(inp,Way[f].Lij)
  end;
Close(inp);
for f:=1 to TotalN do Z[f]:=false;

end.