procedure SaveFile(Name:string);
begin
Assign(gim,Name+'.gim');
Rewrite(gim);
writeln(gim,CoderStr(TestText,Key));
for f:=1 to 6 do
  begin
    for l:=1 to 2 do
      begin
        str(Part[f,l].TotalVir,s);
        writeln(gim,CoderStr(s,Key));
        for ff:=1 to Part[f,l].TotalVir do
          begin
            str(Part[f,l].Vir[ff].Typ,s);
            writeln(gim,CoderStr(s,Key));
            case Part[f,l].Vir[ff].First of
              kore:s:='1';
              modu:s:='2';
              zero:s:='3'
            end;
            writeln(gim,CoderStr(s,Key));
            case Part[f,l].Vir[ff].Koren of
              true:s:='1';
              false:s:='0'
            end;
            writeln(gim,CoderStr(s,Key));
            case Part[f,l].Vir[ff].Modul of
              true:s:='1';
              false:s:='0'
            end;
            writeln(gim,CoderStr(s,Key));
            str(Part[f,l].Vir[ff].A,s);
            writeln(gim,CoderStr(s,Key));
            str(Part[f,l].Vir[ff].B,s);
            writeln(gim,CoderStr(s,Key));
            str(Part[f,l].Vir[ff].C,s);
            writeln(gim,CoderStr(s,Key))
          end;
        for ff:=1 to Part[f,l].TotalVir-1 do
          begin
            str(Part[f,l].Znak[ff],s);
            writeln(gim,CoderStr(s,Key))
          end;
      end;
    str(VirIf[f],s);
    writeln(gim,CoderStr(s,Key))
  end;
for f:=1 to 6 do
  begin
    case PartOnOff[f] of
      true:s:='1';
      false:s:='0'
    end;
    writeln(gim,CoderStr(s,Key))
  end;
writeln(gim,CoderStr(TestText,Key));
Close(gim)
end;

function CheckError(Error:Integer):Boolean;
begin
if Error<>0 then CheckError:=true
            else CheckError:=false
end;

procedure LoadFile(Name:string;var EExit:Boolean);
var Err:Integer;
begin
EExit:=true;
BakPart^:=Part;
Assign(gim,Name+'.gim');
Reset(gim);
readln(gim,h);
for f:=1 to 6 do
  begin
    for l:=1 to 2 do
      begin
        readln(gim,s);
        val(CoderStr(s,-Key),Part[f,l].TotalVir,Err);
        if CheckError(Err) then
          begin
            Message('Ошибка чтения файла '+Name+'.GIM!');
            Part:=BakPart^;
            EExit:=false;
            Exit
          end;
        for ff:=1 to Part[f,l].TotalVir do
          begin
            readln(gim,s);
            val(CoderStr(s,-Key),Part[f,l].Vir[ff].Typ,Err);
            if CheckError(Err) then
              begin
                Message('Ошибка чтения файла '+Name+'.GIM!');
                Part:=BakPart^;
                EExit:=false;
                Exit
              end;
            readln(gim,s);
            val(CoderStr(s,-Key),FX,Err);
            if CheckError(Err) then
              begin
                Message('Ошибка чтения файла '+Name+'.GIM!');
                Part:=BakPart^;
                EExit:=false;
                Exit
              end;
            case FX of
              1:Part[f,l].Vir[ff].First:=kore;
              2:Part[f,l].Vir[ff].First:=modu;
              3:Part[f,l].Vir[ff].First:=zero
            end;
            readln(gim,s);
            val(CoderStr(s,-Key),FX,Err);
            if CheckError(Err) then
              begin
                Message('Ошибка чтения файла '+Name+'.GIM!');
                Part:=BakPart^;
                EExit:=false;
                Exit
              end;
            case FX of
              1:Part[f,l].Vir[ff].Koren:=true;
              0:Part[f,l].Vir[ff].Koren:=false
            end;
            readln(gim,s);
            val(CoderStr(s,-Key),FX,Err);
            if CheckError(Err) then
              begin
                Message('Ошибка чтения файла '+Name+'.GIM!');
                Part:=BakPart^;
                EExit:=false;
                Exit
              end;
            case FX of
              1:Part[f,l].Vir[ff].Modul:=true;
              0:Part[f,l].Vir[ff].Modul:=false
            end;
            readln(gim,s);
            val(CoderStr(s,-Key),Part[f,l].Vir[ff].A,Err);
            if CheckError(Err) then
              begin
                Message('Ошибка чтения файла '+Name+'.GIM!');
                Part:=BakPart^;
                EExit:=false;
                Exit
              end;
            readln(gim,s);
            val(CoderStr(s,-Key),Part[f,l].Vir[ff].B,Err);
            if CheckError(Err) then
              begin
                Message('Ошибка чтения файла '+Name+'.GIM!');
                Part:=BakPart^;
                EExit:=false;
                Exit
              end;
            readln(gim,s);
            val(CoderStr(s,-Key),Part[f,l].Vir[ff].C,Err);
            if CheckError(Err) then
              begin
                Message('Ошибка чтения файла '+Name+'.GIM!');
                Part:=BakPart^;
                EExit:=false;
                Exit
              end
          end;
        for ff:=1 to Part[f,l].TotalVir-1 do
          begin
            readln(gim,s);
            val(CoderStr(s,-Key),Part[f,l].Znak[ff],Err);
            if CheckError(Err) then
              begin
                Message('Ошибка чтения файла '+Name+'.GIM!');
                Part:=BakPart^;
                EExit:=false;
                Exit
              end
          end;
      end;
    readln(gim,s);
    val(CoderStr(s,-Key),VirIf[f],Err);
    if CheckError(Err) then
      begin
        Message('Ошибка чтения файла '+Name+'.GIM!');
        Part:=BakPart^;
        EExit:=false;
        Exit
      end
  end;
for f:=1 to 6 do
  begin
    readln(gim,s);
    val(CoderStr(s,-Key),FX,Err);
    if CheckError(Err) then
      begin
        Message('Ошибка чтения файла '+Name+'.GIM!');
        Part:=BakPart^;
        EExit:=false;
        Exit
      end;
    case FX of
      1:PartOnOff[f]:=true;
      0:PartOnOff[f]:=false
    end
  end;
Close(gim)
end;

procedure ReadSpisok;
begin
TotalSpisok:=0;
FindFirst('*.gim',AnyFile,TFile);
while (DosError=0) and (TotalSpisok<MaxSpisok) do
  begin
    inc(TotalSpisok);
    Files^[TotalSpisok]:=Copy(TFile.Name,1,Pos('.',TFile.Name)-1);
    FindNext(TFile)
  end
end;

procedure WriteSpisok;
begin
ClearZone(188,194,73,82,15);
if TotalSpisok=0 then Exit;
if TotalSpisok<(SpisokX+11) then l:=TotalSpisok
                            else l:=SpisokX+11;
for ff:=SpisokX to l do
  if ff<>SpisokV then
    begin
      ClearZone(189,185+9*(ff-SpisokX+1),71,9,15);
      SetColor(ColorText);
      HideMouse;
      OutTextXY(194,186+9*(ff-SpisokX+1),Files^[ff]);
      ShowMouse
    end
                 else
    begin
      ClearZone(189,185+9*(ff-SpisokX+1),71,9,9);
      SetColor(ColorLigth);
      HideMouse;
      OutTextXY(194,186+9*(ff-SpisokX+1),Files^[ff]);
      ShowMouse
    end
end;

procedure IfMy;
begin
HideMouse;
if not BOIVButtonPush then
  begin
    Image.Import('oivbpush.pfp',@Filter);
    Image.Draw(559,8,NormalPut);
    Size:=ImageSize(559,8,623,53);
    GetMem(POIVButtonPush,Size);
    GetImage(559,8,623,53,POIVButtonPush^);
    Image.Done;
    BOIVButtonPush:=true
  end
                      else
  PutImage(559,8,POIVButtonPush^,0);
ShowMouse;
Delay(PushButtonDelay*2);
HideMouse;
if not BOIVButton then
  begin
    Image.Import('oivbutt.pfp',@Filter);
    Image.Draw(559,8,NormalPut);
    Size:=ImageSize(559,8,623,53);
    GetMem(POIVButton,Size);
    GetImage(559,8,623,53,POIVButton^);
    Image.Done;
    BOIVButton:=true
  end
                  else
  PutImage(559,8,POIVButton^,0);
Size:=ImageSize(170,110,470,320);
GetMem(PSpace,Size);
GetImage(170,110,470,320,PSpace^);
ShowMouse;
HideMouse;
GraphWindow(170,110,300,210,'О программе');
ButtonDisable(175,140,290,15,'Программу разработал');
ButtonDisable(175,155,290,15,'учащийся лицея');
ButtonDisable(175,170,290,15,'III-M курса');
ButtonDisable(175,185,290,15,'Остапенко Игорь');
ButtonDisable(175,215,290,15,'г. Смела');
ButtonDisable(175,230,290,15,'(c) 2000');
Button(260,260,120,30,'Ok');
ButtonSelect(260,260,120,30);
ShowMouse
end;

procedure ButtonScroll;
begin
if ScrStrOX>47 then f:=ScrStrOX-46
               else f:=1;
SXX:=ScrollX;
SYY:=ScrollY;
SOXX:=ScrollOX;
SOYY:=ScrollOY;
Didit:=false;
if ButtonLR and (ScrStrX>1) then
  begin
    ScrStrX:=ScrStrX-1;
    ScrollX:=29+Round((350-ScrollOX)*ScrStrX/f);
    Didit:=true
  end
                            else
if not ButtonLR and (ScrStrX<f) then
  begin
    ScrStrX:=ScrStrX+1;
    ScrollX:=29+Round((350-ScrollOX)*ScrStrX/f);
    Didit:=true
  end;
if didit then
  begin
    HideMouse;
    SetFillStyle(1,15);
    Bar(SXX+1,SYY+1,SXX+SOXX-2,SYY+SOYY-2);
    SetFillStyle(1,15);
    Bar(20,380,395,390);
    SQROn:=true;
    OutVir;
    SQROn:=false;
    Button(ScrollX,ScrollY,ScrollOX,ScrollOY,'');
    if mvib=12 then CaseMain(mvib,0);
    ShowMouse;
    with ScrollData^[TekPart] do
      begin
        SX:=ScrollX;
        SY:=ScrollY;
        SOX:=ScrollOX;
        SOY:=ScrollOY;
        for f:=1 to ScrStrOX do SStr[f]:=ScrollStr[f];
        SStrOX:=ScrStrOX;
        SStrX:=ScrStrX
      end
  end
end;

procedure TextIn;
var s:string[71];
begin
HideMouse;
ClearZone(28,73,584,321,15);
Reset(gim);
if st<>1 then
  for ff:=1 to 40*(st-1) do readln(gim,h);
for ff:=1 to 40 do
  if not EOF(gim) then
    begin
      readln(gim,s);
      for l:=1 to Length(s) do OutTextXY(29+l*8,66+ff*8,CoderStr(s[l],-Key))
    end;
Close(gim);
ShowMouse
end;

procedure ProgramHelp;
begin
Assign(gim,HelpFile);
HideMouse;
if HelpFile='help.dat' then s:='Описание'
                       else s:='Помощь';
GraphWindow(20,40,600,400,s);
ColorPole:=15;
PushButton(25,70,590,326,'');
ColorPole:=7;
Button(43,401,164,30,'Назад');
Button(237,401,164,30,'Далее');
Button(429,401,164,30,'Выход');
ShowMouse;
st:=1;
TextIn;
Ok:=false;
Enter:=false;
vib:=2;
CaseHelp(vib,0);
repeat
GetMouseEvent(Ev);
MouseX:=CMouseX;
MouseY:=CMouseY;
if KeyPressed then
  begin
    h:=ReadKey;
    if h=#13 then Enter:=true;
    if h=#27 then
      begin
        Enter:=true;
        vib:=3
      end;
    if h=#0 then
      begin
        h:=ReadKey;
        if h=#77 then
          begin
            CaseHelp(vib,7);
            if vib=3 then vib:=1
                     else inc(vib);
            CaseHelp(vib,0)
          end;
        if h=#75 then
          begin
            CaseHelp(vib,7);
            if vib=1 then vib:=3
                     else dec(vib);
            CaseHelp(vib,0)
          end;
      end;
  end;
if ((Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton)) or Enter then
  begin
    if ((MouseX>429) and (MouseX<592) and (MouseY>401) and (MouseY<430)) or ((vib=3) and Enter) then
      begin
        HideMouse;
        PushButton(429,401,164,30,'Выход');
        ShowMouse;
        Delay(PushButtonDelay);
        HideMouse;
        Button(429,401,164,30,'Выход');
        ShowMouse;
        Delay(PushButtonDelay);
        Ok:=true
      end;
    if (((MouseX>237) and (MouseX<400) and (MouseY>401) and (MouseY<430)) or ((vib=2) and Enter))
        and (st<>stmax) then
      begin
        HideMouse;
        PushButton(237,401,164,30,'Далее');
        ShowMouse;
        Delay(PushButtonDelay);
        HideMouse;
        Button(237,401,164,30,'Далее');
        ShowMouse;
        Delay(PushButtonDelay);
        inc(st);
        TextIn;
        Enter:=false;
        CaseHelp(vib,0)
      end;
    if (((MouseX>43) and (MouseX<206) and (MouseY>401) and (MouseY<430)) or ((vib=1) and Enter))
        and (st<>1) then
      begin
        HideMouse;
        PushButton(43,401,164,30,'Назад');
        ShowMouse;
        Delay(PushButtonDelay);
        HideMouse;
        Button(43,401,164,30,'Назад');
        ShowMouse;
        Delay(PushButtonDelay);
        dec(st);
        TextIn;
        Enter:=false;
        CaseHelp(vib,0)
      end;
    Enter:=false
  end;
until Ok;
end;