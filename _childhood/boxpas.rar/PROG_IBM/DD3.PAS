begin
{$I-}
Mkdir(paramstr(1));
if IOResult <> 0 then
    writeln('no!')
    else writeln('yes!')
end.