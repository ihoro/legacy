unit mainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, XPMan, ComCtrls, ToolWin, ExtCtrls{, ReadFrm};

type
  TDateConnection = record
    Year: Word;
    Month: Byte;
    Day: Byte;
    Hour: Byte;
    Minute: Byte;
    Sec: Byte
  end;

  TFile = record
    FileName: string;
    Size: Integer;
    Speed: Double;
    k_b: Boolean;
    UpDown: Boolean;
    ErrorStr: string;
  end;

  TConnection = class
    public
      HostName: string;
      IP: string;
      Date: TDateConnection;
      Date2: TDateConnection;
      WorkTime: TDateConnection;
      ID: Integer;
      UserName: string;
      Password: string;
      Files: array of TFile;
      FilesCount: Integer;
      TimeOut: Boolean;
      constructor Create;
  end;

  TMain = class(TForm)
    MainMenu: TMainMenu;
    mmiFile: TMenuItem;
    sep1: TMenuItem;
    mmiLoad: TMenuItem;
    mmiExit: TMenuItem;
    ToolBar: TToolBar;
    Load: TToolButton;
    sep2: TToolButton;
    lwFiles: TListView;
    Splitter: TSplitter;
    StatusBar: TStatusBar;
    Settings1: TMenuItem;
    mmiOptions: TMenuItem;
    sep3: TMenuItem;
    OpenDialog: TOpenDialog;
    lwTime: TListView;
    procedure mmiExitClick(Sender: TObject);
    procedure mmiLoadClick(Sender: TObject);
    procedure lwTimeColumnClick(Sender: TObject; Column: TListColumn);
    procedure lwTimeSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lwFilesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lwFilesColumnClick(Sender: TObject; Column: TListColumn);
  private
  public
    LogFileName: string;
    function ReadLogFile: Boolean;
    function GetDate(s: string): TDateConnection;
    function GetWorkTime(s: string): TDateConnection;
    function GetID(s: string): Integer;
    function GetIP(s: string): string;
    function GetHostName(s: string): string;
    function GetUserName(s: string): string;
    function GetPassword(s: string): string;
    function GetFile(s: string): TFile;
    function IsClosingConn(s: string): Boolean;
    function IsServerStart(s: string): Boolean;
    function IsServerDown(s: string): Boolean;
    function IsTimeOut(s: string): Byte;
    function IsSentFile(s: string): Boolean;
    function IsPutFile(s: string): Boolean;
    function DateToStr(d: TDateConnection): string;
    function TimeToStr(d: TDateConnection): string;

    procedure FillTimeList;
    procedure FillFileList;
    procedure SortList;
  end;

var
  Main: TMain;
  IDLast: Integer;
  ConnCount: Integer;
  Conn: array of TConnection;
  Corr: array of Integer;
  CorrCount: Integer;
  SortBy: Integer;
  SortTo: Integer;
  FSortBy: Integer;
  FSortTo: Integer;
  ActItem: Integer;

implementation

{$R *.dfm}

{ TConnection }

constructor TConnection.Create;
begin
  FilesCount:=0;
  SetLength(Files,FilesCount);
  ID:=ConnCount;
  Conn[ID-1]:=Self
end;

{ TMain }

procedure TMain.mmiExitClick(Sender: TObject);
begin
  Close
end;

procedure TMain.mmiLoadClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    begin
      LogFileName:=OpenDialog.FileName;
      if not FileExists(LogFileName) then
        begin
          MessageBox(Self.Handle,'Read file error!','Error',MB_ICONERROR+MB_OK);
          StatusBar.Panels.Items[0].Text:='Error.';
          Exit
        end;
{      Read.btnStop.Caption:='Stop';
      Read.Show}
      ReadLogFile
    end
end;

function TMain.ReadLogFile: Boolean;
var
  LogFile: TextFile;
  s,c: string;
  //d: TDateConnection;
  id,i: Integer;
begin
  if not FileExists(LogFileName) then
    begin
      Result:=false;
      StatusBar.Panels.Items[0].Text:='Error.';
      Exit
    end;
  if lwTime.Items.Count<>0 then
    lwTime.Items.Clear;
  AssignFile(LogFile,LogFileName);
  Reset(LogFile);
  IDLast:=0;
  ConnCount:=0;
  CorrCount:=0;
  SortBy:=1;
  SortTo:=1;
  FSortBy:=1;
  FSortTo:=1;
//  StatusBar.Panels.Items[0].Text:='Reading...';
//  StatusBar.Panels.Items[1].Text:='Connections: '+IntToStr(ConnCount);
  while not eof(LogFile) do
    begin
      readln(LogFile,s);
      id:=GetID(s);
      if (id<>0) and (IDLast+id-2=ConnCount+CorrCount) then
        begin
          inc(CorrCount);
          SetLength(Corr,CorrCount);
          Corr[CorrCount-1]:=id
        end;
      if id<>0 then
        for i:=CorrCount-1 downto 0 do
          if id>=Corr[i] then
            dec(id);
      if IsServerStart(s) then
        begin
          IDLast:=ConnCount;
          CorrCount:=0;
          SetLength(Corr,CorrCount);
          Continue
        end;
      if (id<>0) and (IDLast+id>ConnCount) then
        begin
          inc(ConnCount);
          SetLength(Conn,ConnCount);
          lwTime.Items.Add;
          Conn[ConnCount-1]:=TConnection.Create;
          Conn[ConnCount-1].IP:=GetIP(s);
          Conn[ConnCount-1].Date:=GetDate(s);
          Conn[ConnCount-1].TimeOut:=false;
//          StatusBar.Panels.Items[1].Text:='Connections: '+IntToStr(ConnCount);
          Continue
        end;
      if (id<>0) and (IDLast+id<=ConnCount) then
        with Conn[IDLast+id-1] do
          begin
            if IsTimeOut(s)<>0 then
              begin
                TimeOut:=true;
                Continue
              end;
            if IsClosingConn(s) then
              begin
                Date2:=GetDate(s);
                WorkTime:=GetWorkTime(s);
                Continue
              end;
            if IsSentFile(s) then
              begin
                inc(FilesCount);
                SetLength(Files,FilesCount);
                Files[FilesCount-1]:=GetFile(s);
                Files[FilesCount-1].UpDown:=false
              end;
            if IsPutFile(s) then
              begin
                inc(FilesCount);
                SetLength(Files,FilesCount);
                Files[FilesCount-1]:=GetFile(s);
                Files[FilesCount-1].UpDown:=true
              end;
            c:=GetHostName(s);
            if c<>'' then
              begin
                HostName:=LowerCase(c);
                Continue
              end;
            c:=GetUserName(s);
            if c<>'' then
              begin
                UserName:=LowerCase(c);
                Password:=LowerCase(GetPassword(s))
              end
          end;
    end;
  CloseFile(LogFile);
  Result:=true;
  StatusBar.Panels.Items[0].Text:='Connections: '+IntToStr(ConnCount);
  FillTimeList
end;

function TMain.GetDate(s: string): TDateConnection;
var
  t: TDateConnection;
  c: string;
begin
  c:=copy(s,9,2);
  t.Day:=StrToInt(c);
  c:=UpperCase(copy(s,11,3));
  if c='JAN' then t.Month:=1;  if c='FEB' then t.Month:=2;
  if c='MAR' then t.Month:=3;  if c='APR' then t.Month:=4;
  if c='MAY' then t.Month:=5;  if c='JUN' then t.Month:=6;
  if c='JUL' then t.Month:=7;  if c='AUG' then t.Month:=8;
  if c='SEP' then t.Month:=9;  if c='OCT' then t.Month:=10;
  if c='NOV' then t.Month:=11;  if c='DEC' then t.Month:=12;
  c:='20'+copy(s,14,2);
  t.Year:=StrToInt(c);
  c:=copy(s,17,2);
  t.Hour:=StrToInt(c);
  c:=copy(s,20,2);
  t.Minute:=StrToInt(c);
  c:=copy(s,23,2);
  t.Sec:=StrToInt(c);
  Result:=t
end;

function TMain.GetID(s: string): Integer;
begin
  if copy(s,28,1)<>'(' then
    Result:=0
                       else
    Result:=StrToInt(copy(s,29,6))
end;

function TMain.GetIP(s: string): string;
var
  p: Integer;
begin
  if copy(s,37,12)<>'Connected to' then
    Result:=''
                                   else
    begin
      s:=copy(s,50,15);
      p:=Pos(' ',s);
      if p<>0 then
        Delete(s,p,Length(s)-p+1);
      Result:=s
    end
end;

function TMain.GetHostName(s: string): string;
var
  p: Integer;
begin
  if copy(s,37,8)<>'IP-Name:' then
    Result:=''
                              else
    begin
      p:=Pos('IP-Name:',s);
      Delete(s,1,p+8);
      Result:=s
    end
end;

function TMain.GetUserName(s: string): string;
var
  p: Integer;
begin
  p:=Pos('logged in,',s);
  if p=0 then
    begin
      Result:='';
      Exit
    end;
  Delete(s,1,Pos(') ',s)+1);
  s:=copy(s,1,Pos(' logged in,',s)-1);
  Result:=s
end;

function TMain.GetPassword(s: string): string;
var
  p: Integer;
begin
  p:=Pos('logged in,',s);
  if p=0 then
    begin
      Result:='';
      Exit
    end;
  Delete(s,1,Pos('logged in, password: ',s)+20);
  Result:=s
end;

function TMain.IsClosingConn(s: string): Boolean;
begin
  if Pos('Closing connection',s)<>0 then
    Result:=true
                                             else
    Result:=false
end;

function TMain.GetWorkTime(s: string): TDateConnection;
var
  c: string;
  t: TDateConnection;
  p: Integer;
begin
  if Pos('Closing connection for user',s)=0 then
    Exit;
  p:=Pos(' connected',s);
  c:=copy(s,p-8,2);
  t.Hour:=StrToInt(c);
  c:=copy(s,p-5,2);
  t.Minute:=StrToInt(c);
  c:=copy(s,p-2,2);
  t.Sec:=StrToInt(c);
  Result:=t
end;

function TMain.IsServerDown(s: string): Boolean;
begin
  if Pos('FTP server going down...',s)<>0 then
    Result:=true
                  else
    Result:=false
end;

function TMain.IsServerStart(s: string): Boolean;
begin
  if Pos('FTP Server listening on port',s)<>0 then
    Result:=true
                  else
    Result:=false
end;

procedure TMain.FillTimeList;
var
  i: Integer;
begin
  if (SortBy=1) and (SortTo=1) then
    for i:=0 to ConnCount-1 do
      with Conn[i] do
        begin
          lwTime.Items[i].Caption:=IntToStr(ID);
          if lwTime.Items[i].SubItems.Count<>0 then
            lwTime.Items[i].SubItems.Clear;
          lwTime.Items[i].SubItems.Add(IP);
          lwTime.Items[i].SubItems.Add(HostName);
          lwTime.Items[i].SubItems.Add(DateToStr(Date));
          lwTime.Items[i].SubItems.Add(DateToStr(Date2));
          if TimeOut then
            lwTime.Items[i].SubItems.Add('y')
                     else
            lwTime.Items[i].SubItems.Add('n');
          lwTime.Items[i].SubItems.Add(TimeToStr(WorkTime));
          lwTime.Items[i].SubItems.Add(UserName);
          lwTime.Items[i].SubItems.Add(Password);
          lwTime.Items[i].SubItems.Add(IntToStr(FilesCount))
        end;
  if (SortBy=1) and (SortTo=-1) then
    for i:=0 to ConnCount-1 do
      with Conn[ConnCount-i-1] do
        begin
          lwTime.Items[i].Caption:=IntToStr(ID);
          if lwTime.Items[i].SubItems.Count<>0 then
            lwTime.Items[i].SubItems.Clear;
          lwTime.Items[i].SubItems.Add(IP);
          lwTime.Items[i].SubItems.Add(HostName);
          lwTime.Items[i].SubItems.Add(DateToStr(Date));
          lwTime.Items[i].SubItems.Add(DateToStr(Date2));
          if TimeOut then
            lwTime.Items[i].SubItems.Add('y')
                     else
            lwTime.Items[i].SubItems.Add('n');
          lwTime.Items[i].SubItems.Add(TimeToStr(WorkTime));
          lwTime.Items[i].SubItems.Add(UserName);
          lwTime.Items[i].SubItems.Add(Password);
          lwTime.Items[i].SubItems.Add(IntToStr(FilesCount))
        end;
  Refresh
end;

function TMain.DateToStr(d: TDateConnection): string;
var
  c,t: string;
begin
  t:=IntToStr(d.Hour);
  if Length(t)=1 then
    t:='0'+t;
  c:=t+':';
  t:=IntToStr(d.Minute);
  if Length(t)=1 then
    t:='0'+t;
  c:=c+t+':';
  t:=IntToStr(d.Sec);
  if Length(t)=1 then
    t:='0'+t;
  c:=c+t+'  ';
  t:=IntToStr(d.Day);
  if Length(t)=1 then
    t:='0'+t;
  c:=c+t+'.';
  t:=IntToStr(d.Month);
  if Length(t)=1 then
    t:='0'+t;
  c:=c+t+'.';
  t:=copy(IntToStr(d.Year),3,2);
  c:=c+t;
  Result:=c
end;

function TMain.TimeToStr(d: TDateConnection): string;
var
  c,t: string;
begin
  t:=IntToStr(d.Hour);
  if Length(t)=1 then
    t:='0'+t;
  c:=t+':';
  t:=IntToStr(d.Minute);
  if Length(t)=1 then
    t:='0'+t;
  c:=c+t+':';
  t:=IntToStr(d.Sec);
  if Length(t)=1 then
    t:='0'+t;
  c:=c+t;
  Result:=c
end;

procedure TMain.lwTimeColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Caption='ID' then
    SortTo:=-SortTo;
  {if Column.Caption='ID' then
    begin
      if SortBy=1 then SortTo:=-SortTo;
      SortBy:=1
    end;
  if Column.Caption='IP' then
    begin
      if SortBy=2 then SortTo:=-SortTo;
      SortBy:=2
    end;
  if Column.Caption='Host Name' then
    begin
      if SortBy=3 then SortTo:=-SortTo;
      SortBy:=3
    end;
  if Column.Caption='Open Time' then
    begin
      if SortBy=4 then SortTo:=-SortTo;
      SortBy:=4
    end;
  if Column.Caption='Close Time' then
    begin
      if SortBy=5 then SortTo:=-SortTo;
      SortBy:=5
    end;
  if Column.Caption='Work Time' then
    begin
      if SortBy=6 then SortTo:=-SortTo;
      SortBy:=6
    end;
  if Column.Caption='User Name' then
    begin
      if SortBy=7 then SortTo:=-SortTo;
      SortBy:=7
    end;
  if Column.Caption='Password' then
    begin
      if SortBy=8 then SortTo:=-SortTo;
      SortBy:=8
    end;
  if Column.Caption='Files' then
    begin
      if SortBy=9 then SortTo:=-SortTo;
      SortBy:=9
    end;}
  FillTimeList
end;

function TMain.IsTimeOut(s: string): Byte;
begin
  if Pos('Connection timed out',s)=0 then
    Result:=0
                                     else
    Result:=1
end;

function TMain.IsSentFile(s: string): Boolean;
begin
  if Pos('Sent file',s)<>0 then
    Result:=true
                  else
    Result:=false
end;

function TMain.IsPutFile(s: string): Boolean;
begin
  if Pos('Received file',s)<>0 then
    Result:=true
                  else
    Result:=false
end;

function TMain.GetFile(s: string): TFile;
var
  t: TFile;
  p: Integer;
  c,sp: string;
begin
  p:=Pos('successfully',s);
  if p=0 then
    begin
      p:=Pos(' aborting',s);
      if p=0 then
        begin
          MessageBox(Self.Handle,PChar(s),'Error: call to author',MB_OK);
          Exit
        end
    end;
  if Pos('Kb/sec',s)<>0 then
    begin
      sp:='Kb/sec';
      t.k_b:=true
    end
                        else
    if Pos('bytes/sec',s)<>0 then
      begin
        sp:='bytes/sec';
        t.k_b:=false
      end
                        else
      begin
        MessageBox(Self.Handle,'Av. Speed: bytes/sec.','Error: call to author',MB_OK);
        Exit
      end;
  c:=s;
  Delete(c,p-1,Length(s)-p+2);
  Delete(c,1,Pos('file',c)+4);
  t.FileName:=c;
  c:=s;
  Delete(c,1,Pos(sp+' - ',c)+Length(sp)+2);
  t.Size:=StrToInt(copy(c,1,Pos(' bytes',c)-1));
  c:=s;
  Delete(c,1,p-1);
  t.ErrorStr:=copy(c,1,Pos(' (',c)-1);
  Delete(c,1,Pos('(',c));
  if Pos('.',c)<>0 then
    c[Pos('.',c)]:=',';
  t.Speed:=StrToFloat(copy(c,1,Pos(' '+sp,c)-1));
  if Pos('client closed data connection',s)<>0 then
    t.ErrorStr:='client closed data connection';
  Result:=t
end;

procedure TMain.lwTimeSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  ActItem:=StrToInt(Item.Caption);
  FillFileList
end;

procedure TMain.FillFileList;
var
  i,s: Integer;
  c: string;
begin
  if lwFiles.Items.Count<>0 then
    lwFiles.Items.Clear;
  for i:=0 to Conn[ActItem-1].FilesCount-1 do
    with Conn[ActItem-1].Files[i] do
      begin
        lwFiles.Items.Add;
        lwFiles.Items[i].Caption:=IntToStr(i+1);
        lwFiles.Items[i].SubItems.Add(ExtractFileName(FileName));
        if Size>1023 then
          if Size>1048575 then
            lwFiles.Items[i].SubItems.Add(FloatToStr(Round(Size/1048576*100)/100)+' MB')
                          else
            lwFiles.Items[i].SubItems.Add(FloatToStr(Round(Size/1024*10)/10)+' KB')
                     else
          lwFiles.Items[i].SubItems.Add(IntToStr(Size)+' B');
        if UpDown then
          lwFiles.Items[i].SubItems.Add('u')
                  else
          lwFiles.Items[i].SubItems.Add('d');
        if k_b then
          c:=' Kb/sec'
               else
          c:=' bytes/sec';
        lwFiles.Items[i].SubItems.Add(FloatToStr(Speed)+c);
        lwFiles.Items[i].SubItems.Add(ExtractFilePath(FileName));
        lwFiles.Items[i].SubItems.Add(ErrorStr)
      end;
  Refresh
end;

procedure TMain.lwFilesSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  FillFileList
end;

procedure TMain.lwFilesColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Caption='#' then
    begin
      if FSortBy=1 then FSortTo:=-FSortTo;
      FSortBy:=1;
      SortList
    end;
  if Column.Caption='File Name' then
    begin
      if FSortBy=2 then FSortTo:=-FSortTo;
      FSortBy:=2;
      SortList
    end;
  if Column.Caption='Size' then
    begin
      if FSortBy=3 then FSortTo:=-FSortTo;
      FSortBy:=3;
      SortList
    end;
  if Column.Caption='D/U' then
    begin
      if FSortBy=4 then FSortTo:=-FSortTo;
      FSortBy:=4;
      SortList
    end;
   if Column.Caption='Av. Speed' then
     begin
       if FSortBy=5 then FSortTo:=-FSortTo;
       FSortBy:=5;
       SortList
     end;
  if Column.Caption='Path' then
    begin
      if FSortBy=6 then FSortTo:=-FSortTo;
      FSortBy:=6;
      SortList
    end;
  if Column.Caption='Error Message' then
    begin
      if FSortBy=7 then FSortTo:=-FSortTo;
      FSortBy:=7;
      SortList
    end;
  lwFiles.Refresh
end;

procedure TMain.SortList;
var
  i,j: Integer;
  doit: Boolean;
begin
  with lwFiles.Items do
    begin
      Add;
      for i:=1 to Count-2 do
        for j:=0 to Count-i-2 do
          begin
            case FSortBy of
              1: begin
                if FSortTo>0 then
                  if StrToInt(Item[j].Caption)>StrToInt(Item[j+1].Caption) then
                    doit:=true
                                                                           else
                    doit:=false
                             else
                  if StrToInt(Item[j].Caption)<StrToInt(Item[j+1].Caption) then
                    doit:=true
                                                                           else
                    doit:=false
              end;
              2: begin
                if FSortTo>0 then
                  if Item[j].SubItems.Strings[0]>Item[j+1].SubItems.Strings[0] then
                    doit:=true
                                                                           else
                    doit:=false
                             else
                  if Item[j].SubItems.Strings[0]<Item[j+1].SubItems.Strings[0] then
                    doit:=true
                                                                           else
                    doit:=false
              end;
              3: begin
                if FSortTo>0 then
                  if StrToInt(Item[j].SubItems.Strings[1])>StrToInt(Item[j+1].SubItems.Strings[1]) then
                    doit:=true
                                                                           else
                    doit:=false
                             else
                  if StrToInt(Item[j].SubItems.Strings[1])<StrToInt(Item[j+1].SubItems.Strings[1]) then
                    doit:=true
                                                                           else
                    doit:=false
              end;
              4: begin
                if FSortTo>0 then
                  if Item[j].SubItems.Strings[2]>Item[j+1].SubItems.Strings[2] then
                    doit:=true
                                                                           else
                    doit:=false
                             else
                  if Item[j].SubItems.Strings[2]<Item[j+1].SubItems.Strings[2] then
                    doit:=true
                                                                           else
                    doit:=false
              end;
              5: begin
                if FSortTo>0 then
                  if StrToInt(Item[j].SubItems.Strings[3])>StrToInt(Item[j+1].SubItems.Strings[3]) then
                    doit:=true
                                                                           else
                    doit:=false
                             else
                  if StrToInt(Item[j].SubItems.Strings[3])<StrToInt(Item[j+1].SubItems.Strings[3]) then
                    doit:=true
                                                                           else
                    doit:=false
              end;
              6: begin
                if FSortTo>0 then
                  if Item[j].SubItems.Strings[4]>Item[j+1].SubItems.Strings[4] then
                    doit:=true
                                                                           else
                    doit:=false
                             else
                  if Item[j].SubItems.Strings[4]<Item[j+1].SubItems.Strings[4] then
                    doit:=true
                                                                           else
                    doit:=false
              end;
              7: begin
                if FSortTo>0 then
                  if Item[j].SubItems.Strings[5]>Item[j+1].SubItems.Strings[5] then
                    doit:=true
                                                                           else
                    doit:=false
                             else
                  if Item[j].SubItems.Strings[5]<Item[j+1].SubItems.Strings[5] then
                    doit:=true
                                                                           else
                    doit:=false
              end
            end;
            if doit then
              begin
                Item[Count-1]:=Item[j];
                Item[j]:=Item[j+1];
                Item[j+1]:=Item[Count-1]
              end
          end;
      Delete(Count-1)
    end
end;

end.
