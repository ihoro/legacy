var
    FileName:string[12];
    TekSymbol:byte;
    OnOffSymbol:array[1..TotalSymbols] of Boolean;
    Err,F,L,D,MM:integer;
    YouX,YouY,SizeX,SizeY:word;
    TekColor:byte;
    Yes:Boolean;
    PSymbol:Pointer;
    p:^Char;
    h:Char;