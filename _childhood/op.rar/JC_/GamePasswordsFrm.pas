unit GamePasswordsFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TPasswords = array[1..255] of string;

  TAccess = set of Byte;

  TGP = class(TForm)
    Label1: TLabel;
    memData: TMemo;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    {FPasswords: TPasswords;
    FDescriptions: TPasswords;
    FCount: Byte;
    FAccess: TAccess;
    FCurrents: TAccess;
    FCurrentKey: Integer;
    FChecking: Boolean;
    FDefaultPassword: string;
    procedure ShowPasswords;
    procedure SetDefPass(AValue: string);}
  public
    {procedure Add(Keys,Description: string);
    procedure SetAccess(Access: TAccess);
    procedure OffAccess;
    procedure AllAccess;
    function CheckIt(Key: Char): Byte;
    property DefaultPassword: string read FDefaultPassword
      write SetDefPass;}
  end;

  TGamePasswords = class(TObject)
  private
    FPasswords: TPasswords;
    FDescriptions: TPasswords;
    FCount: Byte;
    FAccess: TAccess;
    FCurrents: TAccess;
    FCurrentKey: Integer;
    FChecking: Boolean;
    FDefaultPassword: string;
    procedure ShowPasswords;
    procedure SetDefPass(AValue: string);
  public
    constructor Create;
    procedure Add(Keys,Description: string);
    procedure SetAccess(Access: TAccess);
    procedure OffAccess;
    procedure AllAccess;
    function CheckIt(Key: Char): Byte;
    property DefaultPassword: string read FDefaultPassword
      write SetDefPass;
  end;

const
  DefPass = 'OIVSoft010585GamePasswords';

var
  GP: TGP;
  GamePasswords: TGamePasswords;

implementation

{$R *.DFM}

constructor TGamePasswords.Create;
begin
  FCount:=1;
  FCurrentKey:=0;
  FChecking:=false;
  DefaultPassword:=DefPass;
  FAccess:=[1]
end;

procedure TGamePasswords.SetDefPass(AValue: string);
begin
  FPasswords[1]:=AValue
end;

procedure TGamePasswords.Add(Keys,Description: string);
begin
  inc(FCount);
  FPasswords[FCount]:=Keys;
  FDescriptions[FCount]:=Description;
  FAccess:=FAccess+[FCount]
end;

procedure TGamePasswords.SetAccess(Access: TAccess);
begin
  FAccess:=[1]+Access
end;

procedure TGamePasswords.OffAccess;
begin
  FAccess:=[1]
end;

procedure TGamePasswords.AllAccess;
var
  f: Byte;
begin
  OffAccess;
  for f:=2 to FCount do
    FAccess:=FAccess+[f]
end;

procedure TGamePasswords.ShowPasswords;
begin
  GP:=TGP.Create(Application);
  try
    GP.ShowModal
  finally
    GP.Free;
    GP:=nil
  end
end;

function TGamePasswords.CheckIt(Key: Char): Byte;
var
  f: Byte;
  Ok: Boolean;
begin
  Result:=0;
  if not FChecking then
    begin
      FCurrentKey:=0;
      FChecking:=true;
      FCurrents:=FAccess
    end;
  inc(FCurrentKey);
  Ok:=false;
  for f:=1 to FCount do
    if f in FCurrents then
      if Key=FPasswords[f][FCurrentKey] then
        begin
          Ok:=true;
          if FCurrentKey=Length(FPasswords[f]) then
            begin
              Result:=f;
              if f<>1 then
                MessageDlg(FDescriptions[f],mtInformation,[mbOk],0);
              FChecking:=false;
              if f=1 then
                begin
                  Result:=0;
                  ShowPasswords
                end;
              Exit
            end
        end
                                        else
          FCurrents:=FCurrents-[f];
  if not Ok then
    FChecking:=false
end;

procedure TGP.FormShow(Sender: TObject);
var
  f: Byte;
begin
with GamePasswords do
 begin
  memData.Clear;
  for f:=2 to FCount do
    memData.Lines.Add(FDescriptions[f]+
      ': '+FPasswords[f])
 end
end;

procedure TGP.Button1Click(Sender: TObject);
begin
  Close
end;

end.
