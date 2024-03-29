uses WaveFile,SB,Mixer,Crt;

var
    Sound1,Sound2:TWaveFile;
    Sample1,Sample2,MixedSample:TSample;
    BlockSize:Word;
    FileName1,FileName2:string;

procedure Error(Message:string);
begin
writeln(Message);
halt(1)
end;

begin
if (ParamCount<2) or (ParamCount<1) then
  Error('�㦭� 㪠���� ��� wav-䠩��!');
FileName1:=ParamStr(1);
if ParamCount=1 then FileName2:=FileName1
                else FileName2:=ParamStr(2);
Sound1.Create;
if not Sound1.AssignFile(ParamStr(1)) then Error('�訡�� �����祭�� ��ࢮ�� 䠩��');
with Sound1.WaveFormat do
  begin
    if FormatTag<>wavefmtPCM then Error('�� �����ন������ �㤨��ଠ� 䠩�� '+FileName1);
    if Channels<>1 then Error('���� '+FileName1+': ����� �ந��뢠�� ⮫쪮 ����');
    if Frequency<>22050 then Error('���� '+FileName1+': ���� �롮ન ������ ���� 22050 ��');
    if Fidelity<>8 then Error('���� '+FileName1+': ������ ���� 8-���� ���')
  end;
Sound2.Create;
if not Sound2.AssignFile(ParamStr(2)) then Error('�訡�� �����祭�� ��ண� 䠩��');
with Sound2.WaveFormat do
  begin
    if FormatTag<>wavefmtPCM then Error('�� �����ন������ �㤨��ଠ� 䠩�� '+FileName2);
    if Channels<>1 then Error('���� '+FileName2+': ����� �ந��뢠�� ⮫쪮 ����');
    if Frequency<>22050 then Error('���� '+FileName2+': ���� �롮ન ������ ���� 22050 ��');
    if Fidelity<>8 then Error('���� '+FileName2+': ������ ���� 8-���� ���')
  end;
with Sample1 do
  begin
    Format:=sb8bitPCM;
    Frequency:=Sound1.WaveFormat.Frequency;
    Channels:=Sound1.WaveFormat.Channels
  end;
with Sample2 do
  begin
    Format:=sb8bitPCM;
    Frequency:=Sound2.WaveFormat.Frequency;
    Channels:=Sound2.WaveFormat.Channels
  end;
with MixedSample do
 begin
   Format:=sb8bitPCM;
   Frequency:=Sample1.Frequency;
   Channels:=Sample1.Channels;
   if MaxAvail<Sound1.GetBufferSize then Error('�� �����筮 �����');
   GetMem(Data,Sound1.GetBufferSize)
 end;
sbLoadData:=true;
while Sound1.IsMoreAudio or Sound2.IsMoreAudio do
  begin
    with Sample1 do
      if Sound1.IsMoreAudio then
        begin
          Data:=Sound1.GetAudioBlock(BlockSize);
          if Data=nil then Error('�訡�� �⥭�� �㤨������� �� 䠩��');
          Size:=BlockSize;
          if Size=0 then Error('�訡�� �⥭�� �㤨������� �� 䠩��')
        end
                            else
        begin
          Data:=nil;
          Size:=0
        end;
    with Sample2 do
      if Sound2.IsMoreAudio then
        begin
          Data:=Sound2.GetAudioBlock(BlockSize);
          if Data=nil then Error('�訡�� �⥭�� �㤨������� �� 䠩��');
          Size:=BlockSize;
          if Size=0 then Error('�訡�� �⥭�� �㤨������� �� 䠩��')
        end
                            else
        begin
          Data:=nil;
          Size:=0
        end;
    MixSamples(Sample1,Sample2,MixedSample);
    while not sbLoadData do;
    PlaySample(MixedSample);
    Sound1.Idle;
    Sound2.Idle
  end;
while not sbLoadData do;
FreeMem(MixedSample.Data,Sound1.GetBufferSize);
Sound1.Destroy;
Sound2.Destroy;
CloseSB;
writeln('The End')
end.