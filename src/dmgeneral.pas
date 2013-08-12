unit dmgeneral;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, Controls;

type

  { TDM_GENERAL }

  TDM_GENERAL = class(TDataModule)
    ImageListActs: TImageList;
    Cnx_General: TZConnection;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  DM_GENERAL: TDM_GENERAL;

implementation

{$R *.lfm}

end.

