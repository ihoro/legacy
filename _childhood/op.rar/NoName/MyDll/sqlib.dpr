library sqlib;

function kvadrat(par: Integer): Integer; StdCall;
begin
  Result:=par*par
end;

exports
  kvadrat;

end.
