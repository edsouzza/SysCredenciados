unit U_EDITARLOGIN;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, Mask, Encryp, DBCtrls,
  Menus, IniFiles, ToolEdit, CurrEdit,DB;

type
  TF_EDITARLOGIN = class(TForm)
    pnl_cabecalho: TPanel;
    lblHoraAtual: TLabel;
    lblDataDoDia: TLabel;
    panGridCadCategorias: TPanel;
    gr_CadCategorias: TGroupBox;
    gr_EditarNovo: TGroupBox;
    btnSair: TSpeedButton;
    gridUsuarios: TDBGrid;
    btnGravar: TSpeedButton;
    GroupBox1: TGroupBox;
    Label22: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit4: TDBEdit;
    btnCancelar: TSpeedButton;
    procedure btn_SairClick(Sender: TObject);
    procedure AbrirTabelas;
    procedure FecharTabelas;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnSairClick(Sender: TObject);
    procedure FecharAbrirTabelas;
    procedure FormShow(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure EditarLogin;
    procedure AtualizarQde;
    procedure gridUsuariosCellClick(Column: TColumn);
    procedure PreencheGridUsuarios;
    procedure VerificarSeDigitouRFCompleto;
    procedure DBEdit4KeyPress(Sender: TObject; var Key: Char);
    procedure DBEdit4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBEdit4Enter(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);

  private
    { Private declarations }
     nomeUsuarioEditado   : string;
     idUsuarioSelecionado : integer;

  public
    { Public declarations }

  end;

var
  F_EDITARLOGIN : TF_EDITARLOGIN;


implementation

uses U_BIBLIOTECA, U_DM, SqlExpr, U_DMPESQ, U_PRINCIPAL, U_SENHAS;

{$R *.dfm}


procedure TF_EDITARLOGIN.FormCreate(Sender: TObject);
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

procedure TF_EDITARLOGIN.FormShow(Sender: TObject);
begin

  self.Caption        := 'Edição do Login de Usuários - Logado por : '+PrimeirasLetrasMaiusculas(NomeDoUsuarioLogado);
  PreencheGridUsuarios;
  AtualizarQde;

end;

procedure TF_EDITARLOGIN.AtualizarQde;
begin
   qdeRegs               := ListaQdeRegs(DM.CDS_USUARIOS);
   pnl_cabecalho.Caption := 'Total de usuários '+ IntToStr( qdeRegs );

end;


procedure TF_EDITARLOGIN.AbrirTabelas;
begin
   DM.CDS_USUARIOS.Active    := true;

end;


procedure TF_EDITARLOGIN.FecharTabelas;
begin
   DM.CDS_USUARIOS.Active    := false;

end;


procedure TF_EDITARLOGIN.FecharAbrirTabelas;
begin
   DM.CDS_USUARIOS.Active    := false;
   DM.CDS_USUARIOS.Active    := true;

end;


procedure TF_EDITARLOGIN.btn_SairClick(Sender: TObject);
begin 
     close;    
end;


procedure TF_EDITARLOGIN.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //mostrando apenas os tipos de acesso acessiveis ao cadastro a exceção do SISTEMA
  DM.CDS_USUARIOS.Close;
  DM.CDS_USUARIOS.CommandText:='SELECT * FROM TBL_USUARIOS WHERE ID_USUARIO > 1 AND STATUS = '+QuotedStr('ATIVO')+' ORDER BY NOME';
  DM.CDS_USUARIOS.Open;
  FecharAbrirTabelas;
  AcessarEdicaoLogin:=false;
  acessoBackupBanco :=false;

end;

procedure TF_EDITARLOGIN.FormKeyPress(Sender: TObject; var Key: Char);
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


procedure TF_EDITARLOGIN.btnSairClick(Sender: TObject);
begin
  DM.CDS_USUARIOS.Cancel;
  close;

end;

procedure TF_EDITARLOGIN.btnGravarClick(Sender: TObject);
begin
       VerificarSeDigitouRFCompleto;
       AtualizarQde;     

end;

procedure TF_EDITARLOGIN.EditarLogin;
begin
      DM.CDS_USUARIOS.Next;
      DM.CDS_USUARIOS.ApplyUpdates(0);
      texto:= 'O Login do usuário '+nomeUsuarioEditado+' foi editado com sucesso!';
      Application.MessageBox(Pchar(texto), 'Edição de Login!',MB_OK + MB_ICONWARNING);
      LogOperacoes(NomeDoUsuarioLogado, 'edicao de login de '+nomeUsuarioEditado);
      FecharAbrirTabelas;
      DBEdit4.ReadOnly     := true;
      btnGravar.Enabled    := false;
      
end;

procedure TF_EDITARLOGIN.gridUsuariosCellClick(Column: TColumn);
begin

    senhaUsuarioDoBanco  := dm.CDS_USUARIOS.FieldByName('SENHA').AsString;
    idUsuarioSelecionado := dm.CDS_USUARIOS.FieldByName('ID_USUARIO').AsInteger;
    nomeUsuarioEditado   := dm.CDS_USUARIOS.FieldByName('NOME').AsString;
    DBEdit4.ReadOnly     := false;
    btnGravar.Enabled    := true;
    btnCancelar.Enabled  := true;
    DBEdit4.SetFocus;

end;

procedure TF_EDITARLOGIN.PreencheGridUsuarios;
begin
   with DM.CDS_USUARIOS do
   begin
    Close;
    CommandText:='SELECT * FROM TBL_USUARIOS WHERE ID_USUARIO > 1 AND STATUS = '+QuotedStr('ATIVO')+' ORDER BY NOME';
    Open;

     If not IsEmpty then
     begin

        DBEdit2.DataSource  := DM.DS_USUARIOS;
        DBEdit2.DataField   := 'NOME';

        DBEdit4.DataSource  := DM.DS_USUARIOS;
        DBEdit4.DataField   := 'LOGIN';

        with gridUsuarios do
        begin
            DataSource:=  DM.DS_USUARIOS;
            Columns.Clear;

            Columns.Add;
            Columns[0].FieldName         := 'NOME';
            Columns[0].Title.caption     := 'NOME';
            Columns[0].Width             := 680;
            Columns[0].Alignment         := taLeftJustify;
            Columns[0].Title.Font.Style  := [fsBold];
            Columns[0].Title.Alignment   := taLeftJustify;

            Columns.Add;
            Columns[1].FieldName         := 'LOGIN';
            Columns[1].Title.caption     := 'LOGIN';
            Columns[1].Width             := 75;
            Columns[1].Alignment         := taLeftJustify;
            Columns[1].Title.Font.Style  := [fsBold];
            Columns[1].Title.Alignment   := taLeftJustify;

        end;
     end;
   end;
end;

procedure TF_EDITARLOGIN.VerificarSeDigitouRFCompleto;
var
   letraD : string;
begin
      //verifica se digitou a letra 'D' no inicio do RF dentro do DBEdit4
      letraD := copy(DBEdit4.Text,0,1);

      //verifica se digitou os sete caracteres do RF
      if not(DigitouRFCompleto(DBEdit4.Text)) then
      begin
         Application.MessageBox('Selecione o usuário e digite o novo RF corretamente ex: D123456', 'RF inválido!', MB_ICONWARNING);
         DBEdit4.SetFocus;
         DM.CDS_USUARIOS.Cancel;

         btnGravar.Enabled := false;
      end else if(letraD <> 'D')then
      begin
           Application.MessageBox('Selecione o usuário e digite o novo RF corretamente ex: D123456', 'RF inválido!', MB_ICONWARNING);
           DBEdit4.SetFocus;
           DM.CDS_USUARIOS.Cancel;
           btnGravar.Enabled := false;
      end else begin
          if(TemDuplicidade('login','tbl_usuarios',DBEdit4.text))then
          begin
              texto:= 'O login '+DBEdit4.Text+' já esta cadastrado, verifique!';
              Application.MessageBox(Pchar(texto), 'Duplicidade de cadastro!',MB_OK + MB_ICONWARNING);
              DM.CDS_USUARIOS.Cancel;
              btnGravar.Enabled := false;
          end else begin
              EditarLogin;
          end;
      end;
end;

procedure TF_EDITARLOGIN.DBEdit4KeyPress(Sender: TObject; var Key: Char);
begin
//aceita apenas numeros e a letra D
if not (Key in['0'..'9','D'..'d',Chr(8)]) then Key:= #0;
end;

procedure TF_EDITARLOGIN.DBEdit4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=vk_return then
     btnGravarClick(self);
end;

procedure TF_EDITARLOGIN.DBEdit4Enter(Sender: TObject);
begin
DBEdit4.SelStart:=0;
DBEdit4.SelLength:= Length(DBEdit4.Text);

end;

procedure TF_EDITARLOGIN.btnCancelarClick(Sender: TObject);
begin
       DM.CDS_USUARIOS.Cancel;
       btnGravar.Enabled   :=false;
       btnCancelar.Enabled := false;
end;

end.
