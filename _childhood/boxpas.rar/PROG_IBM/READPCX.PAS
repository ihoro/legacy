Unit ReadPcx;
Interface

Type
 { Тип, описывающий регистр палитры }
 TPaletteReg = record
  R, G, B: Byte
 end;
 { Тип, описывающий всю палитру     }
 PRGBPalette = ^TRGBPalette;
 TRGBPalette = array [0..255] of TPaletteReg;
 { Тип, описывающий картинку        }
 TPicture = record
  Width, Height: Word; { Ширина и высота картинки      }
  Palette: PRGBPalette;   { Указатель на палитру картинки }
  Image: Pointer;      { Указатель на данные           }
 end;

 { Методы очистки экрана, передаются в процедуру ClearScreen     }
Const
 csSimply       = 0; { простое очищение экрана цветом BackGround }
 csDarking      = 1; { потемнение экрана                         }
 csDissapearing = 2; { растворение экрана                        }

 { Определенные переменные, которые можно изменять в программе   }
Const
 Transparent : Byte    =   0; { прозрачный цвет                  }
 BackGround  : Byte    =   0; { фоновый цвет                     }
 ScreenWidth : Integer = 320; { размер экрана по горизонтали     }
 ScreenHeight: Integer = 200; { размер экрана по вертикали       }
 VideoBuf: Pointer = Ptr ($A000, $0000); { адрес текущего экрана }

 { Коды ошибок, которые графические процедуры заносят            }
 { в переменную GraphError                                       }
Const
  grOk               =   0;
  grNoInitGraph      =  -1;
  grNotDetected      =  -2;
  grFileNotFound     =  -3;
  grInvalidDriver    =  -4;
  grNoLoadMem        =  -5;
  grNoScanMem        =  -6;
  grNoFloodMem       =  -7;
  grFontNotFound     =  -8;
  grNoFontMem        =  -9;
  grInvalidMode      = -10;
  grError            = -11; 
  grIOerror          = -12;
  grInvalidFont      = -13;
  grInvalidFontNum   = -14;

Var
 { Системная переменная-таймер. Изменяется с частотой 18.2 Гц    }
 Clock: LongInt absolute $0000:$046C;

 { Переменная, в которой хранятся коды графических ошибок        }
 GraphError: Integer;

{ Процедуры работы с палитрой}

procedure SetAllRGBPalette (var Palette);
procedure GetAllRGBPalette (var Palette);
procedure SetPaletteReg (Reg, R, G, B: Byte);
procedure GetPaletteReg (Reg: Byte; Var R, G, B: Byte);
procedure SetNulPalette;

{ Установка видеорежимов и очистка экрана }

procedure SetLoGraphMode;
procedure ClearScreen (Metod: Byte);
procedure SetTextMode;

{ Построение графических примитивов }

procedure PutPixel (x,y: Word; c: Byte);
function  GetPixel (x,y: Word): Byte;
procedure HLine (x,y, Width: Integer; Color: Byte);
procedure VLine (x,y, Height: Integer; Color: Byte);
procedure Line (x1,y1,x2,y2: LongInt; Color: Byte);

{ Загрузка 256-цветных PCX-картинок в память и на экран }

procedure LoadPicture (Name: String; var Pic: TPicture);
procedure LoadIntro (Name: String);
procedure LoadOverPictures (x,y: Integer; Names: String);

{ Работа с картинками в памяти: удаление, копирование с экрана, отрисовка }

procedure UnLoadPicture (var Pic: TPicture);
procedure DrawPicture (x,y: Integer; var Pic: TPicture; SetPalette: Boolean);
procedure GetPicture (x1,y1,x2,y2: Integer; var Pic: TPicture; GetPalette: Boolean);
procedure TransparentDraw (x,y: Integer; var Pic: TPicture; SetPalette: Boolean);

{ Работа с текстами                                                       }

function ToStr (N: LongInt; Width: Byte; FirstZero: Boolean): String;
procedure DrawDigit (x,y: Integer; D: Char; C: Byte);
procedure DrawNumber (x,y: Integer; N: LongInt; Width: Byte; FirstZero: Boolean; C: Byte);

Implementation
Type
 PPCXHeader = ^TPCXHeader;
 TPCXHeader = record
  Manufacturer: Byte;
  Version: Byte;
  Encoding: Byte;
  BitsPixel: Byte;
  X, Y: Integer;
  Width, Height: Integer;
  HRes, VRes: Integer;
  EGAPalette: array [0..15, 1..3] of Byte;
  Reserved: Byte;
  Planes: Byte;
  BytesLine: Integer;
  PaletteInfo: Integer;
  Filler: array [1..58] of Byte;
 end;
 TBuffer = array [0..16383] of Byte;

procedure SetAllRGBPalette (var Palette);
Assembler;
Asm
 les    dx,Palette
 mov    ax,1012h
 mov    bx,0
 mov    cx,256
 int    10h
end;

procedure GetAllRGBPalette (var Palette);
Assembler;
Asm
 les    dx,Palette
 mov    ax,1017h
 mov    bx,0
 mov    cx,256
 int    10h
end;

procedure SetPaletteReg (Reg, R, G, B: Byte);
begin
 Port [$3C6] := $FF;
 Port [$3C8] := Reg;
 Port [$3C9] := R;
 Port [$3C9] := G;
 Port [$3C9] := B
end;

procedure GetPaletteReg (Reg: Byte; Var R, G, B: Byte);
begin
 Port [$3C6] := $FF;
 Port [$3C7] := Reg;
 R := Port [$3C9];
 G := Port [$3C9];
 B := Port [$3C9];
end;

procedure SetLoGraphMode;
Assembler;
Asm
 mov  ah,0
 mov  al,13h
 int  10h
end;

procedure ClearScreen;
Var
 P,P1: PRGBPalette;
 Nul: Word;
 i: LongInt;
begin
 Case Metod of
  csSimply:
   Asm
    mov    ax,0A000h
    mov    es,ax
    xor    di,di
    mov    cx,32000
    mov    al,BackGround
    mov    ah,al
    rep    stosw
   end;
  csDarking:
   begin
    New (P);
    New (P1);
    GetAllRGBPalette (P^);
    Move (P^, P1^, 768);
    repeat
     Nul := 0;
     for i:=0 to 255 do
     begin
      if P^[i].R > 0 then Dec (P^[i].R);
      if P^[i].G > 0 then Dec (P^[i].G);
      if P^[i].B > 0 then Dec (P^[i].B);
      Nul := Nul + P^[i].R+P^[i].G+P^[i].B;
      SetPaletteReg(i, P^[i].R,P^[i].G,P^[i].B);
     end;
     for i:=1 to 2000 do
    until Nul = 0;
    ClearScreen (csSimply);
    SetAllRGBPalette (P1);
    SetPaletteReg (0, P1^[0].R,P1^[0].G,P1^[0].B);
    Dispose (P1);
    Dispose (P)
   end;
  csDissapearing:
   begin
    Randomize;
    for i:=0 to 200000 do Mem [SegA000: Random (64000)] := BackGround;
    ClearScreen (csSimply)
   end
 end
end;

procedure SetTextMode;
Assembler;
Asm
 mov  ah,0
 mov  al,3
 int 10h
end;

procedure SetNulPalette;
Var
 i: Byte;
begin
 for i:=0 to 255 do
  SetPaletteReg (i, 0, 0, 0)
end;

procedure PutPixel (x,y: Word; c: Byte);
Var
  S, O: Word;
begin
  S := Seg (VideoBuf^);
  O := Ofs (VideoBuf^) + y shl 8 + y shl 6 + x;
  Mem [S : O] := c
end;

function GetPixel;
Var
  S, O: Word;
begin
  S := Seg (VideoBuf^);
  O := Ofs (VideoBuf^) + y shl 8 + y shl 6 + x;
  GetPixel := Mem [S : O]
end;

procedure HLine;
Var
  S, O: Word;
begin
  if (y < 0) or (y > ScreenHeight-1) then Exit;
  S := Seg (VideoBuf^);
  O := Ofs (VideoBuf^) + y shl 8 + y shl 6 + x;
  if Width < 0 then
  begin
   x := x + Width;
   Width := Abs (Width)
  end;
  if x < 0 then
  begin
   Width := Width + x;
   x := 0
  end;
  if x + Width > ScreenWidth then
   Width := ScreenWidth - x;
  FillChar (Mem [S : O], Width, Color)
end;

procedure VLine;
Var
  S, O, i: Word;
begin
  if (x < 0) or (x > ScreenWidth-1) then Exit;
  S := Seg (VideoBuf^);
  O := Ofs (VideoBuf^) + y shl 8 + y shl 6 + x;
  if Height < 0 then
  begin
   y := y + Height;
   Height := Abs (Height)
  end;
  if y < 0 then
  begin
   Height := Height + y;
   y := 0
  end;
  if y + Height > ScreenHeight then
   Height := ScreenHeight - y;
  for i:=1 to Height do
  begin
    Mem [S : O] := Color;
    Inc (O, ScreenWidth)
  end
end;

procedure Line;
Var
 x,d,dx,dy: Integer;
 Aincr,Bincr,yincr: Integer;
 S, O: Word;

 procedure SwapCoord (var a,b: LongInt);
 var
  c: LongInt;
 begin
  c := a;
  a := b;
  b := c
 end;

 procedure Cut;
 begin
  if y1 < 0 then begin
   x1 := x2 - (x2 - x1) * y2 div (y2 - y1);
   y1 := 0
  end;
  if y2 < 0 then begin
   x2 := x1 + (x2 - x1) * y1 div (y1 - y2);
   y2 := 0
  end;
  if y1 > 199 then begin
   x1 := x2 - (x2 - x1) * (199 - y2) div (y1 - y2);
   y1 := 199
  end;
  if y2 > 199 then begin
   x2 := x1 + (x2 - x1) * (199 - y1) div (y2 - y1);
   y2 := 199
  end;
  if x1 < 0 then begin
   if yincr = ScreenWidth
    then y1 := y2 - (y2 - y1) * x2 div (x2 - x1)
    else y1 := y2 + (y1 - y2) * x2 div (x2 - x1);
   x1 := 0
  end;
  if x2 > 319 then begin
   if yincr = ScreenWidth
    then y2 := y1 + (y2 - y1) * (319 - x1) div (x2 - x1)
    else y2 := y1 - (y1 - y2) * (319 - x1) div (x2 - x1);
   x2 := 319
  end
 end;

Begin
 if y1 = y2 then
 begin
  if x2 > x1
   then HLine (x1, y1, x2 - x1 + 1, Color)
   else HLine (x2, y1, x1 - x2 + 1, Color);
  Exit
 end;
 if x1 = x2 then
 begin
  if y2 > y1
   then VLine (x1, y1, y2 - y1 + 1, Color)
   else VLine (x1, y2, y1 - y2 + 1, Color);
  Exit
 end;
 if (x1 < 0) and (y1 < 0) and (x2 < 0) and (y2 < 0) then Exit;
 if (x1 > 319) and (y1 > 199) and (x2 > 319) and (y2 > 199) then Exit;
 if x1 > x2 then
 begin
  SwapCoord (x1, x2);
  SwapCoord (y1, y2)
 end;
 if y2 > y1
  then yincr := ScreenWidth
  else yincr := -ScreenWidth;
 Cut;
 dx := x2 - x1;
 dy := Abs (y2 - y1);
 d := 2 * dy - dx;
 Aincr := 2 * (dy - dx);
 BIncr := 2 * dy;
 S := Seg (VideoBuf^);
 O := Ofs (VideoBuf^) + y1 shl 8 + y1 shl 6 + x1;
 Mem [S : O] := Color;
 for x:=x1+1 to x2 do
 begin
  if d >= 0 then
  begin
   O := O + yincr;
   d := d + Aincr
  end
  else
   d := d + Bincr;
  Inc (O);
  Mem [S : O] := Color
 end
End;

procedure LoadPicture;
Var
 Header: PPCXHeader;
 Buf: ^TBuffer;
 Size, Index: Word;
 S, O : Word;
 Count, SizeImage: LongInt;
 Data,i,j: Byte;
 NumBytes: Integer;
 f: File;

 procedure IncIndex;
 begin
  Inc (Index);
  if Index = 16384 then
  begin
   BlockRead (f, Buf^, 16384, Size);
   Index := 0
  end
 end;

Begin
 Assign (f, Name);
 {$I-}
 Reset (f, 1);
 GraphError := grOk;
 if IOResult <> 0 then
 begin
  GraphError := grFileNotFound;
  Exit
 end;
 New (Header);
 BlockRead (f, Header^, SizeOf (TPCXHeader), Size);
 {$I+}
 if Header^.BitsPixel <> 8 then
 begin
  GraphError := grInvalidMode;
  Close (f);
  Exit
 end;
 With Pic do
 begin
  Width := Header^.Width + 1;
  Height := Header^.Height + 1;
  Dispose (Header);
  Count:=0;
  SizeImage := Width * Height;
  if (SizeImage > MaxAvail) or (SizeImage > 65520) then
  begin
   GraphError := grNoLoadMem;
   Close (f);
   Exit
  end;
  GetMem (Image, SizeImage);
  S := Seg (Image^);
  O := Ofs (Image^);
  Index := 16383;
  if SizeOf (TBuffer) > MaxAvail then
  begin
   GraphError := grNoLoadMem;
   Close (f);
   Exit
  end;
  New (Buf);
  IncIndex;
  While Count <= SizeImage do
  begin
   Data := Buf^ [Index];
   IncIndex;
   if Data in [192..255] then
   begin
    NumBytes := Data - 192;
    Data := Buf^ [Index];
    IncIndex;
    Inc (Count, NumBytes);
    While NumBytes > 0 do
    begin
     Mem [S:O] := Data;
     Inc (O);
     Dec (NumBytes);
    end
   end
   else
   begin
    Mem [S:O] := Data;
    Inc (O);
    Inc (Count);
   end
  end;
  Seek (f, FileSize (f) - 768);
  New (Palette);
  BlockRead (f, Palette^, 768, Size);
  for i:=0 to 255 do
  begin
    Palette^[i].R := Palette^[i].R shr 2;
    Palette^[i].G := Palette^[i].G shr 2;
    Palette^[i].B := Palette^[i].B shr 2;
  end;
  Dispose (Buf);
  Close (f);
 end;
End;

procedure UnLoadPicture;
begin
 if Assigned (Pic.Palette) then Dispose (Pic.Palette);
 if Assigned (Pic.Image) then FreeMem (Pic.Image, Pic.Height * Pic.Width)
end;

procedure DrawPicture;
Var
 S, O, SS, OS: Word;
 H, W, SWidth, SHeight, i: Word;
 P: Pointer;
begin
 With Pic do
 begin
  if SetPalette then SetAllRGBPalette (Palette^);
  P := Image;
  W := Width;
  H := Height
 end;
 SWidth := W;
 if x + W > ScreenWidth then
  SWidth := ScreenWidth - x;
 SHeight := H;
 if y + H > ScreenHeight then
  SHeight := ScreenHeight - y;
 S := Seg (P^);
 O := Ofs (P^);
 SS := Seg (VideoBuf^);
 OS := Ofs (VideoBuf^) + y shl 8 + y shl 6 + x;
 for i:=1 to SHeight do
 begin
  Move (Mem[S : O], Mem[SS: OS], SWidth);
  Inc (O, W);
  Inc (OS, ScreenWidth)
 end
end;

procedure GetPicture;
Var
 S, O, SS, OS, i: Word;
begin
 With Pic do
 begin
  if GetPalette then
  begin
   New (Palette);
   GetAllRGBPalette (Palette^)
  end;
  Width := Abs (x1-x2) + 1;
  if x1 + Width > ScreenWidth then
   Width := ScreenWidth - x1;
  Height := Abs (y1-y2) + 1;
  if y1 + Height > ScreenHeight then
   Height := ScreenHeight - y1;
  if (Width * Height > 65528) or (Width * Height > MaxAvail) then Exit;
  GetMem (Image, Width * Height);
  S := Seg (Image^);
  O := Ofs (Image^);
  SS := Seg (VideoBuf^);
  OS := Ofs (VideoBuf^) + y1 shl 8 + y1 shl 6 + x1;
  for i:=1 to Height do
  begin
   Move (Mem[SS : OS], Mem[S: O], Width);
   Inc (O, Width);
   Inc (OS, ScreenWidth)
  end
 end
end;

procedure TransparentDraw;
Var
 P: Pointer;
 W,H,IS: Word;
begin
 With Pic do
 begin
  if SetPalette then SetAllRGBPalette (Palette^);
  P:=Image;
  W:=Width;
  IS := 0;
  if x + W > ScreenWidth then
  begin
   W := ScreenWidth - x;
   IS := Width - W
  end;
  H:=Height;
  if y + H > ScreenHeight then
   H := ScreenHeight - y;
 end;
 Asm
      les   di,[VideoBuf]           { get pointer to memory buffer  }
      mov   ax,y                    { get starting y coordinate     }
      mov   bx,ax                   { make a copy                   }
      mov   cl,6
      sal   ax,cl                   { mult by 64                    }
      mov   cl,8
      sal   bx,cl                   { mult by 256                   }
      add   ax,bx                   { result is same as mult by 320 }
      add   di,ax                   { calc offset into VideoBuf     }
      add   di,x
      push  ds
      lds   si,[P]
      mov   bx,H
      mov   dx,320
      sub   dx,W
  @@1:mov   cx,W
  @@2:lodsb
      cmp  al,Transparent
      je   @@3
      stosb
      jmp  @@4
  @@3:inc  di
  @@4:loop @@2
      add  di,dx
      add  si,IS
      dec  bx
      jnz  @@1
      pop  ds
 end
end;

procedure LoadIntro;
Var
 Pic: TPicture;
begin
 LoadPicture (Name, Pic);
 if GraphError <> grOk then Exit;
 SetNulPalette;
 Move (Pic.Image^, VideoBuf^, 64000);
 SetAllRGBPalette (Pic. Palette^);
 UnLoadPicture (Pic)
end;

procedure LoadOverPictures;
Var
 i,b:Byte;
 f: Boolean;
 P,PO: TPicture;
begin
 b := 0;
 f := true;
 SetNulPalette;
 if Names[Length (Names)] <> ';' then Names := Names + ';';
 for i:=2 to Length (Names) do
  if Names[i] = ';' then
  begin
   if f then
   begin
    LoadPicture (Copy (Names, b+1, i-b-1),P);
    if GraphError <> grOk then Exit;
    DrawPicture (x, y, P, false);
    f := false;
    FreeMem (P.Image, P.Height * P.Width)
   end
   else
   begin
    LoadPicture (Copy (Names, b+1, i-b-1),PO);
    if GraphError <> grOk then Exit;
    TransparentDraw (x, y, PO, false);
    UnLoadPicture (PO)
   end;
   b:= i
  end;
  SetAllRGBPalette (P.Palette^);
  Dispose (P.Palette);
end;

function ToStr;
Var
 i: Byte;
 S: String;
begin
 Str (N : Width, S);
 if FirstZero then
  for i:=1 to Length (S) do
   if S[i] = ' ' then S[i] := '0';
 ToStr := S
end;

Const
 Digits : array['0'..'9', 0..15] of Byte =
    (
     ($00,$00,$3C,$66,$C3,$CB,$CB,$DB,$D3,$D3,$C3,$66,$3C,$00,$00,$00) { 0 },
     ($00,$00,$18,$18,$38,$78,$18,$18,$18,$18,$18,$18,$7E,$00,$00,$00) { 1 },
     ($00,$00,$3C,$66,$43,$03,$03,$06,$0C,$18,$30,$63,$FF,$00,$00,$00) { 2 },
     ($00,$00,$7F,$C6,$0C,$18,$3E,$03,$03,$03,$06,$0C,$70,$00,$00,$00) { 3 },
     ($00,$00,$0E,$0E,$1E,$16,$36,$66,$C7,$FF,$06,$06,$1F,$00,$00,$00) { 4 },
     ($00,$00,$FE,$C0,$C0,$F8,$C6,$03,$03,$03,$06,$0C,$70,$00,$00,$00) { 5 },
     ($00,$00,$0C,$30,$60,$C0,$DC,$E6,$C3,$C3,$C3,$66,$3C,$00,$00,$00) { 6 },
     ($00,$00,$FF,$C3,$06,$06,$0C,$0C,$18,$18,$30,$30,$30,$00,$00,$00) { 7 },
     ($00,$00,$3C,$66,$C3,$66,$3C,$66,$C3,$C3,$C3,$66,$3C,$00,$00,$00) { 8 },
     ($00,$00,$3C,$66,$C3,$C3,$C3,$67,$3B,$03,$06,$0C,$70,$00,$00,$00) { 9 }
     );

procedure DrawDigit;
var
 i,j: Byte;
 s,o: Word;
begin
 s:= Seg (VideoBuf^);
 o:= Ofs (VideoBuf^) + y shl 8 + y shl 6 + x;
 for i:=0 to 15 do
 begin
  for j:=0 to 7 do
  begin
   if (D in ['0'..'9']) and (Digits[D,i] and (128 shr j) <> 0) then
    Mem [s:o] := C
   else
    Mem [s:o] := BackGround;
   Inc (o)
  end;
  Inc (o, 312)
 end
end;

procedure DrawNumber;
Var
 i: Byte;
 S: String;
begin
 S := ToStr (N, Width, FirstZero);
 for i:=1 to Length (S) do
 begin
  DrawDigit (x,y, S[i], C);
  x := x + 10
 end
end;

END.
