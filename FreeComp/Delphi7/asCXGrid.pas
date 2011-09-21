unit asCXGrid;

interface

uses cxGrid, Controls, Classes;

type
	TasCXGrid = class(TcxGrid)
  private
  public
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); dynamic;
  published
  end;

implementation

procedure TasCXGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Y > 144 then
  inherited;
end;

end.
