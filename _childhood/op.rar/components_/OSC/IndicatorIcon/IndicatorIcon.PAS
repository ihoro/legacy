unit IndicatorIcon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, ShellAPI;

const
  WM_ICONMSG = WM_USER+100;
  MaxIcons = 50;

type
  {TAnimation = class(TPersistent)
  private
    FSpeed: Integer;
    FIcons: array[1..MaxIcons] of TIcon;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;}

  TVirWindow = class
  private
    FWindowHandle: HWND;
    procedure WindowProc(var Msg: TMessage);
  public
    property WindowHandle: HWND read FWindowHandle
      write FWindowHandle;
    constructor Create;
    destructor Destroy; override;
  end;

  TIndicatorIcon = class(TComponent)
  private
    FIcon: TIcon;
    FVisible: Boolean;
    FHint: string;
    FPopupMenu: TPopupMenu;
    {FWindowVisible: Boolean;
    FAnimation: TAnimation;}
    {FAnimationVisible: Boolean;
    FAnimationSpeed: Integer;
    FAnimationIcons: TImageList;}
    FDataNI: TNotifyIconData;
    FYesDblClick: Boolean;
    FTimer: TTimer;
    FOnClick,
    FOnDblClick: TNotifyEvent;
    procedure SetIcon(aValue: TIcon);
    procedure SetVisible(aValue: Boolean);
    procedure SetHint(aValue: string);
    procedure SetPopupMenu(aValue: TPopupMenu);
    {procedure SetWindowVisible(aValue: Boolean);}
    {procedure SetAnimationVisible(aValue: Boolean);
    procedure SetAnimationSpeed(aValue: Integer);
    procedure SetAnimationIcons(aValue: TImageList);}
    procedure SendMessage(aMsg: DWORD; aFlags: UINT);
    procedure FTimerTimer(Sender: TObject);
    function GetHIcon: THandle;
    { Private declarations }
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public declarations }
  published
    property Icon: TIcon read FIcon write
      SetIcon;
    property Visible: Boolean read FVisible
      write SetVisible default false;
    property Hint: string read FHint
      write SetHint;
    {property WindowVisible: Boolean read FWindowVisible
      write SetWindowVisible;}
    property PopupMenu: TPopupMenu read FPopupMenu
      write SetPopupMenu;
    {property Animation: TAnimation read FAnimation
      write FAnimation;}
    {property AnimationVisible: Boolean read FAnimationVisible
      write SetAnimationVisible;
    property AnimationSpeed: Integer read FAnimationSpeed
      write SetAnimationSpeed;
    property AnimationIcons: TImageList read FAnimationIcons
      write SetAnimationIcons;}      
    property OnClick: TNotifyEvent read FOnClick
      write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick
      write FOnDblClick;
    { Published declarations }
  end;

implementation

var
  VirWindow: TVirWindow;

{ TAnimation

constructor TAnimation.Create;
var
  f: Integer;
begin
  inherited Create;
  FSpeed:=1;
  for f:=1 to MaxIcons do
    FIcons[f]:=TIcon.Create
end;

destructor TAnimation.Destroy;
var
  f: Integer;
begin
  for f:=1 to MaxIcons do
    FIcons[f].Free;
  inherited Destroy
end;

{procedure TAnimation.Assign(Source: TPersistent);
begin
  if Source is TAnimation then
    begin
      FSpeed:=TAnimation(Source).Speed;
      inherited Assign(Source)
    end
end;}

{ TVirWindow }

constructor TVirWindow.Create;
begin
  FWindowHandle:=AllocateHWnd(WindowProc)
end;

destructor TVirWindow.Destroy;
begin
  if FWindowHandle<>0 then
    DeallocateHWnd(FWindowHandle);
  inherited Destroy
end;

procedure TVirWindow.WindowProc(var Msg: TMessage);
var
  TIC: TIndicatorIcon;
  curPos: TPoint;
begin
  with Msg do
    begin
      if Msg=WM_ICONMSG then
        begin
          TIC:=TIndicatorIcon(WParam);
          case LParam of
            WM_LBUTTONDOWN:
              TIC.FTimer.Enabled:=true;
            WM_LBUTTONDBLCLK:
              begin
                TIC.FYesDblClick:=true;
                if Assigned(TIC.FOnDblClick) then TIC.FOnDblClick(Self)
              end;
            WM_RBUTTONDOWN:
              begin
                if TIC.FPopupMenu=nil then Exit;
                SetForegroundWindow(VirWindow.FWindowHandle);
                GetCursorPos(curPos);
                TIC.FPopupMenu.Popup(curPos.X,curPos.Y);
                PostMessage(VirWindow.FWindowHandle,WM_USER,0,0)
              end
          end
        end
                        else
        Result:=DefWindowProc(FWindowHandle,Msg,WParam,LParam)
    end
end;

{ TIndicatorIcon }

procedure TIndicatorIcon.SetVisible(aValue: Boolean);
begin
  if aValue=FVisible then Exit;
  FVisible:=aValue;
  if aValue then
    SendMessage(NIM_ADD,NIF_MESSAGE or NIF_ICON
      or NIF_TIP)
            else
    SendMessage(NIM_DELETE,NIF_MESSAGE or NIF_ICON or
      NIF_TIP)
end;

function TIndicatorIcon.GetHIcon: THandle;
begin
  if FIcon.Handle<>0 then
    Result:=FIcon.Handle
                     else
    Result:=LoadIcon(0,IDI_WINLOGO)
end;

procedure TIndicatorIcon.SetIcon(aValue: TIcon);
begin
  FIcon.Assign(aValue);
  if FVisible then
    SendMessage(NIM_MODIFY,NIF_ICON)
end;

procedure TIndicatorIcon.SetHint(aValue: string);
begin
  FHint:=aValue;
  if FVisible then
    SendMessage(NIM_MODIFY,NIF_TIP)
end;

procedure TIndicatorIcon.SendMessage(aMsg: DWORD; aFlags: UINT);
begin
  with FDataNI do
    begin
      cbSize:=SizeOf(TNotifyIconData);
      Wnd:=VirWindow.WindowHandle;
      uId:=UINT(Self);
      uFlags:=aFlags;
      hIcon:=GetHIcon;
      uCallbackMessage:=WM_ICONMSG;
      StrPLCopy(szTip,PChar(FHint),SizeOf(szTip))
    end;
  Shell_NotifyIcon(aMsg,@FDataNI)
end;

constructor TIndicatorIcon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {FAnimation:=TAnimation.Create;}
  {FAnimationIcons:=TImageList.Create(Self);}
  FIcon:=TIcon.Create;
  FYesDblClick:=false;
  FTimer:=TTimer.Create(Self);
  with FTimer do
    begin
      Enabled:=false;
      Interval:=GetDoubleClickTime;
      OnTimer:=FTimerTimer
    end
end;

destructor TIndicatorIcon.Destroy;
begin
  if FVisible then Visible:=false;
  FIcon.Free;
  FTimer.Free;
  {FAnimation.Free;}
  {FAnimationIcons.Free;}
  inherited Destroy
end;

procedure TIndicatorIcon.FTimerTimer(Sender: TObject);
begin
  FTimer.Enabled:=false;
  if not FYesDblClick and Assigned(FOnClick) then
    FOnClick(Self);
  FYesDblClick:=false
end;

procedure TIndicatorIcon.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) and (AComponent=PopupMenu) then
    PopupMenu:=nil
end;

procedure TIndicatorIcon.SetPopupMenu(aValue: TPopupMenu);
begin
  FPopupMenu:=aValue;
  if aValue<>nil then aValue.FreeNotification(Self)
end;

{procedure TIndicatorIcon.SetAnimationSpeed(aValue: Integer);
begin
  FAnimationSpeed:=aValue
end;

procedure TIndicatorIcon.SetAnimationVisible(aValue: Boolean);
begin
  FAnimationVisible:=aValue
end;

procedure TIndicatorIcon.SetAnimationIcons(aValue: TImageList);
begin
  FAnimationIcons.Assign(aValue)
end;}

{procedure TIndicatorIcon.SetWindowVisible(aValue: Boolean);
begin
  if FWindowVisible=aValue then Exit;
  FWindowVisible:=aValue;
  if csDesigning in ComponentState then Exit;
  if FWindowVisible then
    Application.MainForm.Visible:=true
                    else
    Application.MainForm.Visible:=false
end;}

initialization
  VirWindow:=TVirWindow.Create

finalization
  VirWindow.Free

end.
