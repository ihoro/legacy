unit whkGlobal;

interface

uses
  Windows, SysUtils, Messages;

const
  MaxActs = 100;
  MaxKeys = 8;
  SizeText = 20;
  TotalFileName = 'tdata.whk';
  DataFileName = 'data.whk';

type
  TKeys = array[1..MaxKeys] of LongInt;

  TAct = record
    Keys: TKeys;
    FileName: string[128];
    TotalKeys: 1..MaxKeys
  end;

var
  HookHandle: hHook;
  TotalActs: Word = 0;
  Acts: array[1..MaxActs] of TAct;
  Total,WorkTotal: 0..MaxKeys;
  TempKeys,WorkKeys: TKeys;

function GetKeys(Code: Integer; wParam,lParam: LongInt): LongInt; stdcall;
function GetGlobalKeys(Code: Integer; wParam,lParam: LongInt): LongInt; stdcall;
procedure InstallHook;
procedure UnInstallHook;
procedure InstallGlobalHook;
procedure UnInstallGlobalHook;
function GetKeysText: string;
{procedure DoAct(n: Word);}

implementation

function GetName(lp: LongInt): string;
var
  p: PChar;
begin
  New(p);
  GetKeyNameText(lp,p,SizeText);
  Result:=StrPas(p);
  p:=nil
end;

procedure DoAct(n: Word);
begin
  Beep
end;

function AllRight(lp: LongInt): Boolean;
begin
  Result:=true;
  if (GetName(lp)=GetName(TempKeys[Total])) and
    ((lp and 2147483648)=(TempKeys[Total] and 2147483648)) then
    Result:=false
end;

procedure Search;
var
  f: 1..MaxActs;
  l: 1..MaxKeys;
begin
  for f:=1 to TotalActs do
    for l:=1 to Acts[f].TotalKeys do
      if Acts[f].Keys[l]<>WorkKeys[l] then
        Break
                                      else
        if l=Acts[f].TotalKeys then
          DoAct(f)
  {for f:=1 to TotalActs do
    if Had[f] and (Acts[f].Keys[n]=WorkKeys[n]) then
      Had[f]:=true
                                              else
      begin
        Had[f]:=false;
        dec(TotalHad)
      end;
  if TotalHad=1 then
    for f:=1 to TotalActs do
      if Had[f] and
        (Acts[f].TotalKeys=n) then
        DoAct(f);
  if (TotalHad<=0) and (n<>1) then
    begin
      WorkKeys[1]:=WorkKeys[n];
      ClearSearch;
      WorkTotal:=1;
      Search(1)
    end;
  if (TotalHad<=0) and (n=1) then
    begin
      ClearSearch;
      WorkTotal:=0
    end}
end;

function GetKeys(Code: Integer; wParam,lParam: LongInt): LongInt; stdcall;
begin
  if Code=HC_ACTION then
    begin
      if (Total<>MaxKeys) and AllRight(lParam) then
        begin
          inc(Total);
          TempKeys[Total]:=lParam
        end;
      {if (lParam and 2147483648)=0 then
        m:=StrPas(s)+' down!'
                                   else
        m:=StrPas(s)+' up!';}
      Result:=0
    end
                    else
    Result:=CallNextHookEx(HookHandle,Code,wParam,lParam)
end;

function GetGlobalKeys(Code: Integer; wParam,lParam: LongInt): LongInt; stdcall;
var
  f: 1..MaxActs;
begin
  if Code=HC_ACTION then
    begin
      if not ((TMsg(Pointer(lParam)^).message=WM_KEYDOWN) or
        (TMsg(Pointer(lParam)^).message=WM_KEYUP)) then
        begin
          Result:=0;
          Exit
        end;
      inc(WorkTotal);
      WorkKeys[WorkTotal]:=TMsg(Pointer(lParam)^).lParam;
      Search;
      if WorkTotal=MaxKeys then
        begin
          for f:=1 to WorkTotal-1 do
            WorkKeys[f]:=WorkKeys[f+1];
          dec(WorkTotal)
        end;
      Result:=0
    end
                    else
    Result:=CallNextHookEx(HookHandle,Code,wParam,lParam)
end;

procedure InstallHook;
begin
  HookHandle:=SetWindowsHookEx(WH_Keyboard,
    GetKeys,HInstance,0);
  Total:=0
end;

procedure UnInstallHook;
begin
  UnHookWindowsHookEx(HookHandle)
end;

procedure InstallGlobalHook;
begin
  HookHandle:=SetWindowsHookEx(WH_GetMessage,
    GetGlobalKeys,HInstance,0)
end;

procedure UnInstallGlobalHook;
begin
  UnHookWindowsHookEx(HookHandle)
end;

function GetKeysText: string;
var
  f,l: Integer;
  s,ss: string;
  DownUp: array[1..MaxKeys] of Boolean;
begin
  Result:='';
  for f:=1 to Total do
    DownUp[f]:=false;
  if Total>0 then
    begin
      s:=GetName(TempKeys[1]);
      if (TempKeys[1] and 2147483648)=0 then
        DownUp[1]:=true
    end;
  for f:=2 to Total do
    begin
      ss:=GetName(TempKeys[f]);
      if (TempKeys[f] and 2147483648)=0 then
        begin
          DownUp[f]:=true;
          if DownUp[f-1] then
            s:=s+'+'+ss
                         else
            for l:=f-2 downto 1 do
              if DownUp[l] then
                s:=s+',+'+ss
                           else
                if l=1 then
                  s:=s+','+ss
        end
                                        else
        for l:=f-1 downto 1 do
          if (GetName(TempKeys[l])=GetName(TempKeys[f])) and
            DownUp[l] then
            begin
              DownUp[l]:=false;
              DownUp[f]:=false
            end
    end;
  Result:=s
end;

end.
