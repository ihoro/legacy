{$M 16384,0,400000}
uses EGAVGA, Graph, Coder, EventMan, GrDriver, Crt, GrProcs, Images, Objects, Dos{, DosCom};
{$I Co_Ty_Va.inc}
{$I ProcFunc.inc}
{$I ProcFun2.inc}
{$I Options.inc}
{$I BeginEnd.inc}
begin
Program_Begin;
Start:
vib:=1;
Enter:=false;
CaseBegin(vib,0);
MyB:=false;
repeat
GetMouseEvent(Ev);
MouseX:=CMouseX;
MouseY:=CMouseY;
if (Ev.What=evMouseMove) and (rect(MouseX,MouseY)=27) and not MyB then
  begin
    MyB:=true;
    HideMouse;
    if not BOIVButtonSelect then
      begin
        Image.Import('oivbutts.pfp',@Filter);
        Image.Draw(559,8,NormalPut);
        Size:=ImageSize(559,8,623,53);
        GetMem(POIVButtonSelect,Size);
        GetImage(559,8,623,53,POIVButtonSelect^);
        Image.Done;
        BOIVButtonSelect:=true
      end
                            else
      PutImage(559,8,POIVButtonSelect^,0);
    ShowMouse
  end;
if (Ev.What=evMouseMove) and MyB and not (rect(MouseX,MouseY)=27) then
  begin
    MyB:=false;
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
    ShowMouse
  end;
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
        if h=#80 then
          begin
            CaseBegin(vib,ColorPole);
            if vib=3 then vib:=1
                     else inc(vib);
            CaseBegin(vib,0)
          end;
        if h=#72 then
          begin
            CaseBegin(vib,ColorPole);
            if vib=1 then vib:=3
                     else dec(vib);
            CaseBegin(vib,0)
          end
      end
  end;
if ((Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton)) or Enter then
begin
MouseX:=CMouseX;
MouseY:=CMouseY;
{ OIVButt }
if rect(MouseX,MouseY)=27 then
  begin
    IfMy;
    Enter:=false;
    repeat
    GetMouseEvent(Ev);
    MouseX:=CMouseX;
    MouseY:=CMouseY;
    if KeyPressed then
      begin
        h:=ReadKey;
        if h in [#13,#27] then Enter:=true;
        if h=#0 then h:=ReadKey
      end;
    Ok:=false;
    if (MouseX>260) and (MouseX<379) and (MouseY>260) and (MouseY<289) then Ok:=true
    until ((Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton) and Ok) or Enter;
    HideMouse;
    PushButton(260,260,120,30,'Ok');
    ShowMouse;
    Delay(PushButtonDelay);
    HideMouse;
    Button(260,260,120,30,'Ok');
    ShowMouse;
    Delay(PushButtonDelay);
    HideMouse;
    PutImage(170,110,PSpace^,0);
    Size:=ImageSize(170,110,470,320);
    FreeMem(PSpace,Size);
    ShowMouse;
    goto Start
  end;
if ((MouseX>=170) and (MouseX<=470) and (MouseY>=230) and (MouseY<=259)) or ((vib=2) and Enter) then
  begin
    HideMouse;
    PushButton(170,230,300,30,'Описание');
    ShowMouse;
    Delay(PushButtonDelay);
    HideMouse;
    Button(170,230,300,30,'Описание');
    ShowMouse;
    stmax:=2;
    ProgramHelp;
    HideMouse;
    PutImage(0,0,pt1^,0);
    PutImage(320,0,pt2^,0);
    PutImage(0,239,pt3^,0);
    PutImage(320,239,pt4^,0);
    BeginButtons;
    ShowMouse;
    goto Start
  end;
{   Work  }
if ((MouseX>=170) and (MouseX<=470) and (MouseY>=170) and (MouseY<=200)) or ((vib=1) and Enter) then
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
    PutImage(0,0,pt1^,0);
    PutImage(320,0,pt2^,0);
    PutImage(0,239,pt3^,0);
    PutImage(320,239,pt4^,0);
    Button(10,10,250,187,'');
    Button(10,207,125,30,'Опции');
    Button(135,207,125,30,'Правка');
    ShowMouse;
    WorkWindow;
    for l:=7 to 11 do Vibors(l,0);
    Vibor:=6;
    mvib:=1;
Main:
    ScrollOn:=false;
    ButtonScrollOn:=false;
    Enter:=false;
    CaseMain(mvib,0);
    MyB:=false;
    repeat
    GetMouseEvent(Ev);
    MouseX:=CMouseX;
    MouseY:=CMouseY;
    if (Ev.What=evMouseMove) and (rect(MouseX,MouseY)=27) and not MyB then
      begin
        MyB:=true;
        HideMouse;
        if not BOIVButtonSelect then
          begin
            Image.Import('oivbutts.pfp',@Filter);
            Image.Draw(559,8,NormalPut);
            Size:=ImageSize(559,8,623,53);
            GetMem(POIVButtonSelect,Size);
            GetImage(559,8,623,53,POIVButtonSelect^);
            Image.Done;
            BOIVButtonSelect:=true
          end
                                else
        PutImage(559,8,POIVButtonSelect^,0);
        ShowMouse
      end;
    if (Ev.What=evMouseMove) and MyB and not (rect(MouseX,MouseY)=27) then
      begin
        MyB:=false;
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
        ShowMouse
      end;
    if KeyPressed then
      begin
        h:=ReadKey;
        if h=#13 then Enter:=true;
        if (h=' ') and (mvib=10) then Enter:=true;
        if h=#27 then
          begin
            HideMouse;
            PutImage(0,0,pt1^,0);
            PutImage(320,0,pt2^,0);
            PutImage(0,239,pt3^,0);
            PutImage(320,239,pt4^,0);
            Button(170,170,300,30,'Уравнения и неравенства');
            Button(170,230,300,30,'Описание');
            Button(170,290,300,30,'Выход');
            ShowMouse;
            goto Start
          end;
        if h=#0 then
          begin
            h:=ReadKey;
            if (h=#80) and (mvib in [7,9,12]) then
              begin
                h:=#0;
                CaseMain(mvib,7);
                inc(mvib,2);
                if mvib=14 then mvib:=1;
                if mvib in [1,2,3,4,5,6] then
                  begin
                    Vibors(Vibor,0);
                    Vibor:=mvib+5
                  end;
                CaseMain(mvib,0)
              end;
            if (h=#72) and (mvib in [8,10,13]) then
              begin
                h:=#0;
                CaseMain(mvib,7);
                dec(mvib,2);
                if mvib in [1,2,3,4,5,6] then
                  begin
                    Vibors(Vibor,0);
                    Vibor:=mvib+5
                  end;
                CaseMain(mvib,0)
              end;
            if h=#80 then
              begin
                h:=#0;
                CaseMain(mvib,7);
                if mvib in [1,2,3,4,5,6] then
                    mvib:=7
                                         else
                  begin
                    inc(mvib);
                    if mvib=14 then mvib:=1
                  end;
                if mvib in [1,2,3,4,5,6] then
                  begin
                    Vibors(Vibor,0);
                    Vibor:=mvib+5
                  end;
                CaseMain(mvib,0)
              end;
            if h=#72 then
              begin
                h:=#0;
                CaseMain(mvib,7);
                if mvib in [1,2,3,4,5,6] then
                    mvib:=13
                                         else
                  begin
                    dec(mvib);
                    if mvib=0 then mvib:=13
                  end;
                if mvib in [1,2,3,4,5,6] then
                  begin
                    Vibors(Vibor,0);
                    Vibor:=mvib+5
                  end;
                CaseMain(mvib,0)
              end;
            if (h in [#77,#75]) and (mvib in [7,8]) then
              begin
                CaseMain(mvib,7);
                if mvib=7 then mvib:=8
                          else mvib:=7;
                CaseMain(mvib,0)
              end;
            if (h in [#77,#75]) and (mvib in [9,10]) then
              begin
                h:=#0;
                CaseMain(mvib,7);
                if mvib=9 then mvib:=10
                          else mvib:=9;
                CaseMain(mvib,0)
              end;
            if (h=#77) and (mvib=11) then
              begin
                h:=#0;
                CaseMain(mvib,7);
                mvib:=13;
                CaseMain(mvib,0)
              end;
            if (h in [#77,#75]) and (mvib=13) then
              begin
                h:=#0;
                CaseMain(mvib,7);
                mvib:=12;
                CaseMain(mvib,0)
              end;
            if (h in [#73,#81]) and (mvib in [1,2,3,4,5,6]) then
              begin
                CaseMain(mvib,7);
                if h=#73 then
                  begin
                    dec(mvib);
                    if mvib=0 then mvib:=6
                  end
                         else
                  begin
                    inc(mvib);
                    if mvib=7 then mvib:=1
                  end;
                h:=#0;
                Vibors(Vibor,0);
                Vibor:=mvib+5;
                CaseMain(mvib,0)
              end;
            if (h in [#73,#81]) and (mvib=9) then
              begin
                HideMouse;
                str(TekPart,s);
                PushButton(10,247,220,30,'неравенство(уравнение) '+s);
                ShowMouse;
                Delay(PushButtonDelay);
                HideMouse;
                if h=#73 then
                  begin
                    inc(TekPart);
                    if TekPart=7 then TekPart:=1
                  end;
                if h=#81 then
                  begin
                    dec(TekPart);
                    if TekPart=0 then TekPart:=6
                  end;
                h:=#0;
                str(TekPart,s);
                Button(10,247,220,30,'неравенство(уравнение) '+s);
                ShowMouse;
                WorkWindow;
                CaseMain(mvib,0)
              end;
            if (h in [#71,#79]) and (mvib=12) and (ScrStrOX>47) then
              begin
                if (h=#71) and (ScrStrX<>1) then
                  begin
                    if ScrStrOX>47 then f:=ScrStrOX-46
                                   else f:=1;
                    SXX:=ScrollX;
                    SYY:=ScrollY;
                    SOXX:=ScrollOX;
                    SOYY:=ScrollOY;
                    ScrStrX:=1;
                    ScrollX:=29+Round((350-ScrollOX)*ScrStrX/f);
                    HideMouse;
                    SetFillStyle(1,15);
                    Bar(SXX+1,SYY+1,SXX+SOXX-2,SYY+SOYY-2);
                    SetFillStyle(1,15);
                    Bar(20,380,395,390);
                    SQROn:=true;
                    OutVir;
                    SQROn:=false;
                    Button(ScrollX,ScrollY,ScrollOX,ScrollOY,'');
                    CaseMain(mvib,0);
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
                  end;
                if (h=#79) and (ScrStrX<>ScrStrOX-46) then
                  begin
                    if ScrStrOX>47 then f:=ScrStrOX-46
                                   else f:=1;
                    SXX:=ScrollX;
                    SYY:=ScrollY;
                    SOXX:=ScrollOX;
                    SOYY:=ScrollOY;
                    ScrStrX:=ScrStrOX-46;
                    ScrollX:=29+Round((350-ScrollOX)*ScrStrX/f);
                    HideMouse;
                    SetFillStyle(1,15);
                    Bar(SXX+1,SYY+1,SXX+SOXX-2,SYY+SOYY-2);
                    SetFillStyle(1,15);
                    Bar(20,380,395,390);
                    SQROn:=true;
                    OutVir;
                    SQROn:=false;
                    Button(ScrollX,ScrollY,ScrollOX,ScrollOY,'');
                    CaseMain(mvib,0);
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
            if (h in [#77,#75]) and (mvib=12) then
              begin
                if ScrStrOX>47 then f:=ScrStrOX-46
                               else f:=1;
                SXX:=ScrollX;
                SYY:=ScrollY;
                SOXX:=ScrollOX;
                SOYY:=ScrollOY;
                if (h=#77) and (ScrStrX<>ScrStrOX-46) and (ScrStrOX>47) then
                  begin
                    ScrStrX:=ScrStrX+1;
                    ScrollX:=29+Round((350-ScrollOX)*ScrStrX/f);
                    HideMouse;
                    SetFillStyle(1,15);
                    Bar(SXX+1,SYY+1,SXX+SOXX-2,SYY+SOYY-2);
                    SetFillStyle(1,15);
                    Bar(20,380,395,390);
                    SQROn:=true;
                    OutVir;
                    SQROn:=false;
                    Button(ScrollX,ScrollY,ScrollOX,ScrollOY,'');
                    CaseMain(mvib,0);
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
                  end;
                if (h=#75) and (ScrStrX<>1) and (ScrStrOX>47) then
                  begin
                    ScrStrX:=ScrStrX-1;
                    ScrollX:=29+Round((350-ScrollOX)*ScrStrX/f);
                    HideMouse;
                    SetFillStyle(1,15);
                    Bar(SXX+1,SYY+1,SXX+SOXX-2,SYY+SOYY-2);
                    SetFillStyle(1,15);
                    Bar(20,380,395,390);
                    SQROn:=true;
                    OutVir;
                    SQROn:=false;
                    Button(ScrollX,ScrollY,ScrollOX,ScrollOY,'');
                    CaseMain(mvib,0);
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
              end
          end
      end;
    {Memory;}
    GetTime(ch,min,sek,sot);
    if sek=0 then sek:=60;
    Time:=Time+sek-FixTime;
    if sek<>60 then FixTime:=sek
               else FixTime:=0;
    if ButtonScrollOn and (Time>ButtonScrollDelay) then ButtonScroll;
    if (Ev.What=evMouseMove) and ScrollOn then
      begin
        MouseX:=CMouseX;
        MouseY:=CMouseY;
        SXX:=ScrollX;
        SYY:=ScrollY;
        SOXX:=ScrollOX;
        SOYY:=ScrollOY;
        ScrollX:=ScrollX+MouseX-ScrSX;
        ScrSX:=MouseX;
        ScrSY:=MouseY;
        if ScrollX<30 then ScrollX:=30;
        if ScrollX+ScrollOX>=380 then ScrollX:=380-ScrollOX;
        if ScrStrOX>47 then ScrStrX:=Round(((ScrollX-29)*(ScrStrOX-46))/(351-ScrollOX))
                       else ScrStrX:=1;
        if ScrStrX=0 then ScrStrX:=1;
        if ScrollX<>FixScrX then
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
            FixScrX:=ScrollX;
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
    if (Ev.What=evMouseUp) and ScrollOn then ScrollOn:=false;
    if (Ev.What=evMouseUp) and ButtonScrollOn then
      begin
        ButtonScrollOn:=false;
        HideMouse;
        if ButtonLR then Button(12,420,20,20,#17)
                    else Button(378,420,20,20,#16);
        ShowMouse
      end;
    if (Ev.What=evMouseDown) and (Ev.Buttons=mbRightButton)
        and (rect(MouseX,MouseY)=PartSystem) then
      begin
        HideMouse;
        str(TekPart,s);
        PushButton(10,247,220,30,'неравенство(уравнение) '+s);
        ShowMouse;
        Delay(PushButtonDelay);
        HideMouse;
        dec(TekPart);
        if TekPart=0 then TekPart:=6;
        str(TekPart,s);
        Button(10,247,220,30,'неравенство(уравнение) '+s);
        ShowMouse;
        WorkWindow;
        Enter:=false;
        CaseMain(mvib,7);
        mvib:=9;
        CaseMain(mvib,0)
      end;
    if ((Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton)) or Enter then
      begin
        if rect(MouseX,MouseY)=27 then
          begin
            IfMy;
            Enter:=false;
            repeat
            GetMouseEvent(Ev);
            MouseX:=CMouseX;
            MouseY:=CMouseY;
            if KeyPressed then
              begin
                h:=ReadKey;
                if h in [#13,#27] then Enter:=true;
                if h=#0 then h:=ReadKey
              end;
            Ok:=false;
            if (MouseX>260) and (MouseX<379) and (MouseY>260) and (MouseY<289) then Ok:=true
            until ((Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton) and Ok) or Enter;
            HideMouse;
            PushButton(260,260,120,30,'Ok');
            ShowMouse;
            Delay(PushButtonDelay);
            HideMouse;
            Button(260,260,120,30,'Ok');
            ShowMouse;
            Delay(PushButtonDelay);
            HideMouse;
            PutImage(170,110,PSpace^,0);
            Size:=ImageSize(170,110,470,340);
            FreeMem(PSpace,Size);
            ShowMouse;
            Enter:=false;
            MouseX:=639;
            MouseY:=0
          end;
        if (rect(MouseX,MouseY)=32) or ((mvib=10) and Enter) then
          begin
            if PartOnOff[TekPart] then PushButtonOn
                                  else PushButtonOff;
            if PartOnOff[TekPart] then PartOnOff[TekPart]:=false
                                  else PartOnOff[TekPart]:=true;
            if PartOnOff[TekPart] then ButtonOn
                                  else ButtonOff;
            Enter:=false;
            CaseMain(mvib,7);
            mvib:=10;
            CaseMain(mvib,0)
          end;
        if (rect(MouseX,MouseY)=30) and (ScrStrOX>47) then
          begin
            ButtonLR:=true;
            ButtonScrollOn:=true;
            Time:=0;
            GetTime(ch,min,FixTime,sot);
            ButtonScroll;
            HideMouse;
            PushButton(12,420,20,20,#17);
            ShowMouse;
            CaseMain(mvib,7);
            mvib:=12;
            CaseMain(mvib,0)
          end;
        if (rect(MouseX,MouseY)=31) and (ScrStrOX>47) then
          begin
            ButtonLR:=false;
            ButtonScrollOn:=true;
            Time:=0;
            GetTime(ch,min,FixTime,sot);
            ButtonScroll;
            HideMouse;
            PushButton(378,420,20,20,#16);
            ShowMouse;
            CaseMain(mvib,7);
            mvib:=12;
            CaseMain(mvib,0)
          end;
        if (rect(MouseX,MouseY)=29) and not ScrollOn and (ScrollOX<>350) then
          begin
            ScrollOn:=true;
            ScrSX:=MouseX;
            ScrSY:=MouseY;
            CaseMain(mvib,7);
            mvib:=12;
            CaseMain(mvib,0)
          end;
        if (rect(MouseX,MouseY)=28) or ((mvib=13) and Enter) then
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
            m[5]:='=>';
            m[6]:='<>';
            SizeMenu:=20;
            f:=Menus(425,327,100,130,m,6);
            if f<>0 then
              begin
                VirIf[TekPart]:=f;
                WorkWindow
              end;
            Enter:=false;
            CaseMain(mvib,7);
            mvib:=13;
            CaseMain(mvib,0)
          end;
        if (rect(MouseX,MouseY)=6) or ((mvib=1) and Enter) then
          begin{ квадратичная }
            SQROn:=true;
            m[1]:='ax ';
            m[2]:='ay ';
            m[3]:='ax +bx+c';
            m[4]:='ax +b';
            m[5]:='ay +b';
            m[6]:='ax +bx';
            m[7]:='ay +by';
            SizeMenu:=20;
            f:=Menus(100,40,100,150,m,7);
            SQROn:=false;
            if f=0 then goto Main;
            ParamVir(f,Virs)
          end;{ квадратичная }
        if (rect(MouseX,MouseY)=7) or ((mvib=2) and Enter) then
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
        if (rect(MouseX,MouseY)=8) or ((mvib=3) and Enter) then
          begin{ уравнение окружности }
            SQROn:=true;
            m[1]:='(x-a) +(y-b) -c ';
            m[2]:='x +y -a ';
            SizeMenu:=20;
            f:=Menus(70,100,160,50,m,2);
            SQROn:=false;
            if f=0 then goto Main;
            f:=14+f;
            ParamVir(f,Virs)
          end;{ уравнение окружности }
        if (rect(MouseX,MouseY)=9) or ((mvib=4) and Enter) then
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
        if (rect(MouseX,MouseY)=10) or ((mvib=5) and Enter) then
          begin{ гипербола }
            m[1]:='a/x';
            m[2]:='a/y';
            SizeMenu:=20;
            f:=Menus(100,160,100,50,m,2);
            if f=0 then goto Main;
            f:=28+f;
            ParamVir(f,Virs)
          end;{ гипербола }
        if (rect(MouseX,MouseY)=11) or ((mvib=6) and Enter) then
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
        if (rect(MouseX,MouseY)=20) or ((mvib=7) and Enter) then
          begin
            f:=OptionsNow;
            case f of
              1:goto Main;
              2:goto NewMain;
              3:begin
                  HideMouse;
                  PutImage(0,0,pt1^,0);
                  PutImage(320,0,pt2^,0);
                  PutImage(0,239,pt3^,0);
                  PutImage(320,239,pt4^,0);
                  BeginButtons;
                  ShowMouse;
                  goto Start
                end;
            end;
            CaseMain(mvib,7);
            mvib:=7;
            CaseMain(mvib,0)
          end;
        { Опции rect=20}
        if (rect(MouseX,MouseY)=Pravka) or ((mvib=8) and Enter) then
          begin
            HideMouse;
            PushButton(135,207,125,30,'Правка');
            ShowMouse;
            m[1]:='отменить';
            m[2]:='вернуть';
            m[3]:='удалить все';
            str(TekPart,s);
            m[4]:='удалить неравенство '+s;
            m[5]:='удалить';
            SizeMenu:=20;
            f:=Menus(135,237,180,110,m,5);
            if (f=1) and (TotalPred<>0) then
              begin
                with PredFunc^[TotalPred] do
                  case T of
                    0:begin
                        if TotalSucc=TotalBaks then
                          begin
                            for ff:=1 to TotalBaks-1 do SuccFunc^[ff]:=SuccFunc^[ff+1];
                            dec(TotalSucc);
                            SuccIf
                          end;
                        inc(TotalSucc);
                        str(TotalSucc,s);
                        Assign(FileVir,'succ'+s+ExtTemp);
                        Rewrite(FileVir);
                        write(FileVir,Part[P,PLR].Vir[Part[P,PLR].TotalVir]);
                        Close(FileVir);
                        dec(Part[P,PLR].TotalVir);
                        SuccFunc^[TotalSucc].T:=0;
                        SuccFunc^[TotalSucc].P:=P;
                        SuccFunc^[TotalSucc].PLR:=PLR
                      end;
                    1:begin
                        str(TotalPred,s);
                        Assign(FilePart,'pred'+s+ExtTemp);
                        Reset(FilePart);
                        read(FilePart,Part);
                        Close(FilePart);
                        Assign(FileIf,'if'+s+ExtTemp);
                        Reset(FileIf);
                        for ff:=1 to 6 do read(FileIf,VirIf[ff]);
                        Close(FileIf);
                        if TotalSucc=TotalBaks then
                          begin
                            for ff:=1 to TotalBaks-1 do SuccFunc^[ff]:=SuccFunc^[ff+1];
                            dec(TotalSucc);
                            SuccIf
                          end;
                        inc(TotalSucc);
                        SuccFunc^[TotalSucc].T:=1
                      end;
                    2:begin
                        str(TotalPred,s);
                        Assign(FileLR,'pred'+s+ExtTemp);
                        Reset(FileLR);
                        read(FileLR,Part[P,1]);
                        read(FileLR,Part[P,2]);
                        Close(FileLR);
                        Assign(FileIf,'if'+s+ExtTemp);
                        Reset(FileIf);
                        read(FileIf,VirIf[P]);
                        Close(FileIf);
                        if TotalSucc=TotalBaks then
                          begin
                            for ff:=1 to TotalBaks-1 do SuccFunc^[ff]:=SuccFunc^[ff+1];
                            dec(TotalSucc);
                            SuccIf
                          end;
                        inc(TotalSucc);
                        SuccFunc^[TotalSucc].T:=2;
                        SuccFunc^[TotalSucc].P:=P;
                      end;
                    3:begin
                        str(TotalPred,s);
                        Assign(FileLR,'pred'+s+ExtTemp);
                        Reset(FileLR);
                        read(FileLR,Part[P,PLR]);
                        Close(FileLR);
                        if TotalSucc=TotalBaks then
                          begin
                            for ff:=1 to TotalBaks-1 do SuccFunc^[ff]:=SuccFunc^[ff+1];
                            dec(TotalSucc);
                            SuccIf
                          end;
                        inc(TotalSucc);
                        SuccFunc^[TotalSucc].T:=3;
                        SuccFunc^[TotalSucc].P:=P;
                        SuccFunc^[TotalSucc].PLR:=PLR
                      end;
                  end;
                dec(TotalPred)
              end;
            if (f=2) and (TotalSucc<>0) then
              begin
                with SuccFunc^[TotalSucc] do
                  case T of
                    0:begin
                        str(TotalSucc,s);
                        Assign(FileVir,'succ'+s+ExtTemp);
                        Reset(FileVir);
                        inc(Part[P,PLR].TotalVir);
                        read(FileVir,Part[P,PLR].Vir[Part[P,PLR].TotalVir]);
                        Close(FileVir);
                        if TotalPred=TotalBaks then
                          begin
                            for ff:=1 to TotalBaks-1 do PredFunc^[ff]:=PredFunc^[ff+1];
                            dec(TotalPred);
                            PredIf
                          end;
                        inc(TotalPred);
                        PredFunc^[TotalPred].P:=P;
                        PredFunc^[TotalPred].PLR:=PLR
                      end;
                    1:f:=3;
                    2:begin
                        TekPart:=P;
                        f:=4
                      end;
                    3:begin
                        TekPart:=P;
                        LeftRigth:=PLR;
                        f:=5
                      end;
                  end;
                dec(TotalSucc)
              end;
            if f=3 then
              begin
                if TotalPred=TotalBaks then
                  begin
                    for ff:=1 to TotalBaks-1 do PredFunc^[ff]:=PredFunc^[ff+1];
                    dec(TotalPred);
                    PredIf
                  end;
                inc(TotalPred);
                with PredFunc^[TotalPred] do
                  begin
                    T:=1;
                    str(TotalPred,s);
                    Assign(FilePart,'pred'+s+ExtTemp);
                    Rewrite(FilePart);
                    write(FilePart,Part);
                    Close(FilePart);
                    Assign(FileIf,'if'+s+ExtTemp);
                    Rewrite(FileIf);
                    for ff:=1 to 6 do write(FileIf,VirIf[ff]);
                    Close(FileIf)
                  end;
                for ff:=1 to 6 do
                  for l:=1 to 2 do
                    Part[ff,l].TotalVir:=0
              end;
            if f=4 then
              begin
                if TotalPred=TotalBaks then
                  begin
                    for ff:=1 to TotalBaks-1 do PredFunc^[ff]:=PredFunc^[ff+1];
                    dec(TotalPred);
                    PredIf
                  end;
                inc(TotalPred);
                with PredFunc^[TotalPred] do
                  begin
                    T:=2;
                    P:=TekPart;
                    str(TotalPred,s);
                    Assign(FileLR,'pred'+s+ExtTemp);
                    Rewrite(FileLR);
                    write(FileLR,Part[TekPart,1]);
                    write(FileLR,Part[TekPart,2]);
                    Close(FileLR);
                    Assign(FileIf,'if'+s+ExtTemp);
                    Rewrite(FileIf);
                    write(FileIf,VirIf[P]);
                    Close(FileIf)
                  end;
                Part[TekPart,1].TotalVir:=0;
                Part[TekPart,2].TotalVir:=0
              end;
            if f=5 then
              begin
                if TotalPred=TotalBaks then
                  begin
                    for ff:=1 to TotalBaks-1 do PredFunc^[ff]:=PredFunc^[ff+1];
                    dec(TotalPred);
                    PredIf
                  end;
                inc(TotalPred);
                with PredFunc^[TotalPred] do
                  begin
                    T:=3;
                    P:=TekPart;
                    PLR:=LeftRigth;
                    str(TotalPred,s);
                    Assign(FileLR,'pred'+s+ExtTemp);
                    Rewrite(FileLR);
                    write(FileLR,Part[P,PLR]);
                    Close(FileLR)
                  end;
                Part[TekPart,LeftRigth].TotalVir:=0
              end;
            HideMouse;
            Button(135,207,125,30,'Правка');
            ShowMouse;
            WorkWindow;
            Enter:=false;
            CaseMain(mvib,7);
            mvib:=8;
            CaseMain(mvib,0);
            goto Main
          end;
        if (rect(MouseX,MouseY)=PartSystem) or ((mvib=9) and Enter) then
          begin
            HideMouse;
            str(TekPart,s);
            PushButton(10,247,220,30,'неравенство(уравнение) '+s);
            ShowMouse;
            Delay(PushButtonDelay);
            HideMouse;
            inc(TekPart);
            if TekPart=7 then TekPart:=1;
            str(TekPart,s);
            Button(10,247,220,30,'неравенство(уравнение) '+s);
            ShowMouse;
            WorkWindow;
            Enter:=false;
            CaseMain(mvib,7);
            mvib:=9;
            CaseMain(mvib,0)
          end;
        if (rect(MouseX,MouseY)=LR) or ((mvib=11) and Enter) then
          begin
            HideMouse;
            PushButton(10,287,250,30,LeftRigthText[LeftRigth]);
            ShowMouse;
            Delay(PushButtonDelay);
            HideMouse;
            LeftRigth:=LeftRigth+1;
            if LeftRigth=3 then LeftRigth:=1;
            Button(10,287,250,30,LeftRigthText[LeftRigth]);
            ShowMouse;
            WorkWindow;
            Enter:=false;
            CaseMain(mvib,7);
            mvib:=11;
            CaseMain(mvib,0)
          end
      end;{MouseDown(LeftButton)}
    for l:=6 to 11 do
      if (rect(MouseX,MouseY)=l) and (vibor<>l) then
        begin
          CaseMain(mvib,7);
          Vibors(Vibor,0);
          Vibor:=l;
          mvib:=l-5;
          CaseMain(mvib,0)
        end
    until Never
  end;
{   Exit  }
if ((MouseX>=170) and (MouseX<=470) and (MouseY>=290) and (MouseY<=320)) or ((vib=3) and Enter) then ExitNow
{   End   }
end
until halts;
Finish:
Program_End
end.