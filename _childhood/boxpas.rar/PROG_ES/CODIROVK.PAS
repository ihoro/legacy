{}{}{}{}{}{}{}{}{}{}{}
{}Program Kodirovka;{}
{}{}{}{}{}{}{}{}{}{}{}
uses Dos, Crt;
 var infile,outfile:text;   {*****************************}
     s,namefile:string;     {* (C) OIV Company Ltd. 2000 *}
     key,f:longint;         {*****************************}
begin
textcolor(10);
textbackground(0);
clrscr;
write(' ������ ��� 䠩��: ');
readln(namefile);
textcolor(13);
write('������ ���� ����஢��: ');
readln(key);
Assign(infile,namefile);
Assign(outfile,copy(namefile,1,Pos('.',namefile))+'out');
Reset(infile);
Rewrite(outfile);
while not EOF(infile) do  {***************************************}
 begin                    {* ������� ���� ����஢��! Main part. *}
  readln(infile,s);       {***************************************}
  for f:=1 to length(s) do s[f]:=chr(ord(s[f])+key);
  writeln(outfile,s)
 end;
 close(infile);
 close(outfile);          
 textcolor(14);
 write('����஢�� �����祭�!');
 readln
end.