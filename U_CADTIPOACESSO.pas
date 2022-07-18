unit U_CADTIPOACESSO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, Mask, Encryp, DBCtrls,
  Menus, IniFiles, ToolEdit, CurrEdit,DB;

type
  TF_CADTIPOACESSO = class(TForm)
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
    gridCredores: TDBGrid;
    btnExcluir: TSpeedButton;
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
    procedure btnExcluirClick(Sender: TObject);
    procedure ExcluirTipo;
    procedure VerificarTabelaVazia;
    procedure gridCredoresCellClick(Column: TColumn);
    procedure DBEdit1Enter(Sender: TObject);


  private
    { Private declarations }
    procedure leitura;
    procedure editar;


  public
    { Public declarations }


  end;

var
  F_CADTIPOACESSO : TF_CADTIPOACESSO;

implementation

uses U_BIBLIOTECA, U_DM, U_DMPESQ;

{$R *.dfm}


procedure TF_CADTIPOACESSO.FormCreate(Sender: TObject);
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

   AbrirTabelas;

end;

procedure TF_CADTIPOACESSO.FormShow(Sender: TObject);
begin

  leitura;
  LogOperacoes(NomeDoUsuarioLogado, 'acesso ao gerenciamento de tipos de credenciados');

end;


procedure TF_CADTIPOACESSO.AbrirTabelas;
begin

   dm.cds_tiposacesso.Active := true;

end;


procedure TF_CADTIPOACESSO.FecharTabelas;
begin

   dm.cds_tiposacesso.Active := false;

end;


procedure TF_CADTIPOACESSO.FecharAbrirTabelas;
begin

    dm.cds_tiposacesso.Active := false;
    dm.cds_tiposacesso.Active := true;

end;


procedure TF_CADTIPOACESSO.btn_SairClick(Sender: TObject);
begin

     close;

end;


procedure TF_CADTIPOACESSO.FormClose(Sender: TObject; var Action: TCloseAction);
begin

    Release;

end;

procedure TF_CADTIPOACESSO.FormKeyPress(Sender: TObject; var Key: Char);
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


procedure TF_CADTIPOACESSO.btnGravarClick(Sender: TObject);
begin 

    if (DBEdit2.Text = '') then
    begin

       Application.MessageBox('Preencha os campos corretamente para continuar o cadastro!',
                                    'Informação do Sistema', MB_OK + MB_ICONINFORMATION);
       exit;

    end else begin

        With DM.Qry_Geral do
        begin

            Close;
            SQL.Clear;
            SQL.Add('select TIPOACESSO from TBL_TIPOSACESSO WHERE tipoacesso = :pTipo');
            ParamByName('pTipo').AsString := DBEdit2.Text;
            Open;

            if not IsEmpty then begin

                  Application.MessageBox('Atenção esse tipo de acesso já esta cadastrado, verifique!',
                                          'Informação do Sistema', MB_OK + MB_ICONINFORMATION);
                  exit;

              end else begin

                  dm.cds_tiposacesso.Next;
                  dm.cds_tiposacesso.ApplyUpdates(0);
                  LogOperacoes(NomeDoUsuarioLogado, 'cadastro de tipo de acesso');
                  FecharAbrirTabelas;
                  DBEdit1.SetFocus;

              end;
          end;
    end;

    leitura;

end;

procedure TF_CADTIPOACESSO.btnNovoClick(Sender: TObject);
begin

        DBEdit2.SetFocus;

        With DM.qry_Cod do
        begin

            Close;
            SQL.Clear;
            SQL.Add('select max(ID_TIPOSACESSO) from TBL_TIPOSACESSO');
            Open;

            if not IsEmpty then begin

               proxNum := DM.qry_Cod.Fields[0].AsInteger + 1;

            end;

      end;


      with dm.cds_tiposacesso do
      begin

          append;
          DBEdit1.Text := InttoStr(proxNum);

      end;

      editar;

end;

procedure TF_CADTIPOACESSO.btnAlterarClick(Sender: TObject);
begin

    dm.CDS_TIPOSACESSO.Edit;
    DBEdit2.SetFocus;
    LogOperacoes(NomeDoUsuarioLogado, 'alteração de tipo de acesso');
    editar;

end;

procedure TF_CADTIPOACESSO.btnCancelarClick(Sender: TObject);
begin

    dm.cds_tiposacesso.CancelUpdates;
    dm.cds_tiposacesso.Prior;
    FecharAbrirTabelas;
    DBEdit1.SetFocus;
    leitura;

end;

procedure TF_CADTIPOACESSO.btnSairClick(Sender: TObject);
begin

    close;

end;

procedure TF_CADTIPOACESSO.btnExcluirClick(Sender: TObject);
begin

     ExcluirTipo;
     LogOperacoes(NomeDoUsuarioLogado, 'exclusão de tipo de acesso');
     //leitura;
     btnExcluir.Enabled :=false;
     btnCancelar.Enabled:=false;

end;

procedure TF_CADTIPOACESSO.ExcluirTipo;
begin

       texto:= 'Confirma a exclusão do ítem selecionado?';

       if Application.MessageBox(PChar(texto),'Excluíndo ítem',MB_YESNO + MB_ICONQUESTION) = IdYes then
       begin

           _Sql:= 'Delete FROM tbl_tiposacesso WHERE id_tiposacesso = :pIDTIPO';

            with DM.Qry_Geral do begin

              Close;
              SQL.Clear;
              SQL.Add(_Sql);
              ParamByName('pIDTIPO').AsInteger := StrToInt(DBEdit1.Text);
              ExecSQL();

           end;

           Application.MessageBox('Tipo de acesso excluído com sucesso!',
           'Exclusão', MB_OK + MB_ICONINFORMATION);

           FecharAbrirTabelas;

      end else begin

          exit;
          leitura;

      end;

end;

procedure TF_CADTIPOACESSO.leitura;
begin

    btnNovo.enabled     := true;
    btnGravar.enabled   := false;
    btnAlterar.enabled  := true;
    btnCancelar.enabled := false;
    btnExcluir.enabled  := false;
    btnSair.enabled     := true;
    DBEdit2.ReadOnly    := true;
    VerificarTabelaVazia;

end;

procedure TF_CADTIPOACESSO.editar;
begin

    btnNovo.enabled     := false;
    btnGravar.enabled   := true;
    btnAlterar.enabled  := false;
    btnCancelar.enabled := true;
    btnExcluir.enabled  := false;
    btnSair.enabled     := false;
    DBEdit2.ReadOnly    := false;

end;


procedure TF_CADTIPOACESSO.VerificarTabelaVazia;
begin

     if ( dm.cds_tiposacesso.Eof ) then
     begin

         btnAlterar.Enabled := false;
         btnExcluir.Enabled := false;

     end;

end;

procedure TF_CADTIPOACESSO.gridCredoresCellClick(Column: TColumn);
begin
  btnExcluir.Enabled :=true;
  btnCancelar.Enabled:=true;
end;

procedure TF_CADTIPOACESSO.DBEdit1Enter(Sender: TObject);
begin
btnExcluir.Enabled:=false;
btnCancelar.Enabled:=true;
end;

end.
