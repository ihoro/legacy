const
      MaxC = 10;
      MaxU = 100;
      MaxV = 100;
      MinHxy = -300;
      MaxHxy = 300;
      MinDlina = 4;
      InputFileName = 'land.inp';
      OutputFileName = 'land.out';
var
    C:0..MaxC;
    U,x,r,ox,x1,x2:0..MaxU;
    V,y,t,oy,y1,y2:-1..MaxV;
    Land:array[1..MaxU,1..MaxV] of MinHxy..MaxHxy;
    MaxS:0..MaxU*MaxV;
    DF:text;
    h:Char;
    f,l,ff,ll:Integer;
    MinH,MaxH:MinHxy..MaxHxy;
begin
Assign(DF,InputFileName);
Reset(DF);
read(DF,U);read(DF,h);
read(DF,V);read(DF,h);
Readln(DF,C);
for l:=1 to V do
  for f:=1 to U do
    begin
      if f<>U then
        begin
          read(DF,Land[f,l]);
          read(DF,h)
        end
              else
        readln(DF,Land[f,l])
    end;
Close(DF);
MaxS:=0;
ox:=0;
oy:=-1;
r:=U;
repeat
oy:=oy+1;
t:=V-oy;
if t=0 then
  begin
    oy:=0;
    ox:=ox+1;
    t:=V-oy;
    r:=U-ox
  end;
for l:=1 to oy+1 do
  for f:=1 to ox+1 do
    begin
      MinH:=Land[f,l];
      MaxH:=Land[f,l];
      for ll:=l to l+t-1 do
        for ff:=f to f+r-1 do
          begin
            if Land[ff,ll]<MinH then MinH:=Land[ff,ll];
            if Land[ff,ll]>MaxH then MaxH:=Land[ff,ll]
          end;
      if (MaxH-MinH<=C) and (r*t>MaxS) then
        begin
          MaxS:=r*t;
          x1:=f;
          y1:=l;
          x2:=f+r-1;
          y2:=l+t-1
        end;
    end;
until (ox=U-MinDlina) and (oy=V-1);
Assign(DF,OutputFileName);
Rewrite(DF);
write(DF,x1,',',y1,' ',x2,',',y2);
Close(DF)
end.