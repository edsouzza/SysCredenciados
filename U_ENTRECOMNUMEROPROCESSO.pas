unit U_ENTRECOMNUMEROPROCESSO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, Buttons;

type
  TF_NUMPROCESSO = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnAtribuir: TSpeedButton;
    btnCancelar: TSpeedButton;
    txtEntraProcesso: TEdit;
    txtCOMPLEMENTO: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAtribuirClick(Sender: TObject);
    procedure txtEntraProcessoKeyPress(Sender: TObject; var Key: Char);
    procedure txtEntraProcessoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtCOMPLEMENTOKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_NUMPROCESSO: TF_NUMPROCESSO;

implementation

uses U_BIBLIOTECA;

{$R *.dfm}

procedure TF_NUMPROCESSO.FormCreate(Sender: TObject);
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
  numProcDigitado := '';
end;

procedure TF_NUMPROCESSO.btnCancelarClick(Sender: TObject);
begin
clicouNaoAtribuidos:=false;
close;
end;

procedure TF_NUMPROCESSO.btnAtribuirClick(Sender: TObject);
begin
  numProcDigitado := txtEntraProcesso.Text;
  NumProcesso     := txtEntraProcesso.Text;
  NumProcesso     := retiraPontosETracos(NumProcesso);

  complementoProc := (txtCOMPLEMENTO.Text);

  if((Pos('.',complementoProc) = 2) or (Pos('.',complementoProc) = 3) or (Pos('.',complementoProc) = 4))then   //4a.vara  => 4a. Vara
  begin
      //complementoProc := LowerCase(complementoProc);
      //ShowMessage('Temos um ponto na terceira posição da string -> '+complementoProc);

      //se nao colocar nada nos parametros converte apenas a primeira ocorrencia
      complementoProc := StringReplace(complementoProc, '.', '. ', []);  //qdo achar a primeira letra V substitua por um (espaço mais a letra V)
      complementoProc := PrimeirasLetrasMaiusculas(complementoProc);

  end;

  inseriuProcesso:=true;
  close;

end;

procedure TF_NUMPROCESSO.txtEntraProcessoKeyPress(Sender: TObject;
  var Key: Char);
begin
   //SO ACEITA NUMEROS / TRAÇOS / PONTOS
   if not (Key in['0'..'9','.','-',Chr(8)]) then Key:= #0;

end;

procedure TF_NUMPROCESSO.txtEntraProcessoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    if ( key = vk_return ) then
     begin
          txtCOMPLEMENTO.SetFocus;
     end;

end;

procedure TF_NUMPROCESSO.txtCOMPLEMENTOKeyPress(Sender: TObject;
  var Key: Char);
begin
   //SO ACEITA LETRAS / NUMEROS / PONTOS / TRAÇOS / ESPACOS / BACKSPACE / ENTER
   if not (Key in['a'..'z','A'..'Z','0'..'9','.','-',#32,#8,#13]) then Key:= #0;


end;

end.


