object DMPESQ: TDMPESQ
  OldCreateOrder = False
  Left = 520
  Top = 201
  Height = 287
  Width = 581
  object CDSPESQ: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSPPESQ'
    Left = 216
    Top = 16
  end
  object DSPPESQ: TDataSetProvider
    DataSet = SQLPESQ
    Options = [poAllowCommandText]
    Left = 136
    Top = 16
  end
  object SQLPESQ: TSQLDataSet
    CommandText = 
      'SELECT distinct c.*, t.* FROM tbl_credenciado c, tbl_tipo t WHER' +
      'E c.tipo_id = t.id_tipo ORDER BY c.nome'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = DM.CONN
    Left = 56
    Top = 16
  end
  object QRY_GERAL: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = DM.CONN
    Left = 392
    Top = 16
  end
  object QRY_COD: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = DM.CONN
    Left = 490
    Top = 16
  end
  object DSPESQ: TDataSource
    DataSet = CDSPESQ
    Left = 296
    Top = 16
  end
  object CDS_FILTRARPORFORMACAO: TClientDataSet
    Aggregates = <>
    CommandText = 
      'SELECT distinct c.tipo_id, t.id_tipo, t.tipo FROM tbl_credenciad' +
      'o c, tbl_tipo t WHERE c.tipo_id = t.id_tipo ORDER BY t.tipo'
    Params = <>
    ProviderName = 'DSPPESQ'
    Left = 88
    Top = 160
  end
  object DS_FILTRARPORFORMACAO: TDataSource
    DataSet = CDS_FILTRARPORFORMACAO
    Left = 296
    Top = 160
  end
  object QRY_AUX: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = DM.CONN
    Left = 488
    Top = 88
  end
  object CDSAUX: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSPPESQ'
    Left = 216
    Top = 88
  end
  object DSAUX: TDataSource
    DataSet = CDSAUX
    Left = 296
    Top = 88
  end
end