unit OIVSoftInt;

interface

uses
  WinTypes;

function ShowOIVSoft(AHandle: THandle): Byte; StdCall;

implementation

function ShowOIVSoft(AHandle: THandle): Byte;
            external 'OIVSoft' name 'ShowOIVSoft'

end.
