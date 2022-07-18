unit U_CADUSUARIOS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, Mask, Encryp, DBCtrls,
  Menus, IniFiles, ToolEdit, CurrEdit,DB;

type
  TF_CADUSUARIO = class(TForm)
    pnl_cabecalho: TPanel;
    lblHoraAtual: TLabel;
    lblDataDoDia: TLabel;
    panGridCadCategorias: TPanel;
    gr_CadCategorias: TGroupBox;
    GroupBox14: TGroupBox;
    Label21: TLabel;
    Label22: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    gr_EditarNovo: TGroupBox;
    btnAlterar: TSpeedButton;
    btnNovo: TSpeedButton;
    btnGravar: TSpeedButton;
    btnSair: TSpeedButton;
    btnCancelar: TSpeedButton;
    gridUsuarios: TDBGrid;
    btnInativar: TSpeedButton;
    DBEdit4: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtNome: TEdit;
    btnReiniciarSenha: TSpeedButton;
    Label4: TLabel;
    DBListaTiposDeAcessos: TDBLookupComboBox;
    DBEdit3: TDBEdit;
    DBEdit5: TDBEdit;
    Label5: TLabel;
    DBEdit6: TDBEdit;
    procedure btn_SairClick(Sender: TObject);
    procedure AbrirTabelas;
    procedure FecharTabelas;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FecharAbrirTabelas;
    procedure FormShow(Sender: TObject);
    procedure btnInativarClick(Sender: TObject);
    procedure InativarUsuario;
    procedure VerificarTabelaVazia;
    procedure edtNomeChange(Sender: TObject);
    procedure edtNomeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBEdit1Enter(Sender: TObject);
    procedure DBEdit4KeyPress(Sender: TObject; var Key: Char);
    procedure leitura;
    procedure editar;
    procedure AtualizarQde;
    procedure GravarNovoUsuario;
    procedure gridUsuariosCellClick(Column: TColumn);
    procedure ReiniciarSenha;
    procedure btnReiniciarSenhaClick(Sender: TObject);
    procedure GravarEdicaoDoUsuario;
    procedure DBListaTiposDeAcessosClick(Sender: TObject);
    procedure DBEdit3Enter(Sender: TObject);
    procedure VerificaQdeRegistros;
    procedure DBEdit4Click(Sender: TObject);
    procedure InserirMascaraNoRF;
    procedure DBEdit4Enter(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }

  end;

var
  F_CADUSUARIO : TF_CADUSUARIO;


implementation

uses U_BIBLIOTECA, U_DM, SqlExpr, U_DMPESQ, U_PRINCIPAL, DBClient;


{$R *.dfm}


procedure TF_CADUSUARIO.FormCreate(Sender: TObject);
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
   self.Caption        := 'Manutenção de Usuários - Logado : '+PrimeirasLetrasMaiusculas(NomeDoUsuarioLogado);
   AbrirTabelas;

end;

procedure TF_CADUSUARIO.FormShow(Sender: TObject);
begin
  edtNome.SetFocus;
  leitura;
  VerificaQdeRegistros;
  AtualizarQde;
  LogOperacoes(NomeDoUsuarioLogado, 'acesso ao gerenciamento de usuarios');

end;

procedure TF_CADUSUARIO.AtualizarQde;
begin
   qdeRegs               := ListaQdeRegs(DM.CDS_USUARIOS);
   pnl_cabecalho.Caption := 'Total de usuários cadastrados '+ IntToStr( qdeRegs );

end;

procedure TF_CADUSUARIO.AbrirTabelas;
begin
   DM.CDS_USUARIOS.Active    := true;
   DM.CDS_TIPOSACESSO.Active := true;

end;

procedure TF_CADUSUARIO.FecharTabelas;
begin
   DM.CDS_USUARIOS.Active    := false;
   DM.CDS_TIPOSACESSO.Active := false;

end;

procedure TF_CADUSUARIO.FecharAbrirTabelas;
begin
   DM.CDS_USUARIOS.Active    := false;
   DM.CDS_TIPOSACESSO.Active := false;

   DM.CDS_USUARIOS.Active    := true;
   DM.CDS_TIPOSACESSO.Active := true;

end;

procedure TF_CADUSUARIO.btn_SairClick(Sender: TObject);
begin
     close;

end;

procedure TF_CADUSUARIO.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //mostrando apenas os tipos de acesso acessiveis ao cadastro a exceção do SISTEMA
  DM.CDS_USUARIOS.Close;
  DM.CDS_USUARIOS.CommandText:='SELECT * FROM TBL_USUARIOS WHERE ID_USUARIO > 1 AND STATUS = '+QuotedStr('ATIVO')+' ORDER BY NOME';
  DM.CDS_USUARIOS.Open;
  FecharAbrirTabelas;

end;

procedure TF_CADUSUARIO.FormKeyPress(Sender: TObject; var Key: Char);
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

procedure TF_CADUSUARIO.GravarNovoUsuario;
begin
    nomeUsuarioEditado:= DBEdit2.Text;
    GerarProximoID('id_usuario','tbl_usuarios');
    CriptografarSenha('pgminfo');  //o retorno dessa função é a string declarada criptografada como => SenhaCriptografada

    _Sql:='INSERT INTO tbl_usuarios (id_usuario,nome,login,senha,nivelacesso,orgao,cadastrante,datacad,status,obs) VALUES '+
          '(:pId,:pNome,:pLogin,:pSenha,:pNivelAcesso,:pOrgao,:pCadastrante,:pDataCad,:pStatus, :pObs)';
    With DM.QRY_GERAL do
    begin
        Close;
        sql.Clear;
        sql.Add(_Sql);
        Params.ParamByName('pId').AsInteger          := proxNum;
        Params.ParamByName('pNome').AsString         := DBEdit2.Text;
        Params.ParamByName('pLogin').AsString        := DBEdit4.Text;
        Params.ParamByName('pSenha').AsString        := SenhaCriptografada; // => pgminfo
        Params.ParamByName('pNivelAcesso').AsInteger := DBListaTiposDeAcessos.KeyValue;
        Params.ParamByName('pOrgao').AsString        := DBEdit3.Text;
        Params.ParamByName('pCadastrante').AsString  := NomeDoUsuarioLogado;
        Params.ParamByName('pDataCad').AsString      := DateToStr(now);
        Params.ParamByName('pStatus').AsString       := 'ATIVO';
        Params.ParamByName('pObs').AsString          := DBEdit6.Text;
        ExecSQL();

    end;  

    texto:= 'Usuário '+nomeUsuarioEditado+' cadastrado com sucesso!';
    Application.MessageBox(Pchar(texto), 'Cadastro!',MB_OK + MB_ICONWARNING);
    LogOperacoes(NomeDoUsuarioLogado, 'cadastro de '+nomeUsuarioEditado);
    FecharAbrirTabelas;
    DBEdit1.SetFocus;
    leitura;
    AtualizarQde;
    edtNome.Clear;   

end;

procedure TF_CADUSUARIO.btnGravarClick(Sender: TObject);
begin
   if not( editando ) then   //se nao estiver editando ou seja esta gravando novo registro
   begin
        if (DBEdit2.Text = '') OR (DBEdit4.Text = '') then
        begin
           Application.MessageBox('Preencha os campos corretamente para continuar o cadastro!',
           'Informação do Sistema', MB_OK + MB_ICONINFORMATION);
           exit;
        end else
        begin
             //grava um novo usuario se não houver duplicidade no RF
             if(TemDuplicidade('login','tbl_usuarios',DBEdit4.Text))then
             begin
                texto:= 'O login '+DBEdit4.Text+' já esta cadastrado, verifique!';
                Application.MessageBox(Pchar(texto), 'Duplicidade de cadastro!',MB_OK + MB_ICONWARNING);
                DBEdit4.SetFocus;
             end else begin
                GravarNovoUsuario;
             end;
         end;
      end else
      begin
        //edita o usuario setado
        GravarEdicaoDoUsuario;

     end;
     editando := false;

end;

procedure TF_CADUSUARIO.GravarEdicaoDoUsuario;
begin
    With DM.QRY_GERAL do
    begin
        Close;
        sql.Clear;
        sql.Add('UPDATE tbl_usuarios SET nome=:pNome, orgao=:pOrgao, nivelacesso=:pNivel, obs=:pObs where id_usuario=:pId');
        Params.ParamByName('pNome').AsString   := DBEdit2.Text;
        Params.ParamByName('pOrgao').AsString  := DBEdit3.Text;
        Params.ParamByName('pId').AsInteger    := idUsuarioSelecionado;
        Params.ParamByName('pNivel').AsInteger := DBListaTiposDeAcessos.KeyValue;
        Params.ParamByName('pObs').AsString    := DBEdit6.Text;
        ExecSQL();

    end;
    Application.MessageBox('Os dados foram alterados com sucesso!',
    'Alteração', MB_OK + MB_ICONINFORMATION);
    LogOperacoes(NomeDoUsuarioLogado, 'alteracao no cadastro de '+nomeUsuarioEditado);

    DBEdit1.SetFocus;
    leitura;
    AtualizarQde;
    edtNome.Clear;
    FecharAbrirTabelas;

end;

procedure TF_CADUSUARIO.btnNovoClick(Sender: TObject);
begin
        editar;
        DBEdit2.SetFocus;
        nomeUsuarioEditado := DBEdit2.Text;
        With DMPESQ.Qry_Cod do
        begin
            Close;
            SQL.Clear;
            SQL.Add('select max(ID_USUARIO) from TBL_USUARIOS');
            Open;

            if not IsEmpty then
            begin
               proxNum := DMPESQ.Qry_Cod.Fields[0].AsInteger + 1;

            end;
      end;

      with DM.CDS_USUARIOS do
      begin
          append;
          DBEdit1.Text := InttoStr(proxNum);

      end;
      btnGravar.Enabled := false;
end;

procedure TF_CADUSUARIO.btnAlterarClick(Sender: TObject);
begin
     editando := true;
     DBEdit4.Enabled := false;
     DBEdit2.SetFocus;
     editar;
     nomeUsuarioEditado   := DBEdit2.Text;
     idUsuarioSelecionado := StrToInt(DBEdit1.Text)

end;

procedure TF_CADUSUARIO.btnCancelarClick(Sender: TObject);
begin
    DM.CDS_USUARIOS.CancelUpdates;
    DM.CDS_USUARIOS.Prior;
    FecharAbrirTabelas;
    DBEdit1.SetFocus;
    AtualizarQde;
    leitura;

end;

procedure TF_CADUSUARIO.btnSairClick(Sender: TObject);
begin
    edtNome.Clear; //limpando o filtro
    close;

end;

procedure TF_CADUSUARIO.btnInativarClick(Sender: TObject);
begin
       nomeUsuarioEditado := DBEdit2.Text;
       InativarUsuario;
       leitura;
       AtualizarQde;

end;

procedure TF_CADUSUARIO.InativarUsuario;
begin
       texto:= 'Confirma a inativação do usuário selecionado?';
       if Application.MessageBox(PChar(texto),'Inativando usuário',MB_YESNO + MB_ICONQUESTION) = IdYes then
       begin
           _Sql:= 'UPDATE tbl_usuarios SET STATUS = '+QuotedStr('INATIVO')+' WHERE id_usuario = :pID';

            with DMPESQ.Qry_Geral do
            begin
              Close;
              SQL.Clear;
              SQL.Add(_Sql);
              ParamByName('pID').AsInteger := StrToInt(DBEdit1.Text);
              ExecSQL();

           end;

           Application.MessageBox('Usuário inativado com sucesso!',
           'Inativando', MB_OK + MB_ICONINFORMATION);
           btnInativar.enabled := false;
           LogOperacoes(NomeDoUsuarioLogado, 'inativação no cadastro de '+nomeUsuarioEditado);
           FecharAbrirTabelas;

      end else
      begin
          btnInativar.enabled := false;
          exit;
          leitura;

      end;

end;

procedure TF_CADUSUARIO.leitura;
begin
    btnNovo.enabled                := true;
    btnGravar.enabled              := false;
    btnAlterar.enabled             := true;
    btnCancelar.enabled            := false;
    btnSair.enabled                := true;
    DBEdit2.ReadOnly               := true;
    DBEdit3.ReadOnly               := true;
    DBEdit4.ReadOnly               := true;
    DBEdit6.ReadOnly               := true;
    btnReiniciarSenha.Enabled      := false;
    DBListaTiposDeAcessos.Enabled  := false;
    DBListaTiposDeAcessos.ReadOnly := true;
    gridUsuarios.Enabled           := true;

    VerificarTabelaVazia;

end;

procedure TF_CADUSUARIO.editar;
begin
    btnNovo.enabled                 := false;
    btnGravar.enabled               := true;
    btnAlterar.enabled              := false;
    btnCancelar.enabled             := true;
    btnSair.enabled                 := false;
    DBEdit2.ReadOnly                := false;
    DBEdit3.ReadOnly                := false;
    DBEdit4.ReadOnly                := false;
    DBEdit6.ReadOnly                := false;
    DBListaTiposDeAcessos.ReadOnly  := false;
    DBListaTiposDeAcessos.Enabled   := true;
    gridUsuarios.Enabled            := false;

end;

procedure TF_CADUSUARIO.VerificarTabelaVazia;
begin
    if (TabelaVazia('TBL_USUARIOS'))then
    begin
       btnalterar.Enabled  := false;
       btnInativar.Enabled := false;

    end;

end;

procedure TF_CADUSUARIO.edtNomeChange(Sender: TObject);
var
  nome : string;
begin
      nome  := edtNome.Text;
      _Sql  := 'SELECT * FROM tbl_usuarios WHERE nome LIKE (''%'+nome+'%'') AND NOME <> '+QuotedStr('ADMINISTRADOR')+' AND STATUS = '+QuotedStr('ATIVO')+' ORDER BY nome';
      with DM.CDS_USUARIOS do
      begin
            Close;
            CommandText:= (_Sql);
            Open;
      end;
      AtualizarQde;
end;

procedure TF_CADUSUARIO.edtNomeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      if KEY = VK_RETURN then
      begin
          edtNome.Clear;

      end;

end;

procedure TF_CADUSUARIO.DBEdit1Enter(Sender: TObject);
begin
   edtNome.SetFocus;

end;

procedure TF_CADUSUARIO.gridUsuariosCellClick(Column: TColumn);
begin
    btnReiniciarSenha.Enabled := true;
    btnCancelar.enabled       := true;
    btnInativar.enabled       := true;
    idUsuarioSelecionado      := dm.CDS_USUARIOS.FieldByName('ID_USUARIO').AsInteger;

end;

procedure TF_CADUSUARIO.ReiniciarSenha;
begin
       CriptografarSenha('pgminfo');  //o retorno dessa função é a string declarada criptografada como => SenhaCriptografada
       With DMPESQ.Qry_Geral do
       begin
          Close;
          SQL.Clear;
          SQL.Add('UPDATE tbl_usuarios SET senha = :pSenhaInicial WHERE id_usuario = :pID');
          Params.ParamByName('pSenhaInicial').AsString := SenhaCriptografada;
          Params.ParamByName('pID').AsInteger          := idUsuarioSelecionado;
          ExecSQL;

       end;

       Application.MessageBox('Senha reiniciada com sucesso o usuário deverá alterá-la no próximo acesso!', 'Reinicialização de senhas!', MB_ICONINFORMATION);
       btnReiniciarSenha.Enabled := false;
       btnCancelar.Enabled       := false;
       btnNovo.Enabled           := true;
       LogOperacoes(NomeDoUsuarioLogado, 'reinicialização da senha '+nomeUsuarioEditado);

end;

procedure TF_CADUSUARIO.btnReiniciarSenhaClick(Sender: TObject);
begin
     nomeUsuarioEditado := DBEdit2.Text;
     texto:= 'Confirma a reinicialização da senha do usuário selecionado?';

     if Application.MessageBox(PChar(texto),'Reiniciando senha',MB_YESNO + MB_ICONQUESTION) = IdYes then
      begin

          ReiniciarSenha;

      end else begin

        btnReiniciarSenha.Enabled := false;
        exit;

      end;
end;

procedure TF_CADUSUARIO.DBListaTiposDeAcessosClick(Sender: TObject);
begin
btnGravar.Enabled := true;
end;

procedure TF_CADUSUARIO.InserirMascaraNoRF;
begin
  DBEdit4.Field.EditMask := 'A999999;1;_';  //digita apenas os numeros o D é fixo
end;

procedure TF_CADUSUARIO.DBEdit4Enter(Sender: TObject);
begin
InserirMascaraNoRF;
end;

procedure TF_CADUSUARIO.DBEdit3Enter(Sender: TObject);
begin
       //verifica se digitou os sete caracteres do RF
       //ShowMessage('valor: '+LimparMascara(DBEdit4.Text)+ ' Qde de caracteres: '+IntToStr(Length(LimparMascara(DBEdit4.text))));
       If (Length(LimparMascara(DBEdit4.Text))<7) then
       begin
        Application.MessageBox('Favor digitar o RF corretamente ex: D123456', 'RF inválido!', MB_ICONWARNING);
        DBEdit4.SetFocus;
       end;
      
end;

procedure TF_CADUSUARIO.DBEdit4KeyPress(Sender: TObject; var Key: Char);
begin
{aceita apenas numeros e a letra D - Deixei apenas a titulo de informação já que utilizei uma mascara e não precisava mais disso
if not (Key in['0'..'9','D','d',Chr(8)]) then Key:= #0;}

end;

procedure TF_CADUSUARIO.VerificaQdeRegistros;
begin
      //verifica a quantidade de registros no banco caso tenha apenas o ADM desabilita os botoes inativar e editar
      _Sql  := 'SELECT * FROM TBL_USUARIOS WHERE ID_USUARIO > 1 AND STATUS = '+QuotedStr('ATIVO')+' ORDER BY NOME';
      with DM.CDS_USUARIOS do
      begin
            Close;
            CommandText:= (_Sql);
            Open;

            if IsEmpty then
            begin
                btnAlterar.Enabled  := false;
                btnInativar.Enabled := false;

            end;
      end;
end;

procedure TF_CADUSUARIO.DBEdit4Click(Sender: TObject);
begin
DBEdit4.SelStart:=0;
DBEdit4.SelLength:= Length(DBEdit4.Text);

end;


end.
