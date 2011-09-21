//------------------------------------------------------------------------------
//
// asCalender
//
// This was created to have a calender with several display options.,
//
// http://AtlanticSoft.com
//
// Kevin Stanton April 2003
//
// Please feel free to contact me: KevinStanton@AtlanticSoft.com
//
// This component is FREE.
//
// Revison History:
//   -NONE YET.
//------------------------------------------------------------------------------
unit asCalender;

interface

uses StdCtrls, ExtCtrls, Controls, Classes, Grids, Graphics, Windows, Messages, Forms, SysUtils;

type
	TasCalender = class;

  TAutoSizeOptions = (asNone, asFitCellsToWidth, asFitWidthToCells);

  TCellState = (csEnabled, csDisabled, csSelected);

  TBeforeDrawCellEvent = procedure (Sender: TObject; ACol, ARow: Longint;
    Canvas: TCanvas; Rect: TRect; State: TCellState;
    CellDate: TDate) of object;

  TAfterDrawCellEvent = procedure (Sender: TObject; ACol, ARow: Longint;
    Canvas: TCanvas; Rect: TRect; State: TCellState;
    CellDate: TDate) of object;

  TCellClickEvent = procedure (Sender: TObject; ACol, ARow, X, Y: Longint;
    Canvas: TCanvas; aRect: TRect; CellDate: TDate; Enabled: Boolean) of object;

  TCellMouseDownEvent = procedure (Sender: TObject; ACol, ARow, X, Y: Longint;
    Canvas: TCanvas; aRect: TRect; CellDate: TDate; Enabled: Boolean) of object;

  TCellMouseUpEvent = procedure (Sender: TObject; ACol, ARow, X, Y: Longint;
    Canvas: TCanvas; aRect: TRect; CellDate: TDate; Enabled: Boolean) of object;

	THeaderOptions = class(TPersistent)
  private
		FOwner: TasCalender;
    FHeaderColor: TColor;
    FCaptionSunday: string;
    FCaptionMonday: string;
    FCaptionTuesday: string;
    FCaptionWednesday: string;
    FCaptionThursday: string;
    FCaptionFriday: string;
    FCaptionSaturday: string;
    procedure SetHeaderColor(const Value: TColor);
	public
		constructor Create(AOwner: TasCalender);
	published
		property HeaderColor: TColor read FHeaderColor write SetHeaderColor;
    property CaptionSunday: string read FCaptionSunday write FCaptionSunday;
    property CaptionMonday: string read FCaptionMonday write FCaptionMonday;
    property CaptionTuesday: string read FCaptionTuesday write FCaptionTuesday;
    property CaptionWednesday: string read FCaptionWednesday write FCaptionWednesday;
    property CaptionThursday: string read FCaptionThursday write FCaptionThursday;
    property CaptionFriday: string read FCaptionFriday write FCaptionFriday;
    property CaptionSaturday: string read FCaptionSaturday write FCaptionSaturday;
  end;

	TasCalender = class(TDrawGrid)
  private
    SelectedCol: Integer;
    SelectedRow: Integer;
    FOnSelectCell: TSelectCellEvent;
    FBorderColor: TColor;
    FDate: TDate;
    DateofFirstCell: TDate;
    FDisabledCellColor: TColor;
    FCellColor: TColor;
    FSelectedColor: TColor;
    FHeaderCellSize: Integer;
    FHeaderOptions: THeaderOptions;
    FHeaderFont: TFont;
    FSelectedCellFont: TFont;
    FCellFont: TFont;
    FDisabledCellFont: TFont;
    FCellHeight: Integer;
    FCellWidth: Integer;
    FAutoSizeOptions: TAutoSizeOptions;
    FDoBeforeCellDraw: TBeforeDrawCellEvent;
    FDoAfterCellDraw: TAfterDrawCellEvent;
    FDoCellClick: TCellClickEvent;
    WasPressed: Boolean;
    ColPressed: Integer;
    RowPressed: Integer;
    FDoDateChange: TNotifyEvent;
    FDoCellMouseDown: TCellMouseDownEvent;
    FDoCellMouseUp: TCellMouseUpEvent;
    procedure SetHeaderCellSize(const Value: Integer);
    procedure ResizeHeaderCells;
    procedure ResizeCellHeights;
    procedure ResizeCellWidths;
    procedure SetBorderColor(const Value: TColor);
    procedure SetCellColor(const Value: TColor);
    procedure SetSelectedColor(const Value: TColor);
    procedure SetDate(const Value: TDate);
    procedure SetDisabledCellColor(const Value: TColor);
    function  CellEnabled(Col, Row: Integer): Boolean;

    procedure DoDrawText(var Rect: TRect; aCaption: string);

    function  MonthChanged(aDate: TDate): Boolean;

    procedure SetHeaderFont(Value: TFont);
    procedure SetCellFont(Value: TFont);
    procedure SetDisabledCellFont(Value: TFont);
    procedure SetSelectedCellFont(Value: TFont);
    procedure SetCellHeight(const Value: Integer);
    procedure SetCellWidth(const Value: Integer);
    procedure SetAutoSizeOptions(const Value: TAutoSizeOptions);
    procedure DoAutoSize;
    //Resize Message
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    //Mouse Click Message
    procedure WMLBUTTONUP(var Message: TWMLBUTTONUP); message WM_LBUTTONUP;
    procedure WMLBUTTONDOWN(var Message: TWMLBUTTONDOWN); message WM_LBUTTONDOWN;
    //Mouse Enter
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMOUSELEAVE(var Message: TMessage); message CM_MOUSELEAVE;

    function IsDoBeforeCellDrawStored: Boolean;
    function IsDoAfterCellDrawStored: Boolean;
    function IsDoCellClickStored: Boolean;
    function IsDoDateChangeStored: Boolean;
    function IsDoCellMouseDownStored: Boolean;
    function IsDoCellMouseUpStored: Boolean;
  protected
  public
    constructor Create(AComponent: TComponent); override;
    procedure invalidate; override;
    function SelectCell(ACol, ARow: Longint): Boolean; override;
    property OnSelectCell: TSelectCellEvent read FOnSelectCell write FOnSelectCell;

    procedure IncMonth;
    procedure DecMonth;
    procedure SetMonth(NewMonth: Integer);
    procedure IncYear;
    procedure DecYear;
    procedure SetYear(NewYear: Integer);
  published
    property Align;
    property AutoSizeOptions: TAutoSizeOptions read FAutoSizeOptions write SetAutoSizeOptions;

    property HeaderFont: TFont read FHeaderFont write SetHeaderFont;
    property CellFont: TFont read FCellFont write SetCellFont;
    property DisabledCellFont: TFont read FDisabledCellFont write SetDisabledCellFont;
    property SelectedCellFont: TFont read FSelectedCellFont write SetSelectedCellFont;
    property HeaderOptions: THeaderOptions read FHeaderOptions write FHeaderOptions;

    property Date: TDate read FDate write SetDate;
    property CellColor: TColor read FCellColor write SetCellColor;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property DisabledCellColor: TColor read FDisabledCellColor write SetDisabledCellColor;
    property HeaderCellSize: Integer read FHeaderCellSize write SetHeaderCellSize;
    property CellWidth: Integer read FCellWidth write SetCellWidth;
    property CellHeight: Integer read FCellHeight write SetCellHeight;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    property ParentColor default False;
    property DoBeforeCellDraw: TBeforeDrawCellEvent read FDoBeforeCellDraw write FDoBeforeCellDraw stored IsDoBeforeCellDrawStored;
    property DoAfterCellDraw: TAfterDrawCellEvent read FDoAfterCellDraw write FDoAfterCellDraw stored IsDoAfterCellDrawStored;
    property OnClick: TCellClickEvent read FDoCellClick write FDoCellClick stored IsDoCellClickStored;
    property OnMouseDown: TCellMouseDownEvent read FDoCellMouseDown write FDoCellMouseDown stored IsDoCellMouseDownStored;
    property OnMouseUp: TCellMouseUpEvent read FDoCellMouseUp write FDoCellMouseUp stored IsDoCellMouseUpStored;
    property OnDateChange: TNotifyEvent read FDoDateChange write FDoDateChange stored IsDoDateChangeStored;
    property OnColumnMoved;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawCell;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetEditMask;
    property OnGetEditText;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseMove;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property ScrollBars;
  end;

function MonthOf(const AValue: TDateTime): Word;
function DaysInAMonth(const AYear, AMonth: Word): Word;
function DayOf(const AValue: TDateTime): Word;
function IsValidDate(const AYear, AMonth, ADay: Word): Boolean;

const Author: String = 'Kevin Stanton';

implementation

function MonthOf(const AValue: TDateTime): Word;
var
  LYear, LDay: Word;
begin
  DecodeDate(AValue, LYear, Result, LDay);
end;

function DaysInAMonth(const AYear, AMonth: Word): Word;
begin
  Result := MonthDays[(AMonth = 2) and IsLeapYear(AYear), AMonth];
end;

function DayOf(const AValue: TDateTime): Word;
var
  LYear, LMonth: Word;
begin
  DecodeDate(AValue, LYear, LMonth, Result);
end;

function IsValidDate(const AYear, AMonth, ADay: Word): Boolean;
begin
  Result := (AYear >= 1) and (AYear <= 9999) and
            (AMonth >= 1) and (AMonth <= 12) and
            (ADay >= 1) and (ADay <= DaysInAMonth(AYear, AMonth));
end;

{ TasBtnPanel }

function TasCalender.CellEnabled(Col, Row: Integer): Boolean;
var
  CellDate: TDate;
begin
  result := False;
  if Row = 0 then exit;
  CellDate := DateofFirstCell + 7*(Row-1)+Col;
  if MonthOF(CellDate) <> MonthOf(Date) then exit;

  result := True;
end;

procedure TasCalender.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FGridState := gsNormal;
  WasPressed := False;
end;

procedure TasCalender.CMMOUSELEAVE(var Message: TMessage);
begin
  inherited;
  FGridState := gsNormal;
end;

constructor TasCalender.Create(AComponent: TComponent);
begin
	inherited Create(AComponent);
  WasPressed := False;

  FHeaderFont := TFont.Create;
  FHeaderFont.Size := 12;
  FHeaderFont.Style := [fsBold];
  FHeaderFont.Color := clWhite;

  FCellFont := TFont.Create;
  FCellFont.Size := 8;
  FCellFont.Style := [];
  FCellFont.Color := clBlack;

  FDisabledCellFont := TFont.Create;
  FDisabledCellFont.Size := 8;
  FDisabledCellFont.Style := [fsItalic];
  FDisabledCellFont.Color := clBlack;

  FSelectedCellFont := TFont.Create;
  FSelectedCellFont.Size := 10;
  FSelectedCellFont.Style := [fsBold];
  FSelectedCellFont.Color := clWhite;

  FHeaderOptions := THeaderOptions.Create(Self);
  FHeaderOptions.FHeaderColor := clBtnShadow;

  FHeaderOptions.FCaptionSunday    := 'S';
  FHeaderOptions.FCaptionMonday    := 'M';
  FHeaderOptions.FCaptionTuesday   := 'T';
  FHeaderOptions.FCaptionWednesday := 'W';
  FHeaderOptions.FCaptionThursday  := 'T';
  FHeaderOptions.FCaptionFriday    := 'F';
  FHeaderOptions.FCaptionSaturday  := 'S';

  DoubleBuffered := True;
  DefaultDrawing := False;
  BorderColor := clBlack;
  CellColor := clWhite;
  SelectedColor := clBtnShadow;
  DisabledCellColor := clSilver;
  Options := [goVertLine,goHorzLine];
  Height := 223;
  Width := 231;
  BorderStyle := bsnone;
  FixedCols := 0;
  FixedRows := 0;
  ColCount  := 7;
  RowCount  := 7;
  HeaderCellSize := 24;
  CellWidth := 32;
  CellHeight := 32;
  ResizeCellHeights;
  ResizeCellWidths;  
  Date := now;
  invalidate;
end;

procedure TasCalender.DecMonth;
var
  aYear, aMonth, aDay: word;
  MaxDays: Integer;
begin
  DecodeDate(Date,aYear, aMonth, aDay);
  if aMonth > 1 then
    aMonth := aMonth - 1
  else
  begin
    aMonth := 12;
    aYear := aYear - 1;
  end;
  MaxDays := DaysInAMonth(aYear, aMonth);
  if MaxDays < aDay then
    Date := EncodeDate(aYear, aMonth, MaxDays)
  else
    Date := EncodeDate(aYear, aMonth, aDay);
end;

procedure TasCalender.DecYear;
var
  aYear, aMonth, aDay: word;
  MaxDays: Integer;
begin
  DecodeDate(Date,aYear, aMonth, aDay);
  aYear := aYear - 1;
  MaxDays := DaysInAMonth(aYear, aMonth);
  if MaxDays < aDay then
    Date := EncodeDate(aYear, aMonth, MaxDays)
  else
    Date := EncodeDate(aYear, aMonth, aDay);
end;

procedure TasCalender.DoAutoSize;
begin
  if AutoSizeOptions = asNone then exit;
  if AutoSizeOptions = asFitCellsToWidth then
  begin
    CellWidth := Trunc((Width - 7) / 7);
    CellHeight := Trunc((Height - 7 - HeaderCellSize) / 6);
  end else
  if AutoSizeOptions = asFitWidthToCells then
  begin
    Width := (CellWidth * 7) + 7;
    Height := (CellHeight * 6) + 7 + HeaderCellSize;
  end;
end;

procedure TasCalender.DoDrawText(var Rect: TRect; aCaption: string);
var
  Flags: Longint;
begin
  Flags := DT_CALCRECT;
  Canvas.Font := HeaderFont;
  DrawText(Canvas.Handle, PChar(aCaption), Length(aCaption), Rect, Flags);
end;

procedure TasCalender.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
var
  CellDate: TDate;
  DayNum: Integer;
  TempRect: TRect;
  aCaption: String;
  aCellState: TCellState;
begin
  inherited;       
  { ** Calculate Date of this Cell ** }
  CellDate := DateofFirstCell + 7*(aRow-1)+aCol;
  DayNum := DayOf(CellDate);
  {Do Before Draw}
  if ARow <> 0 then
  begin
    if ((SelectedCol = ACol)AND(SelectedRow = ARow)) then
    begin
      Canvas.Font := SelectedCellFont;
      Canvas.Brush.Color := SelectedColor;
      Canvas.Pen.Color := clWhite;
      aCellState := csSelected
    end else
    begin
      if MonthOF(CellDate) = MonthOf(Date) then
      begin
        Canvas.Font := CellFont;
        Canvas.Brush.Color := CellColor;
        aCellState := csEnabled;
      end else
      begin
        Canvas.Font := DisabledCellFont;
        Canvas.Brush.Color := DisabledCellColor;
        aCellState := csDisabled;
      end;
    end;

    if not (csDesigning in ComponentState) then
      if IsDoBeforeCellDrawStored then
      begin
        TempRect.Left := aRect.Left + 1;
        TempRect.Top := aRect.Top + 1;
        TempRect.Right := aRect.Right - 1;
        TempRect.Bottom := aRect.Bottom - 1;
        FDoBeforeCellDraw(Self,ACol,ARow,Canvas,TempRect,aCellState,CellDate);
      end;
  end;
  {END Do Before Draw}

  if aRow = 0 then
  begin
    Canvas.Font := HeaderFont;
  end;

  if aRow = 0 then
  begin
    { ** Draw Header For Days of the Week ** }
    Canvas.Brush.Color := HeaderOptions.HeaderColor;
    {Label Cols.}
    Case ACol of
      0: aCaption := HeaderOptions.CaptionSunday;
      1: aCaption := HeaderOptions.CaptionMonday;
      2: aCaption := HeaderOptions.CaptionTuesday;
      3: aCaption := HeaderOptions.CaptionWednesday;
      4: aCaption := HeaderOptions.CaptionThursday;
      5: aCaption := HeaderOptions.CaptionFriday;
      6: aCaption := HeaderOptions.CaptionSaturday;
    end;

    TempRect := ARect;
    DoDrawText(TempRect,aCaption);

    Canvas.TextRect(ARect,ARect.Left + (aRect.Right - TempRect.Right) div 2 ,(aRect.Bottom - TempRect.Bottom) div 2,aCaption);

    {Draw Borders}
    if ACol = 0 then
    begin
      Canvas.Pen.Color := HeaderOptions.HeaderColor;
      Canvas.MoveTo(ARect.Right,ARect.Top);
      Canvas.LineTo(ARect.Right,ARect.Bottom);

      Canvas.Pen.Color := BorderColor;
      Canvas.MoveTo(0,0);
      Canvas.LineTo(0,ARect.Bottom);
      Canvas.MoveTo(0,ARect.Bottom);
      Canvas.LineTo(ARect.Right,ARect.Bottom);
      Canvas.MoveTo(0,0);
      Canvas.LineTo(ARect.Right,0);
    end else
    if ACol = 6 then
    begin
      Canvas.Pen.Color := HeaderOptions.HeaderColor;
      Canvas.MoveTo(ARect.Left,ARect.Top);
      Canvas.LineTo(ARect.Left,ARect.Bottom);

      Canvas.Pen.Color := BorderColor;
      Canvas.MoveTo(ARect.Left-1,ARect.Bottom+1);
      Canvas.LineTo(ARect.Right,ARect.Bottom+1);
      Canvas.MoveTo(ARect.Left-1,0);
      Canvas.LineTo(ARect.Right,0);
      Canvas.MoveTo(ARect.Right,ARect.Top);
      Canvas.LineTo(ARect.Right,ARect.Bottom);
    end else
    begin
      Canvas.Pen.Color := HeaderOptions.HeaderColor;
      Canvas.MoveTo(ARect.Left,ARect.Top);
      Canvas.LineTo(ARect.Left,ARect.Bottom);
      Canvas.MoveTo(ARect.Right,ARect.Top);
      Canvas.LineTo(ARect.Right,ARect.Bottom);

      Canvas.Pen.Color := BorderColor;
      Canvas.MoveTo(ARect.Left-1,ARect.Bottom+1);
      Canvas.LineTo(ARect.Right+1,ARect.Bottom+1);
      Canvas.MoveTo(ARect.Left-1,0);
      Canvas.LineTo(ARect.Right+1,0);
    end;
  end else
  begin
    { ** Draw Each Day ** }
    if ((SelectedCol = ACol)AND(SelectedRow = ARow)) then
    begin
      if MonthOF(CellDate) = MonthOf(Date) then
        if CellDate <> Date then
          Date := CellDate;
    end;
    Canvas.TextRect(ARect,ARect.Left+1,ARect.Top,IntToStr(DayNum));

    {Draw Border}
    Canvas.Brush.Color := BorderColor;
    InflateRect(ARect,1,1);
    if ACol = 0 then
      ARect.Left := 0;
    Canvas.FrameRect(ARect);
  end;
  {Do After Draw}
  if ARow <> 0 then
  begin
    if not (csDesigning in ComponentState) then
      if IsDoAfterCellDrawStored then
      begin
        TempRect.Left := aRect.Left + 1;
        TempRect.Top := aRect.Top + 1;
        TempRect.Right := aRect.Right - 1;
        TempRect.Bottom := aRect.Bottom - 1;
        FDoAfterCellDraw(Self,ACol,ARow,Canvas,TempRect,aCellState,CellDate);
      end;
  end;
  {END Do After Draw}
end;

procedure TasCalender.IncMonth;
var
  aYear, aMonth, aDay: word;
  MaxDays: Integer;
begin
  DecodeDate(Date,aYear, aMonth, aDay);
  if aMonth < 12 then
    aMonth := aMonth + 1
  else
  begin
    aMonth := 1;
    aYear := aYear + 1;
  end;
  MaxDays := DaysInAMonth(aYear, aMonth);
  if MaxDays < aDay then
    Date := EncodeDate(aYear, aMonth, MaxDays)
  else
    Date := EncodeDate(aYear, aMonth, aDay);
end;

procedure TasCalender.IncYear;
var
  aYear, aMonth, aDay: word;
  MaxDays: Integer;
begin
  DecodeDate(Date,aYear, aMonth, aDay);
  aYear := aYear + 1;
  MaxDays := DaysInAMonth(aYear, aMonth);
  if MaxDays < aDay then
    Date := EncodeDate(aYear, aMonth, MaxDays)
  else
    Date := EncodeDate(aYear, aMonth, aDay);
end;

procedure TasCalender.invalidate;
begin
  inherited;
end;

function TasCalender.IsDoAfterCellDrawStored: Boolean;
begin
  Result := @FDoAfterCellDraw <> nil;
end;

function TasCalender.IsDoBeforeCellDrawStored: Boolean;
begin
  Result := @FDoBeforeCellDraw <> nil;
end;

function TasCalender.IsDoCellClickStored: Boolean;
begin
  Result := @FDoCellClick <> nil;
end;

function TasCalender.IsDoCellMouseDownStored: Boolean;
begin
  Result := @FDoCellMouseDown <> nil;
end;

function TasCalender.IsDoCellMouseUpStored: Boolean;
begin
  Result := @FDoCellMouseUp <> nil;
end;

function TasCalender.IsDoDateChangeStored: Boolean;
begin
  Result := @FDoDateChange <> nil;
end;

function TasCalender.MonthChanged(aDate: TDate): Boolean;
var
  CellDate: TDate;
  DayNum: Integer;
  StartYear, StartMonth, StartDay: Word;
  CurYear, CurMonth, CurDay: Word;
  aYear, aMonth, aDay: Word;
  TestDate: TDate;
  DaysToSkip: Integer;
  SkipCount: Integer;
  I, J: Integer;
begin
  DecodeDate(aDate, aYear, aMonth, aDay);
  DecodeDate(Date, CurYear, CurMonth, CurDay);
  if ((aYear = CurYear)AND(aMonth = CurMonth)) then
  begin
    Result := False;
  end else
  begin
    Result := True;

    TestDate := EncodeDate(aYear,aMonth,1);
    DayNum := DayOfWeek(TestDate);
    if DayNum = 1 then
    begin
      DateofFirstCell := TestDate - 7;
    end else
    begin
      DateofFirstCell := TestDate - (DayNum-1);
    end;

    {Set the Selected Col And Row to the New Col And Row}
    DecodeDate(DateofFirstCell, StartYear, StartMonth, StartDay);
    DaysToSkip := 0;
    if StartMonth <> aMonth then
    begin
      DaysToSkip := DaysToSkip + (DaysInAMonth(StartYear,StartMonth) - StartDay);
    end;
    DaysToSkip := DaysToSkip + aDay;

    SkipCount := 0;
    I := 0;
    J := 1;
    while SkipCount < DaysToSkip do
    begin
      I := I +1;
      if I > 6 then
      begin
        I := 0;
        J := J +1;
      end;

      SkipCount := SkipCount + 1;
    end;
    SelectedCol := I;
    SelectedRow := J;
  end;
end;

procedure TasCalender.ResizeCellHeights;
begin
  RowHeights[1] := CellHeight;
  RowHeights[2] := CellHeight;
  RowHeights[3] := CellHeight;
  RowHeights[4] := CellHeight;
  RowHeights[5] := CellHeight;
  RowHeights[6] := CellHeight;
//  if AutoSizeOptions = asFitWidthToCells then
    DoAutoSize;
end;

procedure TasCalender.ResizeCellWidths;
begin
  ColWidths[0]  := CellWidth;
  ColWidths[1]  := CellWidth;
  ColWidths[2]  := CellWidth;
  ColWidths[3]  := CellWidth;
  ColWidths[4]  := CellWidth;
  ColWidths[5]  := CellWidth;
  ColWidths[6]  := CellWidth;
//  if AutoSizeOptions = asFitWidthToCells then
    DoAutoSize;
end;

procedure TasCalender.ResizeHeaderCells;
begin
  RowHeights[0] := HeaderCellSize;
  DoAutoSize;
end;

function TasCalender.SelectCell(ACol, ARow: Integer): Boolean;
var
  CellDate: TDate;
  DayNum: Integer;
  SelectRowOld, SelectedColOld: Integer;
  aCellRect: TRect;
begin
  Result :=  False;
  if ARow = 0 then Exit;
  { ** Calculate Date of this Cell ** }
  CellDate := DateofFirstCell + 7*(aRow-1)+aCol;
  DayNum := DayOf(CellDate);
  if MonthOF(CellDate) <> MonthOf(Date) then exit;

  SelectRowOld := SelectedRow;
  SelectedColOld := SelectedCol;
  SelectedCol := aCol;
  SelectedRow := aRow;
  {NEW}
  aCellRect.Left := CellWidth * SelectedColOld+SelectedColOld;
  aCellRect.Top := (CellHeight * (SelectRowOld-1))+SelectRowOld+HeaderCellSize;
  aCellRect.Right := aCellRect.Left + CellWidth;
  aCellRect.Bottom := aCellRect.Top + CellHeight;
  DrawCell(SelectedColOld,SelectRowOld,aCellRect,[gdFixed]);
  {END NEW}
  Result :=  True;
  if Assigned(FOnSelectCell) then FOnSelectCell(Self, ACol, ARow, Result);

end;

procedure TasCalender.SetAutoSizeOptions(const Value: TAutoSizeOptions);
begin
  if FAutoSizeOptions <> Value then
  begin
    FAutoSizeOptions := Value;
    DoAutoSize;
  end;
end;

procedure TasCalender.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TasCalender.SetCellColor(const Value: TColor);
begin
  if FCellColor <> Value then
  begin
    FCellColor := Value;
    Invalidate;
  end;
end;

procedure TasCalender.SetCellFont(Value: TFont);
begin
  FCellFont.Assign(Value);
  invalidate;
end;

procedure TasCalender.SetCellHeight(const Value: Integer);
begin
  if FCellHeight <> Value then
  begin
    FCellHeight := Value;
    ResizeCellHeights;
    Invalidate;
  end;
end;

procedure TasCalender.SetCellWidth(const Value: Integer);
begin
  if FCellWidth <> Value then
  begin
    FCellWidth := Value;
    ResizeCellWidths;
    Invalidate;
  end;
end;

procedure TasCalender.SetDate(const Value: TDate);
var
  Changed: Boolean;
begin
  if FDate <> Value then
  begin
    Changed := MonthChanged(Value);
     FDate := Value;
    if Changed then
      Invalidate;
    if IsDoDateChangeStored then
      FDoDateChange(self);
  end;
end;

procedure TasCalender.SetDisabledCellColor(const Value: TColor);
begin
  if FDisabledCellColor <> Value then
  begin
    FDisabledCellColor := Value;
    Invalidate;
  end;
end;

procedure TasCalender.SetDisabledCellFont(Value: TFont);
begin
  FDisabledCellFont.Assign(Value);
  invalidate;
end;

procedure TasCalender.SetHeaderCellSize(const Value: Integer);
begin
  if FHeaderCellSize <> Value then
  begin
    FHeaderCellSize := Value;
    ResizeHeaderCells;
    Invalidate;
  end;
end;

procedure TasCalender.SetHeaderFont(Value: TFont);
begin
  FHeaderFont.Assign(Value);
  invalidate;
end;

procedure TasCalender.SetMonth(NewMonth: Integer);
var
  aYear, aMonth, aDay: word;
  MaxDays: Integer;
begin
  if ( NewMonth < 1 ) OR ( NewMonth > 12) then exit;

  DecodeDate(Date,aYear, aMonth, aDay);

  MaxDays := DaysInAMonth(aYear, NewMonth);
  if MaxDays < aDay then
    Date := EncodeDate(aYear, NewMonth, MaxDays)
  else
    Date := EncodeDate(aYear, NewMonth, aDay);
end;

procedure TasCalender.SetSelectedCellFont(Value: TFont);
begin
  FSelectedCellFont.Assign(Value);
  invalidate;
end;

procedure TasCalender.SetSelectedColor(const Value: TColor);
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;
    Invalidate;
  end;
end;

{ THeaderOptions }

constructor THeaderOptions.Create(AOwner: TasCalender);
begin
  inherited Create;
  FOwner:=AOwner;
end;

procedure THeaderOptions.SetHeaderColor(const Value: TColor);
begin
  if FHeaderColor <> Value then
  begin
    FHeaderColor := Value;
    FOwner.invalidate;
  end;
end;

procedure TasCalender.SetYear(NewYear: Integer);
var
  aYear, aMonth, aDay: word;
  MaxDays: Integer;
begin
  if ( NewYear < 1000 ) then
    NewYear := 2000+NewYear;

  DecodeDate(Date,aYear, aMonth, aDay);

  if IsValidDate(NewYear,aMonth,1) then
  begin
    MaxDays := DaysInAMonth(NewYear, aMonth);
    if MaxDays < aDay then
      Date := EncodeDate(NewYear, aMonth, MaxDays)
    else
      Date := EncodeDate(NewYear, aMonth, aDay);
  end;
end;

procedure TasCalender.WMLBUTTONDOWN(var Message: TWMLBUTTONDOWN);
var
  aRect: TRect;
  isEnabled: Boolean;
  aDate: TDate;
begin
  inherited;
  WasPressed := True;
  MouseToCell(Message.XPos,Message.YPos,ColPressed,RowPressed);
  if (ColPressed <> -1) AND (RowPressed > 0) then
  begin
    isEnabled := CellEnabled(ColPressed,RowPressed);
    aRect := CellRect(ColPressed,RowPressed);
    aDate := DateofFirstCell + 7*(RowPressed-1)+ColPressed;
    if IsDoCellMouseDownStored then
      FDoCellMouseDown(Self, ColPressed, RowPressed, Message.XPos, Message.YPos, Canvas, aRect, aDate, isEnabled);
  end;
end;

procedure TasCalender.WMLBUTTONUP(var Message: TWMLBUTTONUP);
var
  ACol,ARow: Integer;
  aRect: TRect;
  isEnabled: Boolean;
  aDate: TDate;
begin
  inherited;
  WasPressed := False;
  MouseToCell(Message.XPos,Message.YPos,ACol,ARow);
  if (ACol <> -1) AND (ARow > 0) then
  begin
    isEnabled := CellEnabled(ACol,ARow);
    aRect := CellRect(ACol,ARow);
    aDate := DateofFirstCell + 7*(ARow-1)+ACol;
    if (ACol = ColPressed) AND (ARow = RowPressed) then
    begin
      if IsDoCellClickStored then
        FDoCellClick(Self, ACol, ARow, Message.XPos, Message.YPos, Canvas, aRect, aDate, isEnabled);
    end;
    if IsDoCellMouseUpStored then
      FDoCellMouseUp(Self, ACol, ARow, Message.XPos, Message.YPos, Canvas, aRect, aDate, isEnabled);
  end;
end;

procedure TasCalender.WMSize(var Message: TWMSize);
begin
  inherited;
  //if AutoSizeOptions = asFitCellsToWidth then
    DoAutoSize;
end;

end.

