unit U_MOSTRAIPSERVIDOR;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, Mask, DBCtrls,
  Menus, ImgList, IniFiles;

type
  TF_IPSERVIDOR = class(TForm)
    pnl_cabecalho: TPanel;
    pnl_rodape: TPanel;
    pnl_EscolhaUsuario: TPanel;
    lblHoraAtual: TLabel;
    lblDataDoDia: TLabel;
    GroupBox1: TGroupBox;
    lblIPServidor: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure pnl_rodapeClick(Sender: TObject);

  private

    { Private declarations }


  public
    { Public declarations }
    Arquivo : TIniFile;

  end;

var
  F_IPSERVIDOR: TF_IPSERVIDOR;
  const chave = 7;


implementation

uses U_BIBLIOTECA, U_DM, SqlExpr, U_DMPESQ, U_PRINCIPAL, DB, U_EDITARLOGIN, U_SENHAS, U_LoginDeAcessos;


{$R *.dfm}

procedure TF_IPSERVIDOR.FormCreate(Sender: TObject);
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

   lblDataDoDia.Caption  :=  DateToStr(date);
   lblHoraAtual.Caption  :=  timetoStr(time);
   lblIPServidor.Caption :=  GetIPLocal;     

end;

procedure TF_IPSERVIDOR.pnl_rodapeClick(Sender: TObject);
begin
  close;
end;

end.
