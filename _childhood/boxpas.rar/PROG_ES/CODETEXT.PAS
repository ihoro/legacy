uses WinDos, Dos, UpString;
const
      Parametres:set of char = ['T'];
var
    Input:array[1..300] of string[12];
    Ch:array[1..45000] of Char;
    PStr,s:string;
    ff,Total,F,L,D:Word;
    TekDir:string;
    se:PathStr;
    Par:Boolean;
    inp,out:text;
    ex:ExtStr;
    pa:DirStr;
    na:NameStr;
    h:Char;
    Stop:Boolean;
begin
GetDir(0,TekDir);
if (ParamCount=0) or (UpStr(ParamStr(1))='/H') then
  begin
    writeln('Coder Text.   (C) OIV Company Ltd.      2000');
    writeln;
    writeln('CODETEXT.EXE [параметр(ы)]  Имя файла(ов)');
    writeln;
    writeln('Параметры:');
    writeln('/h - данное описание');
    writeln('/a - подробное описание программы');
    writeln('/t - проверка файла на содержание текстов');
    writeln;
    halt
  end;
s:=ParamStr(1);
if UpStr(s)='/A' then
  begin
    writeln('Описание');
    Halt
  end;
s:=ParamStr(1);
if ((s[1]='/') and not (UpCase(s[2]) in Parametres) and (Length(s)=2)) or ((s[1]='/') and (Length(s)>2))
   or ((s[1]='/') and (Length(s)=1))then
  begin
    writeln('Неправельный параметр (/h - помощь)');
    halt
  end;
PStr:=ParamStr(1);
if (PStr[1]='/') and (UpCase(PStr[2]) in Parametres) and (ParamCount=1) then
  begin
    writeln('Не указаны файлы');
    Halt
  end;
if not (PStr[1]='/') then begin L:=1;Par:=false end
                     else begin L:=2;Par:=true end;
Total:=0;
for f:=l to ParamCount do
  begin
    se:=FSearch(ParamStr(f),TekDir);
    if se='' then
      begin
        writeln('Файл не найден (',ParamStr(f),')');
        Halt
      end;
    Total:=Total+1;
    Input[Total]:=ParamStr(f)
  end;
for f:=1 to Total do
    begin
      Assign(inp,Input[f]);
      FSplit(Input[f],pa,na,ex);
      Assign(out,pa+na+'.bak');
      Reset(inp);
      Rewrite(out);
      while not EOF(inp) do
        begin
          read(inp,h);
          if h='''' then
            begin
              d:=0;
              Stop:=false;
              repeat
                if EOF(inp) then
                  begin
                    writeln('Нет конца у символьной строки!(',Input[f],')');
                    Halt
                  end;
                read(inp,h);
                if h<>'''' then
                  begin
                    d:=d+1;
                    ch[d]:=h
                  end
                           else
                  begin
                    if EOF(inp) then
                      Stop:=true
                                else
                      begin
                        read(inp,h);
                        if h='''' then
                          begin
                            d:=d+1;
                            ch[d]:=h
                          end
                                  else
                          Stop:=true
                      end;
                  end;
              until Stop;
              for ff:=1 to d do
                begin
                  str(ord(ch[ff]),s);
                  if ff=1 then write(out,'#'+s+'+');
                  if (ff>1) and (ff<d) then write(out,'#'+s+'+');
                  if ff=d then write(out,'#'+s)
                end
            end
                    else
            write(out,h)
        end;
      Close(out);
      Rename(out,Input[f]);
      Close(inp)
    end;
end.