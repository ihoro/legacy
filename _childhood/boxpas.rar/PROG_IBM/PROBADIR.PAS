program ProbaDir;

{$I-,S-}
{$M 8192,8192,655360}

uses Dos, Crt, Graph;

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
  Dm,Dg:integer;
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

procedure command(ss:string);
begin
 
      SwapVectors;
      Exec(GetEnv('COMSPEC'), '/C ' + ss);
      SwapVectors;
      if DosError <> 0 then begin
         cleardevice;
         closegraph;
      WriteLn('Could not execute COMMAND.COM')
                            end;
end;

procedure wind;
var ll:word;
begin
setcolor(0);
for l:=400 to 639 do line(l,0,l,479);
setcolor(9);
rectangle(400,0,639,479);
rectangle(402,2,637,477);
rectangle(402,20,637,477);
settextstyle(1,0,1);
setcolor(12);
outtextxy(457,0,'Wiew Window');
setcolor(10);
settextstyle(1,0,4);
ll:=0;
for l:=fist to fist+14 do
begin
ll:=ll+1;
outtextxy(407,-15+30*ll,f[l].name)
end
end;

procedure main(n:word);
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
end;

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
  WriteLn('Directory of ', Path);
  if Count = 0 then
  begin
    WriteLn('No matching files');
    Exit;
  end;
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
    Write(N, ' ': 9 - Length(N), E, ' ': 4 - Length(E));
    if WideDir then
    begin
      if Attr and Directory <> 0 then
        Write(' DIR')
      else
        Write((Size + 1023) shr 10: 3, 'k');
      if I and 3 <> 3 then
        Write(' ': 3)
      else
        WriteLn;
    end else
    begin
      if Attr and Directory <> 0 then
        Write('<DIR>   ')
      else
        Write(Size: 8);
      UnpackTime(Time, T);
      WriteLn(T.Day: 4, '-',
        MonthStr[T.Month], '-',
        NumStr(T.Year mod 100, 2),
        T.Hour: 4, ':',
        NumStr(T.Min, 2));
    end;
    Inc(Total, Size);
  end;
  if WideDir and (Count and 3 <> 0) then WriteLn;
  WriteLn(Count, ' files, ', Total, ' bytes, ',
    DiskFree(Ord(Path[1])-64), ' bytes free');
end;

begin
  GetCommand;
  FindFiles;
  SortFiles;
  PrintFiles;

  {clrscr;
  textcolor(10);
  for l:=1 to free do
  begin
   gotoxy(2,l);
   write(f[l].name);write(' ',f[l].size);write(' ',f[l].day);write(' ',f[l].month);write(' ',f[l].year);
   write(' ',f[l].hour);
   write(' ',f[l].min);
  end;
  readln; }

  Dm:=Detect;
  InitGraph(Dm,Dg,'');
  if GraphResult <> 0 then halt;
  fist:=1;
  wind;
  main(1);
  y:=15;
  tek:=1;
REPEAT

repeat
setcolor(random(15)+1);
outtextxy(407,y,f[tek].name);
until keypressed;

h:=readkey;
 if (h=#13) and ( copy ( f[tek].name, length( f[tek].name )-2,3 ) ='exe' ) then
   begin
    {M 8192,0,0}
    command(f[tek].name)
   end;
setcolor(10); outtextxy(407,y,f[tek].name);
if h=#0 then if readkey=#80 then
                   if y<>435 then
                    begin
                     tek:=tek+1;
                     y:=y+30;
                     main(tek)
                    end
                             else
                    begin
                     if tek<>free then
                     begin
                      fist:=fist+1;
                      wind;
                      tek:=tek+1;
                      main(tek)
                     end
                    end
               else
                 if y<>15 then
                  begin
                   tek:=tek-1;
                   y:=y-30;
                   main(tek)
                  end
                          else
                   if tek<>1 then
                  begin
                   fist:=fist-1;
                   wind;
                   tek:=tek-1;
                   main(tek)
                  end;
UNTIL H=#27;
end.