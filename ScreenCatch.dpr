program ScreenCatch;

uses
  Forms,
  uScreenCatch in 'uScreenCatch.pas' {ScreenCatchFrm},
  uScreenCatchShow in 'uScreenCatchShow.pas' {CatchScreenShowFrm},
  uAutoScreen in 'uAutoScreen.pas' {AutoScreenFrm},
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := '��Ļץȡ����';
  Application.CreateForm(TScreenCatchFrm, ScreenCatchFrm);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
