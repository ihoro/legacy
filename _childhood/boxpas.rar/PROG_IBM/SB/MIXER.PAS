unit Mixer;
{$G+}

Interface

uses SB;
procedure MixSamples(Sample1,Sample2:TSample;var MixedSample:TSample);

Implementation

uses MinMax;
type
     PByte=^Byte;
procedure MixSamples(Sample1,Sample2:TSample;var MixedSample:TSample);
var
    Index,Size1,Size2,StopIndex,_SP_:Word;
    Data1,Data2,MixedData:PByte;
begin
size1:=Sample1.Size;
size2:=Sample2.Size;
StopIndex:=Min(Size1,Size2)-1;
Data1:=Sample1.Data;
Data2:=Sample2.Data;
MixedData:=MixedSample.Data;
MixedSample.Size:=Max(Sample1.Size,Sample2.Size);
for Index:=0 to StopIndex do
  begin
    MixedData^:=(Data1^+Data2^) div 2;
    MixedData:=ptr(seg(MixedData^),ofs(MixedData^)+1);
    Data1:=ptr(seg(Data1^),ofs(Data1^)+1);
    Data2:=ptr(seg(Data2^),ofs(Data2^)+1)
  end;
if Size1>Size2 then
  for Index:=0 to Size1-Size2 do
    begin
      MixedData^:=Data1^ div 2;
      MixedData:=ptr(seg(MixedData^),ofs(MixedData^)+1);
      Data1:=ptr(seg(Data1^),ofs(Data1^)+1)
    end;
if Size2>Size1 then
  for Index:=0 to Size2-Size1 do
    begin
      MixedData^:=Data2^ div 2;
      MixedData:=ptr(seg(MixedData^),ofs(MixedData^)+1);
      Data2:=ptr(seg(Data2^),ofs(Data2^)+1)
    end
end;
end.