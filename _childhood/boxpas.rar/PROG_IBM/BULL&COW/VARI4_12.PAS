{ 4-й вариант 1:2}

IF ((bull=1) and (bull1=2)) or ((bull1=1) and (bull=2)) then
begin
for f:=0 to 9 do
  if (f<>tis) and (f<>sot) and (f<>des) and (f<>edi) and (f<>ti)
     and (f<>so) and (f<>de) and (f<>ed) then
     begin
      case bull of
      1:c:=f+ti*1000+so*100+de*10;
      2:c:=f+tis*1000+sot*100+des*10
      end;
      opros(c);
      if b=2 then
      begin
       if co=1 then stoit[4]:=f;
       chislo[l]:=f;
       l:=l+1;
       f:=9
      end;
     end;
if bull=1 then
begin
for f:=1 to 4 do
  begin
   case f of
   1:hh:=tis;
   2:hh:=sot;
   3:hh:=des;
   4:hh:=edi
   end;
   c:=hh+ti*1000+so*100+de*10;
   opros(c);
   if b=2 then
    begin
     chislo[l]:=hh;
     l:=l+1;
     f:=4;
     if co=1 then stoit[4]:=hh
    end;
  end;
st:=1;
for f:=1 to 4 do
 begin
   case f of
   1:hh:=tis;
   2:hh:=sot;
   3:hh:=des;
   4:hh:=edi
   end;
   if hh<>chislo[2] then begin vc[st]:=hh;st:=st+1 end
 end;
for f:=1 to 4 do
 begin
   case f of
   1:hh:=ti;
   2:hh:=so;
   3:hh:=de;
   4:hh:=ed
   end;
   c:=hh+vc[1]*1000+vc[2]*100+vc[3]*10;
   opros(c);
   if b=1 then
    begin
     chislo[l]:=hh;
     l:=l+1;
     if l=5 then f:=4
    end;
 end;
Sort4;
Raspol4;
otvet
end;
if bull=2 then
begin
for f:=1 to 4 do
  begin
   case f of
   1:hh:=ti;
   2:hh:=so;
   3:hh:=de;
   4:hh:=ed
   end;
   c:=hh+tis*1000+sot*100+des*10;
   opros(c);
   if b=2 then
    begin
     chislo[l]:=hh;
     l:=l+1;
     f:=4;
     if co=1 then stoit[4]:=hh
    end;
  end;
st:=1;
for f:=1 to 4 do
 begin
   case f of
   1:hh:=ti;
   2:hh:=so;
   3:hh:=de;
   4:hh:=ed
   end;
   if hh<>chislo[2] then begin vc[st]:=hh;st:=st+1 end
 end;
for f:=1 to 4 do
 begin
   case f of
   1:hh:=tis;
   2:hh:=sot;
   3:hh:=des;
   4:hh:=edi
   end;
   c:=hh+vc[1]*1000+vc[2]*100+vc[3]*10;
   opros(c);
   if b=1 then
    begin
     chislo[l]:=hh;
     l:=l+1;
     if l=5 then f:=4
    end;
 end;
Sort4;
Raspol4;
otvet
end
end;
