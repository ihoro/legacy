unit Analyser;

interface

type
  TConstant =
    record
      Name: string[8];
      Value: string[30]
    end;

const
  TotalDefConsts = 2;
  TotalDefXY = 2;
  MaxConsts = 200+TotalDefConsts+TotalDefXY;
  DefaultXY: array[1..TotalDefXY] of TConstant =
    ((Name:'x';Value:''),
     (Name:'y';Value:''));
  DefaultConsts: array[1..TotalDefConsts] of TConstant =
    ((Name:'pi';Value:'3.1415926535897932385'),
     (Name:'exp';Value:'2.71828182845905'));
  //figures:
  Figures: set of Char =
    ['-','0','1','2','3','4','5','6','7','8','9',',','x','y'];
  FiguresW: set of Char =
    ['_','0','1','2','3','4','5','6','7','8','9',',','x','y'];
  // Signs:
  Signs: array[1..6] of string[2] = ('<>','<=','>=','<','>','=');
  //functions:
  TotalDefFunc = 19;
  TotalSimpleFunc = 11;
  LogSymbol = ';';
  DefaultFunc: array[1..TotalDefFunc] of string[6] =
    ('arcsin','arccos','arctg','arcctg','sin','cos',
     'ctg','tg','ln','lg','abs','log','^','*','/','+','_','[]','{}');
  // Точность вычислений до n-ой цифры после запятой:
  Accuracy = 5;

var
  Constants: array[1..MaxConsts] of TConstant;
  TotalConsts: 0..MaxConsts;
  MainExp: string; { Main Expression with "<=>" }
  lme: Word; { Length(MainExp) }
  WithXY: Boolean;
  LastError: Byte;
  {0-OK; 1-Ошибка при конвертации(неправильное число); 2-деление на ноль; 3-нет ";" у log'а;
   30-found X or Y}

procedure Initial;
function FindConsts(fcs: string): string;
function DoFunc(fu: Byte;t: Extended;t2: Extended=1): Extended;
function AnalysisInPars(Ex: string): string;
function AnalysisOnePart(pex: string): string;
function IsItRight(var vir: string;aWithXY: Boolean): Boolean;

implementation

uses
  SysUtils, Math;

procedure Initial;
var
  f: Byte;
begin
  MainExp:=LowerCase(MainExp);
  lme:=Length(MainExp);
  for f:=1 to TotalConsts do
    with Constants[f] do
      Name:=LowerCase(Name);
  for f:=TotalConsts+1 to TotalConsts+TotalDefConsts do
    Constants[f]:=DefaultConsts[f-TotalConsts];
  inc(TotalConsts,TotalDefConsts);
  if WithXY then
    begin
      for f:=TotalConsts+1 to TotalConsts+TotalDefXY do
        Constants[f]:=DefaultXY[f-TotalConsts];
      inc(TotalConsts,TotalDefXY)
    end
end;

function FindConsts(fcs: string): string;
var
  f,d,t: Word;
  l: 1..MaxConsts;
begin
  MainExp:=fcs;
  Initial;
  f:=0;
  repeat
    inc(f);
    for l:=1 to TotalConsts do
      with Constants[l] do
        if Length(Name)<=lme-f+1 then
          if Copy(MainExp,f,Length(Name))=Name then
            begin
              Delete(MainExp,f,Length(Name));
              Insert(Value,MainExp,f);
              lme:=Length(MainExp);
              f:=f+Length(Value)-1
            end
  until f>=lme;
  f:=0;
  repeat
    inc(f);
    {DONE: lme-?}
    if MainExp[f]='.' then MainExp[f]:=',';
    if MainExp[f]='X' then MainExp[f]:='x';
    if MainExp[f]='Y' then MainExp[f]:='y';
    if MainExp[f]='-' then
      begin
        MainExp[f]:='_';
        if f=1 then
          begin
            Insert('0',MainExp,1);
            inc(lme);
            inc(f)
          end;
        if f>1 then
        if not (MainExp[f-1] in Figures) then
          case MainExp[f-1] of
            'n','s','g':begin
              Insert('(0',MainExp,f);
              d:=f+1;
              while MainExp[d] in FiguresW do inc(d);
              Insert(')',MainExp,d);
              inc(lme,3);
              inc(f,2)
            end;
            '(':begin
              Insert('(0',MainExp,f);
              t:=1;
              d:=f;
              repeat
                inc(d);
                case MainExp[d] of
                  '(','[','{':inc(t);
                  ')',']','}':dec(t)
                end;
                {TODO: Error!}
                if d=lme then t:=0
              until t=0;
              Insert(')',MainExp,d);
              inc(lme,3);
              inc(f,2)
            end;
            '[','{':begin
              Insert('0',MainExp,f);
              inc(lme);
              inc(f)
            end
          end
      end
  until f>=lme;
  Result:=MainExp
end;

function DoFunc(fu: Byte;t: Extended;t2: Extended=1): Extended;
begin
  Result:=1;
  {TODO: Ошибка при счете!}
  case fu of
    1:begin
        if sqrt(1-t*t)=0 then
          begin
            LastError:=2;
            {Error!}
          end;
        Result:=arctan(t/sqrt(1-t*t))
      end;
    2:begin
        if t=0 then
          begin
            LastError:=2;
            {Error!}
          end;
        Result:=arctan(sqrt(1-t*t)/t)
      end;
    3:Result:=arctan(t);
    4:begin
        if t=0 then
          begin
            LastError:=2;
            {Error!}
          end;
        Result:=arctan(1/t)
      end;
    5:Result:=sin(t);
    6:Result:=cos(t);
    7:begin
        if sin(t)=0 then
          begin
            LastError:=2;
            {Error!}
          end;
        Result:=cos(t)/sin(t)
      end;
    8:begin
        if cos(t)=0 then
          begin
            LastError:=2;
            {Error!}
          end;
        Result:=sin(t)/cos(t)
      end;
    9:Result:=ln(t); {t<0}
    10:Result:=log10(t); {t<0}
    11:Result:=abs(t);
    12:Result:=logn(t,t2); {t2<0 t<0 t=1}
    13:Result:=exp(t2*ln(t)); {t<0}
    14:Result:=t*t2;
    15:Result:=t/t2; {t2=0}
    16:Result:=t+t2;
    17:Result:=t-t2;
    18:Result:=Floor(t);
    19:Result:=Frac(t)
  end
end;

function AnalysisInPars(Ex: string): string;
var
  f,tempf,Size,fu,Size2: Word;
  t,t2: Extended;

function GetNBefore: Extended;
var
  l: Word;
  ns: string;
  tc: Char;
begin
  Result:=1;
  l:=tempf;
  Size:=0;
  repeat
    dec(l);
    inc(Size);
    if MainExp[l] in Figures then ns:=ns+MainExp[l]
  until not (MainExp[l] in Figures);
  dec(Size);
  for l:=1 to Length(ns) div 2 do
    begin
      tc:=ns[l];
      ns[l]:=ns[Length(ns)-l+1];
      ns[Length(ns)-l+1]:=tc
    end;
  {DONE: Обработка ошибки!}
  LastError:=0;
  try
    Result:=StrToFloat(ns)
  except
    if (ns=DefaultXY[1].Name) or (ns=DefaultXY[2].Name) then
      LastError:=30
                                                        else
      LastError:=1
  end
end;

function GetNAfter: Extended;
var
  l: Word;
  ns: string;
begin
  Result:=1;
  l:=tempf;
  Size:=0;
  repeat
    inc(l);
    inc(Size);
    {f (MainExp[l]='-') and (l<>tempf+1) then Continue;}
    if MainExp[l] in Figures then ns:=ns+MainExp[l]
  until not (MainExp[l] in Figures){ or ((MainExp[l]='-') and (l<>tempf+1))};
  dec(Size);
  {DONE: Обработка ошибки!}
  LastError:=0;
  try
    Result:=StrToFloat(ns)
  except
    if (ns=DefaultXY[1].Name) or (ns=DefaultXY[2].Name) then
      LastError:=30
                                                        else
      LastError:=1
  end
end;

begin
  MainExp:=Ex;
  lme:=Length(MainExp);
  {DONE: При вставке значений : lme-? f-?}
  // find "[]" or "{}"
  for f:=1 to lme-1 do
    for fu:=18 to 19 do
      if MainExp[f]=DefaultFunc[fu][1] then
        begin
          tempf:=f;
          t:=GetNAfter;
          {TODO: If error!}
          if LastError=0 then
            begin
              t:=DoFunc(fu,t);
              {TODO: If error!}
              if LastError=0 then
                begin
                  Delete(MainExp,f,Length(DefaultFunc[fu])+Size);
                  Insert(FloatToStr(t),MainExp,f);
                  lme:=Length(MainExp)
                end
            end
        end;
  // find functions(1-TotalSimpleFunc)...
  for fu:=1 to TotalSimpleFunc do
    begin
      f:=0;
      repeat
        inc(f);
        if Copy(MainExp,f,Length(DefaultFunc[fu]))=DefaultFunc[fu] then
          begin
            tempf:=f+Length(DefaultFunc[fu])-1;
            t:=GetNAfter;
            {TODO: If error!}
            if LastError=0 then
              begin
                t:=DoFunc(fu,t);
                {TODO: If error!}
                if LastError=0 then
                  begin
                    Delete(MainExp,f,Length(DefaultFunc[fu])+Size);
                    Insert(FloatToStr(t),MainExp,f);
                    lme:=Length(MainExp)
                  end
              end
        end;
      until f>=lme-Length(DefaultFunc[fu])+1
    end;
  // find "log"
  fu:=12;
  for f:=1 to lme-Length(DefaultFunc[fu])+1 do
    if Copy(MainExp,f,Length(DefaultFunc[fu]))=DefaultFunc[fu] then
        begin
          tempf:=f+Length(DefaultFunc[fu])-1;
          t:=GetNAfter;
          if MainExp[f+Length(DefaultFunc[fu])+Size]<>LogSymbol then
            begin
              LastError:=3;
              {TODO: Error!}
            end;
          {TODO: If error!}
          if LastError=0 then
            begin
              Size2:=Size;
              tempf:=f+Length(DefaultFunc[fu])+Size;
              t2:=GetNAfter;
              t:=DoFunc(fu,t,t2);
              {TODO: If error!}
              if LastError=0 then
                begin
                  Delete(MainExp,f,Length(DefaultFunc[fu])+Size+Size2+1);
                  Insert(FloatToStr(t),MainExp,f);
                  lme:=Length(MainExp)
                end
            end
        end;
  // find "^"
  fu:=13;
  f:=0;
  repeat
    inc(f);
    if MainExp[f]=DefaultFunc[fu] then
      begin
        tempf:=f;
        t:=GetNBefore;
        {TODO: If error!}
        if LastError=0 then
          begin
            Size2:=Size;
            t2:=GetNAfter;
            t:=DoFunc(fu,t,t2);
            {TODO: If error!}
            if LastError=0 then
              begin
                Delete(MainExp,f-Size2,Size2+Length(DefaultFunc[fu])+Size);
                Insert(FloatToStr(t),MainExp,f-Size2);
                lme:=Length(MainExp);
                f:=f-Size2
              end
          end
      end
  until f>=lme-Length(DefaultFunc[fu]);
  // find "*" or "/"
  f:=0;
  repeat
    inc(f);
    for fu:=14 to 15 do
      if MainExp[f]=DefaultFunc[fu] then
        begin
          tempf:=f;
          t:=GetNBefore;
          {TODO: If error!}
          if LastError=0 then
            begin
              Size2:=Size;
              t2:=GetNAfter;
              t:=DoFunc(fu,t,t2);
              {TODO: If error!}
              if LastError=0 then
                begin
                  Delete(MainExp,f-Size2,Size2+Length(DefaultFunc[fu])+Size);
                  Insert(FloatToStr(t),MainExp,f-Size2);
                  lme:=Length(MainExp);
                  f:=f-Size2
                end
            end
        end
  until f>=lme-1;
  // find "+" or "-"
  f:=0;
  repeat
    inc(f);
    for fu:=16 to 17 do
      if MainExp[f]=DefaultFunc[fu] then
        begin
          tempf:=f;
          t:=GetNBefore;
          {TODO: If error!}
          if LastError=0 then
            begin
              Size2:=Size;
              t2:=GetNAfter;
              t:=DoFunc(fu,t,t2);
              {TODO: If error!}
              if LastError=0 then
                begin
                  Delete(MainExp,f-Size2,Size2+Length(DefaultFunc[fu])+Size);
                  Insert(FloatToStr(t),MainExp,f-Size2);
                  lme:=Length(MainExp);
                  f:=f-Size2
                end
            end
        end
  until f>=lme-1;
  Result:=MainExp
end;

function AnalysisOnePart(pex: string): string;
var
  f: Word;
  TotalP: Word;
  tmp: string;
  lpe: Word;
  Pars: array[1..40000] of
    record
      Pos: Word;
      Typ: Byte
    end;
begin
  {TODO: Error! Many pars!}
  TotalP:=0;
  f:=0;
  lpe:=Length(pex);
  {TODO: Обработка ошибок: !!!}
  repeat
    inc(f);
    if pex[f] in ['(','[','{'] then
      begin
        inc(TotalP);
        Pars[TotalP].Pos:=f;
        case pex[f] of
          '(':Pars[TotalP].Typ:=1;
          '[':Pars[TotalP].Typ:=2;
          '{':Pars[TotalP].Typ:=3
        end
      end;
    if pex[f] in [')',']','}'] then
      begin
        tmp:=AnalysisInPars(Copy(pex,Pars[TotalP].Pos+1,f-Pars[TotalP].Pos-1));
        if pex[f]=')' then
          begin
            Delete(pex,Pars[TotalP].Pos,f-Pars[TotalP].Pos+1);
            Insert(tmp,pex,Pars[TotalP].Pos);
            f:=Pars[TotalP].Pos
          end
                      else
          begin
            Delete(pex,Pars[TotalP].Pos+1,f-Pars[TotalP].Pos-1);
            Insert(tmp,pex,Pars[TotalP].Pos+1);
            f:=Pars[TotalP].Pos+Length(tmp)+1
          end;
        lpe:=Length(pex);
        dec(TotalP)
      end;
  until f>=lpe;
  Result:=AnalysisInPars(pex)
end;

function IsItRight(var vir: string;aWithXY: Boolean): Boolean;
var
  f: Word;
  si,sis: Byte;
  p1,p2: string;
  c1,c2: Extended;
begin
  WithXY:=aWithXY;
  vir:=FindConsts(vir);
  for f:=1 to Length(vir) do
    begin
      if Copy(vir,f,2)=Signs[1] then
        begin
          si:=1; sis:=2;
          Break
        end;
      if Copy(vir,f,2)=Signs[2] then
        begin
          si:=2; sis:=2;
          Break
        end;
      if Copy(vir,f,2)=Signs[3] then
        begin
          si:=3; sis:=2;
          Break
        end;
      if vir[f]=Signs[4] then
        begin
          si:=4; sis:=1;
          Break
        end;
      if vir[f]=Signs[5] then
        begin
          si:=5; sis:=1;
          Break
        end;
      if vir[f]=Signs[6] then
        begin
          si:=6; sis:=1;
          Break
        end;
      if f=Length(vir) then
        begin
          {TODO: Error! Нет знака!}
        end
    end;
  {TODO: Обработка ошибок...}
  p1:=AnalysisOnePart(Copy(vir,1,f-1));
  p2:=AnalysisOnePart(Copy(vir,f+sis,Length(vir)-f-sis+1));
  try
    c1:=Round(StrToFloat(p1)*exp(Accuracy*ln(10)))/exp(Accuracy*ln(10));
    c2:=Round(StrToFloat(p2)*exp(Accuracy*ln(10)))/exp(Accuracy*ln(10));
  except
    {TODO: Error!}
  end;
  Result:=false;
  case si of
    1:if c1<>c2 then Result:=true;
    2:if c1<=c2 then Result:=true;
    3:if c1>=c2 then Result:=true;
    4:if c1<c2 then Result:=true;
    5:if c1>c2 then Result:=true;
    6:if c1=c2 then Result:=true
  end;
  vir:=p1+Signs[si]+p2
end;

end.
