unit U_REATIVARCREDENCIADO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, Mask, Encryp, DBCtrls,
  Menus, IniFiles, ToolEdit, CurrEdit,DB;

type
  TF_REATIVARCREDENCIADO = class(TForm)
    pnl_cabecalho: TPanel;
    lblHoraAtual: TLabel;
    lblDataDoDia: TLabel;
    panGridCadCategorias: TPanel;
    gr_CadCategorias: TGroupBox;
    gr_EditarNovo: TGroupBox;
    btnSair: TSpeedButton;
    Grid: TDBGrid;
    btnReativar: TSpeedButton;
    btnReativarTodos: TSpeedButton;
    procedure btn_SairClick(Sender: TObject);
    procedure AbrirTabelas;
    procedure FecharTabelas;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnSairClick(Sender: TObject);
    procedure FecharAbrirTabelas;
    procedure FormShow(Sender: TObject);
    procedure btnReativarClick(Sender: TObject);
    procedure ReativarCredenciado(conselho, tabela:string);
    procedure ReativarTodosCredenciados;
    procedure AtualizarQde;
    procedure GridCellClick(Column: TColumn);
    procedure PopularGridCredenciadosInativos;
    Function  TemInativos():boolean;
    procedure btnReativarTodosClick(Sender: TObject);



  private
    { Private declarations }
     nomeCredenciadoEditado, nomeFormacao   : string;
     idCredenciadoSelecionado : integer;

  public
    { Public declarations }

  end;

var
  F_REATIVARCREDENCIADO : TF_REATIVARCREDENCIADO;


implementation

uses U_BIBLIOTECA, U_DM, SqlExpr, U_DMPESQ, U_PRINCIPAL;

{$R *.dfm}


procedure TF_REATIVARCREDENCIADO.FormCreate(Sender: TObject);
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
   self.Caption        := 'Manutenção de Credenciados : '+NomeDoUsuarioLogado;
   nomeFormacao        := PrimeirasLetrasMaiusculas(RetornaNomeFormacaoPlural(IdTipoFormacao));
   AbrirTabelas;

end;

procedure TF_REATIVARCREDENCIADO.FormShow(Sender: TObject);
begin
  PopularGridCredenciadosInativos;
  AtualizarQde;

end;

procedure TF_REATIVARCREDENCIADO.AtualizarQde;
begin
   qdeRegs               := ListaQdeRegs(DM.CDS_CONSULTAS);
   pnl_cabecalho.Caption := 'Total de '+nomeFormacao+' inativados no momento '+ IntToStr( qdeRegs );

end;


procedure TF_REATIVARCREDENCIADO.AbrirTabelas;
begin
   DM.CDS_CONSULTAS.Active    := true;

end;


procedure TF_REATIVARCREDENCIADO.FecharTabelas;
begin
   DM.CDS_CONSULTAS.Active    := false;

end;


procedure TF_REATIVARCREDENCIADO.FecharAbrirTabelas;
begin
   DM.CDS_CONSULTAS.Active    := false;
   DM.CDS_CONSULTAS.Active    := true;

end;


procedure TF_REATIVARCREDENCIADO.btn_SairClick(Sender: TObject);
begin 
     close;

end;


procedure TF_REATIVARCREDENCIADO.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  FecharAbrirTabelas;

end;

procedure TF_REATIVARCREDENCIADO.FormKeyPress(Sender: TObject; var Key: Char);
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


procedure TF_REATIVARCREDENCIADO.btnSairClick(Sender: TObject);
begin
  close;

end;

procedure TF_REATIVARCREDENCIADO.btnReativarClick(Sender: TObject);
begin

       //ShowMessage('CONSELHO...: '+numConselho);
       ReativarCredenciado(numConselho,nomeTabela);
       AtualizarQde;

end;

procedure TF_REATIVARCREDENCIADO.ReativarTodosCredenciados;
begin
       texto:= 'Confirma a reativação de todos os '+nomeFormacao+' inativados?';

       if Application.MessageBox(PChar(texto),'Reativando credenciados inativados',MB_YESNO + MB_ICONQUESTION) = IdYes then
       begin
           _Sql:= 'UPDATE '+nomeTabela+' SET STATUS = '+QuotedStr('ATIVO')+', DATAINAT = '+QuotedStr('')+' WHERE STATUS = '+QuotedStr('INATIVO')+'';

            with DMPESQ.Qry_Geral do
            begin
              Close;
              SQL.Clear;
              SQL.Add(_Sql);
              ExecSQL();

           end;

          //REATIVAR TODOS OS CREDENCIADOS QUE ESTAO NA TABELA INATIVOS E DEPOIS DELETAR

          With DM.QRY_GERAL do
          begin
                Close;
                SQL.Clear;
                SQL.Add('DELETE FROM TBL_INATIVOS WHERE tabela = :pTabela');
                Params.ParamByName('pTabela').AsString := nomeTabela;
                ExecSQL();

          end;

           Application.MessageBox('Todos os credenciados foram reativados com sucesso!',
           'Inativando', MB_OK + MB_ICONINFORMATION);
           LogOperacoes(NomeDoUsuarioLogado, 'reativação de todos os '+nomeFormacao+' inativados '+nomeCredenciadoEditado);
           FecharAbrirTabelas;
           if not (TemInativos)then
               close;

       end else begin
          btnReativar.Enabled  := false;
          exit;

      end;

end;

procedure TF_REATIVARCREDENCIADO.ReativarCredenciado(conselho, tabela :string);
begin
       texto:= 'Confirma a reativação de '+nomeCredenciadoEditado+'?';

       if Application.MessageBox(PChar(texto),'Reativando credenciado',MB_YESNO + MB_ICONQUESTION) = IdYes then
       begin
           _Sql:= 'UPDATE '+nomeTabela+' SET STATUS = '+QuotedStr('ATIVO')+', DATAINAT = '+QuotedStr('')+' WHERE conselho = :pConselho';

           //ShowMessage(_Sql);

            with DMPESQ.QRY_AUX do
            begin

              Close;
              SQL.Clear;
              SQL.Add(_Sql);
              Params.ParamByName('pConselho').AsString := conselho;
              ExecSQL();

           end;

          With DM.QRY_GERAL do
          begin
                Close;
                SQL.Clear;
                SQL.Add('DELETE FROM TBL_INATIVOS WHERE conselho = :pConselho');
                ParamByName('pConselho').AsString  := conselho;
                ExecSQL();

          end;

           Application.MessageBox('Credenciado reativado com sucesso!',
           'Reativação...', MB_OK + MB_ICONINFORMATION);
           LogOperacoes(NomeDoUsuarioLogado, 'reativacao no cadastro do '+lowercase(nomedaformacao)+' '+nomeCredenciadoEditado);
           FecharAbrirTabelas;
           btnReativar.Enabled  := false;
           if not (TemInativos)then
               close;

      end else begin
          btnReativar.Enabled  := false;
          exit;

     end;
     PopularGridCredenciadosInativos;
end;

procedure TF_REATIVARCREDENCIADO.GridCellClick(Column: TColumn);
begin
    idCredenciadoSelecionado     := DMPESQ.CDSPESQ.FieldByName('ID_CREDENCIADO').AsInteger;
    nomeCredenciadoEditado       := DMPESQ.CDSPESQ.FieldByName('NOME').AsString;
    numConselho                  := DMPESQ.CDSPESQ.FieldByName('CONSELHO').AsString;
    btnReativar.Enabled          := TRUE;
end;


function TF_REATIVARCREDENCIADO.TemInativos:boolean;
begin
    _Sql:='SELECT * FROM '+nomeTabela+' WHERE STATUS = '+QuotedStr('INATIVO')+'';

     with DMPESQ.Qry_Geral do
     begin

        Close;
        SQL.Clear;
        SQL.Add(_Sql);
        open;

        if not IsEmpty then
          Result := true
        else
          Result := false;

     end;

end;



procedure TF_REATIVARCREDENCIADO.btnReativarTodosClick(Sender: TObject);
begin
  ReativarTodosCredenciados;
end;

procedure TF_REATIVARCREDENCIADO.PopularGridCredenciadosInativos;
begin
     _Sql := 'SELECT * FROM '+nomeTabela+' WHERE status='+QuotedStr('INATIVO')+' ORDER BY nome';

      with DMPESQ.CDSPESQ do begin

          Close;
          CommandText:=(_Sql);
          Open;

          if IsEmpty then begin

             Grid.Enabled := false;

          end;


      end;

      with Grid do
      begin

        DataSource:=  DMPESQ.DSPESQ;
        Columns.Clear;

        Columns.Add;
        Columns[0].FieldName       := 'NOME';
        Columns[0].Width           := 760;
        Columns[0].Alignment       := taLeftJustify;

      end;

end;

end.
