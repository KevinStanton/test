//------------------------------------------------------------------------------
//
// asSpeedButton
//
// This was created to replace the curent SpeedButton.
// It Descends from TCustomLabel to get features such as word wrap.
// Layout can move the text to the top, bottom or center.
// Alignmnet can move text left, right or center.
// An image can be assigned and placed on the left, top, bottom, or right
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
//   -Added an option to Blend the Color of the Border.
//   -Added an Option Make it spin through the owner components and unselect them
//   -No longer Paints the Selected color if button is disabled.
//   -Added Offsets To move Text a few pixels. This is mainly usefull if you
//      have buttons on top of each other. If one has an Icon, and the other doesn't,
//      then you can set an offset on the button without an icon to make the text lineup.
//   -Added The Option to turn off Raising the Image On Mouse Over
//   -Added Image Shadow to Delphi 5
//------------------------------------------------------------------------------
unit asSpeedButton;

interface

uses Controls, Classes, Graphics, Windows, Messages, stdCtrls, ImgList, ActnList;

{$I asInclude.inc}

type
	TasSpeedButton = class;
  TImageLayout = (ilLeft, ilRight, ilTop, ilBottom);

  TOffSets = class(TPersistent)
  private
		FOwner: TasSpeedButton;
    FBottom: Integer;
    FTop: Integer;
    FLeft: Integer;
    FRight: Integer;
    procedure SetBottom(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetRight(const Value: Integer);
    procedure SetTop(const Value: Integer);
  public
		constructor Create(AOwner: TasSpeedButton);
  published
    property Top: Integer read FTop write SetTop;
    property Left: Integer read FLeft write SetLeft;
    property Right: Integer read FRight write SetRight;
    property Bottom: Integer read FBottom write SetBottom;
  end;

	TOptions = class(TPersistent)
  private
		FOwner: TasSpeedButton;
    FColor: TColor;
    FHighlightColor: TColor;
    FShadowColor: TColor;
    FBorderWidth: Integer;
    FFontColor: TColor;
    procedure SetColor(const Value: TColor);
    procedure SetHighlightColor(const Value: TColor);
    procedure SetShadowColor(const Value: TColor);
    procedure SetBorderWidth(const Value: Integer);
    procedure SetFontColor(const Value: TColor);
	public
		constructor Create(AOwner: TasSpeedButton);
	published
		property Color: TColor read FColor write SetColor;
    property FontColor: TColor read FFontColor Write SetFontColor;    
		property HighlightColor: TColor read FHighlightColor write SetHighlightColor;
		property ShadowColor: TColor read FShadowColor write SetShadowColor;
		property BorderWidth: Integer read FBorderWidth write SetBorderWidth;
  end;

	TasSpeedButton = class(TCustomLabel)
  private
    FOffSets: TOffSets;
    FOptionsSelected: TOptions;
    FOptionsUnSelected: TOptions;
    FOptionsDown: TOptions;
    FWordWrap: Boolean;
    FAlignment: TAlignment;
    FOnClick: TNotifyEvent;
    FBlendBorder: Boolean;
    FImages: TCustomImageList;
    FImageIndex: Integer;
    FImageLayout: TImageLayout;
    FLayout: TTextLayout;
    FOnDblClick: TNotifyEvent;
    FAutoUnSelect: Boolean;
    FRaiseSelectedImage: Boolean;
    procedure WMLBUTTONDOWN(var Message: TWMLBUTTONDOWN); message WM_LBUTTONDOWN;
    procedure WMRBUTTONDOWN(var Message: TWMRBUTTONDOWN); message WM_RBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMLBUTTONUP(var Message: TWMLBUTTONUP); message WM_LBUTTONUP;
    procedure WMMOUSEMOVE(var Message: TWMMOUSEMOVE); message WM_MOUSEMOVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;

    procedure PaintMouseDown;
    procedure PaintSelected;
    procedure PaintUnSelected;
    procedure PaintImage;
    procedure PaintText;
    procedure DoDraw_Text(var Rect: TRect; Flags: Longint; aColor: TColor); dynamic;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetWordWrap(const Value: Boolean);
    function  IsOnClickStored: Boolean;
    function  IsOnDblClickStored: Boolean;
    procedure SetBlendBorder(const Value: Boolean);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetImageIndex(const Value: Integer);
    procedure SetImageLayout(const Value: TImageLayout);
    procedure SetLayout(const Value: TTextLayout);

    procedure UnSelectOtherControls;
    procedure SetAutoUnSelect(const Value: Boolean);
  protected
    procedure Paint; override;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
  public
    isSelected: Boolean;
    isDown: Boolean;
    constructor Create(AComponent: TComponent); override;
    destructor Destroy; override;
  published
    property Action;
    property Align;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property AutoUnSelect: Boolean read FAutoUnSelect write SetAutoUnSelect;
    property BlendBorder: Boolean read FBlendBorder write SetBlendBorder;
    property Caption;
    property Enabled;
    property Font;
    property Images: TCustomImageList read FImages write SetImages;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property ImageLayout: TImageLayout read FImageLayout write SetImageLayout;
    property Layout: TTextLayout read FLayout write SetLayout default tlCenter;
    property OnClick: TNotifyEvent read FOnClick write FOnClick stored IsOnClickStored;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick stored IsOnDblClickStored;
    {$IFDEF D6ORHIGHER}
    property OnMouseEnter;
    property OnMouseLeave;
    {$ENDIF}
    property OffSets: TOffSets read FOffSets write FOffSets;
    property OptionsSelected: TOptions read FOptionsSelected write FOptionsSelected;
    property OptionsUnSelected: TOptions read FOptionsUnSelected write FOptionsUnSelected;
    property OptionsDown: TOptions read FOptionsDown write FOptionsDown;
    property PopUpMenu;
    property ShowHint;    
    property RaiseSelectedImage: Boolean read FRaiseSelectedImage write FRaiseSelectedImage;
    property Visible;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
  end;

function  BlendRGB(const Color1, Color2: TColor; const Blend: Integer): TColor;

implementation

uses {$IFDEF D6ORHIGHER}Types, {$ENDIF}Dialogs;

function  BlendRGB(const Color1, Color2: TColor; const Blend: Integer): TColor;
type
  TColorBytes = array[0..3] of Byte;
var
  I: Integer;
begin
  {
  Blends Color1 and Color2.
  Blend must be between 0 and 63;
  0 = all Color1,
  63 = all Color2.
  }
  Result := 0;
  for I := 0 to 2 do
    TColorBytes(Result)[I] := Integer(TColorBytes(Color1)[I] +
      ((TColorBytes(Color2)[I] - TColorBytes(Color1)[I]) * Blend) div 63);
end;

{ TasSpeedButton }

procedure TasSpeedButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited;
  if Sender is TCustomAction then
  begin
    ImageIndex := TCustomAction(Sender).ImageIndex;
    OnClick := TCustomAction(Sender).OnExecute;
  end;
end;

procedure TasSpeedButton.CMFontChanged(var Message: TMessage);
begin
  inherited;
  if OptionsSelected.FontColor = Canvas.Font.Color then
    OptionsSelected.FontColor := Font.Color;
  if OptionsUnSelected.FontColor = Canvas.Font.Color then
    OptionsUnSelected.FontColor := Font.Color;
  if OptionsDown.FontColor = Canvas.Font.Color then
    OptionsDown.FontColor := Font.Color;
end;

procedure TasSpeedButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  {  UnSelect All Other Controls  }
  UnSelectOtherControls;
  {          End UnSelect         }
  if csDesigning in ComponentState then exit;
  isSelected := True;
  PaintSelected;
end;

procedure TasSpeedButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  isSelected := False;
  isDown := False;
  PaintUnSelected;
end;

constructor TasSpeedButton.Create(AComponent: TComponent);
begin
	inherited Create(AComponent);
  BlendBorder := False;
  AutoSize := False;
  isSelected := False;
  isDown := False;
  ImageIndex := -1;

  RaiseSelectedImage := True;

  FOffSets := TOffSets.Create(Self);
  OffSets.Top := 2;
  OffSets.Left := 2;
  OffSets.Right := 2;
  OffSets.Bottom := 2;

  FOptionsSelected := TOptions.Create(Self);
  FOptionsSelected.Color := $00DEB6B5;
  FOptionsSelected.HighlightColor := $00840000;
  FOptionsSelected.ShadowColor := $00840000;
  FOptionsSelected.BorderWidth := 1;
  FOptionsSelected.FontColor := clWindowText;

  FOptionsUnSelected := TOptions.Create(Self);
  FOptionsUnSelected.Color := clBtnFace;
  FOptionsUnSelected.HighlightColor := clWhite;
  FOptionsUnSelected.ShadowColor := clBlack;
  FOptionsUnSelected.BorderWidth := 1;
  FOptionsunSelected.FontColor := clWindowText;

  FOptionsDown := TOptions.Create(Self);
  FOptionsDown.Color := $00BD8684;
  FOptionsDown.HighlightColor := $00840000;
  FOptionsDown.ShadowColor := $00840000;
  FOptionsDown.BorderWidth := 1;
  FOptionsDown.FontColor := clWhite;

  Layout := tlCenter;
  Height := 25;
  Width := 75;
end;

destructor TasSpeedButton.Destroy;
begin
  inherited;
end;

procedure TasSpeedButton.DoDraw_Text(var Rect: TRect; Flags: Integer; aColor: TColor);
var
  Text: string;
  FShowAccelChar: Boolean;
begin
  FShowAccelChar := True;
  Text := GetLabelText;
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or FShowAccelChar and
    (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
  if not FShowAccelChar then Flags := Flags or DT_NOPREFIX;
  Flags := DrawTextBiDiModeFlags(Flags);
  Canvas.Font := Font;
  Canvas.Font.Color := aColor;
  if not Enabled then
  begin
    OffsetRect(Rect, 1, 1);
    Canvas.Font.Color := clBtnHighlight;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
    OffsetRect(Rect, -1, -1);
    Canvas.Font.Color := clBtnShadow;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end
  else
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
end;

function TasSpeedButton.IsOnClickStored: Boolean;
begin
  Result := @FOnClick <> nil;
end;

function TasSpeedButton.IsOnDblClickStored: Boolean;
begin
  Result := @FOnDblClick <> nil;
end;

procedure TasSpeedButton.Paint;
begin
  inherited;
  Canvas.Brush.Style := bsSolid;
  if isSelected then
    PaintSelected
  else
    PaintUnSelected;

  PaintText;
end;

procedure TasSpeedButton.PaintImage;
var
  aLeft: Integer;
  aTop: Integer;
begin
  {Draw Image}
  if Images <> nil then
  begin
    if ImageIndex >= 0 then
    begin
      if ImageIndex < Images.Count then
      begin
        if ImageLayout = ilLeft then
          aLeft := 2
        else if ImageLayout = ilRight then
          aLeft := Width - Images.Width - 2
        else if ImageLayout = ilTop then
          aLeft := ((Width - Images.Width)div 2) - 2
        else
          aLeft := ((Width - Images.Width)div 2) - 2;
        if Enabled then
        begin
          if RaiseSelectedImage then
            if isSelected then
              aLeft := aLeft -1;
        end;

        if ImageLayout = ilLeft then
          aTop := (Height - Images.Height) div 2
        else if ImageLayout = ilRight then
          aTop := (Height - Images.Height) div 2
        else if ImageLayout = ilTop then
          aTop := 2
        else 
          aTop := Height - Images.Height - 2;

        if Enabled then
        begin
          if RaiseSelectedImage then
            if isSelected then
              aTop := aTop - 1;
        end;

        if Enabled then
        begin
          if RaiseSelectedImage then
            if isSelected then
            begin
              Canvas.Brush.Color := clWhite;
              Canvas.Font.Color := clBtnShadow;
              Images.Draw(Canvas,aLeft+2,aTop+2,ImageIndex,dsTransparent,itMask);
            end;
        end;

        Images.Draw(Canvas,aLeft,aTop,ImageIndex,Enabled);
      end;
    end;
  end;
end;

procedure TasSpeedButton.PaintMouseDown;
var
  TempRect: TRect;
  I, bWidth: Integer;
begin
  bWidth := OptionsDown.BorderWidth;
  if bWidth > (Width div 2) then
    bWidth := (Width div 2);
  if bWidth > (Height div 2) then
    bWidth := (Height div 2);
    
  {Main Color}
  TempRect := ClientRect;
  InflateRect(TempRect,-bWidth,-bWidth);
  Canvas.Brush.Color := OptionsDown.Color;
  Canvas.FillRect(TempRect);

  I := 0;
  While I < bWidth do
  begin
    {Top Highlight}
    TempRect.Left := I;
    TempRect.Right := ClientRect.Right - I;
    TempRect.Top := I;
    TempRect.Bottom := I + 1;
    if ((BlendBorder) and (I > 0)) then
      Canvas.Brush.Color := (BlendRGB(ColorToRGB(OptionsDown.FHighlightColor),ColorToRGB(OptionsDown.FColor),Round((62 / bWidth)*I))  or $02000000)
    else
      Canvas.Brush.Color := OptionsDown.FHighlightColor;
    Canvas.FillRect(TempRect);

    {Left Highlight}
    TempRect.Left := I;
    TempRect.Right := I + 1;
    TempRect.Top := I;
    TempRect.Bottom := ClientRect.Bottom - I;
    Canvas.FillRect(TempRect);

    {Bottom Shadow}
    TempRect.Left := I;
    TempRect.Right := ClientRect.Right - I;
    TempRect.Top := ClientRect.Bottom -I - 1;
    TempRect.Bottom := ClientRect.Bottom - I;
    if ((BlendBorder) and (I > 0)) then
      Canvas.Brush.Color := (BlendRGB(ColorToRGB(OptionsDown.FShadowColor),ColorToRGB(OptionsDown.FColor),Round((62 / bWidth)*I))  or $02000000)
    else
      Canvas.Brush.Color := OptionsDown.FShadowColor;
    Canvas.FillRect(TempRect);

    {Right Shadow}
    TempRect.Left := ClientRect.Right - I - 1;
    TempRect.Right := ClientRect.Right - I;
    TempRect.Top := I;
    TempRect.Bottom := ClientRect.Bottom - I;
    Canvas.FillRect(TempRect);

    I := I + 1;
  end;
  PaintImage;
  PaintText;  
end;

procedure TasSpeedButton.PaintSelected;
var
  TempRect: TRect;
  I, bWidth: Integer;
begin
  if not Enabled then
  begin
    PaintUnSelected;
    exit;
  end else
  if isDown then
  begin
    PaintMouseDown;
    exit;
  end;

  bWidth := OptionsSelected.BorderWidth;
  if bWidth > (Width div 2) then
    bWidth := (Width div 2);
  if bWidth > (Height div 2) then
    bWidth := (Height div 2);
        
  {Main Color}
  TempRect := ClientRect;
  InflateRect(TempRect, -bWidth, -bWidth);
  Canvas.Brush.Color := OptionsSelected.Color;
  Canvas.FillRect(TempRect);

  I := 0;
  While I < bWidth do
  begin
    {Top Highlight}
    TempRect.Left := I;
    TempRect.Right := ClientRect.Right - I;
    TempRect.Top := I;
    TempRect.Bottom := I + 1;
    if ((BlendBorder) and (I > 0)) then
      Canvas.Brush.Color := (BlendRGB(ColorToRGB(OptionsSelected.FHighlightColor),ColorToRGB(OptionsSelected.FColor),Round((62 / bWidth)*I))  or $02000000)
    else
      Canvas.Brush.Color := OptionsSelected.FHighlightColor;
    Canvas.FillRect(TempRect);

    {Left Highlight}
    TempRect.Left := I;
    TempRect.Right := I + 1;
    TempRect.Top := I;
    TempRect.Bottom := ClientRect.Bottom - I;
    Canvas.FillRect(TempRect);

    {Bottom Shadow}
    TempRect.Left := I;
    TempRect.Right := ClientRect.Right - I;
    TempRect.Top := ClientRect.Bottom -I - 1;
    TempRect.Bottom := ClientRect.Bottom - I;
    if ((BlendBorder) and (I > 0)) then
      Canvas.Brush.Color := (BlendRGB(ColorToRGB(OptionsSelected.FShadowColor),ColorToRGB(OptionsSelected.FColor),Round((62 / bWidth)*I))  or $02000000)
    else
      Canvas.Brush.Color := OptionsSelected.FShadowColor;
    Canvas.FillRect(TempRect);

    {Right Shadow}
    TempRect.Left := ClientRect.Right - I - 1;
    TempRect.Right := ClientRect.Right - I;
    TempRect.Top := I;
    TempRect.Bottom := ClientRect.Bottom - I;
    Canvas.FillRect(TempRect);

  I := I + 1;
  end;
  PaintImage;
  PaintText;  
end;

procedure TasSpeedButton.PaintText;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  Rect, CalcRect, NewRect: TRect;
  DrawStyle: Longint;
  UseNewRect: Boolean;
  aColor: TColor;
begin
  if isDown then
    aColor := OptionsDown.FontColor
  else if isSelected then
    aColor := OptionsSelected.FontColor
  else
    aColor := OptionsUnSelected.FontColor;

  Rect.Top := ClientRect.Top + OffSets.Top;
  Rect.Left := ClientRect.Left + OffSets.Left;
  Rect.Right := ClientRect.Right + OffSets.Right;
  Rect.Bottom := ClientRect.Bottom + OffSets.Bottom;

  UseNewRect := False;
  if Images <> nil then
  begin
    if ImageIndex >= 0 then
    begin
      if ImageIndex < Images.Count then
      begin
        if ImageLayout = ilLeft then
          Rect.Left := Rect.Left + Images.Width + 4
        else if ImageLayout = ilRight then
          Rect.Right := Width - Images.Width - 4
        else if ImageLayout = ilTop then
          Rect.Top := Images.Height + 2
        else
          Rect.Bottom := Height - Images.Height - 4;
      end
    end;
  end;

  Canvas.Brush.Style := bsClear;

  { DoDrawText takes care of BiDi alignments }
  DrawStyle := DT_EXPANDTABS or WordWraps[FWordWrap] or Alignments[FAlignment];

  { Calculate vertical layout }
  if Layout <> tlTop then
  begin
    CalcRect := Rect;

    DoDraw_Text(CalcRect, DrawStyle or DT_CALCRECT, aColor);
    if Layout = tlBottom then
    begin
      if Images = nil then
        OffsetRect(Rect, 0, Height - CalcRect.Bottom)
      else
      begin
        if ImageLayout = ilBottom then
          OffsetRect(Rect, 0, (Rect.Bottom - Rect.Top) - CalcRect.Bottom)
        else
          OffsetRect(Rect, 0, Height - CalcRect.Bottom)
      end;
    end else
    begin
      if Images = nil then
        OffsetRect(Rect, 0, (Height - CalcRect.Bottom) div 2)
      else
      begin
        if ImageLayout = ilBottom then
        begin
          if ((((Height - CalcRect.Bottom) div 2)+CalcRect.Bottom) < Rect.Bottom) then
          begin
            UseNewRect := True;
            NewRect.Left   := Rect.Left;
            NewRect.Right  := Rect.Right;
            NewRect.Top    := 0;
            NewRect.Bottom := Height;
            OffsetRect(NewRect, 0, (Height - CalcRect.Bottom) div 2)
          end else
            OffsetRect(Rect, 0, Rect.Bottom - CalcRect.Bottom)
        end else
        if ImageLayout = ilTop then
        begin
          if (((Height - CalcRect.Bottom) div 2) > Rect.Top) then
          begin
            UseNewRect := True;
            NewRect.Left   := Rect.Left;
            NewRect.Right  := Rect.Right;
            NewRect.Top    := 0;
            NewRect.Bottom := Height;
            OffsetRect(NewRect, 0, (Height - CalcRect.Bottom) div 2)
          end else
            OffsetRect(Rect, 0, 0);
        end else
          OffsetRect(Rect, 0, (Height - CalcRect.Bottom) div 2);
      end;
    end;
  end;
  if UseNewRect then
    DoDraw_Text(NewRect,DrawStyle,aColor)
  else
    DoDraw_Text(Rect,DrawStyle,aColor);
end;

procedure TasSpeedButton.PaintUnSelected;
var
  TempRect: TRect;
  I, bWidth: Integer;
begin
  bWidth := OptionsUnSelected.BorderWidth;
  if bWidth > (Width div 2) then
    bWidth := (Width div 2);
  if bWidth > (Height div 2) then
    bWidth := (Height div 2);
    
  {Main Color}
  TempRect := ClientRect;
  InflateRect(TempRect,-bWidth,-bWidth);
  Canvas.Brush.Color := OptionsUnSelected.Color;
  Canvas.FillRect(TempRect);

  I := 0;
  While I < bWidth do
  begin
    {Top Highlight}
    TempRect.Left := I;
    TempRect.Right := ClientRect.Right - I;
    TempRect.Top := I;
    TempRect.Bottom := I + 1;
    if ((BlendBorder) and (I > 0)) then
      Canvas.Brush.Color := (BlendRGB(ColorToRGB(OptionsUnSelected.FHighlightColor),ColorToRGB(OptionsUnSelected.FColor),Round((62 / bWidth)*I))  or $02000000)
    else
      Canvas.Brush.Color := OptionsUnSelected.FHighlightColor;
    Canvas.FillRect(TempRect);

    {Left Highlight}
    TempRect.Left := I;
    TempRect.Right := I + 1;
    TempRect.Top := I;
    TempRect.Bottom := ClientRect.Bottom - I;
    Canvas.FillRect(TempRect);

    {Bottom Shadow}
    TempRect.Left := I;
    TempRect.Right := ClientRect.Right - I;
    TempRect.Top := ClientRect.Bottom -I - 1;
    TempRect.Bottom := ClientRect.Bottom - I;
    if ((BlendBorder) and (I > 0)) then
      Canvas.Brush.Color := (BlendRGB(ColorToRGB(OptionsUnSelected.FShadowColor),ColorToRGB(OptionsUnSelected.FColor),Round((62 / bWidth)*I))  or $02000000)
    else
      Canvas.Brush.Color := OptionsUnSelected.FShadowColor;
    Canvas.FillRect(TempRect);

    {Right Shadow}
    TempRect.Left := ClientRect.Right - I - 1;
    TempRect.Right := ClientRect.Right - I;
    TempRect.Top := I;
    TempRect.Bottom := ClientRect.Bottom - I;
    Canvas.FillRect(TempRect);

    I := I + 1;
  end;
  PaintImage;  
  PaintText;
end;

procedure TasSpeedButton.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TasSpeedButton.SetAutoUnSelect(const Value: Boolean);
begin
  if FAutoUnSelect <> Value then
    FAutoUnSelect := Value;
end;

procedure TasSpeedButton.SetBlendBorder(const Value: Boolean);
begin
  if FBlendBorder <> Value then
    FBlendBorder := Value;
end;

procedure TasSpeedButton.SetImageIndex(const Value: Integer);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Invalidate;
  end;
end;

procedure TasSpeedButton.SetImageLayout(const Value: TImageLayout);
begin
  if FImageLayout <> Value then
  begin
    FImageLayout := Value;
    Invalidate;
  end;
end;

procedure TasSpeedButton.SetImages(const Value: TCustomImageList);
begin
  if FImages <> Value then
  begin
    FImages := Value;
    Invalidate;
  end;
end;

procedure TasSpeedButton.SetLayout(const Value: TTextLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TasSpeedButton.SetWordWrap(const Value: Boolean);
begin
  if FWordWrap <> Value then
    FWordWrap := Value;
end;

procedure TasSpeedButton.UnSelectOtherControls;
var
  I: Integer;
begin
  if not AutoUnSelect then exit;
  if Owner = nil then exit;
  I := 0;
  while I < Owner.ComponentCount -1 do
  begin
    if Owner.Components[I].Name <> Name then
    begin
      if Owner.Components[I] is TasSpeedButton then
      begin
        if ((TasSpeedButton(Owner.Components[I]).isSelected)OR
            (TasSpeedButton(Owner.Components[I]).isDown)) then
        begin
          TasSpeedButton(Owner.Components[I]).isSelected := False;
          TasSpeedButton(Owner.Components[I]).isDown := False;
          TasSpeedButton(Owner.Components[I]).Repaint;
        end;
      end;
    end;
    I := I + 1;
  end;
end;

procedure TasSpeedButton.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  inherited;
  isSelected := False;
  isDown := True;
  PaintMouseDown;
  if IsOnDblClickStored then
  begin
    OnDblClick(Self);
  end;
end;

procedure TasSpeedButton.WMLBUTTONDOWN(var Message: TWMLBUTTONDOWN);
begin
  inherited;
  isSelected := False;
  isDown := True;
  PaintMouseDown;
end;

procedure TasSpeedButton.WMLBUTTONUP(var Message: TWMLBUTTONUP);
begin
  inherited;
  isSelected := False;
  isDown := False;
  PaintUnSelected;

  if IsOnClickStored then
  begin
    //Action automatically clicks.....
    if Action = nil then
      OnClick(Self);
  end;
end;

procedure TasSpeedButton.WMMOUSEMOVE(var Message: TWMMOUSEMOVE);
begin
  inherited;
{  if not isSelected then
  begin
    isSelected := True;
    PaintSelected;
  end;  }
end;

procedure TasSpeedButton.WMRBUTTONDOWN(var Message: TWMRBUTTONDOWN);
begin
  if PopUpMenu <> nil then
  begin
    if PopUpMenu.Items.Count > 0 then
    begin
      isSelected := False;
      isDown := False;
      PaintUnSelected;
    end;
  end;

  inherited;
end;

{ TOptions }

constructor TOptions.Create(AOwner: TasSpeedButton);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TOptions.SetBorderWidth(const Value: Integer);
begin
  if FBorderWidth <> Value then
  begin
    FBorderWidth := Value;
    FOwner.Invalidate;
  end;
end;

procedure TOptions.SetColor(const Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    FOwner.invalidate;
  end;
end;

procedure TOptions.SetFontColor(const Value: TColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    FOwner.Invalidate;
  end;
end;

procedure TOptions.SetHighlightColor(const Value: TColor);
begin
  if FHighlightColor  <> Value then
  begin
    FHighlightColor := Value;
    FOwner.invalidate;
  end;
end;

procedure TOptions.SetShadowColor(const Value: TColor);
begin
  if FShadowColor <> Value then
  begin
    FShadowColor := Value;
    FOwner.invalidate;
  end;
end;

{ TOffSets }

constructor TOffSets.Create(AOwner: TasSpeedButton);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TOffSets.SetBottom(const Value: Integer);
begin
  if FBottom <> Value then
  begin
    FBottom := Value;
    FOwner.Invalidate;
  end;
end;

procedure TOffSets.SetLeft(const Value: Integer);
begin
  if FLeft <> Value then
  begin
    FLeft := Value;
    FOwner.Invalidate;
  end;
end;

procedure TOffSets.SetRight(const Value: Integer);
begin
  if FRight <> Value then
  begin
    FRight := Value;
    FOwner.Invalidate;
  end;
end;

procedure TOffSets.SetTop(const Value: Integer);
begin
  if FTop <> Value then
  begin
    FTop := Value;
    FOwner.Invalidate;
  end;
end;

end.
