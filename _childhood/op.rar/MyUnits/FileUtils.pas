unit FileUtils;

interface

uses
  Windows, SysUtils, Classes;

type
  EFWError = class(Exception);

  TFileWork = class
  private
    FFileName: string;
    FFileSize: LongInt;
    FData: PByte;
    FFileHandle: Integer;
    FMapHandle: Integer;
    FMode: Integer;
  public
    constructor Create(aFileName: string;aMode: Integer;
      aSize: Integer); virtual;
    destructor Destroy; override;
    property FileName: string read FFileName;
    property FileSize: LongInt read FFileSize;
    property Data: PByte read FData;
  end;

implementation

{ TFileWork }

constructor TFileWork.Create(aFileName: string; aMode, aSize: Integer);
begin
  FFileName:=aFileName;
  FMode:=aMode;
  try
    if FMode=fmCreate then
      FFileHandle:=FileCreate(FFileName)
                      else
      FFileHandle:=FileOpen(FFileName,FMode);
    if FFileHandle<0 then
      raise EFWError.Create('Ошибка при создании или открытии файла');
    FFileSize:=GetFileSize(FFileHandle,nil);
    if FMode=fmOpenRead then
      FMapHandle:=CreateFileMapping(FFileHandle,nil,Page_ReadOnly,
        0,FFileSize,nil)
                        else
      FMapHandle:=CreateFileMapping(FFileHandle,nil,Page_ReadWrite,
        0,FFileSize,nil);
    if FMapHandle=0 then
      raise EFWError.Create('Ошибка при создании отображения файла');
    if FMode=fmOpenRead then
      FData:=MapViewOfFile(FMapHandle,File_Map_Read,0,0,FFileSize)
                        else
      FData:=MapViewOfFile(FMapHandle,File_Map_All_Access,0,0,FFileSize);
    if FData=nil then
      raise EFWError.Create('Ошибка при отображении окна просмотра файла');
  except
    CloseHandle(FFileHandle)
  end
end;

destructor TFileWork.Destroy;
begin
  if FFileHandle<>0 then
    CloseHandle(FFileHandle);
  if FMapHandle<>0 then
    CloseHandle(FMapHandle);
  if FData<>nil then
    begin
      UnMapViewOfFile(FData);
      FData:=nil
    end;
  inherited
end;

end.
