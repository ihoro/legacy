unit MusicListFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TMusicList = class(TForm)
    GroupBox1: TGroupBox;
    lbMusicList: TListBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    odMusic: TOpenDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Button5: TButton;
    Button6: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    procedure odMusicShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure lbMusicListClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    FIndex: Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MusicList: TMusicList;

implementation

uses
  Main;

var
  ML: Text;

{$R *.DFM}

procedure TMusicList.odMusicShow(Sender: TObject);
begin
  if OpenMusicFirst then
    begin
      odMusic.FileName:=OpenMusic;
      OpenMusicFirst:=false;
      Exit
    end
                      else
    odMusic.InitialDir:=OpenMusic
end;

procedure TMusicList.Button1Click(Sender: TObject);
begin
  if odMusic.Execute then
    begin
      lbMusicList.Items.AddStrings(odMusic.Files)
    end
end;

procedure TMusicList.Button2Click(Sender: TObject);
begin
  lbMusicList.Items.Delete(lbMusicList.ItemIndex)
end;

procedure TMusicList.SpeedButton1Click(Sender: TObject);
begin
  with lbMusicList do
    if ItemIndex>TopIndex then
      begin
        Items.Move(ItemIndex,ItemIndex-1);
        ItemIndex:=FIndex-1;
        dec(FIndex)
      end
end;

procedure TMusicList.SpeedButton2Click(Sender: TObject);
begin
  with lbMusicList do
    if (ItemIndex<Items.Count-1) and (ItemIndex>=TopIndex) then
      begin
        Items.Move(ItemIndex,ItemIndex+1);
        ItemIndex:=FIndex+1;
        inc(FIndex)
      end
end;

procedure TMusicList.lbMusicListClick(Sender: TObject);
begin
  FIndex:=lbMusicList.ItemIndex
end;

procedure TMusicList.Button3Click(Sender: TObject);
begin
  lbMusicList.Clear
end;

procedure TMusicList.Button4Click(Sender: TObject);
begin
  if lbMusicList.Items.Count>0 then
    begin
      MusicOnOff:=true;
      Form1.mmiMusicOnOff.Enabled:=true
    end
                               else
    Form1.mmiMusicOnOff.Enabled:=false;
  if MusicOnOff then
    Form1.mmiMusicOnOff.Caption:='&Выключить'
                else
    Form1.mmiMusicOnOff.Caption:='&Включить';
  WriteSetup;
  Form1.FMusic:=-1;
  Close
end;

procedure TMusicList.Button5Click(Sender: TObject);
var
  f: Integer;
begin
  if SaveDialog1.Execute then
    begin
      AssignFile(ML,SaveDialog1.FileName);
      Rewrite(ML);
      for f:=0 to lbMusicList.Items.Count-1 do
        writeln(ML,lbMusicList.Items[f]);
      CloseFile(ML)
    end;
end;

procedure TMusicList.Button6Click(Sender: TObject);
var
  s: string;
begin
  if OpenDialog1.Execute then
    begin
      AssignFile(ML,OpenDialog1.FileName);
      Reset(ML);
      lbMusicList.Clear;
      while not EOF(ML) do
        begin
          readln(ML,s);
          lbMusicList.Items.Add(s)
        end;
      CloseFile(ML)
    end;
end;

end.
