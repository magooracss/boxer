unit frm_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Menus, ActnList, DBGrids
  ,dmgeneral
  ;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    bookOpen: TAction;
    bookNew: TAction;
    MenuBooks: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem5: TMenuItem;
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
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    procedure prgExitExecute(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.prgExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

end.

