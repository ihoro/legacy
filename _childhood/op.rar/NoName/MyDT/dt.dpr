program dt;

uses
  Windows, MyUtils;

type
  Tkvadrat = function(par: Integer): Integer; StdCall;

var
  LibHandle: THandle;
  kvadrat: Tkvadrat;
  s: string;

begin
  LibHandle:=LoadLibrary('sqlib.dll');
  if LibHandle=0 then
    begin
      MessageBox(0,'Dll''�� ���-�� ������� - �� �����������!',
        'Error''���',MB_OK+MB_ICONERROR);
      FreeLibrary(LibHandle);
      Halt
    end;
  @kvadrat:=GetProcAddress(LibHandle,'kvadrat');
  if @kvadrat=nil then
    begin
      MessageBox(0,'�������� � GetProcAddress!',
        'Error''���',MB_OK+MB_ICONERROR);
      FreeLibrary(LibHandle);
      Halt
    end;
  s:='������� 7: '+its(kvadrat(7));
  MessageBox(0,PChar(s),'���������',MB_OK+MB_ICONINFORMATION);
  FreeLibrary(LibHandle)
end.
