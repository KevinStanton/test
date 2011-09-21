unit DirMon;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs;

const
  DefDir = 'C:\';

type
  { TDirChangeMonitor }

  TDirMonitorOption = (dcFileName, dcDirName, dcAttribs, dcSize,
    dcLastWrite, dcSecurity);
  TDirMonitorOptions = set of TDirMonitorOption;

  TDirChangeMonitor = class(TComponent)
  private
    { Private declarations }
    FChangeHandle: THandle;
    FMonitorSubDirs: Boolean;
    FFileFilter: string;
    FDirName: string;
    FOnChange: TNotifyEvent;
    FStreamedActive: Boolean;
    FMonitorOptions: TDirMonitorOptions;
    FOnStartMonitor: TNotifyEvent;
    FOnStopMonitor: TNotifyEvent;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetDirName(const Value: string);
    procedure SetFileFilter(const Value: string);
    procedure SetMonitorSubDirs(const Value: Boolean);
    procedure SetMonitorOptions(const Value: TDirMonitorOptions);
  protected
    { Protected declarations }
    procedure CheckActive;
    procedure CheckInactive;
    procedure Loaded; override;
    procedure StartMonitor;
    procedure StopMonitor;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ChangeHandle: THandle read FChangeHandle;
  published
    { Published declarations }
    property Active: Boolean read GetActive write SetActive;
    property MonitorOptions: TDirMonitorOptions read FMonitorOptions
      write SetMonitorOptions default [dcFileName, dcLastWrite];
    property DirName: string read FDirName write SetDirName;
    { FileFilter not working yet }
    property FileFilter: string read FFileFilter write SetFileFilter;
    property MonitorSubDirs: Boolean read FMonitorSubDirs
      write SetMonitorSubDirs default False;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnStartMonitor: TNotifyEvent read FOnStartMonitor write
FOnStartMonitor;
    property OnStopMonitor: TNotifyEvent read FOnStopMonitor write
FOnStopMonitor;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('System', [TDirChangeMonitor]);
end;

const
  MonitorOptConsts: array[TDirMonitorOption] of DWORD =
    (FILE_NOTIFY_CHANGE_FILE_NAME, FILE_NOTIFY_CHANGE_DIR_NAME,
     FILE_NOTIFY_CHANGE_ATTRIBUTES, FILE_NOTIFY_CHANGE_SIZE,
     FILE_NOTIFY_CHANGE_LAST_WRITE, FILE_NOTIFY_CHANGE_SECURITY);

type
  EDirChangeMonitor = class(Exception);

procedure DirChangeMonitorError(const Error: string; Monitor:
TDirChangeMonitor = nil);
var
  CompName: string;
begin
  CompName := '';
  if Assigned(Monitor) then
    CompName := Monitor.Name;
  raise EDirChangeMonitor.Create(Format('%s, %s', [Error, CompName]));
end;

{ TDirChangeMonitor }

procedure TDirChangeMonitor.CheckActive;
begin
  if not Active then
    DirChangeMonitorError('Can''t perform this operation while active');
end;

procedure TDirChangeMonitor.CheckInactive;
begin
  if Active then
    DirChangeMonitorError('Can''t perform this operation while active');
end;

constructor TDirChangeMonitor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FChangeHandle := INVALID_HANDLE_VALUE;
  FMonitorOptions := [dcFileName, dcLastWrite];
  FDirName := GetCurrentDir;
end;

destructor TDirChangeMonitor.Destroy;
begin
  StopMonitor;
  inherited Destroy;
end;

function TDirChangeMonitor.GetActive: Boolean;
begin
  Result := FChangeHandle <> INVALID_HANDLE_VALUE;
end;

procedure TDirChangeMonitor.Loaded;
begin
  inherited Loaded;
  if FStreamedActive then Active := True;
end;

procedure TDirChangeMonitor.SetActive(const Value: Boolean);
begin
  if Value = Active then Exit;
  if Value and (csReading in ComponentState) then
  begin
    FStreamedActive := True;
    Exit;
  end;
  if Value then
  begin
    StartMonitor;
  end
  else StopMonitor;
end;

procedure TDirChangeMonitor.SetDirName(const Value: string);
begin
  CheckInactive;
  FDirName := Value;
end;

procedure TDirChangeMonitor.SetFileFilter(const Value: string);
begin
  CheckInactive;
  FFileFilter := Value;
end;

procedure TDirChangeMonitor.SetMonitorOptions(
  const Value: TDirMonitorOptions);
begin
  CheckInactive;
  FMonitorOptions := Value;
end;

procedure TDirChangeMonitor.SetMonitorSubDirs(const Value: Boolean);
begin
  CheckInactive;
  FMonitorSubDirs := Value;
end;

procedure TDirChangeMonitor.StartMonitor;
var
  MonitorOptValues: DWORD;
  WaitStatus: DWORD;
  Handles: array[0..0] of THandle;
  I: TDirMonitorOption;
begin
  if Active then Exit;
  MonitorOptValues := 0;
  for I := Low(TDirMonitorOption) to High(TDirMonitorOption) do
    if I in MonitorOptions then
      MonitorOptValues := MonitorOptValues or MonitorOptConsts[I];
  FChangeHandle := FindFirstChangeNotification(
    PChar(FDirName), LongBool(FMonitorSubDirs),
    MonitorOptValues);
  Handles[0] := FChangeHandle;
  if FChangeHandle = INVALID_HANDLE_VALUE then
    RaiseLastWin32Error;
  if Assigned(FOnStartMonitor) then
    OnStartMonitor(Self);
  while not Application.Terminated do
  begin
    WaitStatus := MsgWaitForMultipleObjects(1, Handles,
      LongBool(False), INFINITE, QS_ALLINPUT);
    case WaitStatus of
      WAIT_OBJECT_0:
        begin
          if Assigned(FOnChange) then
            OnChange(Self);
          if not FindNextChangeNotification(ChangeHandle) then
          begin
            StopMonitor;
            RaiseLastWin32Error;
          end;
        end;
    else
      Application.ProcessMessages;
    end;
  end;
end;

procedure TDirChangeMonitor.StopMonitor;
begin
  if FChangeHandle <> INVALID_HANDLE_VALUE then
  begin
    FindCloseChangeNotification(FChangeHandle);
    FChangeHandle := INVALID_HANDLE_VALUE;
    if Assigned(FOnStopMonitor) then
      FOnStopMonitor(Self);
  end;
end;

end.
