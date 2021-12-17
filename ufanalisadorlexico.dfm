object FAnalisadorLexico: TFAnalisadorLexico
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Analisador L'#233'xico'
  ClientHeight = 681
  ClientWidth = 1161
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 110
  TextHeight = 16
  object Label3: TLabel
    Left = 8
    Top = 3
    Width = 50
    Height = 16
    Caption = 'Entradas'
  end
  object Label2: TLabel
    Left = 274
    Top = 3
    Width = 49
    Height = 16
    Caption = 'Consulta'
  end
  object Shape1: TShape
    Left = 8
    Top = 22
    Width = 260
    Height = 2
  end
  object Shape2: TShape
    Left = 274
    Top = 22
    Width = 879
    Height = 2
  end
  object stg_analisador: TStringGrid
    Left = 274
    Top = 60
    Width = 879
    Height = 613
    ColCount = 27
    DefaultColWidth = 30
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 0
    OnDrawCell = stg_analisadorDrawCell
  end
  object edt_busca: TEdit
    Left = 274
    Top = 28
    Width = 879
    Height = 24
    TabOrder = 1
    OnKeyDown = edt_buscaKeyDown
    OnKeyUp = edt_buscaKeyUp
  end
  object btn_limpar: TButton
    Left = 56
    Top = 639
    Width = 161
    Height = 34
    Caption = 'Limpar Todas Entradas'
    TabOrder = 2
    OnClick = btn_limparClick
  end
  object dbg_entrada: TDBGrid
    Left = 8
    Top = 60
    Width = 260
    Height = 573
    DataSource = src_entrada
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Entrada'
        Width = 223
        Visible = True
      end>
  end
  object dbn_entrada: TDBNavigator
    Left = 8
    Top = 28
    Width = 260
    Height = 26
    DataSource = src_entrada
    VisibleButtons = [nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
    ConfirmDelete = False
    TabOrder = 4
  end
  object cds_entrada: TClientDataSet
    PersistDataPacket.Data = {
      360000009619E0BD010000001800000001000000000003000000360007456E74
      72616461020049000000010005574944544802000200D0070000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Entrada'
        DataType = ftString
        Size = 2000
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    BeforePost = cds_entradaBeforePost
    AfterPost = cds_entradaAfterPost
    BeforeDelete = cds_entradaBeforeDelete
    AfterDelete = cds_entradaAfterDelete
    Left = 736
    Top = 48
    object cds_entradaEntrada: TStringField
      FieldName = 'Entrada'
      Size = 2000
    end
  end
  object src_entrada: TDataSource
    DataSet = cds_entrada
    Left = 856
    Top = 56
  end
end
