unit U_CONSPORPROCESSOS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, Mask, Encryp, DBCtrls,
  Menus, IniFiles, ToolEdit, CurrEdit,DB;

type
  TF_CONSPORPROCESSO = class(TForm)
    pnl_cabecalho: TPanel;
    lblHoraAtual: TLabel;
    lblDataDoDia: TLabel;
    panGridCadCategorias: TPanel;
    gr_CadCategorias: TGroupBox;
    grid: TDBGrid;
    Panel1: TPanel;
    GroupBox9: TGroupBox;
    edtNumero: TEdit;
    cmbFORMACAO: TComboBox;
    lblCONSELHO: TLabel;
    Label1: TLabel;
    cmbNomesCredenciados: TComboBox;
    Label2: TLabel;
    btnLimparPesquisa: TSpeedButton;
    procedure btn_SairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Panel1Click(Sender: TObject);
    procedure edtNumeroChange(Sender: TObject);
    procedure FiltrarPorProcesso;
    procedure FiltrarProcessosPeloNome(nome:string);
    procedure LimparConsulta;
    procedure selecionarFormacao;
    procedure popularComboNomesCredenciados;
    procedure popularComboFormacoes;
    procedure cmbFORMACAOClick(Sender: TObject);
    procedure edtNumeroKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbNomesCredenciadosClick(Sender: TObject);
    procedure btnLimparPesquisaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);



  private
    { Private declarations }
    nomeTabela, nomeCredenciado, nomeFormacao, processo : string;
  public
    { Public declarations }

  end;

var
  F_CONSPORPROCESSO : TF_CONSPORPROCESSO;


implementation

uses U_BIBLIOTECA, U_DM, SqlExpr, U_DMPESQ, U_PRINCIPAL, DBClient;

{$R *.dfm}


procedure TF_CONSPORPROCESSO.FormCreate(Sender: TObject);
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
   self.Caption        := 'Consulta Rápida por Processo ou Credenciado - Logado : '+NomeDoUsuarioLogado;

end;

procedure TF_CONSPORPROCESSO.btn_SairClick(Sender: TObject);
begin 
     close;

end;


procedure TF_CONSPORPROCESSO.FormKeyPress(Sender: TObject; var Key: Char);
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


procedure TF_CONSPORPROCESSO.Panel1Click(Sender: TObject);
begin
close;
end;

procedure TF_CONSPORPROCESSO.edtNumeroChange(Sender: TObject);
begin
  FiltrarPorProcesso;
end;

procedure TF_CONSPORPROCESSO.FiltrarPorProcesso;
begin
      //levando-se em conta que esta digitando um numero de processo desabilitar a combo com nomes
      cmbNomesCredenciados.Enabled   := false;
      cmbNomesCredenciados.ItemIndex := -1;

      selecionarFormacao;  //informa o nome da tabea
      processo  := edtNumero.Text;

      _Sql      := 'SELECT t.nome, p.numero FROM '+nomeTabela+' t, tbl_processos p WHERE t.conselho = p.conselhoproc AND '+
                   'p.numero LIKE (''%'+processo+'%'') ORDER BY t.Nome';

      with DMPESQ.CDSPESQ do
       begin
        Close;
        CommandText:=_Sql;
        Open;

         If not IsEmpty then
         begin

            with grid do
            begin
                DataSource:=  DMPESQ.DSPESQ;
                Columns.Clear;

                Columns.Add;
                Columns[0].FieldName         := 'NOME';
                Columns[0].Title.caption     := 'NOME';
                Columns[0].Width             := 560;
                Columns[0].Alignment         := taLeftJustify;
                Columns[0].Title.Font.Style  := [fsBold];
                Columns[0].Title.Alignment   := taLeftJustify;

                Columns.Add;
                Columns[1].FieldName         := 'NUMERO';
                Columns[1].Title.caption     := 'PROCESSO';
                Columns[1].Width             := 200;
                Columns[1].Alignment         := taLeftJustify;
                Columns[1].Title.Font.Style  := [fsBold];
                Columns[1].Title.Alignment   := taLeftJustify;

            end;
         end;
       end;

end;

procedure TF_CONSPORPROCESSO.selecionarFormacao;
begin
     //define qual será a tabela a ser consultada
     case(cmbFORMACAO.ItemIndex)of
      0: nomeTabela := 'TBL_ENGENHEIROAMBIENTAL';
      1: nomeTabela := 'TBL_ENGENHEIROCIVIL';
      2: nomeTabela := 'TBL_ARQUITETO';
      3: nomeTabela := 'TBL_CONTADOR';
     end;

end;

procedure TF_CONSPORPROCESSO.cmbFORMACAOClick(Sender: TObject);
begin
  edtNumero.Enabled:=true;
  edtNumero.SetFocus;
  cmbNomesCredenciados.Enabled := true;
  btnLimparPesquisa.Enabled    := true;
  popularComboNomesCredenciados;
end;

procedure TF_CONSPORPROCESSO.edtNumeroKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
     if KEY = VK_RETURN then
      begin
          limparConsulta;
      end;
end;

procedure TF_CONSPORPROCESSO.popularComboFormacoes;
begin
      cmbFORMACAO.Items.Clear;
      
      _Sql := 'SELECT tipo FROM tbl_tipo';

      with DMPESQ.CDSAUX do
       begin
        Close;
        CommandText:=_Sql;
        Open;

         while not eof do
         begin
            nomeFormacao := DMPESQ.CDSAUX.Fields[0].AsString;
            cmbFORMACAO.Items.Add(nomeFormacao);
            next;
         end;
      end;

end;

procedure TF_CONSPORPROCESSO.popularComboNomesCredenciados;
begin
      cmbNomesCredenciados.Items.Clear;
      processo  := edtNumero.Text;
      selecionarFormacao;  //informa o nome da tabela

      _Sql      := 'SELECT t.nome FROM '+nomeTabela+' t ORDER BY t.Nome';

      with DMPESQ.CDSPESQ do
       begin
        Close;
        CommandText:=_Sql;
        Open;

         while not eof do
         begin
            nomeCredenciado := DMPESQ.CDSPESQ.Fields[0].AsString;
            cmbNomesCredenciados.Items.Add(nomeCredenciado);
            next;
         end;
      end;
      cmbNomesCredenciados.ItemIndex :=0;
      cmbFORMACAO.Enabled            := false;
end;

procedure TF_CONSPORPROCESSO.FiltrarProcessosPeloNome(nome:string);
begin
      edtNumero.Enabled := false; //entende-se que a consulta será feito pelo nome e não pelo número
      selecionarFormacao;  //informa o nome da tabela
      nomeCredenciado  := cmbNomesCredenciados.Text;


      _Sql      := 'SELECT t.nome, p.numero FROM '+nomeTabela+' t, tbl_processos p WHERE t.conselho = p.conselhoproc '+
                   'AND t.nome = :pNomeCred ORDER BY t.Nome';

      with DMPESQ.CDSPESQ do
       begin
        Close;
        CommandText:=_Sql;
        Params.ParamByName('pNomeCred').AsString := nome;
        Open;

         If not IsEmpty then
         begin

            with grid do
            begin
                DataSource:=  DMPESQ.DSPESQ;
                Columns.Clear;

                Columns.Add;
                Columns[0].FieldName         := 'NOME';
                Columns[0].Title.caption     := 'NOME';
                Columns[0].Width             := 560;
                Columns[0].Alignment         := taLeftJustify;
                Columns[0].Title.Font.Style  := [fsBold];
                Columns[0].Title.Alignment   := taLeftJustify;

                Columns.Add;
                Columns[1].FieldName         := 'NUMERO';
                Columns[1].Title.caption     := 'PROCESSO';
                Columns[1].Width             := 200;
                Columns[1].Alignment         := taLeftJustify;
                Columns[1].Title.Font.Style  := [fsBold];
                Columns[1].Title.Alignment   := taLeftJustify;

            end;
         end;
       end;
end;

procedure TF_CONSPORPROCESSO.cmbNomesCredenciadosClick(Sender: TObject);
begin
    FiltrarProcessosPeloNome(cmbNomesCredenciados.Text);
end;

procedure TF_CONSPORPROCESSO.LimparConsulta;
begin
  edtNumero.Clear;
  edtNumero.Enabled              :=false;
  cmbFORMACAO.ItemIndex          := -1;
  Grid.DataSource                := nil; //limpando o grid
  cmbNomesCredenciados.Enabled   := false;
  cmbNomesCredenciados.ItemIndex := -1;
  btnLimparPesquisa.Enabled      := false;
  cmbFORMACAO.Enabled            := true;
end;

procedure TF_CONSPORPROCESSO.btnLimparPesquisaClick(Sender: TObject);
begin
  LimparConsulta;
end;

procedure TF_CONSPORPROCESSO.FormShow(Sender: TObject);
begin
  popularComboFormacoes;
end;

end.
