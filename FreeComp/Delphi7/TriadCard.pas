unit TriadCard;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, ExtCtrls;

type
  TDirection = (bdUp,bdDown,bdLeft,bdRight,bdHorzIn,bdHorzOut,bdVertIn,bdVertOut);
  TWayDir = (Horz,Vert);

type
	TTriadCard = class(TCustomPanel)
  protected
    FDir: TDirection;
    FEndColor: TColor;
		FStartColor: TColor;
    procedure Filler(Clr1, Clr2: TColor; Dir: TWayDir; TwoWay: Boolean);
    procedure Paint; override;
    function GetTag: LongInt;
    procedure SetDir(Dir: TDirection);
    procedure SetEndColor(NewColor: TColor);
    procedure SetStartColor(NewColor: TColor);
    procedure SetTag(Value: LongInt);
  private
    BorderColor: TColor;
    FSelected: Boolean;
    FIsPlayer1: Boolean;
    FCardValueRight: Integer;
    FCardValueLeft: Integer;
    FCardValueTop: Integer;
    FCardValueBottom: Integer;
    procedure DrawBorder;
    procedure SelectSelected(const Value: Boolean);
    procedure SetIsPlayer1(const Value: Boolean);
    procedure SetCardValueBottom(const Value: Integer);
    procedure SetCardValueLeft(const Value: Integer);
    procedure SetCardValueRight(const Value: Integer);
    procedure SetCardValueTop(const Value: Integer);
    procedure DrawCardNum(vLeft, vTop, aNum: Integer);
    procedure Draw01(X, Y: Integer; aCanvas: TCanvas);
    procedure Draw02(X, Y: Integer; aCanvas: TCanvas);
    procedure Draw03(X, Y: Integer; aCanvas: TCanvas);
    procedure Draw04(X, Y: Integer; aCanvas: TCanvas);
    procedure Draw05(X, Y: Integer; aCanvas: TCanvas);
    procedure Draw06(X, Y: Integer; aCanvas: TCanvas);
    procedure Draw07(X, Y: Integer; aCanvas: TCanvas);
    procedure Draw08(X, Y: Integer; aCanvas: TCanvas);
    procedure Draw09(X, Y: Integer; aCanvas: TCanvas);
    procedure Draw10(X, Y: Integer; aCanvas: TCanvas);
    procedure PutPixel(X, Y: Integer; aCanvas: TCanvas; aColor: TColor);
  public
    constructor Create(AComponent: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Canvas;
  published
    property IsSelected: Boolean read FSelected write SelectSelected;
    property IsPlayer1: Boolean read FIsPlayer1 write SetIsPlayer1;
    property CardValueTop: Integer read FCardValueTop write SetCardValueTop;
    property CardValueBottom: Integer read FCardValueBottom write SetCardValueBottom;
    property CardValueLeft: Integer read FCardValueLeft write SetCardValueLeft;
    property CardValueRight: Integer read FCardValueRight write SetCardValueRight;
    property Align default alNone;
    property BorderStyle;
    property BorderWidth;
    property Cursor;
    property Direction: TDirection read FDir write SetDir default bdUp;
    property DragCursor;
		property DragMode;
    property Enabled;
    property EndColor: TColor read FEndColor write SetEndColor default clBlack;
		property Height;
    property HelpContext;
    property Hint;
    property Left;
    property Locked;
    property Name;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property StartColor: TColor read FStartColor write SetStartColor default clBlue;
    property TabOrder;
    property TabStop;
    property Top;
    property Tag read GetTag write SetTag;
    property Visible;
    property Width;
    property OnClick;
  end;

var
	MainBackDrop: TTriadCard;

implementation

constructor TTriadCard.Create(AComponent: TComponent);
begin
	inherited Create(AComponent);
	Align := alNone;
	FDir := bdUp;
  IsPlayer1 := True;
  IsSelected := False;
	FEndColor := clNavy;
	FStartColor := clWhite;
  CardValueTop := 4;
  CardValueBottom := 4;
  CardValueLeft := 4;
  CardValueRight := 4;
  Width := 110;
  Height := 140;
  BorderColor := clOlive;
	{ If no other back drop is the main back drop then make this the main back drop }
	if csDesigning in ComponentState then
		if not Assigned(MainBackDrop) then
			Self.Tag := -1;
end;

destructor TTriadCard.Destroy;
begin
	if MainBackDrop = Self then MainBackDrop := Nil;
	inherited Destroy;
end;

procedure TTriadCard.Assign(Source: TPersistent);
var
  SBD: TTriadCard;
begin
  if Source is TTriadCard then begin
    SBD := TTriadCard(Source);
    FDir := SBD.Direction;
    FEndColor := SBD.EndColor;
    FStartColor := SBD.StartColor;
    Align := alNone;
    Invalidate;
//    Repaint;
    Exit;
  end;
  inherited Assign(Source);
end;

function TTriadCard.GetTag: LongInt;
begin
  Result := inherited Tag;
end;

procedure TTriadCard.SetDir(Dir: TDirection);
begin
  if Dir <> FDir then begin
    FDir := Dir;
    Repaint;
  end;
end;

procedure TTriadCard.SetStartColor(NewColor: TColor);
begin
  if NewColor <> FStartColor then begin
    FStartColor := NewColor;
    Repaint;
  end;
end;

procedure TTriadCard.SetEndColor(NewColor: TColor);
begin
  if NewColor <> FEndColor then begin
    FEndColor := NewColor;
    Repaint;
	end;
end;

procedure TTriadCard.SetTag(Value: LongInt);
begin
  if Value <> GetTag then begin
    inherited Tag := Value;
    if Value = -1 then
      begin
        { There should not be two backdrop components as the main back drop }
        if Assigned(MainBackDrop) then MainBackDrop.Tag := 0;
        MainBackDrop := Self;
      end
    else if MainBackDrop = Self then
      MainBackDrop := Nil;
  end;
end;

procedure TTriadCard.Filler(Clr1,Clr2: TColor;Dir: TWayDir;TwoWay: Boolean);
var
  RGBFrom   : array[0..2] of Byte;    { from RGB values                     }
  RGBDiff   : array[0..2] of integer; { difference of from/to RGB values    }
	ColorBand : TRect;                  { color band rectangular coordinates  }
  I         : Integer;                { color band index                    }
  R         : Byte;                   { a color band's R value              }
  G         : Byte;                   { a color band's G value              }
  B         : Byte;                   { a color band's B value              }
  Last      : Integer;                { last value in loop }
begin
  { Extract from RGB values}
  RGBFrom[0] := GetRValue(ColorToRGB(Clr1));
  RGBFrom[1] := GetGValue(ColorToRGB(Clr1));
  RGBFrom[2] := GetBValue(ColorToRGB(Clr1));
  { Calculate difference of from and to RGB values}
  RGBDiff[0] := GetRValue(ColorToRGB(Clr2)) - RGBFrom[0];
  RGBDiff[1] := GetGValue(ColorToRGB(Clr2)) - RGBFrom[1];
  RGBDiff[2] := GetBValue(ColorToRGB(Clr2)) - RGBFrom[2];
  { Set pen sytle and mode}
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Mode := pmCopy;
  { Set color band's left and right coordinates }
  if Dir = Horz then
    begin
      ColorBand.Left := 0;
			ColorBand.Right := Width;
    end
  else
    begin
      ColorBand.Top := 0;
      ColorBand.Bottom := Height;
    end;
  { Set number of iterations to do }
  if TwoWay then
    Last := $7f
  else
    Last := $ff;
  for I := 0 to Last do begin
    { Calculate color band color}
    R := RGBFrom[0] + MulDiv(I,RGBDiff[0],Last);
    G := RGBFrom[1] + MulDiv(I,RGBDiff[1],Last);
    B := RGBFrom[2] + MulDiv(I,RGBDiff[2],Last);
    { Select brush and paint color band }
    Canvas.Brush.Color := RGB(R,G,B);
    if Dir = Horz then
      begin
        { Calculate color band's top and bottom coordinates}
				ColorBand.Top    := MulDiv (I    , Height, $100);
        ColorBand.Bottom := MulDiv (I + 1, Height, $100);
      end
    else
      begin
        { Calculate color band's left and right coordinates}
        ColorBand.Left  := MulDiv (I    , Width, $100);
        ColorBand.Right := MulDiv (I + 1, Width, $100);
      end;
    Canvas.FillRect(ColorBand);
    if TwoWay then begin
      { This is a two way fill, so do the other half }
      if Dir = Horz then
        begin
          { Calculate color band's top and bottom coordinates}
          ColorBand.Top    := MulDiv ($ff - I    , Height, $100);
          ColorBand.Bottom := MulDiv ($ff - I + 1, Height, $100);
        end
      else
        begin
          { Calculate color band's left and right coordinates}
          ColorBand.Left  := MulDiv ($ff - I    , Width, $100);
					ColorBand.Right := MulDiv ($ff - I + 1, Width, $100);
        end;
      Canvas.FillRect(ColorBand);
    end;
  end;
end;

procedure TTriadCard.Paint;
begin
  case FDir of
    bdUp: Filler(FStartColor, FEndColor, Horz, False);
    bdDown: Filler(FEndColor, FStartColor, Horz, False);
    bdLeft: Filler(FStartColor, FEndColor, Vert, False);
    bdRight: Filler(FEndColor, FStartColor, Vert, False);
    bdHorzOut: Filler(FStartColor, FEndColor, Horz, True);
    bdHorzIn: Filler(FEndColor, FStartColor, Horz, True);
    bdVertIn: Filler(FStartColor, FEndColor, Vert, True);
  else
    Filler(FEndColor, FStartColor, Vert, True);
  end;
  DrawBorder;
  DrawCardNum(18,6,CardValueTop);
  DrawCardNum(6,22,CardValueLeft);
  DrawCardNum(30,22,CardValueRight);
  DrawCardNum(18,38,CardValueBottom);
end;

procedure TTriadCard.DrawBorder;
var
  I: Integer;
  aRect: TRect;
begin
  I := 0;
  while I < 5 do
  begin
    if IsSelected then
    begin
      if I = 0 then
        Canvas.Brush.Color := clBlack
      else if I = 1 then
        Canvas.Brush.Color := EndColor
      else if I = 2 then
      begin
        if IsPlayer1 then
          Canvas.Brush.Color := $00FF7173
        else
          Canvas.Brush.Color := $007371FF;
      end else if I = 3 then
      begin
        if IsPlayer1 then
          Canvas.Brush.Color := $00FFC7C7
        else
          Canvas.Brush.Color := $00C7C7FF;
      end else if I = 4 then
        Canvas.Brush.Color := clBlack;
    end else
    begin
      if I = 0 then
        Canvas.Brush.Color := clBlack
      else if I = 1 then
        Canvas.Brush.Color := BorderColor
      else if I = 2 then
        Canvas.Brush.Color := clWhite
      else if I = 3 then
        Canvas.Brush.Color := BorderColor
      else if I = 4 then
        Canvas.Brush.Color := clBlack;
    end;
    {Top}
    aRect.Left := 0+I;
    aRect.Right := Width-I;
    aRect.Top := 0+I;
    aRect.Bottom := 1+I;
    Canvas.FillRect(aRect);
    {Bottom}
    aRect.Left := 0+I;
    aRect.Right := Width-I;
    aRect.Top := Height - (I+1);
    aRect.Bottom := Height- I;
    Canvas.FillRect(aRect);
    {Left}
    aRect.Left := 0+I;
    aRect.Right := 1+I;
    aRect.Top := 1+I;
    aRect.Bottom := Height-(I+1);
    Canvas.FillRect(aRect);
    {Right}
    aRect.Left := Width-(I+1);
    aRect.Right := Width-I;
    aRect.Top := I+1;
    aRect.Bottom := Height-(I+1);
    Canvas.FillRect(aRect);
    I := I + 1;
  end;    // while
end;

procedure TTriadCard.SelectSelected(const Value: Boolean);
begin
  if FSelected <> Value then
  begin
    FSelected := Value;
    Invalidate;
  end;
end;

procedure TTriadCard.SetIsPlayer1(const Value: Boolean);
begin
  if FIsPlayer1 <> Value then
  begin
    FIsPlayer1 := Value;

    if IsPlayer1 then
      EndColor := clNavy
    else
      EndColor := clMaroon;
  end;
end;

procedure TTriadCard.SetCardValueBottom(const Value: Integer);
var
  NewValue: Integer;
begin
  if FCardValueBottom <> Value then
  begin
    NewValue := Value;
    if NewValue > 10 then
      NewValue := 10
    else if NewValue < 1 then
      NewValue := 1;
    FCardValueBottom := NewValue;
    Repaint;
  end;
end;

procedure TTriadCard.SetCardValueLeft(const Value: Integer);
var
  NewValue: Integer;
begin
  if FCardValueLeft <> Value then
  begin
    NewValue := Value;
    if NewValue > 10 then
      NewValue := 10
    else if NewValue < 1 then
      NewValue := 1;
    FCardValueLeft := NewValue;
    Repaint;
  end;
end;

procedure TTriadCard.SetCardValueRight(const Value: Integer);
var
  NewValue: Integer;
begin
  if FCardValueRight <> Value then
  begin
    NewValue := Value;
    if NewValue > 10 then
      NewValue := 10
    else if NewValue < 1 then
      NewValue := 1;
    FCardValueRight := NewValue;
    Repaint;
  end;
end;

procedure TTriadCard.SetCardValueTop(const Value: Integer);
var
  NewValue: Integer;
begin
  if FCardValueTop <> Value then
  begin
    NewValue := Value;
    if NewValue > 10 then
      NewValue := 10
    else if NewValue < 1 then
      NewValue := 1;
    FCardValueTop := NewValue;
    Repaint;
  end;
end;

procedure TTriadCard.DrawCardNum(vLeft, vTop, aNum: Integer);
begin
  if aNum = 1 then
    Draw01(vLeft,vTop,Canvas)
  else if aNum = 2 then
    Draw02(vLeft,vTop,Canvas)
  else if aNum = 3 then
    Draw03(vLeft,vTop,Canvas)
  else if aNum = 4 then
    Draw04(vLeft,vTop,Canvas)
  else if aNum = 5 then
    Draw05(vLeft,vTop,Canvas)
  else if aNum = 6 then
    Draw06(vLeft,vTop,Canvas)
  else if aNum = 7 then
    Draw07(vLeft,vTop,Canvas)
  else if aNum = 8 then
    Draw08(vLeft,vTop,Canvas)
  else if aNum = 9 then
    Draw09(vLeft,vTop,Canvas)
  else if aNum = 10 then
    Draw10(vLeft,vTop,Canvas);
end;

procedure TTriadCard.Draw01(X, Y: Integer; aCanvas: TCanvas);
begin
  PutPixel(X+3, Y+0, aCanvas, clBlack);
  PutPixel(X+4, Y+0, aCanvas, clBlack);
  PutPixel(X+5, Y+0, aCanvas, clBlack);
  PutPixel(X+6, Y+0, aCanvas, clBlack);
  PutPixel(X+7, Y+0, aCanvas, clBlack);
  PutPixel(X+2, Y+1, aCanvas, clBlack);
  PutPixel(X+3, Y+1, aCanvas, $00949A94);
  PutPixel(X+4, Y+1, aCanvas, clWhite);
  PutPixel(X+5, Y+1, aCanvas, clWhite);
  PutPixel(X+6, Y+1, aCanvas, clWhite);
  PutPixel(X+7, Y+1, aCanvas, clBlack);
  PutPixel(X+1, Y+2, aCanvas, clBlack);
  PutPixel(X+2, Y+2, aCanvas, $00949A94);
  PutPixel(X+3, Y+2, aCanvas, clWhite);
  PutPixel(X+4, Y+2, aCanvas, clWhite);
  PutPixel(X+5, Y+2, aCanvas, clWhite);
  PutPixel(X+6, Y+2, aCanvas, clWhite);
  PutPixel(X+7, Y+2, aCanvas, clBlack);
  PutPixel(X+0, Y+3, aCanvas, clBlack);
  PutPixel(X+1, Y+3, aCanvas, $00949A94);
  PutPixel(X+2, Y+3, aCanvas, clWhite);
  PutPixel(X+3, Y+3, aCanvas, clWhite);
  PutPixel(X+4, Y+3, aCanvas, clWhite);
  PutPixel(X+5, Y+3, aCanvas, clWhite);
  PutPixel(X+6, Y+3, aCanvas, clWhite);
  PutPixel(X+7, Y+3, aCanvas, clBlack);
  PutPixel(X+0, Y+4, aCanvas, clBlack);
  PutPixel(X+1, Y+4, aCanvas, clWhite);
  PutPixel(X+2, Y+4, aCanvas, clWhite);
  PutPixel(X+3, Y+4, aCanvas, clWhite);
  PutPixel(X+4, Y+4, aCanvas, clWhite);
  PutPixel(X+5, Y+4, aCanvas, clWhite);
  PutPixel(X+6, Y+4, aCanvas, clWhite);
  PutPixel(X+7, Y+4, aCanvas, clBlack);
  PutPixel(X+0, Y+5, aCanvas, clBlack);
  PutPixel(X+1, Y+5, aCanvas, clBlack);
  PutPixel(X+2, Y+5, aCanvas, clBlack);
  PutPixel(X+3, Y+5, aCanvas, clBlack);
  PutPixel(X+4, Y+5, aCanvas, clWhite);
  PutPixel(X+5, Y+5, aCanvas, clWhite);
  PutPixel(X+6, Y+5, aCanvas, clWhite);
  PutPixel(X+7, Y+5, aCanvas, clBlack);
  PutPixel(X+3, Y+6, aCanvas, clBlack);
  PutPixel(X+4, Y+6, aCanvas, clWhite);
  PutPixel(X+5, Y+6, aCanvas, clWhite);
  PutPixel(X+6, Y+6, aCanvas, clWhite);
  PutPixel(X+7, Y+6, aCanvas, clBlack);
  PutPixel(X+3, Y+7, aCanvas, clBlack);
  PutPixel(X+4, Y+7, aCanvas, clWhite);
  PutPixel(X+5, Y+7, aCanvas, clWhite);
  PutPixel(X+6, Y+7, aCanvas, clWhite);
  PutPixel(X+7, Y+7, aCanvas, clBlack);
  PutPixel(X+3, Y+8, aCanvas, clBlack);
  PutPixel(X+4, Y+8, aCanvas, clWhite);
  PutPixel(X+5, Y+8, aCanvas, clWhite);
  PutPixel(X+6, Y+8, aCanvas, clWhite);
  PutPixel(X+7, Y+8, aCanvas, clBlack);
  PutPixel(X+3, Y+9, aCanvas, clBlack);
  PutPixel(X+4, Y+9, aCanvas, clWhite);
  PutPixel(X+5, Y+9, aCanvas, clWhite);
  PutPixel(X+6, Y+9, aCanvas, clWhite);
  PutPixel(X+7, Y+9, aCanvas, clBlack);
  PutPixel(X+3, Y+10, aCanvas, clBlack);
  PutPixel(X+4, Y+10, aCanvas, clWhite);
  PutPixel(X+5, Y+10, aCanvas, clWhite);
  PutPixel(X+6, Y+10, aCanvas, clWhite);
  PutPixel(X+7, Y+10, aCanvas, clBlack);
  PutPixel(X+3, Y+11, aCanvas, clBlack);
  PutPixel(X+4, Y+11, aCanvas, clWhite);
  PutPixel(X+5, Y+11, aCanvas, clWhite);
  PutPixel(X+6, Y+11, aCanvas, clWhite);
  PutPixel(X+7, Y+11, aCanvas, clBlack);
  PutPixel(X+0, Y+12, aCanvas, clBlack);
  PutPixel(X+1, Y+12, aCanvas, clBlack);
  PutPixel(X+2, Y+12, aCanvas, clBlack);
  PutPixel(X+3, Y+12, aCanvas, clBlack);
  PutPixel(X+4, Y+12, aCanvas, clWhite);
  PutPixel(X+5, Y+12, aCanvas, clWhite);
  PutPixel(X+6, Y+12, aCanvas, clWhite);
  PutPixel(X+7, Y+12, aCanvas, clBlack);
  PutPixel(X+8, Y+12, aCanvas, clBlack);
  PutPixel(X+9, Y+12, aCanvas, clBlack);
  PutPixel(X+10, Y+12, aCanvas, clBlack);
  PutPixel(X+0, Y+13, aCanvas, clBlack);
  PutPixel(X+1, Y+13, aCanvas, clWhite);
  PutPixel(X+2, Y+13, aCanvas, clWhite);
  PutPixel(X+3, Y+13, aCanvas, clWhite);
  PutPixel(X+4, Y+13, aCanvas, clWhite);
  PutPixel(X+5, Y+13, aCanvas, clWhite);
  PutPixel(X+6, Y+13, aCanvas, clWhite);
  PutPixel(X+7, Y+13, aCanvas, clWhite);
  PutPixel(X+8, Y+13, aCanvas, clWhite);
  PutPixel(X+9, Y+13, aCanvas, clWhite);
  PutPixel(X+10, Y+13, aCanvas, clBlack);
  PutPixel(X+0, Y+14, aCanvas, clBlack);
  PutPixel(X+1, Y+14, aCanvas, clWhite);
  PutPixel(X+2, Y+14, aCanvas, clWhite);
  PutPixel(X+3, Y+14, aCanvas, clWhite);
  PutPixel(X+4, Y+14, aCanvas, clWhite);
  PutPixel(X+5, Y+14, aCanvas, clWhite);
  PutPixel(X+6, Y+14, aCanvas, clWhite);
  PutPixel(X+7, Y+14, aCanvas, clWhite);
  PutPixel(X+8, Y+14, aCanvas, clWhite);
  PutPixel(X+9, Y+14, aCanvas, clWhite);
  PutPixel(X+10, Y+14, aCanvas, clBlack);
  PutPixel(X+0, Y+15, aCanvas, clBlack);
  PutPixel(X+1, Y+15, aCanvas, clBlack);
  PutPixel(X+2, Y+15, aCanvas, clBlack);
  PutPixel(X+3, Y+15, aCanvas, clBlack);
  PutPixel(X+4, Y+15, aCanvas, clBlack);
  PutPixel(X+5, Y+15, aCanvas, clBlack);
  PutPixel(X+6, Y+15, aCanvas, clBlack);
  PutPixel(X+7, Y+15, aCanvas, clBlack);
  PutPixel(X+8, Y+15, aCanvas, clBlack);
  PutPixel(X+9, Y+15, aCanvas, clBlack);
  PutPixel(X+10, Y+15, aCanvas, clBlack);
end;

procedure TTriadCard.Draw02(X, Y: Integer; aCanvas: TCanvas);
begin
  PutPixel(X+2, Y+0, aCanvas, clBlack);
  PutPixel(X+3, Y+0, aCanvas, clBlack);
  PutPixel(X+4, Y+0, aCanvas, clBlack);
  PutPixel(X+5, Y+0, aCanvas, clBlack);
  PutPixel(X+6, Y+0, aCanvas, clBlack);
  PutPixel(X+7, Y+0, aCanvas, clBlack);
  PutPixel(X+8, Y+0, aCanvas, clBlack);
  PutPixel(X+9, Y+0, aCanvas, clBlack);
  PutPixel(X+1, Y+1, aCanvas, clBlack);
  PutPixel(X+2, Y+1, aCanvas, $00949A94);
  PutPixel(X+3, Y+1, aCanvas, clWhite);
  PutPixel(X+4, Y+1, aCanvas, clWhite);
  PutPixel(X+5, Y+1, aCanvas, clWhite);
  PutPixel(X+6, Y+1, aCanvas, clWhite);
  PutPixel(X+7, Y+1, aCanvas, clWhite);
  PutPixel(X+8, Y+1, aCanvas, clWhite);
  PutPixel(X+9, Y+1, aCanvas, $00949A94);
  PutPixel(X+10, Y+1, aCanvas, clBlack);
  PutPixel(X+0, Y+2, aCanvas, clBlack);
  PutPixel(X+1, Y+2, aCanvas, $00949A94);
  PutPixel(X+2, Y+2, aCanvas, clWhite);
  PutPixel(X+3, Y+2, aCanvas, clWhite);
  PutPixel(X+4, Y+2, aCanvas, clWhite);
  PutPixel(X+5, Y+2, aCanvas, clWhite);
  PutPixel(X+6, Y+2, aCanvas, clWhite);
  PutPixel(X+7, Y+2, aCanvas, clWhite);
  PutPixel(X+8, Y+2, aCanvas, clWhite);
  PutPixel(X+9, Y+2, aCanvas, clWhite);
  PutPixel(X+10, Y+2, aCanvas, $00949A94);
  PutPixel(X+11, Y+2, aCanvas, clBlack);
  PutPixel(X+0, Y+3, aCanvas, clBlack);
  PutPixel(X+1, Y+3, aCanvas, clWhite);
  PutPixel(X+2, Y+3, aCanvas, clWhite);
  PutPixel(X+3, Y+3, aCanvas, $00949A94);
  PutPixel(X+4, Y+3, aCanvas, clBlack);
  PutPixel(X+5, Y+3, aCanvas, clBlack);
  PutPixel(X+6, Y+3, aCanvas, clBlack);
  PutPixel(X+7, Y+3, aCanvas, $00949A94);
  PutPixel(X+8, Y+3, aCanvas, clWhite);
  PutPixel(X+9, Y+3, aCanvas, clWhite);
  PutPixel(X+10, Y+3, aCanvas, clWhite);
  PutPixel(X+11, Y+3, aCanvas, $00101410);
  PutPixel(X+0, Y+4, aCanvas, clBlack);
  PutPixel(X+1, Y+4, aCanvas, clWhite);
  PutPixel(X+2, Y+4, aCanvas, clWhite);
  PutPixel(X+3, Y+4, aCanvas, clBlack);
  PutPixel(X+7, Y+4, aCanvas, clBlack);
  PutPixel(X+8, Y+4, aCanvas, clWhite);
  PutPixel(X+9, Y+4, aCanvas, clWhite);
  PutPixel(X+10, Y+4, aCanvas, clWhite);
  PutPixel(X+11, Y+4, aCanvas, clBlack);
  PutPixel(X+0, Y+5, aCanvas, clBlack);
  PutPixel(X+1, Y+5, aCanvas, clBlack);
  PutPixel(X+2, Y+5, aCanvas, clBlack);
  PutPixel(X+3, Y+5, aCanvas, clBlack);
  PutPixel(X+7, Y+5, aCanvas, clBlack);
  PutPixel(X+8, Y+5, aCanvas, clWhite);
  PutPixel(X+9, Y+5, aCanvas, clWhite);
  PutPixel(X+10, Y+5, aCanvas, clWhite);
  PutPixel(X+11, Y+5, aCanvas, $00101410);
  PutPixel(X+7, Y+6, aCanvas, clBlack);
  PutPixel(X+8, Y+6, aCanvas, clWhite);
  PutPixel(X+9, Y+6, aCanvas, clWhite);
  PutPixel(X+10, Y+6, aCanvas, clWhite);
  PutPixel(X+11, Y+6, aCanvas, clBlack);
  PutPixel(X+6, Y+7, aCanvas, clBlack);
  PutPixel(X+7, Y+7, aCanvas, $00949A94);
  PutPixel(X+8, Y+7, aCanvas, clWhite);
  PutPixel(X+9, Y+7, aCanvas, clWhite);
  PutPixel(X+10, Y+7, aCanvas, $00949A94);
  PutPixel(X+11, Y+7, aCanvas, $00101410);
  PutPixel(X+5, Y+8, aCanvas, clBlack);
  PutPixel(X+6, Y+8, aCanvas, $00949A94);
  PutPixel(X+7, Y+8, aCanvas, clWhite);
  PutPixel(X+8, Y+8, aCanvas, clWhite);
  PutPixel(X+9, Y+8, aCanvas, clWhite);
  PutPixel(X+10, Y+8, aCanvas, $00101410);
  PutPixel(X+4, Y+9, aCanvas, clBlack);
  PutPixel(X+5, Y+9, aCanvas, $00949A94);
  PutPixel(X+6, Y+9, aCanvas, clWhite);
  PutPixel(X+7, Y+9, aCanvas, clWhite);
  PutPixel(X+8, Y+9, aCanvas, clWhite);
  PutPixel(X+9, Y+9, aCanvas, $00949A94);
  PutPixel(X+10, Y+9, aCanvas, $00101410);
  PutPixel(X+3, Y+10, aCanvas, clBlack);
  PutPixel(X+4, Y+10, aCanvas, $00949A94);
  PutPixel(X+5, Y+10, aCanvas, clWhite);
  PutPixel(X+6, Y+10, aCanvas, clWhite);
  PutPixel(X+7, Y+10, aCanvas, clWhite);
  PutPixel(X+8, Y+10, aCanvas, $00949A94);
  PutPixel(X+9, Y+10, aCanvas, clBlack);
  PutPixel(X+2, Y+11, aCanvas, clBlack);
  PutPixel(X+3, Y+11, aCanvas, $00949A94);
  PutPixel(X+4, Y+11, aCanvas, clWhite);
  PutPixel(X+5, Y+11, aCanvas, clWhite);
  PutPixel(X+6, Y+11, aCanvas, clWhite);
  PutPixel(X+7, Y+11, aCanvas, $00949A94);
  PutPixel(X+8, Y+11, aCanvas, clBlack);
  PutPixel(X+1, Y+12, aCanvas, clBlack);
  PutPixel(X+2, Y+12, aCanvas, $00949A94);
  PutPixel(X+3, Y+12, aCanvas, clWhite);
  PutPixel(X+4, Y+12, aCanvas, clWhite);
  PutPixel(X+5, Y+12, aCanvas, clWhite);
  PutPixel(X+6, Y+12, aCanvas, $00949A94);
  PutPixel(X+7, Y+12, aCanvas, clBlack);
  PutPixel(X+8, Y+12, aCanvas, clBlack);
  PutPixel(X+9, Y+12, aCanvas, clBlack);
  PutPixel(X+10, Y+12, aCanvas, clBlack);
  PutPixel(X+11, Y+12, aCanvas, clBlack);
  PutPixel(X+12, Y+12, aCanvas, clBlack);
  PutPixel(X+0, Y+13, aCanvas, clBlack);
  PutPixel(X+1, Y+13, aCanvas, $00949A94);
  PutPixel(X+2, Y+13, aCanvas, clWhite);
  PutPixel(X+3, Y+13, aCanvas, clWhite);
  PutPixel(X+4, Y+13, aCanvas, clWhite);
  PutPixel(X+5, Y+13, aCanvas, clWhite);
  PutPixel(X+6, Y+13, aCanvas, clWhite);
  PutPixel(X+7, Y+13, aCanvas, clWhite);
  PutPixel(X+8, Y+13, aCanvas, clWhite);
  PutPixel(X+9, Y+13, aCanvas, clWhite);
  PutPixel(X+10, Y+13, aCanvas, clWhite);
  PutPixel(X+11, Y+13, aCanvas, clWhite);
  PutPixel(X+12, Y+13, aCanvas, clBlack);
  PutPixel(X+0, Y+14, aCanvas, clBlack);
  PutPixel(X+1, Y+14, aCanvas, clWhite);
  PutPixel(X+2, Y+14, aCanvas, clWhite);
  PutPixel(X+3, Y+14, aCanvas, clWhite);
  PutPixel(X+4, Y+14, aCanvas, clWhite);
  PutPixel(X+5, Y+14, aCanvas, clWhite);
  PutPixel(X+6, Y+14, aCanvas, clWhite);
  PutPixel(X+7, Y+14, aCanvas, clWhite);
  PutPixel(X+8, Y+14, aCanvas, clWhite);
  PutPixel(X+9, Y+14, aCanvas, clWhite);
  PutPixel(X+10, Y+14, aCanvas, clWhite);
  PutPixel(X+11, Y+14, aCanvas, clWhite);
  PutPixel(X+12, Y+14, aCanvas, clBlack);
  PutPixel(X+0, Y+15, aCanvas, clBlack);
  PutPixel(X+1, Y+15, aCanvas, clBlack);
  PutPixel(X+2, Y+15, aCanvas, clBlack);
  PutPixel(X+3, Y+15, aCanvas, clBlack);
  PutPixel(X+4, Y+15, aCanvas, clBlack);
  PutPixel(X+5, Y+15, aCanvas, clBlack);
  PutPixel(X+6, Y+15, aCanvas, clBlack);
  PutPixel(X+7, Y+15, aCanvas, clBlack);
  PutPixel(X+8, Y+15, aCanvas, clBlack);
  PutPixel(X+9, Y+15, aCanvas, clBlack);
  PutPixel(X+10, Y+15, aCanvas, clBlack);
  PutPixel(X+11, Y+15, aCanvas, clBlack);
  PutPixel(X+12, Y+15, aCanvas, clBlack);
end;

procedure TTriadCard.Draw03(X, Y: Integer; aCanvas: TCanvas);
begin
  PutPixel(X+2, Y+0, aCanvas, clBlack);
  PutPixel(X+3, Y+0, aCanvas, clBlack);
  PutPixel(X+4, Y+0, aCanvas, clBlack);
  PutPixel(X+5, Y+0, aCanvas, clBlack);
  PutPixel(X+6, Y+0, aCanvas, clBlack);
  PutPixel(X+7, Y+0, aCanvas, clBlack);
  PutPixel(X+8, Y+0, aCanvas, clBlack);
  PutPixel(X+9, Y+0, aCanvas, clBlack);
  PutPixel(X+1, Y+1, aCanvas, clBlack);
  PutPixel(X+2, Y+1, aCanvas, $00949A94);
  PutPixel(X+3, Y+1, aCanvas, clWhite);
  PutPixel(X+4, Y+1, aCanvas, clWhite);
  PutPixel(X+5, Y+1, aCanvas, clWhite);
  PutPixel(X+6, Y+1, aCanvas, clWhite);
  PutPixel(X+7, Y+1, aCanvas, clWhite);
  PutPixel(X+8, Y+1, aCanvas, clWhite);
  PutPixel(X+9, Y+1, aCanvas, $00949A94);
  PutPixel(X+10, Y+1, aCanvas, clBlack);
  PutPixel(X+1, Y+2, aCanvas, clBlack);
  PutPixel(X+2, Y+2, aCanvas, clWhite);
  PutPixel(X+3, Y+2, aCanvas, clWhite);
  PutPixel(X+4, Y+2, aCanvas, clWhite);
  PutPixel(X+5, Y+2, aCanvas, clWhite);
  PutPixel(X+6, Y+2, aCanvas, clWhite);
  PutPixel(X+7, Y+2, aCanvas, clWhite);
  PutPixel(X+8, Y+2, aCanvas, clWhite);
  PutPixel(X+9, Y+2, aCanvas, clWhite);
  PutPixel(X+10, Y+2, aCanvas, $00949A94);
  PutPixel(X+11, Y+2, aCanvas, clBlack);
  PutPixel(X+1, Y+3, aCanvas, clBlack);
  PutPixel(X+2, Y+3, aCanvas, clBlack);
  PutPixel(X+3, Y+3, aCanvas, clBlack);
  PutPixel(X+4, Y+3, aCanvas, clBlack);
  PutPixel(X+5, Y+3, aCanvas, clBlack);
  PutPixel(X+6, Y+3, aCanvas, clBlack);
  PutPixel(X+7, Y+3, aCanvas, $00949A94);
  PutPixel(X+8, Y+3, aCanvas, clWhite);
  PutPixel(X+9, Y+3, aCanvas, clWhite);
  PutPixel(X+10, Y+3, aCanvas, $00F7F7F7);
  PutPixel(X+11, Y+3, aCanvas, clBlack);
  PutPixel(X+7, Y+4, aCanvas, clBlack);
  PutPixel(X+8, Y+4, aCanvas, clWhite);
  PutPixel(X+9, Y+4, aCanvas, clWhite);
  PutPixel(X+10, Y+4, aCanvas, $00F7F7F7);
  PutPixel(X+11, Y+4, aCanvas, clBlack);
  PutPixel(X+3, Y+5, aCanvas, clBlack);
  PutPixel(X+4, Y+5, aCanvas, clBlack);
  PutPixel(X+5, Y+5, aCanvas, clBlack);
  PutPixel(X+6, Y+5, aCanvas, clBlack);
  PutPixel(X+7, Y+5, aCanvas, clBlack);
  PutPixel(X+8, Y+5, aCanvas, clWhite);
  PutPixel(X+9, Y+5, aCanvas, clWhite);
  PutPixel(X+10, Y+5, aCanvas, $00949A94);
  PutPixel(X+11, Y+5, aCanvas, clBlack);
  PutPixel(X+3, Y+6, aCanvas, clBlack);
  PutPixel(X+4, Y+6, aCanvas, clWhite);
  PutPixel(X+5, Y+6, aCanvas, clWhite);
  PutPixel(X+6, Y+6, aCanvas, clWhite);
  PutPixel(X+7, Y+6, aCanvas, clWhite);
  PutPixel(X+8, Y+6, aCanvas, clWhite);
  PutPixel(X+9, Y+6, aCanvas, clWhite);
  PutPixel(X+10, Y+6, aCanvas, clBlack);
  PutPixel(X+3, Y+7, aCanvas, clBlack);
  PutPixel(X+4, Y+7, aCanvas, clWhite);
  PutPixel(X+5, Y+7, aCanvas, clWhite);
  PutPixel(X+6, Y+7, aCanvas, clWhite);
  PutPixel(X+7, Y+7, aCanvas, clWhite);
  PutPixel(X+8, Y+7, aCanvas, clWhite);
  PutPixel(X+9, Y+7, aCanvas, clWhite);
  PutPixel(X+10, Y+7, aCanvas, clBlack);
  PutPixel(X+3, Y+8, aCanvas, clBlack);
  PutPixel(X+4, Y+8, aCanvas, clBlack);
  PutPixel(X+5, Y+8, aCanvas, clBlack);
  PutPixel(X+6, Y+8, aCanvas, clBlack);
  PutPixel(X+7, Y+8, aCanvas, $00949A94);
  PutPixel(X+8, Y+8, aCanvas, clWhite);
  PutPixel(X+9, Y+8, aCanvas, clWhite);
  PutPixel(X+10, Y+8, aCanvas, $00949A94);
  PutPixel(X+11, Y+8, aCanvas, clBlack);
  PutPixel(X+7, Y+9, aCanvas, clBlack);
  PutPixel(X+8, Y+9, aCanvas, clWhite);
  PutPixel(X+9, Y+9, aCanvas, clWhite);
  PutPixel(X+10, Y+9, aCanvas, clWhite);
  PutPixel(X+11, Y+9, aCanvas, clBlack);
  PutPixel(X+0, Y+10, aCanvas, clBlack);
  PutPixel(X+1, Y+10, aCanvas, clBlack);
  PutPixel(X+2, Y+10, aCanvas, clBlack);
  PutPixel(X+3, Y+10, aCanvas, clBlack);
  PutPixel(X+7, Y+10, aCanvas, clBlack);
  PutPixel(X+8, Y+10, aCanvas, clWhite);
  PutPixel(X+9, Y+10, aCanvas, clWhite);
  PutPixel(X+10, Y+10, aCanvas, clWhite);
  PutPixel(X+11, Y+10, aCanvas, clBlack);
  PutPixel(X+0, Y+11, aCanvas, clBlack);
  PutPixel(X+1, Y+11, aCanvas, clWhite);
  PutPixel(X+2, Y+11, aCanvas, clWhite);
  PutPixel(X+3, Y+11, aCanvas, clBlack);
  PutPixel(X+6, Y+11, aCanvas, clBlack);
  PutPixel(X+7, Y+11, aCanvas, $00949A94);
  PutPixel(X+8, Y+11, aCanvas, clWhite);
  PutPixel(X+9, Y+11, aCanvas, clWhite);
  PutPixel(X+10, Y+11, aCanvas, clWhite);
  PutPixel(X+11, Y+11, aCanvas, clBlack);
  PutPixel(X+0, Y+12, aCanvas, clBlack);
  PutPixel(X+1, Y+12, aCanvas, clWhite);
  PutPixel(X+2, Y+12, aCanvas, clWhite);
  PutPixel(X+3, Y+12, aCanvas, $00949A94);
  PutPixel(X+4, Y+12, aCanvas, clBlack);
  PutPixel(X+5, Y+12, aCanvas, clBlack);
  PutPixel(X+6, Y+12, aCanvas, $00949A94);
  PutPixel(X+7, Y+12, aCanvas, clWhite);
  PutPixel(X+8, Y+12, aCanvas, clWhite);
  PutPixel(X+9, Y+12, aCanvas, clWhite);
  PutPixel(X+10, Y+12, aCanvas, $00949A94);
  PutPixel(X+11, Y+12, aCanvas, clBlack);
  PutPixel(X+0, Y+13, aCanvas, clBlack);
  PutPixel(X+1, Y+13, aCanvas, $00949A94);
  PutPixel(X+2, Y+13, aCanvas, clWhite);
  PutPixel(X+3, Y+13, aCanvas, clWhite);
  PutPixel(X+4, Y+13, aCanvas, clWhite);
  PutPixel(X+5, Y+13, aCanvas, clWhite);
  PutPixel(X+6, Y+13, aCanvas, clWhite);
  PutPixel(X+7, Y+13, aCanvas, clWhite);
  PutPixel(X+8, Y+13, aCanvas, clWhite);
  PutPixel(X+9, Y+13, aCanvas, $00949A94);
  PutPixel(X+10, Y+13, aCanvas, clBlack);
  PutPixel(X+1, Y+14, aCanvas, clBlack);
  PutPixel(X+2, Y+14, aCanvas, $00949A94);
  PutPixel(X+3, Y+14, aCanvas, clWhite);
  PutPixel(X+4, Y+14, aCanvas, clWhite);
  PutPixel(X+5, Y+14, aCanvas, clWhite);
  PutPixel(X+6, Y+14, aCanvas, clWhite);
  PutPixel(X+7, Y+14, aCanvas, clWhite);
  PutPixel(X+8, Y+14, aCanvas, $00949A94);
  PutPixel(X+9, Y+14, aCanvas, clBlack);
  PutPixel(X+2, Y+15, aCanvas, clBlack);
  PutPixel(X+3, Y+15, aCanvas, clBlack);
  PutPixel(X+4, Y+15, aCanvas, clBlack);
  PutPixel(X+5, Y+15, aCanvas, clBlack);
  PutPixel(X+6, Y+15, aCanvas, clBlack);
  PutPixel(X+7, Y+15, aCanvas, clBlack);
  PutPixel(X+8, Y+15, aCanvas, clBlack);
end;

procedure TTriadCard.Draw04(X, Y: Integer; aCanvas: TCanvas);
begin
  PutPixel(X+5, Y+0, aCanvas, clBlack);
  PutPixel(X+6, Y+0, aCanvas, clBlack);
  PutPixel(X+7, Y+0, aCanvas, clBlack);
  PutPixel(X+8, Y+0, aCanvas, clBlack);
  PutPixel(X+9, Y+0, aCanvas, clBlack);
  PutPixel(X+10, Y+0, aCanvas, clBlack);
  PutPixel(X+5, Y+1, aCanvas, clBlack);
  PutPixel(X+6, Y+1, aCanvas, clWhite);
  PutPixel(X+7, Y+1, aCanvas, clWhite);
  PutPixel(X+8, Y+1, aCanvas, clWhite);
  PutPixel(X+9, Y+1, aCanvas, clWhite);
  PutPixel(X+10, Y+1, aCanvas, clBlack);
  PutPixel(X+4, Y+2, aCanvas, clBlack);
  PutPixel(X+5, Y+2, aCanvas, $00949A94);
  PutPixel(X+6, Y+2, aCanvas, clWhite);
  PutPixel(X+7, Y+2, aCanvas, clWhite);
  PutPixel(X+8, Y+2, aCanvas, clWhite);
  PutPixel(X+9, Y+2, aCanvas, clWhite);
  PutPixel(X+10, Y+2, aCanvas, clBlack);
  PutPixel(X+4, Y+3, aCanvas, clBlack);
  PutPixel(X+5, Y+3, aCanvas, clWhite);
  PutPixel(X+6, Y+3, aCanvas, clWhite);
  PutPixel(X+7, Y+3, aCanvas, clWhite);
  PutPixel(X+8, Y+3, aCanvas, clWhite);
  PutPixel(X+9, Y+3, aCanvas, clWhite);
  PutPixel(X+10, Y+3, aCanvas, clBlack);
  PutPixel(X+3, Y+4, aCanvas, clBlack);
  PutPixel(X+4, Y+4, aCanvas, $00949A94);
  PutPixel(X+5, Y+4, aCanvas, clWhite);
  PutPixel(X+6, Y+4, aCanvas, clWhite);
  PutPixel(X+7, Y+4, aCanvas, clWhite);
  PutPixel(X+8, Y+4, aCanvas, clWhite);
  PutPixel(X+9, Y+4, aCanvas, clWhite);
  PutPixel(X+10, Y+4, aCanvas, clBlack);
  PutPixel(X+3, Y+5, aCanvas, clBlack);
  PutPixel(X+4, Y+5, aCanvas, clWhite);
  PutPixel(X+5, Y+5, aCanvas, clWhite);
  PutPixel(X+6, Y+5, aCanvas, clBlack);
  PutPixel(X+7, Y+5, aCanvas, clWhite);
  PutPixel(X+8, Y+5, aCanvas, clWhite);
  PutPixel(X+9, Y+5, aCanvas, clWhite);
  PutPixel(X+10, Y+5, aCanvas, clBlack);
  PutPixel(X+2, Y+6, aCanvas, clBlack);
  PutPixel(X+3, Y+6, aCanvas, $00949A94);
  PutPixel(X+4, Y+6, aCanvas, clWhite);
  PutPixel(X+5, Y+6, aCanvas, $00949A94);
  PutPixel(X+6, Y+6, aCanvas, clBlack);
  PutPixel(X+7, Y+6, aCanvas, clWhite);
  PutPixel(X+8, Y+6, aCanvas, clWhite);
  PutPixel(X+9, Y+6, aCanvas, clWhite);
  PutPixel(X+10, Y+6, aCanvas, clBlack);
  PutPixel(X+2, Y+7, aCanvas, clBlack);
  PutPixel(X+3, Y+7, aCanvas, clWhite);
  PutPixel(X+4, Y+7, aCanvas, clWhite);
  PutPixel(X+5, Y+7, aCanvas, clBlack);
  PutPixel(X+6, Y+7, aCanvas, clBlack);
  PutPixel(X+7, Y+7, aCanvas, clWhite);
  PutPixel(X+8, Y+7, aCanvas, clWhite);
  PutPixel(X+9, Y+7, aCanvas, clWhite);
  PutPixel(X+10, Y+7, aCanvas, clBlack);
  PutPixel(X+1, Y+8, aCanvas, clBlack);
  PutPixel(X+2, Y+8, aCanvas, $00949A94);
  PutPixel(X+3, Y+8, aCanvas, clWhite);
  PutPixel(X+4, Y+8, aCanvas, $00949A94);
  PutPixel(X+5, Y+8, aCanvas, clBlack);
  PutPixel(X+6, Y+8, aCanvas, clBlack);
  PutPixel(X+7, Y+8, aCanvas, clWhite);
  PutPixel(X+8, Y+8, aCanvas, clWhite);
  PutPixel(X+9, Y+8, aCanvas, clWhite);
  PutPixel(X+10, Y+8, aCanvas, clBlack);
  PutPixel(X+1, Y+9, aCanvas, clBlack);
  PutPixel(X+2, Y+9, aCanvas, clWhite);
  PutPixel(X+3, Y+9, aCanvas, clWhite);
  PutPixel(X+4, Y+9, aCanvas, clBlack);
  PutPixel(X+5, Y+9, aCanvas, clBlack);
  PutPixel(X+6, Y+9, aCanvas, clBlack);
  PutPixel(X+7, Y+9, aCanvas, clWhite);
  PutPixel(X+8, Y+9, aCanvas, clWhite);
  PutPixel(X+9, Y+9, aCanvas, clWhite);
  PutPixel(X+10, Y+9, aCanvas, clBlack);
  PutPixel(X+11, Y+9, aCanvas, clBlack);
  PutPixel(X+12, Y+9, aCanvas, clBlack);
  PutPixel(X+0, Y+10, aCanvas, clBlack);
  PutPixel(X+1, Y+10, aCanvas, $00949A94);
  PutPixel(X+2, Y+10, aCanvas, clWhite);
  PutPixel(X+3, Y+10, aCanvas, clWhite);
  PutPixel(X+4, Y+10, aCanvas, clWhite);
  PutPixel(X+5, Y+10, aCanvas, clWhite);
  PutPixel(X+6, Y+10, aCanvas, clWhite);
  PutPixel(X+7, Y+10, aCanvas, clWhite);
  PutPixel(X+8, Y+10, aCanvas, clWhite);
  PutPixel(X+9, Y+10, aCanvas, clWhite);
  PutPixel(X+10, Y+10, aCanvas, clWhite);
  PutPixel(X+11, Y+10, aCanvas, clWhite);
  PutPixel(X+12, Y+10, aCanvas, clBlack);
  PutPixel(X+0, Y+11, aCanvas, clBlack);
  PutPixel(X+1, Y+11, aCanvas, clWhite);
  PutPixel(X+2, Y+11, aCanvas, clWhite);
  PutPixel(X+3, Y+11, aCanvas, clWhite);
  PutPixel(X+4, Y+11, aCanvas, clWhite);
  PutPixel(X+5, Y+11, aCanvas, clWhite);
  PutPixel(X+6, Y+11, aCanvas, clWhite);
  PutPixel(X+7, Y+11, aCanvas, clWhite);
  PutPixel(X+8, Y+11, aCanvas, clWhite);
  PutPixel(X+9, Y+11, aCanvas, clWhite);
  PutPixel(X+10, Y+11, aCanvas, clWhite);
  PutPixel(X+11, Y+11, aCanvas, clWhite);
  PutPixel(X+12, Y+11, aCanvas, clBlack);
  PutPixel(X+0, Y+12, aCanvas, clBlack);
  PutPixel(X+1, Y+12, aCanvas, clBlack);
  PutPixel(X+2, Y+12, aCanvas, clBlack);
  PutPixel(X+3, Y+12, aCanvas, clBlack);
  PutPixel(X+4, Y+12, aCanvas, clBlack);
  PutPixel(X+5, Y+12, aCanvas, clBlack);
  PutPixel(X+6, Y+12, aCanvas, clBlack);
  PutPixel(X+7, Y+12, aCanvas, clWhite);
  PutPixel(X+8, Y+12, aCanvas, clWhite);
  PutPixel(X+9, Y+12, aCanvas, clWhite);
  PutPixel(X+10, Y+12, aCanvas, clBlack);
  PutPixel(X+11, Y+12, aCanvas, clBlack);
  PutPixel(X+12, Y+12, aCanvas, clBlack);
  PutPixel(X+6, Y+13, aCanvas, clBlack);
  PutPixel(X+7, Y+13, aCanvas, clWhite);
  PutPixel(X+8, Y+13, aCanvas, clWhite);
  PutPixel(X+9, Y+13, aCanvas, clWhite);
  PutPixel(X+10, Y+13, aCanvas, clBlack);
  PutPixel(X+6, Y+14, aCanvas, clBlack);
  PutPixel(X+7, Y+14, aCanvas, clWhite);
  PutPixel(X+8, Y+14, aCanvas, clWhite);
  PutPixel(X+9, Y+14, aCanvas, clWhite);
  PutPixel(X+10, Y+14, aCanvas, clBlack);
  PutPixel(X+6, Y+15, aCanvas, clBlack);
  PutPixel(X+7, Y+15, aCanvas, clBlack);
  PutPixel(X+8, Y+15, aCanvas, clBlack);
  PutPixel(X+9, Y+15, aCanvas, clBlack);
  PutPixel(X+10, Y+15, aCanvas, clBlack);
end;

procedure TTriadCard.Draw05(X, Y: Integer; aCanvas: TCanvas);
begin
  PutPixel(X+0, Y+1, aCanvas, clBlack);
  PutPixel(X+1, Y+1, aCanvas, clBlack);
  PutPixel(X+2, Y+1, aCanvas, clBlack);
  PutPixel(X+3, Y+1, aCanvas, clBlack);
  PutPixel(X+4, Y+1, aCanvas, clBlack);
  PutPixel(X+5, Y+1, aCanvas, clBlack);
  PutPixel(X+6, Y+1, aCanvas, clBlack);
  PutPixel(X+7, Y+1, aCanvas, clBlack);
  PutPixel(X+8, Y+1, aCanvas, clBlack);
  PutPixel(X+9, Y+1, aCanvas, clBlack);
  PutPixel(X+10, Y+1, aCanvas, clBlack);
  PutPixel(X+11, Y+1, aCanvas, clBlack);
  PutPixel(X+0, Y+2, aCanvas, clBlack);
  PutPixel(X+1, Y+2, aCanvas, clWhite);
  PutPixel(X+2, Y+2, aCanvas, clWhite);
  PutPixel(X+3, Y+2, aCanvas, clWhite);
  PutPixel(X+4, Y+2, aCanvas, clWhite);
  PutPixel(X+5, Y+2, aCanvas, clWhite);
  PutPixel(X+6, Y+2, aCanvas, clWhite);
  PutPixel(X+7, Y+2, aCanvas, clWhite);
  PutPixel(X+8, Y+2, aCanvas, clWhite);
  PutPixel(X+9, Y+2, aCanvas, clWhite);
  PutPixel(X+10, Y+2, aCanvas, clWhite);
  PutPixel(X+11, Y+2, aCanvas, clBlack);
  PutPixel(X+0, Y+3, aCanvas, clBlack);
  PutPixel(X+1, Y+3, aCanvas, clWhite);
  PutPixel(X+2, Y+3, aCanvas, clWhite);
  PutPixel(X+3, Y+3, aCanvas, clWhite);
  PutPixel(X+4, Y+3, aCanvas, clWhite);
  PutPixel(X+5, Y+3, aCanvas, clWhite);
  PutPixel(X+6, Y+3, aCanvas, clWhite);
  PutPixel(X+7, Y+3, aCanvas, clWhite);
  PutPixel(X+8, Y+3, aCanvas, clWhite);
  PutPixel(X+9, Y+3, aCanvas, clWhite);
  PutPixel(X+10, Y+3, aCanvas, clWhite);
  PutPixel(X+11, Y+3, aCanvas, clBlack);
  PutPixel(X+0, Y+4, aCanvas, clBlack);
  PutPixel(X+1, Y+4, aCanvas, clWhite);
  PutPixel(X+2, Y+4, aCanvas, clWhite);
  PutPixel(X+3, Y+4, aCanvas, clWhite);
  PutPixel(X+4, Y+4, aCanvas, clBlack);
  PutPixel(X+5, Y+4, aCanvas, clBlack);
  PutPixel(X+6, Y+4, aCanvas, clBlack);
  PutPixel(X+7, Y+4, aCanvas, clBlack);
  PutPixel(X+8, Y+4, aCanvas, clBlack);
  PutPixel(X+9, Y+4, aCanvas, clBlack);
  PutPixel(X+10, Y+4, aCanvas, clBlack);
  PutPixel(X+11, Y+4, aCanvas, clBlack);
  PutPixel(X+0, Y+5, aCanvas, clBlack);
  PutPixel(X+1, Y+5, aCanvas, clWhite);
  PutPixel(X+2, Y+5, aCanvas, clWhite);
  PutPixel(X+3, Y+5, aCanvas, clWhite);
  PutPixel(X+4, Y+5, aCanvas, clBlack);
  PutPixel(X+0, Y+6, aCanvas, clBlack);
  PutPixel(X+1, Y+6, aCanvas, clWhite);
  PutPixel(X+2, Y+6, aCanvas, clWhite);
  PutPixel(X+3, Y+6, aCanvas, clWhite);
  PutPixel(X+4, Y+6, aCanvas, clBlack);
  PutPixel(X+5, Y+6, aCanvas, clBlack);
  PutPixel(X+6, Y+6, aCanvas, clBlack);
  PutPixel(X+7, Y+6, aCanvas, clBlack);
  PutPixel(X+8, Y+6, aCanvas, clBlack);
  PutPixel(X+0, Y+7, aCanvas, clBlack);
  PutPixel(X+1, Y+7, aCanvas, clWhite);
  PutPixel(X+2, Y+7, aCanvas, clWhite);
  PutPixel(X+3, Y+7, aCanvas, clWhite);
  PutPixel(X+4, Y+7, aCanvas, clWhite);
  PutPixel(X+5, Y+7, aCanvas, clWhite);
  PutPixel(X+6, Y+7, aCanvas, clWhite);
  PutPixel(X+7, Y+7, aCanvas, $00F7F7F7);
  PutPixel(X+8, Y+7, aCanvas, $00949A94);
  PutPixel(X+9, Y+7, aCanvas, clBlack);
  PutPixel(X+0, Y+8, aCanvas, clBlack);
  PutPixel(X+1, Y+8, aCanvas, clWhite);
  PutPixel(X+2, Y+8, aCanvas, clWhite);
  PutPixel(X+3, Y+8, aCanvas, clWhite);
  PutPixel(X+4, Y+8, aCanvas, clWhite);
  PutPixel(X+5, Y+8, aCanvas, clWhite);
  PutPixel(X+6, Y+8, aCanvas, clWhite);
  PutPixel(X+7, Y+8, aCanvas, clWhite);
  PutPixel(X+8, Y+8, aCanvas, clWhite);
  PutPixel(X+9, Y+8, aCanvas, $00949A94);
  PutPixel(X+10, Y+8, aCanvas, clBlack);
  PutPixel(X+0, Y+9, aCanvas, clBlack);
  PutPixel(X+1, Y+9, aCanvas, clBlack);
  PutPixel(X+2, Y+9, aCanvas, clBlack);
  PutPixel(X+3, Y+9, aCanvas, clBlack);
  PutPixel(X+4, Y+9, aCanvas, clBlack);
  PutPixel(X+5, Y+9, aCanvas, clBlack);
  PutPixel(X+6, Y+9, aCanvas, clBlack);
  PutPixel(X+7, Y+9, aCanvas, $00949A94);
  PutPixel(X+8, Y+9, aCanvas, clWhite);
  PutPixel(X+9, Y+9, aCanvas, clWhite);
  PutPixel(X+10, Y+9, aCanvas, $00949A94);
  PutPixel(X+11, Y+9, aCanvas, clBlack);
  PutPixel(X+7, Y+10, aCanvas, clBlack);
  PutPixel(X+8, Y+10, aCanvas, clWhite);
  PutPixel(X+9, Y+10, aCanvas, clWhite);
  PutPixel(X+10, Y+10, aCanvas, clWhite);
  PutPixel(X+11, Y+10, aCanvas, clBlack);
  PutPixel(X+0, Y+11, aCanvas, clBlack);
  PutPixel(X+1, Y+11, aCanvas, clBlack);
  PutPixel(X+2, Y+11, aCanvas, clBlack);
  PutPixel(X+3, Y+11, aCanvas, clBlack);
  PutPixel(X+7, Y+11, aCanvas, clBlack);
  PutPixel(X+8, Y+11, aCanvas, clWhite);
  PutPixel(X+9, Y+11, aCanvas, clWhite);
  PutPixel(X+10, Y+11, aCanvas, clWhite);
  PutPixel(X+11, Y+11, aCanvas, clBlack);
  PutPixel(X+0, Y+12, aCanvas, clBlack);
  PutPixel(X+1, Y+12, aCanvas, clWhite);
  PutPixel(X+2, Y+12, aCanvas, clWhite);
  PutPixel(X+3, Y+12, aCanvas, clBlack);
  PutPixel(X+6, Y+12, aCanvas, clBlack);
  PutPixel(X+7, Y+12, aCanvas, $00949A94);
  PutPixel(X+8, Y+12, aCanvas, clWhite);
  PutPixel(X+9, Y+12, aCanvas, clWhite);
  PutPixel(X+10, Y+12, aCanvas, clWhite);
  PutPixel(X+11, Y+12, aCanvas, clBlack);
  PutPixel(X+0, Y+13, aCanvas, clBlack);
  PutPixel(X+1, Y+13, aCanvas, clWhite);
  PutPixel(X+2, Y+13, aCanvas, clWhite);
  PutPixel(X+3, Y+13, aCanvas, $00949A94);
  PutPixel(X+4, Y+13, aCanvas, clBlack);
  PutPixel(X+5, Y+13, aCanvas, clBlack);
  PutPixel(X+6, Y+13, aCanvas, $00949A94);
  PutPixel(X+7, Y+13, aCanvas, clWhite);
  PutPixel(X+8, Y+13, aCanvas, clWhite);
  PutPixel(X+9, Y+13, aCanvas, clWhite);
  PutPixel(X+10, Y+13, aCanvas, $00949A94);
  PutPixel(X+11, Y+13, aCanvas, clBlack);
  PutPixel(X+0, Y+14, aCanvas, clBlack);
  PutPixel(X+1, Y+14, aCanvas, $00949A94);
  PutPixel(X+2, Y+14, aCanvas, clWhite);
  PutPixel(X+3, Y+14, aCanvas, clWhite);
  PutPixel(X+4, Y+14, aCanvas, clWhite);
  PutPixel(X+5, Y+14, aCanvas, clWhite);
  PutPixel(X+6, Y+14, aCanvas, clWhite);
  PutPixel(X+7, Y+14, aCanvas, clWhite);
  PutPixel(X+8, Y+14, aCanvas, clWhite);
  PutPixel(X+9, Y+14, aCanvas, $00949A94);
  PutPixel(X+10, Y+14, aCanvas, clBlack);
  PutPixel(X+1, Y+15, aCanvas, clBlack);
  PutPixel(X+2, Y+15, aCanvas, $00949A94);
  PutPixel(X+3, Y+15, aCanvas, clWhite);
  PutPixel(X+4, Y+15, aCanvas, clWhite);
  PutPixel(X+5, Y+15, aCanvas, clWhite);
  PutPixel(X+6, Y+15, aCanvas, clWhite);
  PutPixel(X+7, Y+15, aCanvas, clWhite);
  PutPixel(X+8, Y+15, aCanvas, $00949A94);
  PutPixel(X+9, Y+15, aCanvas, clBlack);
  PutPixel(X+2, Y+16, aCanvas, clBlack);
  PutPixel(X+3, Y+16, aCanvas, clBlack);
  PutPixel(X+4, Y+16, aCanvas, clBlack);
  PutPixel(X+5, Y+16, aCanvas, clBlack);
  PutPixel(X+6, Y+16, aCanvas, clBlack);
  PutPixel(X+7, Y+16, aCanvas, clBlack);
  PutPixel(X+8, Y+16, aCanvas, clBlack);
end;

procedure TTriadCard.Draw06(X, Y: Integer; aCanvas: TCanvas);
begin
  PutPixel(X+4, Y+0, aCanvas, clBlack);
  PutPixel(X+5, Y+0, aCanvas, clBlack);
  PutPixel(X+6, Y+0, aCanvas, clBlack);
  PutPixel(X+7, Y+0, aCanvas, clBlack);
  PutPixel(X+8, Y+0, aCanvas, clBlack);
  PutPixel(X+9, Y+0, aCanvas, clBlack);
  PutPixel(X+10, Y+0, aCanvas, clBlack);
  PutPixel(X+3, Y+1, aCanvas, clBlack);
  PutPixel(X+4, Y+1, aCanvas, $00949A94);
  PutPixel(X+5, Y+1, aCanvas, $00F7F7F7);
  PutPixel(X+6, Y+1, aCanvas, $00F7F7F7);
  PutPixel(X+7, Y+1, aCanvas, clWhite);
  PutPixel(X+8, Y+1, aCanvas, clWhite);
  PutPixel(X+9, Y+1, aCanvas, $00F7F7F7);
  PutPixel(X+10, Y+1, aCanvas, clBlack);
  PutPixel(X+2, Y+2, aCanvas, clBlack);
  PutPixel(X+3, Y+2, aCanvas, $00949A94);
  PutPixel(X+4, Y+2, aCanvas, clWhite);
  PutPixel(X+5, Y+2, aCanvas, clWhite);
  PutPixel(X+6, Y+2, aCanvas, clWhite);
  PutPixel(X+7, Y+2, aCanvas, clWhite);
  PutPixel(X+8, Y+2, aCanvas, clWhite);
  PutPixel(X+9, Y+2, aCanvas, clWhite);
  PutPixel(X+10, Y+2, aCanvas, clBlack);
  PutPixel(X+1, Y+3, aCanvas, clBlack);
  PutPixel(X+2, Y+3, aCanvas, $00949A94);
  PutPixel(X+3, Y+3, aCanvas, clWhite);
  PutPixel(X+4, Y+3, aCanvas, clWhite);
  PutPixel(X+5, Y+3, aCanvas, clWhite);
  PutPixel(X+6, Y+3, aCanvas, $00949A94);
  PutPixel(X+7, Y+3, aCanvas, clBlack);
  PutPixel(X+8, Y+3, aCanvas, clBlack);
  PutPixel(X+9, Y+3, aCanvas, clBlack);
  PutPixel(X+10, Y+3, aCanvas, clBlack);
  PutPixel(X+1, Y+4, aCanvas, clBlack);
  PutPixel(X+2, Y+4, aCanvas, clWhite);
  PutPixel(X+3, Y+4, aCanvas, clWhite);
  PutPixel(X+4, Y+4, aCanvas, clWhite);
  PutPixel(X+5, Y+4, aCanvas, $00949A94);
  PutPixel(X+6, Y+4, aCanvas, clBlack);
  PutPixel(X+0, Y+5, aCanvas, clBlack);
  PutPixel(X+1, Y+5, aCanvas, $00949A94);
  PutPixel(X+2, Y+5, aCanvas, clWhite);
  PutPixel(X+3, Y+5, aCanvas, clWhite);
  PutPixel(X+4, Y+5, aCanvas, clWhite);
  PutPixel(X+5, Y+5, aCanvas, clBlack);
  PutPixel(X+6, Y+5, aCanvas, clBlack);
  PutPixel(X+7, Y+5, aCanvas, clBlack);
  PutPixel(X+8, Y+5, aCanvas, clBlack);
  PutPixel(X+0, Y+6, aCanvas, clBlack);
  PutPixel(X+1, Y+6, aCanvas, clWhite);
  PutPixel(X+2, Y+6, aCanvas, clWhite);
  PutPixel(X+3, Y+6, aCanvas, clWhite);
  PutPixel(X+4, Y+6, aCanvas, clWhite);
  PutPixel(X+5, Y+6, aCanvas, clWhite);
  PutPixel(X+6, Y+6, aCanvas, clWhite);
  PutPixel(X+7, Y+6, aCanvas, clWhite);
  PutPixel(X+8, Y+6, aCanvas, $00949A94);
  PutPixel(X+9, Y+6, aCanvas, clBlack);
  PutPixel(X+0, Y+7, aCanvas, clBlack);
  PutPixel(X+1, Y+7, aCanvas, clWhite);
  PutPixel(X+2, Y+7, aCanvas, clWhite);
  PutPixel(X+3, Y+7, aCanvas, clWhite);
  PutPixel(X+4, Y+7, aCanvas, clWhite);
  PutPixel(X+5, Y+7, aCanvas, clWhite);
  PutPixel(X+6, Y+7, aCanvas, clWhite);
  PutPixel(X+7, Y+7, aCanvas, clWhite);
  PutPixel(X+8, Y+7, aCanvas, clWhite);
  PutPixel(X+9, Y+7, aCanvas, $00949A94);
  PutPixel(X+10, Y+7, aCanvas, clBlack);
  PutPixel(X+0, Y+8, aCanvas, clBlack);
  PutPixel(X+1, Y+8, aCanvas, clWhite);
  PutPixel(X+2, Y+8, aCanvas, clWhite);
  PutPixel(X+3, Y+8, aCanvas, clWhite);
  PutPixel(X+4, Y+8, aCanvas, $00949A94);
  PutPixel(X+5, Y+8, aCanvas, clBlack);
  PutPixel(X+6, Y+8, aCanvas, clBlack);
  PutPixel(X+7, Y+8, aCanvas, $00949A94);
  PutPixel(X+8, Y+8, aCanvas, clWhite);
  PutPixel(X+9, Y+8, aCanvas, clWhite);
  PutPixel(X+10, Y+8, aCanvas, $00949A94);
  PutPixel(X+11, Y+8, aCanvas, clBlack);
  PutPixel(X+0, Y+9, aCanvas, clBlack);
  PutPixel(X+1, Y+9, aCanvas, clWhite);
  PutPixel(X+2, Y+9, aCanvas, clWhite);
  PutPixel(X+3, Y+9, aCanvas, clWhite);
  PutPixel(X+4, Y+9, aCanvas, clBlack);
  PutPixel(X+7, Y+9, aCanvas, clBlack);
  PutPixel(X+8, Y+9, aCanvas, clWhite);
  PutPixel(X+9, Y+9, aCanvas, clWhite);
  PutPixel(X+10, Y+9, aCanvas, clWhite);
  PutPixel(X+11, Y+9, aCanvas, clBlack);
  PutPixel(X+0, Y+10, aCanvas, clBlack);
  PutPixel(X+1, Y+10, aCanvas, clWhite);
  PutPixel(X+2, Y+10, aCanvas, clWhite);
  PutPixel(X+3, Y+10, aCanvas, clWhite);
  PutPixel(X+4, Y+10, aCanvas, clBlack);
  PutPixel(X+7, Y+10, aCanvas, clBlack);
  PutPixel(X+8, Y+10, aCanvas, clWhite);
  PutPixel(X+9, Y+10, aCanvas, clWhite);
  PutPixel(X+10, Y+10, aCanvas, clWhite);
  PutPixel(X+11, Y+10, aCanvas, clBlack);
  PutPixel(X+0, Y+11, aCanvas, clBlack);
  PutPixel(X+1, Y+11, aCanvas, clWhite);
  PutPixel(X+2, Y+11, aCanvas, clWhite);
  PutPixel(X+3, Y+11, aCanvas, clWhite);
  PutPixel(X+4, Y+11, aCanvas, $00949A94);
  PutPixel(X+5, Y+11, aCanvas, clBlack);
  PutPixel(X+6, Y+11, aCanvas, clBlack);
  PutPixel(X+7, Y+11, aCanvas, $00949A94);
  PutPixel(X+8, Y+11, aCanvas, clWhite);
  PutPixel(X+9, Y+11, aCanvas, clWhite);
  PutPixel(X+10, Y+11, aCanvas, clWhite);
  PutPixel(X+11, Y+11, aCanvas, clBlack);
  PutPixel(X+0, Y+12, aCanvas, clBlack);
  PutPixel(X+1, Y+12, aCanvas, $00949A94);
  PutPixel(X+2, Y+12, aCanvas, clWhite);
  PutPixel(X+3, Y+12, aCanvas, clWhite);
  PutPixel(X+4, Y+12, aCanvas, clWhite);
  PutPixel(X+5, Y+12, aCanvas, clWhite);
  PutPixel(X+6, Y+12, aCanvas, clWhite);
  PutPixel(X+7, Y+12, aCanvas, clWhite);
  PutPixel(X+8, Y+12, aCanvas, clWhite);
  PutPixel(X+9, Y+12, aCanvas, clWhite);
  PutPixel(X+10, Y+12, aCanvas, $00949A94);
  PutPixel(X+11, Y+12, aCanvas, clBlack);
  PutPixel(X+1, Y+13, aCanvas, clBlack);
  PutPixel(X+2, Y+13, aCanvas, $00949A94);
  PutPixel(X+3, Y+13, aCanvas, clWhite);
  PutPixel(X+4, Y+13, aCanvas, clWhite);
  PutPixel(X+5, Y+13, aCanvas, clWhite);
  PutPixel(X+6, Y+13, aCanvas, clWhite);
  PutPixel(X+7, Y+13, aCanvas, clWhite);
  PutPixel(X+8, Y+13, aCanvas, clWhite);
  PutPixel(X+9, Y+13, aCanvas, $00949A94);
  PutPixel(X+10, Y+13, aCanvas, clBlack);
  PutPixel(X+2, Y+14, aCanvas, clBlack);
  PutPixel(X+3, Y+14, aCanvas, $00949A94);
  PutPixel(X+4, Y+14, aCanvas, clWhite);
  PutPixel(X+5, Y+14, aCanvas, clWhite);
  PutPixel(X+6, Y+14, aCanvas, clWhite);
  PutPixel(X+7, Y+14, aCanvas, clWhite);
  PutPixel(X+8, Y+14, aCanvas, $00949A94);
  PutPixel(X+9, Y+14, aCanvas, clBlack);
  PutPixel(X+3, Y+15, aCanvas, clBlack);
  PutPixel(X+4, Y+15, aCanvas, clBlack);
  PutPixel(X+5, Y+15, aCanvas, clBlack);
  PutPixel(X+6, Y+15, aCanvas, clBlack);
  PutPixel(X+7, Y+15, aCanvas, clBlack);
  PutPixel(X+8, Y+15, aCanvas, clBlack);
end;

procedure TTriadCard.Draw07(X, Y: Integer; aCanvas: TCanvas);
begin
  PutPixel(X+0, Y+0, aCanvas, clBlack);
  PutPixel(X+1, Y+0, aCanvas, clBlack);
  PutPixel(X+2, Y+0, aCanvas, clBlack);
  PutPixel(X+3, Y+0, aCanvas, clBlack);
  PutPixel(X+4, Y+0, aCanvas, clBlack);
  PutPixel(X+5, Y+0, aCanvas, clBlack);
  PutPixel(X+6, Y+0, aCanvas, clBlack);
  PutPixel(X+7, Y+0, aCanvas, clBlack);
  PutPixel(X+8, Y+0, aCanvas, clBlack);
  PutPixel(X+9, Y+0, aCanvas, clBlack);
  PutPixel(X+10, Y+0, aCanvas, clBlack);
  PutPixel(X+11, Y+0, aCanvas, clBlack);
  PutPixel(X+0, Y+1, aCanvas, clBlack);
  PutPixel(X+1, Y+1, aCanvas, clWhite);
  PutPixel(X+2, Y+1, aCanvas, clWhite);
  PutPixel(X+3, Y+1, aCanvas, clWhite);
  PutPixel(X+4, Y+1, aCanvas, clWhite);
  PutPixel(X+5, Y+1, aCanvas, clWhite);
  PutPixel(X+6, Y+1, aCanvas, clWhite);
  PutPixel(X+7, Y+1, aCanvas, clWhite);
  PutPixel(X+8, Y+1, aCanvas, clWhite);
  PutPixel(X+9, Y+1, aCanvas, clWhite);
  PutPixel(X+10, Y+1, aCanvas, clWhite);
  PutPixel(X+11, Y+1, aCanvas, clBlack);
  PutPixel(X+0, Y+2, aCanvas, clBlack);
  PutPixel(X+1, Y+2, aCanvas, clWhite);
  PutPixel(X+2, Y+2, aCanvas, clWhite);
  PutPixel(X+3, Y+2, aCanvas, clWhite);
  PutPixel(X+4, Y+2, aCanvas, clWhite);
  PutPixel(X+5, Y+2, aCanvas, clWhite);
  PutPixel(X+6, Y+2, aCanvas, clWhite);
  PutPixel(X+7, Y+2, aCanvas, clWhite);
  PutPixel(X+8, Y+2, aCanvas, clWhite);
  PutPixel(X+9, Y+2, aCanvas, clWhite);
  PutPixel(X+10, Y+2, aCanvas, $00949A94);
  PutPixel(X+11, Y+2, aCanvas, clBlack);
  PutPixel(X+0, Y+3, aCanvas, clBlack);
  PutPixel(X+1, Y+3, aCanvas, clBlack);
  PutPixel(X+2, Y+3, aCanvas, clBlack);
  PutPixel(X+3, Y+3, aCanvas, clBlack);
  PutPixel(X+4, Y+3, aCanvas, clBlack);
  PutPixel(X+5, Y+3, aCanvas, clBlack);
  PutPixel(X+6, Y+3, aCanvas, clBlack);
  PutPixel(X+7, Y+3, aCanvas, clWhite);
  PutPixel(X+8, Y+3, aCanvas, clWhite);
  PutPixel(X+9, Y+3, aCanvas, clWhite);
  PutPixel(X+10, Y+3, aCanvas, clBlack);
  PutPixel(X+6, Y+4, aCanvas, clBlack);
  PutPixel(X+7, Y+4, aCanvas, clWhite);
  PutPixel(X+8, Y+4, aCanvas, clWhite);
  PutPixel(X+9, Y+4, aCanvas, $00949A94);
  PutPixel(X+10, Y+4, aCanvas, clBlack);
  PutPixel(X+5, Y+5, aCanvas, clBlack);
  PutPixel(X+6, Y+5, aCanvas, $00949A94);
  PutPixel(X+7, Y+5, aCanvas, clWhite);
  PutPixel(X+8, Y+5, aCanvas, clWhite);
  PutPixel(X+9, Y+5, aCanvas, clBlack);
  PutPixel(X+5, Y+6, aCanvas, clBlack);
  PutPixel(X+6, Y+6, aCanvas, clWhite);
  PutPixel(X+7, Y+6, aCanvas, clWhite);
  PutPixel(X+8, Y+6, aCanvas, $00949A94);
  PutPixel(X+9, Y+6, aCanvas, clBlack);
  PutPixel(X+4, Y+7, aCanvas, clBlack);
  PutPixel(X+5, Y+7, aCanvas, $00949A94);
  PutPixel(X+6, Y+7, aCanvas, clWhite);
  PutPixel(X+7, Y+7, aCanvas, clWhite);
  PutPixel(X+8, Y+7, aCanvas, clBlack);
  PutPixel(X+4, Y+8, aCanvas, clBlack);
  PutPixel(X+5, Y+8, aCanvas, clWhite);
  PutPixel(X+6, Y+8, aCanvas, clWhite);
  PutPixel(X+7, Y+8, aCanvas, $00949A94);
  PutPixel(X+8, Y+8, aCanvas, clBlack);
  PutPixel(X+3, Y+9, aCanvas, clBlack);
  PutPixel(X+4, Y+9, aCanvas, $00949A94);
  PutPixel(X+5, Y+9, aCanvas, clWhite);
  PutPixel(X+6, Y+9, aCanvas, clWhite);
  PutPixel(X+7, Y+9, aCanvas, clBlack);
  PutPixel(X+3, Y+10, aCanvas, clBlack);
  PutPixel(X+4, Y+10, aCanvas, clWhite);
  PutPixel(X+5, Y+10, aCanvas, clWhite);
  PutPixel(X+6, Y+10, aCanvas, $00949A94);
  PutPixel(X+7, Y+10, aCanvas, clBlack);
  PutPixel(X+2, Y+11, aCanvas, clBlack);
  PutPixel(X+3, Y+11, aCanvas, $00949A94);
  PutPixel(X+4, Y+11, aCanvas, clWhite);
  PutPixel(X+5, Y+11, aCanvas, clWhite);
  PutPixel(X+6, Y+11, aCanvas, clBlack);
  PutPixel(X+2, Y+12, aCanvas, clBlack);
  PutPixel(X+3, Y+12, aCanvas, clWhite);
  PutPixel(X+4, Y+12, aCanvas, clWhite);
  PutPixel(X+5, Y+12, aCanvas, $00949A94);
  PutPixel(X+6, Y+12, aCanvas, clBlack);
  PutPixel(X+1, Y+13, aCanvas, clBlack);
  PutPixel(X+2, Y+13, aCanvas, $00949A94);
  PutPixel(X+3, Y+13, aCanvas, clWhite);
  PutPixel(X+4, Y+13, aCanvas, clWhite);
  PutPixel(X+5, Y+13, aCanvas, clBlack);
  PutPixel(X+1, Y+14, aCanvas, clBlack);
  PutPixel(X+2, Y+14, aCanvas, clWhite);
  PutPixel(X+3, Y+14, aCanvas, clWhite);
  PutPixel(X+4, Y+14, aCanvas, clWhite);
  PutPixel(X+5, Y+14, aCanvas, clBlack);
  PutPixel(X+1, Y+15, aCanvas, clBlack);
  PutPixel(X+2, Y+15, aCanvas, clBlack);
  PutPixel(X+3, Y+15, aCanvas, clBlack);
  PutPixel(X+4, Y+15, aCanvas, clBlack);
  PutPixel(X+5, Y+15, aCanvas, clBlack);
end;

procedure TTriadCard.Draw08(X, Y: Integer; aCanvas: TCanvas);
begin
  PutPixel(X+2, Y+0, aCanvas, clBlack);
  PutPixel(X+3, Y+0, aCanvas, clBlack);
  PutPixel(X+4, Y+0, aCanvas, clBlack);
  PutPixel(X+5, Y+0, aCanvas, clBlack);
  PutPixel(X+6, Y+0, aCanvas, clBlack);
  PutPixel(X+7, Y+0, aCanvas, clBlack);
  PutPixel(X+8, Y+0, aCanvas, clBlack);
  PutPixel(X+9, Y+0, aCanvas, clBlack);
  PutPixel(X+1, Y+1, aCanvas, clBlack);
  PutPixel(X+2, Y+1, aCanvas, clWhite);
  PutPixel(X+3, Y+1, aCanvas, clWhite);
  PutPixel(X+4, Y+1, aCanvas, clWhite);
  PutPixel(X+5, Y+1, aCanvas, clWhite);
  PutPixel(X+6, Y+1, aCanvas, clWhite);
  PutPixel(X+7, Y+1, aCanvas, clWhite);
  PutPixel(X+8, Y+1, aCanvas, clWhite);
  PutPixel(X+9, Y+1, aCanvas, clWhite);
  PutPixel(X+10, Y+1, aCanvas, clBlack);
  PutPixel(X+0, Y+2, aCanvas, clBlack);
  PutPixel(X+1, Y+2, aCanvas, clWhite);
  PutPixel(X+2, Y+2, aCanvas, clWhite);
  PutPixel(X+3, Y+2, aCanvas, clWhite);
  PutPixel(X+4, Y+2, aCanvas, clWhite);
  PutPixel(X+5, Y+2, aCanvas, clWhite);
  PutPixel(X+6, Y+2, aCanvas, clWhite);
  PutPixel(X+7, Y+2, aCanvas, clWhite);
  PutPixel(X+8, Y+2, aCanvas, clWhite);
  PutPixel(X+9, Y+2, aCanvas, clWhite);
  PutPixel(X+10, Y+2, aCanvas, clWhite);
  PutPixel(X+11, Y+2, aCanvas, clBlack);
  PutPixel(X+0, Y+3, aCanvas, clBlack);
  PutPixel(X+1, Y+3, aCanvas, clWhite);
  PutPixel(X+2, Y+3, aCanvas, clWhite);
  PutPixel(X+3, Y+3, aCanvas, clWhite);
  PutPixel(X+4, Y+3, aCanvas, $00949A94);
  PutPixel(X+5, Y+3, aCanvas, clBlack);
  PutPixel(X+6, Y+3, aCanvas, clBlack);
  PutPixel(X+7, Y+3, aCanvas, $00949A94);
  PutPixel(X+8, Y+3, aCanvas, clWhite);
  PutPixel(X+9, Y+3, aCanvas, clWhite);
  PutPixel(X+10, Y+3, aCanvas, clWhite);
  PutPixel(X+11, Y+3, aCanvas, clBlack);
  PutPixel(X+0, Y+4, aCanvas, $00212821);
  PutPixel(X+1, Y+4, aCanvas, clWhite);
  PutPixel(X+2, Y+4, aCanvas, clWhite);
  PutPixel(X+3, Y+4, aCanvas, clWhite);
  PutPixel(X+4, Y+4, aCanvas, clBlack);
  PutPixel(X+7, Y+4, aCanvas, clBlack);
  PutPixel(X+8, Y+4, aCanvas, clWhite);
  PutPixel(X+9, Y+4, aCanvas, clWhite);
  PutPixel(X+10, Y+4, aCanvas, clWhite);
  PutPixel(X+11, Y+4, aCanvas, $00292829);
  PutPixel(X+0, Y+5, aCanvas, clBlack);
  PutPixel(X+1, Y+5, aCanvas, clWhite);
  PutPixel(X+2, Y+5, aCanvas, clWhite);
  PutPixel(X+3, Y+5, aCanvas, clWhite);
  PutPixel(X+4, Y+5, aCanvas, clBlack);
  PutPixel(X+7, Y+5, aCanvas, clBlack);
  PutPixel(X+8, Y+5, aCanvas, clWhite);
  PutPixel(X+9, Y+5, aCanvas, clWhite);
  PutPixel(X+10, Y+5, aCanvas, clWhite);
  PutPixel(X+11, Y+5, aCanvas, clBlack);
  PutPixel(X+0, Y+6, aCanvas, clBlack);
  PutPixel(X+1, Y+6, aCanvas, clWhite);
  PutPixel(X+2, Y+6, aCanvas, clWhite);
  PutPixel(X+3, Y+6, aCanvas, clWhite);
  PutPixel(X+4, Y+6, aCanvas, $00949A94);
  PutPixel(X+5, Y+6, aCanvas, clBlack);
  PutPixel(X+6, Y+6, aCanvas, clBlack);
  PutPixel(X+7, Y+6, aCanvas, $00949A94);
  PutPixel(X+8, Y+6, aCanvas, clWhite);
  PutPixel(X+9, Y+6, aCanvas, clWhite);
  PutPixel(X+10, Y+6, aCanvas, clWhite);
  PutPixel(X+11, Y+6, aCanvas, clBlack);
  PutPixel(X+1, Y+7, aCanvas, clBlack);
  PutPixel(X+2, Y+7, aCanvas, clWhite);
  PutPixel(X+3, Y+7, aCanvas, clWhite);
  PutPixel(X+4, Y+7, aCanvas, clWhite);
  PutPixel(X+5, Y+7, aCanvas, clWhite);
  PutPixel(X+6, Y+7, aCanvas, clWhite);
  PutPixel(X+7, Y+7, aCanvas, clWhite);
  PutPixel(X+8, Y+7, aCanvas, clWhite);
  PutPixel(X+9, Y+7, aCanvas, clWhite);
  PutPixel(X+10, Y+7, aCanvas, $00101410);
  PutPixel(X+1, Y+8, aCanvas, clBlack);
  PutPixel(X+2, Y+8, aCanvas, clWhite);
  PutPixel(X+3, Y+8, aCanvas, clWhite);
  PutPixel(X+4, Y+8, aCanvas, clWhite);
  PutPixel(X+5, Y+8, aCanvas, clWhite);
  PutPixel(X+6, Y+8, aCanvas, clWhite);
  PutPixel(X+7, Y+8, aCanvas, clWhite);
  PutPixel(X+8, Y+8, aCanvas, clWhite);
  PutPixel(X+9, Y+8, aCanvas, clWhite);
  PutPixel(X+10, Y+8, aCanvas, clBlack);
  PutPixel(X+0, Y+9, aCanvas, clBlack);
  PutPixel(X+1, Y+9, aCanvas, clWhite);
  PutPixel(X+2, Y+9, aCanvas, clWhite);
  PutPixel(X+3, Y+9, aCanvas, clWhite);
  PutPixel(X+4, Y+9, aCanvas, $00949A94);
  PutPixel(X+5, Y+9, aCanvas, clBlack);
  PutPixel(X+6, Y+9, aCanvas, clBlack);
  PutPixel(X+7, Y+9, aCanvas, $00949A94);
  PutPixel(X+8, Y+9, aCanvas, clWhite);
  PutPixel(X+9, Y+9, aCanvas, clWhite);
  PutPixel(X+10, Y+9, aCanvas, clWhite);
  PutPixel(X+11, Y+9, aCanvas, clBlack);
  PutPixel(X+0, Y+10, aCanvas, clBlack);
  PutPixel(X+1, Y+10, aCanvas, clWhite);
  PutPixel(X+2, Y+10, aCanvas, clWhite);
  PutPixel(X+3, Y+10, aCanvas, clWhite);
  PutPixel(X+4, Y+10, aCanvas, clBlack);
  PutPixel(X+7, Y+10, aCanvas, clBlack);
  PutPixel(X+8, Y+10, aCanvas, clWhite);
  PutPixel(X+9, Y+10, aCanvas, clWhite);
  PutPixel(X+10, Y+10, aCanvas, clWhite);
  PutPixel(X+11, Y+10, aCanvas, clBlack);
  PutPixel(X+0, Y+11, aCanvas, clBlack);
  PutPixel(X+1, Y+11, aCanvas, clWhite);
  PutPixel(X+2, Y+11, aCanvas, clWhite);
  PutPixel(X+3, Y+11, aCanvas, clWhite);
  PutPixel(X+4, Y+11, aCanvas, clBlack);
  PutPixel(X+7, Y+11, aCanvas, clBlack);
  PutPixel(X+8, Y+11, aCanvas, clWhite);
  PutPixel(X+9, Y+11, aCanvas, clWhite);
  PutPixel(X+10, Y+11, aCanvas, clWhite);
  PutPixel(X+11, Y+11, aCanvas, clBlack);
  PutPixel(X+0, Y+12, aCanvas, clBlack);
  PutPixel(X+1, Y+12, aCanvas, clWhite);
  PutPixel(X+2, Y+12, aCanvas, clWhite);
  PutPixel(X+3, Y+12, aCanvas, clWhite);
  PutPixel(X+4, Y+12, aCanvas, $00949A94);
  PutPixel(X+5, Y+12, aCanvas, clBlack);
  PutPixel(X+6, Y+12, aCanvas, clBlack);
  PutPixel(X+7, Y+12, aCanvas, $00949A94);
  PutPixel(X+8, Y+12, aCanvas, clWhite);
  PutPixel(X+9, Y+12, aCanvas, clWhite);
  PutPixel(X+10, Y+12, aCanvas, clWhite);
  PutPixel(X+11, Y+12, aCanvas, clBlack);
  PutPixel(X+0, Y+13, aCanvas, clBlack);
  PutPixel(X+1, Y+13, aCanvas, clWhite);
  PutPixel(X+2, Y+13, aCanvas, clWhite);
  PutPixel(X+3, Y+13, aCanvas, clWhite);
  PutPixel(X+4, Y+13, aCanvas, clWhite);
  PutPixel(X+5, Y+13, aCanvas, clWhite);
  PutPixel(X+6, Y+13, aCanvas, clWhite);
  PutPixel(X+7, Y+13, aCanvas, clWhite);
  PutPixel(X+8, Y+13, aCanvas, clWhite);
  PutPixel(X+9, Y+13, aCanvas, clWhite);
  PutPixel(X+10, Y+13, aCanvas, clWhite);
  PutPixel(X+11, Y+13, aCanvas, clBlack);
  PutPixel(X+1, Y+14, aCanvas, clBlack);
  PutPixel(X+2, Y+14, aCanvas, clWhite);
  PutPixel(X+3, Y+14, aCanvas, clWhite);
  PutPixel(X+4, Y+14, aCanvas, clWhite);
  PutPixel(X+5, Y+14, aCanvas, clWhite);
  PutPixel(X+6, Y+14, aCanvas, clWhite);
  PutPixel(X+7, Y+14, aCanvas, clWhite);
  PutPixel(X+8, Y+14, aCanvas, clWhite);
  PutPixel(X+9, Y+14, aCanvas, clWhite);
  PutPixel(X+10, Y+14, aCanvas, clBlack);
  PutPixel(X+2, Y+15, aCanvas, clBlack);
  PutPixel(X+3, Y+15, aCanvas, clBlack);
  PutPixel(X+4, Y+15, aCanvas, clBlack);
  PutPixel(X+5, Y+15, aCanvas, clBlack);
  PutPixel(X+6, Y+15, aCanvas, clBlack);
  PutPixel(X+7, Y+15, aCanvas, clBlack);
  PutPixel(X+8, Y+15, aCanvas, clBlack);
  PutPixel(X+9, Y+15, aCanvas, clBlack);
end;

procedure TTriadCard.Draw09(X, Y: Integer; aCanvas: TCanvas);
begin
  PutPixel(X+3, Y+0, aCanvas, clBlack);
  PutPixel(X+4, Y+0, aCanvas, clBlack);
  PutPixel(X+5, Y+0, aCanvas, clBlack);
  PutPixel(X+6, Y+0, aCanvas, clBlack);
  PutPixel(X+7, Y+0, aCanvas, clBlack);
  PutPixel(X+8, Y+0, aCanvas, clBlack);
  PutPixel(X+2, Y+1, aCanvas, clBlack);
  PutPixel(X+3, Y+1, aCanvas, clWhite);
  PutPixel(X+4, Y+1, aCanvas, clWhite);
  PutPixel(X+5, Y+1, aCanvas, clWhite);
  PutPixel(X+6, Y+1, aCanvas, clWhite);
  PutPixel(X+7, Y+1, aCanvas, clWhite);
  PutPixel(X+8, Y+1, aCanvas, clWhite);
  PutPixel(X+9, Y+1, aCanvas, clBlack);
  PutPixel(X+1, Y+2, aCanvas, clBlack);
  PutPixel(X+2, Y+2, aCanvas, clWhite);
  PutPixel(X+3, Y+2, aCanvas, clWhite);
  PutPixel(X+4, Y+2, aCanvas, clWhite);
  PutPixel(X+5, Y+2, aCanvas, clWhite);
  PutPixel(X+6, Y+2, aCanvas, clWhite);
  PutPixel(X+7, Y+2, aCanvas, clWhite);
  PutPixel(X+8, Y+2, aCanvas, clWhite);
  PutPixel(X+9, Y+2, aCanvas, clWhite);
  PutPixel(X+10, Y+2, aCanvas, clBlack);
  PutPixel(X+0, Y+3, aCanvas, clBlack);
  PutPixel(X+1, Y+3, aCanvas, clWhite);
  PutPixel(X+2, Y+3, aCanvas, clWhite);
  PutPixel(X+3, Y+3, aCanvas, clWhite);
  PutPixel(X+4, Y+3, aCanvas, $00949A94);
  PutPixel(X+5, Y+3, aCanvas, clBlack);
  PutPixel(X+6, Y+3, aCanvas, clBlack);
  PutPixel(X+7, Y+3, aCanvas, $00949A94);
  PutPixel(X+8, Y+3, aCanvas, clWhite);
  PutPixel(X+9, Y+3, aCanvas, clWhite);
  PutPixel(X+10, Y+3, aCanvas, clWhite);
  PutPixel(X+11, Y+3, aCanvas, clBlack);
  PutPixel(X+0, Y+4, aCanvas, clBlack);
  PutPixel(X+1, Y+4, aCanvas, clWhite);
  PutPixel(X+2, Y+4, aCanvas, clWhite);
  PutPixel(X+3, Y+4, aCanvas, clWhite);
  PutPixel(X+4, Y+4, aCanvas, clBlack);
  PutPixel(X+7, Y+4, aCanvas, clBlack);
  PutPixel(X+8, Y+4, aCanvas, clWhite);
  PutPixel(X+9, Y+4, aCanvas, clWhite);
  PutPixel(X+10, Y+4, aCanvas, clWhite);
  PutPixel(X+11, Y+4, aCanvas, clBlack);
  PutPixel(X+0, Y+5, aCanvas, clBlack);
  PutPixel(X+1, Y+5, aCanvas, clWhite);
  PutPixel(X+2, Y+5, aCanvas, clWhite);
  PutPixel(X+3, Y+5, aCanvas, clWhite);
  PutPixel(X+4, Y+5, aCanvas, clBlack);
  PutPixel(X+7, Y+5, aCanvas, clBlack);
  PutPixel(X+8, Y+5, aCanvas, clWhite);
  PutPixel(X+9, Y+5, aCanvas, clWhite);
  PutPixel(X+10, Y+5, aCanvas, clWhite);
  PutPixel(X+11, Y+5, aCanvas, clBlack);
  PutPixel(X+0, Y+6, aCanvas, clBlack);
  PutPixel(X+1, Y+6, aCanvas, clWhite);
  PutPixel(X+2, Y+6, aCanvas, clWhite);
  PutPixel(X+3, Y+6, aCanvas, clWhite);
  PutPixel(X+4, Y+6, aCanvas, $00949A94);
  PutPixel(X+5, Y+6, aCanvas, clBlack);
  PutPixel(X+6, Y+6, aCanvas, clBlack);
  PutPixel(X+7, Y+6, aCanvas, $00949A94);
  PutPixel(X+8, Y+6, aCanvas, clWhite);
  PutPixel(X+9, Y+6, aCanvas, clWhite);
  PutPixel(X+10, Y+6, aCanvas, clWhite);
  PutPixel(X+11, Y+6, aCanvas, clBlack);
  PutPixel(X+0, Y+7, aCanvas, clBlack);
  PutPixel(X+1, Y+7, aCanvas, clWhite);
  PutPixel(X+2, Y+7, aCanvas, clWhite);
  PutPixel(X+3, Y+7, aCanvas, clWhite);
  PutPixel(X+4, Y+7, aCanvas, clWhite);
  PutPixel(X+5, Y+7, aCanvas, clWhite);
  PutPixel(X+6, Y+7, aCanvas, clWhite);
  PutPixel(X+7, Y+7, aCanvas, clWhite);
  PutPixel(X+8, Y+7, aCanvas, clWhite);
  PutPixel(X+9, Y+7, aCanvas, clWhite);
  PutPixel(X+10, Y+7, aCanvas, clWhite);
  PutPixel(X+11, Y+7, aCanvas, clBlack);
  PutPixel(X+1, Y+8, aCanvas, clBlack);
  PutPixel(X+2, Y+8, aCanvas, clWhite);
  PutPixel(X+3, Y+8, aCanvas, clWhite);
  PutPixel(X+4, Y+8, aCanvas, clWhite);
  PutPixel(X+5, Y+8, aCanvas, clWhite);
  PutPixel(X+6, Y+8, aCanvas, clWhite);
  PutPixel(X+7, Y+8, aCanvas, clWhite);
  PutPixel(X+8, Y+8, aCanvas, clWhite);
  PutPixel(X+9, Y+8, aCanvas, clWhite);
  PutPixel(X+10, Y+8, aCanvas, clWhite);
  PutPixel(X+11, Y+8, aCanvas, clBlack);
  PutPixel(X+2, Y+9, aCanvas, clBlack);
  PutPixel(X+3, Y+9, aCanvas, clBlack);
  PutPixel(X+4, Y+9, aCanvas, clBlack);
  PutPixel(X+5, Y+9, aCanvas, clBlack);
  PutPixel(X+6, Y+9, aCanvas, $00949A94);
  PutPixel(X+7, Y+9, aCanvas, clWhite);
  PutPixel(X+8, Y+9, aCanvas, clWhite);
  PutPixel(X+9, Y+9, aCanvas, clWhite);
  PutPixel(X+10, Y+9, aCanvas, clWhite);
  PutPixel(X+11, Y+9, aCanvas, clBlack);
  PutPixel(X+6, Y+10, aCanvas, clBlack);
  PutPixel(X+7, Y+10, aCanvas, clWhite);
  PutPixel(X+8, Y+10, aCanvas, clWhite);
  PutPixel(X+9, Y+10, aCanvas, clWhite);
  PutPixel(X+10, Y+10, aCanvas, $00949A94);
  PutPixel(X+11, Y+10, aCanvas, clBlack);
  PutPixel(X+5, Y+11, aCanvas, clBlack);
  PutPixel(X+6, Y+11, aCanvas, $00949A94);
  PutPixel(X+7, Y+11, aCanvas, clWhite);
  PutPixel(X+8, Y+11, aCanvas, clWhite);
  PutPixel(X+9, Y+11, aCanvas, clWhite);
  PutPixel(X+10, Y+11, aCanvas, clBlack);
  PutPixel(X+1, Y+12, aCanvas, clBlack);
  PutPixel(X+2, Y+12, aCanvas, clBlack);
  PutPixel(X+3, Y+12, aCanvas, clBlack);
  PutPixel(X+4, Y+12, aCanvas, clBlack);
  PutPixel(X+5, Y+12, aCanvas, $00949A94);
  PutPixel(X+6, Y+12, aCanvas, clWhite);
  PutPixel(X+7, Y+12, aCanvas, clWhite);
  PutPixel(X+8, Y+12, aCanvas, clWhite);
  PutPixel(X+9, Y+12, aCanvas, $00949A94);
  PutPixel(X+10, Y+12, aCanvas, clBlack);
  PutPixel(X+1, Y+13, aCanvas, clBlack);
  PutPixel(X+2, Y+13, aCanvas, clWhite);
  PutPixel(X+3, Y+13, aCanvas, clWhite);
  PutPixel(X+4, Y+13, aCanvas, clWhite);
  PutPixel(X+5, Y+13, aCanvas, clWhite);
  PutPixel(X+6, Y+13, aCanvas, clWhite);
  PutPixel(X+7, Y+13, aCanvas, clWhite);
  PutPixel(X+8, Y+13, aCanvas, $00949A94);
  PutPixel(X+9, Y+13, aCanvas, clBlack);
  PutPixel(X+1, Y+14, aCanvas, clBlack);
  PutPixel(X+2, Y+14, aCanvas, $00F7F7F7);
  PutPixel(X+3, Y+14, aCanvas, clWhite);
  PutPixel(X+4, Y+14, aCanvas, clWhite);
  PutPixel(X+5, Y+14, aCanvas, clWhite);
  PutPixel(X+6, Y+14, aCanvas, clWhite);
  PutPixel(X+7, Y+14, aCanvas, $00949A94);
  PutPixel(X+8, Y+14, aCanvas, clBlack);
  PutPixel(X+1, Y+15, aCanvas, clBlack);
  PutPixel(X+2, Y+15, aCanvas, clBlack);
  PutPixel(X+3, Y+15, aCanvas, clBlack);
  PutPixel(X+4, Y+15, aCanvas, clBlack);
  PutPixel(X+5, Y+15, aCanvas, clBlack);
  PutPixel(X+6, Y+15, aCanvas, clBlack);
  PutPixel(X+7, Y+15, aCanvas, clBlack);
end;

procedure TTriadCard.Draw10(X, Y: Integer; aCanvas: TCanvas);
begin
  PutPixel(X+4, Y+0, aCanvas, clBlack);
  PutPixel(X+5, Y+0, aCanvas, clBlack);
  PutPixel(X+6, Y+0, aCanvas, clBlack);
  PutPixel(X+7, Y+0, aCanvas, clBlack);
  PutPixel(X+8, Y+0, aCanvas, clBlack);
  PutPixel(X+9, Y+0, aCanvas, clBlack);
  PutPixel(X+10, Y+0, aCanvas, clBlack);
  PutPixel(X+4, Y+1, aCanvas, clBlack);
  PutPixel(X+5, Y+1, aCanvas, clWhite);
  PutPixel(X+6, Y+1, aCanvas, clWhite);
  PutPixel(X+7, Y+1, aCanvas, clWhite);
  PutPixel(X+8, Y+1, aCanvas, clWhite);
  PutPixel(X+9, Y+1, aCanvas, clWhite);
  PutPixel(X+10, Y+1, aCanvas, clBlack);
  PutPixel(X+4, Y+2, aCanvas, clBlack);
  PutPixel(X+5, Y+2, aCanvas, clWhite);
  PutPixel(X+6, Y+2, aCanvas, clWhite);
  PutPixel(X+7, Y+2, aCanvas, clWhite);
  PutPixel(X+8, Y+2, aCanvas, clWhite);
  PutPixel(X+9, Y+2, aCanvas, clWhite);
  PutPixel(X+10, Y+2, aCanvas, clBlack);
  PutPixel(X+3, Y+3, aCanvas, clBlack);
  PutPixel(X+4, Y+3, aCanvas, $00949A94);
  PutPixel(X+5, Y+3, aCanvas, clWhite);
  PutPixel(X+6, Y+3, aCanvas, clWhite);
  PutPixel(X+7, Y+3, aCanvas, clWhite);
  PutPixel(X+8, Y+3, aCanvas, clWhite);
  PutPixel(X+9, Y+3, aCanvas, clWhite);
  PutPixel(X+10, Y+3, aCanvas, $00949A94);
  PutPixel(X+11, Y+3, aCanvas, clBlack);
  PutPixel(X+3, Y+4, aCanvas, clBlack);
  PutPixel(X+4, Y+4, aCanvas, clWhite);
  PutPixel(X+5, Y+4, aCanvas, clWhite);
  PutPixel(X+6, Y+4, aCanvas, clWhite);
  PutPixel(X+7, Y+4, aCanvas, clWhite);
  PutPixel(X+8, Y+4, aCanvas, clWhite);
  PutPixel(X+9, Y+4, aCanvas, clWhite);
  PutPixel(X+10, Y+4, aCanvas, clWhite);
  PutPixel(X+11, Y+4, aCanvas, clBlack);
  PutPixel(X+3, Y+5, aCanvas, clBlack);
  PutPixel(X+4, Y+5, aCanvas, clWhite);
  PutPixel(X+5, Y+5, aCanvas, clWhite);
  PutPixel(X+6, Y+5, aCanvas, clWhite);
  PutPixel(X+7, Y+5, aCanvas, clBlack);
  PutPixel(X+8, Y+5, aCanvas, clWhite);
  PutPixel(X+9, Y+5, aCanvas, clWhite);
  PutPixel(X+10, Y+5, aCanvas, clWhite);
  PutPixel(X+11, Y+5, aCanvas, clBlack);
  PutPixel(X+2, Y+6, aCanvas, clBlack);
  PutPixel(X+3, Y+6, aCanvas, $00949A94);
  PutPixel(X+4, Y+6, aCanvas, clWhite);
  PutPixel(X+5, Y+6, aCanvas, clWhite);
  PutPixel(X+6, Y+6, aCanvas, clWhite);
  PutPixel(X+7, Y+6, aCanvas, clBlack);
  PutPixel(X+8, Y+6, aCanvas, clWhite);
  PutPixel(X+9, Y+6, aCanvas, clWhite);
  PutPixel(X+10, Y+6, aCanvas, clWhite);
  PutPixel(X+11, Y+6, aCanvas, $00949A94);
  PutPixel(X+12, Y+6, aCanvas, clBlack);
  PutPixel(X+2, Y+7, aCanvas, clBlack);
  PutPixel(X+3, Y+7, aCanvas, clWhite);
  PutPixel(X+4, Y+7, aCanvas, clWhite);
  PutPixel(X+5, Y+7, aCanvas, clWhite);
  PutPixel(X+6, Y+7, aCanvas, $00949A94);
  PutPixel(X+7, Y+7, aCanvas, clBlack);
  PutPixel(X+8, Y+7, aCanvas, $00949A94);
  PutPixel(X+9, Y+7, aCanvas, clWhite);
  PutPixel(X+10, Y+7, aCanvas, clWhite);
  PutPixel(X+11, Y+7, aCanvas, clWhite);
  PutPixel(X+12, Y+7, aCanvas, clBlack);
  PutPixel(X+2, Y+8, aCanvas, clBlack);
  PutPixel(X+3, Y+8, aCanvas, clWhite);
  PutPixel(X+4, Y+8, aCanvas, clWhite);
  PutPixel(X+5, Y+8, aCanvas, clWhite);
  PutPixel(X+6, Y+8, aCanvas, clBlack);
  PutPixel(X+8, Y+8, aCanvas, clBlack);
  PutPixel(X+9, Y+8, aCanvas, clWhite);
  PutPixel(X+10, Y+8, aCanvas, clWhite);
  PutPixel(X+11, Y+8, aCanvas, clWhite);
  PutPixel(X+12, Y+8, aCanvas, clBlack);
  PutPixel(X+1, Y+9, aCanvas, clBlack);
  PutPixel(X+2, Y+9, aCanvas, $00949A94);
  PutPixel(X+3, Y+9, aCanvas, clWhite);
  PutPixel(X+4, Y+9, aCanvas, clWhite);
  PutPixel(X+5, Y+9, aCanvas, clWhite);
  PutPixel(X+6, Y+9, aCanvas, clBlack);
  PutPixel(X+7, Y+9, aCanvas, clBlack);
  PutPixel(X+8, Y+9, aCanvas, clBlack);
  PutPixel(X+9, Y+9, aCanvas, clWhite);
  PutPixel(X+10, Y+9, aCanvas, clWhite);
  PutPixel(X+11, Y+9, aCanvas, clWhite);
  PutPixel(X+12, Y+9, aCanvas, $00949A94);
  PutPixel(X+13, Y+9, aCanvas, clBlack);
  PutPixel(X+1, Y+10, aCanvas, clBlack);
  PutPixel(X+2, Y+10, aCanvas, clWhite);
  PutPixel(X+3, Y+10, aCanvas, clWhite);
  PutPixel(X+4, Y+10, aCanvas, clWhite);
  PutPixel(X+5, Y+10, aCanvas, clWhite);
  PutPixel(X+6, Y+10, aCanvas, clWhite);
  PutPixel(X+7, Y+10, aCanvas, clWhite);
  PutPixel(X+8, Y+10, aCanvas, clWhite);
  PutPixel(X+9, Y+10, aCanvas, clWhite);
  PutPixel(X+10, Y+10, aCanvas, clWhite);
  PutPixel(X+11, Y+10, aCanvas, clWhite);
  PutPixel(X+12, Y+10, aCanvas, clWhite);
  PutPixel(X+13, Y+10, aCanvas, clBlack);
  PutPixel(X+1, Y+11, aCanvas, clBlack);
  PutPixel(X+2, Y+11, aCanvas, clWhite);
  PutPixel(X+3, Y+11, aCanvas, clWhite);
  PutPixel(X+4, Y+11, aCanvas, clWhite);
  PutPixel(X+5, Y+11, aCanvas, clWhite);
  PutPixel(X+6, Y+11, aCanvas, clWhite);
  PutPixel(X+7, Y+11, aCanvas, clWhite);
  PutPixel(X+8, Y+11, aCanvas, clWhite);
  PutPixel(X+9, Y+11, aCanvas, clWhite);
  PutPixel(X+10, Y+11, aCanvas, clWhite);
  PutPixel(X+11, Y+11, aCanvas, clWhite);
  PutPixel(X+12, Y+11, aCanvas, clWhite);
  PutPixel(X+13, Y+11, aCanvas, clBlack);
  PutPixel(X+0, Y+12, aCanvas, clBlack);
  PutPixel(X+1, Y+12, aCanvas, $00949A94);
  PutPixel(X+2, Y+12, aCanvas, clWhite);
  PutPixel(X+3, Y+12, aCanvas, clWhite);
  PutPixel(X+4, Y+12, aCanvas, clWhite);
  PutPixel(X+5, Y+12, aCanvas, clBlack);
  PutPixel(X+6, Y+12, aCanvas, clBlack);
  PutPixel(X+7, Y+12, aCanvas, clBlack);
  PutPixel(X+8, Y+12, aCanvas, clBlack);
  PutPixel(X+9, Y+12, aCanvas, clBlack);
  PutPixel(X+10, Y+12, aCanvas, clWhite);
  PutPixel(X+11, Y+12, aCanvas, clWhite);
  PutPixel(X+12, Y+12, aCanvas, clWhite);
  PutPixel(X+13, Y+12, aCanvas, $00949A94);
  PutPixel(X+14, Y+12, aCanvas, clBlack);
  PutPixel(X+0, Y+13, aCanvas, clBlack);
  PutPixel(X+1, Y+13, aCanvas, clWhite);
  PutPixel(X+2, Y+13, aCanvas, clWhite);
  PutPixel(X+3, Y+13, aCanvas, clWhite);
  PutPixel(X+4, Y+13, aCanvas, clWhite);
  PutPixel(X+5, Y+13, aCanvas, clBlack);
  PutPixel(X+9, Y+13, aCanvas, clBlack);
  PutPixel(X+10, Y+13, aCanvas, clWhite);
  PutPixel(X+11, Y+13, aCanvas, clWhite);
  PutPixel(X+12, Y+13, aCanvas, clWhite);
  PutPixel(X+13, Y+13, aCanvas, clWhite);
  PutPixel(X+14, Y+13, aCanvas, clBlack);
  PutPixel(X+0, Y+14, aCanvas, clBlack);
  PutPixel(X+1, Y+14, aCanvas, clWhite);
  PutPixel(X+2, Y+14, aCanvas, clWhite);
  PutPixel(X+3, Y+14, aCanvas, clWhite);
  PutPixel(X+4, Y+14, aCanvas, clWhite);
  PutPixel(X+5, Y+14, aCanvas, clBlack);
  PutPixel(X+9, Y+14, aCanvas, clBlack);
  PutPixel(X+10, Y+14, aCanvas, clWhite);
  PutPixel(X+11, Y+14, aCanvas, clWhite);
  PutPixel(X+12, Y+14, aCanvas, clWhite);
  PutPixel(X+13, Y+14, aCanvas, clWhite);
  PutPixel(X+14, Y+14, aCanvas, clBlack);
  PutPixel(X+0, Y+15, aCanvas, clBlack);
  PutPixel(X+1, Y+15, aCanvas, clBlack);
  PutPixel(X+2, Y+15, aCanvas, clBlack);
  PutPixel(X+3, Y+15, aCanvas, clBlack);
  PutPixel(X+4, Y+15, aCanvas, clBlack);
  PutPixel(X+5, Y+15, aCanvas, clBlack);
  PutPixel(X+9, Y+15, aCanvas, clBlack);
  PutPixel(X+10, Y+15, aCanvas, clBlack);
  PutPixel(X+11, Y+15, aCanvas, clBlack);
  PutPixel(X+12, Y+15, aCanvas, clBlack);
  PutPixel(X+13, Y+15, aCanvas, clBlack);
  PutPixel(X+14, Y+15, aCanvas, clBlack);
end;

procedure TTriadCard.PutPixel(X, Y: Integer; aCanvas: TCanvas;
  aColor: TColor);
begin
  aCanvas.Pixels[X,Y] := aColor;
end;

end.
