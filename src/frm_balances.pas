unit frm_balances;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, DBGrids, Buttons;

type

  { TfrmBalances }

  TfrmBalances = class(TForm)
    btnExit: TBitBtn;
    DBGrid2: TDBGrid;
    ds_PrevBal: TDatasource;
    ds_CurrBal: TDatasource;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    stextPriorBal: TStaticText;
    stextCurrBal: TStaticText;
    procedure btnExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure GetBalances;
  public
    { public declarations }
  end;

var
  frmBalances: TfrmBalances;

implementation
{$R *.lfm}
 uses
   dmitems
   ;

{ TfrmBalances }


procedure TfrmBalances.GetBalances;
var
  prevBal, currBal: double;
begin
   prevBal:= DM_ITEMS.previousbalance(Now);
   currBal:= DM_ITEMS.BalanceADay(Now);
   stextPriorBal.Caption:= 'TOTAL: ' + FormatFloat('$##########0.00', prevBal);
   stextCurrBal.Caption:= 'TOTAL: ' + FormatFloat('$##########0.00', currBal);
end;

procedure TfrmBalances.btnExitClick(Sender: TObject);
begin
  ModalResult:= mrOK;
end;

procedure TfrmBalances.FormShow(Sender: TObject);
begin
  GetBalances;
end;

end.

