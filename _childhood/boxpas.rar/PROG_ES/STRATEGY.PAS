uses Objects;
const
      TerritorySize = 150;
      MaxBlock = 255;
      GraphDriver:Integer = 9; {VGA}
var
    MaxX,
    MaxY:1..TerritorySize;
type
     XYType = 1..TerritorySize;
     FazaType = 1..20;
     GoType = 1..8;
     BlockType = 0..MaxBlock;
     ScreenXYType = 1..800;
     TerritoryType = array[1..TerritorySize,1..TerritorySize] of BlockType;
     SpaceType = Set of BlockType;

     StrategicObject =
        Object
          Private
            MaxFaza:FazaType;
            MaxGo:GoType;
            ObjectSpace:SpaceType;
            ObjectX,ObjectY:XYType;
            ObjectFaza:FazaType;
            ObjectGo:GoType;
            ObjectStop:Boolean;
            TargetX,TargetY:XYType;
          Public
            constructor Init(OX,OY:XYType;OGo:GoType;OFaza:FazaType;OStop:Boolean);
            constructor InitTarget(TX,TY:XYType);
            constructor TotalFazes(Total:FazaType);
            constructor TotalGoes(Total:GoType);
            constructor Space(Sp:SpaceType);
            function WhereX:XYType;
            function WhereY:XYType;
            function Stop:Boolean;
            procedure Move;
            procedure Draw(X,Y:XYType;Go:GoType;Faza:FazaType); virtual;
        end;
     Territory =
        Object
          Private
            MaxTerritoryX,MaxTerritoryY:XYType;
            TerritoryX,TerritoryY:ScreenXYType;
            TerritoryFirstX,TerritoryFirstY:XYType;
            TerritorySizeX,TerritorySizeY:XYType;
            TerritoryOnOff:Boolean;
            TerritoryData:TerritoryType;
            OriginalData:TerritoryType;
          Public
            constructor Init(Terr:TerritoryType;MaxTerrX,MaxTerrY:XYType;FirstX,FirstY:XYType);
            constructor SetOnScreen(TerrX,TerrY:ScreenXYType;SizeX,SizeY:XYType);
            constructor On;
            constructor Off;
            procedure DrawBlock(X,Y:ScreenXYType;Block:BlockType); virtual;
            procedure Draw;
        end;
     Radar =
        Object
          Private
            RadarX,RadarY:ScreenXYType;
            RadarSizeX,RadarSizeY:XYType;
            RadarFirstX,RadarFirstY:XYType;
            RadarOnOff:Boolean;
          Public
            constructor Init(X,Y:ScreenXYType;SizeX,SizeY,FirstX,FirstY:XYType);
            constructor On;
            constructor Off;
            procedure Draw;
        end;
constructor StrategicObject.Init;
begin
ObjectX:=OX;
ObjectY:=OY;
ObjectGo:=OGo;
ObjectFaza:=OFaza;
ObjectStop:=OStop
end;
constructor StrategicObject.InitTarget;
begin
TargetX:=TX;
TargetY:=TY
end;
constructor StrategicObject.TotalFazes;
begin
MaxFaza:=Total
end;
constructor StrategicObject.TotalGoes;
begin
MaxGo:=Total
end;
constructor StrategicObject.Space(Sp:SpaceType);
begin
ObjectSpace:=Sp
end;
function StrategicObject.WhereX:XYType;
begin
WhereX:=ObjectX
end;
function StrategicObject.WhereY:XYType;
begin
WhereY:=ObjectY
end;
function StrategicObject.Stop:Boolean;
begin
Stop:=ObjectStop
end;
procedure StrategicObject.Move;
begin
end;
procedure StrategicObject.Draw;
begin
Territory.Draw
end;
constructor Territory.Init;
begin
TerritoryOnOff:=true;
TerritoryData:=Terr;
OriginalData:=Terr;
MaxTerritoryX:=MaxTerrX;
MaxTerritoryY:=MaxTerrY;
TerritoryFirstX:=FirstX;
TerritoryFirstY:=FirstY
end;
constructor Territory.SetOnScreen;
begin
TerritoryX:=TerrX;
TerritoryY:=TerrY;
TerritorySizeX:=SizeX;
TerritorySizeY:=SizeY
end;
constructor Territory.On;
begin
TerritoryOnOff:=true
end;
constructor Territory.Off;
begin
TerritoryOnOff:=false
end;
procedure Territory.DrawBlock;
begin
end;
procedure Territory.Draw;
begin
end;
constructor Radar.Init;
begin
RadarOnOff:=true;
RadarX:=X;
RadarY:=Y;
RadarSizeX:=SizeX;
RadarSizeY:=SizeY;
RadarFirstX:=FirstX;
RadarFirstY:=FirstY
end;
constructor Radar.On;
begin
RadarOnOff:=true
end;
constructor Radar.Off;
begin
RadarOnOff:=false
end;
procedure Radar.Draw;
begin
end;
begin
MaxX:=150;
end.