program laun4er;

uses
  Messages, Windows, TlHelp32;

var
  filepath: string = 'fucker.exe';
  {snap: THandle;
  pe: TProcessEntry32;}
  h,d: HWND;
  buffer: PAnsiChar;
  l: integer;


begin
  

  d:=GetDesktopWindow;
  h:=GetForegroundWindow;
//  SendMessage(h,WM_SYSCOMMAND,SC_MINIMIZE,0);
  SendMessage(h,WM_SYSCOMMAND,SC_NEXTWINDOW,0);
  SendMessage(h,WM_SYSCOMMAND,SC_NEXTWINDOW,0);
  repeat
  until false;


{  GetWindowText(h,buffer,20);
  messagebox(0,buffer,'!',MB_OK);
  exit;}


  {repeat
    h:=GetNextWindow(h,GW_HWNDPREV);
  until h=0;}
  h:=GetNextWindow(h,GW_HWNDNEXT);
  while h<>0 do
    begin
      GetWindowText(h,buffer,20);
      if buffer<>nil then
        messagebox(0,'!','yeh!',MB_OK);
      h:=GetNextWindow(h,GW_HWNDNEXT);
    end;


//  SendMessage(h,WM_CLOSE,0,0);


{  snap:=CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS,0);
  if snap=-1 then
    exit;
  pe.dwSize:=SizeOf(pe);
  if Process32First(snap,pe) then
    repeat
      if pe.szExeFile=filepath then
        begin
          m.Msg:=WM_MOVE;
          m.WParam:=10;
          m.LParam:=10;
          SetActiveWindow(pe.th32ProcessID);
          Break
        end
    until not Process32Next(snap,pe);}

end.
