unit U_REATIVARUSUARIO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, Mask, Encryp, DBCtrls,
  Menus, IniFiles, ToolEdit, CurrEdit,DB;

type
  TF_REATIVARUSUARIO = class(TForm)
    pnl_cabecalho: TPanel;
    lblHoraAtual: TLabel;
    lblDataDoDia: TLabel;
    panGridCadCategorias: TPanel;
    gr_CadCategorias: TGroupBox;
    gr_EditarNovo: TGroupBox;
    btnSair: TSpeedButton;
    gridUsuarios: TDBGrid;
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
    procedure ReativarUsuario;
    procedure ReativarTodosUsuarios;
    procedure AtualizarQde;
    procedure gridUsuariosCellClick(Column: TColumn);
    procedure PreencheGridUsuarios;
    Function  TemInativos():boolean;
    procedure btnReativarTodosClick(Sender: TObject);



  private
    { Private declarations }
     nomeUsuarioEditado   : string;
     idUsuarioSelecionado : integer;

  public
    { Public declarations }

  end;

var
  F_REATIVARUSUARIO : TF_REATIVARUSUARIO;


implementation

uses U_BIBLIOTECA, U_DM, SqlExpr, U_DMPESQ, U_PRINCIPAL;

{$R *.dfm}


procedure TF_REATIVARUSUARIO.FormCreate(Sender: TObject);
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

   lblDataDoDia.Caption:=  DateToStr(date);
   lblHoraAtual.Caption:=  timetoStr(time);
   self.Caption        := 'Manuten��o de Usu�rios - Logado : '+NomeDoUsuarioLogado;
   AbrirTabelas;

end;

procedure TF_REATIVARUSUARIO.FormShow(Sender: TObject);
begin
  PreencheGridUsuarios;
  AtualizarQde;

end;

procedure TF_REATIVARUSUARIO.AtualizarQde;
begin
   qdeRegs               := ListaQdeRegs(DM.CDS_USUARIOS);
   pnl_cabecalho.Caption := 'Total de usu�rios inativados no momento '+ IntToStr( qdeRegs );

end;


procedure TF_REATIVARUSUARIO.AbrirTabelas;
begin
   DM.CDS_USUARIOS.Active    := true;

end;


procedure TF_REATIVARUSUARIO.FecharTabelas;
begin
   DM.CDS_USUARIOS.Active    := false;

end;


procedure TF_REATIVARUSUARIO.FecharAbrirTabelas;
begin
   DM.CDS_USUARIOS.Active    := false;
   DM.CDS_USUARIOS.Active    := true;

end;


procedure TF_REATIVARUSUARIO.btn_SairClick(Sender: TObject);
begin 
     close;

end;


procedure TF_REATIVARUSUARIO.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //mostrando apenas os tipos de acesso acessiveis ao cadastro a exce��o do SISTEMA
  DM.CDS_USUARIOS.Close;
  DM.CDS_USUARIOS.CommandText:='SELECT * FROM TBL_USUARIOS WHERE ID_USUARIO > 1 AND STATUS = '+QuotedStr('ATIVO')+' ORDER BY NOME';
  DM.CDS_USUARIOS.Open;
  FecharAbrirTabelas;

end;

procedure TF_REATIVARUSUARIO.FormKeyPress(Sender: TObject; var Key: Char);
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


procedure TF_REATIVARUSUARIO.btnSairClick(Sender: TObject);
begin
  close;

end;

procedure TF_REATIVARUSUARIO.btnReativarClick(Sender: TObject);
begin
       ReativarUsuario;
       AtualizarQde;     

end;

procedure TF_REATIVARUSUARIO.ReativarTodosUsuarios;
begin
       texto:= 'Confirma a reativa��o de todos os usu�rios inativados?';

       if Application.MessageBox(PChar(texto),'Reativando usu�rios inativados',MB_YESNO + MB_ICONQUESTION) = IdYes then
       begin
           _Sql:= 'UPDATE tbl_usuarios SET STATUS = '+QuotedStr('ATIVO')+' WHERE STATUS = '+QuotedStr('INATIVO')+'';

            with DMPESQ.Qry_Geral do
            begin
              Close;
              SQL.Clear;
              SQL.Add(_Sql);
              ExecSQL();

           end;

           Application.MessageBox('Todos os usu�rios foram reativados com sucesso!',
           'Inativando', MB_OK + MB_ICONINFORMATION);
           LogOperacoes(NomeDoUsuarioLogado, 'reativa��o de todos os usuarios inativados '+nomeUsuarioEditado);
           FecharAbrirTabelas;
           if not (TemInativos)then
               close;

       end else begin
          btnReativar.Enabled  := false;
          exit;

      end;

end;

procedure TF_REATIVARUSUARIO.ReativarUsuario;
begin
       texto:= 'Confirma a reativa��o do usu�rio selecionado?';

       if Application.MessageBox(PChar(texto),'Reativando usu�rio',MB_YESNO + MB_ICONQUESTION) = IdYes then
       begin
           _Sql:= 'UPDATE tbl_usuarios SET STATUS = '+QuotedStr('ATIVO')+' WHERE id_usuario = :pID';

            with DMPESQ.Qry_Geral do
            begin

              Close;
              SQL.Clear;
              SQL.Add(_Sql);
              ParamByName('pID').AsInteger := idUsuarioSelecionado;
              ExecSQL();

           end;

           Application.MessageBox('Usu�rio reativado com sucesso!',
           'Inativando', MB_OK + MB_ICONINFORMATION);
           LogOperacoes(NomeDoUsuarioLogado, 'reativa��o no cadastro de '+nomeUsuarioEditado);
           FecharAbrirTabelas;
           btnReativar.Enabled  := false;
           if not (TemInativos)then
               close;

      end else begin
          btnReativar.Enabled  := false;
          exit;

      end;

end;

procedure TF_REATIVARUSUARIO.gridUsuariosCellClick(Column: TColumn);
begin
    idUsuarioSelecionado := dm.CDS_USUARIOS.FieldByName('ID_USUARIO').AsInteger;
    nomeUsuarioEditado   := dm.CDS_USUARIOS.FieldByName('NOME').AsString;
    btnReativar.Enabled  := TRUE;
end;

procedure TF_REATIVARUSUARIO.PreencheGridUsuarios;
begin
  //mostrando apenas os tipos de acesso acessiveis ao cadastro a exce��o do SISTEMA
  DM.CDS_USUARIOS.Close;
  DM.CDS_USUARIOS.CommandText:='SELECT * FROM TBL_USUARIOS WHERE STATUS = '+QuotedStr('INATIVO')+'';
  DM.CDS_USUARIOS.Open;

end;

function TF_REATIVARUSUARIO.TemInativos:boolean;
begin
    _Sql:='SELECT * FROM TBL_USUARIOS WHERE STATUS = '+QuotedStr('INATIVO')+'';

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



procedure TF_REATIVARUSUARIO.btnReativarTodosClick(Sender: TObject);
begin
ReativarTodosUsuarios;
end;

end.
