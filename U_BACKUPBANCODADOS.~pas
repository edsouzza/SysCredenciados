unit U_BACKUPBANCODADOS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellApi, ExtCtrls, Buttons;

type
  TF_BACKUPBANCO = class(TForm)
    pnl_cabecalho: TPanel;
    pnl_rodape: TPanel;
    lblHoraAtual: TLabel;
    lblStatusLogoff: TLabel;
    lblDataDoDia: TLabel;
    lbl45: TLabel;
    CaminhoDoBanco: TOpenDialog;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edt_origem: TEdit;
    edt_destino: TEdit;
    btnProcurarArqOrigem: TButton;
    btnSetarPastaDestino: TButton;
    Panel2: TPanel;
    btnGravarConfs: TSpeedButton;
    btnExecutar_backup: TSpeedButton;
    btnSair: TSpeedButton;
    CaminhoDoBackup: TOpenDialog;
    procedure btnExecutar_backupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AbrirTabelas;
    procedure btnProcurarArqOrigemClick(Sender: TObject);
    procedure btnSetarPastaDestinoClick(Sender: TObject);
    procedure btnGravarConfsClick(Sender: TObject);
    procedure MostrarConfigGravada;
    procedure FormShow(Sender: TObject);
    procedure LimparPastaDeBackup;
    procedure GerarLogBackup(acesso : string);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_BACKUPBANCO: TF_BACKUPBANCO;

implementation

uses U_DM, U_BIBLIOTECA, U_DMPESQ;

{$R *.dfm}

procedure TF_BACKUPBANCO.FormCreate(Sender: TObject);
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

  lblDataDoDia.Caption           := DateToStr(date);
  lblHoraAtual.Caption           := timetoStr(time);
  lblStatusLogoff.Caption        := IdentificarUsuarioLogado;
  AbrirTabelas;

end;


procedure TF_BACKUPBANCO.btnExecutar_backupClick(Sender: TObject);
var 
SR: TSearchRec; 
I: integer; 
Origem, Destino: string;

begin

  if not (edt_origem.Text = edt_destino.Text) then
  begin

      if (edt_origem.Text = '') or (edt_destino.Text = '') then
      begin

          Application.MessageBox('Defina a origem e o destino do backup para continuar...',
                     'Origem ou Destino não definidos', MB_OK + MB_ICONERROR);
           exit;

      end else
      begin

           LimparPastaDeBackup; // PRIMEIRO LIMPA A PASTA E DEPOIS GRAVA O NOVO BACKUP

           I := FindFirst(edt_origem.text +'*.fdb', faAnyFile, SR); // Local de Origem

           while I = 0 do begin

                if (SR.Attr and faDirectory) <> faDirectory then
                begin

                  Origem  := edt_origem.text + SR.Name;
                  Destino := edt_destino.text + SR.Name;

                  if not CopyFile(PChar(Origem), PChar(Destino), true) then
                  ShowMessage('Erro ao copiar ' + Origem + ' para ' + Destino);

                end;

                   I := FindNext(SR);

            end;

             ShowMessage('Backup realizado com sucesso!');

             GerarLogBackup('Último backup realizado: '+ DateToStr(date) + ' ás ' + TimeToStr(time) );

             btnExecutar_backup.Enabled := false;

      end;


  end else begin

       Application.MessageBox('A pasta de destino não pode a mesma da origem!',
                 'Atenção pasta inválida', MB_OK + MB_ICONERROR);
       edt_destino.Clear;

       exit;

  end;

end;


procedure TF_BACKUPBANCO.btnSairClick(Sender: TObject);
begin

  close;

end;

procedure TF_BACKUPBANCO.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

    DM.CDS_BACKUP.Active      := false;
    Release;

end;

procedure TF_BACKUPBANCO.AbrirTabelas;
begin

   DM.CDS_BACKUP.Active      := True;

end;

procedure TF_BACKUPBANCO.btnProcurarArqOrigemClick(Sender: TObject);
begin

     btnExecutar_backup.Enabled := true;

     if CaminhoDoBanco.Execute then
      begin

           //COM O EXTRACTFILEPATH O TXT MOSTRARA APENAS A PASTA E NÃO O ARQUIVO
           edt_origem.Text :=  ExtractFilePath(CaminhoDoBanco.FileName);

      end;

end;

procedure TF_BACKUPBANCO.btnSetarPastaDestinoClick(Sender: TObject);
begin

     if CaminhoDoBackup.Execute then
      begin

           edt_destino.Text  := CaminhoDoBackup.FileName;

      end;

      //COM O EXTRACTFILEPATH O TXT MOSTRARA APENAS A PASTA E NÃO O ARQUIVO
      edt_destino.Text :=  ExtractFilePath(CaminhoDoBackup.FileName);
      btnExecutar_backup.Enabled := false;
      btnGravarConfs.Enabled     := true;

end;

procedure TF_BACKUPBANCO.btnGravarConfsClick(Sender: TObject);
begin

    if not (edt_origem.Text = edt_destino.Text) then
    begin

           if DM.CDS_BACKUP.RecordCount > 0 then
           begin

                With DMPESQ.Qry_Geral do
                begin

                     close;
                     sql.Clear;
                     sql.Add('UPDATE config_backup SET txt_origem = :pOrigem, txt_destino = :pDestino');
                     Params.ParamByName('pOrigem').AsString   :=  edt_origem.Text ;
                     Params.ParamByName('pDestino').AsString  :=  edt_destino.Text ;
                     ExecSQL();

                end;

               Application.MessageBox('Backup configurado com sucesso!', 'OK!', MB_OK);
               LogOperacoes(NomeDoUsuarioLogado, 'alteracao na configuracao de backup');
               btnExecutar_backup.Enabled := true;
               btnGravarConfs.Enabled     := false;

           end
           else begin

                  // ATUALIZANDO O CAIXA
                   With DMPESQ.qry_Cod do begin

                      Close;
                      SQL.Clear;
                      SQL.Add('select max(id_backup) from config_backup');
                      Open;

                      if not IsEmpty then begin

                         proxNum := DMPESQ.qry_Cod.Fields[0].AsInteger + 1;

                      end;

                   end;


                    with DM.CDS_BACKUP do begin

                        Append;
                        FieldByName('id_backup').AsInteger       := proxNum;
                        FieldByName('txt_origem').AsString       := edt_origem.Text;
                        FieldByName('txt_destino').AsString      := edt_destino.Text;
                        ApplyUpdates(0);

                    end;

               Application.MessageBox('Backup configurado com sucesso!', 'OK!', MB_OK);
               btnExecutar_backup.Enabled := true;
               btnGravarConfs.Enabled     := false;

           end;

    end else begin

         Application.MessageBox('A pasta de destino não pode a mesma da origem!',
                   'Atenção pasta inválida', MB_OK + MB_ICONERROR);
         edt_destino.Clear;
         exit;

    end;

end;

procedure TF_BACKUPBANCO.MostrarConfigGravada;
begin

       with DM.CDS_BACKUP do
       begin

         close;
         CommandText := 'SELECT * FROM config_backup' ;
         open;

             if not IsEmpty then begin

                 edt_origem.Text   := DM.CDS_BACKUP.Fields[1].AsString;
                 edt_destino.Text  := DM.CDS_BACKUP.Fields[2].AsString;

             end;

       end;

end;

procedure TF_BACKUPBANCO.FormShow(Sender: TObject);
begin

    MostrarConfigGravada;

end;

procedure TF_BACKUPBANCO.LimparPastaDeBackup;
var
caminho : string;
SR: TSearchRec;
I: integer;

begin

  //APAGA TODOS OS ARQUIVOS DA PASTA DE BACKUP

  caminho := edt_destino.Text+'*.*';

  I := FindFirst(caminho, faAnyFile, SR);

  while I = 0 do
  begin

      if (SR.Attr and faDirectory) <> faDirectory then
       begin

          caminho:= ExtractFilePath(edt_destino.Text) + SR.Name;

          if not DeleteFile(caminho) then
            ShowMessage('Erro ao deletar  ' + caminho);

       end;

      I := FindNext(SR);

   end;

end;     


procedure TF_BACKUPBANCO.GerarLogBackup(acesso: string);
var
Arq : TextFile;
begin

  AssignFile(Arq, ExtractFilePath(edt_destino.Text)+'Log backup.log');
  if not FileExists(ExtractFilePath(edt_destino.Text)+'Log backup.log') then Rewrite(arq,ExtractFilePath(edt_destino.Text)+'Log backup.log');
  Append(arq);
  Writeln(Arq, acesso);
  Writeln(Arq, '');
  CloseFile(Arq);

end;

end.
