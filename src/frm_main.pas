unit frm_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Menus, ActnList, DBGrids, StdCtrls, Buttons
  ,dmgeneral
  ,classBook, db
  ;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    MenuItem15: TMenuItem;
    repItems: TAction;
    MenuItem14: TMenuItem;
    repBalances: TAction;
    MenuItem13: TMenuItem;
    prgReportEdit: TAction;
    itemClose: TAction;
    ItemDel: TAction;
    itemEdit: TAction;
    itemSave: TAction;
    btnSave: TBitBtn;
    cbPayment: TComboBox;
    itemNew: TAction;
    bookOpen: TAction;
    bookNew: TAction;
    ds_Items: TDatasource;
    edPreviousBalance: TLabeledEdit;
    edBalance: TLabeledEdit;
    Label1: TLabel;
    edDescription: TLabeledEdit;
    edItemIn: TLabeledEdit;
    edItemOut: TLabeledEdit;
    MenuBooks: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    od: TOpenDialog;
    prgExit: TAction;
    ActionList: TActionList;
    DBGrid1: TDBGrid;
    MainMenu1: TMainMenu;
    MenuReports: TMenuItem;
    MenuProgram: TMenuItem;
    MenuItems: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PanelDataInput: TPanel;
    sd: TSaveDialog;
    stInfo: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure bookNewExecute(Sender: TObject);
    procedure bookOpenExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure itemCloseExecute(Sender: TObject);
    procedure ItemDelExecute(Sender: TObject);
    procedure itemEditExecute(Sender: TObject);
    procedure itemNewExecute(Sender: TObject);
    procedure itemSaveExecute(Sender: TObject);
    procedure prgExitExecute(Sender: TObject);
    procedure prgReportEditExecute(Sender: TObject);
    procedure repBalancesExecute(Sender: TObject);
    procedure repItemsExecute(Sender: TObject);
  private
    aBook: TBook;
    currItem: integer; //Fix this!!!
    procedure openFileBook(filepath: string);
    procedure ShowBalance (aDate: TDate);
    procedure InitItemScreen;
    procedure SaveItem;
  public
    { public declarations }
  end;

var
  frmMain: TfrmMain;

implementation
{$R *.lfm}
uses
  classconfig
  ,dmitems
  ,frm_balances
  ,frm_daterange
  ;

const
  FRM_FLOAT='$ ########0.00';

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
var
  fpath: string;
begin
  aBook:= TBook.Create;

  fpath:= LeerDato(SECT_BOOK, BOOK_OPEN);
  if FileExists(fpath) then
    openFileBook(fpath)
  else
    if (MessageDlg ('AVISO', 'No encuentro un libro en uso. Desea crear uno nuevo?', mtConfirmation, [mbYes, mbNo],0 ) = mrYes) then
    begin
      bookNew.Execute;
    end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  aBook.Free;
end;

procedure TfrmMain.itemCloseExecute(Sender: TObject);
begin
  if (MessageDlg ('AVISO', '¿Cierro los movimientos de hoy?', mtConfirmation, [mbYes, mbNo],0 ) = mrYes) then
  begin
    DM_ITEMS.ItemClose(Now);
    DM_ITEMS.GetItems(Now);
  end;
end;

procedure TfrmMain.ItemDelExecute(Sender: TObject);
begin
  if DM_ITEMS.CurrItemOpened then
  begin
   if (MessageDlg ('AVISO', '¿Elimino el valor seleccionado?', mtConfirmation, [mbYes, mbNo],0 ) = mrYes) then
   begin
    DM_ITEMS.DelCurrItem;
    DM_ITEMS.GetItems(Now);
    ShowBalance(Now);
   end;
  end
  else
    ShowMessage('No se puede eliminar un movimiento cerrado');
end;

procedure TfrmMain.itemEditExecute(Sender: TObject);
var
  itemdate: TDate;
  itemIn, itemOut: double;
  refPayment, closed, bVisible: integer;
  descript: string;
begin
 if DM_ITEMS.CurrItemOpened then
 begin
  { TODO -oMagoo : Creating the item class instead of this mess }
  DM_ITEMS.GetCurrItem (currItem
                      ,itemDate
                      ,descript
                      ,ItemIn
                      ,ItemOut
                      ,refPayment
                      ,closed
                      ,bVisible);

   edItemIn.Text:= FloatToStr(itemIn);
   edItemOut.Text:= FloatToStr(itemOut);
   cbPayment.ItemIndex:= refPayment;
   edDescription.Text:= descript
 end
 else
  ShowMessage('No se pueden modificar los datos cerrados');
end;

procedure TfrmMain.itemNewExecute(Sender: TObject);
begin
  InitItemScreen;
end;

procedure TfrmMain.itemSaveExecute(Sender: TObject);
begin
  if TRIM(edDescription.Text) <> EmptyStr then
    SaveItem
  else
  begin
    ShowMessage('Falta ingresar la descripción');
    edDescription.SetFocus;
  end;

end;

procedure TfrmMain.prgExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.prgReportEditExecute(Sender: TObject);
begin
  DM_GENERAL.EditReport;
end;

procedure TfrmMain.repBalancesExecute(Sender: TObject);
var
  scr_Bal: TfrmBalances;
begin
 scr_Bal:= TfrmBalances.Create(self);
 try
   scr_Bal.ShowModal;
 finally
   scr_Bal.Free;
 end;
end;

procedure TfrmMain.repItemsExecute(Sender: TObject);
var
  scr_dateRange: TfrmDateRange;
begin
  scr_dateRange:= TfrmDateRange.Create(self);
  try
    if scr_dateRange.ShowModal = mrOK then
    begin
      DM_ITEMS.RepItemsRange(scr_dateRange.DateInit
                            ,scr_dateRange.DateEnd);
    end;
  finally
    scr_dateRange.Free;
  end;
end;

procedure TfrmMain.openFileBook(filepath: string);
begin
  aBook.Open(od.FileName);
  stInfo.Panels[0].Text:= filepath;
  EscribirDato(SECT_BOOK,BOOK_OPEN, filepath);
  DM_Items.getItems(Now);
  ShowBalance (Now);
  DM_GENERAL.FillComboBox(cbPayment, 'payment','idPayment',DM_GENERAL.gutPayments);
end;

procedure TfrmMain.ShowBalance(aDate: TDate);
begin
  edPreviousBalance.Text:= FormatFloat(FRM_FLOAT, DM_ITEMS.previousbalance(aDate));
  edBalance.Text:= FormatFloat(FRM_FLOAT, DM_ITEMS.GetBalance(aDate));
end;

procedure TfrmMain.InitItemScreen;
begin
  edDescription.Clear;
  edItemOut.Text:='0';
  edItemIn.Text:='0';
  edDescription.SetFocus;
  currItem:= NEW_ID;
end;

procedure TfrmMain.SaveItem;
const
  VAL_ERROR = -9999;
begin

  if TRIM(edItemIn.Text) = EmptyStr then
    edItemIn.Text:= '0' ;
  if TRIM(edItemOut.Text) = EmptyStr then
    edItemOut.Text:= '0' ;

  if ((StrToFloatDef(edItemIn.Text, VAL_ERROR) <> VAL_ERROR)
     and
     (StrToFloatDef(edItemOut.Text, VAL_ERROR) <> VAL_ERROR)
     ) then
  begin
{ TODO 2 -oMagoo -ctidy : Remove the constant values }
    DM_ITEMS.SaveItem(currItem
                     ,Now
                     ,TRIM(edDescription.Text)
                     ,StrToFloatDef(edItemIn.Text, VAL_ERROR)
                     ,StrToFloatDef(edItemOut.Text, VAL_ERROR)
                     ,DM_GENERAL.GetCbId (cbPayment)
                     ,0
                     ,1);
    currItem:= NEW_ID;
    InitItemScreen;
    DM_Items.getItems(Now);
    ShowBalance(now);

  end
  else
    ShowMessage('Error en los montos ingresados');
end;

procedure TfrmMain.bookNewExecute(Sender: TObject);
begin
  if sd.Execute then
  begin
   aBook.Create(sd.FileName);
   openFileBook(sd.FileName);
  end;
end;

procedure TfrmMain.bookOpenExecute(Sender: TObject);
begin
  if od.Execute then
  begin
    openFileBook(od.FileName);
  end;
end;

end.

