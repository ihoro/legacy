program Dller;

uses
  Windows, MyUtils;

const
  Size = 100;
  DefaultText = 'Хороща хвункція';

type
  typ = string[Size];

var
  semOur,semGo: THandle;
  Data: THandle;
  PData: Pointer;
  ss: ^typ;
  s: typ;
  nf,p: Integer;

begin
  New(ss);
  semOur:=CreateSemaphore(nil,0,1,'OUR_S1');
  semGo:=CreateSemaphore(nil,0,1,'go');
  repeat
    if WaitForSingleObject(semOur,INFINITE)=WAIT_OBJECT_0 then
      begin
        if WaitForSingleObject(semGo,50)=WAIT_OBJECT_0 then
          begin
            Dispose(ss);
            CloseHandle(semOur);
            CloseHandle(semGo);
            Halt
          end;
        OpenClipboard(0);
        Data:=GetClipboardData(CF_TEXT);
        try
          PData:=GlobalLock(Data);
          Move(ptr(Int64(PData)-1)^,ss^,Size);
          s:=ss^;
          nf:=sti(Copy(s,1,Pos(' ',s)-1));
          Delete(s,1,Pos(' ',s));
          p:=sti(s);
          case nf of
            1:begin
                p:=p*p;
                ss^:=its(p)
              end;
            2:ss^:=DefaultText;
            10:begin
                 p:=p*p*p;
                 ss^:=its(p)
               end
          end
        finally
          GlobalUnLock(Data)
        end;
        Data:=GlobalAlloc(GMEM_MOVEABLE,Size);
        try
          PData:=GlobalLock(Data);
          EmptyClipboard;
          ss^:=ss^+#0;
          Move(ss^,ptr(Int64(PData)-1)^,Size);
          SetClipboardData(CF_TEXT,Data)
        finally
          GlobalUnLock(Data)
        end;
        CloseClipboard;
        ReleaseSemaphore(semOur,1,nil)
      end
  until false
end.
