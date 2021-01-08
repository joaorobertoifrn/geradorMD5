unit Form_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ClipBrd;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label_Build: TLabel;
    Label_Data: TLabel;
    Label_MD5: TLabel;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Edit_Solicitacao: TEdit;
    Label6: TLabel;
    Memo1: TMemo;
    Label7: TLabel;
    Memo2: TMemo;
    BitBtn1: TBitBtn;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses unitMD5;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  build : String;
begin
  if OpenDialog1.Execute then
  begin
    Edit1.Text := ExtractFilePath(OpenDialog1.FileName)+ExtractFileName(OpenDialog1.FileName);
    build := MD5.GetBuild(Edit1.Text);
    if build <> '' then
    begin
      Label4.Top := 94;
      Label_Data.Top := 94;
      Label_Build.AutoSize := true;
      Label_Build.Font.Color := clBlue;
      Label_Build.Caption    := build;
    end
    else
    begin
      Label4.Top := 103;
      Label_Data.Top := 103;
      Label_Build.Font.Color := clRed;
      Label_Build.Height := 27;
      Label_Build.Width := 482;
      Label_Build.Caption    := 'Arquivo sem Build. Ative a propriedade do projeto.'+#13
      +' Project / Options / Version Info / -> (Include version Information in project)';
    end;
   Label_Data.Caption  := MD5.DataCriacao(Edit1.Text);
   Edit_Solicitacao.SetFocus;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Memo : TMemo;
begin
 Label_MD5.Caption   := MD5.GeraArquivo(Edit1.Text);
 try
   Memo := TMemo.Create(nil);
   Memo.Parent := Self;
   Memo.WantReturns := True;
   Memo.WantTabs := True;
   Memo.Text :=
   'Solicitação: '+Edit_Solicitacao.Text+#13#10+#13#10+
   'Descrição Simplificada da Correção: '+#13#10+
   Memo1.Text +#13#10+#13#10+
   'Impacto da Mudança: ' + #13#10 +
   Memo2.Text +#13#10+#13#10+
   'Build : ' + Label_Build.Caption + #13#10+
   'Data/Hora de Criação do Arquivo : '+ Label_Data.Caption;
   Clipboard.AsText := Memo.Text;
 finally
   FreeAndNil(Memo);
 end;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    Key:= #0;
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

end.
