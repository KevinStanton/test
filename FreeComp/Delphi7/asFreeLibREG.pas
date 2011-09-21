unit asFreeLibREG;

interface

uses
  SysUtils, Classes;

procedure Register;

implementation

{$R *.dcr}

uses
  asSpeedButton,asBtnPanel,asBtnPanelClose,asCalender,asTray,TriadCard, asNonXPPanel, DirMon;

procedure Register;
begin
  RegisterComponents('Atlanticsoft', [TNonXPPanel,TTriadCard,TasTray,TasSpeedButton,TasBtnPanel,TasBtnPanelClose,TasCalender, TDirChangeMonitor]);
end;

end.
