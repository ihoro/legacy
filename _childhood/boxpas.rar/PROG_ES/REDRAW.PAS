uses App,Memory, Crt;
type NN=object(TApplication)
          procedure Kl;
        end;
procedure NN.Kl;
begin
Redraw
end;
var N:NN;
begin
InitVideo;
textcolor(12);
write('OOOOOOOK Ok Ok');
DoneVideo;
readln;
InitVideo;
N.Kl;
readln;
DoneVideo
end.