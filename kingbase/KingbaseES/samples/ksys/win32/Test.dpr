program Test;

uses
  Forms,
  main in 'main.pas' {TestDLL},
  ksys in 'ksys.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTestDLL, TestDLL);
  Application.Run;
end.
