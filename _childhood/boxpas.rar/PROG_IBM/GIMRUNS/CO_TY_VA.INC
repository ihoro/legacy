label
      Start,NewMain,Main,Finish{,Next,Next2};
const
      ButtonScrollDelay = 1; {seconds}
      MaxVir = 200;
      MaxDlinaVir = 2560;
      PushButtonDelay = 1000;
      Menshe = 1;
      Bolshe = 2;
      MenRavno = 3;
      BolRavno = 4;
      Ravno = 5;
      AXBYE = 6;
      VKoren = 7;
      VModul = 8;
      VCos = 9;
      VSin = 10;
      VConst = 11;
      PartSystem = 12;
      LR = 13;
      Options = 20;
      Save = 21;
      Open = 22;
      Graphic = 23;
      Menu = 24;
      Exits = 25;
      Cancel = 26;
      OIVButt = 27;
      Znaki = 28;
      ScrollBar = 29;
      POnOff = 32;
      PWinCur = 33;
      SaveExit = 34;
      SaveSave = 35;
      Pravka = 36;
      FilesPole = 37;
      LoadUp = 38;
      LoadDown =39;
      SizeMenu:Word = 20;
      Key = 12;
      TotalBaks = 100;
      MaxSpisok = 100;
      ExtTemp = '.$im';
      HelpFile:string = 'help.dat';
      Never = false;
      Figures:set of Char = ['0','1','2','3','4','5','6','7','8','9','-'];
      LeftRigthText:array[1..2] of string[12] =
                      ('левая часть','правая часть');
      ZnakText:array[1..6] of string[2] =
                 ('=','<','>','<=','=>','<>');
      ColorsText:array[0..15] of string[12] =
                   ('черный','синий','зеленый','голубой','красный','фиолетовый','коричневый',
                    'светло-серый','темно-серый','ярко-синий','ярко-зеленый','ярко-голубой',
                    'розовый','малиновый','желтый','белый');
      SetupNameFile = 'gimruns.ini';
      FileSymbols:set of Char =['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O',
                                'P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3',
                                '4','5','6','7','8','9','-','_','$','#','&','@','!','%','(',
                                ')','{','}','''','`','~','^',#8];
      TestText = '(C) 2000-2001 by OIV Company Ltd.';
type
     MenuType = array[1..20] of string;
     MainVirType = (Drob,Auto);
     TypType = 0..30;
     IfType = 1..6; {1 =,2 <,3 >,4 <=,5 >=,6 <>}
     FirstType = (kore,modu,zero);
     ZnakType = 1..4; {1 +,2 -,3 /,4 *}
     SpisokType = array[1..MaxSpisok] of string[8];
     FuncType = array[1..TotalBaks] of
                  record
                    T,P,PLR:Byte {T 0-обычное, 1-удалил все, 2-удалил N, 3-удалил LR}
                  end;
     VirType = record
                 Typ       :TypType;
                 First     :FirstType;
                 Koren     :Boolean;
                 Modul     :Boolean;
                 A,B,C     :LongInt;
               end;
     LRType = record
                Znak:array[1..199] of ZnakType;
                TotalVir:0..200;
                Vir:array[1..200] of VirType
              end;
     PartType = array[1..6,1..2] of LRType;
     ScrollDataType = array[1..6{,1..2}] of
                        record
                          SX,SY,SOX,SOY:Integer;
                          SStr:array[0..2560*2+2] of Char;
                          SStrOX,SStrX:Word
                        end;
var
    PixelColor,
    PixelBKColor,
    LineColor,
    PointsColor,
    PointsBKColor:Byte;
    FonGr,TonGr,TonCoor,FonPoi,TonPoi:Byte;
    virs:VirType;
    mx,my,mox,moy :integer;
    vibo,totalm   :Byte;
    mmm           :MenuType;
    h:Char;
   F,L,FF,FT,FD,
   Gd,Gm,
   FX,LY          :Integer;
   Filter         :TBmpFilter;
   Image          :TImage;
   x,
   y,
   MouseX,
   MouseY         :Integer;
   SetupFile,
   Gim            :Text;
   FilePart       :file of PartType;
   FileLR         :file of LRType;
   FileVir        :file of VirType;
   FileIf         :file of IfType;
   TekFile        :string[8];
   Files         :^SpisokType;
   TFile          :SearchRec;
   TotalSpisok,
   SpisokV,
   SpisokX        :0..MaxSpisok;
   {}{}{}{}{}{}{}{}{}
   TekPart        :Byte;
   LeftRigth      :1..2;
   VirIf:array[1..6] of IfType;
   PartOnOff,
   PartOk:array[1..6] of Boolean;
   Part:PartType;
   BakPart:^PartType;
   ChisloA,
   ChisloB,
   ChisloC        :LongInt;
   {}{}{}{}{}{}{}{}{}
   NumberVir      :0..200;
   Ev             :TEvent;
   Size,
   st,
   MaxX,
   MaxY           :Word;
   POIVButtonSelect,
   POIVButton,
   POIVButtonPush,
   Pt1,Pt2,Pt3,Pt4,
   POptions,
   PSpace,
   PSpaces,
   PDraw1,
   PDraw2,
   PDraw3,
   POn,
   POff,
   PFError         :Pointer;
   BOIVButtonSelect,
   BOIVButton,
   BOIVButtonPush,
   BOption,
   BOn,
   BOff,
   BFError         :Boolean;
   Error,
   Err1,
   Err2,
   Points,
   Ok,
   Enter,
   WinCur,
   ba,bb,bc,
   MyB,
   SQROn,
   Coor           :Boolean;
   vibor,mvib,
   stmax,
   vib            :Byte;
   s,ss,
   Name,chislo    :String;
   halts          :boolean;
   m              :MenuType;
   Res1,Res2      :Real;
   ScrollX,SXX,
   ScrollY,SYY,
   ScrollOX,SOXX,
   FixScrX,
   ScrollOY,SOYY,
   ScrSX,
   ScrSY,
   cx,cy          :Integer;
   ScrollStr      :array[0..2560] of Char;
   ScrollData     :^ScrollDataType;
   PredFunc,
   SuccFunc       :^FuncType;
   TotalPred,
   TotalSucc      :Byte;
   ScrStrOX,
   ScrStrX        :Word;
   ScrollOn,
   ButtonScrollOn,
   ButtonLR,
   Didit          :Boolean; {true - left}
   Time,FixTime,
   ch,min,sek,sot :Word;
   KorenOn:Boolean;
   PFErrorOX,
   Err            :Integer;
   Spisok         :array[1..6] of byte;