unit WaveFile;
{$I-}

Interface
const
      Buffer_Size_Default=16384-8;
      WavefmtPCM=1;
type
     TChar4=array[0..3] of Char;
     TParentChunk=record
         RIFF:TChar4;
         Size:LongInt;
         ID:TChar4;
         Offset:LongInt
       end;
     TChunk=record
         ID:TChar4;
         Size:LongInt;
         Offset:LongInt
       end;
     TWaveFormat=record
         FormatTag:Word;
         Channels:Word;
         Frequency:LongInt;
         AvByteRate:LongInt;
         BlockAlign:Word;
         Fidelity:Word
       end;
     TWaveFile=object
         private
         FVar:File;
         Buffer:Pointer;
         BufferSize,
         MaxBufferSize:Word;
         Toread:LongInt;
         function FindParentChunk(var ParentChunk:TParentChunk):Boolean;
         function FindChunk(var Chunk:TChunk):Boolean;
         function LoadChunkData(Chunk:TChunk;Data:Pointer):Boolean;
         public
         FileName:String;
         WaveFormat:TWaveFormat;
         constructor Create;
         destructor Destroy;
         function SetBufferSize(NewMaxSize:Word):Boolean;
         function GetBufferSize:Word;
         function AssignFile(FName:String):Boolean;
         function GetAudioBlock(var BlockSize:Word):Pointer;
         procedure Idle;
         function CloseFile:Boolean;
         function IsMoreAudio:Boolean;
       end;

Implementation

uses MinMax;

constructor TWaveFile.Create;
begin
FileName:='';
MaxBufferSize:=Buffer_Size_Default;
if MaxAvail<MaxBufferSize then fail;
GetMem(Buffer,MaxBufferSize);
end;

destructor TWaveFile.Destroy;
begin
if Buffer<>nil then FreeMem(Buffer,MaxBufferSize);
if Length(FileName)>0 then CloseFile
end;

function TWaveFile.GetBufferSize:Word;
begin
GetBufferSize:=MaxBufferSize
end;

function TWaveFile.SetBufferSize(NewMaxSize:Word):Boolean;
begin
SetBufferSize:=true;
if Buffer<>nil then FreeMem(Buffer,MaxBufferSize);
Buffer:=nil;
MaxBufferSize:=NewMaxSize;
if NewMaxSize>(65536-8) then Exit;
if MaxAvail<MaxBufferSize then
  begin
    SetBufferSize:=false;
    Buffer:=nil;
    exit
  end;
GetMem(Buffer,MaxBufferSize);
AssignFile(FileName)
end;

function TWaveFile.FindParentChunk(var ParentChunk:TParentChunk):Boolean;
var
    _Chunk_:TParentChunk;
    Result:Word;
begin
FindParentChunk:=false;
Seek(FVar,0);
BlockRead(FVar,_Chunk_,SizeOf(_Chunk_)-4,Result);
if Result<>(SizeOf(_Chunk_)-4) then Exit;
if _Chunk_.RIFF<>ParentChunk.RIFF then Exit;
if _Chunk_.ID<>ParentChunk.ID then Exit;
ParentChunk.Size:=_Chunk_.Size;
ParentChunk.Offset:=FilePos(FVar);
FindParentChunk:=true
end;

function TWaveFile.FindChunk(var Chunk:TChunk):Boolean;
var
    _Chunk_:TChunk;
    Result:Word;
begin
FindChunk:=false;
Seek(FVar,SizeOf(TParentChunk)-4);
repeat
BlockRead(FVar,_Chunk_,SizeOf(_Chunk_)-4,Result);
if Result<>(SizeOf(_Chunk_)-4) then Exit;
if _Chunk_.ID<>Chunk.ID then Seek(FVar,FilePos(FVar)+_Chunk_.Size)
until _Chunk_.ID=Chunk.ID;
Chunk.Size:=_Chunk_.Size;
Chunk.Offset:=FilePos(FVar);
FindChunk:=true
end;

function TWaveFile.LoadChunkData(Chunk:TChunk;Data:Pointer):Boolean;
var
    Result:Word;
begin
LoadChunkData:=false;
Seek(FVar,Chunk.Offset);
BlockRead(FVar,Data^,Chunk.Size,Result);
if Result<>Chunk.Size then Exit;
LoadChunkData:=true
end;

function TWaveFile.AssignFile(FName:string):Boolean;
var
    ParentChunk:TParentChunk;
    Chunk:TChunk;
begin
if Length(FileName)>0 then CloseFile;
AssignFile:=false;
FileName:=FName;
Assign(FVar,FileName);
Reset(FVar,1);
if IOResult<>0 then Exit;
ParentChunk.RIFF:='RIFF';
ParentChunk.ID:='WAVE';
if not FindParentChunk(ParentChunk) then Exit;
if ParentChunk.Size<>(FileSize(FVar)-8) then Exit;
Chunk.ID:='fmt ';
if not FindChunk(Chunk) then Exit;
if not LoadChunkData(Chunk,@WaveFormat) then Exit;
Chunk.ID:='data';
if not FindChunk(Chunk) then Exit;
Toread:=Chunk.Size;
Idle;
AssignFile:=true
end;

procedure TWaveFile.Idle;
var
    Result:Word;
begin
if Toread<>0 then
  begin
    BufferSize:=Min(MaxBufferSize,Toread);
    BlockRead(FVar,Buffer^,BufferSize,Result);
    if Result<>BufferSize then CloseFile;
    Dec(Toread,BufferSize)
  end
end;

function TWaveFile.GetAudioBlock(var BlockSize:Word):Pointer;
begin
if BufferSize<>0 then
  begin
    GetAudioBlock:=Buffer;
    BlockSize:=BufferSize;
    BufferSize:=0
  end
                 else
  GetAudioBlock:=nil
end;

function TWaveFile.CloseFile:Boolean;
begin
CloseFile:=true;
BufferSize:=0;
Toread:=0;
FileName:='';
Close(FVar);
if IOResult<>0 then CloseFile:=false
end;

function TWaveFile.IsMoreAudio:Boolean;
begin
if BufferSize>0 then IsMoreAudio:=true
                else IsMoreAudio:=false
end;
end.