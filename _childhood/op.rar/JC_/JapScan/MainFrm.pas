unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, Gauges, ExtCtrls;

type
  TMainForm = class(TForm)
    Lab: TLabel;
    dlb: TDirectoryListBox;
    flb: TFileListBox;
    g: TGauge;
    Bevel1: TBevel;
    Timer: TTimer;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TCrossword = array[-10..200,-10..200] of Boolean;

var
  MainForm: TMainForm;
//  Key: Byte = 15;
//  OIVSoft: string = 'Copiright (C) 2001 by OIVSoft';

//procedure SaveJCE(FileName:String;cX,cY: Byte;Crossw:TCrossword);
//function LoadJap(FileName:String;var cX,cY:Byte;var Crosswor:TCrossword):Boolean;
procedure SaveCrossword(FileName:String;cX,cY: Byte;Crossw:TCrossword);
function LoadCrossword(FileName:String;var cX,cY:Word;var Crosswor:TCrossword):Boolean;

implementation

{$R *.DFM}

{procedure SaveJCE(FileName:String;cX,cY: Byte;Crossw:TCrossword);
var
  Bits,WByte: Byte;
  f,l: Byte;
  Jap: TextFile;
begin
AssignFile(Jap,FileName);
try
  Rewrite(Jap);
  write(Jap,'JE',Chr(cX),Chr(cY));
  Bits:=8;
  WByte:=0;
  for l:=1 to cY do
    for f:=1 to cX do
      begin
        dec(Bits);
        if Crossw[f,l] then
          WByte:=WByte or (00000001 shl Bits);
        if (Bits=0) or (f=cX) then
          begin
            write(Jap,Chr(WByte));
            Bits:=8;
            WByte:=0
          end
      end;
except
MessageDlg('Ошибка записи файла '+ExtractFileName(FileName),mtError,[mbOK],0);
Close(Jap);
Erase(Jap);
Exit
end;
Close(Jap)
end;

function LoadJap(FileName:String;var cX,cY:Byte;var Crosswor:TCrossword):Boolean;
var
  s: String;
  Err,c,f,l: Integer;
  h: Char;
  Jap: TextFile;
begin
AssignFile(Jap,FileName);
Reset(Jap);
readln(Jap,s);
if CoderStr(s,-Key)<>OIVSoft then
  begin
    Result:=false;
    Exit
  end;
readln(Jap,s);
val(CoderStr(s,-Key),cX,Err);
readln(Jap,s);
val(CoderStr(s,-Key),cY,Err);
for l:=1 to cY do
  for f:=1 to cX do
    begin
      if (l=cY) and (f=cX) then readln(Jap,h)
                           else read(Jap,h);
      val(CoderStr(h,-Key),c,Err);
      case c of
        0:Crosswor[f,l]:=false;
        1:Crosswor[f,l]:=true
      end
    end;
CloseFile(Jap);
Result:=true
end;}

procedure TMainForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Close
end;

procedure TMainForm.TimerTimer(Sender: TObject);
var
  d: Integer;
  Total: Integer;
  Cr: TCrossword;
  x,y: Word;
  td: string;
begin
  Timer.Enabled:=false;
  Lab.Caption:='Scaning...';
  g.Progress:=0;
  GetDir(0,td);
  dlb.Directory:=td;
  Total:=0;
  for d:=1 to flb.Items.Count do
    if LoadCrossword(flb.Items[d-1],x,y,Cr) then
      begin
        inc(Total);
        SaveCrossword(Copy(flb.Items[d-1],1,Length(flb.Items[d-1])-3)+'jce',x,y,Cr);
        g.Progress:=Round(d/flb.Items.Count*100);
        g.Invalidate
      end;
  if flb.Items.Count=0 then Total:=0;
  Lab.Caption:=IntToStr(Total)+' files.'
end;

function LoadCrossword(FileName:String;var cX,cY:Word;var Crosswor:TCrossword):Boolean;
var
  c1,c2: Byte;
  f,l,b: Byte;
  Jap: file of Byte;
  s: string;
begin
AssignFile(Jap,FileName);
Reset(Jap);
read(Jap,c1,c2);
if UpperCase(Chr(c1)+Chr(c2))<>'JE' then
  begin
    LoadCrossword:=false;
    Exit
  end;
read(Jap,c1,c2);
cX:=c1;
cY:=c2;
for l:=1 to cY do
 begin
  f:=0;
  while f<cX do
    begin
      read(Jap,c1);
      for b:=7 downto 0 do
        begin
          inc(f);
          if f>cX then Break;
          if c1 and (00000001 shl b)<>0 then
            Crosswor[f,l]:=true
                                             else
            Crosswor[f,l]:=false
        end
    end
 end;
CloseFile(Jap);
Result:=true
end;

procedure SaveCrossword(FileName:String;cX,cY: Byte;Crossw:TCrossword);
var
  Bits,WByte: Byte;
  f,l: Byte;
  Jap: TextFile;
begin
AssignFile(Jap,FileName);
try
  Rewrite(Jap);
  write(Jap,'JE',Chr(cX),Chr(cY));
  Bits:=8;
  WByte:=0;
  for l:=1 to cY do
    for f:=1 to cX do
      begin
        dec(Bits);
        if Crossw[f,l] then
          WByte:=WByte or (00000001 shl Bits);
        if Bits=0 then
          begin
            write(Jap,Chr(WByte));
            Bits:=8;
            WByte:=0
          end;
        if (f=cX) and (l=cY) then
          write(Jap,Chr(WByte))
      end
except
//WriteError:=true;
MessageDlg('Ошибка записи файла '+ExtractFileName(FileName),mtError,[mbOK],0);
Close(Jap);
Erase(Jap);
Exit
end;
Close(Jap)
end;

end.
