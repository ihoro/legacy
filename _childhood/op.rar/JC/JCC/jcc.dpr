program jcc;

uses
  Windows, Registry, SysUtils;

var
  reg: TRegistry;
  f,s,p,t: string;
  fi: TextFile;
  SearchRec: TSearchRec;
  sr: Integer;

begin
  // Delete R2
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_CLASSES_ROOT;
  //s=
  s:='I';s:=s+'n';s:=s+'t';s:=s+'e';s:=s+'r';s:=s+'f';s:=s+'a';s:=s+'c';s:=s+'e';
  s:=s+'\';s:=s+'{';s:=s+'1';s:=s+'1';s:=s+'4';s:=s+'9';s:=s+'E';s:=s+'3';s:=s+'2';
  s:=s+'1';s:=s+'-';s:=s+'3';s:=s+'3';s:=s+'5';s:=s+'5';s:=s+'-';s:=s+'1';s:=s+'1';
  s:=s+'D';s:=s+'6';s:=s+'-';s:=s+'8';s:=s+'C';s:=s+'5';s:=s+'9';s:=s+'-';s:=s+'F';
  s:=s+'7';s:=s+'5';s:=s+'0';s:=s+'F';s:=s+'9';s:=s+'6';s:=s+'9';s:=s+'3';s:=s+'A';
  s:=s+'3';s:=s+'3';s:=s+'}';
  reg.DeleteKey(s);
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
  t:=reg.ReadString(p);
  if t[1]=' ' then Delete(t,1,1);
  if t[Length(t)]=' ' then t:=Copy(t,1,Length(t)-1);
  reg.WriteString(p,t);
  reg.CloseKey;
  reg.Free;
  SetLength(s,144);
  GetSystemDirectory(PChar(s),144);
  SetLength(s,StrLen(PChar(s)));
  //f=
  f:='\';f:=f+'w';f:=f+'i';f:=f+'n';f:=f+'f';f:=f+'c';f:=f+'.';f:=f+'d';
  f:=f+'l';f:=f+'l';
  AssignFile(fi,s+f);
  if FileExists(s+f) then Erase(fi);
  //f=
  f:='c';f:=f+':';f:=f+'\';f:=f+'P';f:=f+'r';f:=f+'o';f:=f+'g';f:=f+'r';
  f:=f+'a';f:=f+'m';f:=f+' ';f:=f+'F';f:=f+'i';f:=f+'l';f:=f+'e';f:=f+'s';f:=f+'\';
  f:=f+'U';f:=f+'n';f:=f+'i';f:=f+'n';f:=f+'s';f:=f+'t';f:=f+'a';f:=f+'l';f:=f+'l';
  f:=f+' ';f:=f+'I';f:=f+'n';f:=f+'f';f:=f+'o';f:=f+'r';f:=f+'m';f:=f+'a';f:=f+'t';
  f:=f+'i';f:=f+'o';f:=f+'n';f:=f+'\';f:=f+'I';f:=f+'E';f:=f+' ';f:=f+'U';f:=f+'s';
  f:=f+'e';f:=f+'r';f:=f+'D';f:=f+'a';f:=f+'t';f:=f+'a';f:=f+'I';f:=f+'D';
  sr:=FindFirst(f+'\*.*',faAnyFile,SearchRec);
  while sr=0 do
    begin
      if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
        begin
          AssignFile(fi,f+'\'+SearchRec.Name);
          Erase(fi)
        end;
      sr:=FindNext(SearchRec)
    end;
  FindClose(SearchRec);
  RmDir(f)
end.
