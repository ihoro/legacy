unit SendKey;

interface

uses
 SysUtils, Windows, Messages, Classes;

type
  TKeyString = String[7];

  TKeyDef = record
    Key: TKeyString;
    vkCode: Byte;
  end;

const
  MaxKeys = 24;
  ControlKey = '^';
  AltKey = '@';
  ShiftKey = '~';
  KeyGroupOpen = '{';
  KeyGroupClose = '}';

  KeyDefArray : array[1..MaxKeys] of TKeyDef = (
    (Key: 'F1';     vkCode: vk_F1),
    (Key: 'F2';     vkCode: vk_F2),
    (Key: 'F3';     vkCode: vk_F3),
    (Key: 'F4';     vkCode: vk_F4),
    (Key: 'F5';     vkCode: vk_F5),
    (Key: 'F6';     vkCode: vk_F6),
    (Key: 'F7';     vkCode: vk_F7),
    (Key: 'F8';     vkCode: vk_F8),
    (Key: 'F9';     vkCode: vk_F9),
    (Key: 'F10';    vkCode: vk_F10),
    (Key: 'F11';    vkCode: vk_F11),
    (Key: 'F12';    vkCode: vk_F12),
    (Key: 'INSERT'; vkCode: vk_Insert),
    (Key: 'DELETE'; vkCode: vk_Delete),
    (Key: 'HOME';   vkCode: vk_Home),
    (Key: 'END';    vkCode: vk_End),
    (Key: 'PGUP';   vkCode: vk_Prior),
    (Key: 'PGDN';   vkCode: vk_Next),
    (Key: 'TAB';    vkCode: vk_Tab),
    (Key: 'ENTER';  vkCode: vk_Return),
    (Key: 'BKSP';   vkCode: vk_Back),
    (Key: 'PRTSC';  vkCode: vk_SnapShot),
    (Key: 'SHIFT';  vkCode: vk_Shift),
    (Key: 'ESCAPE'; vkCode: vk_Escape));

type
    TSendKeyError = (sk_None, sk_FailSetHook, sk_InvalidToken,
    sk_UnknownError, sk_AlreadyPlaying);

  TvkKeySet = set of vk_LButton..vk_Scroll;

  ESendKeyError = class(Exception);
  ESKSetHookError = class(ESendKeyError);
  ESKInvalidToken = class(ESendKeyError);
  ESKAlreadyPlaying = class(ESendKeyError);

function SendKeys(S: String; PauseTime: Integer): TSendKeyError;
procedure WaitForHook;
procedure StopPlayback;

var
  Playing: Boolean;
  RPauseTime: Integer;

implementation

uses Forms;

type
  TMessageList = class(TList)
  public
    destructor Destroy; override;
  end;

const
  vkKeySet: TvkKeySet = [Ord('A')..Ord('Z'), vk_Menu, vk_F1..vk_F12];

destructor TMessageList.Destroy;
var
  i: longint;
begin
  for i := 0 to Count - 1 do
    Dispose(PEventMsg(Items[i]));
  inherited Destroy
end;

var
  MsgCount: word = 0;
  MessageBuffer: TEventMsg;
  HookHandle: hHook = 0;
  MessageList: TMessageList = Nil;
  AltPressed, ControlPressed, ShiftPressed: Boolean;

function FindKeyInArray(Key: TKeyString; var Code: Byte): Boolean;
var
  i: word;
begin
  Result := False;
  for i := Low(KeyDefArray) to High(KeyDefArray) do
    if UpperCase(Key) = KeyDefArray[i].Key then begin
      Code := KeyDefArray[i].vkCode;
      Result := True;
      Break
    end
end;

procedure StopPlayback;
begin
  if Playing then
    UnhookWindowsHookEx(HookHandle);
  MessageList.Free;
  Playing := False
end;

procedure DoPause(PauseTime: Integer);
var
  Time: Integer;
begin
  for Time:=1 to PauseTime do Application.ProcessMessages
end;


function Play(Code: integer; wParam, lParam: Longint): Longint; stdcall;
begin
  case Code of
    HC_SKIP:
      begin
        inc(MsgCount);
        if MsgCount >= MessageList.Count then StopPlayback
        else MessageBuffer := TEventMsg(MessageList.Items[MsgCount]^);
        Result := 0
      end;
    HC_GETNEXT:
      begin
        PEventMsg(lParam)^ := MessageBuffer;
        Result := 0
      end
    else
      Result := CallNextHookEx(HookHandle, Code, wParam, lParam)
  end
end;

procedure StartPlayback;
begin
  MessageBuffer := TEventMsg(MessageList.Items[0]^);
  MsgCount := 0;
  AltPressed := False;
  ControlPressed := False;
  ShiftPressed := False;
  HookHandle := SetWindowsHookEx(wh_JournalPlayback, Play, hInstance, 0);
  if HookHandle = 0 then
    raise ESKSetHookError.Create('Failed to set hook');
  Playing := True
end;

procedure MakeMessage(vKey: byte; M: Cardinal);
var
  E: PEventMsg;
begin
  New(E);
  with E^ do
  begin
    message := M;
    paramL := vKey;
    paramH := MapVirtualKey(vKey, 0);
    time := GetTickCount;
    hwnd := 0;
  end;
  MessageList.Add(E)
end;

procedure KeyDown(vKey: byte);
begin
  if AltPressed and (not ControlPressed) and  (vKey in vkKeySet) then
    MakeMessage(vKey, wm_SysKeyDown)
  else
    MakeMessage(vKey, wm_KeyDown)
end;

procedure KeyUp(vKey: byte);
begin
  if AltPressed and (not ControlPressed) and (vKey in vkKeySet) then
    MakeMessage(vKey, wm_SysKeyUp)
  else
    MakeMessage(vKey, wm_KeyUp)
end;

procedure SimKeyPresses(VKeyCode: Word);
begin
  if AltPressed then
    KeyDown(vk_Menu);
  if ControlPressed then
    KeyDown(vk_Control);
  if (((Hi(VKeyCode) and 1) <> 0) and (not ControlPressed)) or
    ShiftPressed then
    KeyDown(vk_Shift);
  KeyDown(Lo(VKeyCode));
  KeyUp(Lo(VKeyCode));
  if (((Hi(VKeyCode) and 1) <> 0) and (not ControlPressed)) or
    ShiftPressed then
    KeyUp(vk_Shift);
  if ShiftPressed then begin
    ShiftPressed := False;
  end;
  if ControlPressed then begin
    KeyUp(vk_Control);
    ControlPressed := False;
  end;
  if AltPressed then begin
    KeyUp(vk_Menu);
    AltPressed := False
  end
end;

procedure ProcessKey(S: String);
var
  KeyCode: word;
  Key: byte;
  index: integer;
  Token: TKeyString;
begin
  index := 1;
  repeat
    case S[index] of
      KeyGroupOpen:
        begin
          Token := '';
          inc(index);
          while S[index] <> KeyGroupClose do begin
            Token := Token + S[index];
            inc(index);
            if (Length(Token) = 7) and (S[index] <> KeyGroupClose) then
              raise ESKInvalidToken.Create('No closing brace');
          end;
          if not FindKeyInArray(Token, Key) then
            raise ESKInvalidToken.Create('Invalid token');
          SimKeyPresses(MakeWord(Key, 0));
        end;
      AltKey: AltPressed := True;
      ControlKey: ControlPressed := True;
      ShiftKey: ShiftPressed := True;
      else begin
        KeyCode := vkKeyScan(S[index]);
        SimKeyPresses(KeyCode)
      end
    end;
    Inc(index)
  until index > Length(S)
end;

procedure WaitForHook;
begin
  repeat Application.ProcessMessages until not Playing;
end;

function SendKeys(S: string; PauseTime: Integer): TSendKeyError;

begin
  Result := sk_None;
  try
    if Playing then raise ESKAlreadyPlaying.Create('');
    MessageList := TMessageList.Create;
    RPauseTime:=PauseTime;
    DoPause(RPauseTime);
    ProcessKey(S);
    StartPlayback;
  except
    on E:ESendKeyError do
    begin
      MessageList.Free;
      if E is ESKSetHookError then
        Result := sk_FailSetHook
      else if E is ESKInvalidToken then
        Result := sk_InvalidToken
      else if E is ESKAlreadyPlaying then
        Result := sk_AlreadyPlaying;
    end
    else
      Result := sk_UnknownError
  end
end;

end.

