program Directories;

{$I-,S-}
{$M 8192,8192,655360}

uses Dos, Crt, DirFiles;

const
  MaxDirSize = 512;
  MonthStr: array[1..12] of string[3] = (
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');

type
  DirPtr   = ^DirRec;
  DirRec   = record
               Attr: Byte;
               Time: Longint;
               Size: Longint;
               Name: string[12];
             end;
  DirList  = array[0..MaxDirSize - 1] of DirPtr;
  LessFunc = function(X, Y: DirPtr): Boolean;

var
  H:char;
  Tek:word;
  Fist:word;
  Y:integer;
  WideDir: Boolean;
  Count: Integer;
  Less: LessFunc;
  Path: PathStr;
  Dir: DirList;
  free:word;
  l:integer;
  f:array[1..1000] of
     record
      day:byte;
      month:byte;
      year:integer;
      hour:byte;
      min:byte;
      size:longint;
      name:string[12]
     end;

procedure Window;
var f:word;
begin
textbackground(0);
clrscr;
textcolor(10);
gotoxy(1,1); write('É');
for f:=1 to 77 do write('Í');
write('»');
for f:=1 to 23 do
 begin
  gotoxy(1,1+f); write('º');
  gotoxy(79,1+f);write('º')
 end;
gotoxy(1,25); write('È');
for f:=1 to 77 do write('Í');
write('¼');
textcolor(13);
gotoxy(34,1); write(' Directories ');
gotoxy(1,1);
end;

procedure Files(a:word);
var l,t,k:word;
begin
textbackground(0);
t:=1;
for l:=fist to fist+22 do
 begin
  t:=t+1; textcolor(14);
  gotoxy(3,t); write(f[l].name);
  textcolor(0);
  for k:=1 to 13-length(f[l].name) do write(' ')
 end;
gotoxy(3,y);
textbackground(9);
textcolor(12);
write(f[a].name);
{for k:=1 to 13-length(f[a].name) do write(' ')}
end;

procedure ClearFree;
var l,t:word;
begin
for l:=1 to free do
if (f[l].name='.') or (f[l].name='..') or (f[l].name='...') or (f[l].name='....') or
   (f[l].name='.....') or (f[l].name='......') or (f[l].name='........') or (f[l].name='........')
   then
   begin
     for t:=l+1 to free do
          begin
           f[t-1].name:=f[t].name;
           f[t-1].size:=f[t].size;
           f[t-1].day:=f[t].day;
           f[t-1].month:=f[t].month;
           f[t-1].year:=f[t].year;
           f[t-1].hour:=f[t].hour;
           f[t-1].min:=f[t].min
          end;
     free:=free-1;
     l:=free;
     clearfree
   end
end;

procedure Little;
var l,t:word;
begin
for l:=1 to free do
if f[l].size<>0 then
   for t:=1 to length(f[l].name) do
      if (f[l].name[t] <> '.') and (ord(f[l].name[t]) >= 65)
      and (ord(f[l].name[t]) <= 90) then f[l].name[t]:=chr(ord(f[l].name[t])+32)
end;

procedure Command(ss:string);
begin

      SwapVectors;
      Exec(GetEnv('COMSPEC'), '/C ' + ss);
      SwapVectors;
      if DosError <> 0 then
      WriteLn('Could not execute COMMAND.COM')
end;
{procedure main(n:word);
 var
    s,k:string;
begin
 setcolor(0);
 for l:=1 to 350 do
  line(l,100,l,479);
 settextstyle(7,0,4);
 s:=f[n].name;
 setcolor(12);
 Ellipse(200,300,0,360,150,60);
 Ellipse(200,315,180,360,150,60);
 line(50,300,50,315);
 line(350,300,350,315);
 setfillstyle(11,10);
 floodfill(200,361,12);
 setfillstyle(1,129);
 floodfill(200,300,12);
 setcolor(14);
 outtextxy(75,240,s);
 if ((s='.') or (s='..') or (s='...') or (s='....') or (s='.....') or (s='......') or
    (s='.......') or (s='........')) OR ( (pos('.',s)=0) and (f[n].size=0) ) then
    begin
     setcolor(10);
     outtextxy(130,300,'Directory');
    end
    else
     begin
      setcolor(10);
      outtextxy(160,300,'File');
      setcolor(13);
      str(f[n].size,k);
      outtextxy(50,100,k+' bytes');
       setcolor(11);
      str(f[n].day,k);
      outtextxy(10,140,k+'.');
      str(f[n].month,k);
      outtextxy(60,140,k+'.');
      str(f[n].year,k);
      outtextxy(100,140,k);
       setcolor(15);
        str(f[n].hour,k);
        outtextxy(210,140,k+':');
        str(f[n].min,k);
        outtextxy(260,140,k);
     end;
 settextstyle(1,0,4)
end;}

function NumStr(N, D: Integer): String;
begin
  NumStr[0] := Chr(D);
  while D > 0 do
  begin
    NumStr[D] := Chr(N mod 10 + Ord('0'));
    N := N div 10;
    Dec(D);
  end;
end;

{$F+}

function LessName(X, Y: DirPtr): Boolean;
begin
  LessName := X^.Name < Y^.Name;
end;

function LessSize(X, Y: DirPtr): Boolean;
begin
  LessSize := X^.Size < Y^.Size;
end;

function LessTime(X, Y: DirPtr): Boolean;
begin
  LessTime := X^.Time > Y^.Time;
end;

{$F-}

procedure QuickSort(L, R: Integer);
var
  I, J: Integer;
  X, Y: DirPtr;
begin
  I := L;
  J := R;
  X := Dir[(L + R) div 2];
  repeat
    while Less(Dir[I], X) do Inc(I);
    while Less(X, Dir[J]) do Dec(J);
    if I <= J then
    begin
      Y := Dir[I];
      Dir[I] := Dir[J];
      Dir[J] := Y;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSort(L, J);
  if I < R then QuickSort(I, R);
end;

procedure GetCommand;
var
  I,J: Integer;
  Attr: Word;
  S: PathStr;
  D: DirStr;
  N: NameStr;
  E: ExtStr;
  F: File;
begin
  WideDir := False;
  @Less := nil;
  Path := '';
  Less := Lessname;
  for I := 1 to ParamCount do
  begin
    S := ParamStr(I);
    if S[1] = '-' then
      for J := 2 to Length(S) do
        case UpCase(S[J]) of
          'N': Less := LessName;
          'S': Less := LessSize;
          'T': Less := LessTime;
          'W': WideDir := True;
        else
          WriteLn('Invalid option: ', S[J]);
          Halt(1);
        end
    else
      Path := S;
  end;
  Path := FExpand(Path);
  if Path[Length(Path)] <> '\' then
  begin
    Assign(F, Path);
    GetFAttr(F, Attr);
    if (DosError = 0) and (Attr and Directory <> 0) then
      Path := Path + '\';
  end;
  FSplit(Path, D, N, E);
  if N = '' then N := '*';
  if E = '' then E := '.*';
  Path := D + N + E;
end;

procedure FindFiles;
var
  F: SearchRec;
begin
  Count := 0;
  FindFirst(Path, ReadOnly + Directory + Archive, F);
  while (DosError = 0) and (Count < MaxDirSize) do
  begin
    GetMem(Dir[Count], Length(F.Name) + 10);
    Move(F.Attr, Dir[Count]^, Length(F.Name) + 10);
    Inc(Count);
    FindNext(F);
  end;
end;

procedure SortFiles;
begin
  if (Count <> 0) and (@Less <> nil) then
    QuickSort(0, Count - 1);
end;

procedure PrintFiles;
var
  I, P: Integer;
  Total: Longint;
  T: DateTime;
  N: NameStr;
  E: ExtStr;

begin
  if Count = 0 then
   Exit;
  Total := 0;
  free:=0;
  for I := 0 to Count-1 do
  with Dir[I]^ do
  begin
   free:=free+1;
    f[free].name:=name;
    f[free].size:=size;
    unpacktime(time,t);
    f[free].day:=t.day;
    f[free].month:=t.month;
    f[free].year:=t.year;
    f[free].hour:=t.hour;
    f[free].min:=t.min;
    P := Pos('.', Name);
    if P > 1 then
    begin
      N := Copy(Name, 1, P - 1);
      E := Copy(Name, P + 1, 3);
    end else
    begin
      N := Name;
      E := '';
    end;
    if WideDir then
    begin
      if Attr and Directory <> 0 then
        write
      else
        Write;
      if I and 3 <> 3 then
        Write
      else
        Write;
    end else
    begin
      if Attr and Directory <> 0 then
        Write
      else
        Write;
    end;
    Inc(Total, Size);
  end;
  if WideDir and (Count and 3 <> 0) then Write;
end;

begin
  GetCommand;
  FindFiles;
  SortFiles;
  PrintFiles;
  clrscr;
{  textcolor(10);
  for l:=1 to free do
  begin
   gotoxy(2,l);
   write(f[l].name);write(' ',f[l].size);write(' ',f[l].day);write(' ',f[l].month);write(' ',f[l].year);
   write(' ',f[l].hour);
   write(' ',f[l].min);
  end;}
   fist:=1;
   y:=2;
   tek:=1;
  ClearFree;
  Little;
  Window;
  Files(1);
REPEAT

repeat
gotoxy(1,1);
until keypressed;

h:=readkey;
 if h=#13 {and ( copy ( f[tek].name, length( f[tek].name )-2,3 ) ='exe' )} then
   begin
    CommandLine(f[tek].name);
   end;
if h=#0 then if readkey=#80 then
                   if y<>24 then
                    begin
                     tek:=tek+1;
                     y:=y+1;
                     files(tek)
                    end
                             else
                    begin
                     if tek<>free then
                     begin
                      fist:=fist+1;

                      tek:=tek+1;
                      files(tek)
                     end
                    end
               else
                 if y<>2 then
                  begin
                   tek:=tek-1;
                   y:=y-1;
                   files(tek)
                  end
                          else
                   if tek<>1 then
                  begin
                   fist:=fist-1;

                   tek:=tek-1;
                   files(tek)
                  end;
UNTIL H=#27;
end.