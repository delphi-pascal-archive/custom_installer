unit fUninstall;

interface

uses
   ShellAPI, registry, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls;

type
   TShortcutFolder = (sfCustom, sfStartMenu, sfPrograms, sfDesktop);
   
  TfrmUninstall = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    btnUninstall: TButton;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnUninstallClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sInstallDir: string;

    procedure DeleteRegistryKeys;
    procedure DeleteShortcuts;
    function  GetShortcutFolder(ShortcutFolder: TShortcutFolder): string; 
    procedure LoadInstallationDirFromRegistry;
    procedure UnregisterUninstaller;
  end;

var
   frmUninstall: TfrmUninstall;

implementation

{$R *.dfm}

{=                                                                          <fh>
*******************************************************************************
FUNCTION: SH_DeleteFiles()
-------------------------------------------------------------------------------
DESCRIPTION :
    Deletes file(s) specified by pointer "sFiles" mask,
    using SHFileOperation() shell API function.
-------------------------------------------------------------------------------
INPUT:
   sFiles:     Mask for specified files.
   bConfirm:   Should Windows ask for confirmation before deleting?
   bSilent:    Should windows suppress the progress dialog?
   bAllowUndo: Should files be sent to the recycle bin instead of being deleted?
-------------------------------------------------------------------------------
RETURN VALUE:
    0 if no errors occurred,
    otherwise error code returned by SHFileOperation().
-------------------------------------------------------------------------------
REMARKS:
    sFiles MUST be a fully qualified pathname,
    especially if we set bAllowUndo := true.
    Otherwise results may be unpredictable.

*******************************************************************************
}
function  SH_DeleteFiles(sFiles: string;
                         bConfirm : boolean = false;
                         bSilent: boolean = true;
                         bAllowUndo: Boolean = false): integer;
var
   SHInfo : TSHFileOpStruct;
begin
   { The list of names of files to be deleted must be double null-terminated. }
   sFiles := sFiles + #0#0;

   FillChar(SHInfo, SizeOf(TSHFileOpStruct), 0);
   with SHInfo do begin
      wnd := Application.Handle;
      wFunc := FO_DELETE;
      pFrom := PChar(sFiles);
      pTo := nil;
      fFlags := 0;
      if not bConfirm then fFlags := fFlags or FOF_NOCONFIRMATION;
      if bSilent then fFlags := fFlags or FOF_SILENT;
      if bAllowUndo then fFlags := fFlags or FOF_ALLOWUNDO;
   end;
   Result := SHFileOperation(SHInfo);
end; { SH_DeleteFiles }

procedure TfrmUninstall.LoadInstallationDirFromRegistry;
var
   reg: TRegistry;
begin
   reg := TRegistry.Create;
   try
      reg.RootKey := HKEY_CURRENT_USER;
      reg.OpenKey('Software\MyCompany\MyApp', true);
      sInstallDir := reg.ReadString('Installation directory');
   finally
      reg.Free
   end;
end;

procedure TfrmUninstall.btnUninstallClick(Sender: TObject);
begin

   { Find out where the application has been installed }
   LoadInstallationDirFromRegistry;

   { Remove the last backslash from the installation folder name }
   Delete(sInstallDir, length(sInstallDir), 1);

   { Delete the created shortcuts }
   DeleteShortcuts;

   { Delete the Windows registry keys we created at installation }
   DeleteRegistryKeys;

   { "Unregister" the uninstaller app from the "Add/Remove programs" control panel section }
   UnregisterUninstaller;

   { Delete the installation folder }
   if DirectoryExists(sInstallDir) then
      SH_DeleteFiles(sInstallDir);

   MessageDlg('MyApp has been successfully removed from your computer.', mtInformation, [mbOK], 0);

   Close;

end;

procedure TfrmUninstall.DeleteRegistryKeys;
var
   reg: TRegistry;
begin
   reg := TRegistry.Create;
   try
      reg.RootKey := HKEY_CURRENT_USER;
      reg.DeleteKey('Software\MyCompany\MyApp');

      {
      Note that this will leave the HKEY_CURRENT_USER\Software\MyCompany registry key
      on the user's computer.
      This is desired if e.g. we have installed more than one of our company's applications
      on the user's computer, and we want to delete the registry key only for the current,
      leaving the other ones intact.
      If this is not the case, then the above command should be instead:
         reg.DeleteKey('Software\MyCompany');
      }

   finally
      reg.Free
   end;
end;

procedure TfrmUninstall.UnregisterUninstaller;
var
   reg: TRegistry;
begin
   reg := TRegistry.Create;
   try
      reg.RootKey := HKEY_CURRENT_USER;
      reg.DeleteKey('Software\Microsoft\Windows\CurrentVersion\Uninstall\MyApp');
   finally
      reg.Free
   end;
end;

procedure TfrmUninstall.btnCancelClick(Sender: TObject);
begin
   Close;
end;

procedure TfrmUninstall.DeleteShortcuts;
var
   sFileMask: string;
begin
   {
   delete shortcuts in "programs" - delete the entire folder.
   This deletes the Application shortcut, the help file shortcut as well as the uninstaller shortcut 
   }
   sFileMask := GetShortcutFolder(sfPrograms) + 'MyApp';
   if DirectoryExists(sFileMask) then
      SH_DeleteFiles(sFileMask);

   { shortcut on desktop }
   sFileMask := GetShortcutFolder(sfDesktop) + 'MyApp.lnk';
   DeleteFile(sFileMask);

   { shortcut in start menu }
   sFileMask := GetShortcutFolder(sfStartMenu) + 'MyApp.lnk';
   DeleteFile(sFileMask);

end;

function TfrmUninstall.GetShortcutFolder(ShortcutFolder: TShortcutFolder): string;
var
   reg: TRegistry;
begin
   reg := TRegistry.Create;
   try
      reg.RootKey := HKEY_CURRENT_USER;
      reg.OpenKey('Software\MicroSoft\Windows\CurrentVersion\Explorer\Shell Folders', false);

      case ShortcutFolder of
         sfCustom: result := '';{ Do nothing }
         sfStartMenu: result := reg.ReadString('Start Menu') + '\';
         sfPrograms: result := reg.ReadString('Programs') + '\';
         sfDesktop: result := reg.ReadString('Desktop') + '\';
      end;

   finally
      reg.Free
   end;
end;

end.
