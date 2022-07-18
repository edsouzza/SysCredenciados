unit U_ESCOLHATIPODEFORMACAOCAD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, ToolEdit, Buttons, DB, Grids, DBGrids,
  DBCtrls;

type
  TF_ESCOLHATIPODEFORMACAOCAD = class(TForm)
    GridCredenciados: TDBGrid;
    DBIDTIPOFUNC: TDBEdit;
    procedure btnFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridCredenciadosCellClick(Column: TColumn);
    procedure AbrirTabelas;
    procedure FecharTabelas;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_ESCOLHATIPODEFORMACAOCAD: TF_ESCOLHATIPODEFORMACAOCAD;

implementation

uses U_BIBLIOTECA, U_DM, SqlExpr, U_CADPADRAO;

{$R *.dfm}

procedure TF_ESCOLHATIPODEFORMACAOCAD.FormCreate(
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

procedure TF_ESCOLHATIPODEFORMACAOCAD.FormShow(Sender: TObject);
begin
    AbrirTabelas;

end;

procedure TF_ESCOLHATIPODEFORMACAOCAD.AbrirTabelas;
begin
     DM.CDS_TIPO.Active                  := TRUE;

end;     

procedure TF_ESCOLHATIPODEFORMACAOCAD.FecharTabelas;
begin
     DM.CDS_TIPO.Active                  := FALSE;  

end;

procedure TF_ESCOLHATIPODEFORMACAOCAD.btnFecharClick(
  Sender: TObject);
begin
    close;
    release;

end;

procedure TF_ESCOLHATIPODEFORMACAOCAD.GridCredenciadosCellClick(
  Column: TColumn);
begin
     IdTipoFormacao := 0;
     IdTipoFormacao := StrToInt(DBIDTIPOFUNC.text);
     nomeDaFormacao := (DM.CDS_TIPO.fieldbyname('TIPO').AsString);

     if ( IdTipoFormacao = 3 ) then
     begin
           nomeTabela := 'TBL_ARQUITETO';
           AbrirTabela(DM.CDS_CONSULTAS,nomeTabela);

          Application.CreateForm(TF_CADPADRAO,  F_CADPADRAO);
          F_CADPADRAO.ShowModal;
          FreeAndNil(F_CADPADRAO);


     end else if ( IdTipoFormacao = 4 ) then
     begin
           nomeTabela := 'TBL_CONTADOR';
           AbrirTabela(DM.CDS_CONSULTAS,nomeTabela);

          Application.CreateForm(TF_CADPADRAO,  F_CADPADRAO);
          F_CADPADRAO.ShowModal;
          FreeAndNil(F_CADPADRAO);

     end else if ( IdTipoFormacao = 1 ) then
     begin
           nomeTabela := 'TBL_ENGENHEIROAMBIENTAL';
           AbrirTabela(DM.CDS_CONSULTAS,nomeTabela);

          Application.CreateForm(TF_CADPADRAO,  F_CADPADRAO);
          F_CADPADRAO.ShowModal;
          FreeAndNil(F_CADPADRAO);

    end else if ( IdTipoFormacao = 2 ) then
    begin
           nomeTabela := 'TBL_ENGENHEIROCIVIL';
            AbrirTabela(DM.CDS_CONSULTAS,nomeTabela);

            Application.CreateForm(TF_CADPADRAO,  F_CADPADRAO);
            F_CADPADRAO.ShowModal;
            FreeAndNil(F_CADPADRAO);   

     end;
     close;

end;


procedure TF_ESCOLHATIPODEFORMACAOCAD.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin    
    FecharTabelas;

end;

end.
