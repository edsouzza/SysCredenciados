unit U_RELPROCSCREDENCIADO;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, FMTBcd, DB, DBClient,
  Provider, SqlExpr;

type
  TQ_RELPROCSCREDENCIADO = class(TQuickRep)
    qrbndPageHeaderBand1: TQRBand;
    qr_Titulo: TQRLabel;
    qrsysdt2: TQRSysData;
    qrgrp1: TQRGroup;
    qrlbl3: TQRLabel;
    QRShape1: TQRShape;
    QRLabel1: TQRLabel;
    qrbndDetailBand1: TQRBand;
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
    qrdbtxtDATAFECHAMENTO: TQRDBText;
    imgLogoPMSP: TQRImage;
    procedure QuickRepBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
  private

  public

  end;

var
  Q_RELPROCSCREDENCIADO: TQ_RELPROCSCREDENCIADO;

implementation

uses U_PRINCIPAL;

{$R *.DFM}

procedure TQ_RELPROCSCREDENCIADO.QuickRepBeforePrint(
  Sender: TCustomQuickRep; var PrintReport: Boolean);
begin
F_PRINCIPAL.Timer1.Enabled := True;
end;

end.
