procedure CaseSave(cs,Color:Byte);
begin
ColorText:=Color;
case cs of
  1:if Color=7 then
      begin
        ClearZone(214,244,72,8,15);
        SetCursor(214,244,TekFile,true);
        WinCur:=false
      end
               else
      begin
        WinCur:=true;
        SetCursor(214,244,TekFile,false)
      end;
  2:ButtonSelect(320,210,120,30);
  3:ButtonSelect(320,260,120,30)
end;
ColorText:=0
end;

procedure CaseOpen(co,Color:Byte);
begin
ColorText:=Color;
case co of
  1:if Color=0 then
      begin
        ColorText:=0;
        WriteSpisok
      end;
  2:ButtonSelect(320,210,120,30);
  3:ButtonSelect(320,260,120,30)
end;
ColorText:=0
end;

function OptionsNow:byte;
label Next,Next2;
begin
OptionsNow:=0;
HideMouse;
PushButton(10,207,125,30,'Опции');
ShowMouse;
Delay(PushButtonDelay);
HideMouse;
Button(10,207,125,30,'Опции');
Size:=ImageSize(220,90,420,390);
GetMem(PSpace,Size);
GetImage(220,90,420,390,PSpace^);
if not BOption then
  begin
    Button(220,90,200,300,'');
    Image.Import('writedsk.pfp',@Filter);
    Image.Draw(240,100,NormalPut);
    Image.Done;
    Image.Import('fileopen.pfp',@Filter);
    Image.Draw(240,150,NormalPut);
    Image.Done;
    Image.Import('graphic.pfp',@Filter);
    Image.Draw(240,200,NormalPut);
    Image.Done;
    Image.Import('mainmenu.pfp',@Filter);
    Image.Draw(240,250,NormalPut);
    Image.Done;
    Image.Import('exit.pfp',@Filter);
    Image.Draw(240,300,NormalPut);
    Image.Done;
    Image.Import('cancel.pfp',@Filter);
    Image.Draw(240,350,NormalPut);
    Image.Done;
    Button(285,100,120,30,'Сохранить');
    Button(285,150,120,30,'Открыть');
    Button(285,200,120,30,'График');
    Button(285,250,120,30,'Помощь');
    Button(285,300,120,30,'Выход');
    Button(285,350,120,30,'Отмена');
    Size:=ImageSize(221,91,418,388);
    GetMem(POptions,Size);
    GetImage(221,91,418,388,POptions^);
    BOption:=true
  end
               else PutImage(221,91,POptions^,0);

ShowMouse;
Enter:=false;
vib:=1;
CaseOptions(vib,0);
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
        vib:=6
      end;
    if h=#0 then
      begin
        h:=ReadKey;
        if h=#80 then
          begin
            CaseOptions(vib,7);
            if vib=6 then vib:=1
                     else inc(vib);
            CaseOptions(vib,0)
          end;
        if h=#72 then
          begin
            CaseOptions(vib,7);
            if vib=1 then vib:=6
                     else dec(vib);
            CaseOptions(vib,0)
          end
      end
  end;
until ((Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton)
      and (OptionsRect(MouseX,MouseY)>20) and (OptionsRect(MouseX,MouseY)<27))
      or Enter;
if (OptionsRect(MouseX,MouseY)=24) or ((vib=4) and Enter) then
  begin
    HideMouse;
    PushButton(285,250,120,30,'Помощь');
    ShowMouse;
    Delay(PushButtonDelay);
    HideMouse;
    Button(285,250,120,30,'Помощь');
    ShowMouse;
    Delay(PushButtonDelay*2);
    stmax:=1;
    HelpFile:='help2.dat';
    ProgramHelp;
    HelpFile:='help.dat';
    HideMouse;
    PutImage(0,0,pt1^,0);
    PutImage(320,0,pt2^,0);
    PutImage(0,239,pt3^,0);
    PutImage(320,239,pt4^,0);
    {PutImage(220,90,PSpace^,0);}
    ShowMouse;
    Size:=ImageSize(220,90,420,390);
    FreeMem(PSpace,Size);
    OptionsNow:=2;
    Exit
  end;
if (OptionsRect(MouseX,MouseY)=23) or ((vib=3) and Enter) then
  begin
    HideMouse;
    PushButton(285,200,120,30,'График');
    ShowMouse;
    Delay(PushButtonDelay);
    HideMouse;
    Button(285,200,120,30,'График');
    ShowMouse;
    Delay(2*PushButtonDelay);
    str(TekPart,s);
    m[1]:='неравенство(уравнение) '+s;
    m[2]:='система';
    m[3]:='настройка';
    SizeMenu:=30;
    ff:=Menus(170,190,300,100,m,3);
    if ff=0 then
      begin
        HideMouse;
        PutImage(220,90,PSpace^,0);
        Size:=ImageSize(220,90,420,390);
        FreeMem(PSpace,Size);
        ShowMouse;
        OptionsNow:=1;
        Exit
      end;
    if ((Part[TekPart,1].TotalVir=0) or (Part[TekPart,2].TotalVir=0)) and (ff=1) then
      begin
        str(TekPart,s);
        Message('Неравенство(уравнение) '+s+' не создано!');
        HideMouse;
        PutImage(220,90,PSpace^,0);
        Size:=ImageSize(220,90,420,390);
        FreeMem(PSpace,Size);
        ShowMouse;
        OptionsNow:=1;
        Exit
      end;
    if ff=2 then
      begin
        ft:=0;
        for l:=1 to 6 do
          if PartOnOff[l] then
            begin
              inc(ft);
              Spisok[ft]:=l;
              if (Part[l,1].TotalVir=0) or (Part[l,2].TotalVir=0) then
                begin
                  str(l,s);
                  Message('Неравенство(уравнение) '+s+' не создано!');
                  HideMouse;
                  PutImage(220,90,PSpace^,0);
                  Size:=ImageSize(220,90,420,390);
                  FreeMem(PSpace,Size);
                  ShowMouse;
                  OptionsNow:=1;
                  Exit
                end
            end
      end;
    if (ff=2) and (ft=0) then
      begin
        Message('Все неравенства отключены!');
        HideMouse;
        PutImage(220,90,PSpace^,0);
        Size:=ImageSize(220,90,420,390);
        FreeMem(PSpace,Size);
        ShowMouse;
        OptionsNow:=1;
        Exit
      end;
    if ff=3 then
      begin
        HideMouse;
        PutImage(220,90,PSpace^,0);
        Size:=ImageSize(220,90,420,390);
        FreeMem(PSpace,Size);
        ShowMouse;
        Setup;
        OptionsNow:=1;
        Exit
      end;
    if ff=1 then
      begin
        Spisok[1]:=TekPart;
        ft:=1
      end;
    Size:=ImageSize(220,90,420,390);
    FreeMem(PSpace,Size);
    HideMouse;
    ClearZone(0,0,640,480,0);
    ColorPole:=PixelBKColor;
    Button(0,0,640,480,'');
    ColorPole:=7;
    Button(210,225,220,30,'Идет построение графика!');
    for LY:=237 downto -236 do
      for FX:=-317 to 316 do
        begin
          for f:=1 to ft do PartOk[f]:=false;
          if not ((FX>=-110) and (FX<=108) and (LY>=-13) and (LY<=15)) then
            for l:=1 to ft do
              begin
                ff:=Spisok[l];
                Res1:=0;
                for f:=1 to Part[ff,1].TotalVir do
                  begin
                    if f=1 then
                      Res1:=Result(fx,ly,Part[ff,1].Vir[f])
                           else
                      case Part[ff,1].Znak[f-1] of
                        1:Res1:=Res1+Result(fx,ly,Part[ff,1].Vir[f]);
                        2:Res1:=Res1-Result(fx,ly,Part[ff,1].Vir[f]);
                        3:if Result(fx,ly,Part[ff,1].Vir[f])<>0 then
                            Res1:=Res1/Result(fx,ly,Part[ff,1].Vir[f]);
                        4:Res1:=Res1*Result(fx,ly,Part[ff,1].Vir[f])
                      end;
                    Err1:=PError;
                    if Err1 then
                      begin
                        f:=Part[ff,1].TotalVir;
                        PartOk[l]:=false;
                        goto Next
                      end
                  end;
                Res2:=0;
                for f:=1 to Part[ff,2].TotalVir do
                  begin
                    if f=1 then
                      Res2:=Result(fx,ly,Part[ff,2].Vir[f])
                           else
                      case Part[ff,2].Znak[f-1] of
                        1:Res2:=Res2+Result(fx,ly,Part[ff,2].Vir[f]);
                        2:Res2:=Res2-Result(fx,ly,Part[ff,2].Vir[f]);
                        3:if Result(fx,ly,Part[ff,2].Vir[f])<>0 then
                            Res2:=Res2/Result(fx,ly,Part[ff,2].Vir[f]);
                        4:Res2:=Res2*Result(fx,ly,Part[ff,2].Vir[f])
                      end;
                    Err2:=PError;
                    if Err2 then
                      begin
                        f:=Part[ff,2].TotalVir;
                        PartOk[l]:=false;
                        goto Next
                      end
                  end;
                res1:=round(res1);
                res2:=round(res2);
                PartOk[l]:=false;
                case VirIf[ff] of
                  1:if Res1=Res2 then PartOk[l]:=true;
                  2:if Res1<Res2 then PartOk[l]:=true;
                  3:if Res1>Res2 then PartOk[l]:=true;
                  4:if Res1<=Res2 then PartOk[l]:=true;
                  5:if Res1>=Res2 then PartOk[l]:=true;
                  6:if Res1<>Res2 then PartOk[l]:=true
                end
              end;
            for f:=1 to ft do
              if not PartOk[f] then
                begin
                  PartOk[1]:=false;
                  f:=ft
                end;
            if PartOk[1] then PutPixel(320+fx,240-ly,PixelColor);
Next:
        end;
    for LY:=15 downto -14 do
      for FX:=-110 to 110 do
        begin
          for l:=1 to ft do
            begin
              ff:=Spisok[l];
              Res1:=0;
              for f:=1 to Part[ff,1].TotalVir do
                begin
                  if f=1 then
                    Res1:=Result(fx,ly,Part[ff,1].Vir[f])
                         else
                    case Part[ff,1].Znak[f-1] of
                      1:Res1:=Res1+Result(fx,ly,Part[ff,1].Vir[f]);
                      2:Res1:=Res1-Result(fx,ly,Part[ff,1].Vir[f]);
                      3:if Result(fx,ly,Part[ff,1].Vir[f])<>0 then
                          Res1:=Res1/Result(fx,ly,Part[ff,1].Vir[f]);
                      4:Res1:=Res1*Result(fx,ly,Part[ff,1].Vir[f])
                    end;
                  Err1:=PError;
                  if Err1 then
                    begin
                      f:=Part[ff,1].TotalVir;
                      PartOk[l]:=false;
                      PutPixel(320+fx,240-ly,PixelBKColor);
                      goto Next2
                    end
                end;
              Res2:=0;
              for f:=1 to Part[ff,2].TotalVir do
                begin
                  if f=1 then
                    Res2:=Result(fx,ly,Part[ff,2].Vir[f])
                         else
                    case Part[ff,2].Znak[f-1] of
                      1:Res2:=Res2+Result(fx,ly,Part[ff,2].Vir[f]);
                      2:Res2:=Res2-Result(fx,ly,Part[ff,2].Vir[f]);
                      3:if Result(fx,ly,Part[ff,2].Vir[f])<>0 then
                          Res2:=Res2/Result(fx,ly,Part[ff,2].Vir[f]);
                      4:Res2:=Res2*Result(fx,ly,Part[ff,2].Vir[f])
                    end;
                  Err2:=PError;
                  if Err2 then
                    begin
                      f:=Part[ff,2].TotalVir;
                      PartOk[l]:=false;
                      PutPixel(320+fx,240-ly,PixelBKColor);
                      goto Next2
                    end
                end;
              res1:=round(res1);
              res2:=round(res2);
              PartOk[l]:=false;
              case VirIf[ff] of
                1:if Res1=Res2 then PartOk[l]:=true;
                2:if Res1<Res2 then PartOk[l]:=true;
                3:if Res1>Res2 then PartOk[l]:=true;
                4:if Res1<=Res2 then PartOk[l]:=true;
                5:if Res1>=Res2 then PartOk[l]:=true;
                6:if Res1<>Res2 then PartOk[l]:=true
              end
            end;
          for f:=1 to ft do
            if not PartOk[f] then
              begin
                PartOk[1]:=false;
                f:=ft
              end;
          if PartOk[1] then PutPixel(320+fx,240-ly,PixelColor)
                       else PutPixel(320+fx,240-ly,PixelBKColor);
Next2:
        end;
    Size:=ImageSize(305,3,330,476);
    GetMem(PDraw1,Size);
    GetImage(305,3,330,476,PDraw1^);
    Size:=ImageSize(3,225,639,250);
    GetMem(PDraw2,Size);
    GetImage(3,225,639,250,PDraw2^);
    Size:=ImageSize(519,454,639,479);
    GetMem(PDraw3,Size);
    GetImage(519,454,639,479,PDraw3^);
    ShowMouse;
    repeat
    HideMouse;
    PutImage(305,3,PDraw1^,0);
    PutImage(3,225,PDraw2^,0);
    PutImage(519,454,PDraw3^,0);
    if Coor then
      begin
        SetColor(LineColor);
        Line(3,240,636,240);
        Line(320,3,320,476);
        Line(636,240,626,237);
        Line(636,240,626,243);
        Line(320,4,317,13);
        Line(320,4,323,13);
        OutTextXY(628,227,'x');
        OutTextXY(307,7,'y');
      end;
    if Points then
      begin
        GetMouseEvent(Ev);
        MouseX:=CMouseX;
        MouseY:=CMouseY;
        str(MouseX-319,s);
        str(239-MouseY,ss);
        ColorPole:=PointsBKColor;
        ColorText:=PointsColor;
        Button(520,455,120,25,'X='+s+' Y='+ss);
        ColorPole:=7;
        ColorText:=0
      end;
    ShowMouse;
    repeat
    GetMouseEvent(Ev);
    MouseX:=CMouseX;
    MouseY:=CMouseY;
    if (Points) and (Ev.What=evMouseMove) then
      begin
        str(MouseX-319,s);
        str(239-MouseY,ss);
        HideMouse;
        ColorPole:=PointsBKColor;
        ColorText:=PointsColor;
        Button(520,455,120,25,'X='+s+' Y='+ss);
        ColorPole:=7;
        ColorText:=0;
        ShowMouse
      end;
    until ((Ev.What=evMouseDown) and (Ev.Buttons=mbRightButton)) or KeyPressed;
    if KeyPressed then
      begin
        h:=ReadKey;
        if h=#0 then h:=ReadKey
      end;
    MouseX:=CMouseX;
    MouseY:=CMouseY;
    m[1]:='оси';
    m[2]:='координаты';
    m[3]:='продолжить';
    m[4]:='выход';
    SizeMenu:=30;
    FX:=MouseX;
    LY:=MouseY;
    if MouseX>490 then FX:=MouseX-150;
    if MouseY>350 then LY:=MouseY-130;
    f:=Menus(FX,LY,150,130,m,4);
    if f=1 then
      if Coor then Coor:=false
              else Coor:=true;
    if f=2 then
      if Points then Points:=false
                else Points:=true;
    until f=4;
    Size:=ImageSize(305,3,330,476);
    FreeMem(PDraw1,Size);
    Size:=ImageSize(3,225,639,250);
    FreeMem(PDraw2,Size);
    Size:=ImageSize(519,454,639,479);
    FreeMem(PDraw3,Size);
    OptionsNow:=2;
    Exit
  end;
if (OptionsRect(MouseX,MouseY)=22) or ((vib=2) and Enter) then
  begin
    HideMouse;
    PushButton(285,150,120,30,'Открыть');
    ShowMouse;
    Delay(PushButtonDelay);
    HideMouse;
    Button(285,150,120,30,'Открыть');
    Delay(PushButtonDelay);
    PutImage(220,90,PSpace^,0);
    Size:=ImageSize(220,90,420,390);
    FreeMem(PSpace,Size);
    Size:=ImageSize(170,165,470,315);
    GetMem(PSpace,Size);
    GetImage(170,165,470,315,PSpace^);
    GraphWindow(170,165,300,150,'Открыть');
    ColorPole:=15;
    PushButton(185,191,78,115,'');
    ColorPole:=7;
    Button(320,210,120,30,'открыть');
    Button(320,260,120,30,'отмена');
    Button(270,194,20,20,'');
    Button(270,215,20,20,'');
    ShowMouse;
    ReadSpisok;
    Ok:=false;
    SpisokX:=1;
    SpisokV:=1;
    WriteSpisok;
    ButtonScrollOn:=false;
    vib:=1;
    Enter:=false;
    repeat
    GetMouseEvent(Ev);
    MouseX:=CMouseX;
    MouseY:=CMouseY;
    if KeyPressed then
      begin
        h:=ReadKey;
        if h=#13 then
          begin
            Enter:=true;
            if vib<>3 then vib:=2;
            CaseOpen(vib,0)
          end;
        if h=#27 then
          begin
            Enter:=true;
            vib:=3
          end;
        if h=#0 then
          begin
            h:=ReadKey;
            if h=#80 then
              begin
                CaseOpen(vib,7);
                if (vib=1) and (SpisokV<>TotalSpisok) then
                  begin
                    inc(SpisokV);
                    if SpisokV>TotalSpisok then SpisokV:=TotalSpisok;
                    if SpisokV>(SpisokX+11) then inc(SpisokX);
                    CaseOpen(vib,0)
                  end;
                if vib=2 then
                  begin
                    vib:=3;
                    Enter:=true
                  end;
                if (vib=3) and not Enter then vib:=2;
                if vib<>1 then CaseOpen(vib,0);
                Enter:=false
              end;
            if h=#72 then
              begin
                CaseOpen(vib,7);
                if (vib=1) and (SpisokV<>1) then
                  begin
                    dec(SpisokV);
                    if SpisokV<1 then SpisokV:=1;
                    if SpisokV<SpisokX then dec(SpisokX);
                    CaseOpen(vib,0)
                  end;
                if vib=2 then
                  begin
                    vib:=3;
                    Enter:=true
                  end;
                if (vib=3) and not Enter then vib:=2;
                if vib<>1 then CaseOpen(vib,0);
                Enter:=false
              end;
            if (h in [#75,#77]) and (vib=1) then
              begin
                CaseOpen(vib,7);
                vib:=2;
                CaseOpen(vib,0);
                h:=#0
              end;
            if (h in [#75,#77]) and (vib in [2,3]) then
              begin
                CaseOpen(vib,7);
                vib:=1;
                CaseOpen(vib,0);
                h:=#0
              end;
            if (h=#81) and (SpisokV<>TotalSpisok) then
              begin
                inc(SpisokV,11);
                if SpisokV>TotalSpisok then SpisokV:=TotalSpisok;
                SpisokX:=SpisokV-11;
                if TotalSpisok<=12 then SpisokX:=1;
                CaseOpen(vib,0);
                h:=#0
              end;
            if (h=#73) and (SpisokV<>1) then
              begin
                dec(SpisokV,11);
                if SpisokV<1 then SpisokV:=1;
                SpisokX:=SpisokV;
                CaseOpen(vib,0);
                h:=#0
              end
          end
      end;
    GetTime(ch,min,sek,sot);
    if sek=0 then sek:=60;
    Time:=Time+sek-FixTime;
    if sek<>60 then FixTime:=sek
               else FixTime:=0;
    if ButtonScrollOn and (Time>=ButtonScrollDelay) and not ButtonLR then
      if (SpisokX<>TotalSpisok-11) and (TotalSpisok>11) then
        begin
          inc(SpisokX);
          WriteSpisok
        end;
    if ButtonScrollOn and (Time>=ButtonScrollDelay) and ButtonLR then
      if SpisokX<>1 then
        begin
          dec(SpisokX);
          WriteSpisok
        end;
    if (Ev.What=evMouseUp) and ButtonScrollOn then
      begin
        ButtonScrollOn:=false;
        HideMouse;
        if ButtonLR then Button(270,194,20,20,'')
                    else Button(270,215,20,20,'');
        ShowMouse
      end;
    if ((Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton)) or Enter then
      begin
        if (LoadRect(MouseX,MouseY)=37) and not Enter then
          begin
            f:=(MouseY-192) div 9;
            if (MouseY-192) mod 9<>0 then inc(f);
            f:=SpisokX+f-1;
            if f<=TotalSpisok then SpisokV:=f;
            WriteSpisok
          end;
        if (LoadRect(MouseX,MouseY)=38) and not Enter then
          begin
            ButtonScrollOn:=true;
            ButtonLR:=true;
            HideMouse;
            PushButton(270,194,20,20,'');
            ShowMouse;
            if SpisokX<>1 then
              begin
                dec(SpisokX);
                WriteSpisok
              end;
            Time:=0;
            GetTime(ch,min,FixTime,sot)
          end;
        if (LoadRect(MouseX,MouseY)=39) and not Enter then
          begin
            ButtonScrollOn:=true;
            ButtonLR:=false;
            HideMouse;
            PushButton(270,215,20,20,'');
            ShowMouse;
            if (SpisokX<>TotalSpisok-11) and (TotalSpisok>11) then
              begin
                inc(SpisokX);
                WriteSpisok
              end;
            Time:=0;
            GetTime(ch,min,FixTime,sot)
          end;
        if (rect(MouseX,MouseY)=34) or ((vib=3) and Enter) then
          begin
            HideMouse;
            PushButton(320,260,120,30,'отмена');
            ShowMouse;
            Delay(PushButtonDelay);
            HideMouse;
            Button(320,260,120,30,'отмена');
            Delay(PushButtonDelay);
            ShowMouse;
            HideMouse;
            PutImage(170,165,PSpace^,0);
            Size:=ImageSize(170,165,470,315);
            FreeMem(PSpace,Size);
            ShowMouse;
            Ok:=true
          end;
        if ((rect(MouseX,MouseY)=35) or ((vib=2) and Enter)) and (TotalSpisok<>0) then
          begin
            HideMouse;
            PushButton(320,210,120,30,'открыть');
            ShowMouse;
            Delay(PushButtonDelay);
            HideMouse;
            Button(320,210,120,30,'открыть');
            ShowMouse;
            if not CheckFile(Files^[SpisokV]) then
              begin
                Message('Неправильный формат файла!');
                vib:=1;
                CaseOpen(vib,0)
              end
                                              else
              begin
                LoadFile(Files^[SpisokV],Ok);
                if Ok then
                  begin
                    TekFile:=Files^[SpisokV];
                    HideMouse;
                    PutImage(170,165,PSpace^,0);
                    Size:=ImageSize(170,165,470,315);
                    FreeMem(PSpace,Size);
                    ShowMouse
                  end
                      else
                  begin
                    vib:=1;
                    CaseOpen(vib,0)
                  end
              end
          end
      end
    until Ok;
    Enter:=false;
    WorkWindow
  end;
if (OptionsRect(MouseX,MouseY)=21) or ((vib=1) and Enter) then
  begin
    HideMouse;
    PushButton(285,100,120,30,'Сохранить');
    ShowMouse;
    Delay(PushButtonDelay);
    HideMouse;
    Button(285,100,120,30,'Сохранить');
    Delay(PushButtonDelay);
    PutImage(220,90,PSpace^,0);
    Size:=ImageSize(220,90,420,390);
    FreeMem(PSpace,Size);
    Size:=ImageSize(170,165,470,315);
    GetMem(PSpace,Size);
    GetImage(170,165,470,315,PSpace^);
    GraphWindow(170,165,300,150,'Сохранение');
    ColorShadow:=7;
    ColorLigth:=7;
    Button(210,228,78,10,'Имя файла');
    ColorShadow:=8;
    ColorLigth:=15;
    ColorPole:=15;
    PushButton(208,238,82,19,'');
    ColorPole:=7;
    Button(320,210,120,30,'сохранить');
    Button(320,260,120,30,'отмена');
    ShowMouse;
    Ok:=false;
    WinCur:=false;
    SetCursor(214,244,TekFile,true);
    s:=TekFile;
    vib:=2;
    CaseSave(vib,0);
    Enter:=false;
    repeat
    GetMouseEvent(Ev);
    MouseX:=CMouseX;
    MouseY:=CMouseY;
    if KeyPressed then
      begin
        h:=ReadKey;
        if h=#13 then
          begin
            ClearZone(214,244,72,8,15);
            SetCursor(214,244,TekFile,true);
            WinCur:=false;
            Enter:=true;
            if vib<>3 then vib:=2;
            CaseSave(vib,0)
          end;
        if h=#27 then
          begin
            Enter:=true;
            vib:=3
          end;
        if WinCur and (UpCase(h) in FileSymbols) then
          begin
            if (h<>#8) and (Length(TekFile)<8) then
              begin
                ClearZone(214,244,72,8,15);
                TekFile:=TekFile+UpCase(h);
                SetCursor(214,244,TekFile,false)
              end;
            if (h=#8) and (Length(TekFile)>0) then
              begin
                ClearZone(214,244,72,8,15);
                TekFile:=Copy(TekFile,1,Length(TekFile)-1);
                SetCursor(214,244,TekFile,false)
              end;
          end;
        if h=#0 then
          begin
            h:=ReadKey;
            if h=#80 then
              begin
                CaseSave(vib,7);
                if vib=3 then
                  vib:=2
                         else
                  if vib=2 then vib:=3
                           else vib:=3;
                CaseSave(vib,0)
              end;
            if h=#72 then
              begin
                CaseSave(vib,7);
                if vib=1 then
                  vib:=2
                         else
                  if vib=2 then vib:=3
                           else vib:=2;
                CaseSave(vib,0)
              end;
            if (h in [#75,#77]) and (vib=1) then
              begin
                CaseSave(vib,7);
                vib:=2;
                CaseSave(vib,0);
                h:=#0
              end;
            if (h in [#75,#77]) and (vib in [2,3]) then
              begin
                CaseSave(vib,7);
                vib:=1;
                CaseSave(vib,0)
              end
          end
      end;
    if ((Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton)) or Enter then
      begin
        if (rect(MouseX,MouseY)=33) and not Enter then
          begin
            WinCur:=true;
            SetCursor(214,244,TekFile,false);
            CaseSave(vib,7);
            vib:=1;
            CaseSave(vib,0)
          end;
        if (rect(MouseX,MouseY)=34) or ((vib=3) and Enter) then
          begin
            HideMouse;
            PushButton(320,260,120,30,'отмена');
            ShowMouse;
            Delay(PushButtonDelay);
            HideMouse;
            Button(320,260,120,30,'отмена');
            Delay(PushButtonDelay);
            ShowMouse;
            HideMouse;
            PutImage(170,165,PSpace^,0);
            Size:=ImageSize(170,165,470,315);
            FreeMem(PSpace,Size);
            ShowMouse;
            TekFile:=s;
            Enter:=false;
            Ok:=true
          end;
        if ((rect(MouseX,MouseY)=35) or ((vib=2) and Enter)) and (TekFile='') then
          begin
            Message('Нужно ввести имя файла!');
            MouseX:=639;
            MouseY:=0;
            Enter:=false;
            CaseSave(vib,7);
            vib:=1;
            CaseSave(vib,0)
          end;
        if (rect(MouseX,MouseY)=35) or ((vib=2) and Enter) then
          begin
            HideMouse;
            PushButton(320,210,120,30,'сохранить');
            ShowMouse;
            Delay(PushButtonDelay);
            HideMouse;
            Button(320,210,120,30,'сохранить');
            SaveFile(TekFile);
            ShowMouse;
            HideMouse;
            PutImage(170,165,PSpace^,0);
            Size:=ImageSize(170,165,470,315);
            FreeMem(PSpace,Size);
            ShowMouse;
            Ok:=true
          end;
      end;
    until Ok;
    Enter:=false
  end;
if (OptionsRect(MouseX,MouseY)=26) or ((vib=6) and Enter) then
  begin
    HideMouse;
    PushButton(285,350,120,30,'Отмена');
    ShowMouse;
    Delay(PushButtonDelay);
    HideMouse;
    Button(285,350,120,30,'Отмена');
    ShowMouse;
    Delay(2*PushButtonDelay);
    HideMouse;
    PutImage(220,90,PSpace^,0);
    Size:=ImageSize(220,90,420,390);
    FreeMem(PSpace,Size);
    ShowMouse
  end;
if (OptionsRect(MouseX,MouseY)=25) or ((vib=5) and Enter) then
  begin
    HideMouse;
    PushButton(285,300,120,30,'Выход');
    ShowMouse;
    Delay(PushButtonDelay);
    HideMouse;
    Button(285,300,120,30,'Выход');
    ShowMouse;
    Size:=ImageSize(220,90,420,390);
    FreeMem(PSpace,Size);
    Delay(2*PushButtonDelay);
    OptionsNow:=3;
    Exit
  end;
Enter:=false
end;