unit MinMax;

Interface

function Min(a,b:LongInt):LongInt;
function Max(a,b:LongInt):LongInt;

Implementation

function Min(a,b:LongInt):LongInt;
begin
if a<b then Min:=a
       else Min:=b
end;

function Max(a,b:LongInt):LongInt;
begin
if a>b then Max:=a
       else Max:=b
end;
end.