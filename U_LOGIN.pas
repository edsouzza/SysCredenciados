unit U_LOGIN;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, Mask, DBCtrls,
  Menus, ImgList, IniFiles;

type
  TF_LOGIN = class(TForm)
    pnl_cabecalho: TPanel;
    pnl_rodape: TPanel;
    pnl_EscolhaUsuario: TPanel;
    btn_Entrar: TSpeedButton;
    btn_Sair: TSpeedButton;
    btn_GravarNovaSenha: TSpeedButton;
    lblHoraAtual: TLabel;
    lblDataDoDia: TLabel;
    GroupBox1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    edt_Senha: TEdit;
    btnGravar: TSpeedButton;
    edt_novasenha: TEdit;
    Label1: TLabel;
    edt_NomeUsuario: TEdit;
    lblUsuario: TStaticText;
    cmbDefineConexao: TComboBox;
    menuConexao: TPopupMenu;
    EscolherTipoConexao: TMenuItem;

    //funcoes personalizadas
    procedure AbrirTabelas;
    procedure FecharTabelas;
    procedure Autenticar;
    procedure FecharAbrirTabelas;
    procedure AutenticarSenhaAntiga;
    procedure Criptografar;
    procedure CriptografarNovaSenha;
    procedure CriptografarSenhaInicial;
    procedure Decriptografar(senha : string);
    procedure ExecutarConfiguracaoInicial;
    procedure GravarConfiguracaoInicial;
    procedure EscolherBancoParaConexao;
    procedure IdentificarIDUsuarioLogado;
    procedure AlterarSenha;
    procedure VerificarSeCadastroInicial;
    procedure MostrarSenhaAdmin;
    procedure ExcluirArqConn;


    //procedimentos padrões
    procedure btn_SairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edt_NovaSenhaChange(Sender: TObject);
    procedure btn_GravarNovaSenhaClick(Sender: TObject);
    procedure btn_EntrarClick(Sender: TObject);
    procedure edt_NovaSenhaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btn_CancelarClick(Sender: TObject);
    procedure btnSairLogoffClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure edt_SenhaKeyPress(Sender: TObject; var Key: Char);
    procedure edt_SenhaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edt_SenhaEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edt_NomeUsuarioKeyPress(Sender: TObject; var Key: Char);
    procedure cmbDefineConexaoClick(Sender: TObject);
    procedure EscolherTipoConexaoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt_SenhaExit(Sender: TObject);
    procedure edt_NomeUsuarioClick(Sender: TObject);

  private

    { Private declarations }
     senhaDoBanco, senhaDigitada, senhaCriptografada, senhaDecriptografada,
     senhaInicialCriptografada, novaSenhaCriptografada, nomeBanco, comecoIPLOCAL   : string;

  public
    { Public declarations }
      Tentativas : Integer;
      Arquivo    : TIniFile;
      IPLocal    : string;
      flag       : integer;

  end;

var
  F_LOGIN: TF_LOGIN;
  const chave = 7;



implementation

uses U_BIBLIOTECA, U_DM, SqlExpr, U_DMPESQ, U_PRINCIPAL, DB, U_EDITARLOGIN, U_SENHAS, U_LoginDeAcessos;
var
 s: string[255];
 c: array[0..255] of Byte absolute s;
 formacoes: array[1..4] of String = ('ENGENHEIRO AMBIENTAL','ENGENHEIRO CIVIL','ARQUITETO','CONTADOR');
 usuarios: array[1..3] of String = ('ADMINISTRADOR','USUARIO','D631863');
 tiposacesso: array[1..4] of String = ('SISTEMA','ADMINISTRADOR','USUARIO','AVANCADO');

{$R *.dfm}

procedure TF_LOGIN.FormCreate(Sender: TObject);
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

   ExcluirArqConn;
   AbrirTabelas;
   ExecutarConfiguracaoInicial;

end;

procedure TF_LOGIN.AbrirTabelas;
begin
    DM.CDS_USUARIOS.Active  := True;

end;

procedure TF_LOGIN.FecharTabelas;
begin
   DM.CDS_USUARIOS.Active  := False;

end;


procedure TF_LOGIN.ExcluirArqConn;
var
  pathArquivo: string;
begin

  //Sempre que abrir o sistema vai excluir o arquivo de configuração e recria-lo em procedure TDM.LerCaminhoDoBanco que encontra-se no U_DM nosso dataModule
  pathArquivo := (ExtractFilePath(Application.ExeName)+'Config.ini');
  //ShowMessage(pathArquivo);

  if FileExists(pathArquivo) then
      DeleteFile(pathArquivo);

end;


procedure TF_LOGIN.cmbDefineConexaoClick(Sender: TObject);
begin

    EscolherBancoParaConexao;

end;

procedure TF_LOGIN.EscolherBancoParaConexao;
begin

      //se o começo do ipLocal = '10.' significa que estou na PGM aceita config mas se for diferente significa que estou em casa barrar a config
      IPServidor         := '10.71.32.39';      //IP DA ESTAÇÃO SERVIDOR SNJPGMC53
      comecoIPLOCAL      := copy(GetIPLocal,1,5);

      if ( cmbDefineConexao.Text = 'BANCO : SERVIDOR' ) then
      begin
            //10.71.32.39
            if(comecoIPLOCAL <> '10.71.')then
            begin

                Application.MessageBox('Atenção você setou uma conexão com o servidor inválida!','Configuração inválida...',MB_ICONEXCLAMATION);
                cmbDefineConexao.ItemIndex:= -1;
                exit;
            end else
            begin

               //nesse linha a aplicação cria o arquivo no diretorio dela mesma, se o mesmo existir substitui pelo atual
               Arquivo := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Config.ini');

               //na linha seguinte escreve no arquivo o caminho do banco de dados dentro do arquivo .ini com o IPLocal setado
               Arquivo.WriteString('caminho_do_banco','DATABASE',IPServidor+':C:\meus documentos\bancos_de_projetos\CredPeritos\CREDPERITOS.fdb');
               ipLogado         := IPServidor;
               bancoDadosSetado := Arquivo.ReadString('caminho_do_banco','DATABASE','');
               nomeBanco        := CopyReverse(bancoDadosSetado, 1, 15);

            end;

      end else  if ( cmbDefineConexao.Text = 'BANCO : DESENVOLVIMENTO' ) then   //IP LOCAL DA ESTAÇÃO SNJPGMC59 OU EDSOF1 EM CASA - DESENVOLVIMENTO CREDDESENV
      begin
           IPLocal := GetIPLocal;

           //nesse linha a aplicação cria o arquivo no diretorio dela mesma, se o mesmo existir substitui pelo atual
           Arquivo := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Config.ini');

          //na linha seguinte escreve no arquivo o caminho do banco de dados dentro do arquivo .ini
          Arquivo.WriteString('caminho_do_banco','DATABASE',IPLocal+':C:\meus documentos\bancos_de_projetos\CredPeritos\CREDDESENV.fdb');
          ipLogado         := GetIPLocal;
          bancoDadosSetado := Arquivo.ReadString('caminho_do_banco','DATABASE','');
          nomeBanco        := CopyReverse(bancoDadosSetado, 1, 13);

      end else  if ( cmbDefineConexao.Text = 'BANCO : CREDPERITOS' ) then   //IP DA ESTAÇÃO EDSOF1 - DESENVOLVIMENTO    192.168.0.108
      begin
           IPLocal := GetIPLocal;

           //nesse linha a aplicação cria o arquivo no diretorio dela mesma, se o mesmo existir substitui pelo atual
           Arquivo := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Config.ini');

          //na linha seguinte escreve no arquivo o caminho do banco de dados dentro do arquivo .ini
          Arquivo.WriteString('caminho_do_banco','DATABASE',IPLocal+':C:\meus documentos\bancos_de_projetos\CredPeritos\CREDPERITOS.fdb');
          ipLogado         := GetIPLocal;
          bancoDadosSetado := Arquivo.ReadString('caminho_do_banco','DATABASE','');
          nomeBanco        := CopyReverse(bancoDadosSetado, 1, 15);

      end;

          //ShowMessage('IP LOCAL : '+ipLogado);
          cmbDefineConexao.Visible := false;
          Application.MessageBox('CredDesenv setado com sucesso, continue com seu login!', 'Alterando configurações!', MB_OK + MB_ICONASTERISK);
          //Application.Terminate;

end;

procedure TF_LOGIN.FecharAbrirTabelas;
begin
    DM.CDS_USUARIOS.Active  := False;
    DM.CDS_USUARIOS.Active  := True;

end;

procedure TF_LOGIN.btn_SairClick(Sender: TObject);
begin
    //ShowMessage(BoolToStr(logado));
    //0 = false  / -1 = true - se estiver logado e na tela principal -> fechar o login caso contrario terminar a aplicação

    if not(logado) then
    begin
      Application.Terminate;
    end else begin
       close;
    end;

end;

procedure TF_LOGIN.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    FecharTabelas;
    Action  := caFree;
    F_LOGIN := nil;
    FreeAndNil(Arquivo);
    Release;

end;

procedure TF_LOGIN.FormKeyPress(Sender: TObject; var Key: Char);
begin
  // Enter por Tab
  //verifica se a tecla pressionada é a tecla ENTER, conhecida pelo Delphi como #13
  If key = #13 then
  Begin

    //se for, passa o foco para o próximo campo, zerando o valor da variável Key
    Key:= #0;
    Perform(Wm_NextDlgCtl,0,0);

  end;
end;


procedure TF_LOGIN.edt_NovaSenhaChange(Sender: TObject);
begin
      btnGravar.Enabled            := True;
      btn_Entrar.Enabled           := False;
      btn_Sair.Enabled             := true;
      btn_GravarNovaSenha.Enabled  := false;

end;

procedure TF_LOGIN.Criptografar;
var
  i:Integer;
begin
  {encode}
  s := edt_Senha.text;
  For i:=1 to ord(s[0]) do
    c[i] := 23 Xor c[i];
    senhaCriptografada := s;

end;

procedure TF_LOGIN.CriptografarSenhaInicial;
var
  i:Integer;
begin
  {encode}
  s := 'pgminfo';
  For i:=1 to ord(s[0]) do
    c[i] := 23 Xor c[i];
    senhaInicialCriptografada := s;

end;

procedure TF_LOGIN.CriptografarNovaSenha;
var
  i:Integer;
begin
  {encode}
  s := edt_novasenha.text;

  For i:=1 to ord(s[0]) do
    c[i] := 23 Xor c[i];
    novaSenhaCriptografada := s;

end;

procedure TF_LOGIN.Decriptografar(senha : string);
var
  i:Integer;
begin
  {Decode}
  s := senha;
  For i:=1 to Length(s) do
    s[i] := char(23 Xor ord(c[i]));
    senhaDecriptografada  :=s;

end;

procedure TF_LOGIN.btn_GravarNovaSenhaClick(Sender: TObject);
begin
    AutenticarSenhaAntiga;

end;

procedure TF_LOGIN.IdentificarIDUsuarioLogado;
begin
      //verifica se digitou a letra 'D' no inicio do RF dentro do DBEdit4
      letraD := copy(edt_NomeUsuario.Text,0,1);

      //verifica se digitou os sete caracteres do RF
      if not(DigitouRFCompleto(edt_NomeUsuario.Text)) then
      begin
         Application.MessageBox('Favor digitar o RF corretamente ex: D123456', 'RF inválido!', MB_ICONWARNING);
         edt_NomeUsuario.SetFocus;
      end else begin
          //verifica se o usuario existe atraves do login digitado passando seu ID para variavel IdDoUsuarioLogado
          with DMPESQ.QRY_GERAL do
          begin
              close;
              sql.Clear;
              sql.Add('SELECT * FROM tbl_usuarios WHERE login=:pLogin');
              Params.ParamByName('pLogin').AsString := edt_NomeUsuario.Text;        // campo que recebe o RF
              open;

              if not IsEmpty then
              begin
                 IdDoUsuarioLogado   :=  DMPESQ.QRY_GERAL.FieldbyName('id_usuario').AsInteger;
                 NomeDoUsuarioLogado :=  DMPESQ.QRY_GERAL.FieldbyName('nome').AsString;
                 senhaDoBanco        :=  DMPESQ.QRY_GERAL.FieldByName('senha').AsString;
              end else
              begin
                  if ( Tentativas <= 1 )then
                      begin
                          Application.MessageBox('Usuário não encontrado, entre como por ex: D123456', 'Tente novamente!', MB_OK + MB_ICONWARNING);
                          edt_NomeUsuario.SetFocus;
                          Inc(Tentativas);

                      end else if ( Tentativas = 2 ) then
                      begin

                         Application.MessageBox('Desculpe você não tem permissão para acessar o Sistema!', 'Usuário sem permissão!',
                         MB_OK + MB_ICONWARNING);
                         Tentativas:= 0;
                         Application.Terminate;
                      end;
              end;
          end;
      end;
end;

procedure TF_LOGIN.AutenticarSenhaAntiga;
begin
           IdentificarIDUsuarioLogado;
           Criptografar;    //obtem a senhaCriptografada

           if (  senhaCriptografada = senhaDoBanco ) then
           begin
                edt_NovaSenha.Enabled       := true;
                btn_Entrar.Enabled          := False;
                btn_GravarNovaSenha.Enabled := false;
                edt_NomeUsuario.Enabled     := false;
                edt_Senha.Enabled           := false;
                edt_NovaSenha.SetFocus;

                Application.MessageBox('Entre com a nova senha para continuar!', 'Alterando senha de entrada!',
                MB_OK + MB_ICONINFORMATION);

           end else begin

                 if ( Tentativas <= 1 )then
                  begin
                      Application.MessageBox('Senha atual incorreta, tente novamente!', 'Erro de Autenticação!',
                      MB_OK + MB_ICONWARNING);

                      edt_Senha.Clear;
                      btn_Entrar.Enabled          := False;
                      btn_GravarNovaSenha.Enabled := false;
                      edt_Senha.SetFocus;
                      Inc(Tentativas);

                  end else if ( Tentativas = 2 ) then
                  begin

                     Application.MessageBox('Desculpe você não tem permissão para acessar o Sistema!', 'Usuário sem permissão!',
                     MB_OK + MB_ICONWARNING);
                     LogOperacoes(NomeDoUsuarioLogado, 'erro de senha em tres tentativas');
                     Tentativas:= 0;
                     Application.Terminate;

                  end;
            end;
end;


procedure TF_LOGIN.edt_SenhaEnter(Sender: TObject);
begin

    IdentificarIDUsuarioLogado;
    VerificarSeCadastroInicial;

end;

procedure TF_LOGIN.VerificarSeCadastroInicial;
begin
     //verifica se a senha do usuario foi reiniciada ou se o cadastro é inicial se positivo informar que deve alterar a senha agora   
      with DMPESQ.QRY_GERAL do
      begin
          close;
          sql.Clear;
          sql.Add('SELECT * FROM tbl_usuarios WHERE login=:login AND senha=:senha');
          Params.ParamByName('login').AsString := edt_NomeUsuario.Text;      //RF
          Params.ParamByName('senha').AsString := 'gpz~yqx';                 //pgminfo
          open;

          if not IsEmpty then
          begin
             edt_Senha.Text          := 'pgminfo';                           //setando como senha anterior
             edt_Senha.Enabled       := false;
             edt_NomeUsuario.Enabled := false;
             edt_novasenha.Enabled   := true;
             edt_novasenha.SetFocus;
             Application.MessageBox('Senha reiniciada, favor alterá-la!', 'Alterção de senha de acesso!', MB_OK + MB_ICONWARNING);
             
          end;

      end;

end;

procedure TF_LOGIN.AlterarSenha;
var
  novasenha : string;
begin
    CriptografarNovaSenha;             //pega a nova senha digitada no edt_novasenha e retorna novaSenhaCriptografada
    novasenha  := novaSenhaCriptografada;

    with DMPESQ.QRY_GERAL do
    begin
        Close;
        SQL.Clear;
        SQL.add('Update tbl_usuarios SET senha = :pSenha WHERE id_usuario = :pIDUsuario');
        ParamByName('pSenha').AsString      := novasenha;
        ParamByName('pIDUsuario').AsInteger := IdDoUsuarioLogado;
        ExecSQL;

    end;

    Application.MessageBox('Senha alterada com sucesso!', 'Alteração de senha!', MB_OK);
    LogOperacoes(NomeDoUsuarioLogado, 'alteração de senha');
    edt_Senha.Enabled            := true;
    edt_Senha.Clear;
    edt_Senha.SetFocus;
    edt_novasenha.Clear;
    btn_Entrar.Enabled           := False;
    btnGravar.Enabled            := False;
    btn_GravarNovaSenha.Enabled  := False;
    edt_novasenha.Enabled        := False;
    IdentificarIDUsuarioLogado;  //identifica novamente para fazer o login sem reiniciar o sistema
    Tentativas := 0;

end;

procedure TF_LOGIN.btnGravarClick(Sender: TObject);
begin
   //gravar nova senha no banco
   AlterarSenha;
   btn_GravarNovaSenha.Enabled := false;

end;


procedure TF_LOGIN.btn_EntrarClick(Sender: TObject);
begin

   Criptografar;

   if ( edt_NomeUsuario.Text = '' ) OR (edt_Senha.Text = '') then
   begin
        Application.MessageBox('Usuário ou Senha não digitados!', 'Erro de Autenticação!',
                  MB_OK + MB_ICONWARNING);
        exit;

   end else begin

     Autenticar;

   end;

end;


procedure TF_LOGIN.Autenticar;
begin    
      //senha de cadastro inicial ( gpz~yqx = pgminfo ) no banco de dados  
      btn_Entrar.Enabled  := False;
      with DM.QRY_GERAL do
      begin
          close;
          sql.Clear;
          sql.Add('SELECT u.*, t.* FROM tbl_usuarios u, tbl_tiposacesso t WHERE u.login=:login AND u.senha=:senha AND u.nivelacesso=t.id_tiposacesso');
          Params.ParamByName('login').AsString   := edt_NomeUsuario.Text;
          Params.ParamByName('senha').AsString   := senhaCriptografada;
          open;

          if not IsEmpty then
          begin
             senhaDoBanco          :=  DM.QRY_GERAL.FieldByName('senha').AsString;
             IdDoUsuarioLogado     :=  DM.QRY_GERAL.FieldByName('id_usuario').AsInteger;
             nivelDeAcesso         :=  DM.QRY_GERAL.FieldByName('nivelacesso').AsInteger;
             tipoAcesso            :=  DM.QRY_GERAL.FieldByName('tipoacesso').AsString;
             loginAcessado         :=  DM.QRY_GERAL.FieldByName('login').AsString;
             NomeDoUsuarioLogado   :=  DM.QRY_GERAL.FieldByName('nome').AsString;

          end;

           senhaDigitada := senhaCriptografada;

           if (  senhaDigitada = senhaDoBanco ) then
           begin
                 if (logado) then LogOperacoes(NomeDoUsuarioLogado, 'acesso ao sistema atraves do logoff');

                 Application.CreateForm(TF_Principal,  F_Principal);
                 F_Principal.ShowModal;
                 FreeAndNil(F_Principal);
                 Close;

           end  else
           begin
              if Tentativas <= 1 then
              begin
                  Application.MessageBox('Usuário ou Senha inválidos!', 'Erro de Autenticação!',
                  MB_OK + MB_ICONWARNING);

                  edt_Senha.Clear;
                  edt_Senha.SetFocus;
                  btn_Entrar.Enabled          := False;
                  btn_GravarNovaSenha.Enabled := False;

                  Inc(Tentativas);

              end else if Tentativas = 2 then
              begin
                 Application.MessageBox('Desculpe você não tem permissão para acessar o Sistema!', 'Usuário sem permissão!',
                 MB_OK + MB_ICONWARNING);
                 LogOperacoes(NomeDoUsuarioLogado, 'acesso ao Sistema negado por 3 tentativas erradas');
                 Tentativas:= 0;
                 Application.Terminate;

              end;

           end;
       end;
end;


procedure TF_LOGIN.edt_NovaSenhaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      if Key = VK_RETURN then
      begin
           btnGravarClick(self);

      end;
end;


procedure TF_LOGIN.btn_CancelarClick(Sender: TObject);
begin
    Application.Terminate;

end;


procedure TF_LOGIN.btnSairLogoffClick(Sender: TObject);
begin
    close;

end;

procedure TF_LOGIN.edt_SenhaKeyPress(Sender: TObject; var Key: Char);
begin
     btn_GravarNovaSenha.Enabled := true;
     btn_Entrar.Enabled          := true;

end;

procedure TF_LOGIN.edt_SenhaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if key=13 then
     begin
         btn_EntrarClick(self);

     end;
end;

procedure TF_LOGIN.ExecutarConfiguracaoInicial;
var
   qdeusers : integer;
begin
      //Verificar se o usuario id 1 SISTEMA existe, se nao existir faz toda a configuração inicial   
      qdeusers :=  retornaQuantidadeRegsTabela('ID_USUARIO','TBL_USUARIOS') ;
      //ShowMessage(IntToStr(qdeusers));

      if(qdeusers < 1)then
      begin
        GravarConfiguracaoInicial;
      end;

end;

procedure TF_LOGIN.GravarConfiguracaoInicial;
var i : integer;    
begin
       CriptografarSenhaInicial;
       //GRAVANDO O USUARIO SISTEMA NA TBL_USUARIOS => D631863

       DM.CDS_USUARIOS.Active := TRUE;
       with  DM.CDS_USUARIOS do
       begin
              Append;
              FieldByName('id_usuario').AsInteger     := 1;
              FieldByName('nome').AsString            := 'ADMINISTRADOR';
              FieldByName('login').AsString           := 'D631863';
              FieldByName('senha').AsString           := senhaInicialCriptografada;
              FieldByName('nivelacesso').AsInteger    := 1;
              FieldByName('orgao').AsString           := 'PGM/CGGM';
              FieldByName('cadastrante').AsString     := 'ADMINISTRADOR';
              FieldByName('datacad').AsString         := DateToStr(now);
              FieldByName('status').AsString          := 'ATIVO';
              ApplyUpdates(0);
       end;

    //=======================================================================================

       //GRAVANDO OS TIPOS DE FORMAÇÕES NA TBL_TIPO =>ENGENHEIRO AMBIENTAL','ENGENHEIRO CIVIL','ARQUITETO','CONTADOR

       DM.CDS_TIPO.Active := TRUE;
       with DM.CDS_TIPO do
       begin
            for i := 1 to 4 do
            begin
              Append;
              FieldByName('id_tipo').AsInteger     := i;
              FieldByName('tipo').AsString         := formacoes[i];
              ApplyUpdates(0);

            end;
       end;

   //=======================================================================================

    //GRAVANDO OS TIPOS DE ACESSOS TBL_TIPOSACESSO =>1-SISTEMA, 2-ADMINISTRADOR, 3-USUARIO, 4-AVANCADO

       DM.CDS_TIPOSACESSO.Active := TRUE;
       with DM.CDS_TIPOSACESSO do
       begin
            for i := 1 to 4 do
            begin
              Append;
              FieldByName('id_tiposacesso').AsInteger  := i;
              FieldByName('tipoacesso').AsString       := tiposacesso[i];
              ApplyUpdates(0);

            end;

       end;

   //=======================================================================================


     //GRAVANDO O PRIMEIRO LOG NA TABELA LOG_OPERACOES         'SISTEMA INICIALIZADO COM SUCESSO';

       DM.CDS_LOGOPERACOES.Active := TRUE;
       with DM.CDS_LOGOPERACOES do
       begin
              Append;
              FieldByName('id_operacao').AsInteger  := 0;
              FieldByName('ocorrencia').AsString    := 'SISTEMA INICIALIZADO COM SUCESSO';
              FieldByName('data').AsDateTime        := date;
              ApplyUpdates(0);   

       end;

   //=======================================================================================


   Application.MessageBox('Configurações iniciais executadas com sucesso!',
               'Seja bem vindo!', MB_OK + MB_ICONASTERISK);

   FecharAbrirTabelas;

end;  


procedure TF_LOGIN.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

    If(KEY=VK_F1)then
    begin
         //esse código faz com que ao digitar o RF e clicar em F1 a senha do EDI fique alternando entre visível ou não
         //ShowMessage('valor flag : '+IntToStr(flag));
         if (flag = 0)then
         begin

                   if(edt_NomeUsuario.Text = '')then
                   begin
                        Application.MessageBox('Primeiro digite seu RF!',
                         'RF inválido!', MB_OK + MB_ICONEXCLAMATION);
                   end else
                   begin
                        MostrarSenhaAdmin;
                        flag := flag + 1;
                        //ShowMessage('valor flag : '+IntToStr(flag));
                   end;

         end else if (flag = 1)then
         begin

            lblUsuario.Visible := false;
            flag := 0;
         end;

    end;


    if(KEY=VK_F2)then
    begin 

         AcessarEdicaoLogin := true;
         Application.CreateForm(TF_LOGINDEACESSOS,  F_LOGINDEACESSOS);
         F_LOGINDEACESSOS.ShowModal;
         FreeAndNil(F_LOGINDEACESSOS);

    end;

end;

procedure TF_LOGIN.edt_NomeUsuarioKeyPress(Sender: TObject; var Key: Char);
begin
//aceita apenas numeros e a letra D
if not (Key in['0'..'9','D','d','E','e','X','x',Chr(8)]) then Key:= #0;
end;

procedure TF_LOGIN.EscolherTipoConexaoClick(Sender: TObject);
begin
  cmbDefineConexao.Visible := true;
end;

procedure TF_LOGIN.FormShow(Sender: TObject);
begin

     F_LOGIN.Caption := 'Controle de Credenciados - ' +getNomeBancoSetado+ ' - '+GetIPLocal+'';

end;

procedure TF_LOGIN.MostrarSenhaAdmin;
var
   senhaAtualBanco, usuario : string;
begin

    usuario         := edt_NomeUsuario.Text;
    senhaAtualBanco := RetornaValorBanco('tbl_usuarios','senha','login',usuario);

    if ( (senhaAtualBanco <> '') and (usuario = 'D631863') )then
    begin
        lblUsuario.Visible      := true;
        Decriptografar(senhaAtualBanco);
        lblUsuario.Caption    := 'Senha atual : '+senhaDecriptografada;
    end;

end;


procedure TF_LOGIN.edt_SenhaExit(Sender: TObject);
begin
  lblUsuario.Visible      := false;
end;

procedure TF_LOGIN.edt_NomeUsuarioClick(Sender: TObject);
begin
   edt_NomeUsuario.SelectAll;
end;

end.
