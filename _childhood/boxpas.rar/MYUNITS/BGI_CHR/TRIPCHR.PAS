{ (C) OIV Company Ltd. 18.06.2000 }
unit TripChr;
Interface
Implementation
uses Graph;
procedure TripFont;external;
{$L trip.obj}
begin
if RegisterBGIFont(@TripFont)<0 then
  begin
    writeln('�訡�� �� ॣ����樨 ���� Trip.chr');
    halt
  end;
end.
