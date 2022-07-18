unit U_RELIMPRIMIRTELA;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, FMTBcd, DB, SqlExpr;

type
  TQ_RELIMPRIMIRTELA = class(TQuickRep)
    qrbndTitleBand1: TQRBand;
    lblTITULO: TQRLabel;
    qrsysdt2: TQRSysData;
    qrbnd2: TQRBand;
    qrshp6: TQRShape;
    qrlbl16: TQRLabel;
    qrlbl17: TQRLabel;
    qrdbtxtFUNC_ID: TQRDBText;
    qrdbtxtFUNC_NOME: TQRDBText;
    qrlbl20: TQRLabel;
    qrlbl21: TQRLabel;
    qrlbl22: TQRLabel;
    qrlbl23: TQRLabel;
    qrlbl24: TQRLabel;
    qrlbl25: TQRLabel;
    qrlbl26: TQRLabel;
    qrdbtxtCLI_ENDERECO: TQRDBText;
    qrdbtxtCLI_COMPLEMENTO: TQRDBText;
    qrdbtxtCLI_CEP: TQRDBText;
    qrdbtxtFUNC_FONE: TQRDBText;
    qrdbtxtCLI_EMAIL: TQRDBText;
    qrlbl2: TQRLabel;
    qrdbtxtFUNC_FUNCAOID: TQRDBText;
    lblOrgao: TQRLabel;
    qrdbtxt2: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText7: TQRDBText;
    qrbnd1: TQRBand;
    qrsysdt1: TQRSysData;
    QRYCOMPLETA: TSQLQuery;
    QRLabel1: TQRLabel;
    QRDBText8: TQRDBText;
    QRDBText1: TQRDBText;
    QRLabel3: TQRLabel;
    QRLabel5: TQRLabel;
    QRDBText5: TQRDBText;
    qrlbl27: TQRLabel;
    qrdbtxtFUNC_DATACAD: TQRDBText;
    QRLabel2: TQRLabel;
    memProcs: TQRMemo;
    QRShape2: TQRShape;
    QRLabel7: TQRLabel;
    QRShape1: TQRShape;
    QRLabel6: TQRLabel;
    lblStatus: TQRLabel;
    memDataAtribuicao: TQRMemo;
    QRLabel4: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    memNomeAtribuidor: TQRMemo;
    imgLogoPMSP: TQRImage;
    QRLabel10: TQRLabel;
    memComplemento: TQRMemo;
    procedure QuickRepBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
  private

  public

  end;

var
  Q_RELIMPRIMIRTELA: TQ_RELIMPRIMIRTELA;

implementation

uses U_DM, U_PRINCIPAL;

{$R *.DFM}

procedure TQ_RELIMPRIMIRTELA.QuickRepBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
F_PRINCIPAL.Timer1.Enabled := True;
end;

end.
