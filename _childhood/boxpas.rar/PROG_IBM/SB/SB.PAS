unit SB;

Interface

const
      offReset = $06;
      offRead = $0A;
      offWrite = $0C;
      offStatus = $0C;
      offAvail = $0E;
      sb8bitPCM = $14;
      sb4bitADPCM = $74;
      sb4bitADPCMR = $75;
      sb3bitADPCM = $76;
      sb3bitADPCMR = $77;
      sb2bitADPCM = $16;
      sb2bitADPCMR = $17;
type
     tSample = record
                 Data:Pointer;
                 Format:Byte;
                 Frequency:Word;
                 Channels:Byte;
                 Size:Word
               end;
var
    sbBase,sbReset,sbRead,sbWrite,sbStatus,sbAvail:Word;
    sbIRQ,sbDMA,sbHDMA:Byte;
    sbLoadData:Boolean;

procedure PlaySample(sample:tSample);
procedure CloseSB;

Implementation

Uses Crt,Dos;
var
    BlasterStr:string[79];
    BasePort,MPUPort,IRQ,DMA8,DMA16,
    SoftInt,IRQMask:Integer;
    OldVector:Pointer;
function Wait(Delay:Integer):Integer;
begin
Wait:=Delay
end;
procedure WriteDSP(value:Byte);
begin
while (Port[sbStatus] and $80)<>0 do;
Port[sbWrite]:=Value
end;
function ReadDSP:Byte;
begin
while (Port[sbAvail] and $80)=0 do;
ReadDSP:=Port[sbRead]
end;
function Init(Base:Word;_IRQ:Byte;DMA:Byte;HDMA:Byte):Boolean;
begin
sbBase:=Base;
sbReset:=sbBase+offReset;
sbRead:=sbBase+offRead;
sbWrite:=sbBase+offWrite;
sbStatus:=sbBase+offStatus;
sbAvail:=sbBase+offAvail;
sbIRQ:=IRQ;
sbDMA:=DMA;
sbHDMA:=HDMA;
Port[sbReset]:=1;
Delay(10);
Port[sbReset]:=0;
Delay(10);
if ((Port[sbAvail] and $80)=$80) and (Port[sbRead]=$AA) then
  begin
    Init:=true;
    WriteDSP($D1)
  end
                                                        else
  Init:=false;
end;
procedure PlaySample(sample:tSample);
var
    Size,Offset,Page,Time:Word;
begin
sbLoadData:=false;
Dec(Sample.Size);
Offset:=seg(Sample.Data^) shl 4+Ofs(Sample.Data^);
Page:=(seg(Sample.Data^)+Ofs(Sample.Data^) shr 4) shr 12;
Port[$0A]:=5;
Port[$0C]:=0;
Port[$0B]:=$49;
Port[$02]:=Lo(Offset);
Port[$02]:=Hi(Offset);
Port[$83]:=Page;
Port[$03]:=Lo(Sample.Size);
Port[$03]:=Hi(Sample.Size);
Port[$0A]:=1;
Time:=256-1000000 div Sample.Frequency;
WriteDSP($40);
WriteDSP(Time);
WriteDSP(Sample.Format);
WriteDSP(Lo(Sample.Size));
WriteDSP(Hi(Sample.Size))
end;
function ToHex(Value:Word):Word;
var
    Digits:string[4];
    Result,Code:Integer;
begin
Str(Value,Digits);
Val('$'+Digits,Result,Code);
ToHex:=Result
end;
procedure CloseSB;
begin
SetIntVec(SoftInt,OldVector);
Port[$21]:=Port[$21] or IRQMask;
if IRQ>=8 then Port[$A1]:=Port[$A1] or IRQMask
end;
{$F+}
procedure SBHandler;interrupt;
var
    b:Byte;
begin
b:=Port[sbAvail];
sbLoadData:=true;
Port[$20]:=$20;
if IRQ>=8 then Port[$A0]:=$A0
end;
{$F-}
begin
{BlasterStr:=GetEnv('Blaster');
BasePort:=ToHex(ParseData(BlasterStr,'A'));
MPUPort:=ToHex(ParseData(BlasterStr,'P'));
IRQ:=ParseData(BlasterStr,'I');
DMA8:=ParseData(BlasterStr,'D');
DMA16:=ParseData(BlasterStr,'H');}
BasePort:=220;
MPUPort:=330;
IRQ:=5;
DMA8:=1;
DMA16:=4;
Init(BasePort,IRQ,DMA8,DMA16);
if IRQ<8 then SoftInt:=IRQ+8
         else SoftInt:=IRQ+$68;
GetIntVec(SoftInt,OldVector);
SetIntVec(SoftInt,Addr(SBHandler));
IRQMask:=1 shl (IRQ mod 8);
Port[$21]:=Port[$21] and not IRQMask;
if IRQ>=8 then Port[$A1]:=Port[$A1] and not IRQMask
end.