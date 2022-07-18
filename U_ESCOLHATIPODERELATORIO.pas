unit U_ESCOLHATIPODERELATORIO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Grids, DBGrids, Mask, DBCtrls;

type
  TF_ESCOLHATIPORELATORIO = class(TForm)
    pnl_cabecalho: TPanel;
    pnl1: TPanel;
    pnl_rodape: TPanel;
    lstOpcoes: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure lstOpcoesClick(Sender: TObject);
    procedure pnl_rodapeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  F_ESCOLHATIPORELATORIO: TF_ESCOLHATIPORELATORIO;

implementation

uses U_BIBLIOTECA, U_DM, SqlExpr, U_DMPESQ, U_RELATORIOS, DBClient, DB;

{$R *.dfm}

procedure TF_ESCOLHATIPORELATORIO.FormCreate(Sender: TObject);
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

procedure TF_ESCOLHATIPORELATORIO.lstOpcoesClick(
  Sender: TObject);
var lblTitulos : string;
begin
     if lstOpcoes.Items[lstOpcoes.ItemIndex] = 'TODOS POR ORDEM ALFABETICA' then
     begin 
           Application.CreateForm(TQ_RELATORIOS,  Q_RELATORIOS);
          // abre o relatorio com todos os credenciados da tabela selecionada por ordem alfabetica
          with Q_RELATORIOS.SQL_RELATORIOS do
          begin
             Close;
             CommandText := 'SELECT * FROM '+nomeTabela+' ORDER BY nome';
             open;

          end;

           with Q_RELATORIOS.CDS_RELATORIOS do
           begin
              Close;
              CommandText := 'SELECT * FROM '+nomeTabela+' ORDER BY nome';
              Open;

              if not IsEmpty then begin
                 TotalRegs := Q_RELATORIOS.CDS_RELATORIOS.RecordCount;

              end;

               lblTitulos := 'LISTA '+nomeDaFormacao+' POR ORDEM ALFABÉTICA';
               Q_RELATORIOS.QRLabelTotal.Caption     := IntToStr(TotalRegs);
               Q_RELATORIOS.lblTitulo.Caption        := lblTitulos;
               Q_RELATORIOS.ReportTitle              := lblTitulos;
               Q_RELATORIOS.lblDocumento.Caption     := nomeDocOficial;
               Q_RELATORIOS.nomeDetalhe.Caption      := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('NOME').AsString;
               Q_RELATORIOS.documentoDetalhe.Caption := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('CONSELHO').AsString;
               Q_RELATORIOS.posicaoDetalhe.Caption   := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('POSICAO_INICIAL').AsString;
               Q_RELATORIOS.cpfDetalhe.Caption       := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('CPF').AsString;
               Q_RELATORIOS.dataDetalhe.Caption      := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('DATACAD').AsString;
               Q_RELATORIOS.Preview;
               FreeAndNil(Q_RELATORIOS);
         end;
         
    end else if lstOpcoes.Items[lstOpcoes.ItemIndex] = 'TODOS POR ORDEM DE POSICAO INICIAL' then
    begin
          Application.CreateForm(TQ_RELATORIOS,  Q_RELATORIOS);
          // abre o relatorio com todos os credenciados cadastrados da tabela selecionada por ordem de posicao inicial
          with Q_RELATORIOS.SQL_RELATORIOS do
          begin
             Close;
             CommandText := 'SELECT * FROM '+nomeTabela+' ORDER BY posicao_inicial';
             open;

          end;

           with Q_RELATORIOS.CDS_RELATORIOS do
           begin
              Close;
              CommandText := 'SELECT * FROM '+nomeTabela+' ORDER BY posicao_inicial';
              Open;

              if not IsEmpty then begin
                 TotalRegs := Q_RELATORIOS.CDS_RELATORIOS.RecordCount;

              end;

               lblTitulos := 'LISTA '+nomeDaFormacao+' POR POSIÇÃO INICIAL';
               Q_RELATORIOS.QRLabelTotal.Caption     := IntToStr(TotalRegs);
               Q_RELATORIOS.lblTitulo.Caption        := lblTitulos;
               Q_RELATORIOS.ReportTitle              := lblTitulos;
               Q_RELATORIOS.lblDocumento.Caption     := nomeDocOficial;
               Q_RELATORIOS.nomeDetalhe.Caption      := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('NOME').AsString;
               Q_RELATORIOS.documentoDetalhe.Caption := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('CONSELHO').AsString;
               Q_RELATORIOS.posicaoDetalhe.Caption   := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('POSICAO_INICIAL').AsString;
               Q_RELATORIOS.cpfDetalhe.Caption       := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('CPF').AsString;
               Q_RELATORIOS.dataDetalhe.Caption      := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('DATACAD').AsString;
               Q_RELATORIOS.Preview;
               FreeAndNil(Q_RELATORIOS); 
         end;

    end else if lstOpcoes.Items[lstOpcoes.ItemIndex] = 'SOMENTE ATRIBUIDOS POR ORDEM ALFABETICA' then
    begin
          Application.CreateForm(TQ_RELATORIOS,  Q_RELATORIOS);
          // abre o relatorio com todos os credenciados da tabela selecionada com processos atribuidos por ordem alfabetica
          with Q_RELATORIOS.SQL_RELATORIOS do
          begin
             Close;
             CommandText := 'SELECT * FROM '+nomeTabela+' WHERE atribuido = '+QuotedStr('S')+' ORDER BY nome';
             open;

          end;

           with Q_RELATORIOS.CDS_RELATORIOS do
           begin
              Close;
              CommandText := 'SELECT * FROM '+nomeTabela+' WHERE atribuido = '+QuotedStr('S')+' ORDER BY nome';
              Open;

              if not IsEmpty then begin
                 TotalRegs := Q_RELATORIOS.CDS_RELATORIOS.RecordCount;

              end else
              begin
                ShowMessage('Não foram encontrados '+nomeDaFormacao+' com processos atribuidos no momento!');
                FreeAndNil(Q_RELATORIOS);
                exit;
              end;

               lblTitulos := 'LISTA '+nomeDaFormacao+' COM PROC. ATRIBUIDO POR ORDEM ALFABÉTICA';
               Q_RELATORIOS.QRLabelTotal.Caption     := IntToStr(TotalRegs);
               Q_RELATORIOS.lblTitulo.Caption        := lblTitulos;
               Q_RELATORIOS.ReportTitle              := lblTitulos;
               Q_RELATORIOS.lblDocumento.Caption     := nomeDocOficial;
               Q_RELATORIOS.nomeDetalhe.Caption      := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('NOME').AsString;
               Q_RELATORIOS.documentoDetalhe.Caption := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('CONSELHO').AsString;
               Q_RELATORIOS.posicaoDetalhe.Caption   := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('POSICAO_INICIAL').AsString;
               Q_RELATORIOS.cpfDetalhe.Caption       := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('CPF').AsString;
               Q_RELATORIOS.dataDetalhe.Caption      := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('DATACAD').AsString;
               Q_RELATORIOS.Preview;
               FreeAndNil(Q_RELATORIOS);
         end;

    end else if lstOpcoes.Items[lstOpcoes.ItemIndex] = 'SOMENTE   ATRIBUIDOS   POR   POSICAO  INICIAL' then
    begin
          Application.CreateForm(TQ_RELATORIOS,  Q_RELATORIOS);
          // abre o relatorio com todos os credenciados da tabela selecionada com processos atribuidos por ordem alfabetica
          with Q_RELATORIOS.SQL_RELATORIOS do
          begin
             Close;
             CommandText := 'SELECT * FROM '+nomeTabela+' WHERE atribuido = '+QuotedStr('S')+' ORDER BY posicao_inicial';
             open;

          end;

           with Q_RELATORIOS.CDS_RELATORIOS do
           begin
              Close;
              CommandText := 'SELECT * FROM '+nomeTabela+' WHERE atribuido = '+QuotedStr('S')+' ORDER BY posicao_inicial';
              Open;

              if not IsEmpty then begin
                 TotalRegs := Q_RELATORIOS.CDS_RELATORIOS.RecordCount;

              end else
              begin
                ShowMessage('Não foram encontrados '+nomeDaFormacao+' com processos atribuidos no momento!');
                FreeAndNil(Q_RELATORIOS);
                exit;
              end;

               lblTitulos := 'LISTA '+nomeDaFormacao+' COM PROC. ATRIBUIDO POR POSIÇÃO INICIAL';
               Q_RELATORIOS.QRLabelTotal.Caption     := IntToStr(TotalRegs);
               Q_RELATORIOS.lblTitulo.Caption        := lblTitulos;
               Q_RELATORIOS.ReportTitle              := lblTitulos;
               Q_RELATORIOS.lblDocumento.Caption     := nomeDocOficial;
               Q_RELATORIOS.nomeDetalhe.Caption      := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('NOME').AsString;
               Q_RELATORIOS.documentoDetalhe.Caption := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('CONSELHO').AsString;
               Q_RELATORIOS.posicaoDetalhe.Caption   := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('POSICAO_INICIAL').AsString;
               Q_RELATORIOS.cpfDetalhe.Caption       := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('CPF').AsString;
               Q_RELATORIOS.dataDetalhe.Caption      := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('DATACAD').AsString;
               Q_RELATORIOS.Preview;
               FreeAndNil(Q_RELATORIOS);
         end;


    end else if lstOpcoes.Items[lstOpcoes.ItemIndex] = 'SOMENTE NÃO ATRIBUIDOS POR ORDEM ALFABETICA' then
    begin
          Application.CreateForm(TQ_RELATORIOS,  Q_RELATORIOS);
          // abre o relatorio com todos os credenciados da tabela selecionada sem processos atribuidos por ordem de posicao inicial
          with Q_RELATORIOS.SQL_RELATORIOS do
          begin
             Close;
             CommandText := 'SELECT * FROM '+nomeTabela+' WHERE atribuido = '+QuotedStr('N')+' ORDER BY nome';
             open;

          end;

           with Q_RELATORIOS.CDS_RELATORIOS do
           begin
              Close;
              CommandText := 'SELECT * FROM '+nomeTabela+' WHERE atribuido = '+QuotedStr('N')+' ORDER BY nome';
              Open;

              if not IsEmpty then begin
                 TotalRegs := Q_RELATORIOS.CDS_RELATORIOS.RecordCount;

              end else
              begin
                ShowMessage('Não foram encontrados '+nomeDaFormacao+' sem processos atribuidos no momento!');
                FreeAndNil(Q_RELATORIOS);
                exit;
              end;

               lblTitulos := 'LISTA '+nomeDaFormacao+' SEM PROC. ATRIBUIDO POR ORDEM ALFABÉTICA';
               Q_RELATORIOS.QRLabelTotal.Caption     := IntToStr(TotalRegs);
               Q_RELATORIOS.lblTitulo.Caption        := lblTitulos;
               Q_RELATORIOS.ReportTitle              := lblTitulos;
               Q_RELATORIOS.lblDocumento.Caption     := nomeDocOficial;
               Q_RELATORIOS.nomeDetalhe.Caption      := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('NOME').AsString;
               Q_RELATORIOS.documentoDetalhe.Caption := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('CONSELHO').AsString;
               Q_RELATORIOS.posicaoDetalhe.Caption   := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('POSICAO_INICIAL').AsString;
               Q_RELATORIOS.cpfDetalhe.Caption       := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('CPF').AsString;
               Q_RELATORIOS.dataDetalhe.Caption      := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('DATACAD').AsString;
               Q_RELATORIOS.Preview;
               FreeAndNil(Q_RELATORIOS);
         end;

    end else if lstOpcoes.Items[lstOpcoes.ItemIndex] = 'SOMENTE NÃO ATRIBUIDOS POR POSICAO INICIAL' then
    begin
          Application.CreateForm(TQ_RELATORIOS,  Q_RELATORIOS);
          // abre o relatorio com todos os credenciados da tabela selecionada sem processos atribuidos por ordem de posicao inicial
          with Q_RELATORIOS.SQL_RELATORIOS do
          begin
             Close;
             CommandText := 'SELECT * FROM '+nomeTabela+' WHERE atribuido = '+QuotedStr('N')+' ORDER BY posicao_inicial';
             open;

          end;

           with Q_RELATORIOS.CDS_RELATORIOS do
           begin
              Close;
              CommandText := 'SELECT * FROM '+nomeTabela+' WHERE atribuido = '+QuotedStr('N')+' ORDER BY posicao_inicial';
              Open;

              if not IsEmpty then begin
                 TotalRegs := Q_RELATORIOS.CDS_RELATORIOS.RecordCount;

              end else
              begin
                ShowMessage('Não foram encontrados '+nomeDaFormacao+' sem processos atribuidos no momento!');
                FreeAndNil(Q_RELATORIOS);
                exit;
              end;

               lblTitulos := 'LISTA '+nomeDaFormacao+' SEM PROC. ATRIBUIDO POR POSIÇÃO INICIAL';
               Q_RELATORIOS.QRLabelTotal.Caption     := IntToStr(TotalRegs);
               Q_RELATORIOS.lblTitulo.Caption        := lblTitulos;
               Q_RELATORIOS.ReportTitle              := lblTitulos;
               Q_RELATORIOS.lblDocumento.Caption     := nomeDocOficial;
               Q_RELATORIOS.nomeDetalhe.Caption      := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('NOME').AsString;
               Q_RELATORIOS.documentoDetalhe.Caption := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('CONSELHO').AsString;
               Q_RELATORIOS.posicaoDetalhe.Caption   := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('POSICAO_INICIAL').AsString;
               Q_RELATORIOS.cpfDetalhe.Caption       := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('CPF').AsString;
               Q_RELATORIOS.dataDetalhe.Caption      := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('DATACAD').AsString;
               Q_RELATORIOS.Preview;
               FreeAndNil(Q_RELATORIOS);
         end;

    end else if lstOpcoes.Items[lstOpcoes.ItemIndex] = 'SOMENTE CREDENCIADOS INATIVOS' then
    begin
          Application.CreateForm(TQ_RELATORIOS,  Q_RELATORIOS);
          // abre o relatorio com todos os credenciados da tabela selecionada e que esteja inativados
          with Q_RELATORIOS.SQL_RELATORIOS do
          begin
             Close;
             CommandText := 'SELECT * FROM '+nomeTabela+' WHERE status = '+QuotedStr('INATIVO')+' ORDER BY posicao_inicial';
             open;

          end;

           with Q_RELATORIOS.CDS_RELATORIOS do
           begin
              Close;
              CommandText := 'SELECT * FROM '+nomeTabela+' WHERE status = '+QuotedStr('INATIVO')+' ORDER BY posicao_inicial';
              Open;

              if not IsEmpty then begin
                 TotalRegs := Q_RELATORIOS.CDS_RELATORIOS.RecordCount;

              end else
              begin
                ShowMessage('Não foram encontrados '+RetornaNomeFormacaoPlural(IdTipoFormacao)+' inativados no momento!');
                FreeAndNil(Q_RELATORIOS);
                exit;
              end;

               lblTitulos := 'LISTA '+nomeDaFormacao+' INATIVOS NO SISTEMA';
               Q_RELATORIOS.QRLabelTotal.Caption     := IntToStr(TotalRegs);
               Q_RELATORIOS.lblTitulo.Caption        := lblTitulos;
               Q_RELATORIOS.ReportTitle              := lblTitulos;
               Q_RELATORIOS.lblDocumento.Caption     := nomeDocOficial;
               Q_RELATORIOS.nomeDetalhe.Caption      := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('NOME').AsString;
               Q_RELATORIOS.documentoDetalhe.Caption := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('CONSELHO').AsString;
               Q_RELATORIOS.posicaoDetalhe.Caption   := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('POSICAO_INICIAL').AsString;
               Q_RELATORIOS.cpfDetalhe.Caption       := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('CPF').AsString;
               Q_RELATORIOS.dataDetalhe.Caption      := Q_RELATORIOS.CDS_RELATORIOS.fieldbyname('DATACAD').AsString;
               Q_RELATORIOS.Preview;
               FreeAndNil(Q_RELATORIOS);
         end;
    end;
end;

procedure TF_ESCOLHATIPORELATORIO.pnl_rodapeClick(
  Sender: TObject);
begin
     nomeTabela     := '';
     nomeDaFormacao := '';
     nomeDocOficial := '';

     close;
     Release;

end;

procedure TF_ESCOLHATIPORELATORIO.FormShow(Sender: TObject);
begin
    pnl_cabecalho.Caption :=  'Qual relatório deseja emitir para ' + nomeDaFormacao + '?';
end;

procedure TF_ESCOLHATIPORELATORIO.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
FreeAndNil(Q_RELATORIOS);
end;

end.
