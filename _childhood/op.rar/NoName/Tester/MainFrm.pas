unit MainFrm;

interface

uses
  Windows, Forms,  Spin, StdCtrls, Controls, Classes, Buttons, Graphics,
  ExtCtrls;

type
  TForm1 = class(TForm)
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    Image1: TImage;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  semOur,semGo: THandle;
  Rslt: LongBool;
  StartUpInfo: TStartUpInfo;
  ProcessInfo: TProcessInformation;

implementation

uses
  MyUtils;

const
  Size = 100;

type
  typ = string[Size];

var
  Data: THandle;
  PData: Pointer;
  ss: ^typ;
  y: Boolean;

{$R *.DFM}

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  New(ss);
  semOur:=CreateSemaphore(nil,0,1,'OUR_S1');
  semGo:=CreateSemaphore(nil,0,1,'go');
  FillChar(StartUpInfo,SizeOf(TStartUpInfo),0);
  with StartUpInfo do
    begin
      cb:=SizeOf(TStartUpInfo);
      dwFlags:=STARTF_USESHOWWINDOW;
      wShowWindow:=SW_SHOW
    end;
  Rslt:=CreateProcess('Dller.exe',nil,nil,
    nil,false,NORMAL_PRIORITY_CLASS,nil,nil,
    StartUpInfo,ProcessInfo);
  if not Rslt then
    begin
      MessageBox(0,'Ты чеВо бастуешь и не запускаешься?',
        'Error',MB_OK);
      Halt
    end
              else
    with ProcessInfo do
      begin
        Sleep(1000);
        CloseHandle(hThread);
        CloseHandle(hProcess)
      end
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Data:=GlobalAlloc(GMEM_MOVEABLE,Size);
  ss^:=its(SpinEdit1.Value)+' '+
    its(SpinEdit2.Value);
  OpenClipboard(0);
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
  ReleaseSemaphore(semOur,1,nil);
  if WaitForSingleObject(semOur,INFINITE)=WAIT_OBJECT_0 then
    begin
      OpenClipboard(0);
      Data:=GetClipboardData(CF_TEXT);
      try
        PData:=GlobalLock(Data);
        Move(ptr(Int64(PData)-1)^,ss^,Size);
        Edit1.Text:=ss^;
      finally
        GlobalUnLock(Data)
      end;
      CloseClipboard
    end
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Dispose(ss);
  ReleaseSemaphore(semGo,1,nil);
  ReleaseSemaphore(semOur,1,nil);
  CloseHandle(semOur);
  CloseHandle(semGo)
end;

{procedure Doing;
var
  r: THandle;
begin
  with Form1 do
    begin
      x:=Random(Width-4);
      y:=Random(Height-4);
      r:=CreateRectRgn(x,y,x+5,y+5);
      CombineRgn(rr,rr,r,RGN_DIFF);
      SetWindowRgn(Handle,rr,true);
      DeleteObject(r);
      r:=0
    end;
  inc(f);
  if f=10 then Exit
          else Doing
end;}

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if y then
    begin
      Height:=Height-29;
      y:=false
    end
       else
    begin
      Height:=Height+29;
      y:=true
    end  
end;

end.
