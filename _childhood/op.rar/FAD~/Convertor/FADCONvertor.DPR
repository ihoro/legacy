program FADConvertor;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'FAD Convertor';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
