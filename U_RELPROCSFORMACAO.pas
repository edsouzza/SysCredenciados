unit U_RELPROCSFORMACAO;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, FMTBcd, DB, DBClient,
  Provider, SqlExpr;

type
  TQ_RELPROCSFORMACAO = class(TQuickRep)
    qrbndPageHeaderBand1: TQRBand;
    qr_Titulo: TQRLabel;
    qrsysdt2: TQRSysData;
    qrgrp1: TQRGroup;
    qrlbl3: TQRLabel;
    QRLabel3: TQRLabel;
    QRDBText1: TQRDBText;
    QRShape1: TQRShape;
    QRLabel1: TQRLabel;
    qrbndDetailBand1: TQRBand;
    qrdbtxtDATAFECHAMENTO: TQRDBText;
    QRDBText2: TQRDBText;
    qrbnd1: TQRBand;
    qrsysdt4: TQRSysData;
    qrsysdt5: TQRSysData;
    QRY_RELPROCESSOS: TSQLDataSet;
    DSP_RELPROCESSOS: TDataSetProvider;
    CDS_RELPROCESSOS: TClientDataSet;
    CDS_RELPROCESSOSFORMACAOID: TIntegerField;
    CDS_RELPROCESSOSNUMERO: TStringField;
    CDS_RELPROCESSOSNOME: TStringField;
    CDS_RELPROCESSOSTIPO: TStringField;
    imgLogoPMSP: TQRImage;
    procedure QuickRepBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
  private

  public

  end;

var
  Q_RELPROCSFORMACAO: TQ_RELPROCSFORMACAO;

implementation

uses U_DM, U_PRINCIPAL;

{$R *.DFM}

procedure TQ_RELPROCSFORMACAO.QuickRepBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
F_PRINCIPAL.Timer1.Enabled := True;
end;

end.
