unit U_RELATORIOS;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls, Dialogs,
  FMTBcd, DBClient, Provider, DB, SqlExpr, QRCtrls, QuickRpt, ExtCtrls,
  StdCtrls, Forms;

type
  TQ_RELATORIOS = class(TQuickRep)
    qrbndPageHeaderBand1: TQRBand;
    lblTitulo: TQRLabel;
    qrsysdt2: TQRSysData;
    qrbndColumnHeaderBand1: TQRBand;
    qrlbl16: TQRLabel;
    qrlbl17: TQRLabel;
    qrlbl5: TQRLabel;
    lblDocumento: TQRLabel;
    qrbndDetailBand1: TQRBand;
    nomeDetalhe: TQRDBText;
    posicaoDetalhe: TQRDBText;
    dataDetalhe: TQRDBText;
    documentoDetalhe: TQRDBText;
    qrbnd1: TQRBand;
    qrsysdt1: TQRSysData;
    QRLabel1: TQRLabel;
    QRLabelTotal: TQRLabel;
    SQL_RELATORIOS: TSQLDataSet;
    DSP_RELATORIOS: TDataSetProvider;
    CDS_RELATORIOS: TClientDataSet;
    QRLabel2: TQRLabel;
    cpfDetalhe: TQRDBText;
    imgLogoPMSP: TQRImage;
    QRLabel3: TQRLabel;
    QRDBText1: TQRDBText;
    procedure QuickRepBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
  private

  public

  end;

var
  Q_RELATORIOS: TQ_RELATORIOS;

implementation

uses U_DM, U_BIBLIOTECA, U_PRINCIPAL;

{$R *.DFM}


procedure TQ_RELATORIOS.QuickRepBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
F_PRINCIPAL.Timer1.Enabled := True;
end;

end.
