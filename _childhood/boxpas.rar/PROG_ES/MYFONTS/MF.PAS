uses TextWind, Crt;
{$I mf_label.inc}
{$I mf_versi.inc}
{$I mf_symb.inc}
{$I mf_sml.inc}
{$I mf_color.inc}
{$I mf_curs.inc}
{$I mf_var.inc}
{$I mf_p&f.inc}
begin
Randomize;
GetMem(PSymbol,SQR(SizeMaxLine));
for l:=0 to SizeMaxLine-1 do
  for f:=0 to SizeMaxLine-1 do
    begin
      p:=ptr(seg(PSymbol^),ofs(PSymbol^)+l*SizeMaxLine+f*SizeOf(Char));
      p^:='0'
    end;
FileName:='';
TekSymbol:=1;
for f:=1 to TotalSymbols do OnOffSymbol[f]:=false;
YouX:=0;YouY:=0;
TekColor:=1;
SizeX:=8;
SizeY:=8;
PrintTitle;
MainScreen;
MenuY:=1;
FirstActive:=1;
F10Menu:
repeat
MM:=MainMenu;
Yes:=true;
case MM of
1:Redakt;
2:NewFont;
4:SaveFont(true);
6:ChangeColor;
12:ExitProgram(true)
end;
until Yes;
WorkWindow;
MyFontsWindow;
Help2Window;
repeat
SetXY;
p:=ptr(seg(PSymbol^),ofs(PSymbol^)+YouY*SizeMaxLine+YouX*SizeOf(Char));
l:=DeCoderSymbol(p^);
repeat
SetYou(l,false)
until KeyPressed;
h:=ReadKey;
if h=' ' then
  begin
    if not OnOffSymbol[TekSymbol] then
      begin
        OnOffSymbol[TekSymbol]:=true;
        OnOffWindow
      end;
    p:=ptr(seg(PSymbol^),ofs(PSymbol^)+YouY*SizeMaxLine+YouX*SizeOf(Char));
    p^:=CoderSymbol(TekColor);
    l:=TekColor
  end;
if h=#0 then
  begin
    h:=ReadKey;
    if h=#45 then ExitProgram(false);
    if h=#66 then
      begin
        TekColor:=TekColor+1;
        if TekColor=16 then TekColor:=0;
        SetColor
      end;
    if h=#68 then
      begin
        SetYou(l,true);
        Help1Window;
        goto F10Menu
      end;
    if (h=#72) and (YouY<>0) then
      begin
        SetYou(l,true);
        YouY:=YouY-1
      end;
    if (h=#80) and (YouY<>SizeY-1) then
      begin
        SetYou(l,true);
        YouY:=YouY+1
      end;
    if (h=#75) and (YouX<>0) then
      begin
        SetYou(l,true);
        YouX:=YouX-1
      end;
    if (h=#77) and (YouX<>SizeX-1) then
      begin
        SetYou(l,true);
        YouX:=YouX+1
      end;
  end;
until h=#27;
end.