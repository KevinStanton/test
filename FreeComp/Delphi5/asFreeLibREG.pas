unit asFreeLibREG;

interface

uses
  SysUtils, Classes;

procedure Register;

implementation

{$R *.dcr}

uses
  asSpeedButton,asBtnPanel,asBtnPanelClose,asCalender;

procedure Register;
begin
  RegisterComponents('Atlanticsoft', [TasSpeedButton,TasBtnPanel,TasBtnPanelClose,TasCalender]);
end;

end.
