{***********************************}
{*                                 *}
{*   (C) OIV Company Ltd.          *}
{*   OIV Turbo Pascal Units        *}
{*   Unit "NSystem"    19.08.2000  *}
{*                                 *}
{***********************************}

unit NSystem;

Interface

type
     NType = 2..10;
     SystemNType = array[1..9] of 0..9;
     System16Figures = 0..15;
     System16Type = array[1..7] of System16Figures;
procedure InSystemN(X:LongInt;N:NType;var Result:SystemNType);
procedure FromSystemN(X:SystemNType;N:NType;var Result:LongInt);
procedure InSystem16(X:LongInt;var Result:System16Type);
procedure FromSystem16(X:System16Type;var Result:LongInt);
function InChar16(X:System16Figures):Char;
function FromChar16(C:Char):Byte;
function PError:Boolean;

Implementation

var
    Error:Boolean;
function Stepen(X:Integer;S:Byte):LongInt;
var
    F:Byte;
    P:LongInt;
begin
P:=1;
for F:=1 to S do P:=P*X;
Stepen:=P
end;
procedure InSystemN(X:LongInt;N:NType;var Result:SystemNType);
var
    F,R:Byte;
begin
Error:=false;
X:=ABS(X);
for F:=1 to 10 do Result[F]:=0;
R:=9;
F:=X div Stepen(N,R-1);
if F > (N-1) then
  begin
    Error:=true;
    Exit
  end;
R:=R+1;
repeat
R:=R-1;
F:=X div Stepen(N,R-1);
until F<>0;
for F:=R downto 1 do
  begin
    Result[F]:=X div Stepen(N,F-1);
    X:=X-(X div Stepen(N,F-1))*Stepen(N,F-1)
  end;
end;
procedure FromSystemN(X:SystemNType;N:NType;var Result:LongInt);
var
    F:Byte;
begin
Result:=0;
for F:=1 to 9 do Result:=Result+X[F]*Stepen(N,F-1)
end;
function FromChar16(C:Char):Byte;
begin
case UpCase(C) of
'0':FromChar16:=0;
'1':FromChar16:=1;
'2':FromChar16:=2;
'3':FromChar16:=3;
'4':FromChar16:=4;
'5':FromChar16:=5;
'6':FromChar16:=6;
'7':FromChar16:=7;
'8':FromChar16:=8;
'9':FromChar16:=9;
'A':FromChar16:=10;
'B':FromChar16:=11;
'C':FromChar16:=12;
'D':FromChar16:=13;
'E':FromChar16:=14;
'F':FromChar16:=15
end
end;
function InChar16(X:System16Figures):Char;
begin
case X of
0:InChar16:='0';
1:InChar16:='1';
2:InChar16:='2';
3:InChar16:='3';
4:InChar16:='4';
5:InChar16:='5';
6:InChar16:='6';
7:InChar16:='7';
8:InChar16:='8';
9:InChar16:='9';
10:InChar16:='A';
11:InChar16:='B';
12:InChar16:='C';
13:InChar16:='D';
14:InChar16:='E';
15:InChar16:='F'
end
end;
procedure InSystem16(X:LongInt;var Result:System16Type);
const
      N = 16;
var
    F,R:Byte;
begin
Error:=false;
for F:=1 to 7 do Result[F]:=0;
R:=7;
F:=X div Stepen(N,R-1);
if F > (N-1) then
  begin
    Error:=true;
    Exit
  end;
R:=R+1;
repeat
R:=R-1;
F:=X div Stepen(N,R-1);
until F<>0;
for F:=R downto 1 do
  begin
    Result[F]:=X div Stepen(N,F-1);
    X:=X-(X div Stepen(N,F-1))*Stepen(N,F-1)
  end;
end;
procedure FromSystem16(X:System16Type;var Result:LongInt);
const
      N = 16;
var
    F:Byte;
begin
Result:=0;
for F:=1 to 7 do Result:=Result+X[F]*Stepen(N,F-1)
end;
function PError:Boolean;
begin
PError:=Error
end;
begin
Error:=false
end.