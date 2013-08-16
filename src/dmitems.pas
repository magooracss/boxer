unit dmitems;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, rxmemds, ZDataset, ZSqlUpdate
  ,dmgeneral, db
  ;

const
  NEW_ID = -1;
type

  { TDM_ITEMS }

  TDM_ITEMS = class(TDataModule)
    qItemClose: TZQuery;
    qItemEdit: TZQuery;
    qItemDel: TZQuery;
    qItemsDate: TZQuery;
    tbBalance: TRxMemoryData;
    tbBalanceBalance: TFloatField;
    tbBalanceIncome: TFloatField;
    tbBalanceOutcome: TFloatField;
    tbBalancePayment: TStringField;
    tbBalancerefPayment: TLongintField;
    tbItems: TRxMemoryData;
    qPreviousBalance: TZQuery;
    tbItemsidItem: TLongintField;
    tbItemsitemBalance: TFloatField;
    tbItemsitemClosed: TLongintField;
    tbItemsitemDate: TDateTimeField;
    tbItemsItemDescription: TStringField;
    tbItemsitemIn: TFloatField;
    tbItemsitemOut: TFloatField;
    tbItemsitemVisible: TLongintField;
    tbItemspayment: TStringField;
    tbItemsrefPayment: TLongintField;
    tbItemsshortRef: TStringField;
    qItemInsert: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure tbBalanceAfterInsert(DataSet: TDataSet);
    procedure tbItemsAfterInsert(DataSet: TDataSet);
  private
    { private declarations }
  public
    function previousbalance (aDate: TDateTime): double;
    function GetBalance(aDate: TDateTime): double;
    procedure GetItems (aDate: TDateTime);
    procedure SaveItem(idItem: integer
                       ;itemDate: TDate
                       ;Description: string
                       ;ItemIn, ItemOut: double
                       ;refPayment: integer
                       ;Closed, visible: smallint);
    function CurrItemOpened: boolean;
    procedure GetCurrItem (var currItem: integer
                           ; var itemDate: TDate
                           ; var Description: string
                           ; var ItemIn, ItemOut: Double
                           ; var refPayment, closed, bVisible: integer
                           );
    procedure DelCurrItem;

    procedure ItemClose (aDate: TDate);

  end;

var
  DM_ITEMS: TDM_ITEMS;

implementation
{$R *.lfm}
uses
  dateutils
  ;

{ TDM_ITEMS }

procedure TDM_ITEMS.tbBalanceAfterInsert(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('refPayment').asInteger:= 0;
    FieldByName('Payment').asString:= EmptyStr;
    FieldByName('Income').asFloat:= 0;
    FieldByName('Outcome').asFloat:= 0;
    FieldByName('Balance').asFloat:= 0;
  end;
end;

procedure TDM_ITEMS.DataModuleCreate(Sender: TObject);
begin

end;

procedure TDM_ITEMS.tbItemsAfterInsert(DataSet: TDataSet);
begin
  With DataSet do
  Begin
    FieldByName('itemDate').AsDateTime:= DateOf(Now);
    FieldByName('itemIn').AsFloat:= 0;
    FieldByName('itemOut').asFloat:= 0;
    FieldByName('ItemClosed').asInteger:= 0;
    FieldByName('ItemVisible').asInteger:= 1;
    FieldByName('ItemBalance').asFloat:= 0;
    FieldByName('refPayment').asInteger:= 0;
    FieldByName('Payment').asString:= EmptyStr;
    FieldByName('shortref').asString:= EmptyStr;
  end;
end;

function TDM_ITEMS.previousbalance(aDate: TDateTime): double;
var
  total: double;
begin
  total:= 0;
  tbBalance.Close;
  with qPreviousBalance do
  begin
    if active then close;
    ParamByName('itemDate').AsDate:= aDate;
    Open;
    tbBalance.Open;
    tbBalance.LoadFromDataSet(qPreviousBalance,0, lmAppend);
  end;
  with tbBalance do
  begin
    if RecordCount > 0 then
    begin
      First;
      While (Not EOF) do
      begin
        total:= total + tbBalanceBalance.AsFloat;
        Next;
      end;
    end;
  end;
  Result:= total;
end;

function TDM_ITEMS.GetBalance(aDate: TDateTime): double;
var
  prevBal, total: Double;
begin

  prevBal:= previousbalance(aDate);

  if tbItems.RecordCount < 1 then
    GetItems(aDate);

  with tbItems do
  begin
    First;
    total:= 0;
    DisableControls;
    While Not EOF do
    begin
      total:= total + tbItemsitemBalance.AsFloat;
      Next;
    end;
    EnableControls;
    Result:= total + prevBal;
  end;
end;

procedure TDM_ITEMS.GetItems(aDate: TDateTime);
begin
  tbItems.Close;
  with qItemsDate do
  begin
    if active then close;
    ParamByName('itemDate').asDate:= aDate;
    Open;
    tbItems.Open;
    tbItems.LoadFromDataSet(qItemsDate, 0, lmAppend);
    Close;
  end;
end;

procedure TDM_ITEMS.SaveItem(idItem: integer; itemDate: TDate;
  Description: string; ItemIn, ItemOut: double; refPayment: integer; Closed,
  visible: smallint);
var
  aQuery: TZQuery;
begin
  if idItem = NEW_ID then
    aQuery := qItemInsert
  else
  begin
    aQuery := qItemEdit;
    aQuery.ParamByName('itemClosed').asInteger:= Closed;
    aQuery.ParamByName('itemVisible').asInteger:= visible;
    aQuery.ParamByName('idItem').asInteger:= idItem;
  end;

  with aQuery do
  begin
    ParamByName('itemDate').AsDate:= itemDate;
    ParamByName('itemDescription').AsString:= Description;
    ParamByName('ItemIn').asFloat:= ItemIn;
    ParamByName('ItemOut').asFloat:= ItemOut;
    ParamByName('refPayment').asInteger:= refPayment;
    ExecSQL;
  end;

end;

function TDM_ITEMS.CurrItemOpened: boolean;
begin
  with tbItems do
  begin
    if (RecordCount > 0)
        and (tbItemsitemClosed.AsInteger = 0) then
      Result:= true
    else
      Result:= false;
  end;
end;

procedure TDM_ITEMS.GetCurrItem(var currItem: integer; var itemDate: TDate;
  var Description: string; var ItemIn, ItemOut: Double; var refPayment, closed,
  bVisible: integer);
begin
  with tbItems do
  begin
    if RecordCount > 0 then
    begin
      currItem:= tbItemsidItem.asInteger;
      itemDate:= tbItemsitemDate.AsDateTime;
      Description:= tbItemsItemDescription.asString;
      ItemIn:= tbItemsitemIn.asFloat;
      ItemOut:= tbItemsitemOut.asFloat;
      refPayment:= tbItemsrefPayment.asInteger;
      closed:= tbItemsitemClosed.asInteger;
      bVisible:= tbItemsitemVisible.AsInteger;
    end;
  end;
end;

procedure TDM_ITEMS.DelCurrItem;
begin
  if tbItems.RecordCount > 0 then
    with qItemDel do
    begin
      ParamByName('idItem').asInteger:= tbItemsidITem.asInteger;
      ExecSQL;
    end;
end;

procedure TDM_ITEMS.ItemClose(aDate: TDate);
begin
  with qItemClose do
  begin
    ParamByName('itemDate').AsDate:= aDate;
    ExecSQL;
  end;
end;

end.

