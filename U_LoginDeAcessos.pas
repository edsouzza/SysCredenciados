unit U_LoginDeAcessos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, Mask, Encryp, DBCtrls,
  Menus, IniFiles;

type
  TF_LOGINDEACESSOS = class(TForm)
    pnl_cabecalho: TPanel;
    pnl_rodape: TPanel;
    pnl_EscolhaUsuario: TPanel;
    btn_Entrar: TSpeedButton;
    btn_Sair: TSpeedButton;
    lblHoraAtual: TLabel;
    lblDataDoDia: TLabel;
    pnl_DadosUsuario: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    edt_Senha: TEdit;
    edt_Usuario: TStaticText;
    procedure btn_SairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure edt_SenhaChange(Sender: TObject);
    procedure btn_EntrarClick(Sender: TObject);
    procedure Autenticar;
    procedure edt_SenhaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);

 
  private
    { Private declarations }

  public
    { Public declarations }

  end;

var
  F_LOGINDEACESSOS: TF_LOGINDEACESSOS;

implementation

uses U_DM, U_BIBLIOTECA, U_DMPESQ, U_LogOperacoes, USobre, U_LOGIN,
  U_PRINCIPAL, U_EDITARLOGIN, DBClient, DB, U_BACKUPBANCODADOS;

{$R *.dfm}


procedure TF_LOGINDEACESSOS.FormCreate(Sender: TObject);
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

   lblDataDoDia.Caption:=  DateToStr(date);
   lblHoraAtual.Caption:=  timetoStr(time); 

end;


procedure TF_LOGINDEACESSOS.FormShow(Sender: TObject);
begin
   with DM.CDS_USUARIOS do
   begin
      close;
      CommandText:='select * from tbl_usuarios where id_usuario=1';
      open;

      if not IsEmpty then
          senhaAdmDoBanco := DM.CDS_USUARIOS.fieldbyname('senha').AsString;
   end;

end;

procedure TF_LOGINDEACESSOS.btn_SairClick(Sender: TObject);
begin
    close;

end;

procedure TF_LOGINDEACESSOS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    acessoBackupBanco := false;
    close;
    Release;

end;

procedure TF_LOGINDEACESSOS.edt_SenhaChange(Sender: TObject);
begin
    btn_Entrar.Enabled:= true;

end;


procedure TF_LOGINDEACESSOS.btn_EntrarClick(Sender: TObject);
begin
    Autenticar;

end;

procedure TF_LOGINDEACESSOS.Autenticar;
begin    
      btn_Sair.Enabled     := True;
      btn_Entrar.Enabled   := False;
      senhaAcesso          := CriptografarSenha(edt_Senha.Text);

      if ( senhaAcesso = senhaAdmDoBanco ) then
      begin
            //Application.MessageBox('Acesso Liberado para esta operação!', 'Informação de Sistema!', MB_OK + MB_ICONINFORMATION);
            Tentativas  := 0;
            if ( AcessarEdicaoLogin )then    //para consulta e edição de login na tela de login atraves fo F1
            begin
                Application.CreateForm(TF_EDITARLOGIN,  F_EDITARLOGIN);
                F_EDITARLOGIN.ShowModal;
                FreeAndNil(F_EDITARLOGIN);
                Close;
            end else if ( acessoBackupBanco )then
            begin
                Application.CreateForm(TF_BACKUPBANCO,  F_BACKUPBANCO);
                F_BACKUPBANCO.ShowModal;
                FreeAndNil(F_BACKUPBANCO);
                Close;    
            end;

      end else
      begin
              if Tentativas <= 1 then
              begin
                  Application.MessageBox('Senha Incorreta!', 'Erro de Autenticação!',
                                         MB_OK + MB_ICONWARNING);
                  edt_Senha.Clear;
                  edt_Senha.SetFocus;
                  btn_Entrar.Enabled:= False;
                  Inc(Tentativas);

              end else if Tentativas = 2 then
              begin

                 Application.MessageBox('Desculpe você não tem permissão para esse tipo de operação!', 'Usuário sem permissão!',
                                        MB_OK + MB_ICONWARNING);
                 Tentativas:= 0;
                 close;

              end;
      end;

end;


procedure TF_LOGINDEACESSOS.edt_SenhaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
       if key = 13 then
       begin
           Autenticar;

       end;   
end;


end.

