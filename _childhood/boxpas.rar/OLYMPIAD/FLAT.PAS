uses Dos;
const
      MaxColon = 200;
      MaxCaps = 2000;
      InputFileName = 'flat.inp';
      OutputFileName = 'flat.out';
type
     CapsType = 0..MaxCaps;
     ColonType = 1..MaxColon;
var
    DataFile:Text;
    n:2..MaxColon;
    c:array[ColonType] of CapsType;
    f:integer;
    h:Char;
    k:0..MaxColon;
    All:0..MaxCaps*MaxColon;
    Min:ColonType;
    Ok:Boolean;
    M:LongInt;
    Hod:array[1..2000] of
          record
            p:1..MaxColon;
            m:0..MaxCaps*MaxColon
          end;
begin
Assign(DataFile,InputFileName);
Reset(DataFile);
readln(DataFile,n);
for f:=1 to n do
  begin
    read(DataFile,c[f]);
    if not EOF(DataFile) then read(DataFile,h)
  end;
Close(DataFile);
All:=0;
for f:=1 to n do All:=All+c[f];
k:=All div n;
M:=0;
repeat
Min:=1;
M:=M+1;
for f:=2 to n do
  begin
    if f=N then
      if (c[f]<c[Min]) and (c[f-1]>1) then Min:=f;
    if f<>N then
      if (c[f]<c[Min]) and ((c[f-1]>1) or (c[f+1]>1)) then Min:=f
  end;
if Min=1 then
  if (k-c[Min])*2>c[Min+1] then
    begin
      Hod[M].m:=c[Min+1] div 2;
      Hod[M].p:=Min+1;
      c[Min]:=c[Min]+c[Min+1] div 2;
      c[Min+2]:=c[Min+2]+c[Min+1] div 2;
      c[Min+1]:=c[Min+1]-2*(c[Min+1] div 2)
    end
                           else
    begin
      Hod[M].m:=k-c[Min];
      Hod[M].p:=Min+1;
      c[Min+2]:=c[Min+2]+k-c[Min];
      c[Min+1]:=c[Min+1]-2*(k-c[Min]);
      c[Min]:=k
    end;
if Min=N then
  if (k-c[Min])*2>c[Min-1] then
    begin
      Hod[M].m:=c[Min-1] div 2;
      Hod[M].p:=Min-1;
      c[Min]:=c[Min]+c[Min-1] div 2;
      c[Min-2]:=c[Min-2]+c[Min-1] div 2;
      c[Min-1]:=c[Min-1]-2*(c[Min-1] div 2)
    end
                           else
    begin
      Hod[M].m:=k-c[Min];
      Hod[M].p:=Min-1;
      c[Min-2]:=c[Min-2]+k-c[Min];
      c[Min-1]:=c[Min-1]-2*(k-c[Min]);
      c[Min]:=k
    end;
if (Min<>1) and (Min<>N) then
  if c[Min-1]>c[Min+1] then
    begin
    if ((k-c[Min])*2>c[Min-1]) and (Min-1<>1) then
      begin
        Hod[M].m:=c[Min-1] div 2;
        Hod[M].p:=Min-1;
        c[Min]:=c[Min]+c[Min-1] div 2;
        c[Min-2]:=c[Min-2]+c[Min-1] div 2;
        c[Min-1]:=c[Min-1]-2*(c[Min-1] div 2)
      end
                             else
      if ((k-c[Min])*2<=c[Min-1]) and (Min-1<>1) then
      begin
        Hod[M].m:=k-c[Min];
        Hod[M].p:=Min-1;
        c[Min-2]:=c[Min-2]+k-c[Min];
        c[Min-1]:=c[Min-1]-2*(k-c[Min]);
        c[Min]:=k
      end;
    if (k-c[Min]>c[Min-1]) and (Min-1=1) then
      begin
        Hod[M].m:=c[Min-1] div 2;
        Hod[M].p:=1;
        c[Min]:=c[Min]+c[Min-1] div 2;
        c[Min-1]:=c[Min-1]-c[Min-1] div 2
      end
                             else
      if (k-c[Min]<=c[Min-1]) and (Min-1=1) then
      begin
        Hod[M].m:=k-c[Min];
        Hod[M].p:=1;
        c[Min-1]:=c[Min-1]-k+c[Min];
        c[Min]:=k
      end;
    end
                       else
    begin
    if ((k-c[Min])*2>c[Min+1]) and (Min+1<>N) then
      begin
        Hod[M].m:=c[Min+1] div 2;
        Hod[M].p:=Min+1;
        c[Min]:=c[Min]+c[Min+1] div 2;
        c[Min+2]:=c[Min+2]+c[Min+1] div 2;
        c[Min+1]:=c[Min+1]-2*(c[Min+1] div 2)
      end
                             else
      if ((k-c[Min])*2<=c[Min+1]) and (Min+1<>N) then
      begin
        Hod[M].m:=k-c[Min];
        Hod[M].p:=Min+1;
        c[Min+2]:=c[Min+2]+k-c[Min];
        c[Min+1]:=c[Min+1]-2*(k-c[Min]);
        c[Min]:=k
      end;
    if (k-c[Min]>c[Min+1]) and (Min+1=N) then
      begin
        Hod[M].m:=c[Min+1] div 2;
        Hod[M].p:=N;
        c[Min]:=c[Min]+c[Min+1] div 2;
        c[Min+1]:=c[Min+1]-c[Min+1] div 2
      end
                             else
      if (k-c[Min]<=c[Min+1]) and (Min+1=N) then
      begin
        Hod[M].m:=k-c[Min];
        Hod[M].p:=N;
        c[Min+1]:=c[Min+1]-k+c[Min];
        c[Min]:=k
      end;
    end;
Ok:=true;
for f:=1 to N do
  if c[f]<>k then
    begin
      Ok:=false;
      f:=N
    end;
until Ok;
Assign(DataFile,OutputFileName);
Rewrite(DataFile);
writeln(DataFile,M);
for f:=1 to M do writeln(DataFile,Hod[f].p,',',Hod[f].m);
Close(DataFile);
writeln('Ok!')
end.