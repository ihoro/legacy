program JC35;

uses
  Forms,
  main in 'main.pas' {Form1},
  Dialogs,
  SysUtils,
  Graphics,
  Coder in 'coder.pas',
  ColorsFrm in 'ColorsFrm.pas' {Colors},
  CongratulationsFrm in 'CongratulationsFrm.pas' {Congratulations},
  GlobalVars in 'GlobalVars.pas',
  picsize in 'picsize.pas' {Size},
  ScaleFrm in 'ScaleFrm.pas' {Scale},
  GamePasswordsFrm in 'GamePasswordsFrm.pas' {GP},
  WritingFrm in 'WritingFrm.pas' {Writing},
  About in 'About.pas' {AboutBox},
  MusicListFrm in 'MusicListFrm.pas' {MusicList},
  Registry,
  DecisionFrm in 'DecisionFrm.pas' {Decision},
  EnterFrm in 'EnterFrm.pas' {Enter};

{$R *.RES}

var
  TempBMP: TBitmap;
  RegS: TRegistry;
  s: string;
  Loop: Integer;
  Ok: Boolean;

begin
  Ok:=false;
  with Screen do
    for Loop:=0 to Fonts.Count-1 do
      if Fonts[Loop]='Small Fonts' then
        Ok:=true;
  if not Ok then
    begin
      MessageDlg('Не найден шрифт "Small Fonts".',
        mtError,[mbOK],0);
      Halt
    end;
  Ok:=false;
  with Screen do
    for Loop:=0 to Fonts.Count-1 do
      if Fonts[Loop]='MS Sans Serif' then
        Ok:=true;
  if not Ok then
    begin
      MessageDlg('Не найден шрифт "MS Sans Serif".',
        mtError,[mbOK],0);
      Halt
    end;
  RegS:=TRegistry.Create;
  if not RegS.OpenKey('\SOFTWARE\OIVSoft\Japanese Crossword',false) then
    begin
      MessageDlg('Ошибка в реестре.',mtError,[mbOK],0);
      Halt
    end;
  s:=RegS.ReadString('MainDirectory');
  s:=s+'\'+StandartTitleFile;
  if not FileExists(s) then
    begin
      MessageDlg('Не найден файл '+StandartTitleFile,mtError,[mbOK],0);
      Halt
    end;
  try
    TempBMP:=TBitmap.Create;
    try
      TempBMP.LoadFromFile(s);
    except
      MessageDlg('Ошибка чтения файла '+StandartTitleFile,mtError,[mbOK],0);
      Halt
    end;
  finally
    TempBMP.Free
  end;
  Application.Initialize;
  Application.Title := 'Японский кроссворд';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TColors, Colors);
  Application.CreateForm(TCongratulations, Congratulations);
  Application.CreateForm(TSize, Size);
  Application.CreateForm(TScale, Scale);
  Application.CreateForm(TWriting, Writing);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TMusicList, MusicList);
  Application.CreateForm(TDecision, Decision);
  Application.CreateForm(TEnter, Enter);
  Application.Run
end.
