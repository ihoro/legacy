{$M 16384,0,400000}
uses Nothing,EGAVGA, Graph, EventMan, GrDriver, Crt, Images, Objects, Dos, Mouse;
{$I Co_Ty_Va.inc}
{$I ProcFunc.inc}
{$I BeginEnd.inc}
var
    MyCur:Pointer;
    mmx,mmy:integer;
begin
Program_Begin;
InitNothing;
SetNothing;
f:=1;
repeat
GetMouseEvent(Ev);
MouseX:=CMouseX;
MouseY:=CMouseY;
if (Ev.What=evMouseMove) and (f=0) then
  begin
HideMouse;
{SetColor(9);
Rectangle(MouseX,MouseY,MouseX+30,MouseY+30);}
PutImage(mmx,mmy,MyCur^,0);
ShowMouse;
FreeMem(MyCur,Size);
f:=1
  end;
if f=1 then
   begin
if MouseX+30>=639 then
  begin
    Size:=ImageSize(MouseX,MouseY,639,MouseY+30);
    GetMem(MyCur,Size);
    HideMouse;
    GetImage(MouseX,MouseY,639,MouseY+30,MyCur^);
  end
                  else
  begin
    Size:=ImageSize(MouseX,MouseY,MouseX+30,MouseY+30);
    GetMem(MyCur,Size);
    HideMouse;
    GetImage(MouseX,MouseY,MouseX+30,MouseY+30,MyCur^);
  end;
mmx:=mousex;mmy:=mousey;
SetColor(9);
Rectangle(MouseX,MouseY,MouseX+30,MouseY+30);
ShowMouse;
f:=0
  end;
if (Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton) then
begin
MouseX:=CMouseX;
MouseY:=CMouseY;
{ OIVButt }
if rect(MouseX,MouseY)=27 then
  begin
    HideMouse;
    Image.Import('oivbpush.pfp',@Filter);
    Image.Draw(559,8,NormalPut);
    ShowMouse;
    Delay(PushButtonDelay);
    HideMouse;
    Image.Import('oivbutt.pfp',@Filter);
    Image.Draw(559,8,NormalPut);
    ShowMouse;
    GraphWindow(170,140,300,200,'О программе');
  end;
{   Work  }
if (MouseX>=170) and (MouseX<=470) and (MouseY>=170) and (MouseY<=200) then
  begin
    HideMouse;
    PushButton(170,170,300,30,'Уравнения и неравенства');
    ShowMouse;
    Delay(PushButtonDelay);
    HideMouse;
    Button(170,170,300,30,'Уравнения и неравенства');
    ShowMouse;
    Delay(2*PushButtonDelay);
NewMain:
    HideMouse;
    Image.Import('title.pfp',@Filter);
    Image.Draw(0,0,NormalPut);
    Button(10,10,250,187,'');
    Button(10,207,100,30,'Опции');
{    Button(270,10,100,157,'');}
    WorkWindow;
    {Window(380,10,250,197,'Отдельное выражение');
    ColorPole:=15;
    PushButton(385,35,240,80,'');
    ColorPole:=7;
    ButtonDisable(405,125,200,30,'Добавить к главному');
    ButtonDisable(405,160,200,30,'Редактировать');}
    for l:=6 to 11 do Vibors(l,0);
    Vibor:=0;
    ShowMouse;
Main:
    repeat
    GetMouseEvent(Ev);
    MouseX:=CMouseX;
    MouseY:=CMouseY;
    if (Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton) then
      begin
        if rect(MouseX,MouseY)=28 then
          begin
            HideMouse;
            PushButton(475,337,100,30,'Знак');
            ShowMouse;
            Delay(PushButtonDelay);
            HideMouse;
            Button(475,337,100,30,'Знак');
            ShowMouse;
            Delay(2*PushButtonDelay);
            m[1]:='=';
            m[2]:='<';
            m[3]:='>';
            m[4]:='<=';
            m[5]:='>=';
            m[6]:='<>';
            SizeMenu:=20;
            f:=Menus(425,327,100,130,m,6);
            if f<>0 then
              begin
                VirIf[TekPart]:=f;
                WorkWindow
              end;
          end;
        if rect(MouseX,MouseY)=6 then
          begin{ квадратичная }
            m[1]:='ax¤';
            m[2]:='ay¤';
            m[3]:='ax¤+bx+c';
            m[4]:='ax¤+b';
            m[5]:='ay¤+b';
            m[6]:='ax¤+bx';
            m[7]:='ay¤+by';
            SizeMenu:=20;
            f:=Menus(100,40,100,150,m,7);
            if f=0 then goto Main;
            ParamVir(f,Virs)
          end;{ квадратичная }
        if rect(MouseX,MouseY)=7 then
          begin{ линейная }
            m[1]:='ax';
            m[2]:='ay';
            m[3]:='ax+by+c';
            m[4]:='ax+b';
            m[5]:='ay+b';
            SizeMenu:=20;
            f:=Menus(100,70,100,110,m,5);
            if f=0 then goto Main;
            f:=9+f;
            ParamVir(f,Virs)
          end;{ линейная }
        if rect(MouseX,MouseY)=8 then
          begin{ уравнение окружности }
            m[1]:='(x-a)¤+(y-b)¤-c¤';
            m[2]:='x¤+y¤-a¤';
            SizeMenu:=20;
            f:=Menus(70,100,160,50,m,2);
            if f=0 then goto Main;
            f:=14+f;
            ParamVir(f,Virs)
          end;{ уравнение окружности }
        if rect(MouseX,MouseY)=9 then
          begin{ тригонометрические функции }
            m[1]:='cos(ax)';
            m[2]:='cos(ay)';
            m[3]:='cos(Pi)';
            m[4]:='cos(Pi/2)';
            m[5]:='sin(ax)';
            m[6]:='sin(ay)';
            m[7]:='sin(Pi)';
            m[8]:='sin(Pi/2)';
            m[9]:='tg(ax)';
            m[10]:='tg(ay)';
            m[11]:='tg(Pi)';
            m[12]:='tg(Pi/2)';
            SizeMenu:=20;
            f:=Menus(100,130,100,250,m,12);
            if f=0 then goto Main;
            f:=16+f;
            ParamVir(f,Virs)
          end;{ тригонометрические функции }
        if rect(MouseX,MouseY)=10 then
          begin{ гипербола }
            m[1]:='a/x';
            m[2]:='a/y';
            SizeMenu:=20;
            f:=Menus(100,160,100,50,m,2);
            if f=0 then goto Main;
            f:=28+f;
            ParamVir(f,Virs)
          end;{ гипербола }
        if rect(MouseX,MouseY)=11 then
          begin{ константа }
            m[1]:='a';
            m[2]:='Pi';
            SizeMenu:=20;
            f:=Menus(100,190,100,50,m,2);
            if f=0 then goto Main;
            f:=7+f;
            ParamVir(f,Virs)
          end;{ константа }

        { Опции: }
        if rect(MouseX,MouseY)=20 then
          begin
            HideMouse;
            PushButton(10,207,100,30,'Опции');
            ShowMouse;
            Delay(PushButtonDelay);
            HideMouse;
            Button(10,207,100,30,'Опции');
            Size:=ImageSize(220,90,420,390);
            GetMem(PSpace,Size);
            GetImage(220,90,420,390,PSpace^);
            if not BOption then
              begin
                Button(220,90,200,300,'');
                Image.Import('writedsk.pfp',@Filter);
                Image.Draw(240,100,NormalPut);
                Image.Import('fileopen.pfp',@Filter);
                Image.Draw(240,150,NormalPut);
                Image.Import('graphic.pfp',@Filter);
                Image.Draw(240,200,NormalPut);
                Image.Import('mainmenu.pfp',@Filter);
                Image.Draw(240,250,NormalPut);
                Image.Import('exit.pfp',@Filter);
                Image.Draw(240,300,NormalPut);
                Image.Import('cancel.pfp',@Filter);
                Image.Draw(240,350,NormalPut);
                Button(285,100,120,30,'Сохранить');
                Button(285,150,120,30,'Открыть');
                Button(285,200,120,30,'График');
                Button(285,250,120,30,'Меню');
                Button(285,300,120,30,'Выход');
                Button(285,350,120,30,'Отмена');
                Size:=ImageSize(221,91,418,388);
                GetMem(POptions,Size);
                GetImage(221,91,418,388,POptions^);
                BOption:=true
              end
                          else PutImage(221,91,POptions^,0);

            ShowMouse;
            repeat
            GetMouseEvent(Ev);
            MouseX:=CMouseX;
            MouseY:=CMouseY;
            until (Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton)
                  and (rect(MouseX,MouseY)>20) and (rect(MouseX,MouseY)<27);
            if rect(MouseX,MouseY)=23 then
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
                    goto Main
                  end;
                if (ff=1) or (ff=2) then
                 if (Part[TekPart,1].TotalVir=0) or (Part[TekPart,2].TotalVir=0) then
                  begin
                    str(TekPart,s);
                    Message('Неравенство(уравнение) '+s+' не создано!');
                    HideMouse;
                    PutImage(220,90,PSpace^,0);
                    Size:=ImageSize(220,90,420,390);
                    FreeMem(PSpace,Size);
                    ShowMouse;
                    goto Main
                  end;
                if ff=3 then
                  begin
                    HideMouse;
                    PutImage(220,90,PSpace^,0);
                    Size:=ImageSize(220,90,420,390);
                    FreeMem(PSpace,Size);
                    ShowMouse;
                    Setup;
                    goto Main
                  end;
                if ff=1 then
                  begin
                    HideMouse;
                    ClearZone(0,0,640,480,0);
                    ColorPole:=PixelBKColor;
                    Button(0,0,640,480,'');
                    ColorPole:=7;
                    Button(210,225,220,30,'Идет построение графика!');
                    for LY:=237 downto -236 do
                      for FX:=-317 to 316 do
                        begin
                          if not ((320+FX>=210) and (320+FX<=428) and (240-LY>=225) and (240-LY<=253)) then
                          begin
                          {NumberVir:=0;}
                          Res1:=0;
                          for f:=1 to Part[TekPart,1].TotalVir do
                           begin
                            {NumberVir:=NumberVir+1;}
                            if f{NumberVir}=1 then
                              Res1:=Result(fx,ly,Part[TekPart,1].Vir[f{NumberVir}])
                                           else
                              case Part[TekPart,1].Znak[f{NumberVir}-1] of
                                1:Res1:=Res1+Result(fx,ly,Part[TekPart,1].Vir[f{NumberVir}]);
                                2:Res1:=Res1-Result(fx,ly,Part[TekPart,1].Vir[f{NumberVir}]);
                                3:Res1:=Res1/Result(fx,ly,Part[TekPart,1].Vir[f{NumberVir}]);
                                4:Res1:=Res1*Result(fx,ly,Part[TekPart,1].Vir[f{NumberVir}])
                              end;
                            Err1:=PError;
                            if Err1 then
                              begin
                                f:=Part[TekPart,1].TotalVir;
                                goto Next
                              end
                           end;
                          {until NumberVir=Part[TekPart,1].TotalVir;}
                          {NumberVir:=0;}
                          Res2:=0;
                          for f:=1 to Part[TekPart,2].TotalVir do
                           begin
                            {NumberVir:=NumberVir+1;}
                            if f{NumberVir}=1 then
                              Res2:=Result(fx,ly,Part[TekPart,2].Vir[f{NumberVir}])
                                           else
                              case Part[TekPart,2].Znak[f{NumberVir}-1] of
                                1:Res2:=Res2+Result(fx,ly,Part[TekPart,2].Vir[f{NumberVir}]);
                                2:Res2:=Res2-Result(fx,ly,Part[TekPart,2].Vir[f{NumberVir}]);
                                3:Res2:=Res2/Result(fx,ly,Part[TekPart,2].Vir[f{NumberVir}]);
                                4:Res2:=Res2*Result(fx,ly,Part[TekPart,2].Vir[f{NumberVir}])
                              end;
                            Err2:=PError;
                            if Err2 then
                              begin
                                f:=Part[TekPart,2].TotalVir;
                                goto Next
                              end;
                           end;
                          {until NumberVir=Part[TekPart,2].TotalVir;}
                          res1:=round(res1);
                          res2:=round(res2);
                          case VirIf[TekPart] of
                            1:if Res1=Res2 then PutPixel(Round(320+fx),Round(240-ly),PixelColor);
                            2:if Res1<Res2 then PutPixel(Round(320+fx),Round(240-ly),PixelColor);
                            3:if Res1>Res2 then PutPixel(Round(320+fx),Round(240-ly),PixelColor);
                            4:if Res1<=Res2 then PutPixel(Round(320+fx),Round(240-ly),PixelColor);
                            5:if Res1>=Res2 then PutPixel(Round(320+fx),Round(240-ly),PixelColor);
                            6:if Res1<>Res2 then PutPixel(Round(320+fx),Round(240-ly),PixelColor)
                          end
                          end;
Next:
                        end;
                    for LY:=15 downto -14 do
                      for FX:=-110 to 110 do
                        begin
                          NumberVir:=0;
                          Res1:=0;
                          repeat
                            NumberVir:=NumberVir+1;
                            if NumberVir=1 then
                              Res1:=Result(fx,ly,Part[TekPart,1].Vir[NumberVir])
                                           else
                              case Part[TekPart,1].Znak[NumberVir-1] of
                                1:Res1:=Res1+Result(fx,ly,Part[TekPart,1].Vir[NumberVir]);
                                2:Res1:=Res1-Result(fx,ly,Part[TekPart,1].Vir[NumberVir]);
                                3:Res1:=Res1/Result(fx,ly,Part[TekPart,1].Vir[NumberVir]);
                                4:Res1:=Res1*Result(fx,ly,Part[TekPart,1].Vir[NumberVir])
                              end;
                            Err1:=PError;
                            if Err1 then
                              begin
                                PutPixel(Round(320+fx),Round(240-ly),PixelBKColor);
                                goto Next2
                              end
                          until NumberVir=Part[TekPart,1].TotalVir;
                          NumberVir:=0;
                          Res2:=0;
                          repeat
                            NumberVir:=NumberVir+1;
                            if NumberVir=1 then
                              Res2:=Result(fx,ly,Part[TekPart,2].Vir[NumberVir])
                                           else
                              case Part[TekPart,2].Znak[NumberVir-1] of
                                1:Res2:=Res2+Result(fx,ly,Part[TekPart,2].Vir[NumberVir]);
                                2:Res2:=Res2-Result(fx,ly,Part[TekPart,2].Vir[NumberVir]);
                                3:Res2:=Res2/Result(fx,ly,Part[TekPart,2].Vir[NumberVir]);
                                4:Res2:=Res2*Result(fx,ly,Part[TekPart,2].Vir[NumberVir])
                              end;
                            Err2:=PError;
                            if Err2 then
                              begin
                                PutPixel(Round(320+fx),Round(240-ly),PixelBKColor);
                                goto Next2
                              end
                          until NumberVir=Part[TekPart,2].TotalVir;
                          res1:=round(res1);
                          res2:=round(res2);
                          case VirIf[TekPart] of
                            1:if Res1=Res2 then PutPixel(Round(320+fx),Round(240-ly),PixelColor)
                                           else PutPixel(Round(320+fx),Round(240-ly),PixelBKColor);
                            2:if Res1<Res2 then PutPixel(Round(320+fx),Round(240-ly),PixelColor)
                                           else PutPixel(Round(320+fx),Round(240-ly),PixelBKColor);
                            3:if Res1>Res2 then PutPixel(Round(320+fx),Round(240-ly),PixelColor)
                                           else PutPixel(Round(320+fx),Round(240-ly),PixelBKColor);
                            4:if Res1<=Res2 then PutPixel(Round(320+fx),Round(240-ly),PixelColor)
                                            else PutPixel(Round(320+fx),Round(240-ly),PixelBKColor);
                            5:if Res1>=Res2 then PutPixel(Round(320+fx),Round(240-ly),PixelColor)
                                            else PutPixel(Round(320+fx),Round(240-ly),PixelBKColor);
                            6:if Res1<>Res2 then PutPixel(Round(320+fx),Round(240-ly),PixelColor)
                                            else PutPixel(Round(320+fx),Round(240-ly),PixelBKColor)
                          end;
Next2:
                        end;
                    {for LY:=15 downto -14 do
                      for FX:=-110 to 110 do
                        begin
                          Result(fx,ly,Part[TekPart,1].Vir[Part[TekPart,1].TotalVir]);
                          Err1:=PError;
                          Result(fx,ly,Part[TekPart,2].Vir[Part[TekPart,2].TotalVir]);
                          Err2:=PError;
                          if Err1 or Err2 then PutPixel(Round(320+fx),Round(240-ly),PixelBKColor);
                          if not (Err1 and Err2) then
                          case VirIf[TekPart] of
                          1:if Result(fx,ly,Part[TekPart,1].Vir[Part[TekPart,1].TotalVir])
                               =Result(fx,ly,Part[TekPart,2].Vir[Part[TekPart,2].TotalVir])
                                 then PutPixel(Round(320+fx),Round(240-ly),PixelColor)
                                 else PutPixel(Round(320+fx),Round(240-ly),PixelBKColor);
                          2:if Result(fx,ly,Part[TekPart,1].Vir[Part[TekPart,1].TotalVir])
                               <Result(fx,ly,Part[TekPart,2].Vir[Part[TekPart,2].TotalVir])
                                 then PutPixel(Round(320+fx),Round(240-ly),PixelColor)
                                 else PutPixel(Round(320+fx),Round(240-ly),PixelBKColor);
                          3:if Result(fx,ly,Part[TekPart,1].Vir[Part[TekPart,1].TotalVir])
                               >Result(fx,ly,Part[TekPart,2].Vir[Part[TekPart,2].TotalVir])
                                 then PutPixel(Round(320+fx),Round(240-ly),PixelColor)
                                 else PutPixel(Round(320+fx),Round(240-ly),PixelBKColor);
                          4:if Result(fx,ly,Part[TekPart,1].Vir[Part[TekPart,1].TotalVir])
                               <=Result(fx,ly,Part[TekPart,2].Vir[Part[TekPart,2].TotalVir])
                                 then PutPixel(Round(320+fx),Round(240-ly),PixelColor)
                                 else PutPixel(Round(320+fx),Round(240-ly),PixelBKColor);
                          5:if Result(fx,ly,Part[TekPart,1].Vir[Part[TekPart,1].TotalVir])
                               >=Result(fx,ly,Part[TekPart,2].Vir[Part[TekPart,2].TotalVir])
                                 then PutPixel(Round(320+fx),Round(240-ly),PixelColor)
                                 else PutPixel(Round(320+fx),Round(240-ly),PixelBKColor);
                          6:if Result(fx,ly,Part[TekPart,1].Vir[Part[TekPart,1].TotalVir])
                               <>Result(fx,ly,Part[TekPart,2].Vir[Part[TekPart,2].TotalVir])
                                 then PutPixel(Round(320+fx),Round(240-ly),PixelColor)
                                 else PutPixel(Round(320+fx),Round(240-ly),PixelBKColor)
                          end
                        end;}
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
                    if (Points) and (Ev.What=evMouseMove) then
                      begin
                        MouseX:=CMouseX;
                        MouseY:=CMouseY;
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
                    until (Ev.What=evMouseDown) and (Ev.Buttons=mbRightButton);
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
                    goto NewMain
                  end;
              end;
            if rect(MouseX,MouseY)=26 then
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
            if rect(MouseX,MouseY)=25 then
              begin
                HideMouse;
                PushButton(285,300,120,30,'Выход');
                ShowMouse;
                Delay(PushButtonDelay);
                HideMouse;
                Button(285,300,120,30,'Выход');
                ShowMouse;
                Delay(2*PushButtonDelay);
                goto Finish
              end;
          end;{ Опции rect=20}
        if rect(MouseX,MouseY)=PartSystem then
          begin
            HideMouse;
            str(TekPart,s);
            PushButton(10,247,220,30,'неравенство(уравнение) '+s);
            ShowMouse;
            Delay(PushButtonDelay);
            HideMouse;
            TekPart:=TekPart+1;
            if TekPart=7 then TekPart:=1;
            str(TekPart,s);
            Button(10,247,220,30,'неравенство(уравнение) '+s);
            ShowMouse;
            Delay(2*PushButtonDelay);
            WorkWindow
          end;
        if rect(MouseX,MouseY)=LR then
          begin
            HideMouse;
            PushButton(10,287,220,30,LeftRigthText[LeftRigth]);
            ShowMouse;
            Delay(PushButtonDelay);
            HideMouse;
            LeftRigth:=LeftRigth+1;
            if LeftRigth=3 then LeftRigth:=1;
            Button(10,287,220,30,LeftRigthText[LeftRigth]);
            ShowMouse;
            Delay(2*PushButtonDelay);
            WorkWindow
          end;
      end;{MouseDown(LeftButton)}
    for l:=6 to 11 do
     if (rect(MouseX,MouseY)=l) and (vibor<>l) then
      begin
        Vibors(Vibor,0);
        Vibor:=l;
        Vibors(Vibor,1)
      end;

    until (Ev.What=evMouseDown) and (Ev.Buttons=mbRightButton);
  end;
{   Exit  }
if (MouseX>=170) and (MouseX<=470) and (MouseY>=290) and (MouseY<=320) then
  begin
    HideMouse;
    PushButton(170,290,300,30,'Выход');
    ShowMouse;
    Delay(1900);
    HideMouse;
    Button(170,290,300,30,'Выход');
    ShowMouse;
    Delay(1000);
    halts:=true
  end;
{   End   }
end;
until halts;
Finish:
Program_End
end.