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
  Error('Нужно указать два wav-файла!');
FileName1:=ParamStr(1);
if ParamCount=1 then FileName2:=FileName1
                else FileName2:=ParamStr(2);
Sound1.Create;
if not Sound1.AssignFile(ParamStr(1)) then Error('Ошибка назначения первого файла');
with Sound1.WaveFormat do
  begin
    if FormatTag<>wavefmtPCM then Error('Не поддерживается аудиоформат файла '+FileName1);
    if Channels<>1 then Error('Файл '+FileName1+': можно проигрывать только моно');
    if Frequency<>22050 then Error('Файл '+FileName1+': частота выборки должна быть 22050 Гц');
    if Fidelity<>8 then Error('Файл '+FileName1+': должен быть 8-битный звук')
  end;
Sound2.Create;
if not Sound2.AssignFile(ParamStr(2)) then Error('Ошибка назначения второго файла');
with Sound2.WaveFormat do
  begin
    if FormatTag<>wavefmtPCM then Error('Не поддерживается аудиоформат файла '+FileName2);
    if Channels<>1 then Error('Файл '+FileName2+': можно проигрывать только моно');
    if Frequency<>22050 then Error('Файл '+FileName2+': частота выборки должна быть 22050 Гц');
    if Fidelity<>8 then Error('Файл '+FileName2+': должен быть 8-битный звук')
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
   if MaxAvail<Sound1.GetBufferSize then Error('Не достаточно памяти');
   GetMem(Data,Sound1.GetBufferSize)
 end;
sbLoadData:=true;
while Sound1.IsMoreAudio or Sound2.IsMoreAudio do
  begin
    with Sample1 do
      if Sound1.IsMoreAudio then
        begin
          Data:=Sound1.GetAudioBlock(BlockSize);
          if Data=nil then Error('Ошибка чтения аудиоданных из файла');
          Size:=BlockSize;
          if Size=0 then Error('Ошибка чтения аудиоданных из файла')
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
          if Data=nil then Error('Ошибка чтения аудиоданных из файла');
          Size:=BlockSize;
          if Size=0 then Error('Ошибка чтения аудиоданных из файла')
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