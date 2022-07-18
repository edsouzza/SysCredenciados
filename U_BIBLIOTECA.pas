unit U_BIBLIOTECA;

interface

uses QForms, Controls, DB, DBClient, StdCtrls, SqlExpr, ExtCtrls, Dialogs,
SysUtils, Variants, Classes, Buttons, Messages, Windows, Graphics, Forms,
Grids, DBGrids, Mask, DBCtrls, DateUtils, ToolEdit, Inifiles, MaskUtils,
Registry, idGlobal, CurrEdit, Winsock, WinInet, StrUtils, Printers;

//funcoes perso
Function ListaQdeRegs(cds: TClientDataSet):integer;
Function LetrasIniciaisMaiusculas(Texto:String): String;
Function PrimeirasLetrasMaiusculas(Str: string): string;
Function TemAcrobatReader: boolean;
Function TabelaVazia(nomeTabela:string):boolean;
Function TemDuplicidade(campo,tabela,valorString:string):boolean;
function DigitouRFCompleto(rf: string): boolean;
Function CriptografarSenha(sSenha:String):String;
Function DescriptografarSenha(sSenha:String):String;
Function RetornaNomeConselho(idTipo:integer):string;
Function RetornaNomeFormacaoPlural(idTipo:integer):string;
Function RetornaValorBanco(nomeTabela, campoRetornado : string; campoComparar, valorPesq : Variant): Variant;
Function MostrarIDUltimoReg(nomeTabela:string; nomeEdit:TEdit):integer;
Function TemAtribuido(nometabela:string):boolean;
Function NaoTemAtribuido(nometabela:string):boolean;
Function GerarProximoID(nomeCampoID, nomeTabela: string): integer;
Function CalcularClassificacaoInicial(nomeTabela:string; dbEdit:TDBEdit):integer;
Function LimparMascara(sTexto:String):String;
Function retiraPontosETracos(sTexto:string):string;
Function retornaNomeMaquina : String;
Function GetIPLocal:string;
Function Limita_Tamanho_Texto(texto_original:string;tam_max:integer):string;
function getNomeBancoSetado:string;
function CopyReverse(S: String; Index, Count : Integer) : String;
Function retornaQuantidadeRegsTabela(campoID,tabela:string):integer;
function GetIndiceImpressoraPadrao: Integer;
function GetNomeImpressoraPadrao: string;
function temImpressoraPadrao : Boolean;

//procedimentos perso
procedure SetImpressoraPadrao(Impressora: String);
procedure CriarNovaFormacao(nomeTabela: string);
procedure ImprimirVersaoCompleta(nomeTabela,conselho:string);
procedure ImprimirVersaoParcial(nomeTabela,conselho:string);
procedure CopiarArquivo(ArqOrigem, ArqDestino : String);
procedure LogOperacoes(usuario : string; ocorrencia : string);
procedure MostrarTodos(cds:TClientDataSet; nomeTabela:string);
procedure MostrarProcessosDoCredenciado(conselho:string; gridProc:TDBGrid);
procedure AtualizaQde(cds:TClientDataSet; txtMsg:TStaticText);
procedure LiberarAtribuicao(nomeTabela:string; btnAtribuirProc:TSpeedButton; DBID:TDBEdit; pan_titulo:TPanel);
procedure RetirarAtribuicoes(cds:TClientDataSet; nomeTabela:string; botao:TSpeedButton);
procedure AbrirTabela(cds:TClientDataSet; nomeTabela: string);
procedure AbrirTabelaInativos(cds:TClientDataSet; nomeTabela: string);
procedure formatarRelatoriosDisplay100;



var
  _Sql,IdentificarUsuarioLogado,NomeDoUsuarioLogado,texto, mes_ano, nomeMes, mes, cpf_cnpj, IDForne, DescProdutoGeral, senhaAcesso, senhaAdmDoBanco, senhaUsuarioDoBanco, complementoProc, ipServidor, ipLogado,
  NumVendaParaCreditos, ValorVendaParaCreditos, ValorDaParcelaAVista, NumNFGerarDuplicatas, ValorDuplicata, IPLocal, nome_anterior, nome_atualizado, nomeTabela,nomeDocOficial, IPMaquinaLocal,nomeMaquinaLocal,
  NomeDoClienteDaVenda, NomeFornecedorGerarDuplicata, historicoDaVendaParaCaixa, NomeDoProdutoParaVenda, nomeDaFormacao, nomeTabelaExclusao, NumProcesso, nomeConselho, numConselho, numProcDigitado, bancoDadosSetado,
  nomeArquivoPDFExclusao, caminhoDaPasta,tipoAcesso, loginAcessado, letraD, SenhaCriptografada, senhaDescriptografada, nomeUsuarioEditado, _sqlAuxiliar, textoAlterado, ipSetado, nomeBanco : string;

  IdDoUsuarioLogado, proxNum, flag, TotalRegs, Tentativas, numMes, IDOperador, opc, IDProdutoGeral, IDPedidoGerarDuplicatas, nivelDeAcesso, idUsuarioSelecionado,
  IDPrimeiroReg, IDUltimoReg, IDFornecedorGerarDuplicata, IDVendaParaAlterarData, idUsuario, idVenda, IdContatoSelecionado, qde, qdeRegs, IdTipoFormacao, IdExclusao,
  IdCredenciado, idAtual, ultimoID, proxNumProc, idProcesso, posicaoInicial, classIni, novaClassInicial : Integer;

  inseriuProcesso, alterouNome, novoReg, acessoBackupBanco, editando, usuarioEncontrado, EditarLogin, AcessarEdicaoLogin, clicouNaoAtribuidos, imprimiuRelatorio, logado : boolean;

  DataDoDia,  DataInicio, DataFim, DataAtual, DataVendaAlterada, DataVenda, DataSelecionada : TDate;

  dtDataDoDia : TDateEdit;

  valorTotal, valorDoItem  : double;

  Arquivo  : TIniFile;
 
implementation

uses U_DM, U_DMPESQ, U_RELIMPRIMIRTELA, U_RELIMPRIMIRTELAPARCIAL,
  U_RELPROCSCREDENCIADO, U_RELPROCSFORMACAO, U_RELUSUARIOS, U_PRINCIPAL;
var
s: string[255];
c: array[0..255] of Byte absolute s;



procedure formatarRelatoriosDisplay100;
var
  i : integer;
  tBar: TComponent; PrevFrm: TForm;
begin

     //tratando o tamanho dos relatórios ao abrir
      PrevFrm := nil;
      for i := 0 to Screen.FormCount-1 do
      with Screen.Forms[i] do

      if ClassName = 'TQRStandardPreview' then
      PrevFrm := Screen.Forms[i]; // Se não encontrou o Form, abandona

      if PrevFrm = nil then
      Exit;

      tBar := PrevFrm.FindComponent('ZoomFit'); //Zoom100
      if tBar <> nil then
      TSpeedButton(tBar).Click;

      F_PRINCIPAL.Timer1.Enabled := False;

end;

function CopyReverse(S: String; Index, Count : Integer) : String;
begin
  {corta string mas ao contrario do copy funciona de traz pra frente da string  ex: { Quero os 6 últimos caracteres, ou seja, a aprtir do último,
  quero os 6 caracteres do fim.
  ShowMessage( CopyReverse('Show Delphi', 1, 6) );  O resultado será Delphi}

  Result := ReverseString(S);
  Result := Copy(Result, Index, Count);
  Result := ReverseString(Result);

end;

function GetNomeImpressoraPadrao: string;
begin

  //retorna o nome da impressora padrao
 { try
     ShowMessage('Indice do impressora : '+inttostr(Printer.PrinterIndex));
     if (Printer.PrinterIndex >= 0) then
         Result := Printer.Printers[Printer.PrinterIndex];
  except
        Result := 'Nenhuma impressora padrão foi detectada,'+#13+'para   imprimir  instale   uma   impressora  e  tente  novamente.';
        //exit;
  end;    }

  //RETORNA O NOME DA IMPRESSORA PADRAO
  if (Printer.Printers.Count = 0) then
  begin

        //Application.MessageBox('Nenhuma    impressora    padrão    foi    detectada,'+#13+'para   imprimir   instale   uma   impressora  e  tente  novamente.','Nenhuma impessora instalada!', MB_OK + MB_ICONWARNING);
        //Result := '';
        exit;
        
  end else
  begin
        if(Printer.PrinterIndex >= 0)then
        begin
          Result := Printer.Printers[Printer.PrinterIndex]
        end else
          Result := '';//'Nenhuma impressora foi detectada...';
  end;

end;


procedure SetImpressoraPadrao(Impressora: String);
var I: Integer; Device: PChar; Driver: Pchar; Port: Pchar;
  HdeviceMode: Thandle; aPrinter: TPrinter;
begin
  Printer.PrinterIndex := -1;
  getmem(Device, 255);
  getmem(Driver, 255);
  getmem(Port, 255);
  aPrinter := TPrinter.create;
  for I := 0 to Printer.printers.Count-1 do
  begin
    if Printer.printers[i] = Impressora then
    begin
      aprinter.printerindex := i;
      aPrinter.getprinter(device, driver, port, HdeviceMode);
      StrCat(Device, ',');
      StrCat(Device, Driver );
      StrCat(Device, Port );
      WriteProfileString('windows', 'device', Device);
      StrCopy( Device, 'windows' );
      SendMessage(HWND_BROADCAST, WM_WININICHANGE, 0, Longint(@Device));
    end;
  end;
  Freemem(Device, 255);
  Freemem(Driver, 255);
  Freemem(Port, 255);
  aPrinter.Free;
end;

function GetIndiceImpressoraPadrao: Integer;
begin

  //RETORNA O INDICE DA IMPRESSORA PADRAO
  if (Printer.Printers.Count = 0) then
  begin
        Result := -1;
        Application.MessageBox('Nenhuma    impressora    padrão    foi    detectada,'+#13+'para   imprimir   instale   uma   impressora  e  tente  novamente.','Nenhuma impessora instalada!', MB_OK + MB_ICONWARNING);
        exit;
  end else
  begin
        if(Printer.PrinterIndex >= 0)then
          Result := Printer.PrinterIndex                     // ou Printer.Printers[Printer.PrinterIndex]
        else
          Result := -1;//'Nenhuma impressora foi detectada...';
  end;

end;

function temImpressoraPadrao : Boolean;
var
  indImpressoraPadaro  : integer;
begin

   //detectando se tem uma impressora instalada, sem sim mostra o nome senão msg de falta de impressora padrão
   indImpressoraPadaro  := GetIndiceImpressoraPadrao;
   //ShowMessage('indice impr padrao'+inttostr(indImpressoraPadaro));
   if (indImpressoraPadaro >= 0)then
      result := true
   else
      result := false;

end;

Function retornaQuantidadeRegsTabela(campoID,tabela:string):integer;
var
  total:integer;
begin
     total := 0;
     with DMPESQ.Qry_Geral do
     begin
          close;
          sql.Clear;
          sql.Add('SELECT '+campoID+' FROM '+tabela+'');
          open;

          if not IsEmpty then
          begin
             total := DMPESQ.Qry_Geral.RecordCount;
          end;
     end;
     Result := total;
end;


function GetIPLocal:string;
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe : PHostEnt;
  pptr : PaPInAddr;
  Buffer : array [0..63] of char;
  I : Integer;
  GInitData : TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  phe :=GetHostByName(buffer);
  if phe = nil then Exit;
  pptr := PaPInAddr(Phe^.h_addr_list);
  I := 0;
  while pptr^[I] <> nil do begin
  result:=StrPas(inet_ntoa(pptr^[I]^));
  result := StrPas(inet_ntoa(pptr^[I]^));
  Inc(I);
  end;
  WSACleanup;
end;


function getNomeBancoSetado:string;
begin

     Arquivo          := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Config.ini');
     bancoDadosSetado := Arquivo.ReadString('caminho_do_banco','DATABASE','');     //'10.71.32.39:C:\meus documentos\bancos_de_projetos\CredPeritos\CredPeritos.fdb'
     nomeBanco        := CopyReverse(bancoDadosSetado, 0, 14);

     if ( nomeBanco = 'CREDDESENV.fdb' ) then
     begin
        nomeBanco  := CopyReverse(bancoDadosSetado, 0, 14);
     end else
     begin
        nomeBanco  := CopyReverse(bancoDadosSetado, 0, 15);
     end;

        Result     := nomeBanco;

end;


Function RetornaValorBanco(nomeTabela, campoRetornado : string; campoComparar, valorPesq : Variant): Variant;
begin

     _Sql := 'SELECT '+campoRetornado+' FROM '+nomeTabela+' WHERE '+campoComparar+' = :pValorPesq';
     //ShowMessage(_Sql);

     With DM.CDSPESQ do
      begin
            Close;
            CommandText:= (_Sql);
            Params.ParamByName('pValorPesq').AsString := valorPesq;  
            Open;

             if not IsEmpty then begin

               Result   := DM.CDSPESQ.Fields[0].AsVariant;   

            end else begin

                Result := '';

            end;

      end;

end;


Function CalcularClassificacaoInicial(nomeTabela:string; dbEdit:TDBEdit):integer;
begin
     With DM.CDSPESQ do
      begin
            Close;
            CommandText:= ('select max(posicao_inicial) from '+nomeTabela);
            Open;

             if not IsEmpty then begin

               Result   := DM.CDSPESQ.Fields[0].AsInteger + 1;
               classIni := Result;

            end else begin

                Result := 0;

            end;

      end;
      dbEdit.Text := IntToStr(classIni);
end;

Function retornaNomeMaquina : String;
// Retorna o nome do computador
var
  lpBuffer : PChar;
  nSize    : DWord;
const Buff_Size = MAX_COMPUTERNAME_LENGTH + 1;
  begin
  try
    nSize    := Buff_Size;
    lpBuffer := StrAlloc(Buff_Size);
    GetComputerName(lpBuffer,nSize);
    Result   := String(lpBuffer);
    StrDispose(lpBuffer);
  except
    Result := '';
  end;
end;

Function retiraPontosETracos(sTexto:string):string;
 var
   iPos : Integer;
   iTamanho : Integer;
   sTextoSemFormato : String;
   sCaractere : String;
   sCaracMascaras : String;
begin
   Result := sTexto;
   if Trim(sTexto) = '' then begin
	  Exit;
   end;
   sTextoSemFormato := '';
   sCaracMascaras   := './><_+=[]{}()-$&@*';
   iTamanho := Length(sTexto);
   for iPos := 1 to iTamanho do begin
	   sCaractere := Trim(Copy(sTexto,iPos,1));
	   if (Pos(sCaractere,sCaracMascaras) = 0) AND (sCaractere <> '') then
	   begin
		  sTextoSemFormato := sTextoSemFormato + sCaractere;
	   end;
   end;
   Result := sTextoSemFormato;
 end;

function GerarProximoID(nomeCampoID, nomeTabela: string): integer;
begin
     //esta funcão gera um número de id para o proximo registro da tabela que for passada
     With DM.QRY_GERAL do
     begin
          Close;
          Sql.Clear;
          sql.Add('select max('+nomeCampoID+') from '+nomeTabela);
          Open;

          if not IsEmpty then
          begin
             Result  := DM.QRY_GERAL.Fields[0].AsInteger + 1;
             proxNum := Result;

          end else
          begin
             Result  := 0;

          end;
      end;

end;

Function LimparMascara(sTexto:String):String;
var
   iPos : Integer;
   iTamanho : Integer;
   sTextoSemFormato : String;
   sCaractere : String;
   sCaracMascaras : String;
begin
   Result := sTexto;
   if Trim(sTexto) = '' then begin
	  Exit;
   end;
   sTextoSemFormato := '';
   sCaracMascaras   := './><_+=[]{}()-$&@*';
   iTamanho := Length(sTexto);
   for iPos := 1 to iTamanho do begin
	   sCaractere := Trim(Copy(sTexto,iPos,1));
	   if (Pos(sCaractere,sCaracMascaras) = 0) AND (sCaractere <> '') then
	   begin
		  sTextoSemFormato := sTextoSemFormato + sCaractere;
	   end;
   end;
   Result := sTextoSemFormato;
end;

function DigitouRFCompleto(rf: string): boolean;
begin
    //contar quantos digitos tem na string Se tiver menos de 7 digitos => msg de erro : favor digitar os rf com DXXXXXX
    if(Length(rf) < 7)then
      Result := false
    else
      Result := true;
end;

Function RetornaNomeConselho(idTipo:integer):string;
begin

      case (idTipo) of
        1:
            if(imprimiuRelatorio)then
                 Result := 'Crea                          :'
            else
                 Result := 'Crea';

        2:
            if(imprimiuRelatorio)then
                 Result := 'Crea                          :'
            else
                 Result := 'Crea';

        3:
            if(imprimiuRelatorio)then
                 Result := 'Cau                           :'
            else
                 Result := 'Cau';

        4:
            if(imprimiuRelatorio)then
                 Result := 'Crc                           :'
            else
                 Result := 'Crc';

      end;

end;

Function RetornaNomeFormacaoPlural(idTipo:integer):string;
begin
      if ( idTipo = 1 ) then
           Result := 'engenheiros ambientais';

      if ( idTipo = 2 ) then
           Result := 'engenheiros civis';

      if ( idTipo = 3 ) then
           Result := 'arquitetos';

      if ( idTipo = 4 ) then
           Result := 'contadores';

end;

Function TemAtribuido(nometabela:string):boolean;
begin
    With DM.QRY_GERAL do
    begin
          Close;
          sql.Clear;
          sql.Add('SELECT * FROM '+nomeTabela+' WHERE atribuido = '+QuotedStr('S')+'');
          open;

          if not IsEmpty then
             Result:= true
          else
             Result:= false;

          end;
end;

Function Limita_Tamanho_Texto(texto_original:string;tam_max:integer):string;
var
  i:integer; // variavel contadora   // limitar o tamanho maximo de uma string
  texto_final:string; // variavel auxiliar para retorno da string
begin
  texto_final:=''; // inicializa variavel
  for I:=1 to tam_max do
  begin
    texto_final:=texto_final+texto_original[i]; // armazena caracteres até o num. X de caracteres
  end;
  result:=(texto_final); // retorna variavel do tamanho desejado
end;

Function NaoTemAtribuido(nometabela:string):boolean;
begin
    With DM.QRY_GERAL do
    begin
          Close;
          sql.Clear;
          sql.Add('SELECT * FROM '+nomeTabela+' WHERE atribuido = '+QuotedStr('N')+'');
          open;

          if not IsEmpty then
             Result:= true
          else
             Result:= false;

          end;
end;

Function MostrarIDUltimoReg(nomeTabela:string; nomeEdit:TEdit):integer;
begin
      With DM.CDSPESQ do
      begin
            Close;
            CommandText:=('SELECT FIRST 1 * FROM '+nomeTabela+' ORDER BY id_credenciado desc');
            open;
            if not IsEmpty then
            begin
               Result              := DM.CDSPESQ.Fields[0].AsInteger;
               IDUltimoReg         := Result;
               nomeEdit.text       := IntToStr(IDUltimoReg);

            end else
            begin
               Result  := 0;

            end;
        end;
end;

Function TemDuplicidade(campo,tabela,valorString:string):boolean;
begin
    //verifica no campo declarado se existe duplicidade no cadastro atual
    With DM.Qry_Geral do
    begin  
        Close;
        SQL.Clear;
        SQL.Add('SELECT '+campo+' FROM '+tabela+' WHERE '+campo+' = :pParam');
        ParamByName('pParam').AsString := valorString;
        Open;
        if not IsEmpty then
          Result := true
        else
          Result := false;
    end;
end;

function TemAcrobatReader: boolean;
var
  Registro : TRegistry;
begin
  Registro := TRegistry.Create;
  try
    Registro.RootKey := HKEY_LOCAL_MACHINE;
    Result := Registro.OpenKey('Software\Adobe\Acrobat Reader', false);
  finally
    Registro.Free;
  end;
end;

Function TabelaVazia(nomeTabela:string):boolean;
begin 
    With dm.QRY_GERAL do
    begin
        Close;
        sql.Clear;
        sql.Add('select * FROM '+nomeTabela);
        Open;

        if IsEmpty then begin
             Result := true;
        end else begin
             Result := false;
        end;     
    end;

end;

Function PrimeirasLetrasMaiusculas(Str: string): string;
var
  i: integer;
  esp: boolean;
begin
  {Converte a primeira letra de todas as palavras de uma string para maiúscula é o resto para minuscula}
  str := LowerCase(Trim(str));
  for i := 1 to Length(str) do
  begin
    if i = 1 then
      str[i] := UpCase(str[i])
    else
      begin
        if i <> Length(str) then
        begin
          esp := (str[i] = ' ');
          if esp then
            str[i+1] := UpCase(str[i+1]);
        end;
      end;
  end;
  Result := Str;
end;

Function LetrasIniciaisMaiusculas(Texto:String): String;
begin
     //CONVERTE SOMENTE A PRIMEIRA LETRA DA STRING EM MAIÚSCULA E AS RESTANTES PARA MINUSCULA
     if Texto <> '' then
     begin
         Texto := AnsiUpperCase(Copy(Texto,1,1))+AnsiLowerCase(Copy(Texto,2,Length(Texto)));
         Result := Texto;

     end;

end;

Function CriptografarSenha(sSenha:String):String;
 var
  i:Integer;
begin
  {Encode}
  s := sSenha;

  For i:=1 to ord(s[0]) do
  begin
    c[i]   := 23 Xor c[i];
    Result := s;
    senhaCriptografada := Result;
  end;

end;

Function DescriptografarSenha(sSenha:String):String;
var
  i:Integer;
begin
  {Decode}
  s := sSenha;

  For i:=1 to Length(s) do
  begin
    s[i]   := char(23 Xor ord(c[i]));
    Result := s;
    senhaDescriptografada := Result;
  end;

end;

procedure CriarNovaFormacao(nomeTabela: string);
var L:TStringList;
begin
  {==CRIANDO UMA NOVA TABELA NO BD==
   A classe TStringList é utilizada para armazenar e manipular
   uma lista de strings. Através do método Add da classe é possível
   inserir uma nova string a lista}

  //criando Stringlist na memória
  L := TStringList.Create;

  //pega o nome da tabela
  dm.CONN.GetTableNames(L);

  //pega a posição da tabela(começa no 0)
  if L.IndexOf(nomeTabela) >= 0 then
    begin
     Showmessage('Esta tabela já existe no BD!');
     Abort
    end
  else
    begin

     with DM.QRY_GERAL do
     begin
          Close;
          SQL.Clear;
          SQL.Add('create table '+nomeTabela+ '(' );
          Sql.Add('id_credenciado integer not null primary key, ');
          Sql.Add('POSICAO_INICIAL  INTEGER, ');
          Sql.Add('TIPO_ID          INTEGER, ');
          Sql.Add('CONSELHO         VARCHAR(20) COLLATE WIN_PTBR, ');
          Sql.Add('NOME             DM_NOMES_DESCR COLLATE WIN_PTBR, ');
          Sql.Add('ENDERECO         DM_NOMES_DESCR COLLATE WIN_PTBR, ');
          Sql.Add('BAIRRO           DM_NOMES_DESCR COLLATE WIN_PTBR, ');
          Sql.Add('CEP              DM_FONES COLLATE WIN_PTBR, ');
          Sql.Add('CPF              DM_NOMES_DESCR COLLATE WIN_PTBR, ');
          Sql.Add('DDDFONE          DM_DDD COLLATE WIN_PTBR, ');
          Sql.Add('FONE             DM_FONES COLLATE WIN_PTBR, ');
          Sql.Add('CELULAR          DM_FONES COLLATE WIN_PTBR, ');
          Sql.Add('EMAIL            DM_NOMES_DESCR COLLATE WIN_PTBR, ');
          Sql.Add('CADASTRANTEID    INTEGER, ');
          Sql.Add('ATRIBUIDO        CHAR(1) COLLATE WIN_PTBR, ');
          Sql.Add('OBS              DM_NOMES_DESCR COLLATE WIN_PTBR, ');
          Sql.Add('DATACAD          DM_DATAS COLLATE WIN_PTBR )');
          ExecSQL;

     end;
     L.Free;
    end;


    texto:= 'A tabela '+nometabela+' foi criada com sucesso!';
    Application.MessageBox(PChar(texto),'Criando nova tabela no banco de dados!',MB_OK + MB_ICONINFORMATION);

end;


procedure LiberarAtribuicao(nomeTabela:string; btnAtribuirProc:TSpeedButton; DBID:TDBEdit; pan_titulo:TPanel);
begin
   if ( clicouNaoAtribuidos ) then
   begin
      With DM.CDSPESQ do
       begin
            Close;
            CommandText:=('SELECT FIRST 1 * FROM '+nomeTabela+' WHERE atribuido = '+ QuotedStr('N')+' and status='+QuotedStr('ATIVO')+' ORDER BY posicao_inicial');
            open;

              if not IsEmpty then
              begin

                IDPrimeiroReg := DM.CDSPESQ.Fields[0].AsInteger;
                
                if (  IDPrimeiroReg = 0 ) then
                begin
                       btnAtribuirProc.Enabled := false;
                       pan_titulo.Font.Color   := clWhite;
                       pan_titulo.Caption      := uppercase(nomeDaFormacao)+' NÃO DISPONIVEL PARA ATRIBUIÇÃO';
                       exit;
                end else
                begin
                     if ( StrToInt(DBID.Text) = IDPrimeiroReg ) then
                     begin
                        btnAtribuirProc.Enabled := true;
                        pan_titulo.Font.Color   := clYellow;
                        pan_titulo.Caption      := uppercase(nomeDaFormacao)+' DISPONIVEL PARA ATRIBUIÇÃO';
                     end else begin
                        btnAtribuirProc.Enabled := false;
                        pan_titulo.Font.Color   := clWhite;
                        pan_titulo.Caption      := uppercase(nomeDaFormacao)+' NÃO DISPONIVEL PARA ATRIBUIÇÃO';
                     end;
                end;
             end;
       end;
 end else
 begin
    btnAtribuirProc.Enabled := false;  //sempre que clicar em atribuidos o botao de atribuição deverá ser desabilitado
 end;

end;

procedure RetirarAtribuicoes(cds:TClientDataSet; nomeTabela:string; botao:TSpeedButton);
begin
    {antes de retirar atribuições o sistema deverá primerio verificar se todos ja estão atribuidos
    assim sendo a fila recomeçará com todos os credenciados prontos para novas atribuições}

        With cds do
        begin
              Close;
              CommandText:=('SELECT * FROM '+nomeTabela+' WHERE atribuido = '+QuotedStr('N')+' and status = '+QuotedStr('ATIVO'));
              open;

              if IsEmpty then
              begin
                  With DM.QRY_GERAL do
                  begin
                        Close;
                        SQL.Clear;
                        SQL.Add('UPDATE '+nomeTabela+' SET atribuido='+QuotedStr('N')+' WHERE status = '+QuotedStr('ATIVO')+' ');
                        ExecSQL;

                  end;
                  botao.Enabled := false;
              end;
        end;
end;

procedure ImprimirVersaoCompleta(nomeTabela,conselho:string);
begin
     //imprimir a versao completa da tela principal
     Application.CreateForm(TQ_RELIMPRIMIRTELA,  Q_RELIMPRIMIRTELA);

     //passando a nova SQL para o componente ignorando a que ele tem setada pois é necessária para configuracao inicial

    _Sql:='SELECT C.*, P.*, U.* FROM '+nometabela+' C, TBL_PROCESSOS P, TBL_USUARIOS U WHERE C.CADASTRANTEID=U.ID_USUARIO '+
          'AND P.conselhoproc=C.conselho AND C.conselho=:pCONSELHO';

     with Q_RELIMPRIMIRTELA.QRYCOMPLETA do
     begin
          close;
          sql.Clear;
          sql.Add(_sql);
          Params.ParamByName('pCONSELHO').AsString      := conselho;
          open;

          if not IsEmpty then
          begin
              Q_RELIMPRIMIRTELA.lblOrgao.Caption := (nomeConselho);

              //imprime todos os processos do credenciado no relatório
              _sqlAuxiliar := 'SELECT p.*, u.nome, t.* FROM tbl_processos p, '+nomeTabela+' t, tbl_usuarios u WHERE '+
              't.conselho=p.conselhoproc AND p.atribuidorid=u.id_usuario and t.conselho=:pConselho';

              with DM.QRY_GERAL do
              begin
                    close;
                    sql.Clear;
                    sql.Add(_sqlAuxiliar);
                    Params.ParamByName('pConselho').AsString := conselho;
                    open;

                    while not eof do
                    begin
                        //imprime enquanto tiver processos do credenciado selecionado
                        Q_RELIMPRIMIRTELA.memProcs.Lines.Add(DM.QRY_GERAL.FieldByname('NUMERO').AsString);
                        Q_RELIMPRIMIRTELA.memComplemento.Lines.Add(DM.QRY_GERAL.FieldByname('COMPLEMENTO').AsString);
                        Q_RELIMPRIMIRTELA.memDataAtribuicao.Lines.Add(DM.QRY_GERAL.FieldByname('DATAATRIB').AsString);
                        Q_RELIMPRIMIRTELA.memNomeAtribuidor.Lines.Add(DM.QRY_GERAL.FieldByname('NOME').AsString);
                        Q_RELIMPRIMIRTELA.lblOrgao.Caption  := (RetornaNomeConselho(IdTipoFormacao));
                        next;
                    end;

                    //mostrando o status do credenciado no relatório
                    if ( Q_RELIMPRIMIRTELA.QRYCOMPLETA.FIELDBYNAME('ATRIBUIDO').AsString = 'S' )then
                       Q_RELIMPRIMIRTELA.lblStatus.Caption := LowerCase(nomeDaFormacao)+' com processo atribuido no momento'
                    else
                       Q_RELIMPRIMIRTELA.lblStatus.Caption := LowerCase(nomeDaFormacao)+' aguardando atribuição de processo no momento';   
                       
                end;
          end;
     end;
     Q_RELIMPRIMIRTELA.lblTITULO.Caption := 'Relatório do '+LowerCase(nomeDaFormacao)+' selecionado';
     Q_RELIMPRIMIRTELA.ReportTitle       := 'Relatório de '+Q_RELIMPRIMIRTELA.QRYCOMPLETA.FieldByname('NOME').AsString;
     Q_RELIMPRIMIRTELA.Preview;
     FreeAndNil(Q_RELIMPRIMIRTELA);

end;


procedure ImprimirVersaoParcial(nomeTabela,conselho:string);
begin
     Application.CreateForm(TQ_RELIMPRIMIRTELAPARCIAL,  Q_RELIMPRIMIRTELAPARCIAL);

     _Sql := 'SELECT u.nome, t.* FROM '+nomeTabela+' t, tbl_usuarios u WHERE '+
              't.cadastranteid=u.id_usuario and t.conselho=:pConselho';

     with Q_RELIMPRIMIRTELAPARCIAL.QRYPARCIAL do
     begin   
          close;
          sql.Clear;
          sql.Add(_sql);
          Params.ParamByName('pConselho').AsString := conselho;
          open;

          if not IsEmpty then
          begin
              //mostrando o status do credenciado no relatório
              if ( Q_RELIMPRIMIRTELAPARCIAL.QRYPARCIAL.FIELDBYNAME('ATRIBUIDO').AsString = 'S' )then
                    Q_RELIMPRIMIRTELAPARCIAL.lblStatus.Caption := LowerCase(nomeDaFormacao)+' com processo atribuido no momento'
              else
                    Q_RELIMPRIMIRTELAPARCIAL.lblStatus.Caption := LowerCase(nomeDaFormacao)+' aguardando atribuição de processo no momento';

              Q_RELIMPRIMIRTELAPARCIAL.lblTITULO.Caption := 'Relatório do '+LowerCase(nomeDaFormacao)+' selecionado';
              Q_RELIMPRIMIRTELAPARCIAL.ReportTitle       := 'Relatório de '+Q_RELIMPRIMIRTELAPARCIAL.QRYPARCIAL.FieldByname('NOME_1').AsString;
              Q_RELIMPRIMIRTELAPARCIAL.lblOrgao.Caption  := (RetornaNomeConselho(IdTipoFormacao));
              Q_RELIMPRIMIRTELAPARCIAL.Preview;
              FreeAndNil(Q_RELIMPRIMIRTELAPARCIAL);

          end;
     end;
end;



procedure CopiarArquivo(ArqOrigem, ArqDestino : String);
  var Origem, Destino : string;
begin
  Origem  := ArqOrigem;
  Destino := ArqDestino;

    if FileExists(PChar(Destino)) then
    begin
      DeleteFile(PChar(Destino));
    end else
    begin
     CopyFile(PChar(Origem),PChar(Destino),false);
    end;

end;

procedure AtualizaQde(cds:TClientDataSet; txtMsg:TStaticText);
begin
    qdeRegs               := ListaQdeRegs(cds);
    txtMsg.Caption        := 'Total de '+RetornaNomeFormacaoPlural(IdTipoFormacao)+' = '+IntToStr( qdeRegs );
    txtMsg.Font.Color     := clBlue;

end;

procedure MostrarProcessosDoCredenciado(conselho:string; gridProc:TDBGrid);
begin
       // Mostra todos os processos do credenciado selecionado
       _Sql := 'SELECT * FROM tbl_processos WHERE conselhoproc = :pConselho';
       with DM.CDS_PROCESSOS do
       begin 
           close;
           CommandText:= _Sql;
           Params.ParamByName('pConselho').AsString := conselho;
           open;

           if not IsEmpty then
           begin

               with gridProc do
                begin

                  DataSource :=  DM.DS_PROCESSOS;
                  Columns.Clear;

                  Columns.Add;
                  Columns[0].FieldName         := 'NUMERO';
                  Columns[0].Width             := 300;
                  Columns[0].Alignment         := taLeftJustify;
                  Columns[0].Title.caption     := 'PROCESSOS';
                  Columns[0].Title.Font.Style  := [fsBold];
                  Columns[0].Title.Alignment   := taLeftJustify;

                  Columns.Add;
                  Columns[1].FieldName         := 'COMPLEMENTO';
                  Columns[1].Width             := 330;
                  Columns[1].Alignment         := taLeftJustify;
                  Columns[1].Title.caption     := 'COMPLEMENTO';
                  Columns[1].Title.Font.Style  := [fsBold];
                  Columns[1].Title.Alignment   := taLeftJustify;

               end;

           end;
      end;
end;

procedure MostrarTodos(cds:TClientDataSet; nomeTabela:string);
begin
    With cds do
    begin
          Close;
          CommandText:=('SELECT * FROM '+nomeTabela+' WHERE status='+QuotedStr('ATIVO')+' ORDER BY nome');
          open;
    end;

end;

Function ListaQdeRegs(cds: TClientDataSet):integer;
begin
     qde    := cds.RecordCount;
     result := qde;
     cds.Last;

end;

procedure AbrirTabelaInativos(cds:TClientDataSet; nomeTabela: string);
begin
    with cds do
    begin 
      close;
      CommandText := 'SELECT * FROM '+nomeTabela+' WHERE status='+QuotedStr('INATIVO')+' ORDER BY nome';
      Open;

    end;

end;

procedure AbrirTabela(cds:TClientDataSet; nomeTabela: string);
begin
    with cds do
    begin 
      close;
      CommandText := 'SELECT * FROM '+nomeTabela+' WHERE status='+QuotedStr('ATIVO')+' ORDER BY nome';
      Open;

    end;

end;

Procedure LogOperacoes(usuario : string; ocorrencia : string);
var
 data : string;
 hora : string;
begin
      data       := dateToStr(now);
      hora       := TimeToStr(time);

      ocorrencia := 'Usuario '+usuario+' registrou : '+ocorrencia+ ' em '+data+' as '+hora+'';
      With DMPESQ.QRY_COD do
      begin         
        Close;
        SQL.Clear;
        SQL.Add('select max(id_operacao) from log_operacoes');
        Open;

        if not IsEmpty then
        begin
           proxNum := DMPESQ.qry_Cod.Fields[0].AsInteger+1;

        end;

      end;

     DM.cds_LogOperacoes.Active := TRUE;
     with DM.cds_LogOperacoes do
     begin
        Append;
        FieldByName('id_Operacao').AsInteger  := proxNum;
        FieldByname('ocorrencia').AsString    := ocorrencia;
        FieldByname('data').AsDateTime        := date;
        ApplyUpdates(0);

     end;

end;

end.


