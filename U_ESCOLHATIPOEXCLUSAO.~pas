unit U_ESCOLHATIPOEXCLUSAO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TF_ESCOLHATIPOEXCLUSAO = class(TForm)
    pnl_cabecalho: TPanel;
    pnl_rodape: TPanel;
    pnl1: TPanel;
    chkCredenciado: TCheckBox;
    chkCurriculum: TCheckBox;
    lblHoraAtual: TLabel;
    lblDataDoDia: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure chkCredenciadoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkCurriculumClick(Sender: TObject);
    procedure pnl_rodapeClick(Sender: TObject);
    procedure DeletarCurriculumPDF;
    procedure Atualizar;
    procedure ExcluirProcessos(posicaoIni, formacaoId : integer);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_ESCOLHATIPOEXCLUSAO: TF_ESCOLHATIPOEXCLUSAO;

implementation

uses U_BIBLIOTECA, U_DM, SqlExpr, U_DMPESQ, U_CHECKDOC, U_CADPADRAO;


{$R *.dfm}

procedure TF_ESCOLHATIPOEXCLUSAO.FormCreate(Sender: TObject);
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
    lblDataDoDia.Caption    :=  DateToStr(now);
    lblHoraAtual.Caption    :=  timetoStr(time);

end;


procedure TF_ESCOLHATIPOEXCLUSAO.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     Close;
     Release;

end;

procedure TF_ESCOLHATIPOEXCLUSAO.ExcluirProcessos(posicaoIni, formacaoId: integer);
begin
      With DM.QRY_GERAL do
      begin
            Close;
            SQL.Clear;
            SQL.Add('delete from tbl_processos WHERE posicao_inicial = :pPosicaoInicial and formacaoId=:pFormacao');
            ParamByName('pPosicaoInicial').AsInteger := posicaoIni;
            ParamByName('pFormacao').AsInteger       := formacaoId;
            ExecSQL();

      end;
end;


procedure TF_ESCOLHATIPOEXCLUSAO.chkCredenciadoClick(Sender: TObject);
begin
     texto:= 'Confirma a exclusão do credenciado selecionado?';
     if Application.MessageBox(PChar(texto),'Excluíndo credenciado',MB_YESNO + MB_ICONQUESTION) = IdYes then
     begin
            With DM.QRY_GERAL do
            begin
                  Close;
                  SQL.Clear;
                  SQL.Add('delete from '+nomeTabelaExclusao+' WHERE id_credenciado = :pID');
                  ParamByName('pID').AsInteger := IdExclusao;
                  ExecSQL();

            end;
            ExcluirProcessos(posicaoInicial,IdTipoFormacao);

            DeleteFile(nomeArquivoPDFExclusao);
            Atualizar;
            Application.MessageBox('O credenciado foi excluído com sucesso!',
            'Excluído', MB_OK + MB_ICONINFORMATION);
            close;

       end else
       begin
          close;

       end;       

end;

procedure TF_ESCOLHATIPOEXCLUSAO.Atualizar;
begin

       if ( nomeTabelaExclusao = 'tbl_engenheirocivil') then
       begin
                F_CADPADRAO.AtualizarAposDelecao;
                F_CADPADRAO.FecharAbrirTabelas;
       end else
       if ( nomeTabelaExclusao = 'tbl_engenheiroambiental') then
       begin
                F_CADPADRAO.AtualizarAposDelecao;
                F_CADPADRAO.FecharAbrirTabelas;
       end else
       if ( nomeTabelaExclusao = 'tbl_arquiteto') then
       begin
                F_CADPADRAO.AtualizarAposDelecao;
                F_CADPADRAO.FecharAbrirTabelas;
       end else
       if ( nomeTabelaExclusao = 'tbl_contador') then
       begin
                F_CADPADRAO.AtualizarAposDelecao;
                F_CADPADRAO.FecharAbrirTabelas;
       end;

end;

procedure TF_ESCOLHATIPOEXCLUSAO.DeletarCurriculumPDF;
begin 
     //o nome do PDF para deleção esta vindo do formulario
     texto:= 'Confirma a exclusão do curriculum do credenciado selecionado?';

     if Application.MessageBox(PChar(texto),'Exclusão de Curriculum',MB_YESNO + MB_ICONQUESTION) = IdYes then
     begin
          DeleteFile(nomeArquivoPDFExclusao);
          Application.MessageBox('O curriculum foi excluído com sucesso!', 'Exclusão de Curriculum', MB_OK + MB_ICONINFORMATION);

     end else
     begin
         exit;

     end;

end;

procedure TF_ESCOLHATIPOEXCLUSAO.chkCurriculumClick(Sender: TObject);
begin
      if chkCurriculum.Checked then
      begin
         DeletarCurriculumPDF;
         chkCurriculum.Checked  := False;
         chkCredenciado.Checked := False;
         Close;
         Release;

      end;

end;

procedure TF_ESCOLHATIPOEXCLUSAO.pnl_rodapeClick(Sender: TObject);
begin
     close;
     Release;

end;

end.
