unit frm_daterange;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, EditBtn,
  StdCtrls, Buttons;

type

  { TfrmDateRange }

  TfrmDateRange = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    edDateIni: TDateEdit;
    edDateEnd: TDateEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    function getDateEnd: TDate;
    function getDateIni: TDate;
    { private declarations }
  public
    property DateInit: TDate read getDateIni;
    property DateEnd: TDate read getDateEnd;
  end;

var
  frmDateRange: TfrmDateRange;

implementation

{$R *.lfm}

{ TfrmDateRange }

procedure TfrmDateRange.FormCreate(Sender: TObject);
begin
  edDateIni.Date:= Now;
  edDateEnd.Date:= Now;
end;

function TfrmDateRange.getDateEnd: TDate;
begin
  Result:= edDateEnd.Date;
end;

function TfrmDateRange.getDateIni: TDate;
begin
  Result:= edDateIni.Date;
end;

end.

