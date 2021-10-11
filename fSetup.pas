unit fSetup;

interface

uses
   registry, FileCtrl, ShellApi, ShlObj, ActiveX, ComObj,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, ExtCtrls, ComCtrls, jpeg;

type

   TSetupStep = (ssNone, ssWelcome, ssTargetFolder, ssShortcuts, ssReadyToInstall, ssINstall, ssFinish);

   TShortcutFolder = (sfCustom, sfStartMenu, sfPrograms, sfDesktop);

  TForm1 = class(TForm)
    btnInstall: TButton;
    paMain: TPanel;
    btnCancel: TButton;
    btnNext: TButton;
    btnBack: TButton;
    btnFinish: TButton;
    pcSteps: TPageControl;
    tsWelcome: TTabSheet;
    tsTargetFolder: TTabSheet;
    tsShortcuts: TTabSheet;
    tsInstall: TTabSheet;
    tsFinish: TTabSheet;
    tsSwap: TTabSheet;
    paWelcome: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    imgMyApp: TImage;
    paFinish: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    imgFinish: TImage;
    Label8: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    chLaunch: TCheckBox;
    paTargetFolder: TPanel;
    Panel1: TPanel;
    imgTargetFolder: TImage;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edTargetFolder: TEdit;
    btnChangeFolder: TButton;
    Label14: TLabel;
    paShortcuts: TPanel;
    Panel3: TPanel;
    imgShortcuts: TImage;
    Label17: TLabel;
    Label18: TLabel;
    chShortcutInPrograms: TCheckBox;
    chShortcutOnDesktop: TCheckBox;
    chShortcutInStartMenu: TCheckBox;
    paInstall: TPanel;
    Panel5: TPanel;
    imgInstall: TImage;
    Label15: TLabel;
    Label16: TLabel;
    pbSetup: TProgressBar;
    Label19: TLabel;
    laCurrentFile: TLabel;
    Label21: TLabel;
    Label20: TLabel;
    tsReadyToInstall: TTabSheet;
    paReadyToInstall: TPanel;
    Panel4: TPanel;
    imgReadyToInstall: TImage;
    Label22: TLabel;
    Label23: TLabel;
    Bevel1: TBevel;
    procedure DoInstall(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnChangeFolderClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnBackClick(Sender: TObject);
    procedure btnInstallClick(Sender: TObject);
    procedure btnFinishClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    sInstallDir: string;

    fSetupStep: TSetupStep;

    procedure CreateShortcuts;
    procedure DoExtractResource(sResourceName, sTargetFileName: string);
    procedure GotoStep(aSetupStep: TSetupStep);
    procedure RegisterUninstallerWithControlPanel;
    procedure SaveInstallationDirInRegistry;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure AssignJpegResourceToPicture(aPicture: TPicture; sName: string; hInst: THandle);
var
   jpgStream: TResourceStream;
   jpg: TJpegImage;
begin
   if hInst <> 0 then begin
      jpgStream := TResourceStream.Create(hInst, sName, RT_RCDATA);
      try
         jpgStream.Position := 0;
         jpg := TJpegImage.Create;
         try
            jpg.LoadFromStream(jpgStream);
            aPicture.Assign(jpg);
         finally
            jpg.Free;
         end;
      finally
         jpgStream.Free;
      end;
   end
end;

procedure CreateShortcut(sTargetFullPathname,
                         sArguments,
                         sDescription,
                         sLinkName: string;
                         ShortcutFolder: TShortcutFolder;
                         sShortcutFolder: string;
                         sWorkDir: string = '');
var
   MyObject: IUnknown;
   MySLink: IShellLink;
   MyPFile: IPersistFile;
   sDirectory: String;
   sFileName: WideString;
   Reg: TRegistry;
begin
   MyObject := CreateComObject(CLSID_ShellLink);
   MySLink := MyObject as IShellLink;
   MyPFile := MyObject as IPersistFile;
   with MySLink do begin
      SetArguments(PChar(sArguments));
      SetDescription(PChar(sDescription));
      SetPath(PChar(sTargetFullPathname));
      if sWorkDir = '' then
         sWorkDir := ExtractFilePath(sTargetFullPathname);
      SetWorkingDirectory(PChar(sWorkDir));
   end;

   if ShortcutFolder = sfCustom then
      sDirectory := sShortcutFolder
   else begin
      reg := TRegistry.Create;
      try
         reg.RootKey := HKEY_CURRENT_USER;
         reg.OpenKey('Software\MicroSoft\Windows\CurrentVersion\Explorer\Shell Folders', false);

         case ShortcutFolder of
            sfCustom: { Do nothing, it has been covered above! };
            sfStartMenu: sDirectory := reg.ReadString('Start Menu') + '\' + sShortcutFolder;
            sfPrograms: sDirectory := reg.ReadString('Programs') + '\' + sShortcutFolder;
            sfDesktop: sDirectory := reg.ReadString('Desktop') + '\' + sShortcutFolder;
         end;
         
      finally
         reg.Free
      end;
   end;

   ForceDirectories(sDirectory);
   sFileName := sDirectory + '\' + sLinkName;
   MyPFile.Save(PWChar(sFileName),False);

end;

function GetProgramFilesDirectory: string;
var
   reg: TRegistry;
begin
   reg := TRegistry.Create;
   try
      reg.RootKey := HKEY_LOCAL_MACHINE;
      reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion', True);
      result := reg.ReadString('ProgramFilesDir');
   finally
      reg.Free
   end;
   { Append a backslash at the end (if not present already }
   if (result <> '') and (result[Length(result)] <> '\') then
      result := result + '\';
end;

procedure ExtractResource(sResourceName, sTargetFileName: string);
var
   rStream: TResourceStream;
   fStream: TFileStream;
begin
   rStream := TResourceStream.Create(hInstance, sResourceName, RT_RCDATA);
   try
      fStream := TFileStream.Create(sTargetFileName, fmCreate);
      try
         fStream.CopyFrom(rStream, 0);
      finally
         fStream.Free;
      end;
   finally
      rStream.Free;
   end;
end;

procedure TForm1.DoInstall(Sender: TObject);
begin
   { Hide "Install button }
   btnInstall.Visible := false;

   { read target folder from the appropraite edit box text }
   sInstallDir := edTargetFolder.Text;
   { Create the folder full path } 
   ForceDirectories(sInstallDir);

   { Extract the application files }
	DoExtractResource('MyApp', sInstallDir + 'MyApp.exe');
	DoExtractResource('dllA', sInstallDir + 'A.DLL');
	DoExtractResource('dllB', sInstallDir + 'B.DLL');
	DoExtractResource('Helpfile', sInstallDir + 'MyApp.chm');

   { Extract the uninstaller executable as well. }
	DoExtractResource('Uninstaller', sInstallDir + 'Uninstall.exe');

   { Create the shortcuts as required }
   CreateShortcuts;

   { Save the installation directory in Windows registry }
   SaveInstallationDirInRegistry;

   { Register the uninstaller application with the "Add / remove programs" in Control Panel }
   RegisterUninstallerWithControlPanel; 
end;

procedure TForm1.btnCancelClick(Sender: TObject);
begin
   close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   { The default target folder for the installation }
   sInstallDir := GetProgramFilesDirectory + 'MyApp\';
   edTargetFolder.Text := sInstallDir;

   fSetupStep := ssNone;

   {
   Note that the image is dynamically assigned at run time,
   so that we can embed the images in the application resources ONLY ONCE,
   regardless of how many components use each image.
   If we had set their "Picture" property at desing time,
   an instance of the image would be embedded for each component,
   thus increasing the executable size. 
   }
   AssignJpegResourceToPicture(imgMyApp.Picture, 'MyAppImage', HInstance);
   AssignJpegResourceToPicture(imgFinish.Picture, 'MyAppImage', HInstance);
   AssignJpegResourceToPicture(imgTargetFolder.Picture, 'SetupIcon', HInstance);
   AssignJpegResourceToPicture(imgShortcuts.Picture, 'SetupIcon', HInstance);
   AssignJpegResourceToPicture(imgReadyToInstall.Picture, 'SetupIcon', HInstance);
   AssignJpegResourceToPicture(imgInstall.Picture, 'SetupIcon', HInstance);

   paWelcome.Parent := paMain
end;

procedure TForm1.btnNextClick(Sender: TObject);
begin
   GotoStep(Succ(fSetupStep));
end;

procedure TForm1.btnChangeFolderClick(Sender: TObject);
var
   sDir: string;
begin
   {
   NOTE:
   SelectDirectory() displays an outdated folder selection interface.
   In your real setup programs,
   you may want to use SHBrowseForFolder() API function instead.
   }
   sDir := 'c:\';
   if SelectDirectory(sDir, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
      edTargetFolder.Text := sDir + '\';
end;

procedure TForm1.GotoStep(aSetupStep: TSetupStep);
begin
   { Send panel currently showing to become a child of "tsSwap" TabSheet }
   case fSetupStep of
      ssNone:           {nothing to do};
      ssWelcome:        paWelcome.Parent := tsSwap;
      ssTargetFolder:   paTargetFolder.Parent := tsSwap;
      ssShortcuts:      paShortcuts.Parent := tsSwap;
      ssReadyToInstall: paReadyToInstall.Parent := tsSwap;
      ssInstall:        paInstall.Parent := tsSwap;
      ssFinish:         paFinish.Parent := tsSwap;
   end;

   { Change current step }
   fSetupStep := aSetupStep;

   { And send panel currently showing to become a child of "paMain" panel, thus becoming visible }
   case fSetupStep of
      ssNone:           {nothing to do};
      ssWelcome:        paWelcome.Parent := paMain;
      ssTargetFolder:   paTargetFolder.Parent := paMain;
      ssShortcuts:      paShortcuts.Parent := paMain;
      ssReadyToInstall: paReadyToInstall.Parent := paMain;
      ssInstall:        paInstall.Parent := paMain;
      ssFinish:         paFinish.Parent := paMain;
   end;

   { Finally, enable / disable / hide / show buttons accrding to the current step }
   btnBack.Visible := fSetupStep in [ssTargetFolder, ssShortcuts, ssReadyToInstall];
   btnNext.Visible := fSetupStep in [ssWelcome, ssTargetFolder, ssShortcuts];
   btnFinish.Visible := fSetupStep in [ssFinish];
   btnCancel.Visible := fSetupStep in [ssWelcome, ssTargetFolder, ssShortcuts, ssReadyToInstall, ssInstall];
   btnInstall.Visible := fSetupStep in [ssReadyToInstall];

end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   if fSetupStep <> ssFinish then
      CanClose := (MessageDlg('If you exit now, MyApp will not be installed.' + #13#10 +
                    'Are you sure you want to quit setup?',
                    mtConfirmation, [mbYes, mbNo], 0) = mrYes)
end;

procedure TForm1.btnBackClick(Sender: TObject);
begin
   GotoStep(Pred(fSetupStep));
end;

procedure TForm1.btnInstallClick(Sender: TObject);
begin
   GotoStep(Succ(fSetupStep));
   DoInstall(sender);
   GotoStep(ssFinish);
end;

procedure TForm1.btnFinishClick(Sender: TObject);
begin
   if chLaunch.Checked then
      ShellExecute(0, 'open', PChar(sInstallDir + 'MyApp.exe'), nil, '', SW_SHOWDEFAULT);

   Close
end;

procedure TForm1.FormShow(Sender: TObject);
begin
   GotoStep(ssWelcome);
end;

procedure TForm1.CreateShortcuts;
begin

   { shortcut in "programs" - ALWAYS }
   CreateShortCut(sInstallDir + 'MyApp.exe',
                  '',
                  'MyApp Description', 'MyApp.lnk',
                  sfPrograms,
                  'MyApp',
                  '');

   { shortcut on desktop }
   if chShortcutOnDesktop.Checked then
      CreateShortCut(sInstallDir + 'MyApp.exe',
                     '',
                     'MyApp Description', 'MyApp.lnk',
                     sfDesktop,
                     '',
                     '');

   { shortcut in start menu }
   if chShortcutInStartMenu.Checked then
      CreateShortCut(sInstallDir + 'MyApp.exe',
                     '',
                     'MyApp Description', 'MyApp.lnk',
                     sfStartMenu,
                     '',
                     '');

   { a shortcut for the application help file in "programs" - ALWAYS }
   CreateShortCut(sInstallDir + 'MyApp.chm',
                  '',
                  'MyApp HTML help', 'MyAppHelp.lnk',
                  sfPrograms,
                  'MyApp',
                  '');

   { Finally, a shortcut for Uninstaller in "programs" - ALWAYS }
   CreateShortCut(sInstallDir + 'Uninstall.exe',
                  '',
                  'Uninstall MyApp', 'MyAppUninstaller.lnk',
                  sfPrograms,
                  'MyApp',
                  '');

end;

procedure TForm1.DoExtractResource(sResourceName, sTargetFileName: string);
begin
   laCurrentFile.Caption := sTargetFileName;
   Application.ProcessMessages;
   
   ExtractResource(sResourceName, sTargetFileName);
end;

procedure TForm1.SaveInstallationDirInRegistry;
var
   reg: TRegistry;
begin
   reg := TRegistry.Create;
   try
      reg.RootKey := HKEY_CURRENT_USER;
      reg.OpenKey('Software\MyCompany\MyApp', true);
      reg.WriteString('Installation directory', sInstallDir);
   finally
      reg.Free
   end;
end;

procedure TForm1.RegisterUninstallerWithControlPanel;
var
   reg: TRegistry;
begin
   reg := TRegistry.Create;
   try
      reg.RootKey := HKEY_CURRENT_USER;
      reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Uninstall\MyApp', true);
      reg.WriteString('DisplayName', 'MyApp');
      reg.WriteString('UninstallString', '"' + sInstallDir + 'Uninstall.exe' + '"');
   finally
      reg.Free
   end;
end;

end.
