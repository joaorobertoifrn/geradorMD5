unit unitMD5;

interface

 uses Forms , ShellApi, IdHashMessageDigest, Classes, SysUtils, Windows, Dialogs;

 type
   TMD5 = class
     function GeraString(Const Valor : String):String;
     function GeraArquivo(Const Valor : String): String;
     function DataCriacao(const Arq: string): String;
     function GetBuild(prog: String): String;
   end;

  var
   MD5 : TMD5;

implementation

uses Form_Principal;

{ TMD5 }

function TMD5.DataCriacao(const Arq: string): String;
var
  FileH: THandle;
  LocalFT: TFileTime;
  DosFT: DWORD;
  LastAccessedTime: TDateTime;
  FindData: TWin32FindData;
begin
Result := '';
  FileH := FindFirstFile(PChar(Arq), FindData);
  if FileH <> INVALID_HANDLE_VALUE then
  begin
   Windows.FindClose(Form1.Handle) ;
   if (FindData.dwFileAttributes AND
       FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
     FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFT);
     FileTimeToDosDateTime(LocalFT,LongRec(DosFT).Hi, LongRec(DosFT).Lo);
     LastAccessedTime := FileDateToDateTime(DosFT);
     Result := DateTimeToStr(LastAccessedTime);
    end;
  end;
end;

function TMD5.GeraArquivo(const Valor: String): String;
var
  xMD5: TIdHashMessageDigest5;
  xArquivo: TFileStream;
begin
  xMD5 := TIdHashMessageDigest5.Create;
  xArquivo := TFileStream.Create(Valor, fmOpenRead OR fmShareDenyWrite);
  try
    Result := xMD5.HashStreamAsHex(xArquivo);
  finally
    FreeAndNil(xArquivo);
    FreeAndNil(xMD5);
  end;
end;

function TMD5.GeraString(const Valor: String): string;
var
  xMD5: TIdHashMessageDigest5;
begin
  xMD5 := TIdHashMessageDigest5.Create;
  try
    Result := xMD5.HashStringAsHex(Valor);
  finally
    FreeAndNil(xMD5);
  end;
end;

function TMD5.GetBuild(prog: String): String;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  V1, V2, V3, V4: Word;
begin
  try
    VerInfoSize := GetFileVersionInfoSize(PChar(prog),Dummy);
    GetMem(VerInfo,VerInfoSize);
    if GetFileVersionInfo(PChar(prog),0,VerInfoSize,VerInfo) then
      if VerQueryValue(VerInfo,'',Pointer(VerValue),VerValueSize) then
      begin
        with VerValue^ do
        begin
          V1 := dwFileVersionMS shr 16;
          V2 := dwFileVersionMS and $FFFF;
          V3 := dwFileVersionLS shr 16;
          V4 := dwFileVersionLS and $FFFF;
        end;

        FreeMem(VerInfo,VerInfoSize);

        result := Copy(IntToStr(100 + v1),3,2) + '.' +
                  Copy(IntToStr(100 + V2),3,2) + '.' +
                  Copy(IntToStr(100 + V3),3,2) + '.' +
                  Copy(IntToStr(100 + V4),3,2);

      end;
  Except
    on e : exception do
    begin
     result := '';
     ShowMessage('Erro : '+ e.Message);
    end;

  end;
end;

end.
