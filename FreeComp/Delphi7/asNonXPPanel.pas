unit asNonXPPanel;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, ExtCtrls;

type
	TNonXPPanel = class(TCustomPanel)
  protected
    FEndColor: TColor;
		FStartColor: TColor;
    procedure Filler;
    procedure Paint; override;
    function GetTag: LongInt;
    procedure SetTag(Value: LongInt);
  private
    FBorderWidth: Integer;
    FBorderColor: TColor;
    procedure DrawBorder;
    procedure SetBorderColor(const Value: TColor);
    procedure SetBorderWidth(const Value: Integer);
  public
    constructor Create(AComponent: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Canvas;
  published
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth;
    property Align default alNone;
    property Cursor;
    property DragCursor;
		property DragMode;
    property Enabled;
    property Color;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clBlack;
    property Font;
		property Height;
    property HelpContext;
    property Hint;
    property Left;
    property Name;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Top;
    property Tag read GetTag write SetTag;
    property Visible;
    property Width;
    property OnClick;
  end;

var
	MainBackDrop: TNonXPPanel;

implementation

constructor TNonXPPanel.Create(AComponent: TComponent);
begin
	inherited Create(AComponent);
	Align := alNone;
	Color := clBtnFace;
  BorderColor := clBlack;
  BorderWidth := 0;
  Width := 185;
  Height := 41;
  BorderStyle := bsNone;
	{ If no other back drop is the main back drop then make this the main back drop }
	if csDesigning in ComponentState then
		if not Assigned(MainBackDrop) then
			Self.Tag := -1;
end;

destructor TNonXPPanel.Destroy;
begin
	if MainBackDrop = Self then MainBackDrop := Nil;
	inherited Destroy;
end;

procedure TNonXPPanel.Assign(Source: TPersistent);
var
  SBD: TNonXPPanel;
begin
  if Source is TNonXPPanel then begin
    SBD := TNonXPPanel(Source);
    FBorderColor := SBD.BorderColor;
    FBorderWidth := SBD.BorderWidth;
    Align := alNone;
    Invalidate;
//    Repaint;
    Exit;
  end;
  inherited Assign(Source);
end;

function TNonXPPanel.GetTag: LongInt;
begin
  Result := inherited Tag;
end;

procedure TNonXPPanel.SetTag(Value: LongInt);
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

procedure TNonXPPanel.Filler;
var
  vRect: TRect;
begin
  vRect.Left := 0;
  vRect.Top := 0;
  vRect.Right := Width;
  vRect.Bottom := Height;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(vRect);
end;

procedure TNonXPPanel.Paint;
begin
  Filler;
  DrawBorder;
end;

procedure TNonXPPanel.DrawBorder;
var
  aRect: TRect;
begin
  if BorderWidth < 1 then exit;

  Canvas.Brush.Color := BorderColor;
  {Top}
  aRect.Left := 0;
  aRect.Right := Width;
  aRect.Top := 0;
  aRect.Bottom := BorderWidth;
  Canvas.FillRect(aRect);
  {Bottom}
  aRect.Left := 0;
  aRect.Right := Width;
  aRect.Top := Height - BorderWidth;
  aRect.Bottom := Height;
  Canvas.FillRect(aRect);
  {Left}
  aRect.Left := 0;
  aRect.Right := BorderWidth;
  aRect.Top := BorderWidth;
  aRect.Bottom := Height - BorderWidth;
  Canvas.FillRect(aRect);
  {Right}
  aRect.Left := Width;
  aRect.Right := Width - BorderWidth;
  aRect.Top := BorderWidth;
  aRect.Bottom := Height - BorderWidth;
  Canvas.FillRect(aRect);
end;

procedure TNonXPPanel.SetBorderColor(const Value: TColor);
begin
  if Value <> FBorderColor then begin
    FBorderColor := Value;
    Repaint;
	end;
end;

procedure TNonXPPanel.SetBorderWidth(const Value: Integer);
begin
  if Value <> FBorderWidth then begin
    FBorderWidth := Value;
    Repaint;
	end;
end;

end.
