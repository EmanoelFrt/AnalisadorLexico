unit ufanalisadorlexico;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.DBCtrls, StrUtils;
type
  TFAnalisadorLexico = class(TForm)
    stg_analisador: TStringGrid;
    edt_busca: TEdit;
    Label3: TLabel;
    btn_limpar: TButton;
    Label2: TLabel;
    cds_entrada: TClientDataSet;
    dbg_entrada: TDBGrid;
    src_entrada: TDataSource;
    cds_entradaEntrada: TStringField;
    dbn_entrada: TDBNavigator;
    Shape1: TShape;
    Shape2: TShape;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_limparClick(Sender: TObject);
    procedure IncluirDados(palavra:string);
    procedure FormActivate(Sender: TObject);
    procedure edt_buscaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edt_buscaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cds_entradaBeforePost(DataSet: TDataSet);
    procedure cds_entradaBeforeDelete(DataSet: TDataSet);
    procedure cds_entradaAfterDelete(DataSet: TDataSet);
    procedure CarregaAnalisador;
    procedure InsereDadosAnalisador;
    procedure cds_entradaAfterPost(DataSet: TDataSet);
    procedure stg_analisadorDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    slEntrada: TStringList;
    q: Array of Char;
    sTemp: string;
    Teste: boolean;
  public
    { Public declarations }
  end;
var
  FAnalisadorLexico: TFAnalisadorLexico;
implementation
{$R *.dfm}
procedure TFAnalisadorLexico.btn_limparClick(Sender: TObject);
begin
  if MessageDlg('Deseja excluir todas as Entradas?', mtInformation, mbYesNo, 0) = mrYes then
  begin
    slEntrada.Clear;
    edt_busca.Text := '';
    cds_entrada.EmptyDataSet;
    InsereDadosAnalisador;
  end;
end;

procedure TFAnalisadorLexico.InsereDadosAnalisador;
var
  cds_clone : TClientDataSet;
begin
  slEntrada.Clear;
  CarregaAnalisador;
  cds_clone := TClientDataSet.Create(self);
  cds_clone.CloneCursor(cds_entrada, true, true);
  try
    cds_clone.First;
    while not cds_clone.Eof do
    begin
      slEntrada.Add(cds_clone.FieldByName('Entrada').AsString);
      IncluirDados(cds_clone.FieldByName('Entrada').AsString);
      cds_clone.Next;
    end;
  finally
    cds_clone.Free;
  end;
end;

procedure TFAnalisadorLexico.stg_analisadorDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  stg_analisador.Canvas.Brush.Color := edt_busca.Color;
end;

procedure TFAnalisadorLexico.cds_entradaAfterDelete(DataSet: TDataSet);
begin
  InsereDadosAnalisador;
end;

procedure TFAnalisadorLexico.cds_entradaAfterPost(DataSet: TDataSet);
begin
  InsereDadosAnalisador;
end;

procedure TFAnalisadorLexico.cds_entradaBeforeDelete(DataSet: TDataSet);
var
  Index : Integer;
begin
  if slEntrada.Find(VarToStrDef(cds_entradaEntrada.OldValue,''),Index) then
    slEntrada.Delete(Index);
end;

procedure TFAnalisadorLexico.cds_entradaBeforePost(DataSet: TDataSet);
var
  cds_clone : TClientDataSet;
  palavra : string;
  I, Index : Integer;
begin
  if cds_entradaEntrada.AsString = '' then
  begin
    MessageDlg('Entrada não informada !', mtInformation, mbOKCancel, 0);
    Abort;
  end;
  cds_clone := TClientDataSet.Create(self);
  cds_clone.CloneCursor(cds_entrada, true, true);
  try
    cds_clone.First;
    while not cds_clone.Eof do
    begin
      if UpperCase(cds_clone.FieldByName('Entrada').AsString) = UpperCase(cds_entradaEntrada.AsString) then
      begin
        MessageDlg('Entrada "' + cds_entradaEntrada.AsString + '" já incluída !', mtInformation, mbOKCancel, 0);
        Abort;
      end;
      cds_clone.Next;
    end;
  finally
    cds_clone.Free;
  end;
  palavra := cds_entradaEntrada.AsString;

  for I := 0 to Length(palavra) do
  begin
    if AnsiIndexStr(LowerCase(Copy(palavra,I,1)),['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','x','w','y','z']) = -1 then
    begin
      MessageDlg('Entrada Inválida !', mtInformation, mbOKCancel, 0);
      Abort;
    end;
  end;
end;

procedure TFAnalisadorLexico.edt_buscaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // espaço
  If Ord(Key) = 32 Then
  begin
    if trim(edt_busca.Text) <> EmptyStr then
    begin
      if ((sTemp = '*') and (Teste = True)) and (slEntrada.IndexOf(LowerCase(edt_busca.Text))>=0) then
      begin
        MessageDlg('"' + trim(edt_busca.Text) + '"  ' + 'foi encontrada!', mtInformation, mbOKCancel, 0);
        edt_busca.Clear;
        // Acompanha linha com a seleção
        stg_analisador.Row := 0;
      end
      else
      begin
        MessageDlg('"' + trim(edt_busca.Text) + '"  ' + 'não foi encontrada!', mtError, mbOKCancel, 0);
        edt_busca.Clear;
        // Acompanha linha com a seleção
        stg_analisador.Row := 0;
      end;
    end
    else
      MessageDlg('O campo está em Branco!', mtWarning, mbOKCancel, 0);
  end;
end;

procedure TFAnalisadorLexico.edt_buscaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  cont, posi, I, J: integer;
begin
  if edt_busca.Text = '' then
  begin
    edt_busca.Color := clWindow;
    stg_analisador.Canvas.Brush.Color := clWindow;
    stg_analisador.Row := 0;
  end
  else
  begin
    posi  := 1;
    Teste := True;
    cont  := Length(edt_busca.Text);
    for I := 1 to cont do
    begin
      for j := 1 to 27 do
      begin
        if (stg_analisador.Cells[j, 0] = LowerCase(edt_busca.Text[I])) and (Teste = True) then
        begin
          stg_analisador.Options := stg_analisador.Options - [goRowSelect];
          if (stg_analisador.Cells[j, posi] <> '') and (Pos(LowerCase(edt_busca.Text),LowerCase(slEntrada.Text))>0) then
          begin
            edt_busca.Color := clLime;
            sTemp := copy(stg_analisador.Cells[0, posi],
              Length(stg_analisador.Cells[0, posi]), 1);
            posi  := StrToInt(StringReplace(stg_analisador.Cells[j, posi],'q','',[rfReplaceAll])) + 1;
          end
          else
          begin
            edt_busca.Color := clRed;
            Teste := False;
          end;
          stg_analisador.Options := stg_analisador.Options + [goRowSelect];
          stg_analisador.Row := posi-1;
        end;
      end;
    end;
  end;
end;

procedure TFAnalisadorLexico.CarregaAnalisador;
var
  I, j, Num_Linhas, Num_Colunas: integer;
  cds_clone : TClientDataSet;
begin
  Num_Linhas := 0;
  edt_busca.Color := clWindow;
  stg_analisador.Canvas.Brush.Color := edt_busca.Color;
  cds_clone := TClientDataSet.Create(self);
  cds_clone.CloneCursor(cds_entrada, true, true);
  try
    cds_clone.First;
    while not cds_clone.Eof do
    begin
      if Length(cds_clone.FieldByName('Entrada').AsString) > Num_Linhas then
        Num_Linhas := Length(cds_clone.FieldByName('Entrada').AsString) + 1;
      cds_clone.Next;
    end;
  finally
    cds_clone.Free;
  end;

  Num_Colunas := 26;
  stg_analisador.RowCount := Num_Linhas;
  stg_analisador.ColCount := Num_Colunas + 1;
  // insere o cabeçalho nas colunas {a,b,c,...,z}
  for I := 1 to (Num_Colunas) do
  begin
    for j := 0 to Num_Linhas + 1 do
      stg_analisador.Cells[I, j] := '';
    stg_analisador.Cells[I, 0] := Chr(Ord('a') - 1 + I);
  end;
  // insere o numero das linhas
  for I := 1 to Num_Linhas do
    stg_analisador.Cells[0, I] := IntToStr(I);
end;

procedure TFAnalisadorLexico.FormActivate(Sender: TObject);
begin
  CarregaAnalisador;
end;

procedure TFAnalisadorLexico.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  slEntrada.Free;
  Action := caFree;
end;

procedure TFAnalisadorLexico.FormShow(Sender: TObject);
begin
  slEntrada := TStringList.Create;
end;

procedure TFAnalisadorLexico.IncluirDados(palavra:string);
var Linha, Coluna, iTam: integer;
    sTemp: string;
begin
  iTam := Length(palavra);
  for Linha := 1 to iTam do
  begin
    for Coluna := 1 to stg_analisador.ColCount do
    begin
      // Encontra Coluna do caractere
      if (LowerCase(stg_analisador.Cells[Coluna, 0]) = LowerCase(palavra[Linha])) then
      begin
        stg_analisador.Cells[Coluna, Linha] := 'q' + IntToStr(Linha);
        if (Linha = iTam) then
        begin
          sTemp := copy(stg_analisador.Cells[0, Linha],
            Length(stg_analisador.Cells[0, Linha]), 1);
          if stemp <> '*' then
            stg_analisador.Cells[0, Linha] := stg_analisador.Cells[0, Linha] + '*';
        end;
      end;
    end;
  end;
end;
end.
