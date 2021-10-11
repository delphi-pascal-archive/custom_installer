program CustomInstaller;

uses
  Forms,
  fSetup in 'fSetup.pas' {Form1};

{$R *.res}
{$R AppFiles.res}
{$R AppResources.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
