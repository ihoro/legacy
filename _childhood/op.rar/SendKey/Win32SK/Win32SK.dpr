program Win32SK;

uses
  SysUtils,
  Classes,
  SendKey,
  Windows;

const
  FilePath = '\comptalk.txt';

var
  CriticalPauseTime: Integer = 40000;

  CriticalText: string = 'Привет, дурачок!'+
    ' Зачем стер файл, где хранится мой базар?'+
    ' Я теперь не знаю, что говорить. И в будущем '+
    'буду напоминать про это! Бегом сделай файлик, '+
    'чтобы я мог говорить то, что ты захочешь! Кстати, '+
    'после создания этого файла надо перезагрузить меня! '+
    'Понял? Я тебя спрашиваю? Короче говоря, ВЫПОЛНЯЙ! '+
    'File path: Windows'' main directory\comptalk.txt';

  RussianText: set of Char =
    ['А','Б','В','Г','Д','Е','Ё','Ж','З',
    'И','Й','К','Л','М','Н','О','П','Р',
    'С','Т','У','Ф','Х','Ц','Ч','Ш','Щ',
    'Ь','Ы','Ъ','Э','Ю','Я','а','б','в',
    'г','д','е','ё','ж','з','и','й','к',
    'л','м','н','о','п','р','с','т','у',
    'ф','х','ц','ч','ш','щ','ь','ы','ъ',
    'э','ю','я'];
  EnglishText: set of Char =
    ['A','B','C','D','E','F','G','H','I',
    'J','K','L','M','N','O','P','Q','R',
    'S','T','U','V','W','X','Y','Z'];

  TXT: TextFile;
  p: PChar;
  MainText: string;
  h: Char;
  CurrentKey: Integer;
  PauseTime: Integer;
  l: Integer;

  Russian, English: HKL;

begin
  MainText:='';
  PauseTime:=CriticalPauseTime;
  New(p);
  GetWindowsDirectory(p,SizeOf(p));
{$I-}
  Assign(TXT,StrPas(p){'c:\windows'}+FilePath);
  Reset(TXT);
  if IOResult<>0 then
    MainText:=CriticalText
                 else
{$I+}
    begin
      while not EOF(TXT) do
        begin
          read(TXT,h);
          if (h<>#13) and (h<>#10) and (h<>#27) then
            MainText:=MainText+h
        end;
      CloseFile(TXT)
    end;
  CurrentKey:=0;
  repeat
    inc(CurrentKey);
    if CurrentKey>Length(MainText) then
      CurrentKey:=1;
    if not (MainText[CurrentKey] in RussianText) then
      begin
        English:=LoadKeyboardLayout('00000409',0);
        Russian:=LoadKeyboardLayout('00000419',0);
        ActivateKeyboardLayout(Russian,0);
        ActivateKeyboardLayout(English,0);
        if (UpperCase(MainText[CurrentKey])=MainText[CurrentKey]) and
          (UpCase(MainText[CurrentKey]) in EnglishText) then
          SendKeys('~'+MainText[CurrentKey],PauseTime)
                                                        else
          SendKeys(MainText[CurrentKey],PauseTime)
      end else
    {if UpCase(MainText[CurrentKey]) in RussianText then}
      begin
        English:=LoadKeyboardLayout('00000409',0);
        Russian:=LoadKeyboardLayout('00000419',0);
        ActivateKeyboardLayout(English,0);
        ActivateKeyboardLayout(Russian,0);
        SendKeys(MainText[CurrentKey],PauseTime)
      end;
    WaitForHook
  until false
end.

