unit dmgeneral;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, ZDataset, Controls
  ,StdCtrls;

type

  { TDM_GENERAL }

  TDM_GENERAL = class(TDataModule)
    ImageListActs: TImageList;
    Cnx_General: TZConnection;
    gutPayments: TZQuery;
  private
    { private declarations }
  public
    procedure OpenDB (filePath: string);
    procedure FillComboBox (var aComboBox: TComboBox; fieldVisible, fieldIndex: string; var DataQuery: TZQuery);
    function GetCbId (var aComboBox: TComboBox): integer;
    function GetCbKey (var aComboBox: TComboBox; idx: integer): integer;
  end;

var
  DM_GENERAL: TDM_GENERAL;

implementation

{$R *.lfm}

{ TDM_GENERAL }

procedure TDM_GENERAL.OpenDB(filePath: string);
begin
  with Cnx_General do
  begin
    if Connected then
       Disconnect;
    Database:= filePath;
    Connect;
  end;
end;

procedure TDM_GENERAL.FillComboBox(var aComboBox: TComboBox; fieldVisible,
  fieldIndex: string; var DataQuery: TZQuery);
begin
  aComboBox.Items.Clear;
  with DataQuery do
  begin
    if Active then close;
    Open;
    While Not EOF do
    begin
      aComboBox.Items.AddObject(FieldByName(fieldVisible).asString, TObject(FieldByName (fieldIndex).asInteger));
      Next;
    end;
  end;
  if aComboBox.Items.Count > 0 then
   aComboBox.ItemIndex:= 0;
end;

function TDM_GENERAL.GetCbId(var aComboBox: TComboBox): integer;
begin
 if (aComboBox.Items.Count > 0) and (aComboBox.ItemIndex >= 0) then
  Result:= integer(aComboBox.Items.Objects[aComboBox.ItemIndex])
 else
   Result:= 0;
end;

function TDM_GENERAL.GetCbKey(var aComboBox: TComboBox; idx: integer): integer;
var
 i, retVal: integer;
begin
 i:= aComboBox.Items.Count - 1;
 retVal:= -1;
 while (i >= 0) and (retVal = -1) do
 begin
   if (integer(aComboBox.Items.Objects[i]) = idx) then
      retVal:= i;
   DEC (i);
 end;
 Result:= retVal;
end;

end.

