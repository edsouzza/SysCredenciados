unit U_SPLASH;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TF_SPLASH = class(TForm)
    Image1: TImage;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_SPLASH: TF_SPLASH;

implementation

{$R *.dfm}

end.
