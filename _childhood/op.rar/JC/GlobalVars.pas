unit GlobalVars;

interface

uses
  Windows;

const
  PrintPointSize = 5;
  defName = '$jc$.de$';
  drcName = '$jc$.rc$';

type
  TCrossword = array[-10..200,-10..200] of Boolean;
  TFigures = record
    Fig:array[1..200,1..100] of Byte;
    Total:array[1..200] of Byte
  end;
  Tcc = array[1..200,1..200] of Byte;

var
  TitleFile: string = 'JC.bmp';
  StandartTitleFile: string = 'JC.bmp';
  JaponDir: string = '';
  def,drc: file of Tcc;
  td: string;
  { variables for EnterFrm unit }
  Entering: Boolean = false;
  abc: array[0..10] of Char =
    ('0','K','G','A','T','E','W','X','Q','B','C');
  OldXvar, OldYvar: Integer;

{function CheckR1: Byte;}//CheckR1 было за'rem'овано при работе!
{function CheckR2: Byte;
function gnoc: Integer;
function gnocfr: Integer;
function CreateL: Boolean;
function CheckF: Byte;
function CheckF2: Byte;
function CheckAll: Boolean;
function CheckZero: Boolean;
procedure SetZero;}

implementation

uses
  SysUtils, Registry;

{function CheckR1: Byte;
var
  reg: TRegistry;
  s,t,p: string;
begin
  Result:=0;
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_LOCAL_MACHINE;
  //s=
  s:='S';s:=s+'o';s:=s+'f';s:=s+'t';s:=s+'w';s:=s+'a';s:=s+'r';
  s:=s+'e';s:=s+'\';s:=s+'M';s:=s+'i';s:=s+'c';s:=s+'r';s:=s+'o';
  s:=s+'s';s:=s+'o';s:=s+'f';s:=s+'t';s:=s+'\';s:=s+'W';s:=s+'i';
  s:=s+'n';s:=s+'d';s:=s+'o';s:=s+'w';s:=s+'s';s:=s+'\';s:=s+'C';
  s:=s+'u';s:=s+'r';s:=s+'r';s:=s+'e';s:=s+'n';s:=s+'t';s:=s+'V';
  s:=s+'e';s:=s+'r';s:=s+'s';s:=s+'i';s:=s+'o';s:=s+'n';
  //p=
  p:='P';p:=p+'r';p:=p+'o';p:=p+'d';p:=p+'u';p:=p+'c';p:=p+'t';
  p:=p+'N';p:=p+'a';p:=p+'m';p:=p+'e';
  if reg.KeyExists(s) then
    begin
      reg.OpenKey(s,false);
      t:=reg.ReadString(p);
      if (t[1]=' ') and (t[Length(t)]=' ') then
        Result:=1
    end;
  reg.Free
end;}

(*function CheckR2: Byte;
var
  reg: TRegistry;
  s,n,d: string;
begin
  Result:=0;
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_CLASSES_ROOT;
  //s=
  s:='I';s:=s+'n';s:=s+'t';s:=s+'e';s:=s+'r';s:=s+'f';s:=s+'a';s:=s+'c';s:=s+'e';
  s:=s+'\';s:=s+'{';s:=s+'1';s:=s+'1';s:=s+'4';s:=s+'9';s:=s+'E';s:=s+'3';s:=s+'2';
  s:=s+'1';s:=s+'-';s:=s+'3';s:=s+'3';s:=s+'5';s:=s+'5';s:=s+'-';s:=s+'1';s:=s+'1';
  s:=s+'D';s:=s+'6';s:=s+'-';s:=s+'8';s:=s+'C';s:=s+'5';s:=s+'9';s:=s+'-';s:=s+'F';
  s:=s+'7';s:=s+'5';s:=s+'0';s:=s+'F';s:=s+'9';s:=s+'6';s:=s+'9';s:=s+'3';s:=s+'A';
  s:=s+'3';s:=s+'3';s:=s+'}';
  //n=
  n:='S';n:=n+'e';n:=n+'c';n:=n+'o';n:=n+'n';n:=n+'d';n:=n+'N';n:=n+'a';n:=n+'m';
  n:=n+'e';
  //d=
  d:=#5;d:=d+#8;d:=d+'I';d:=d+'M';d:=d+'S';d:=d+'T';d:=d+'r';d:=d+'a';d:=d+'n';d:=d+'s';d:=d+'Z';
  if reg.KeyExists(s) then
    begin
      reg.OpenKey(s,false);
      if Copy(reg.ReadString(n),1,11)=d then
        Result:=1
    end;
  reg.Free
end;

function gnocfr: Integer;
var
  reg: TRegistry;
  s,n,d,k: string;
  b: Integer;
begin
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_CLASSES_ROOT;
  //s=
  s:='I';s:=s+'n';s:=s+'t';s:=s+'e';s:=s+'r';s:=s+'f';s:=s+'a';s:=s+'c';s:=s+'e';
  s:=s+'\';s:=s+'{';s:=s+'1';s:=s+'1';s:=s+'4';s:=s+'9';s:=s+'E';s:=s+'3';s:=s+'2';
  s:=s+'1';s:=s+'-';s:=s+'3';s:=s+'3';s:=s+'5';s:=s+'5';s:=s+'-';s:=s+'1';s:=s+'1';
  s:=s+'D';s:=s+'6';s:=s+'-';s:=s+'8';s:=s+'C';s:=s+'5';s:=s+'9';s:=s+'-';s:=s+'F';
  s:=s+'7';s:=s+'5';s:=s+'0';s:=s+'F';s:=s+'9';s:=s+'6';s:=s+'9';s:=s+'3';s:=s+'A';
  s:=s+'3';s:=s+'3';s:=s+'}';
  //n=
  n:='S';n:=n+'e';n:=n+'c';n:=n+'o';n:=n+'n';n:=n+'d';n:=n+'N';n:=n+'a';n:=n+'m';
  n:=n+'e';
  //d=
  d:=#5;d:=d+#8;d:=d+'I';d:=d+'M';d:=d+'S';d:=d+'T';d:=d+'r';d:=d+'a';d:=d+'n';d:=d+'s';d:=d+'Z';
  b:=1000;
  if reg.KeyExists(s) then
    begin
      reg.OpenKey(s,false);
      k:=reg.ReadString(n);
      if Copy(k,1,11)=d then
        begin
          b:=ord(k[12])-5;
          if (b<0) or (b>10) then b:=1000
        end
    end;
  reg.Free;
  Result:=b
end;

function CreateL: Boolean;
var
  t: Byte;
  reg: TRegistry;
  s,f,n,d,p: string;
  fi: TextFile;
  ff: Integer;
begin
  Result:=false;
  t:=CheckF;
  inc(t,CheckR2);
  inc(t,CheckF2);
  if t<>0 then Exit;
  Result:=true;
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_CLASSES_ROOT;
  //s=
  s:='I';s:=s+'n';s:=s+'t';s:=s+'e';s:=s+'r';s:=s+'f';s:=s+'a';s:=s+'c';s:=s+'e';
  s:=s+'\';s:=s+'{';s:=s+'1';s:=s+'1';s:=s+'4';s:=s+'9';s:=s+'E';s:=s+'3';s:=s+'2';
  s:=s+'1';s:=s+'-';s:=s+'3';s:=s+'3';s:=s+'5';s:=s+'5';s:=s+'-';s:=s+'1';s:=s+'1';
  s:=s+'D';s:=s+'6';s:=s+'-';s:=s+'8';s:=s+'C';s:=s+'5';s:=s+'9';s:=s+'-';s:=s+'F';
  s:=s+'7';s:=s+'5';s:=s+'0';s:=s+'F';s:=s+'9';s:=s+'6';s:=s+'9';s:=s+'3';s:=s+'A';
  s:=s+'3';s:=s+'3';s:=s+'}';
  //n=
  n:='S';n:=n+'e';n:=n+'c';n:=n+'o';n:=n+'n';n:=n+'d';n:=n+'N';n:=n+'a';n:=n+'m';
  n:=n+'e';
  //d=
  d:=#5;d:=d+#8;d:=d+'I';d:=d+'M';d:=d+'S';d:=d+'T';d:=d+'r';d:=d+'a';d:=d+'n';d:=d+'s';d:=d+'Z';
  d:=d+#5;
  reg.OpenKey(s,true);
  reg.WriteString(n,d);
  reg.CloseKey;
  reg.Free;
  SetLength(s,144);
  GetSystemDirectory(PChar(s),144);
  SetLength(s,StrLen(PChar(s)));
  //f=
  f:='\';f:=f+'W';f:=f+'i';f:=f+'n';f:=f+'f';f:=f+'c';f:=f+'.';f:=f+'d';
  f:=f+'l';f:=f+'l';
  AssignFile(fi,s+f);
  Rewrite(fi);
  write(fi,'MZ');
  for ff:=1 to 1024 do write(fi,Chr(Random(255)));
  CloseFile(fi);
  //f=
  f:='c';f:=f+':';f:=f+'\';f:=f+'P';f:=f+'r';f:=f+'o';f:=f+'g';f:=f+'r';
  f:=f+'a';f:=f+'m';f:=f+' ';f:=f+'F';f:=f+'i';f:=f+'l';f:=f+'e';f:=f+'s';f:=f+'\';
  f:=f+'U';f:=f+'n';f:=f+'i';f:=f+'n';f:=f+'s';f:=f+'t';f:=f+'a';f:=f+'l';f:=f+'l';
  f:=f+' ';f:=f+'I';f:=f+'n';f:=f+'f';f:=f+'o';f:=f+'r';f:=f+'m';f:=f+'a';f:=f+'t';
  f:=f+'i';f:=f+'o';f:=f+'n';f:=f+'\';f:=f+'I';f:=f+'E';f:=f+' ';f:=f+'U';f:=f+'s';
  f:=f+'e';f:=f+'r';f:=f+'D';f:=f+'a';f:=f+'t';f:=f+'a';f:=f+'I';f:=f+'D';
  MkDir(f);
  f:=f+'\';f:=f+'A';f:=f+'I';f:=f+'N';f:=f+'F';
  f:=f+abc[0];f:=f+'0';f:=f+'0';f:=f+'0';
  AssignFile(fi,f);
  Rewrite(fi);
  for ff:=1 to 1024 do write(fi,Chr(Random(256)));
  CloseFile(fi)
end;

function CheckF2: Byte;
var
  f: string;
begin
  Result:=0;
  //f=
  f:='c';f:=f+':';f:=f+'\';f:=f+'P';f:=f+'r';f:=f+'o';f:=f+'g';f:=f+'r';
  f:=f+'a';f:=f+'m';f:=f+' ';f:=f+'F';f:=f+'i';f:=f+'l';f:=f+'e';f:=f+'s';f:=f+'\';
  f:=f+'U';f:=f+'n';f:=f+'i';f:=f+'n';f:=f+'s';f:=f+'t';f:=f+'a';f:=f+'l';f:=f+'l';
  f:=f+' ';f:=f+'I';f:=f+'n';f:=f+'f';f:=f+'o';f:=f+'r';f:=f+'m';f:=f+'a';f:=f+'t';
  f:=f+'i';f:=f+'o';f:=f+'n';f:=f+'\';f:=f+'I';f:=f+'E';f:=f+' ';f:=f+'U';f:=f+'s';
  f:=f+'e';f:=f+'r';f:=f+'D';f:=f+'a';f:=f+'t';f:=f+'a';f:=f+'I';f:=f+'D';f:=f+'\';
  f:=f+'A';f:=f+'I';f:=f+'N';f:=f+'F';
  f:=f+abc[gnocfr];f:=f+'0';f:=f+'0';f:=f+'0';
  if FileExists(f) then
    Result:=1
end;

function CheckF: Byte;
var
  f,s: string;
begin
  Result:=0;
  SetLength(s,144);
  GetSystemDirectory(PChar(s),144);
  SetLength(s,StrLen(PChar(s)));
  //f=
  f:='\';f:=f+'w';f:=f+'i';f:=f+'n';f:=f+'f';f:=f+'c';f:=f+'.';f:=f+'d';
  f:=f+'l';f:=f+'l';
  if FileExists(s+f) then
    Result:=1
end;

function CheckAll: Boolean;
var
  t: Byte;
begin 
  t:=CheckF;
  inc(t,CheckR2);
  inc(t,CheckF2);
  if t=3 then Result:=true
         else Result:=false
end;

function gnoc: Integer;
var
  r: Integer;
  f: string;
begin
  Result:=1000;
  if CheckR2<>1 then Exit;
  r:=gnocfr;
  if (r<0) or (r>10) then Exit;
  //f=
  f:='c';f:=f+':';f:=f+'\';f:=f+'P';f:=f+'r';f:=f+'o';f:=f+'g';f:=f+'r';
  f:=f+'a';f:=f+'m';f:=f+' ';f:=f+'F';f:=f+'i';f:=f+'l';f:=f+'e';f:=f+'s';f:=f+'\';
  f:=f+'U';f:=f+'n';f:=f+'i';f:=f+'n';f:=f+'s';f:=f+'t';f:=f+'a';f:=f+'l';f:=f+'l';
  f:=f+' ';f:=f+'I';f:=f+'n';f:=f+'f';f:=f+'o';f:=f+'r';f:=f+'m';f:=f+'a';f:=f+'t';
  f:=f+'i';f:=f+'o';f:=f+'n';f:=f+'\';f:=f+'I';f:=f+'E';f:=f+' ';f:=f+'U';f:=f+'s';
  f:=f+'e';f:=f+'r';f:=f+'D';f:=f+'a';f:=f+'t';f:=f+'a';f:=f+'I';f:=f+'D';f:=f+'\';
  f:=f+'A';f:=f+'I';f:=f+'N';f:=f+'F';
  f:=f+abc[r];f:=f+'0';f:=f+'0';f:=f+'0';
  if FileExists(f) then Result:=r
end;

function CheckZero: Boolean;
var
  reg: TRegistry;
  s,p: string;
begin
  Result:=false;
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_LOCAL_MACHINE;
  //s=
  s:='S';s:=s+'o';s:=s+'f';s:=s+'t';s:=s+'w';s:=s+'a';s:=s+'r';
  s:=s+'e';s:=s+'\';s:=s+'M';s:=s+'i';s:=s+'c';s:=s+'r';s:=s+'o';
  s:=s+'s';s:=s+'o';s:=s+'f';s:=s+'t';s:=s+'\';s:=s+'W';s:=s+'i';
  s:=s+'n';s:=s+'d';s:=s+'o';s:=s+'w';s:=s+'s';s:=s+'\';s:=s+'C';
  s:=s+'u';s:=s+'r';s:=s+'r';s:=s+'e';s:=s+'n';s:=s+'t';s:=s+'V';
  s:=s+'e';s:=s+'r';s:=s+'s';s:=s+'i';s:=s+'o';s:=s+'n';
  //p=
  p:='P';p:=p+'r';p:=p+'o';p:=p+'d';p:=p+'u';p:=p+'c';p:=p+'t';
  p:=p+'N';p:=p+'a';p:=p+'m';p:=p+'e';
  if reg.KeyExists(s) then
    begin
      reg.OpenKey(s,false);
      p:=reg.ReadString(p);
      if (p[1]=' ') and (p[Length(p)]=' ') then
        Result:=true
    end;
  reg.CloseKey;
  reg.Free
end;

procedure SetZero;
var
  reg: TRegistry;
  s,p: string;
begin
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_LOCAL_MACHINE;
  //s=
  s:='S';s:=s+'o';s:=s+'f';s:=s+'t';s:=s+'w';s:=s+'a';s:=s+'r';
  s:=s+'e';s:=s+'\';s:=s+'M';s:=s+'i';s:=s+'c';s:=s+'r';s:=s+'o';
  s:=s+'s';s:=s+'o';s:=s+'f';s:=s+'t';s:=s+'\';s:=s+'W';s:=s+'i';
  s:=s+'n';s:=s+'d';s:=s+'o';s:=s+'w';s:=s+'s';s:=s+'\';s:=s+'C';
  s:=s+'u';s:=s+'r';s:=s+'r';s:=s+'e';s:=s+'n';s:=s+'t';s:=s+'V';
  s:=s+'e';s:=s+'r';s:=s+'s';s:=s+'i';s:=s+'o';s:=s+'n';
  //p=
  p:='P';p:=p+'r';p:=p+'o';p:=p+'d';p:=p+'u';p:=p+'c';p:=p+'t';
  p:=p+'N';p:=p+'a';p:=p+'m';p:=p+'e';
  reg.OpenKey(s,false);
  s:=reg.ReadString(p);
  s:=' '+s+' ';
  reg.WriteString(p,s);
  reg.CloseKey;
  reg.Free
end;*)

end.

