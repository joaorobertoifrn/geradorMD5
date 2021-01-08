program MD5;

uses
  Forms,
  Form_Principal in 'Form_Principal.pas' {Form1},
  unitMD5 in 'unitMD5.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Resposta Solicitação';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
