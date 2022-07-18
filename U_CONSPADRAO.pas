unit U_CONSPADRAO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, Buttons, ExtCtrls,DateUtils, ToolEdit,
  CurrEdit, Grids, DBGrids, Menus, Math, DB, OleCtnrs;

type
  TF_CONSPADRAO = class(TForm)
    pan_titulo: TPanel;
    lblHoraAtual: TLabel;
    lblDataDoDia: TLabel;
    Panel1: TPanel;
    GroupBox9: TGroupBox;
    edtNome: TEdit;
    GridCredenciados: TDBGrid;
    Panel2: TPanel;
    pan_botoes: TPanel;
    btnSair: TSpeedButton;
    btnCurriculum: TSpeedButton;
    btnAtribuirProc: TSpeedButton;
    txtMsg: TStaticText;
    openCurriculum: TOpenDialog;
    grDados: TGroupBox;
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
    Label5: TLabel;
    Label6: TLabel;
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
    edtIDUltimoReg: TEdit;
    DBCLASSINI: TDBEdit;
    OleContainer1: TOleContainer;
    DBIDTipo: TDBEdit;
    lblCONSELHO: TLabel;
    DBCrea: TDBEdit;
    btnLiberarAtribuicao: TSpeedButton;
    btnMostrarAtribuidos: TSpeedButton;
    btnImprimir: TSpeedButton;
    GridProcessos: TDBGrid;
    Label2: TLabel;
    Label8: TLabel;
    lblCADASTRADOR: TStaticText;
    lblATRIBUIDOR: TStaticText;
    Label3: TLabel;
    lblStatus: TStaticText;
    btnMostrarNaoAtribuidos: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure AbrirTabelas;
    procedure FecharTabelas;
    procedure FecharAbrirTabelas;
    procedure btnSairClick(Sender: TObject);
    procedure PesquisarPorNome;
    procedure FormShow(Sender: TObject);
    procedure edtNomeChange(Sender: TObject);
    procedure edtNomeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure GridCredenciadosCellClick(Column: TColumn);
    procedure AtribuirProcesso;
    procedure btnAtribuirProcClick(Sender: TObject);
    procedure VerificarStatus;
    procedure exibirCurriculum;
    procedure GridCredenciadosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnCurriculumClick(Sender: TObject);
    procedure ProcessosDoCredenciado;
    procedure btnLiberarAtribuicaoClick(Sender: TObject);
    procedure MostrarAtribuidos;
    procedure MostrarNaoAtribuidos;
    procedure MostrarParaAtribuicao;
    procedure MostrarStatus;
    procedure btnMostrarAtribuidosClick(Sender: TObject);
    procedure MostrarNomeDoAtribuidor;
    procedure MostrarNomeDoCadastrante;
    procedure GridProcessosCellClick(Column: TColumn);
    procedure btnImprimirClick(Sender: TObject);
    procedure CopiarCurriculumPdf;
    procedure btnRecomecarFilaClick(Sender: TObject);
    procedure btnMostrarNaoAtribuidosClick(Sender: TObject);
    procedure HabiltarDesabilitarBotao;
    procedure RecomecarFila;

  private
    { Private declarations }

  public
    { Public declarations }
   
  end;

var
  F_CONSPADRAO: TF_CONSPADRAO;


implementation

uses U_BIBLIOTECA, U_DM, SqlExpr, U_DMPESQ, U_ENTRECOMNUMEROPROCESSO,
  DBClient;


{$R *.dfm}

procedure TF_CONSPADRAO.FormCreate(Sender: TObject);
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

    //Recebe a data atual por padr�o  
    lblDataDoDia.Caption         := DateToStr(now);
    lblHoraAtual.Caption         := timetoStr(time);
    pan_titulo.Caption           := 'CONSULTA '+UpperCase(RetornaNomeFormacaoPlural(IdTipoFormacao));
    lblConselho.Caption          := UpperCase(RetornaNomeConselho(IdTipoFormacao));
    //ShowMessage('Imprimiu relatorio...: '+BoolToStr(imprimiuRelatorio));
end;

procedure TF_CONSPADRAO.FormShow(Sender: TObject);
begin
    DBDATA.Text        :=  datetostr(NOW);
    MostrarIDUltimoReg(nomeTabela,edtIDUltimoReg);
    edtNome.SetFocus;
    LogOperacoes(NomeDoUsuarioLogado, 'acesso a consulta de '+lowercase(nomedaformacao));
    posicaoInicial := StrToInt(DBCLASSINI.Text);  //definindo posi��o inicial para os relatorios
    IDCredenciado  := StrToInt(DBID.Text);
    MostrarNomeDoCadastrante;
    HabiltarDesabilitarBotao;
    AtualizaQde(DM.CDS_CONSULTAS,txtMsg);
    self.Caption := 'Logado por : '+PrimeirasLetrasMaiusculas(NomeDoUsuarioLogado);

    //mostrar os processos do credenciado selecionado
    numConselho := DBCrea.Text;
    ProcessosDoCredenciado;

end;

procedure TF_CONSPADRAO.ProcessosDoCredenciado;
begin
      MostrarProcessosDoCredenciado(numConselho,GridProcessos);
end;

procedure TF_CONSPADRAO.AbrirTabelas;
begin
    DM.CDS_CONSULTAS.Active              := TRUE;
    DM.CDS_CONSULTAS.First;

end;

procedure TF_CONSPADRAO.FecharTabelas;
begin
    DM.CDS_CONSULTAS.Active              := FALSE;

end;

procedure TF_CONSPADRAO.FecharAbrirTabelas;
begin 
    DM.CDS_CONSULTAS.Active            := FALSE;
    DM.CDS_CONSULTAS.Active            := TRUE;

end;

procedure TF_CONSPADRAO.btnSairClick(Sender: TObject);
begin
  close;
  Release;

end;

procedure TF_CONSPADRAO.FormKeyPress(Sender: TObject; var Key: Char);
begin

    // Enter por Tab
    //verifica se a tecla pressionada � a tecla ENTER, conhecida pelo Delphi como #13
    If key = #13 then
    Begin
    //se for, passa o foco para o pr�ximo campo, zerando o valor da vari�vel Key
    Key:= #0;
    Perform(Wm_NextDlgCtl,0,0);
    end;

end;

procedure TF_CONSPADRAO.PesquisarPorNome;
var
  nome : string;
begin
      lblATRIBUIDOR.Caption := '';
      nome  := edtNome.Text;
      _Sql  := 'SELECT * FROM '+nomeTabela+' WHERE nome LIKE (''%'+nome+'%'') AND status='+QuotedStr('ATIVO')+''+
               'and tipo_id = :pID ORDER BY Nome';

      with DM.CDS_CONSULTAS do
      begin
            Close;
            CommandText:= (_Sql);
            Params.ParamByName('pID').AsInteger := IdTipoFormacao;
            Open;

      end;
      AtualizaQde(DM.CDS_CONSULTAS,txtMsg);

end;

procedure TF_CONSPADRAO.edtNomeChange(Sender: TObject);
begin
    PesquisarPorNome;
end;

procedure TF_CONSPADRAO.edtNomeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      if KEY = VK_RETURN then
      begin
          edtNome.Clear;
          edtNome.SetFocus;

      end; 
end;

procedure TF_CONSPADRAO.GridCredenciadosCellClick(Column: TColumn);
begin
   VerificarStatus;
   edtNome.SetFocus;
   posicaoInicial  := DM.CDS_CONSULTAS.fieldbyname('posicao_inicial').AsInteger; //definindo posi��o inicial para os relatorios
   IDCredenciado   := DM.CDS_CONSULTAS.fieldbyname('id_credenciado').AsInteger;
   numConselho     := DM.CDS_CONSULTAS.fieldbyname('conselho').AsString;
   nomeConselho    := RetornaNomeConselho(DM.CDS_CONSULTAS.fieldbyname('tipo_id').AsInteger);
   MostrarNomeDoCadastrante;

end;

procedure TF_CONSPADRAO.AtribuirProcesso;
begin
        //gravar um novo ID para o credenciado colocando-o no fim da tabela
        idAtual  := StrToInt(DBID.Text);
        ultimoID := StrToInt(edtIDUltimoReg.Text)+1;

        With DM.QRY_GERAL do
        begin
              Close;
              SQL.Clear;
              SQL.Add('UPDATE '+nomeTabela+' SET id_credenciado = :pUltimoID, atribuido='+QuotedStr('S')+' WHERE id_credenciado = :pID');
              ParamByName('pUltimoID').AsInteger      := ultimoID;
              ParamByName('pID').AsInteger            := idAtual;
              ExecSQL();

        end;

         //gravar o processo na tabela de processos ===============================================================================

         With DM.QRY_GERAL do
         begin
              Close;
              SQL.Clear;
              SQL.Add('INSERT INTO tbl_processos (conselhoproc, numero, atribuidorid, dataatrib, datacad, complemento, formacaoid) VALUES '+
              '(:pConselhoProc, :pNumero, :pAtribuidorid, :pDataAtrib, :pData, :pComplemento, :pFormacaoid)');
              ParamByName('pConselhoProc').AsString    := DBCrea.Text;
              ParamByName('pNumero').AsString          := NumProcesso;
              ParamByName('pAtribuidorid').AsInteger   := IdDoUsuarioLogado;
              ParamByName('pDataAtrib').AsString       := DateToStr(now);
              ParamByName('pData').AsString            := DateToStr(now);
              ParamByName('pComplemento').AsString     := complementoProc;
              ParamByName('pFormacaoid').AsInteger     := IdTipoFormacao;
              ExecSQL();

          end;

        //=========================================================================================================================

        clicouNaoAtribuidos:=false;
        FecharAbrirTabelas;
        MostrarIDUltimoReg(nomeTabela,edtIDUltimoReg);
        NumProcesso              := '';
        btnAtribuirProc.Enabled  := false;
        pan_titulo.Font.Color    := clWhite;

end;

procedure TF_CONSPADRAO.btnAtribuirProcClick(Sender: TObject);
begin
       Application.CreateForm(TF_NumProcesso,  F_NumProcesso);
       F_NumProcesso.ShowModal;
       FreeAndNil(F_NumProcesso);

          if( inseriuProcesso )then
          begin
             //permitir atribui��o livre para os administradores e somente para o primeiro da lista para usuarios
             texto:= 'Confirma a atribui��o de processo ao '+lowercase(nomedaformacao)+' selecionado?';
             if Application.MessageBox(PChar(texto),'Atribuindo Processo',MB_YESNO + MB_ICONQUESTION) = IdYes then
             begin
                 AtribuirProcesso;
                 Application.MessageBox('Processo atribuido com sucesso!',
                 'Atribuindo Processo', MB_OK + MB_ICONINFORMATION);
                 LogOperacoes(NomeDoUsuarioLogado, 'atribuicao do processo n. '+numProcDigitado+' ao '+lowercase(nomedaformacao)+' conselho n. '+numConselho);

                 MostrarIDUltimoReg(nomeTabela,edtIDUltimoReg);
                 {COLOQUEI UM BOT�O PARA O ADMINISTRADOR D631863 retirar o status de atribuido para todos os credenciados caso todos estejam credenciados
                 : a fila recome�a ou seja ao atribuir o ultimo automaticamente a fila recome�a}
                 RetirarAtribuicoes(DM.CDS_CONSULTAS,nomeTabela,btnAtribuirProc);

                 FecharAbrirTabelas;
                 MostrarNaoAtribuidos;
                 AtualizaQde(DM.CDS_CONSULTAS,txtMsg);
                 HabiltarDesabilitarBotao;

             end else begin
                 Application.MessageBox('A atribui��o foi cancelada com sucesso!', 'Atribui��o de Processo cancelada', MB_OK + MB_ICONINFORMATION);
                 btnAtribuirProc.Enabled:=false;
                 btnMostrarAtribuidosClick(self);

             end;
          end else begin
               Application.MessageBox('A atribui��o foi cancelada com sucesso!', 'Atribui��o de Processo cancelada', MB_OK + MB_ICONINFORMATION);
               btnAtribuirProc.Enabled:=false;
               btnMostrarAtribuidosClick(self);

          end;
          GridProcessos.DataSource  := nil; //limpando o grid
end;

procedure TF_CONSPADRAO.GridCredenciadosDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
     with GridCredenciados do
      begin
        if DataSource.DataSet.FieldByName('atribuido').AsString = 'S' then
        begin
              Canvas.Font.Style  := [fsBold];
              Canvas.Font.Color  := clRed;

         end else
         begin
             Canvas.Font.Style  := [fsBold];
             Canvas.Font.Color  := clBlue;

         end;

         //dando cor � linha selecionada
         if gdSelected in State then
         begin

              if DataSource.DataSet.FieldByName('atribuido').AsString = 'S' then
              begin
                    Canvas.Brush.Color := clSkyBlue;   //cor de fundo da linha
                    Canvas.Font.Color  := clred;       //cor da letra

              end else
              begin
                    Canvas.Brush.Color := clSkyBlue;   //cor de fundo da linha
                    Canvas.Font.Color  := clblack;     //cor da letra

              end;
         end;
         Canvas.FillRect(Rect);
         DefaultDrawColumnCell(Rect,DataCol,Column,State);

     end;

end;

procedure TF_CONSPADRAO.VerificarStatus;
begin
    //mostra se esta com processo atribuido ou nao
    MostrarStatus;

    //libera atribui��o
    if (nivelDeAcesso <3)then
    begin
       LiberarAtribuicao(nomeTabela,btnAtribuirProc,DBID,pan_titulo);
       IdCredenciado:= DM.CDS_CONSULTAS.fieldbyname('ID_CREDENCIADO').AsInteger;
       edtNome.SetFocus;
       ProcessosDoCredenciado;
    end;   
end;

procedure TF_CONSPADRAO.btnCurriculumClick(Sender: TObject);
begin
     //se achar o curriculum mostre caso contr�rio abra op��o de cadastro
     exibirCurriculum;

     LogOperacoes(NomeDoUsuarioLogado, 'visualizacao de curriculum de '+lowercase(nomedaformacao)+' conselho n. '+numConselho);
end;

procedure TF_CONSPADRAO.CopiarCurriculumPdf;
var
   caminhoDaPasta, novoNomePDF, arquivoEscolhido : string;   
begin

    if openCurriculum.Execute then
    begin 
         arquivoEscolhido    := openCurriculum.FileName;
         caminhoDaPasta      := ExtractFilePath(Application.ExeName)+'Curriculuns\';
         novoNomePDF         := caminhoDaPasta +DBNome.Text+'.PDF';
         CopiarArquivo(arquivoEscolhido,novoNomePDF);

    end;
    Application.MessageBox('Curriculum cadastrado com sucesso!',
         'Cadastrado!', MB_OK + MB_ICONEXCLAMATION);
end;


procedure TF_CONSPADRAO.exibirCurriculum;
var
   caminhoDoPDF, nomePDF : string;
begin
    //todos os PDF dever�o conter o nome de seus donos ex: LINOSMAR.PDF
    nomePDF      := trim(DBNome.Text)+'.PDF';
    caminhoDoPDF :=  ExtractFilePath(Application.ExeName)+'Curriculuns\'+nomePDF;

    //ShowMessage(caminhoDoPDF);

    //se o PDF existir abra-o
    if FileExists(caminhoDoPDF) then
    begin
        OleContainer1.Visible      := true;
        OleContainer1.AutoActivate := aaGetFocus;
        OleContainer1.CreateLinkToFile(caminhoDoPDF, True);
        OleContainer1.SetFocus;
        LogOperacoes(NomeDoUsuarioLogado, 'exibi��o de curriculum de de '+lowercase(nomedaformacao)+' conselho n. '+numConselho);
        close;
    end else
    begin
         Application.MessageBox('Aten��o curriculum n�o cadastrado, cadastre-o agora...',
         'Curriculum n�o encontrado!', MB_OK + MB_ICONEXCLAMATION);
         CopiarCurriculumPdf;
         exit;

    end;

end;

procedure TF_CONSPADRAO.MostrarNaoAtribuidos;
begin
    With DM.CDS_CONSULTAS do
    begin
          Close;
          CommandText:=('SELECT * FROM '+nomeTabela+' WHERE atribuido = '+QuotedStr('N')+' and status='+QuotedStr('ATIVO')+' ORDER BY nome');
          open;

          if IsEmpty then
          begin
              texto:='Nenhum '+LetrasIniciaisMaiusculas(nomeDaFormacao)+' sem processo atribuido encontrado!';
              Application.MessageBox(PChar(texto),'N�o encontrado!',MB_OK + MB_ICONINFORMATION);
              pan_titulo.Caption  := 'CONSULTA '+UpperCase(nomeDaFormacao);
              GridProcessos.DataSource := nil;
              btnImprimir.Enabled      := false;
              btnCurriculum.Enabled    := false;
              btnMostrarAtribuidosClick(self);

          end else begin
              ProcessosDoCredenciado;
              btnImprimir.Enabled      := true;
              btnCurriculum.Enabled    := true;

          end;
    end;

end;

procedure TF_CONSPADRAO.MostrarParaAtribuicao;
begin
    With DM.CDS_CONSULTAS do
    begin
          Close;
          CommandText:=('SELECT * FROM '+nomeTabela+' WHERE atribuido = '+QuotedStr('N')+' and status='+QuotedStr('ATIVO')+' ORDER BY posicao_inicial');
          open;

          if IsEmpty then
          begin
              texto:='Nenhum '+LetrasIniciaisMaiusculas(nomeDaFormacao)+' sem processo atribuido encontrado!';
              Application.MessageBox(PChar(texto),'N�o encontrado!',MB_OK + MB_ICONINFORMATION);
              pan_titulo.Caption  := 'CONSULTANDO '+UpperCase(nomeDaFormacao);
              GridProcessos.DataSource := nil;
              btnImprimir.Enabled      := false;
              btnCurriculum.Enabled    := false;

          end else begin
              ProcessosDoCredenciado;
              btnImprimir.Enabled      := true;
              btnCurriculum.Enabled    := true;

          end;
    end;

end;

procedure TF_CONSPADRAO.btnLiberarAtribuicaoClick(Sender: TObject);
begin
    clicouNaoAtribuidos:=true; //para efetivar libera��o do bot�o atribuir => MostrarStatus
    FecharAbrirTabelas;
    MostrarParaAtribuicao;
    AtualizaQde(DM.CDS_CONSULTAS,txtMsg);
    MostrarStatus;
    if ( nivelDeAcesso >= 3 ) then
    begin
        pan_titulo.Caption    := 'ATRIBUI��O N�O DISPON�VEL PARA ESTE USU�RIO';
    end else
    begin
        pan_titulo.Caption    := 'DISPONIVEIS PARA ATRIBUI��O SELECIONE O PRIMEIRO DA LISTA';
        pan_titulo.Font.Color := clYellow;

    end;
    btnAtribuirProc.Enabled:=false;
    GridProcessos.DataSource  := nil; //limpando o grid
end;

procedure TF_CONSPADRAO.MostrarAtribuidos;
begin
    With DM.CDS_CONSULTAS do
    begin
          Close;
          CommandText:=('SELECT * FROM '+nomeTabela+' WHERE atribuido = '+QuotedStr('S')+' and status='+QuotedStr('ATIVO')+' ORDER BY nome');
          open;

          if not IsEmpty then
          begin
              ProcessosDoCredenciado;
              btnImprimir.Enabled      := true;
              btnCurriculum.Enabled    := true;

          end else
          begin
              texto:='Nenhum '+nomeDaFormacao+' com processo atribuido encontrado!';
              Application.MessageBox(PChar(texto),'N�o encontrado!',MB_OK + MB_ICONINFORMATION);
              GridProcessos.DataSource := nil;
              btnImprimir.Enabled      := false;
              btnCurriculum.Enabled    := false;

          end;

    end;

    pan_titulo.Font.Color   := clWhite;
    pan_titulo.Caption      := 'VISUALIZA '+UpperCase(RetornaNomeFormacaoPlural(IdTipoFormacao))+' COM ATRIBUI��O';
    AtualizaQde(DM.CDS_CONSULTAS,txtMsg);

end;

procedure TF_CONSPADRAO.btnMostrarAtribuidosClick(Sender: TObject);
begin
    clicouNaoAtribuidos := false;
    FecharAbrirTabelas;
    MostrarAtribuidos;
    AtualizaQde(DM.CDS_CONSULTAS,txtMsg);
    MostrarStatus;
    btnAtribuirProc.Enabled:=false;
    GridProcessos.DataSource  := nil; //limpando o grid
end;


procedure TF_CONSPADRAO.MostrarStatus;
begin
     IDPrimeiroReg           := 0;
     imprimiuRelatorio       := false;
     DM.CDS_CONSULTAS.Active := true; 
     if ( DM.CDS_CONSULTAS.fieldbyname('atribuido').AsString = 'S')then
     begin
          lblStatus.Caption            := 'COM PROCESSO ATRIBUIDO';
          lblStatus.Font.Color         := clRed;

     end else
     begin
          lblStatus.Caption            := 'SEM PROCESSO ATRIBUIDO NO MOMENTO';
          lblStatus.Font.Color         := clBlue;

     end;
     lblATRIBUIDOR.Caption      :='';
     DBCLASSINI.Field.Alignment := taCenter;  //centralizando os dados no dbedit
     
end;

procedure TF_CONSPADRAO.MostrarNomeDoAtribuidor;
begin
    _Sql:= 'SELECT u.nome, p.id_processo, p.atribuidorid FROM tbl_usuarios u, tbl_processos p WHERE u.id_usuario=p.atribuidorid and p.id_processo=:pID';
    With DM.QRY_GERAL do
    begin
          Close;
          SQL.Clear;
          SQL.Add(_Sql);
          Params.ParamByName('pID').AsInteger:= idProcesso;
          open;

          if not IsEmpty then
          begin
              lblATRIBUIDOR.Caption    := DM.QRY_GERAL.fieldbyname('nome').AsString;

          end else begin
              lblATRIBUIDOR.Caption:= '';

          end;
    end;

end;

procedure TF_CONSPADRAO.MostrarNomeDoCadastrante;
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

procedure TF_CONSPADRAO.GridProcessosCellClick(Column: TColumn);
begin
idProcesso := DM.CDS_PROCESSOS.fieldbyname('id_processo').AsInteger;
MostrarNomeDoAtribuidor;

end;

procedure TF_CONSPADRAO.btnImprimirClick(Sender: TObject);
begin

   if (temImpressoraPadrao)then
   begin

        //ShowMessage('NUMERO DO CONSELHO...: '+numConselho);
        imprimiuRelatorio := true;
        //ShowMessage('Imprimiu relatorio...: '+BoolToStr(imprimiuRelatorio));
        With DMPESQ.QRY_GERAL do
        begin
            Close;
            SQL.Clear;
            SQL.Add('select c.*, p.* FROM '+nomeTabela+' c, tbl_processos p WHERE c.conselho = p.conselhoproc and c.conselho=:pConselho AND formacaoid=:pIDFormacao');
            Params.ParamByName('pConselho').AsString          := numConselho;
            Params.ParamByName('pIDFormacao').AsInteger       := IdTipoFormacao;
            Open;

              if not IsEmpty then
              begin

                ImprimirVersaoCompleta(nomeTabela,numConselho);

              end else begin

                 ImprimirVersaoParcial(nomeTabela,numConselho);

              end;
          end;

          LogOperacoes(NomeDoUsuarioLogado, 'impress�o de relat�rio de '+lowercase(nomedaformacao)+' conselho n. '+numConselho);
          GridProcessos.DataSource  := nil; //limpando o grid
          imprimiuRelatorio         := false;

   end;

end;

procedure TF_CONSPADRAO.RecomecarFila;
begin
    //retirar o status de atribuido para todos os credenciados caso todos estejam credenciados : a fila recome�a
    RetirarAtribuicoes(DM.CDS_CONSULTAS,nomeTabela,btnAtribuirProc);
    texto:='A fila dos '+RetornaNomeFormacaoPlural(IdTipoFormacao)+' foi reiniciada com sucesso!';
    Application.MessageBox(PChar(texto),'Reinicializa��o de fila',MB_OK + MB_ICONINFORMATION);
    HabiltarDesabilitarBotao;
    btnMostrarNaoAtribuidosClick(self);
    LogOperacoes(NomeDoUsuarioLogado, 'Recomeco de fila para '+RetornaNomeFormacaoPlural(IdTipoFormacao));

end;

procedure TF_CONSPADRAO.btnRecomecarFilaClick(Sender: TObject);
begin
  texto:= 'Confirma o recome�o de fila para os '+RetornaNomeFormacaoPlural(IdTipoFormacao)+' ?';

 if Application.MessageBox(PChar(texto),'Recome�ando a fila',MB_YESNO + MB_ICONQUESTION) = IdYes then
  begin
     RecomecarFila;

  end else
  begin
     exit;

  end;
end;

procedure TF_CONSPADRAO.btnMostrarNaoAtribuidosClick(Sender: TObject);
begin
    FecharAbrirTabelas;
    MostrarNaoAtribuidos;
    AtualizaQde(DM.CDS_CONSULTAS,txtMsg);
    MostrarStatus;
    if ( nivelDeAcesso >= 3 ) then
    begin
       pan_titulo.Caption       := 'ATRIBUI��O N�O DISPON�VEL PARA ESTE USU�RIO';
    end else
    begin
        if(NaoTemAtribuido(nomeTabela))then
        begin
          pan_titulo.Caption    := 'VISUALIZA '+UpperCase(RetornaNomeFormacaoPlural(IdTipoFormacao))+' SEM ATRIBUI��O';
          pan_titulo.Font.Color := clWhite;
        end else begin
          pan_titulo.Caption    := 'DISPONIVEIS PARA ATRIBUI��O';
          pan_titulo.Font.Color := clYellow;
        end;
    end;
    btnAtribuirProc.Enabled:=false;
    GridProcessos.DataSource  := nil; //limpando o grid
end;

procedure TF_CONSPADRAO.HabiltarDesabilitarBotao;
begin
        if ( nivelDeAcesso >= 2 ) then
        begin
           //btnRecomecarFila.Visible := false;  //botao liberado somente para o ADMINISTRADOR
        end;

         //botao Mostrar n�o Atribuidos - se nao encontrar nenhum atribuido='N' na tabela
         if(NaoTemAtribuido(nomeTabela))then
         begin
             btnMostrarNaoAtribuidos.Enabled :=true;
             btnLiberarAtribuicao.Enabled    :=true;
             //btnRecomecarFila.Enabled        :=false;
         end else begin
             btnMostrarNaoAtribuidos.Enabled :=false;
             btnLiberarAtribuicao.Enabled    :=false;
             //btnRecomecarFila.Enabled        :=true;
         end;

         //botao Mostrar Atribuidos
         if (TemAtribuido(nomeTabela))then
             btnMostrarAtribuidos.Enabled:=true
         else
             btnMostrarAtribuidos.Enabled:=false;

          if ( nivelDeAcesso >= 3 ) then
          begin
             btnAtribuirProc.Enabled      := false;    //botao desabilitado aos usuarios
             btnLiberarAtribuicao.Enabled :=false;
             //btnRecomecarFila.Visible     :=false;
          end;  

end;   



end.


