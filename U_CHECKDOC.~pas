unit U_CHECKDOC;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs ; //, DesignEditors;

type
  TMode = (moCPF, moCGC);

  TCheckDoc = class(TComponent)
  private
    FAbout  : string;
    FInput  : string;
    FResult : Boolean;
    FMode   : TMode;
    procedure SetInput(Value: string);
    procedure SetMode(Value: TMode);
    procedure SetCPF(Value: string);
    procedure SetCGC(Value: string);
    procedure SetResult(Value: boolean);
    procedure ShowAbout;
  protected
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published
    property About    : string  read FAbout     write FAbout      stored  False;
    property Input    : string  read FInput     write SetInput;
    property Mode     : TMode   read FMode      write SetMode;
    property Result   : boolean read FResult    write SetResult;
  end;

procedure Register;

implementation

{#######################################################################}



procedure TCheckDoc.ShowAbout;
var
  msg: string;
const
  carriage_return = chr(13);
begin
  msg := 'CheckDoc  v1.0';
  AppendStr(msg, carriage_return);
  AppendStr(msg, 'A freeware component');
  AppendStr(msg, carriage_return);
  AppendStr(msg, carriage_return);
  AppendStr(msg, 'by Roger Constantin Demetrescu');
  AppendStr(msg, carriage_return);
  AppendStr(msg, carriage_return);
  AppendStr(msg, 'rogercd@iconet.com.br');
  ShowMessage(msg);
end;

{#######################################################################}

constructor TCheckDoc.Create( Aowner: Tcomponent);
begin
  inherited Create( Aowner );
  FInput  := '';
  FResult := False;
  FMode   := moCPF;
end;

destructor TCheckDoc.Destroy;
begin
  inherited Destroy;
end;

procedure TCheckDoc.SetMode(Value: TMode);
begin
  if FMode <> Value then
  begin
    FMode := Value;
    SetInput(FInput);
  end;
end;

procedure TCheckDoc.SetInput(Value: string);
begin
  FInput := Value;
  case FMode of
    moCPF: SetCPF(Value);
    moCGC: SetCGC(Value);
  end;
end;

procedure TCheckDoc.SetCPF(Value: string);
var
  localCPF       : string;
  localResult    : boolean;
  digit1, digit2 : integer;
  ii,soma        : integer;
begin
  localCPF := '';
  localResult := False;

  {analisa CPF no formato 999.999.999-00}
  if Length(FInput) = 14 then
    if (Copy(FInput,4,1)+Copy(FInput,8,1)+Copy(FInput,12,1) = '..-') then
      begin
      localCPF := Copy(FInput,1,3) + Copy(FInput,5,3) + Copy(FInput,9,3) +
                   Copy(FInput,13,2);
      localResult := True;
      end;

  {analisa CPF no formato 99999999900}
  if Length(FInput) = 11 then
    begin
    localCPF := FInput;
    localResult := True;
    end;

  {comeca a verificacao do digito}
  if localResult then
    try
      {1° digito}
      soma := 0;
      for ii := 1 to 9 do Inc(soma, StrToInt(Copy(localCPF, 10-ii, 1))*(ii+1));
      digit1 := 11 - (soma mod 11);
      if digit1 > 9 then digit1 := 0;

      {2° digito}
      soma := 0;
      for ii := 1 to 10 do Inc(soma, StrToInt(Copy(localCPF, 11-ii, 1))*(ii+1));
      digit2 := 11 - (soma mod 11);
      if digit2 > 9 then digit2 := 0;

      {Checa os dois dígitos}
      if (Digit1 = StrToInt(Copy(localCPF, 10, 1))) and
         (Digit2 = StrToInt(Copy(localCPF, 11, 1))) then
         localResult := True
      else
         localResult := False;
    except
      localResult := False;
    end;

  FResult := localResult;
end;

procedure TCheckDoc.SetCGC(Value: string);
var
  localCGC       : string;
  localResult    : boolean;
  digit1, digit2 : integer;
  ii,soma        : integer;
begin
  localCGC := '';
  localResult := False;

  {analisa CGC no formato 99.999.999/9999-00}
  if Length(FInput) = 18 then
    if (Copy(FInput,3,1)+Copy(FInput,7,1)+Copy(FInput,11,1)+Copy(FInput,16,1) = '../-') then
      begin
      localCGC := Copy(FInput,1,2) + Copy(FInput,4,3) + Copy(FInput,8,3) +
                  Copy(FInput,12,4) + Copy(FInput,17,2);
      localResult := True;
      end;

  {analisa CGC no formato 99999999999900}
  if Length(FInput) = 14 then
    begin
    localCGC := FInput;
    localResult := True;
    end;

  {comeca a verificacao do digito}
  if localResult then
    try
      {1° digito}
      soma := 0;
      for ii := 1 to 12 do
      begin
        if ii < 5 then
          Inc(soma, StrToInt(Copy(localCGC, ii, 1))*(6-ii))
        else
          Inc(soma, StrToInt(Copy(localCGC, ii, 1))*(14-ii))
      end;
      digit1 := 11 - (soma mod 11);
      if digit1 > 9 then digit1 := 0;

      {2° digito}
      soma := 0;
      for ii := 1 to 13 do
      begin
        if ii < 6 then
          Inc(soma, StrToInt(Copy(localCGC, ii, 1))*(7-ii))
        else
          Inc(soma, StrToInt(Copy(localCGC, ii, 1))*(15-ii))
      end;
      digit2 := 11 - (soma mod 11);
      if digit2 > 9 then digit2 := 0;

      {Checa os dois dígitos}
      if (Digit1 = StrToInt(Copy(localCGC, 13, 1))) and
         (Digit2 = StrToInt(Copy(localCGC, 14, 1))) then
         localResult := True
      else
         localResult := False;
    except
      localResult := False;
    end;

  FResult := localResult;
end;

procedure TCheckDoc.SetResult(Value: boolean);
begin
  {do nothing  //  read only}
end;

procedure Register;
begin
  RegisterComponents('My Components', [TCheckDoc]);
//  RegisterPropertyEditor(TypeInfo(String), TCheckDoc, 'About',	TAboutProperty);
end;

end.
