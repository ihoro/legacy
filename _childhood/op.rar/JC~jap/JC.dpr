program JC;

uses
  Forms,
  Windows,
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
  EnterFrm in 'EnterFrm.pas' {Enter},
  ViewerFrm in 'ViewerFrm.pas' {ViewerForm},
  PreviewFrm in 'PreviewFrm.pas' {Preview};

{$R *.RES}

var
  TempBMP: TBitmap;
  RegS: TRegistry;
  s,td,ttd: string;
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
  GetDir(0,td);  
  RegS:=TRegistry.Create;
  RegS.RootKey:=HKEY_CURRENT_USER;
  if not RegS.OpenKey('\SOFTWARE\OIVSoft\Japanese Crossword',false) then
    begin
      MessageDlg('Ошибка в реестре.',mtError,[mbOK],0);
      Halt
    end;
  if RegS.ReadInteger('First')=1 then
    begin
      RegS.WriteInteger('Background',14078931);
      RegS.WriteInteger('BackgroundFigures',12632256);
      RegS.WriteInteger('BackgroundFigures2',7320456);
      RegS.WriteInteger('Clear',232365);
      RegS.WriteInteger('Count',0);
      RegS.WriteInteger('Figures',0);
      RegS.WriteInteger('MusicOnOff',0);
      RegS.WriteInteger('Point',9004594);
      RegS.WriteInteger('First',0);
      RegS.WriteString('BackgroundFile',td+'\'+StandartTitleFile);
      RegS.WriteString('Import',td);
      RegS.WriteString('JAP',td);
      RegS.WriteString('JCD',td);
      RegS.WriteString('MainDirectory',td)
    end;
  ttd:=RegS.ReadString('MainDirectory');
  s:=ttd+'\'+StandartTitleFile;
  RegS.CloseKey;
  RegS.Free;
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
  Application.CreateForm(TViewerForm, ViewerForm);
  Application.CreateForm(TPreview, Preview);
  Application.Run
end.
