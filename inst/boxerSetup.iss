; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Boxer"
#define MyAppVersion "1.1.0"
#define MyAppPublisher "RACSS Programación"
#define MyAppURL "http://www.racss.com.ar/"
#define MyAppExeName "boxer.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{2AF167FD-2F22-4298-BF3D-0ABCB60F7794}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile=R:\Trabajo\programas\boxer\LICENSE
InfoBeforeFile=R:\Trabajo\programas\boxer\exe\cambios.txt
OutputDir=R:\Trabajo\programas\boxer\inst\1-1-0
OutputBaseFilename=instaladorBoxer  
Compression=lzma
SolidCompression=yes

[Languages]
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "R:\Trabajo\programas\boxer\exe\boxer.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "R:\Trabajo\programas\boxer\exe\boxer.cfg"; DestDir: "{app}"; Flags: ignoreversion
Source: "R:\Trabajo\programas\boxer\exe\itemsrange.lrf"; DestDir: "{app}"; Flags: ignoreversion
Source: "R:\Trabajo\programas\boxer\exe\masterdata.db"; DestDir: "{app}"; Flags: ignoreversion
Source: "R:\Trabajo\programas\boxer\exe\sqlite3.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "R:\Trabajo\programas\boxer\exe\cambios.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "R:\Trabajo\programas\boxer\LICENSE"; DestDir: "{app}"; Flags: ignoreversion

; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

