uses Graph,Crt;
type
     PointType = array[1..8] of
                   record
                     X,Y,Z:Integer;
                     Alpha:Integer;
                     Ch:1..4
                   end;

const
      P:PointType = ((X:0;Y:0;Z:0;Alpha:0;Ch:1),(X:0;Y:0;Z:20;Alpha:0;Ch:1),(X:20;Y:20;Z:20;Alpha:45;Ch:1),
                     (X:20;Y:20;Z:0;Alpha:45;Ch:1),(X:20;Y:0;Z:0;Alpha:0;Ch:1),(X:20;Y:0;Z:20;Alpha:0;Ch:1),
                     (X:20;Y:20;Z:20;Alpha:45;Ch:1),(X:20;Y:20;Z:0;Alpha:45;Ch:1));
      Betta = 5;
      gr1 = Pi/180;
      cx = 319;
      cy = 239;
var
    grd,grm,f,l,nu:Integer;
procedure WritePoints;
var
    g:integer;
    t:array[1..8] of
        record
          x,y:integer
        end;
begin
ClearDevice;
for g:=1 to 8 do
  with P[g] do
    begin
      case Ch of
        2:X:=-X;
        3:begin X:=-X;Y:=-Y end;
        4:Y:=-Y
      end;
      t[g].x:=X;
      t[g].y:=cy+Y+Z
    end;
Line(t[1].X,t[1].Y,t[2].X,t[2].Y);
LineTo(t[3].X,t[3].Y);
LineTo(t[4].X,t[4].Y);
LineTo(t[1].X,t[1].Y);
LineTo(t[5].X,t[5].Y);
LineTo(t[6].X,t[6].Y);
LineTo(t[2].X,t[2].Y);
Line(t[6].X,t[6].Y,t[7].X,t[7].Y);
LineTo(t[8].X,t[8].Y);
LineTo(t[5].X,t[5].Y);
Line(t[3].X,t[3].Y,t[7].X,t[7].Y);
Line(t[4].X,t[4].Y,t[8].X,t[8].Y)
end;
begin
grd:=0;
InitGraph(grd,grm,'');
WritePoints;
for f:=1 to 720 do
  for l:=1 to 8 do
    with P[l] do
      begin
        if Betta>Alpha then
          begin
            nu:=90-Betta+Alpha;
            if Ch<>1 then Ch:=Ch-1
                     else Ch:=4
          end
                       else nu:=Alpha-Betta;
        if Betta>Alpha then
          begin
            X:=Round((SQR(X)+SQR(Y))*COS(gr1*(90-nu)));
            Y:=Round((SQR(X)+SQR(Y))*SIN(gr1*(90-nu)))
          end
                       else
          begin
            X:=Round((SQR(X)+SQR(Y))*COS(gr1*nu));
            Y:=Round((SQR(X)+SQR(Y))*SIN(gr1*nu))
          end;
        Alpha:=nu;
        WritePoints;
        Delay(10000)
      end;
CloseGraph
end.