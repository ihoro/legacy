program Rectangles_M_Olymp82_1;
const
     X = 6;
     Y = 6;
var
   R:array[1..X,1..Y] of 0..1;
   F,L:byte;
   Rec:Word;
begin
writeln;
for L:=1 to Y do
  for F:=1 to X do
    begin
      Write(' Point[',F,',',L,'] = ');
      ReadLn(R[F,L])
    end;
Rec:=0;
for L:=1 to Y do
  for F:=1 to X do
   if R[F,L]=1 then
    begin
      if (F=1) and (L=1) then Rec:=Rec+1;
      if (L=1) and (F<>1) and (R[F-1,L]=0) then Rec:=Rec+1;
      if (F=1) and (L<>1) and (R[F,L-1]=0) then Rec:=Rec+1;
      if (F<>1) and (L<>1) and (R[F-1,L]=0) and (R[F,L-1]=0) then Rec:=Rec+1
    end;
WriteLn('Всего прямоугольников: ',Rec);
ReadLn
end.