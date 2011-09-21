{------------------------------------------------------------------------------}
{                                                                              }
{  TRotateImage v1.4                                                           }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com                                                   }
{                                                                              }
{------------------------------------------------------------------------------}

{$I DELPHIAREA.INC}
{$R-}

unit RotImg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type

  TRotateImage = class(TGraphicControl)
  private
    FPicture: TPicture;
    FOnProgress: TProgressEvent;
    FStretch: Boolean;
    FCenter: Boolean;
    FIncrementalDisplay: Boolean;
    FTransparent: Boolean;
    FDrawing: Boolean;
    FAngle: Extended;
    {$IFNDEF DELPHI4_UP}
    FAutoSize: Boolean;
    {$ENDIF}
    FUniqueSize: Boolean;
    FRotatedBitmap: TBitmap;
    function GetCanvas: TCanvas;
    procedure PictureChanged(Sender: TObject);
    procedure SetCenter(Value: Boolean);
    procedure SetPicture(Value: TPicture);
    procedure SetStretch(Value: Boolean);
    procedure SetTransparent(Value: Boolean);
    procedure SetAngle(Value: Extended);
    {$IFNDEF DELPHI4_UP}
    procedure SetAutoSize(Value: Boolean);
    {$ENDIF}
    procedure SetUniqueSize(Value: Boolean);
    procedure RebuildRotatedBitmap;
    procedure CMColorChanged(var Msg: TMessage); message CM_COLORCHANGED;
  protected
    {$IFDEF DELPHI4_UP}
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    {$ELSE}
    procedure AdjustSize;
    {$ENDIF}
    function DestRect: TRect;
    function DoPaletteChange: Boolean;
    function GetPalette: HPALETTE; override;
    procedure Paint; override;
    procedure Loaded; override;
    procedure Progress(Sender: TObject; Stage: TProgressStage;
      PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function RotatedPoint(const Pt: TPoint): TPoint;
    property Canvas: TCanvas read GetCanvas;
    property RotatedBitmap: TBitmap read FRotatedBitmap;
  published
    property Align;
    {$IFDEF DELPHI4_UP}
    property Anchors;
    {$ENDIF}
    property Angle: Extended read FAngle write SetAngle;
    {$IFDEF DELPHI4_UP}
    property AutoSize;
    {$ELSE}
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    {$ENDIF}
    property Center: Boolean read FCenter write SetCenter default False;
    property Color;
    {$IFDEF DELPHI4_UP}
    property Constraints;
    {$ENDIF}
    property DragCursor;
    {$IFDEF DELPHI4_UP}
    property DragKind;
    {$ENDIF}
    property DragMode;
    property Enabled;
    property IncrementalDisplay: Boolean read FIncrementalDisplay write FIncrementalDisplay default False;
    property ParentColor;
    property ParentShowHint;
    property Picture: TPicture read FPicture write SetPicture;
    property PopupMenu;
    property ShowHint;
    property Stretch: Boolean read FStretch write SetStretch default False;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property UniqueSize: Boolean read FUniqueSize write SetUniqueSize default True;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    {$IFDEF DELPHI4_UP}
    property OnEndDock;
    {$ENDIF}
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    {$IFDEF DELPHI4_UP}
    property OnStartDock;
    {$ENDIF}
    property OnStartDrag;
  end;

function CreateRotatedBitmap(Bitmap: TBitmap; Angle: Extended; bgColor: TColor): TBitmap;

implementation

uses
  Consts, Math;

// Angle is in degrees.
function CreateRotatedBitmap(Bitmap: TBitmap; Angle: Extended; bgColor: TColor): TBitmap;
{$IFNDEF DELPHI6_UP}
type
  IntegerArray  = array[0..$EFFFFFF] of Integer;
  PIntegerArray = ^IntegerArray;
{$ENDIF}
var
  CosTheta, SinTheta: Extended;
  iCosTheta, iSinTheta: Integer;
  xSrc, ySrc: Integer;
  xDst, yDst: Integer;
  xODst, yODst: Integer;
  xOSrc, yOSrc: Integer;
  xPrime, yPrime: Integer;
  srcWidth, srcHeight: Integer;
  dstWidth, dstHeight: Integer;
  yPrimeSinTheta, yPrimeCosTheta: Integer;
  srcBits: PIntegerArray;
  dstBits: PInteger;
begin
  // Workaround SinCos bug (-180 <= Angle <= +180)
  while Angle > +180.0 do Angle := Angle - 360.0;
  while Angle < -180.0 do Angle := Angle + 360.0;
  // end of workaround SinCos bug
  SinCos(Pi * -Angle / 180.0, SinTheta, CosTheta);
  iSinTheta := Trunc(SinTheta * (1 shl 16));
  iCosTheta := Trunc(CosTheta * (1 shl 16));
  Bitmap.PixelFormat := pf32bit;
  srcWidth := Bitmap.Width;
  srcHeight := Bitmap.Height;
  srcBits := Bitmap.ScanLine[srcHeight-1];
  xOSrc := srcWidth shr 1;
  yOSrc := srcHeight shr 1;
  dstWidth := SmallInt((srcWidth * Abs(iCosTheta) + srcHeight * Abs(iSinTheta)) shr 16);
  dstHeight := SmallInt((srcWidth * Abs(iSinTheta) + srcHeight * Abs(iCosTheta)) shr 16);
  xODst := dstWidth shr 1;
  if ((Angle = 0.0) or (Angle = -90.0)) and not Odd(dstWidth) then
    Dec(xODst);
  yODst := dstHeight shr 1;
  if ((Angle = 0.0) or (Angle = +90.0)) and not Odd(dstHeight) then
    Dec(yODst);
  Result := TBitmap.Create;
  Result.Canvas.Brush.Color := bgColor;
  Result.Width := dstWidth;
  Result.Height := dstHeight;
  Result.PixelFormat := pf32bit;
  dstBits := @(PIntegerArray(Result.ScanLine[0])[dstWidth-1]);
  yPrime := yODst;
  for yDst := dstHeight - 1 downto 0 do
  begin
    yPrimeSinTheta := yPrime * iSinTheta;
    yPrimeCosTheta := yPrime * iCosTheta;
    xPrime := xODst;
    for xDst := dstWidth - 1 downto 0 do
    begin
      xSrc := SmallInt((xPrime * iCosTheta - yPrimeSinTheta) shr 16) + xOSrc;
      ySrc := SmallInt((xPrime * iSinTheta + yPrimeCosTheta) shr 16) + yOSrc;
      {$IFDEF DELPHI4_UP}
      if (DWORD(ySrc) < DWORD(srcHeight)) and (DWORD(xSrc) < DWORD(srcWidth)) then
      {$ELSE} // Delphi 3 compiler ignores unsigned type cast and generates signed comparison code!
      if (ySrc >= 0) and (ySrc < srcHeight) and (xSrc >= 0) and (xSrc < srcWidth) then
      {$ENDIF}
      begin
        dstBits^ := srcBits[ySrc * srcWidth + xSrc];
      end;
      Dec(dstBits);
      Dec(xPrime);
    end;
    Dec(yPrime);
  end;
  Result.HandleType := bmDDB;
end;

// Returns rotated coordinate of a point on the original image
function TRotateImage.RotatedPoint(const Pt: TPoint): TPoint;
var
  Theta, CosTheta, SinTheta: Extended;
  Prime, OrgDst, OrgSrc: TPoint;
begin
  // Workaround SinCos bug (-180 <= Angle <= +180)
  Theta := Angle;
  while Theta > +180.0 do Theta := Theta - 360.0;
  while Theta < -180.0 do Theta := Theta + 360.0;
  // end of workaround SinCos bug
  SinCos(Pi * -Theta / 180, SinTheta, CosTheta);

  OrgDst.X := RotatedBitmap.Width div 2;
  OrgDst.Y := RotatedBitmap.Height div 2;

  OrgSrc.X := Picture.Width div 2;
  OrgSrc.Y := Picture.Height div 2;

  Prime.X := Pt.X - OrgSrc.X;
  Prime.Y := Pt.Y - OrgSrc.Y;

  Result.X := Round(Prime.X * CosTheta - Prime.Y * SinTheta) + OrgDst.X;
  Result.Y := Round(Prime.X * SinTheta + Prime.Y * CosTheta) + OrgDst.Y;
end;

procedure TRotateImage.RebuildRotatedBitmap;
var
  MakeCopy: Boolean;
  OrgBitmap: TBitmap;
  RotBitmap: TBitmap;
  BlindColor: TColor;
  Times360: Extended;
begin
  if (Picture.Width > 0) and (Picture.Height > 0) then
  begin
    MakeCopy := not (Picture.Graphic is TBitmap);
    if MakeCopy then
    begin
      BlindColor := Color;
      OrgBitmap := TBitmap.Create;
      OrgBitmap.Canvas.Brush.Color := BlindColor;
      OrgBitmap.Width := Picture.Width;
      OrgBitmap.Height := Picture.Height;
      OrgBitmap.Canvas.Draw(0, 0, Picture.Graphic);
    end
    else
    begin
      OrgBitmap := Picture.Bitmap;
      BlindColor := OrgBitmap.TransparentColor;
    end;
    Times360 := Angle / 360.0;
    if Int(Times360) <> Times360 then
      RotBitmap := CreateRotatedBitmap(OrgBitmap, Angle, BlindColor)
    else if MakeCopy then
    begin
      RotBitmap := OrgBitmap;
      MakeCopy := False;
    end
    else
    begin
      RotBitmap := TBitmap.Create;
      RotBitmap.Assign(OrgBitmap);
    end;
    if MakeCopy then
      OrgBitmap.Free;
    RotatedBitmap.Free;
    if UniqueSize then
    begin
      FRotatedBitmap := TBitmap.Create;
      RotatedBitmap.Canvas.Brush.Color := BlindColor;
      RotatedBitmap.Width := Round(Sqrt(Sqr(Picture.Width+2) + Sqr(Picture.Height+2)));
      RotatedBitmap.Height := RotatedBitmap.Width;
      if Center then
        RotatedBitmap.Canvas.Draw((RotatedBitmap.Width - RotBitmap.Width) div 2,
          (RotatedBitmap.Height - RotBitmap.Height) div 2, RotBitmap)
      else
        RotatedBitmap.Canvas.Draw(0, 0, RotBitmap);
      RotBitmap.Free;
    end
    else
      FRotatedBitmap := RotBitmap;
    RotatedBitmap.Transparent := Transparent;
    RotatedBitmap.TransparentColor := BlindColor;
  end
  else
  begin
    RotatedBitmap.Width := 0;
    RotatedBitmap.Height := 0;
  end;
  if AutoSize then AdjustSize;
end;

constructor TRotateImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  FPicture.OnProgress := Progress;
  FUniqueSize := True;
  FRotatedBitmap := TBitmap.Create;
  Height := 105;
  Width := 105;
end;

destructor TRotateImage.Destroy;
begin
  Picture.Free;
  RotatedBitmap.Free;
  inherited Destroy;
end;

function TRotateImage.GetPalette: HPALETTE;
begin
  Result := 0;
  if Picture.Graphic <> nil then
    Result := Picture.Graphic.Palette;
end;

function TRotateImage.DestRect: TRect;
begin
  if Stretch then
    Result := ClientRect
  else if Center then
    Result := Bounds((Width - RotatedBitmap.Width) div 2,
                     (Height - RotatedBitmap.Height) div 2,
                      RotatedBitmap.Width, RotatedBitmap.Height)
  else
    Result := Rect(0, 0, RotatedBitmap.Width, RotatedBitmap.Height);
end;

procedure TRotateImage.Paint;
var
  Save: Boolean;
begin
  if not RotatedBitmap.Empty then
  begin
    Save := FDrawing;
    FDrawing := True;
    try
      with inherited Canvas do
        StretchDraw(DestRect, RotatedBitmap);
    finally
      FDrawing := Save;
    end;
  end;
  if csDesigning in ComponentState then
    with inherited Canvas do
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
end;

procedure TRotateImage.Loaded;
begin
  inherited Loaded;
  PictureChanged(Self);
end;

function TRotateImage.DoPaletteChange: Boolean;
var
  ParentForm: TCustomForm;
  G: TGraphic;
begin
  Result := False;
  G := Picture.Graphic;
  if Visible and (not (csLoading in ComponentState)) and
    (G <> nil) and (G.PaletteModified) then
  begin
    if (G.Palette = 0) then
      G.PaletteModified := False
    else
    begin
      ParentForm := GetParentForm(Self);
      if Assigned(ParentForm) and ParentForm.Active and Parentform.HandleAllocated then
      begin
        if FDrawing then
          ParentForm.Perform(WM_QUERYNEWPALETTE, 0, 0)
        else
          PostMessage(ParentForm.Handle, WM_QUERYNEWPALETTE, 0, 0);
        Result := True;
        G.PaletteModified := False;
      end;
    end;
  end;
end;

procedure TRotateImage.Progress(Sender: TObject; Stage: TProgressStage;
  PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string);
begin
  if IncrementalDisplay and RedrawNow then
  begin
    if DoPaletteChange then Update
    else Paint;
  end;
  if Assigned(OnProgress) then OnProgress(Sender, Stage, PercentDone, RedrawNow, R, Msg);
end;

function TRotateImage.GetCanvas: TCanvas;
var
  Bitmap: TBitmap;
begin
  if Picture.Graphic = nil then
  begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.Width := Width;
      Bitmap.Height := Height;
      Picture.Graphic := Bitmap;
    finally
      Bitmap.Free;
    end;
  end;
  if Picture.Graphic is TBitmap then
    Result := TBitmap(Picture.Graphic).Canvas
  else
    raise EInvalidOperation.Create(SImageCanvasNeedsBitmap);
end;

procedure TRotateImage.CMColorChanged(var Msg: TMessage);
begin
  inherited;
  RebuildRotatedBitmap;
end;

procedure TRotateImage.SetCenter(Value: Boolean);
begin
  if Value <> Center then
  begin
    FCenter := Value;
    PictureChanged(Self);
  end;
end;

procedure TRotateImage.SetPicture(Value: TPicture);
begin
  Picture.Assign(Value);
end;

procedure TRotateImage.SetStretch(Value: Boolean);
begin
  if Value <> Stretch then
  begin
    FStretch := Value;
    PictureChanged(Self);
  end;
end;

procedure TRotateImage.SetTransparent(Value: Boolean);
begin
  if Value <> Transparent then
  begin
    FTransparent := Value;
    PictureChanged(Self);
  end;
end;

procedure TRotateImage.SetAngle(Value: Extended);
begin
  if Value <> Angle then
  begin
    FAngle := Value;
    PictureChanged(Self);
  end;
end;

{$IFNDEF DELPHI4_UP}
procedure TRotateImage.SetAutoSize(Value: Boolean);
begin
  if Value <> AutoSize then
  begin
    FAutoSize := Value;
    if FAutoSize then AdjustSize;
  end;
end;
{$ENDIF}

procedure TRotateImage.SetUniqueSize(Value: Boolean);
begin
  if Value <> UniqueSize then
  begin
    FUniqueSize := Value;
    PictureChanged(Self);
  end;
end;

procedure TRotateImage.PictureChanged(Sender: TObject);
var
  G: TGraphic;
begin
  if not (csLoading in ComponentState) then
  begin
    G := Picture.Graphic;
    if G <> nil then
    begin
      if not ((G is TMetaFile) or (G is TIcon)) then
        G.Transparent := FTransparent;
      if (not G.Transparent) and (Stretch or (RotatedBitmap.Width >= Width)
        and (RotatedBitmap.Height >= Height))
      then
        ControlStyle := ControlStyle + [csOpaque]
      else
        ControlStyle := ControlStyle - [csOpaque];
      if DoPaletteChange and FDrawing then Update;
    end
    else
      ControlStyle := ControlStyle - [csOpaque];
    RebuildRotatedBitmap;
    if AutoSize and (Picture.Width > 0) and (Picture.Height > 0) then
      SetBounds(Left, Top, RotatedBitmap.Width, RotatedBitmap.Height);
    if not FDrawing then Invalidate;
  end;
end;

{$IFDEF DELPHI4_UP}
function TRotateImage.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := True;
  if not (csDesigning in ComponentState) or
    (RotatedBitmap.Width > 0) and (RotatedBitmap.Height > 0) then
  begin
    if Align in [alNone, alLeft, alRight] then
      NewWidth := RotatedBitmap.Width;
    if Align in [alNone, alTop, alBottom] then
      NewHeight := RotatedBitmap.Height;
  end;
end;
{$ENDIF}

{$IFNDEF DELPHI4_UP}
procedure TRotateImage.AdjustSize;
begin
  if not (csDesigning in ComponentState) or
    (RotatedBitmap.Width > 0) and (RotatedBitmap.Height > 0) then
  begin
    if Align in [alNone, alLeft, alRight] then
      Width := RotatedBitmap.Width;
    if Align in [alNone, alTop, alBottom] then
      Height := RotatedBitmap.Height;
  end;
end;
{$ENDIF}

end.
