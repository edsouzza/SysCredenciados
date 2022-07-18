unit U_ESCOLHATIPOFORMACAOREATIVAR;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, ToolEdit, Buttons, DB, Grids, DBGrids,
  DBCtrls;

type
  TF_ESCOLHATIPODEFORMACAOREATIVAR = class(TForm)
    GridCredenciados: TDBGrid;
    DBIDTIPOFUNC: TDBEdit;
    procedure btnFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridCredenciadosCellClick(Column: TColumn);
    procedure AbrirTabelas;
    procedure FecharTabelas;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_ESCOLHATIPODEFORMACAOREATIVAR: TF_ESCOLHATIPODEFORMACAOREATIVAR;

implementation

uses U_BIBLIOTECA, U_DM, SqlExpr, U_DMPESQ, U_REATIVARCREDENCIADO;

{$R *.dfm}

procedure TF_ESCOLHATIPODEFORMACAOREATIVAR.btnFecharClick(
  Sender: TObject);
begin   
    close;
    release;

end;

procedure TF_ESCOLHATIPODEFORMACAOREATIVAR.FormCreate(
  Sender: TObject);
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

procedure TF_ESCOLHATIPODEFORMACAOREATIVAR.AbrirTabelas;
begin
     DM.CDS_TIPO.Active                  := TRUE;
end;

procedure TF_ESCOLHATIPODEFORMACAOREATIVAR.FecharTabelas;
begin
     DM.CDS_TIPO.Active                  := FALSE;
end;

procedure TF_ESCOLHATIPODEFORMACAOREATIVAR.GridCredenciadosCellClick(
  Column: TColumn);
begin

     IdTipoFormacao := 0;
     IdTipoFormacao := StrToInt(DBIDTIPOFUNC.text);
     nomeDaFormacao := (DM.CDS_TIPO.fieldbyname('TIPO').AsString);

     if ( IdTipoFormacao = 3 ) then
     begin
           nomeTabela := 'TBL_ARQUITETO';
           AbrirTabelaInativos(DM.CDS_CONSULTAS,nomeTabela);
           if DM.CDS_CONSULTAS.RecordCount = 0 then
           begin
              Application.MessageBox('No momento não existem arquitetos inativos!',
                 'Sem Inativos!', MB_OK + MB_ICONINFORMATION);
              Close;

           end else
           begin
              Application.CreateForm(TF_REATIVARCREDENCIADO,  F_REATIVARCREDENCIADO);
              F_REATIVARCREDENCIADO.ShowModal;
              FreeAndNil(F_REATIVARCREDENCIADO);

          end;

     end else if ( IdTipoFormacao = 4 ) then
     begin
           nomeTabela := 'TBL_CONTADOR';
           AbrirTabelaInativos(DM.CDS_CONSULTAS,nomeTabela);
           if DM.CDS_CONSULTAS.RecordCount = 0 then
           begin
              Application.MessageBox('No momento não existem contadores inativos!',
                 'Sem Inativos!', MB_OK + MB_ICONINFORMATION);
              Close;

           end else
           begin
              Application.CreateForm(TF_REATIVARCREDENCIADO,  F_REATIVARCREDENCIADO);
              F_REATIVARCREDENCIADO.ShowModal;
              FreeAndNil(F_REATIVARCREDENCIADO);

          end;

     end else if ( IdTipoFormacao = 1 ) then
     begin
           nomeTabela := 'TBL_ENGENHEIROAMBIENTAL';
           AbrirTabelaInativos(DM.CDS_CONSULTAS,nomeTabela);
           if DM.CDS_CONSULTAS.RecordCount = 0 then
           begin
              Application.MessageBox('No momento não existem engenheiros ambientais inativos!',
                 'Sem Inativos!', MB_OK + MB_ICONINFORMATION);
              Close;

           end else
           begin
              Application.CreateForm(TF_REATIVARCREDENCIADO,  F_REATIVARCREDENCIADO);
              F_REATIVARCREDENCIADO.ShowModal;
              FreeAndNil(F_REATIVARCREDENCIADO);

          end;
    end else if ( IdTipoFormacao = 2 ) then
    begin
           nomeTabela := 'TBL_ENGENHEIROCIVIL';
           AbrirTabelaInativos(DM.CDS_CONSULTAS,nomeTabela);
           if DM.CDS_CONSULTAS.RecordCount = 0 then
           begin
              Application.MessageBox('No momento não existem engenheiros civis inativos!',
                 'Sem Inativos!', MB_OK + MB_ICONINFORMATION);
              Close;

           end else
           begin
              Application.CreateForm(TF_REATIVARCREDENCIADO,  F_REATIVARCREDENCIADO);
              F_REATIVARCREDENCIADO.ShowModal;
              FreeAndNil(F_REATIVARCREDENCIADO);

          end;
     end;     
     close;

end;

procedure TF_ESCOLHATIPODEFORMACAOREATIVAR.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    FecharTabelas;

end;

procedure TF_ESCOLHATIPODEFORMACAOREATIVAR.FormShow(Sender: TObject);
begin
     AbrirTabelas;

end;

end.
