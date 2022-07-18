unit U_CADPADRAO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, Buttons, ExtCtrls,DateUtils, ToolEdit,
  CurrEdit, Grids, DBGrids, Menus, Math, DB, OleCtnrs;

type
  TF_CADPADRAO = class(TForm)
    pan_titulo: TPanel;
    lblHoraAtual: TLabel;
    lblDataDoDia: TLabel;
    Panel1: TPanel;
    GroupBox9: TGroupBox;
    edtNome: TEdit;
    GridCredenciados: TDBGrid;
    Panel2: TPanel;
    grupoDados: TGroupBox;
    lbl54: TLabel;
    lbl55: TLabel;
    lbl56: TLabel;
    lbl60: TLabel;
    lbl61: TLabel;
    lbl62: TLabel;
    lblFones: TLabel;
    Label20: TLabel;
    Label29: TLabel;
    Label1: TLabel;
    pan_botoes: TPanel;
    btnExcluir: TSpeedButton;
    btnSair: TSpeedButton;
    btnGravar: TSpeedButton;
    btnNovo: TSpeedButton;
    btnAlterar: TSpeedButton;
    DBNome: TDBEdit;
    DBEndereco: TDBEdit;
    DBBairro: TDBEdit;
    DBEmail: TDBEdit;
    DBObs: TDBEdit;
    DBCEP: TDBEdit;
    DBCPF: TDBEdit;
    DBFONE: TDBEdit;
    DBCELULAR: TDBEdit;
    DBDDD: TDBEdit;
    DBID: TDBEdit;
    DBDATA: TDBEdit;
    btnCancelar: TSpeedButton;
    edtIDUltimoReg: TEdit;
    DBCLASSINI: TDBEdit;
    Label5: TLabel;
    txtMsg: TStaticText;
    Label6: TLabel;
    OleContainer1: TOleContainer;
    openCurriculum: TOpenDialog;
    btnCurriculum: TSpeedButton;
    DBStatus: TStaticText;
    lblCONSELHO: TLabel;
    DBCONSELHO: TDBEdit;
    lblCADASTRADOR: TStaticText;
    Label3: TLabel;
    btnInativar: TSpeedButton;

    //procedimentos perso
    procedure AbrirTabelas;
    procedure FecharTabelas;
    procedure FecharAbrirTabelas;
    procedure ClassificarListaPorID;
    procedure VerificarStatus;
    procedure leitura;
    procedure editar;
    procedure exibirCurriculum;
    procedure CopiarCurriculumPdf;
    procedure AlterarNomePDF;
    procedure DeletarPDF;
    procedure VerificarDuplicidade;
    procedure ValidarCPF;
    procedure MostrarNomeDoCadastrante;
    procedure InserirMascaraNosCampos;
    procedure InativarCredenciado;
    procedure mostrarDados;
    procedure VerificarTabelaVazia;
    procedure EnviarDadosParaExclusaoDeCredenciado;
    procedure AtualizarAposDelecao;
    procedure PesquisarPorNome;

    //procedimentos padrao
    procedure FormCreate(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtNomeChange(Sender: TObject);
    procedure edtNomeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DBNomeExit(Sender: TObject);
    procedure DBEmailChange(Sender: TObject);
    procedure GridCredenciadosCellClick(Column: TColumn);
    procedure GridCredenciadosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnCurriculumClick(Sender: TObject);
    procedure DBCPFEnter(Sender: TObject);
    procedure DBEnderecoEnter(Sender: TObject);
    procedure DBNomeChange(Sender: TObject);
    procedure edtNomeEnter(Sender: TObject);
    procedure DBCLASSINIEnter(Sender: TObject);
    procedure btnInativarClick(Sender: TObject);  
    procedure DBCLASSINIClick(Sender: TObject);
    procedure DBCLASSINIChange(Sender: TObject);
    procedure DBCONSELHOKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
     alterou,  inativou, novoReg, alterouClassificacao: BOOLEAN;
     classIni : integer;
     nomeCredenciadoEditado   : string;

  public
    { Public declarations }
   
  end;

var
  F_CADPADRAO: TF_CADPADRAO;


implementation

uses U_BIBLIOTECA, U_DM, SqlExpr, U_DMPESQ, U_CHECKDOC, U_ESCOLHATIPOEXCLUSAO,
  DBClient;


{$R *.dfm}

procedure TF_CADPADRAO.FormCreate(Sender: TObject);
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

    //Recebe a data atual por padrão
    lblDataDoDia.Caption         := DateToStr(now);
    lblHoraAtual.Caption         := timetoStr(time);
    pan_titulo.Caption           := 'CADASTRA '+UpperCase(RetornaNomeFormacaoPlural(IdTipoFormacao));
    lblConselho.Caption          := UpperCase(RetornaNomeConselho(IdTipoFormacao));
    AtualizaQde(dm.CDS_CONSULTAS,txtMsg);

end;

procedure TF_CADPADRAO.mostrarDados;
begin
    with DM.CDS_CONSULTAS do
    begin
        close;
        CommandText:='SELECT * FROM '+nomeTabela+' WHERE status='+QuotedStr('ATIVO')+' ORDER BY posicao_inicial';
        open;

    end;
    self.Caption        := 'Logado por : '+PrimeirasLetrasMaiusculas(NomeDoUsuarioLogado);

    if DM.CDS_CONSULTAS.RecordCount > 0 then
    begin
        MostrarNomeDoCadastrante;
    end;

    DBDATA.Text    :=  datetostr(NOW);
    MostrarIDUltimoReg(nomeTabela,edtIDUltimoReg);
    edtNome.SetFocus;
    leitura;

end;

procedure TF_CADPADRAO.FormShow(Sender: TObject);
begin     
     mostrarDados;
end;

procedure TF_CADPADRAO.AbrirTabelas;
begin
    DM.CDS_CONSULTAS.Active     := TRUE;

end;

procedure TF_CADPADRAO.FecharTabelas;
begin
    DM.CDS_CONSULTAS.Active     := FALSE;

end;

procedure TF_CADPADRAO.FecharAbrirTabelas;
begin
    DM.CDS_CONSULTAS.Active  := FALSE;
    DM.CDS_CONSULTAS.Active  := TRUE;

end;   

procedure TF_CADPADRAO.btnSairClick(Sender: TObject);
begin
  close;
  Release;

end;

procedure TF_CADPADRAO.FormKeyPress(Sender: TObject; var Key: Char);
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

procedure TF_CADPADRAO.AlterarNomePDF;
var
   nomeArquivoAnterior, nomeArquivoNovo, caminhoDaPasta : string;
begin
    if ( alterouNome )then
    begin
       caminhoDaPasta       := ExtractFilePath(Application.ExeName)+'curriculuns\';
       nomeArquivoAnterior  := caminhoDaPasta + nome_anterior + '.PDF';
       nomeArquivoNovo      := caminhoDaPasta + dbNome.text + '.PDF';
       RenameFile(nomeArquivoAnterior,nomeArquivoNovo);

    end;

end;

procedure TF_CADPADRAO.btnGravarClick(Sender: TObject);
begin
    if ( alterou )then      //se fez alterações
    begin
         AlterarNomePDF;    //somente se alterou o nome
         DM.CDS_CONSULTAS.Next;
         DM.CDS_CONSULTAS.ApplyUpdates(0);
         Application.MessageBox('Cadastro alterado com sucesso!',
                     'Cadastro alterado!', MB_OK + MB_ICONINFORMATION);
         LogOperacoes(NomeDoUsuarioLogado, 'alteracao no cadastro de '+lowercase(nomedaformacao)+' conselho n. '+numConselho);
         DBCLASSINI.Field.Alignment := taCenter;  //centralizando os dados no dbedit
         edtNome.setfocus;

    end else
    begin
         GerarProximoID('id_credenciado',nomeTabela);
         With DM.QRY_GERAL do
         begin
              Close;
              SQL.Clear;
              SQL.Add('INSERT INTO '+nomeTabela+'(id_credenciado, posicao_inicial, tipo_id, conselho, nome, endereco, bairro, cep, cpf, dddfone, fone, celular, '+
              'email, cadastranteid, atribuido, obs, datacad, status) VALUES (:pidCredenciado, :pPosicaoInicial, :pTipoId, :pConselho, :pNome, :pEnd, :pBairro, :pCep, :pCpf, '+
              ':pDddFone, :pFone, :pCelular, :pEmail, :pCadastranteId, :pAtribuido, :pObs, :pDataCad, :pStatus)');
              ParamByName('pidCredenciado').AsInteger     := proxNum;
              ParamByName('pPosicaoInicial').AsInteger    := novaClassInicial;
              ParamByName('pTipoId').AsInteger            := IdTipoFormacao;
              ParamByName('pConselho').AsString           := DBCONSELHO.Text;
              ParamByName('pNome').AsString               := DBNome.Text;
              ParamByName('pEnd').AsString                := DBEndereco.Text;
              ParamByName('pBairro').AsString             := DBBairro.Text;
              ParamByName('pCep').AsString                := DBCEP.Text;
              ParamByName('pCpf').AsString                := DBCPF.Text;
              ParamByName('pDddFone').AsString            := DBDDD.Text;
              ParamByName('pFone').AsString               := DBFONE.Text;
              ParamByName('pCelular').AsString            := DBCELULAR.Text;
              ParamByName('pEmail').AsString              := DBEmail.Text;
              ParamByName('pCadastranteId').AsInteger     := IdDoUsuarioLogado;
              ParamByName('pAtribuido').AsString          := 'N';
              ParamByName('pObs').AsString                := DBObs.Text;
              ParamByName('pDataCad').AsString            := DateToStr(now);
              ParamByName('pObs').AsString                := DBObs.Text;
              ParamByName('pStatus').AsString             := 'ATIVO';
              ExecSQL();

          end;
          CalcularClassificacaoInicial(nomeTabela,DBCLASSINI);
          texto := nomedaformacao+' CADASTRADO COM SUCESSO!';
          Application.MessageBox(Pchar(texto),'Cadastro efetuado!', MB_OK + MB_ICONINFORMATION);
          LogOperacoes(NomeDoUsuarioLogado, 'cadastro de '+lowercase(nomedaformacao)+' conselho n. '+numConselho);
          VerificarTabelaVazia;
          Panel1.Enabled:=true;
          edtNome.setfocus;
          inativou := false;

    end;
    grupoDados.Enabled:=false;
    DBCLASSINI.Field.Alignment := taCenter;  //centralizando os dados no dbedit
    MostrarIDUltimoReg(nomeTabela,edtIDUltimoReg);
    FecharAbrirTabelas;
    alterou := false;
    novoReg := false;
    alterouClassificacao := false;
    leitura;
    AtualizaQde(dm.CDS_CONSULTAS,txtMsg);
    
end;

procedure TF_CADPADRAO.PesquisarPorNome;
var
  nome : string;
begin
      nome  := edtNome.Text;
      _Sql  := 'SELECT * FROM '+nomeTabela+' WHERE nome LIKE (''%'+nome+'%'') AND status='+QuotedStr('ATIVO')+' ORDER BY nome';

      with DM.CDS_CONSULTAS do
      begin
            Close;
            CommandText:= (_Sql);
            Open;

      end;
      AtualizaQde(DM.CDS_CONSULTAS,txtMsg);

end;

procedure TF_CADPADRAO.edtNomeChange(Sender: TObject);
begin
    PesquisarPorNome;

end;

procedure TF_CADPADRAO.edtNomeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      if KEY = VK_RETURN then
      begin
          edtNome.Clear;
          ClassificarListaPorID;

      end;    
end;

procedure TF_CADPADRAO.btnNovoClick(Sender: TObject);
begin
      InserirMascaraNosCampos;

      //USADO SOMENTE PARA LIMPAR OS DBEDITS DEPOIS GRAVO COM A QUERY
      with DM.CDS_CONSULTAS do
      begin
            append;
            DBID.Text := InttoStr(proxNum);

      end;

      editar;
      novoReg                := true;
      btnGravar.Enabled      := false;
      btnCurriculum.Enabled  := false;
      inativou               := false;
      DBNome.SetFocus;
      DBStatus.Caption       := '';
      lblCADASTRADOR.Caption := '';
      classIni               := 0;

end;

procedure TF_CADPADRAO.btnAlterarClick(Sender: TObject);
begin
     grupoDados.Enabled:=true;
     with DM.CDS_CONSULTAS do
     begin
          edit;
          DBNome.SetFocus;

      end;
      alterou       := TRUE;
      alterouNome   := false;
      inativou      := false;
      nome_anterior := DBNome.Text;
      editar;

end;

procedure TF_CADPADRAO.AtualizarAposDelecao;
begin
       MostrarIDUltimoReg(nomeTabela,edtIDUltimoReg);
       AtualizaQde(DM.CDS_CONSULTAS,txtMsg);
       leitura;

end;

procedure TF_CADPADRAO.btnExcluirClick(Sender: TObject);
begin
     //escolher tipo de exclusão
     EnviarDadosParaExclusaoDeCredenciado;

     Application.CreateForm(TF_ESCOLHATIPOEXCLUSAO,  F_ESCOLHATIPOEXCLUSAO);
     F_ESCOLHATIPOEXCLUSAO.ShowModal;
     FreeAndNil(F_ESCOLHATIPOEXCLUSAO);

     FecharAbrirTabelas;
     AtualizaQde(dm.CDS_CONSULTAS,txtMsg);

     inativou := false;

end;

procedure TF_CADPADRAO.EnviarDadosParaExclusaoDeCredenciado;
begin
     //SE OPTAR POR EXCLUIR CREDENCIADOS
      nomeTabelaExclusao      := nomeTabela;
      IdExclusao              := StrToInt(DBID.Text);
      caminhoDaPasta          := ExtractFilePath(Application.ExeName)+'curriculuns\';
      nomeArquivoPDFExclusao  := caminhoDaPasta + DBNome.Text + '.PDF';
      posicaoInicial          := StrToInt(DBCLASSINI.text);

end;

procedure TF_CADPADRAO.DeletarPDF;
var
   nomeArquivo, caminhoDaPasta : string;
begin
     caminhoDaPasta      := ExtractFilePath(Application.ExeName)+'curriculuns\';
     nomeArquivo         := caminhoDaPasta + DBNome.Text + '.PDF';
     DeleteFile(nomeArquivo);

end;

procedure TF_CADPADRAO.btnCancelarClick(Sender: TObject);
begin
      if ( novoReg ) then
      begin
         DeletarPDF;
         DM.CDS_CONSULTAS.Cancel;
         FecharAbrirTabelas;
         leitura;

      end else
      begin
          DM.CDS_CONSULTAS.Cancel;
          FecharAbrirTabelas;
          leitura;

      end;

      if ( alterou ) then
      begin
          DM.CDS_CONSULTAS.Cancel;
          FecharAbrirTabelas;
          leitura;

      end;

      inativou             := false;
      alterouClassificacao := false;

end;


procedure TF_CADPADRAO.DBNomeExit(Sender: TObject);
begin
   if DBNome.Text = '' then
   begin
         ShowMessage('Nome inválido, digite o nome do arquiteto');
         DBNome.SetFocus;

   end;    

end;

procedure TF_CADPADRAO.leitura;
begin
    btnNovo.enabled               := true;
    btnGravar.enabled             := false;
    btnCancelar.enabled           := false;
    btnSair.enabled               := true;
    btnInativar.enabled           := false;

    if DM.CDS_CONSULTAS.RecordCount > 0 then
    begin
        VerificarTabelaVazia;
        btnExcluir.enabled       := true;
        btnAlterar.enabled       := true;
        panel1.Enabled           := true;
        lblCADASTRADOR.Caption   := '';
        DBStatus.Caption         := '';

    end else begin
        btnExcluir.enabled       := false;
        btnAlterar.enabled       := false;
        panel1.Enabled           := false;

    end;

    DBNome.ReadOnly               := true;
    DBEndereco.ReadOnly           := true;
    DBBairro.ReadOnly             := true;
    DBCONSELHO.ReadOnly           := true;
    DBCEP.ReadOnly                := true;
    DBCPF.ReadOnly                := true;
    DBDDD.ReadOnly                := true;
    DBFONE.ReadOnly               := true;
    DBCELULAR.ReadOnly            := true;
    DBEmail.ReadOnly              := true;
    DBObs.ReadOnly                := true;
    grupoDados.Enabled            := false;

    if(inativou)then
      AtualizaQde(dm.CDS_CONSULTAS,txtMsg);

end;

procedure TF_CADPADRAO.editar;
begin
    btnNovo.enabled               := false;
    btnGravar.enabled             := true;
    btnAlterar.enabled            := false;
    btnCancelar.enabled           := true;
    btnExcluir.enabled            := false;
    btnSair.enabled               := false;
    btnInativar.Enabled           := false;
    DBNome.ReadOnly               := false;
    DBEndereco.ReadOnly           := false;
    DBBairro.ReadOnly             := false;
    DBCONSELHO.ReadOnly           := false;
    DBCEP.ReadOnly                := false;
    DBCPF.ReadOnly                := false;
    DBDDD.ReadOnly                := false;
    DBFONE.ReadOnly               := false;
    DBCELULAR.ReadOnly            := false;
    DBEmail.ReadOnly              := false;
    DBObs.ReadOnly                := false;
    DBCLASSINI.ReadOnly           := false;
    grupoDados.Enabled            := true;

end;

procedure TF_CADPADRAO.VerificarTabelaVazia;
begin
     if ( TabelaVazia(nomeTabela)) then
     begin
         btnAlterar.Enabled           := false;
         btnExcluir.Enabled           := false;
         txtMsg.Visible               := false;
         btnCurriculum.Enabled        := false;
         IdCredenciado                := 0;
     end else
     begin
         txtMsg.Visible               := true;
         btnCurriculum.Enabled        := true;
         IdCredenciado                := StrToInt(DBID.Text);

     end;

end;


procedure TF_CADPADRAO.DBEmailChange(Sender: TObject);
begin
     btnCurriculum.Enabled := true;

end;

procedure TF_CADPADRAO.GridCredenciadosCellClick(Column: TColumn);
begin
   leitura;
   MostrarNomeDoCadastrante;
   //passando o ID do credenciado ao clicar no nome do grid
   IdCredenciado           := DM.CDS_CONSULTAS.fieldbyname('id_credenciado').AsInteger;
   nomeCredenciadoEditado  := DM.CDS_CONSULTAS.FieldByName('NOME').AsString;
   btnInativar.Enabled     := true;
   numConselho             := DBCONSELHO.Text;

end;

procedure TF_CADPADRAO.ClassificarListaPorID;
begin
      With DM.QRY_GERAL do
      begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM '+nomeTabela+' WHERE status='+QuotedStr('ATIVO')+' ORDER BY id_credenciado');
            open;
      end;

end;

procedure TF_CADPADRAO.GridCredenciadosDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
     with GridCredenciados do
      begin
        if DataSource.DataSet.FieldByName('atribuido').AsString = 'S' then
        begin
              Canvas.Font.Style  := [fsBold];
              Canvas.Font.Color  := clRed;

         end else begin
             Canvas.Font.Style  := [fsBold];
             Canvas.Font.Color  := clBlue;

         end;

         //dando cor á linha selecionada
         if gdSelected in State then
         begin

              if DataSource.DataSet.FieldByName('atribuido').AsString = 'S' then
              begin
                    Canvas.Brush.Color := clSkyBlue;   //cor de fundo da linha
                    Canvas.Font.Color  := clred;       //cor da letra

              end else begin
                    Canvas.Brush.Color := clSkyBlue;   //cor de fundo da linha
                    Canvas.Font.Color  := clblack;     //cor da letra

              end;
         end;

         Canvas.FillRect(Rect);
         DefaultDrawColumnCell(Rect,DataCol,Column,State);

     end;

end;

procedure TF_CADPADRAO.VerificarStatus;
begin
     if ( DM.CDS_CONSULTAS.fieldbyname('atribuido').AsString = 'S')then
     begin
          DBStatus.Caption        := 'COM PROCESSO ATRIBUIDO';
          DBStatus.Font.Color     := clRed;

     end else
     begin
          DBStatus.Caption       := 'SEM PROCESSO ATRIBUIDO';
          DBStatus.Font.Color    := clBlue;

     end;
     DBCLASSINI.Field.Alignment := taCenter;  //centralizando os dados no dbedit
end;

{procedure TF_CADPADRAO.CopiarCurriculumPdf;
var origem, destino,novoNomePDF  : string;
begin

   destino := ExtractFilePath(Application.ExeName)+'Curriculuns\';


   //SE CREDDESENV EXISTIR DELETAR PARA SER COPIADO O NOVO ARQUIVO
   if(FileExists(destino))then
      DeleteFile(destino);

   if openCurriculum.Execute then
   begin

       novoNomePDF  := DBNome.Text + '.PDF';
       origem  := openCurriculum.FileName;

       destino := ExtractFilePath(Application.ExeName)+'Curriculuns\'+novoNomePDF;

       ShowMessage(origem);
       ShowMessage(destino);


       CopyFile(PChar(origem), PChar(destino), False);

   end;

end;  }

procedure TF_CADPADRAO.CopiarCurriculumPdf;
var
   caminhoDaPasta, novoNomePDF, arquivoEscolhido : string;   
begin

    if openCurriculum.Execute then
    begin
         arquivoEscolhido    := openCurriculum.FileName;
         caminhoDaPasta      := ExtractFilePath(Application.ExeName)+'Curriculuns\';
         novoNomePDF         := caminhoDaPasta + DBNome.Text + '.PDF';
         CopiarArquivo(arquivoEscolhido,novoNomePDF);
    end;

end;

procedure TF_CADPADRAO.btnCurriculumClick(Sender: TObject);
begin
   //se estiver cadastrando abrir opção de escolha do curriculum para cópia na pasta 'curriculuns'
   CopiarCurriculumPdf;
   btnGravar.Enabled := true;

end;

procedure TF_CADPADRAO.exibirCurriculum;
var
   caminhoDoPDF, nomePDF : string;
begin
    //todos os PDF deverão conter o nome de seus donos ex: LINOSMAR.PDF
    nomePDF      := trim(DBNome.Text)+'.PDF';

    caminhoDoPDF :=  ExtractFilePath(Application.ExeName)+'Curriculuns\'+nomePDF;
    
    //se o PDF existir abra-o
    if FileExists(caminhoDoPDF) then
    begin
        OleContainer1.Visible      := true;
        OleContainer1.AutoActivate := aaGetFocus;
        OleContainer1.CreateLinkToFile(caminhoDoPDF, True);
        OleContainer1.SetFocus;

    end else
    begin
         Application.MessageBox('Curriculum solicitado não encontrado, cadastre novamente!',
         'Não encontrado!', MB_OK + MB_ICONEXCLAMATION);
         CopiarCurriculumPdf;
         Application.MessageBox('Curriculum cadastrado com sucesso!',
         'Cadastrando curriculum!', MB_OK + MB_ICONINFORMATION);  
    end;

end;

procedure TF_CADPADRAO.DBCPFEnter(Sender: TObject);
begin
    if ( novoReg ) then begin
       VerificarDuplicidade;
       CalcularClassificacaoInicial(nomeTabela,DBCLASSINI);
       novaClassInicial := strtoint(DBCLASSINI.text);
       numConselho      := DBCONSELHO.Text;
    end;

end;

procedure TF_CADPADRAO.VerificarDuplicidade;
begin
   with DMPESQ.QRY_GERAL do
   begin
       close;
       sql.Clear;
       sql.Add('SELECT * FROM '+nomeTabela+' WHERE nome LIKE :pNome AND conselho= :pConselho');
       Params.ParamByName('pNome').AsString      := DBNome.Text;
       Params.ParamByName('pConselho').AsString  := DBCONSELHO.Text;
       open;

       if not IsEmpty then
       begin
           ShowMessage('Arquiteto já cadastrado');
           DBNome.Clear;
           DBNome.SetFocus;

       end;
   end;
end;


procedure TF_CADPADRAO.ValidarCPF;
var
   entradaCPF : string;
   validacao  : TCheckDoc;
begin
      entradaCPF       := StringReplace(DBCPF.Text,'.','',[rfReplaceAll]);
      entradaCPF       := StringReplace(entradaCPF,'-','',[rfReplaceAll]);

      validacao        := TCheckDoc.Create(self);
      validacao.Input  := entradaCPF;

      if ( validacao.Result = true ) then
      begin
            DBEndereco.SetFocus;// ShowMessage('CPF é válido ');

      end else begin
            ShowMessage('Número de CPF inválido digite novamente!');
            DBCPF.SetFocus;
      end;

end;

procedure TF_CADPADRAO.DBEnderecoEnter(Sender: TObject);
begin
     //ValidarCPF;

end;

procedure TF_CADPADRAO.DBNomeChange(Sender: TObject);
begin
    alterouNome := true;

end;

procedure TF_CADPADRAO.MostrarNomeDoCadastrante;
begin
    _Sql:= 'SELECT u.nome FROM tbl_usuarios u, '+nomeTabela+' a WHERE u.id_usuario=a.cadastranteid and a.posicao_inicial=:pID';
    With DM.QRY_GERAL do
    begin
          Close;
          SQL.Clear;
          SQL.Add(_Sql);
          Params.ParamByName('pID').AsInteger:= StrToInt(DBCLASSINI.Text);
          open;

          if not IsEmpty then
          begin
              lblCADASTRADOR.Caption    := DM.QRY_GERAL.fieldbyname('nome').AsString;

          end else begin
              lblCADASTRADOR.Caption:= '';

          end;
    end;
    VerificarStatus;
end;



procedure TF_CADPADRAO.InserirMascaraNosCampos;
begin
     grupoDados.Enabled:=true;
     DBCPF.Field.EditMask       := '999.999.999-99;1;_';
     DBCEP.Field.EditMask       := '99999-999;1;_';
     DBFONE.Field.EditMask      := '9999-9999;1;_';
     DBCELULAR.Field.EditMask   := '\99999-9999;1;_';    //a barra define um numero fixo
     DBDDD.Field.EditMask       := '\099;1;_';           //mascara editavel com 0 na frente
     //DBDDD.Field.EditMask       := '!\011;1;0';        //mascara fixa  com 011

end;

procedure TF_CADPADRAO.edtNomeEnter(Sender: TObject);
begin
DBCLASSINI.Field.Alignment := taCenter;  //centralizando os dados no dbedit
end;

procedure TF_CADPADRAO.DBCLASSINIEnter(Sender: TObject);
begin
     DBCLASSINI.Text := IntToStr(novaClassInicial);
     DBCLASSINI.SelStart:=0;
     DBCLASSINI.SelLength:= Length(DBCLASSINI.Text);
     
end;

procedure TF_CADPADRAO.btnInativarClick(Sender: TObject);
begin
     //inativando o credenciado
     
     texto:= 'Confirma a inativação de '+nomeCredenciadoEditado+'?';

     if Application.MessageBox(PChar(texto),'Inativação de Credenciado',MB_YESNO + MB_ICONQUESTION) = IdYes then
     begin
          InativarCredenciado;
          LogOperacoes(NomeDoUsuarioLogado, 'inativacao no cadastro do '+lowercase(nomedaformacao)+' conselho n. '+numConselho);
          mostrarDados;
          Application.MessageBox('O credenciado foi inativado com sucesso!', 'Inativação de Credenciado', MB_OK + MB_ICONINFORMATION);
     end else
     begin
         exit;

     end;
     btnInativar.Enabled := false;
     AtualizaQde(dm.CDS_CONSULTAS,txtMsg);
     
end;

procedure TF_CADPADRAO.InativarCredenciado;
var
  codigoInativacao : integer;
begin
    With DM.QRY_GERAL do
    begin
          Close;
          SQL.Clear;
          SQL.Add('update '+nomeTabela+' SET status = '+QuotedStr('INATIVO')+', posicao_inicial = 0, datainat = :pDataInativacao WHERE id_credenciado = :pID');
          ParamByName('pID').AsInteger             := IdCredenciado;
          ParamByName('pDataInativacao').AsString  := DateToStr(now);
          ExecSQL();

    end;

    codigoInativacao := GerarProximoID('codigo','TBL_INATIVOS');

    With DM.QRY_GERAL do
    begin
          Close;
          SQL.Clear;
          SQL.Add('Insert into TBL_INATIVOS (CODIGO,CONSELHO,TABELA) VALUES (:pCodigo, :pConselho, :pTabela)');
          ParamByName('pCodigo').AsInteger   := codigoInativacao;
          ParamByName('pConselho').AsString  := numConselho;
          ParamByName('pTabela').AsString    := nomeTabela;
          ExecSQL();

    end;

    inativou := false;
end;



procedure TF_CADPADRAO.DBCLASSINIClick(Sender: TObject);
begin
    DBCLASSINI.SelStart:=0;
    DBCLASSINI.SelLength:= Length(DBCLASSINI.Text);

end;

procedure TF_CADPADRAO.DBCLASSINIChange(Sender: TObject);
begin
  alterouClassificacao := true;
end;

procedure TF_CADPADRAO.DBCONSELHOKeyPress(Sender: TObject; var Key: Char);
begin
   //SO ACEITA NUMEROS / BARRAS / TRAÇOS 
   if not (Key in['0'..'9' , '/' , '-' ,Chr(8)]) then Key:= #0;
end;

end.





