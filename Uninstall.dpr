program Uninstall;

uses
  Forms, Windows, SysUtils, classes,
  fUninstall in 'fUninstall.pas' {frmUninstall};

{$R *.res}

procedure RunCloneEXEfromTemp;
var
   sOriginalEXE: string;
   sCloneEXE,
   sTempDir: array [0..MAX_PATH] of char;
   sCommandLine: array [0..512] of char;
   si :TSTARTUPINFO;
   pi :TProcessInformation;
begin

   sOriginalEXE := Application.ExeName;
   { Get the temporary folder }
   GetTempPath(MAX_PATH, sTempDir);
   { Create the clone file name }
   StrCopy(sCloneExe, PChar(Format('%s%s',[sTempDir, ExtractFileName(Application.ExeName)])));

   { Clone this executable  into the temporary folder }
   CopyFile(PChar(sOriginalEXE), sCloneEXE, false);

   {
   Pass a command line parameter so that the clone process KNOWS that it is a clone,
   so that it can execute normally instead of spawning yet another .exe!
   }
   StrCopy(sCommandLine, PChar(Format('%s -clone',[sCloneEXE])));

   ZeroMemory(@si, sizeof(si));
   si.cb := sizeof(si);

   { Run the clone .exe }
   CreateProcess(nil, sCommandLine, nil, nil, true, 0, nil, nil, si, pi);

end;


procedure SelfDelete;
var
   cTempDir: array [0..MAX_PATH] of char;
   sModulename,
   sBatchfile:string;
   BatchLines: TStringList;
   si: TStartupInfo;
   pi: TProcessInformation;
begin
   sModulename := Application.ExeName;

   { Get the temporary folder }
   GetTempPath(MAX_PATH, cTempDir);

   { Create a string list with the batch file commands }
   BatchLines := TStringlist.Create;
   try
      {
      This batch file will actually loop, trying to delete the clone .exe.
      Once the clone .exe has terminated, the batch will delete it.
      Finally, the batch file will delete itself (batch files *CAN* delete themselves!)
      }
      sBatchfile := string(cTempDir) + 'delself.bat';
      BatchLines.Add('@echo off');
      BatchLines.Add(':try');
      BatchLines.Add('del '+ sModulename);
      BatchLines.Add('if exist ' + sModulename + ' goto try');
      BatchLines.Add('del ' + sBatchfile );
      { Save the batch file to the temporary folder }
      BatchLines.SaveToFile(sBatchfile);
   finally
      BatchLines.free;
   end;

   ZeroMemory(@si, sizeof(si));
   si.cb:=sizeof(Si);
   { SW_HIDE so that the command window is never displayed to the user }
   si.wShowWindow :=  SW_HIDE;
   si.dwFlags := STARTF_USESHOWWINDOW;

   { Execute the batch file }
   CreateProcess(nil, PChar(sBatchfile), nil, nil,
                 false, IDLE_PRIORITY_CLASS + DETACHED_PROCESS,
                 nil, nil, si, pi);
end;


begin

   if ParamCount = 0 then begin
      { The original .exe only spawns the clone and terminates }
      RunCloneEXEfromTemp
   end else begin
      { The clone is actually responsible for the uninstaller functionality }
      Application.Initialize;
      Application.CreateForm(TfrmUninstall, frmUninstall);
      Application.Run;
      { The clone must ALWAYS delete itself from the temp directory }
      SelfDelete;
   end;
   
end.
