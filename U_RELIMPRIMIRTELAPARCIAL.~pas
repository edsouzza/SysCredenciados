unit U_RELIMPRIMIRTELAPARCIAL;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, FMTBcd, DB, SqlExpr;

type
  TQ_RELIMPRIMIRTELAPARCIAL = class(TQuickRep)
    qrbndTitleBand1: TQRBand;
    lblTITULO: TQRLabel;
    qrsysdt2: TQRSysData;
    QRYPARCIAL: TSQLQuery;
    qrbnd2: TQRBand;
    qrshp5: TQRShape;
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
    QRLabel1: TQRLabel;
    QRDBText8: TQRDBText;
    QRDBText1: TQRDBText;
    QRLabel3: TQRLabel;
    qrlbl27: TQRLabel;
    qrdbtxtFUNC_DATACAD: TQRDBText;
    QRLabel2: TQRLabel;
    qrbnd1: TQRBand;
    qrsysdt1: TQRSysData;
    QRLabel6: TQRLabel;
    lblStatus: TQRLabel;
    QRLabel5: TQRLabel;
    QRDBText3: TQRDBText;
    imgLogoPMSP: TQRImage;
    procedure QuickRepBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
  private

  public

  end;

var
  Q_RELIMPRIMIRTELAPARCIAL: TQ_RELIMPRIMIRTELAPARCIAL;

implementation

uses U_PRINCIPAL;

{$R *.DFM}

procedure TQ_RELIMPRIMIRTELAPARCIAL.QuickRepBeforePrint(
  Sender: TCustomQuickRep; var PrintReport: Boolean);
begin
F_PRINCIPAL.Timer1.Enabled := True;
end;

end.
