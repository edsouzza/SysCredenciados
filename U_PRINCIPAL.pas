unit U_PRINCIPAL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ImgList, ExtCtrls, ComCtrls, Buttons, IdBaseComponent,
  IdComponent, IdIPWatch, StdCtrls, IniFiles, Printers;

type
  TF_PRINCIPAL = class(TForm)
    menuPrincipal: TMainMenu;
    MnuCadastros: TMenuItem;
    MenTipoCredenciados: TMenuItem;
    lista_imagens: TImageList;
    BarraStatus: TStatusBar;
    Timer1: TTimer;
    GerenciarCandidatos: TMenuItem;
    Panel2: TPanel;
    btnCandidatos: TSpeedButton;
    btnConsultar: TSpeedButton;
    btnSairDoSistema: TSpeedButton;
    mnuConsultas: TMenuItem;
    Consultar: TMenuItem;
    mnuLogOperacoes: TMenuItem;
    mnuSuporte: TMenuItem;
    OpenDialog1: TOpenDialog;
    ImagemPMSP: TImage;
    mnuConfiguracoes: TMenuItem;
    DoBackup: TMenuItem;
    DaSenhas1: TMenuItem;
    mnuUsuarios: TMenuItem;
    btnUsuarios: TSpeedButton;
    mnuReativarUsuario: TMenuItem;
    lblBoasVindas: TLabel;
    mnuCadUsuarios: TMenuItem;
    mnuEditarUsuarios: TMenuItem;
    mnuRelatrios: TMenuItem;
    mnuRelUsuarios: TMenuItem;
    mnuRelCredenciados: TMenuItem;
    mnuARQUITETO: TMenuItem;
    mnuCONTADORES: TMenuItem;
    mnuENGENHEIROSCIVIS: TMenuItem;
    mnuENGENHEIROSAMBIENTAIS: TMenuItem;
    mnuCriarNovaTabela: TMenuItem;
    mnuReativarCredenciado: TMenuItem;
    menuIPdoServidor: TMenuItem;
    ConsultarPorProcesso: TMenuItem;
    menuTiposdeAcesso: TMenuItem;
    Loggof: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MenTipoCredenciadosClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure GerenciarCandidatosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSairDoSistemaClick(Sender: TObject);
    procedure btnCandidatosClick(Sender: TObject);
    procedure btnTiposClick(Sender: TObject);
    procedure ControlarResolucao;
    procedure VerificarPermissoes;
    procedure LimparPastaDeBackup;
    procedure GerarLogBackup(acesso: string);
    procedure ExecutarBackup;
    procedure LiberarAcessoBackup;
    procedure btnConsultarClick(Sender: TObject);
    procedure ConsultarClick(Sender: TObject);
    procedure mnuLogOperacoesClick(Sender: TObject);
    procedure mnuSuporteClick(Sender: TObject);
    procedure DoBackupClick(Sender: TObject);
    procedure DaSenhas1Click(Sender: TObject);
    procedure btnUsuariosClick(Sender: TObject);
    procedure mnuReativarUsuarioClick(Sender: TObject);
    procedure VerificaSeTemInativados;
    procedure MsgBoasVindas;
    procedure CriandoNovaTabela;
    procedure mnuCadUsuariosClick(Sender: TObject);
    procedure mnuEditarUsuariosClick(Sender: TObject);
    procedure mnuRelUsuariosClick(Sender: TObject);
    procedure mnuARQUITETOClick(Sender: TObject);
    procedure mnuCONTADORESClick(Sender: TObject);
    procedure mnuENGENHEIROSCIVISClick(Sender: TObject);
    procedure mnuENGENHEIROSAMBIENTAISClick(Sender: TObject);
    procedure mnuCriarNovaTabelaClick(Sender: TObject);
    procedure mnuReativarCredenciadoClick(Sender: TObject);
    procedure menuIPdoServidorClick(Sender: TObject);
    procedure ConsultarPorProcessoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure menuTiposdeAcessoClick(Sender: TObject);
    procedure LoggofClick(Sender: TObject);

    //function  getNomeBanco:string;


  private
    { Private declarations }
    lblHora  : TLabel;


  public
    { Public declarations }
    procedure criarCredDesenv;
  end;

var
  F_PRINCIPAL: TF_PRINCIPAL;


implementation

uses U_CADTIPO, U_DM, U_BIBLIOTECA, U_DMPESQ, U_LogOperacoes, USobre, U_LOGIN,
  U_ESCOLHATIPODEFORMACAO, U_ESCOLHATIPODEFORMACAOCAD, U_BackupBancoDados, U_Senhas,
  U_LoginDeAcessos, U_CADUSUARIOS, U_REATIVARUSUARIO, U_EDITARLOGIN, DB,
  U_ESCOLHATIPODERELATORIO, U_RELUSUARIOS, SqlExpr,
  U_ESCOLHATIPOFORMACAOREATIVAR, U_MOSTRAIPSERVIDOR, U_CONSPORPROCESSOS,
  U_CADTIPOACESSO;

{$R *.dfm}

procedure TF_PRINCIPAL.ControlarResolucao;
var
  XW, xH :double;
begin

     //controla a resolu��o do video
     XW := (((Screen.Width)  / 100) * 100);
     XH := (((Screen.Height) / 100) * 100);

     Self.Width  := Round(XW);
     Self.Height := Round(xH);

     F_PRINCIPAL.Position := poScreenCenter;

end;

procedure TF_PRINCIPAL.FormCreate(Sender: TObject);
//DESABILITA O BOTAO FECHAR DO FORMUL�RIO
var
  hwndHandle : THANDLE;
  hMenuHandle : HMenu;
begin
//Impede movimenta��o do formul�rio
 DeleteMenu(GetSystemMenu(Handle, False), SC_MOVE, MF_BYCOMMAND);

  hwndHandle := Self.Handle;
  if (hwndHandle <> 0) then
    begin
      hMenuHandle := GetSystemMenu(hwndHandle, FALSE);
        if (hMenuHandle <> 0) then
          DeleteMenu(hMenuHandle, SC_CLOSE, MF_BYCOMMAND);

  end;
  
end;

procedure TF_PRINCIPAL.FormShow(Sender: TObject);
begin
     VerificarPermissoes;
     F_PRINCIPAL.Caption := 'Controle de Credenciados - '+getNomeBancoSetado ;
     
end;

procedure TF_PRINCIPAL.MsgBoasVindas;
begin
      //criando o label em tempo de execu��o
      Timer1.Enabled := true;
      
      lblHora := TLabel.Create(self);
      with lblHora do
      begin
        Parent := F_PRINCIPAL;
        Left := 10;
        Top := 50;
        Caption := TimeToStr(time);
      end;

     if  (lblHora.Caption <= '12:00:00') then
     begin

           lblBoasVindas.Caption := 'Bom Dia : '+PrimeirasLetrasMaiusculas(NomeDoUsuarioLogado);

     end
     else if  (lblHora.Caption >= '12:00:00') and (lblHora.Caption < '18:00:00') then
     begin

          lblBoasVindas.Caption  := 'Boa Tarde : '+PrimeirasLetrasMaiusculas(NomeDoUsuarioLogado);

     end
     else if  (lblHora.Caption > '18:00:00') then
     begin

          lblBoasVindas.Caption  := 'Bom Noite : '+PrimeirasLetrasMaiusculas(NomeDoUsuarioLogado);

     end;

     FreeAndNil(lblHora);  //destruindo o objeto criado
     logado := true;

end;


procedure TF_PRINCIPAL.Timer1Timer(Sender: TObject);
begin

      barrastatus.Panels[0].Text:= ' Desenvolvido por Edi Aquino de Souza - EdSof';
      barrastatus.Panels[1].Text:= ' Logado : '+ loginAcessado+' - '+tipoAcesso;
      barrastatus.Panels[2].Text:= ' Banco  : '+ nomeBanco;
      barrastatus.Panels[3].Text:= ' Data : ' + DateToStr(date);
      barrastatus.Panels[4].Text:= ' Hora : ' + TimeToStr(time);
      barrastatus.Panels[5].Text:= ' Procuradoria Geral do Munic�pio';
      barrastatus.Panels[6].Text:= ' Departamento de Inform�tica - CGGM';

      //formata o tamanho do relat�rio
      formatarRelatoriosDisplay100;

end;

procedure TF_Principal.VerificarPermissoes;
begin
        //usuario com nivelacesso = 1 � o SISTEMA somente para D631863 / nivel 2 s�o os administradores do SISTEMA
        // nivel acima de 2 apenas consultas      =>     1 SISTEMA    2 ADMINISTRADOR    3 USUARIO    4 AVANCADO

        if ( nivelDeAcesso = 2 ) then          //  => 2 ADMINISTRADORE QUE NAO CADASTRAM PERITOS
        begin
              mnuConfiguracoes.Visible        := false;
              MenTipoCredenciados.Visible     := false;
              mnuEditarUsuarios.Visible       := false;
              mnuReativarCredenciado.Visible  := false;
              MnuCadastros.Visible            := false;
              menuIPdoServidor.Visible        := false;
              menuIPdoServidor.Visible        := false;
              btnUsuarios.Visible             := false;
              btnCandidatos.Visible           := false;
              menuTiposdeAcesso.Visible       := false;
              btnConsultar.Left               := 2;
              btnSairDoSistema.Left           := 66;

        end;

        if( nivelDeAcesso = 3 ) then          //  => 3 USUARIO
        begin
              mnuReativarCredenciado.Visible  := false;
              mnuRelatrios.Visible            := false;
              mnuConfiguracoes.Visible        := false;
              MnuCadastros.Visible            := false;
              mnuLogOperacoes.Visible         := false;
              mnuUsuarios.Visible             := false;
              btnCandidatos.Visible           := false;
              btnUsuarios.Visible             := false;
              mnuEditarUsuarios.Visible       := false;
              mnuReativarCredenciado.Visible  := false;
              menuTiposdeAcesso.Visible       := false;
              btnConsultar.Left               := 2;
              btnSairDoSistema.Left           := 66;
        end;

        if ( nivelDeAcesso = 4 ) then         //  => 4 AVANCADOS / ADMIISTRADORES QUE PODEM CADASTRAR PERITOS
        begin
              MnuCadastros.Visible            := true;
              MenTipoCredenciados.Visible     := false;
              mnuConfiguracoes.Visible        := false;
              menuTiposdeAcesso.Visible       := false;

        end;

        LogOperacoes(NomeDoUsuarioLogado, 'acesso ao Sistema atraves de senha pessoal');  
        MsgBoasVindas;

end;


procedure TF_PRINCIPAL.MenTipoCredenciadosClick(Sender: TObject);
begin

      btnTiposClick(Self);

end;

procedure TF_PRINCIPAL.GerenciarCandidatosClick(Sender: TObject);
begin

    btnCandidatosClick(Self);

end;

procedure TF_PRINCIPAL.GerarLogBackup(acesso: string);
var
Arq : TextFile;
begin

  AssignFile(Arq, (DM.CDS_BACKUPTXT_DESTINO.Value)+'Log backup.log');
  if not FileExists((DM.CDS_BACKUPTXT_DESTINO.Value)+'Log backup.log') then Rewrite(arq,(DM.CDS_BACKUPTXT_DESTINO.Value)+'Log backup.log');
  Append(arq);
  Writeln(Arq, acesso);
  Writeln(Arq, '');
  CloseFile(Arq);

end;

procedure TF_PRINCIPAL.LimparPastaDeBackup;
var
caminho : string;
SR: TSearchRec;
I: integer;

begin

  //APAGA TODOS OS ARQUIVOS DA PASTA DE BACKUP DEFINIDO NO BANCO DE DADOS

  caminho := DM.CDS_BACKUPTXT_DESTINO.Value + '*.*';

  I := FindFirst(caminho, faAnyFile, SR);

  while I = 0 do
  begin

      if (SR.Attr and faDirectory) <> faDirectory then
       begin

          caminho:= DM.CDS_BACKUPTXT_DESTINO.Value + SR.Name;

          if not DeleteFile(caminho) then
            ShowMessage('Erro ao deletar  ' + caminho);

       end;

      I := FindNext(SR);

   end;

end;

procedure TF_PRINCIPAL.criarCredDesenv;
var origem, destino  : string;
begin

   //este procedimento cria uma c�pia do CREDPERITOS com o nome de CREDDESENV na mesma pasta do CredPeritos

   origem  := 'C:\Meus Documentos\Bancos_De_Projetos\CredPeritos\CREDPERITOS.FDB';
   destino := 'C:\Meus Documentos\Bancos_De_Projetos\CredPeritos\CREDDESENV.FDB';

   //SE CREDDESENV EXISTIR DELETAR PARA SER COPIADO O NOVO ARQUIVO
   if(FileExists(destino))then
      DeleteFile(destino);

   if CopyFile(PChar(origem), PChar(destino), False)then
    begin
     //ShowMessage('Arquivo copiado')
   end else begin
     //ShowMessage('Erro  na  gera��o  da  c�pia  backup [creddesenv], banco  n�o  pode  estar aberto  em  outro  programa!');
     Application.MessageBox('Erro   na    gera��o    do   [ backup   creddesenv ]   banco      esta      sendo      acessado       por     outro     programa!', 'Falha na gera��o da c�pia!',
                 MB_OK + MB_ICONWARNING);
     LogOperacoes(NomeDoUsuarioLogado, 'erro na geracao do backup creddesenv, banco aberto em outro programa!');
   end;

end;  


procedure TF_PRINCIPAL.btnSairDoSistemaClick(Sender: TObject);

begin

   LogOperacoes(NomeDoUsuarioLogado, 'saida do Sistema');
   criarCredDesenv;
   Application.Terminate;
   
end;

procedure TF_PRINCIPAL.ExecutarBackup;
var
SR: TSearchRec;
I: integer;
Origem, Destino: string;

begin

    DM.CDS_BACKUP.Active := true;

    if not( DM.CDS_BACKUP.RecordCount = 0 ) then
    begin

       LimparPastaDeBackup; // PRIMEIRO LIMPA A PASTA E DEPOIS GRAVA O NOVO BACKUP

       I := FindFirst(DM.CDS_BACKUPTXT_ORIGEM.Value + '*.fdb', faAnyFile, SR); // Local de Origem

       while I = 0 do begin

            if (SR.Attr and faDirectory) <> faDirectory then
            begin

              Origem  := DM.CDS_BACKUPTXT_ORIGEM.Value + SR.Name;
              Destino := DM.CDS_BACKUPTXT_DESTINO.Value + SR.Name;

              if not CopyFile(PChar(Origem), PChar(Destino), true) then
              ShowMessage('Erro ao copiar ' + Origem + ' para ' + Destino);

            end;

               I := FindNext(SR);

        end;

        GerarLogBackup('�ltimo backup realizado: '+ DateToStr(date) + ' �s ' + TimeToStr(time) );
        Application.Terminate;
        
     end
     else begin

             texto:= 'Voc� n�o definiu as configura��es do backup! Deseja sair assim mesmo?';

             if Application.MessageBox(PChar(texto),'Aten��o backup sem configura��o...!',MB_YESNO + MB_SYSTEMMODAL) = IdYes then
             begin  

                Application.Terminate;

             end else begin

                 exit;

             end;

     end;

end;


procedure TF_PRINCIPAL.btnCandidatosClick(Sender: TObject);
begin

   if(retornaQuantidadeRegsTabela('ID_USUARIO','TBL_USUARIOS') > 1)then
   begin

     Application.CreateForm(TF_ESCOLHATIPODEFORMACAOCAD,  F_ESCOLHATIPODEFORMACAOCAD);
     F_ESCOLHATIPODEFORMACAOCAD.ShowModal;
     FreeAndNil(F_ESCOLHATIPODEFORMACAOCAD);

   end else begin

         Application.MessageBox('Cadastre os usu�rios do sistema primeiro!', 'Tabela de usu�rios vazia!', MB_OK + MB_ICONWARNING);
         btnUsuariosClick(self);
   end;

end;

procedure TF_PRINCIPAL.btnTiposClick(Sender: TObject);
begin

      Application.CreateForm(TF_CADTIPO,  F_CADTIPO);
      F_CADTIPO.ShowModal;
      FreeAndNil(F_CADTIPO);    

end;

procedure TF_PRINCIPAL.btnConsultarClick(Sender: TObject);
begin

   if  ( (TabelaVazia('TBL_ARQUITETO')) and (TabelaVazia('TBL_CONTADOR')) and (TabelaVazia('TBL_ENGENHEIROAMBIENTAL')) and (TabelaVazia('TBL_ENGENHEIROCIVIL')) )then   
   begin
          Application.MessageBox('Credenciados n�o cadastrados!', 'Tabela de credenciados vazias!', MB_OK + MB_ICONWARNING);
   end else
   begin

      Application.CreateForm(TF_ESCOLHATIPODEFORMACAO,  F_ESCOLHATIPODEFORMACAO);
      F_ESCOLHATIPODEFORMACAO.ShowModal;
      FreeAndNil(F_ESCOLHATIPODEFORMACAO);

   end;

end;

procedure TF_PRINCIPAL.ConsultarClick(Sender: TObject);
begin

    btnConsultarClick(Self);

end;

procedure TF_PRINCIPAL.mnuLogOperacoesClick(Sender: TObject);
begin

      Application.CreateForm(TF_CONSLOGOPERACOES,  F_CONSLOGOPERACOES);
      F_CONSLOGOPERACOES.ShowModal;
      FreeAndNil(F_CONSLOGOPERACOES);

      LogOperacoes(NomeDoUsuarioLogado, 'acesso a consulta de LogOperacoes');

end;

procedure TF_PRINCIPAL.mnuSuporteClick(Sender: TObject);
begin

      Application.CreateForm(TF_SOBRE,  F_SOBRE);
      F_SOBRE.ShowModal;
      FreeAndNil(F_SOBRE);

      LogOperacoes(NomeDoUsuarioLogado, 'acesso a informa��es sobre suporte');

end;

procedure TF_PRINCIPAL.LiberarAcessoBackup;
begin

      if Application.MessageBox('Aten��o qualquer altera��o equivocada nesta tela pode comprometer o desempenho do Sistema deseja continuar?',
        'Aten��o...', MB_YESNO +
            MB_ICONEXCLAMATION) = IDYES then begin

             Application.CreateForm(TF_BACKUPBANCO,  F_BACKUPBANCO);
             F_BACKUPBANCO.ShowModal;
             FreeAndNil(F_BACKUPBANCO);

    end  else begin exit; end;

end;

procedure TF_PRINCIPAL.DoBackupClick(Sender: TObject);
begin
    acessoBackupBanco := true;
    Application.CreateForm(TF_LOGINDEACESSOS,  F_LOGINDEACESSOS);
    F_LOGINDEACESSOS.ShowModal;
    FreeAndNil(F_LOGINDEACESSOS);

end;

procedure TF_PRINCIPAL.DaSenhas1Click(Sender: TObject);
begin  
     AcessarEdicaoLogin:=true;
     Application.CreateForm(TF_LOGINDEACESSOS,  F_LOGINDEACESSOS);
     F_LOGINDEACESSOS.ShowModal;
     FreeAndNil(F_LOGINDEACESSOS);

end;

procedure TF_PRINCIPAL.btnUsuariosClick(Sender: TObject);
begin
      Application.CreateForm(TF_CADUSUARIO,  F_CADUSUARIO);
      F_CADUSUARIO.ShowModal;
      FreeAndNil(F_CADUSUARIO);    

end;

procedure TF_PRINCIPAL.mnuReativarUsuarioClick(Sender: TObject);
begin
   VerificaSeTemInativados;
end;

procedure TF_PRINCIPAL.VerificaSeTemInativados;
begin
  //mostrando apenas os tipos de acesso acessiveis ao cadastro a exce��o do SISTEMA
  DM.CDS_USUARIOS.Close;
  DM.CDS_USUARIOS.CommandText:='SELECT * FROM TBL_USUARIOS WHERE STATUS = '+QuotedStr('INATIVO')+'';
  DM.CDS_USUARIOS.Open;
  if ( DM.CDS_USUARIOS.RecordCount = 0 )then
  begin
      Application.MessageBox('Aten��o no momento n�o h� usu�rios inativados!', 'N�o h� inativados!',
                  MB_OK + MB_ICONWARNING);
      DM.CDS_USUARIOS.Close;
      DM.CDS_USUARIOS.CommandText:='SELECT * FROM TBL_USUARIOS WHERE ID_USUARIO > 1 AND STATUS = '+QuotedStr('ATIVO')+'  ORDER BY NOME';
      DM.CDS_USUARIOS.Open;
      exit;

  end else begin
      Application.CreateForm(TF_REATIVARUSUARIO,  F_REATIVARUSUARIO);
      F_REATIVARUSUARIO.ShowModal;
      FreeAndNil(F_REATIVARUSUARIO);

  end;

end;

procedure TF_PRINCIPAL.mnuCadUsuariosClick(Sender: TObject);
begin
  btnUsuariosClick(self);
end;

procedure TF_PRINCIPAL.mnuEditarUsuariosClick(Sender: TObject);
begin
   With DM.QRY_GERAL do
    begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM TBL_USUARIOS WHERE id_usuario > 1');
          open;

          if IsEmpty then
          begin
               Application.MessageBox('Cadastre os usu�rios do sistema primeiro!', 'Tabela de usu�rios vazia!', MB_OK + MB_ICONWARNING);
               btnUsuariosClick(self);

          end else begin
              Application.CreateForm(TF_EDITARLOGIN,  F_EDITARLOGIN);
              F_EDITARLOGIN.ShowModal;
              FreeAndNil(F_EDITARLOGIN);
          end;
    end;

end;

procedure TF_PRINCIPAL.mnuRelUsuariosClick(Sender: TObject);
begin

     if (temImpressoraPadrao)then
     begin
     
         if(retornaQuantidadeRegsTabela('ID_USUARIO','TBL_USUARIOS') > 1)then
         begin

             Application.CreateForm(TQ_RELUSUARIOS,  Q_RELUSUARIOS);
             Q_RELUSUARIOS.Qry_Usuarios.Active:=true;
             Q_RELUSUARIOS.lblTotal.Caption:= IntToStr(Q_RELUSUARIOS.Qry_Usuarios.RecordCount-1); //excluindo o usu�rio D631863
             Q_RELUSUARIOS.Preview;
             FreeAndNil(Q_RELUSUARIOS);

         end else begin

               Application.MessageBox('Cadastre os usu�rios do sistema primeiro!', 'Tabela de usu�rios vazia!', MB_OK + MB_ICONWARNING);
               btnUsuariosClick(self);
         end;

     end;

end;

procedure TF_PRINCIPAL.mnuARQUITETOClick(Sender: TObject);
begin

    if (temImpressoraPadrao) then
    begin

         if(TabelaVazia('TBL_ARQUITETO')) then
         begin
             Application.MessageBox('Nenhum ARQUITETO cadastrado!',
                 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
             exit;
         end else begin

          nomeTabela     := 'TBL_ARQUITETO';
          nomeDaFormacao := 'ARQUITETOS';
          nomeDocOficial := 'CAU';
          IdTipoFormacao := 3;

         end;

        Application.CreateForm(TF_ESCOLHATIPORELATORIO,  F_ESCOLHATIPORELATORIO);
        F_ESCOLHATIPORELATORIO.ShowModal;
        FreeAndNil(F_ESCOLHATIPORELATORIO);

     end;

end;

procedure TF_PRINCIPAL.mnuCONTADORESClick(Sender: TObject);
begin

    if (temImpressoraPadrao) then
    begin

       if(TabelaVazia('TBL_CONTADOR')) then
       begin
           Application.MessageBox('Nenhum CONTADOR cadastrado!',
               'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
               exit;
       end else begin

          nomeTabela     := 'TBL_CONTADOR';
          nomeDaFormacao := 'CONTADORES';
          nomeDocOficial := 'CRC';
          IdTipoFormacao := 4;

       end;

        Application.CreateForm(TF_ESCOLHATIPORELATORIO,  F_ESCOLHATIPORELATORIO);
        F_ESCOLHATIPORELATORIO.ShowModal;
        FreeAndNil(F_ESCOLHATIPORELATORIO);
    end;

end;

procedure TF_PRINCIPAL.mnuENGENHEIROSCIVISClick(Sender: TObject);
begin

    if (temImpressoraPadrao) then
    begin

           if(TabelaVazia('TBL_ENGENHEIROCIVIL')) then
           begin
               Application.MessageBox('Nenhum ENGENHERIO CIVIL cadastrado!',
                   'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
                   exit;
           end else begin

            nomeTabela     := 'TBL_ENGENHEIROCIVIL';
            nomeDaFormacao := 'ENGENHEIROS CIVIS';
            nomeDocOficial := 'CREA';
            IdTipoFormacao := 2;

           end;

            Application.CreateForm(TF_ESCOLHATIPORELATORIO,  F_ESCOLHATIPORELATORIO);
            F_ESCOLHATIPORELATORIO.ShowModal;
            FreeAndNil(F_ESCOLHATIPORELATORIO);
    end;
end;

procedure TF_PRINCIPAL.mnuENGENHEIROSAMBIENTAISClick(Sender: TObject);
begin


    if (temImpressoraPadrao) then
    begin

       if(TabelaVazia('TBL_ENGENHEIROAMBIENTAL')) then
       begin
           Application.MessageBox('Nenhum ENGENHERIO AMBIENTAL cadastrado!',
               'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
               exit;
       end else begin

        nomeTabela     := 'TBL_ENGENHEIROAMBIENTAL';
        nomeDaFormacao := 'ENGENHEIROS AMBIENTAIS';
        nomeDocOficial := 'CREA';
        IdTipoFormacao := 1;

      end;

      Application.CreateForm(TF_ESCOLHATIPORELATORIO,  F_ESCOLHATIPORELATORIO);
      F_ESCOLHATIPORELATORIO.ShowModal;
      FreeAndNil(F_ESCOLHATIPORELATORIO);

    end;

end;

procedure TF_PRINCIPAL.mnuCriarNovaTabelaClick(Sender: TObject);
begin
   CriandoNovaTabela;
end;

procedure TF_PRINCIPAL.CriandoNovaTabela;
begin
   nomeTabela :='';
   nomeTabela := UpperCase(InputBox('Criando nova tabela no Banco','Entre com o nome da nova tabela',nomeTabela));
   nomeTabela := 'TBL_'+nomeTabela;  
   if(( nomeTabela <> '') and ( nomeTabela <> 'TBL_' ))then
   begin
       CriarNovaFormacao(nomeTabela);
   end else begin
       Application.MessageBox('Opera��o inv�lida, digite um nome para nova tabela!', 'Cancelando cria��o de nova tabela!',
       MB_OK + MB_ICONEXCLAMATION);

   end;
   nomeTabela:='';

end;

procedure TF_PRINCIPAL.mnuReativarCredenciadoClick(Sender: TObject);
begin

      if(TabelaVazia('TBL_INATIVOS'))then
      begin

           Application.MessageBox('N�o foram encontrados credenciados inativados!', 'Tabela de inativados vazia!', MB_OK + MB_ICONWARNING);

      end else begin

        Application.CreateForm(TF_ESCOLHATIPODEFORMACAOREATIVAR,  F_ESCOLHATIPODEFORMACAOREATIVAR);
        F_ESCOLHATIPODEFORMACAOREATIVAR.ShowModal;
        FreeAndNil(F_ESCOLHATIPODEFORMACAOREATIVAR);
        
     end;

end;


procedure TF_PRINCIPAL.menuIPdoServidorClick(Sender: TObject);
begin
      Application.CreateForm(TF_IPSERVIDOR,  F_IPSERVIDOR);
      F_IPSERVIDOR.ShowModal;
      FreeAndNil(F_IPSERVIDOR);
end;

procedure TF_PRINCIPAL.ConsultarPorProcessoClick(Sender: TObject);
begin

   if(TabelaVazia('TBL_PROCESSOS')) then
   begin
       Application.MessageBox('Nenhum Processo cadastrado!',
           'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
       exit;
   end else begin

      Application.CreateForm(TF_CONSPORPROCESSO,  F_CONSPORPROCESSO);
      F_CONSPORPROCESSO.ShowModal;
      FreeAndNil(F_CONSPORPROCESSO);

      LogOperacoes(NomeDoUsuarioLogado, 'acesso a consulta por Processos ou Credenciado');

   end;   

end;

procedure TF_PRINCIPAL.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin  

   Action  := caFree;
   F_PRINCIPAL := nil;
   Release;

end;

procedure TF_PRINCIPAL.menuTiposdeAcessoClick(Sender: TObject);
begin
      Application.CreateForm(TF_CADTIPOACESSO,  F_CADTIPOACESSO);
      F_CADTIPOACESSO.ShowModal;
      FreeAndNil(F_CADTIPOACESSO);

      LogOperacoes(NomeDoUsuarioLogado, 'acesso a consulta de Tipos de Acessos');
end;


procedure TF_PRINCIPAL.LoggofClick(Sender: TObject);
begin
     
     Application.CreateForm(TF_LOGIN,  F_LOGIN);
     F_LOGIN.ShowModal;
     FreeAndNil(F_LOGIN);  

end;

end.
