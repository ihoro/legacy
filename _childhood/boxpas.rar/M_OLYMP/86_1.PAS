program BezTrPov_M_Olymp86_1;
const N = 50;
label Finish;
var
   A:array[1..N] of Boolean;
   K,F,L,D:Integer;
   I:1..N;
   OkNo:Boolean;
begin
A[1]:=true;
for F:=2 to N do A[F]:=false;
I:=1;
while I<>N+1 do
begin
  if I>=3 then
    begin
      OkNo:=true;
      for D:=1 to (I div 3) do
        for L:=1 to I do
          if (L+3*D-1) > I then L:=I
                           else
            begin
              K:=0;
              for F:=1 to D do
                if (A[L+F-1]=A[L+D+F-1]) and (A[L+D+F-1]=A[L+2*D+F-1]) then K:=K+1;
              if K=D then
                begin
                  OkNo:=false;
                  L:=I-2*D;
                  D:=I div 3
                end
            end;
      if OkNo and (I=N) then goto Finish;
      if OkNo then
        begin
          I:=I+1;
          for F:=I to N do
            if not A[F] then
              begin
                A[F]:=true;
                F:=N
              end
                        else
              A[F]:=false;
        end
              else
        begin
          for F:=I downto 1 do
            if not A[F] then
              begin
                A[F]:=true;
                F:=1
              end
                        else
              A[F]:=false
        end
    end
       else I:=I+1
end;
Finish:
 for F:=1 to N do
   if A[F] then write('1')
           else write('0');
readln
end.