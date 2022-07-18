object DM: TDM
  OldCreateOrder = False
  Left = 578
  Top = 155
  Height = 580
  Width = 562
  object CONN: TSQLConnection
    ConnectionName = 'CONCREDENCIADOS'
    DriverName = 'UIB FireBird15'
    GetDriverFunc = 'getSQLDriverINTERBASE'
    LibraryName = 'dbexpUIBfire15.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=UIB FireBird15'
      'BlobSize=-1'
      'CommitRetain=False'
      
        'Database=C:\Meus Documentos\Bancos_De_Projetos\CredPeritos\CREDP' +
        'ERITOS.fdb'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Password=masterkey'
      'RoleName=RoleName'
      'ServerCharSet='
      'SQLDialect=3'
      'Interbase TransIsolation=ReadCommited'
      'User_Name=SYSDBA'
      'WaitOnLocks=True')
    VendorLib = 'fbclient.dll'
    BeforeConnect = CONNBeforeConnect
    Left = 16
    Top = 8
  end
  object CDSPESQ: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSPPESQ'
    Left = 208
    Top = 8
  end
  object SDSPESQ: TSQLDataSet
    CommandText = 'SELECT * FROM TBL_CREDENCIADOS'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = CONN
    Left = 80
    Top = 8
  end
  object DSPPESQ: TDataSetProvider
    DataSet = SDSPESQ
    Options = [poAllowCommandText]
    Left = 144
    Top = 8
  end
  object QRY_GERAL: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = CONN
    Left = 344
    Top = 8
  end
  object QRY_COD: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = CONN
    Left = 418
    Top = 8
  end
  object DSPESQ: TDataSource
    DataSet = CDSPESQ
    Left = 280
    Top = 8
  end
  object SQL_USUARIOS: TSQLDataSet
    CommandText = 
      'SELECT * FROM TBL_USUARIOS WHERE ID_USUARIO > 1 AND STATUS = '#39'AT' +
      'IVO'#39' ORDER BY NOME'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = CONN
    Left = 76
    Top = 131
  end
  object DSP_USUARIOS: TDataSetProvider
    DataSet = SQL_USUARIOS
    Options = [poAllowCommandText]
    Left = 204
    Top = 131
  end
  object DS_USUARIOS: TDataSource
    DataSet = CDS_USUARIOS
    Left = 444
    Top = 131
  end
  object CDS_USUARIOS: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSP_USUARIOS'
    Left = 324
    Top = 131
    object CDS_USUARIOSID_USUARIO: TIntegerField
      FieldName = 'ID_USUARIO'
      Required = True
    end
    object CDS_USUARIOSNOME: TStringField
      FieldName = 'NOME'
      Size = 255
    end
    object CDS_USUARIOSLOGIN: TStringField
      FieldName = 'LOGIN'
      EditMask = 'A999999;1;_'
      Size = 255
    end
    object CDS_USUARIOSSENHA: TStringField
      FieldName = 'SENHA'
      Size = 15
    end
    object CDS_USUARIOSNIVELACESSO: TIntegerField
      FieldName = 'NIVELACESSO'
    end
    object CDS_USUARIOSORGAO: TStringField
      FieldName = 'ORGAO'
      Size = 255
    end
    object CDS_USUARIOSCADASTRANTE: TStringField
      FieldName = 'CADASTRANTE'
      Size = 255
    end
    object CDS_USUARIOSDATACAD: TStringField
      FieldName = 'DATACAD'
      Size = 15
    end
    object CDS_USUARIOSSTATUS: TStringField
      FieldName = 'STATUS'
      Size = 255
    end
    object CDS_USUARIOSOBS: TStringField
      FieldName = 'OBS'
      Size = 255
    end
  end
  object SQL_LOGOPERACOES: TSQLDataSet
    CommandText = 'SELECT * FROM LOG_OPERACOES ORDER BY ID_OPERACAO DESC'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = CONN
    Left = 76
    Top = 195
  end
  object DSP_LOGOPERACOES: TDataSetProvider
    DataSet = SQL_LOGOPERACOES
    Options = [poAllowCommandText]
    Left = 204
    Top = 195
  end
  object DS_LOGOPERACOES: TDataSource
    DataSet = CDS_LOGOPERACOES
    Left = 444
    Top = 195
  end
  object CDS_LOGOPERACOES: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSP_LOGOPERACOES'
    Left = 324
    Top = 195
  end
  object CDS_BACKUP: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSP_BACKUP'
    Left = 329
    Top = 252
    object CDS_BACKUPID_BACKUP: TIntegerField
      FieldName = 'ID_BACKUP'
      Required = True
    end
    object CDS_BACKUPTXT_ORIGEM: TStringField
      FieldName = 'TXT_ORIGEM'
      Size = 200
    end
    object CDS_BACKUPTXT_DESTINO: TStringField
      FieldName = 'TXT_DESTINO'
      Size = 200
    end
  end
  object DS_BACKUP: TDataSource
    DataSet = CDS_BACKUP
    Left = 449
    Top = 252
  end
  object SQL_BACKUP: TSQLDataSet
    CommandText = 'SELECT * FROM CONFIG_BACKUP'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = CONN
    Left = 73
    Top = 252
  end
  object DSP_BACKUP: TDataSetProvider
    DataSet = SQL_BACKUP
    Options = [poAllowCommandText]
    Left = 209
    Top = 252
  end
  object SQL_TIPOSACESSO: TSQLDataSet
    CommandText = 'SELECT * FROM TBL_TIPOSACESSO WHERE ID_TIPOSACESSO>1'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = CONN
    Left = 76
    Top = 323
  end
  object DSP_TIPOSACESSO: TDataSetProvider
    DataSet = SQL_TIPOSACESSO
    Options = [poAllowCommandText]
    Left = 204
    Top = 323
  end
  object DS_TIPOSACESSO: TDataSource
    DataSet = CDS_TIPOSACESSO
    Left = 444
    Top = 323
  end
  object CDS_TIPOSACESSO: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSP_TIPOSACESSO'
    Left = 324
    Top = 323
  end
  object SQL_TIPO: TSQLDataSet
    CommandText = 'SELECT * FROM TBL_TIPO'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = CONN
    Left = 76
    Top = 68
  end
  object DSP_TIPO: TDataSetProvider
    DataSet = SQL_TIPO
    Options = [poAllowCommandText]
    Left = 204
    Top = 68
  end
  object DS_TIPO: TDataSource
    DataSet = CDS_TIPO
    Left = 444
    Top = 68
  end
  object CDS_TIPO: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSP_TIPO'
    Left = 324
    Top = 68
  end
  object SQL_PROCESSOS: TSQLDataSet
    CommandText = 'SELECT * FROM TBL_PROCESSOS'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = CONN
    Left = 77
    Top = 388
  end
  object DSP_PROCESSOS: TDataSetProvider
    DataSet = SQL_PROCESSOS
    Options = [poAllowCommandText]
    Left = 205
    Top = 383
  end
  object CDS_PROCESSOS: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSP_PROCESSOS'
    Left = 325
    Top = 380
    object CDS_PROCESSOSID_PROCESSO: TIntegerField
      FieldName = 'ID_PROCESSO'
      Required = True
    end
    object CDS_PROCESSOSNUMERO: TStringField
      FieldName = 'NUMERO'
      Size = 255
    end
    object CDS_PROCESSOSATRIBUIDORID: TIntegerField
      FieldName = 'ATRIBUIDORID'
    end
    object CDS_PROCESSOSDATAATRIB: TStringField
      FieldName = 'DATAATRIB'
      Size = 15
    end
    object CDS_PROCESSOSDATACAD: TStringField
      FieldName = 'DATACAD'
      Size = 15
    end
    object CDS_PROCESSOSCONSELHOPROC: TStringField
      FieldName = 'CONSELHOPROC'
    end
    object CDS_PROCESSOSCOMPLEMENTO: TStringField
      FieldName = 'COMPLEMENTO'
      Size = 40
    end
    object CDS_PROCESSOSFORMACAOID: TIntegerField
      FieldName = 'FORMACAOID'
    end
  end
  object DS_PROCESSOS: TDataSource
    DataSet = CDS_PROCESSOS
    Left = 445
    Top = 380
  end
  object SQL_CONSULTAS: TSQLDataSet
    CommandText = 'SELECT * FROM TBL_ARQUITETO WHERE STATUS='#39'ATIVO'#39
    MaxBlobSize = -1
    Params = <>
    SQLConnection = CONN
    Left = 80
    Top = 459
  end
  object DSP_CONSULTAS: TDataSetProvider
    DataSet = SQL_CONSULTAS
    Options = [poAllowCommandText]
    Left = 208
    Top = 459
  end
  object CDS_CONSULTAS: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSP_CONSULTAS'
    Left = 328
    Top = 459
  end
  object DS_CONSULTAS: TDataSource
    DataSet = CDS_CONSULTAS
    Left = 448
    Top = 451
  end
end
