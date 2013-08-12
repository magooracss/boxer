program boxer;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, frm_main, dmgeneral, zcomponent
  { you can add units after this };

{$R *.res}

begin
  Application.Title:='Boxer';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TDM_GENERAL, DM_GENERAL);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

