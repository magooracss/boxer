program boxer;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, rxnew, frm_main, dmgeneral, zcomponent, classBook, classconfig,
  dmitems, frm_balances, frm_daterange;

{$R *.res}

begin
  Application.Title:='Boxer';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TDM_GENERAL, DM_GENERAL);
  Application.CreateForm(TDM_ITEMS, DM_ITEMS);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDateRange, frmDateRange);
  Application.Run;
end.

