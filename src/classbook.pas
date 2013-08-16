unit classBook;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils
  ,dmgeneral;

Type

  { TBook }

  TBook=class
    private
      fileDB: string;
    public
      procedure Create (afileDB: string);
      procedure Open (afileDB: string);

      constructor Create;
  end;

implementation

uses
  FileUtil
  ;
{ TBook }
const
  EXT_BAK = 'bak';
  TEMPLATE = 'masterdata.db';

procedure TBook.Create(afileDB: string);
begin
  if FileExists(afileDB) then
    RenameFile(afileDB, ChangeFileExt(afileDB, EXT_BAK));

  if CopyFile('.\'+TEMPLATE,afileDB) then
    Open (afileDB);
end;

procedure TBook.Open(afileDB: string);
begin
  if FileExists(afileDB) then
    DM_GENERAL.OpenDB(afileDB);
end;

constructor TBook.Create;
begin
  inherited Create;
end;

end.

