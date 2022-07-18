object F_SENHAS: TF_SENHAS
  Left = 628
  Top = 232
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Descriptografar senhas'
  ClientHeight = 154
  ClientWidth = 349
  Color = clMoneyGreen
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 27
    Top = 18
    Width = 198
    Height = 20
    Alignment = taCenter
    Caption = 'Senha Criptografada'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 27
    Top = 97
    Width = 197
    Height = 20
    Alignment = taCenter
    Caption = 'Senha Descriptografada'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtSenha: TEdit
    Left = 28
    Top = 40
    Width = 194
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnChange = edtSenhaChange
  end
  object lblSENHA: TStaticText
    Left = 28
    Top = 120
    Width = 194
    Height = 24
    AutoSize = False
    BorderStyle = sbsSingle
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 1
  end
  object btnExecutar: TButton
    Left = 243
    Top = 29
    Width = 94
    Height = 35
    Caption = 'Executar'
    Enabled = False
    TabOrder = 2
    OnClick = btnExecutarClick
  end
  object btnLimpar: TButton
    Left = 245
    Top = 70
    Width = 94
    Height = 35
    Caption = 'Limpar'
    Enabled = False
    TabOrder = 3
    OnClick = btnLimparClick
  end
  object btnSair: TButton
    Left = 245
    Top = 111
    Width = 94
    Height = 35
    Caption = 'Sair'
    TabOrder = 4
    OnClick = btnSairClick
  end
end
