program AnalisadorLexico;

uses
  Vcl.Forms,
  ufanalisadorlexico in 'ufanalisadorlexico.pas' {FAnalisadorLexico};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFAnalisadorLexico, FAnalisadorLexico);
  Application.Run;
end.
