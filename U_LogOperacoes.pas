unit U_LogOperacoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, Mask, DBCtrls,SqlExpr, Printers,
  ToolEdit;

type
  TF_CONSLOGOPERACOES = class(TForm)
    pan_titulo: TPanel;
    lblDataDoDia: TLabel;
    lblHoraAtual: TLabel;
    grp10: TGroupBox;
    btn_Sair: TSpeedButton;
    lbl52: TLabel;
    edt_DataInicio: TDateEdit;
    lbl53: TLabel;
    edt_DataFim: TDateEdit;
    btnPesquisarPeriodo: TSpeedButton;
    grid_VisualizaProdutos: TDBGrid;
    btnLimpar: TSpeedButton;
    btnApagarTabelaLog: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure AbrirTabelas;
    procedure ApagarTabelaLogs;
    procedure btn_SairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FiltrarPorPeriodo;
    procedure btnPesquisarPeriodoClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnApagarTabelaLogClick(Sender: TObject);



  private
    { Private declarations }

  public
    { Public declarations }

  end;

var
  F_CONSLOGOPERACOES: TF_CONSLOGOPERACOES;


implementation

uses  U_BIBLIOTECA, U_DM, U_DMPESQ;

{$R *.dfm}


procedure TF_CONSLOGOPERACOES.FormCreate(Sender: TObject);
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
    lblDataDoDia.Caption    :=  DateToStr(date);
    lblHoraAtual.Caption    :=  timetoStr(time);
    AbrirTabelas;

end;


procedure TF_CONSLOGOPERACOES.AbrirTabelas;
begin
    DM.CDS_LOGOPERACOES.Active   := True;

end;


procedure TF_CONSLOGOPERACOES.btn_SairClick(Sender: TObject);
begin
    close;
    
end;

procedure TF_CONSLOGOPERACOES.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    DM.CDS_LOGOPERACOES.Active   := false;

end;

procedure TF_CONSLOGOPERACOES.FiltrarPorPeriodo;
var
  DataInicio, DataFim  : TDate;
begin
           DataInicio     := StrToDate(edt_DataInicio.text);
           DataFim        := StrToDate(edt_DataFim.text);

           with DM.CDS_LOGOPERACOES do
           begin
               close;
               CommandText := 'SELECT * FROM log_operacoes WHERE data BETWEEN :pDataIni AND :pDataFim ORDER BY id_operacao desc';
               Params.ParamByName('pDataIni').AsDate    := DataInicio;
               Params.ParamByName('pDataFim').AsDate    := DataFim;
               Open;

                if IsEmpty then
                  begin
                         Application.MessageBox('Não foram encontrados registros no período selecionado!',
                         'Atenção...', MB_OK + MB_ICONWARNING);
                         btnLimparClick(self);   

                 end else
                  begin
                     edt_DataInicio.Clear;
                     edt_DataFim.Clear;
                     btnLimpar.Enabled := true;

                 end;       

           end;
end;

procedure TF_CONSLOGOPERACOES.btnPesquisarPeriodoClick(Sender: TObject);
begin
        if (edt_DataInicio.Text = '  /  /    ') or (edt_DataFim.Text = '  /  /    ') then
        begin
                  Application.MessageBox('É necessário uma data inicial e uma data final para efetuar a pesquisa !', 'Período Inválido!', MB_OK);
                  edt_datainicio.text          := '  /  /    ';
                  edt_DataInicio.SetFocus;

        end
        else if (edt_DataFim.Date >= edt_DataInicio.Date) then begin

                 FiltrarPorPeriodo;

        end else begin

          Application.MessageBox('A data inicial não pode ser maior que a data final!', 'Período Inválido!', MB_OK);
          edt_DataInicio.SetFocus;

       end;

end;

procedure TF_CONSLOGOPERACOES.btnLimparClick(Sender: TObject);
begin
        with DM.CDS_LOGOPERACOES do
        begin
               close;
               CommandText := 'SELECT * FROM log_operacoes ORDER BY id_operacao desc';
               Open;

        end;

        btnLimpar.Enabled := false;
        edt_DataInicio.Clear;
        edt_DataFim.Clear;

end;

procedure TF_CONSLOGOPERACOES.ApagarTabelaLogs;
begin
       With DMPESQ.Qry_Geral do
       begin

          Close;
          SQL.Clear;
          SQL.Add('DELETE FROM log_operacoes');
          ExecSQL;

       end;  
       Application.MessageBox('A tabela de logs foi apagada com sucesso!', 'Excluindo registros!', MB_ICONEXCLAMATION);
       DM.CDS_LOGOPERACOES.Active := false;
       DM.CDS_LOGOPERACOES.Active := true;
       
end;

procedure TF_CONSLOGOPERACOES.btnApagarTabelaLogClick(Sender: TObject);
begin
    texto:= 'Confirma o desejo de apagar toda a tabela de logs?';

    if Application.MessageBox(PChar(texto),'Limpando a tabela',MB_YESNO + MB_ICONQUESTION) = IdYes then
    begin
        ApagarTabelaLogs;

    end else begin exit; end;

end;

end.

