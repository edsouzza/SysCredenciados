unit U_DM;

interface

uses
  SysUtils, Classes, DBXpress, FMTBcd, DBClient, DB, Provider, SqlExpr, IniFiles, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdStackWindows;

type
  TDM = class(TDataModule)
    CONN: TSQLConnection;
    CDSPESQ: TClientDataSet;
    SDSPESQ: TSQLDataSet;
    DSPPESQ: TDataSetProvider;
    QRY_GERAL: TSQLQuery;
    QRY_COD: TSQLQuery;
    DSPESQ: TDataSource;
    SQL_USUARIOS: TSQLDataSet;
    DSP_USUARIOS: TDataSetProvider;
    DS_USUARIOS: TDataSource;
    CDS_USUARIOS: TClientDataSet;
    SQL_LOGOPERACOES: TSQLDataSet;
    DSP_LOGOPERACOES: TDataSetProvider;
    DS_LOGOPERACOES: TDataSource;
    CDS_LOGOPERACOES: TClientDataSet;
    CDS_BACKUP: TClientDataSet;
    CDS_BACKUPID_BACKUP: TIntegerField;
    CDS_BACKUPTXT_ORIGEM: TStringField;
    CDS_BACKUPTXT_DESTINO: TStringField;
    DS_BACKUP: TDataSource;
    SQL_BACKUP: TSQLDataSet;
    DSP_BACKUP: TDataSetProvider;
    SQL_TIPOSACESSO: TSQLDataSet;
    DSP_TIPOSACESSO: TDataSetProvider;
    DS_TIPOSACESSO: TDataSource;
    CDS_TIPOSACESSO: TClientDataSet;
    SQL_TIPO: TSQLDataSet;
    DSP_TIPO: TDataSetProvider;
    DS_TIPO: TDataSource;
    CDS_TIPO: TClientDataSet;
    SQL_PROCESSOS: TSQLDataSet;
    DSP_PROCESSOS: TDataSetProvider;
    CDS_PROCESSOS: TClientDataSet;
    DS_PROCESSOS: TDataSource;
    SQL_CONSULTAS: TSQLDataSet;
    DSP_CONSULTAS: TDataSetProvider;
    CDS_CONSULTAS: TClientDataSet;
    DS_CONSULTAS: TDataSource;
    CDS_USUARIOSID_USUARIO: TIntegerField;
    CDS_USUARIOSNOME: TStringField;
    CDS_USUARIOSLOGIN: TStringField;
    CDS_USUARIOSSENHA: TStringField;
    CDS_USUARIOSNIVELACESSO: TIntegerField;
    CDS_USUARIOSORGAO: TStringField;
    CDS_USUARIOSCADASTRANTE: TStringField;
    CDS_USUARIOSDATACAD: TStringField;
    CDS_USUARIOSSTATUS: TStringField;
    CDS_USUARIOSOBS: TStringField;
    CDS_PROCESSOSID_PROCESSO: TIntegerField;
    CDS_PROCESSOSNUMERO: TStringField;
    CDS_PROCESSOSATRIBUIDORID: TIntegerField;
    CDS_PROCESSOSDATAATRIB: TStringField;
    CDS_PROCESSOSDATACAD: TStringField;
    CDS_PROCESSOSCONSELHOPROC: TStringField;
    CDS_PROCESSOSCOMPLEMENTO: TStringField;
    CDS_PROCESSOSFORMACAOID: TIntegerField;
    procedure CONNBeforeConnect(Sender: TObject);
    procedure CriarCaminhoDoBanco;
    procedure LerCaminhoDoBanco;

  private
    { Private declarations }

  public
    { Public declarations }
    Arquivo : TIniFile;
   
  end;

var
  DM: TDM;


implementation

uses U_BIBLIOTECA, U_PRINCIPAL;

{$R *.dfm}

procedure TDM.CONNBeforeConnect(Sender: TObject);
begin
      LerCaminhoDoBanco;
end;

procedure TDM.LerCaminhoDoBanco;
begin
        Arquivo := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Config.ini');

        if (FileExists(ExtractFilePath(Application.ExeName) + 'Config.ini'))then
        begin
           
            With DM.CONN do
            begin

              Params.Values['DATABASE'] := Arquivo.ReadString('caminho_do_banco','DATABASE','Erro ao tentar acessar o banco de dados');
              Arquivo.Free;

            End;

        end else begin

            //ShowMessage('Arquivo de Configura��o n�o encontrado,'+#13+'Click em OK para criar uma conex�o local!');
            CriarCaminhoDoBanco;

        end;

end;

procedure TDM.CriarCaminhoDoBanco;
begin

      //nesse linha a aplica��o cria o arquivo no diretorio dela mesma, se o mesmo existir substitui pelo atual
      Arquivo := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Config.ini');

      //na linha seguinte escreve no arquivo o caminho do banco de dados dentro do arquivo .ini
      Arquivo.WriteString('caminho_do_banco','DATABASE',GetIPLocal+':C:\meus documentos\bancos_de_projetos\CredPeritos\CredPeritos.fdb');

end;


end.
