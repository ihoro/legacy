uses EGAVGA,Graph,GrDriver,Images,Crt,Dos;
var
    grD,grM:integer;
    Filter:TBMPFilter;
    Picture:TImage;
    name:string;
begin
if ParamCount=0 then halt;
name:=ParamStr(1);
grD:=Detect;
InitVideo;
Filter.Init;
InitGraph(grD,grM,'');
Picture.Import(name,@Filter);
Picture.Draw(0,0,NormalPut);
repeat
until KeyPressed;
CloseGraph;
Filter.Done;
DoneVideo
end.