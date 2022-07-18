unit U_SENHAS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TF_SENHAS = class(TForm)
    Label1: TLabel;
    btnExecutar: TButton;
    edtSenha: TEdit;
    lblSENHA: TStaticText;
    btnLimpar: TButton;
    btnSair: TButton;
    Label2: TLabel;
    procedure btnExecutarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure edtSenhaChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_SENHAS: TF_SENHAS;

implementation

uses U_BIBLIOTECA;

{$R *.dfm}

{ TF_SENHAS }

procedure TF_SENHAS.FormCreate(Sender: TObject);
//DESABILITA O BOTAO FECHAR DO FORMULÁRIO
var
  hwndHandle : THANDLE;
  hMenuHandle : HMenu;
begin
//Impede movimentação do formulário
 DeleteMenu(GetSystemMenu(Handle, False), SC_MOVE, MF_BYCOMMAND);

  hwndHandle := Self.Handle;
  if (hwndHandle <> 0) then
    begin
      hMenuHandle := GetSystemMenu(hwndHandle, FALSE);
        if (hMenuHandle <> 0) then
          DeleteMenu(hMenuHandle, SC_CLOSE, MF_BYCOMMAND);
  end;

end;

procedure TF_SENHAS.FormShow(Sender: TObject);
begin
 if ( AcessarEdicaoLogin )then
 begin
  edtSenha.Text := senhaUsuarioDoBanco;
  edtSenha.ReadOnly:=true;
  btnExecutarClick(self);
 end else begin
    edtSenha.Text := '';

 end
end;

procedure TF_SENHAS.btnExecutarClick(Sender: TObject);
begin
  if ( AcessarEdicaoLogin )then
  begin
    lblSENHA.Caption    := DescriptografarSenha(edtSenha.Text);
    btnExecutar.Enabled :=false;
    btnLimpar.Enabled   :=false;
  end else begin
    lblSENHA.Caption    := DescriptografarSenha(edtSenha.Text);
    btnLimpar.Enabled   :=true;
  end;
end;

procedure TF_SENHAS.btnLimparClick(Sender: TObject);
begin
edtSenha.Clear;
lblSENHA.Caption    := '';
btnLimpar.Enabled   :=false;
btnExecutar.Enabled :=false;
edtSenha.SetFocus;
end;

procedure TF_SENHAS.btnSairClick(Sender: TObject);
begin
  if ( AcessarEdicaoLogin )then
  begin
     AcessarEdicaoLogin:=false;
     close;
  end else begin
     close;
     release;
  end;
end;

procedure TF_SENHAS.edtSenhaChange(Sender: TObject);
begin
btnExecutar.Enabled:=true;
btnLimpar.Enabled  :=true;
end;


end.
