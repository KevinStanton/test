unit asFreeLibREG;

interface

uses
  SysUtils, Classes;

procedure Register;

implementation

{$R *.dcr}

uses
  asSpeedButton,asBtnPanel,asBtnPanelClose;

procedure Register;
begin
  RegisterComponents('Atlanticsoft', [TasSpeedButton,TasBtnPanel,TasBtnPanelClose]);
end;

end.
