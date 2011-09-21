//------------------------------------------------------------------------------
//
// asBtnPanel
//
// This was created make a QUICK Panel at the Bottom of a form,
// It contains the Following buttons:
//    OK, Cancel, Apply, Close, Help
// They each have an OnClick event.
// Tab order is set Automatically by the order.
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
unit asBtnPanel;

interface

uses StdCtrls, ExtCtrls, Controls, Classes, Forms;

type
	TasBtnPanel = class;

	TButtonOK = class(TPersistent)
  private
		FOwner: TasBtnPanel;
    FCaption: string;
    FModalResult: TModalResult;
    FEnabled: Boolean;
    FVisible: Boolean;
    FOrder: Integer;
    procedure SetCaption(const Value: String);
    procedure SetModalResult(const Value: TModalResult);
    procedure SetEnabled(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure SetOrder(const Value: Integer);
	public
		constructor Create(AOwner: TasBtnPanel);
	published
		property Caption: String read FCaption write SetCaption;
    property Enabled: Boolean read FEnabled write SetEnabled;
		property ModalResult: TModalResult read FModalResult write SetModalResult;
    property Order: Integer read FOrder write SetOrder;
    property Visible: Boolean read FVisible write SetVisible;
  end;

	TButtonClose = class(TPersistent)
  private
		FOwner: TasBtnPanel;
    FCaption: string;
    FModalResult: TModalResult;
    FEnabled: Boolean;
    FVisible: Boolean;
    FOrder: Integer;
    procedure SetCaption(const Value: String);
    procedure SetModalResult(const Value: TModalResult);
    procedure SetEnabled(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure SetOrder(const Value: Integer);
	public
		constructor Create(AOwner: TasBtnPanel);
	published
		property Caption: String read FCaption write SetCaption;
    property Enabled: Boolean read FEnabled write SetEnabled;
		property ModalResult: TModalResult read FModalResult write SetModalResult;
    property Order: Integer read FOrder write SetOrder;
    property Visible: Boolean read FVisible write SetVisible;
  end;

	TButtonCancel = class(TPersistent)
  private
		FOwner: TasBtnPanel;
    FCaption: string;
    FModalResult: TModalResult;
    FEnabled: Boolean;
    FVisible: Boolean;
    FOrder: Integer;
    procedure SetCaption(const Value: String);
    procedure SetModalResult(const Value: TModalResult);
    procedure SetEnabled(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure SetOrder(const Value: Integer);
	public
		constructor Create(AOwner: TasBtnPanel);
	published
		property Caption: String read FCaption write SetCaption;
    property Enabled: Boolean read FEnabled write SetEnabled;
		property ModalResult: TModalResult read FModalResult write SetModalResult;
    property Order: Integer read FOrder write SetOrder;
    property Visible: Boolean read FVisible write SetVisible;
  end;

	TButtonApply = class(TPersistent)
  private
		FOwner: TasBtnPanel;
    FCaption: string;
    FModalResult: TModalResult;
    FEnabled: Boolean;
    FVisible: Boolean;
    FOrder: Integer;
    procedure SetCaption(const Value: String);
    procedure SetModalResult(const Value: TModalResult);
    procedure SetEnabled(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure SetOrder(const Value: Integer);
	public
		constructor Create(AOwner: TasBtnPanel);
	published
		property Caption: String read FCaption write SetCaption;
    property Enabled: Boolean read FEnabled write SetEnabled;
		property ModalResult: TModalResult read FModalResult write SetModalResult;
    property Order: Integer read FOrder write SetOrder;
    property Visible: Boolean read FVisible write SetVisible;
  end;

	TButtonHelp = class(TPersistent)
  private
		FOwner: TasBtnPanel;
    FCaption: string;
    FModalResult: TModalResult;
    FEnabled: Boolean;
    FVisible: Boolean;
    FOrder: Integer;
    procedure SetCaption(const Value: String);
    procedure SetModalResult(const Value: TModalResult);
    procedure SetEnabled(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure SetOrder(const Value: Integer);
	public
		constructor Create(AOwner: TasBtnPanel);
	published
		property Caption: String read FCaption write SetCaption;
    property Enabled: Boolean read FEnabled write SetEnabled;
		property ModalResult: TModalResult read FModalResult write SetModalResult;
    property Order: Integer read FOrder write SetOrder;
    property Visible: Boolean read FVisible write SetVisible;
  end;

	TasBtnPanel = class(TCustomPanel)
  private
    FButtonOK: TButtonOK;
    FOnBtnOKClick: TNotifyEvent;
    FButtonApply: TButtonApply;
    FButtonCancel: TButtonCancel;
    FButtonClose: TButtonClose;
    FButtonHelp: TButtonHelp;
    FOnBtnCloseClick: TNotifyEvent;
    FOnBtnCancelClick: TNotifyEvent;
    FOnBtnApplyClick: TNotifyEvent;
    FOnBtnHelpClick: TNotifyEvent;
    isCreated: Boolean;
    FParentToForm: Boolean;
    function IsOnBtnOKClickStored: Boolean;
    procedure SetOnBtnOKClick(const Value: TNotifyEvent);
    function IsOnBtnApplyClickStored: Boolean;
    function IsOnBtnCancelClickStored: Boolean;
    function IsOnBtnCloseClickStored: Boolean;
    function IsOnBtnHelpClickStored: Boolean;
    procedure SetOnBtnApplyClick(const Value: TNotifyEvent);
    procedure SetOnBtnCancelClick(const Value: TNotifyEvent);
    procedure SetOnBtnCloseClick(const Value: TNotifyEvent);
    procedure SetOnBtnHelpClick(const Value: TNotifyEvent);
    procedure SetParentToForm(const Value: Boolean);
  protected
  public
    LeftPanel: TPanel;
    RightPanel: TPanel;
    BtnOK: TButton;
    BtnCancel: TButton;
    BtnApply: TButton;
    BtnClose: TButton;
    BtnHelp: TButton;
    constructor Create(AComponent: TComponent); override;
    procedure Invalidate; override;
    procedure UpdateButtons;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderWidth;
    property BorderStyle;
    property ButtonOK: TButtonOK read FButtonOK write FButtonOK;
    property ButtonCancel: TButtonCancel read FButtonCancel write FButtonCancel;
    property ButtonApply: TButtonApply read FButtonApply write FButtonApply;
    property ButtonClose: TButtonClose read FButtonClose write FButtonClose;
    property ButtonHelp: TButtonHelp read FButtonHelp write FButtonHelp;
    property Color;
    property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Locked;
    property ParentBiDiMode;
    property ParentBackground;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property ParentToForm: Boolean Read FParentToForm write SetParentToForm;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnBtnOKClick: TNotifyEvent read FOnBtnOKClick write SetOnBtnOKClick stored IsOnBtnOKClickStored;
    property OnBtnCancelClick: TNotifyEvent read FOnBtnCancelClick write SetOnBtnCancelClick stored IsOnBtnCancelClickStored;
    property OnBtnApplyClick: TNotifyEvent read FOnBtnApplyClick write SetOnBtnApplyClick stored IsOnBtnApplyClickStored;
    property OnBtnCloseClick: TNotifyEvent read FOnBtnCloseClick write SetOnBtnCloseClick stored IsOnBtnCloseClickStored;
    property OnBtnHelpClick: TNotifyEvent read FOnBtnHelpClick write SetOnBtnHelpClick stored IsOnBtnHelpClickStored;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

implementation

{ TasBtnPanel }
uses
  graphics;

constructor TasBtnPanel.Create(AComponent: TComponent);
begin
	inherited Create(AComponent);
  isCreated := False;
  Height := 29;
  BevelOuter := bvNone;
  Align := alBottom;

  ButtonOK := TButtonOK.Create(Self);
  ButtonOK.Caption := '&OK';
  ButtonOK.ModalResult := mrOK;
  ButtonOK.Visible := True;
  ButtonOK.Order := 0;

  ButtonCancel := TButtonCancel.Create(Self);
  ButtonCancel.Caption := '&Cancel';
  ButtonCancel.ModalResult := mrCancel;
  ButtonCancel.Visible := True;
  ButtonCancel.Order := 1;

  ButtonApply := TButtonApply.Create(Self);
  ButtonApply.Caption := '&Apply';
  ButtonApply.ModalResult := mrNone;
  ButtonApply.Visible := True;
  ButtonApply.Order := 2;

  ButtonClose := TButtonClose.Create(Self);
  ButtonClose.Caption := 'Clo&se';
  ButtonClose.ModalResult := mrOK;
  ButtonClose.Order := 3;

  ButtonHelp := TButtonHelp.Create(Self);
  ButtonHelp.Caption := '&Help';
  ButtonHelp.ModalResult := mrNone;  
  ButtonHelp.Order := 4;

  RightPanel := TPanel.Create(Self);
  RightPanel.Caption := '';
  RightPanel.BevelOuter := bvNone;
  RightPanel.Align := alRight;
  RightPanel.Width := 79;
  RightPanel.Parent := Self;

  LeftPanel := TPanel.Create(Self);
  LeftPanel.Caption := '';
  LeftPanel.BevelOuter := bvNone;
  LeftPanel.Align := alClient;
  LeftPanel.Parent := Self;

  BtnOK := TButton.Create(Self);
  BtnOK.Parent := RightPanel;
  BtnOK.Caption := '&OK';
  BtnOK.Visible := True;
  BtnOK.Left := 2;
  BtnOK.Top := 2;

  BtnCancel := TButton.Create(Self);
  BtnCancel.Parent := RightPanel;
  BtnCancel.Caption := '&Cancel';
  BtnCancel.Visible := True;
  BtnCancel.Top := 2;

  BtnApply := TButton.Create(Self);
  BtnApply.Parent := RightPanel;
  BtnApply.Caption := '&Apply';
  BtnApply.Visible := True;
  BtnApply.Top := 2;

  BtnClose := TButton.Create(Self);
  BtnClose.Parent := RightPanel;
  BtnClose.Caption := 'Clo&se';
  BtnClose.Visible := False;
  BtnClose.Top := 2;

  BtnHelp := TButton.Create(Self);
  BtnHelp.Parent := RightPanel;
  BtnHelp.Caption := '&Help';
  BtnHelp.Visible := False;
  BtnHelp.Top := 2;  

  isCreated := True;

  UpdateButtons;
end;

procedure TasBtnPanel.Invalidate;
begin
  inherited;
  UpdateButtons;
end;

function TasBtnPanel.IsOnBtnApplyClickStored: Boolean;
begin
  Result := @OnBtnApplyClick <> nil;
end;

function TasBtnPanel.IsOnBtnCancelClickStored: Boolean;
begin
  Result := @OnBtnCancelClick <> nil;
end;

function TasBtnPanel.IsOnBtnCloseClickStored: Boolean;
begin
  Result := @OnBtnCloseClick <> nil;
end;

function TasBtnPanel.IsOnBtnHelpClickStored: Boolean;
begin
  Result := @OnBtnHelpClick <> nil;
end;

function TasBtnPanel.IsOnBtnOKClickStored: Boolean;
begin
  Result := @OnBtnOKClick <> nil;
end;

procedure TasBtnPanel.SetOnBtnApplyClick(const Value: TNotifyEvent);
begin
  FOnBtnApplyClick := Value;
  BtnApply.OnClick := Value;  
end;

procedure TasBtnPanel.SetOnBtnCancelClick(const Value: TNotifyEvent);
begin
  FOnBtnCancelClick := Value;
  BtnCancel.OnClick := Value;
end;

procedure TasBtnPanel.SetOnBtnCloseClick(const Value: TNotifyEvent);
begin
  FOnBtnCloseClick := Value;
  BtnClose.OnClick := Value;
end;

procedure TasBtnPanel.SetOnBtnHelpClick(const Value: TNotifyEvent);
begin
  FOnBtnHelpClick := Value;
  BtnHelp.OnClick := Value;
end;

procedure TasBtnPanel.SetOnBtnOKClick(const Value: TNotifyEvent);
begin
  FOnBtnOKClick := Value;
  BtnOK.OnClick := Value;
end;

procedure TasBtnPanel.SetParentToForm(const Value: Boolean);
begin
  if FParentToForm <> Value then
  begin
    FParentToForm := Value;
    if Value then
    begin
      if Parent <> nil then
      begin
        While Parent.Parent <> nil do
        begin
          Parent := Parent.Parent;
          Top := Parent.Height;
        end;
      end;
    end;
  end;
end;

procedure TasBtnPanel.UpdateButtons;
var
  NumberVisible: Integer;
  NumberToMove: Integer;
begin
  //Button Width = 75, Need 2 pixel spacer between buttons and edges
  //Default Order
  //OK, Cancel, Apply, Close, Help
  if isCreated then
  begin
    NumberVisible := 0;
    {Set Display for Button OK}
    if ButtonOK.Visible then
    begin
      NumberToMove := 0;
      if ((ButtonCancel.Visible)AND(ButtonCancel.Order < ButtonOK.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonApply.Visible)AND(ButtonApply.Order < ButtonOK.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonClose.Visible)AND(ButtonClose.Order < ButtonOK.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonHelp.Visible)AND(ButtonHelp.Order < ButtonOK.Order)) then
        NumberToMove := NumberToMove + 1;

      NumberVisible := NumberVisible + 1;
      BtnOK.Left := (NumberToMove*79) + 2;
      BtnOK.TabOrder := ButtonOK.Order;
      BtnOK.Visible := True;
      BtnOK.Top := 2;
      BtnOK.Caption := ButtonOK.Caption;
      BtnOK.ModalResult := ButtonOK.ModalResult;
    end else
      BtnOK.Visible := False;

    {Set Display for Button Cancel}
    if ButtonCancel.Visible then
    begin
      NumberToMove := 0;
      if ((ButtonOK.Visible)AND(ButtonOK.Order <= ButtonCancel.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonApply.Visible)AND(ButtonApply.Order < ButtonCancel.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonClose.Visible)AND(ButtonClose.Order < ButtonCancel.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonHelp.Visible)AND(ButtonHelp.Order < ButtonCancel.Order)) then
        NumberToMove := NumberToMove + 1;

      NumberVisible := NumberVisible + 1;
      BtnCancel.Left := (NumberToMove*79) + 2;;
      BtnCancel.TabOrder := ButtonCancel.Order;
      BtnCancel.Visible := True;
      BtnCancel.Top := 2;
      BtnCancel.Caption := ButtonCancel.Caption;
      BtnCancel.ModalResult := ButtonCancel.ModalResult;
    end else
      BtnCancel.Visible := False;

    {Set Display for Button Apply}
    if ButtonApply.Visible then
    begin
      NumberToMove := 0;
      if ((ButtonOK.Visible)AND(ButtonOK.Order <= ButtonApply.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonCancel.Visible)AND(ButtonCancel.Order <= ButtonApply.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonClose.Visible)AND(ButtonClose.Order < ButtonApply.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonHelp.Visible)AND(ButtonHelp.Order < ButtonApply.Order)) then
        NumberToMove := NumberToMove + 1;

      NumberVisible := NumberVisible + 1;
      BtnApply.Left := (NumberToMove*79) + 2;
      BtnApply.TabOrder := ButtonApply.Order;
      BtnApply.Visible := True;
      BtnApply.Top := 2;
      BtnApply.Caption := ButtonApply.Caption;
      BtnApply.ModalResult := ButtonApply.ModalResult;
    end else
      BtnApply.Visible := False;

    {Set Display for Button Close}
    if ButtonClose.Visible then
    begin
      NumberToMove := 0;
      if ((ButtonOK.Visible)AND(ButtonOK.Order <= ButtonClose.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonCancel.Visible)AND(ButtonCancel.Order <= ButtonClose.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonApply.Visible)AND(ButtonApply.Order <= ButtonClose.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonHelp.Visible)AND(ButtonHelp.Order < ButtonClose.Order)) then
        NumberToMove := NumberToMove + 1;

      NumberVisible := NumberVisible + 1;
      BtnClose.Left := (NumberToMove*79) + 2;
      BtnClose.TabOrder := ButtonClose.Order;
      BtnClose.Visible := True;
      BtnClose.Top := 2;
      BtnClose.Caption := ButtonClose.Caption;
      BtnClose.ModalResult := ButtonClose.ModalResult;
    end else
      BtnClose.Visible := False;

    {Set Display for Button Help}
    if ButtonHelp.Visible then
    begin
      NumberToMove := 0;
      if ((ButtonOK.Visible)AND(ButtonOK.Order <= ButtonHelp.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonCancel.Visible)AND(ButtonCancel.Order <= ButtonHelp.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonClose.Visible)AND(ButtonClose.Order <= ButtonHelp.Order)) then
        NumberToMove := NumberToMove + 1;
      if ((ButtonApply.Visible)AND(ButtonApply.Order <= ButtonHelp.Order)) then
        NumberToMove := NumberToMove + 1;

      NumberVisible := NumberVisible + 1;
      BtnHelp.Left := (NumberToMove*79) + 2;
      BtnHelp.TabOrder := ButtonHelp.Order;      
      BtnHelp.Visible := True;
      BtnHelp.Top := 2;
      BtnHelp.Caption := ButtonHelp.Caption;
      BtnHelp.ModalResult := ButtonHelp.ModalResult;
    end else
      BtnHelp.Visible := False;

    {Set Width of Right Panel}
    RightPanel.Width := (NumberVisible * 79) + 4;
    if csDesigning in ComponentState then
    begin
      {  Visible Properties Act Wierd at Design Time,
        So I'm moveing invisible component off the screen  }
      if not BtnOK.Visible then
        BtnOK.Left := RightPanel.Width + 2;
      if not BtnCancel.Visible then
        BtnCancel.Left := RightPanel.Width + 2;
      if not BtnApply.Visible then
        BtnApply.Left := RightPanel.Width + 2;
      if not BtnClose.Visible then
        BtnClose.Left := RightPanel.Width + 2;
      if not BtnHelp.Visible then
        BtnHelp.Left := RightPanel.Width + 2;
    end;
  end;
end;

{ TButtonOK }

constructor TButtonOK.Create(AOwner: TasBtnPanel);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TButtonOK.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    FOwner.Invalidate;
  end;
end;

procedure TButtonOK.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    FOwner.Invalidate;
  end;
end;

procedure TButtonOK.SetModalResult(const Value: TModalResult);
begin
  if FModalResult <> Value then
    FModalResult := Value;
end;

procedure TButtonOK.SetOrder(const Value: Integer);
var
  OldValue: Integer;
begin
  if ((Value > 4) OR (Value < 0)) then exit;
  if FOrder <> Value then
  begin
    OldValue := FOrder;
    FOrder := Value;
    if FOwner.isCreated then
    begin
      if FOwner.ButtonCancel.Order = Value then
        FOwner.ButtonCancel.Order := OldValue;
      if FOwner.ButtonApply.Order = Value then
        FOwner.ButtonApply.Order := OldValue;
      if FOwner.ButtonClose.Order = Value then
        FOwner.ButtonClose.Order := OldValue;
      if FOwner.ButtonHelp.Order = Value then
        FOwner.ButtonHelp.Order := OldValue;
    end;
    FOwner.Invalidate;
  end;
end;

procedure TButtonOK.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    FOwner.Invalidate;
  end;
end;

{ TButtonClose }

constructor TButtonClose.Create(AOwner: TasBtnPanel);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TButtonClose.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    FOwner.Invalidate;
  end;
end;

procedure TButtonClose.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    FOwner.Invalidate;
  end;
end;

procedure TButtonClose.SetModalResult(const Value: TModalResult);
begin
  if FModalResult <> Value then
    FModalResult := Value;
end;

procedure TButtonClose.SetOrder(const Value: Integer);
var
  OldValue: Integer;
begin
  if ((Value > 4) OR (Value < 0)) then exit;
  if FOrder <> Value then
  begin
    OldValue := FOrder;
    FOrder := Value;
    if FOwner.isCreated then
    begin
      if FOwner.ButtonOK.Order = Value then
        FOwner.ButtonOK.Order := OldValue;
      if FOwner.ButtonCancel.Order = Value then
        FOwner.ButtonCancel.Order := OldValue;
      if FOwner.ButtonApply.Order = Value then
        FOwner.ButtonApply.Order := OldValue;
      if FOwner.ButtonHelp.Order = Value then
        FOwner.ButtonHelp.Order := OldValue;
    end;
    FOwner.Invalidate;
  end;
end;

procedure TButtonClose.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    FOwner.Invalidate;
  end;
end;

{ TButtonCancel }

constructor TButtonCancel.Create(AOwner: TasBtnPanel);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TButtonCancel.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    FOwner.Invalidate;
  end;
end;

procedure TButtonCancel.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    FOwner.Invalidate;
  end;
end;

procedure TButtonCancel.SetModalResult(const Value: TModalResult);
begin
  if FModalResult <> Value then
    FModalResult := Value;
end;

procedure TButtonCancel.SetOrder(const Value: Integer);
var
  OldValue: Integer;
begin
  if ((Value > 4) OR (Value < 0)) then exit;
  if FOrder <> Value then
  begin
    OldValue := FOrder;
    FOrder := Value;
    if FOwner.isCreated then
    begin
      if FOwner.ButtonOK.Order = Value then
        FOwner.ButtonOK.Order := OldValue;
      if FOwner.ButtonApply.Order = Value then
        FOwner.ButtonApply.Order := OldValue;
      if FOwner.ButtonClose.Order = Value then
        FOwner.ButtonClose.Order := OldValue;
      if FOwner.ButtonHelp.Order = Value then
        FOwner.ButtonHelp.Order := OldValue;
    end;
    FOwner.Invalidate;
  end;
end;

procedure TButtonCancel.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    FOwner.Invalidate;
  end;
end;

{ TButtonApply }

constructor TButtonApply.Create(AOwner: TasBtnPanel);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TButtonApply.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    FOwner.Invalidate;
  end;
end;

procedure TButtonApply.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    FOwner.Invalidate;
  end;
end;

procedure TButtonApply.SetModalResult(const Value: TModalResult);
begin
  if FModalResult <> Value then
    FModalResult := Value;
end;

procedure TButtonApply.SetOrder(const Value: Integer);
var
  OldValue: Integer;
begin
  if ((Value > 4) OR (Value < 0)) then exit;
  if FOrder <> Value then
  begin
    OldValue := FOrder;
    FOrder := Value;
    if FOwner.isCreated then
    begin
      if FOwner.ButtonOK.Order = Value then
        FOwner.ButtonOK.Order := OldValue;
      if FOwner.ButtonCancel.Order = Value then
        FOwner.ButtonCancel.Order := OldValue;
      if FOwner.ButtonClose.Order = Value then
        FOwner.ButtonClose.Order := OldValue;
      if FOwner.ButtonHelp.Order = Value then
        FOwner.ButtonHelp.Order := OldValue;
    end;
    FOwner.Invalidate;
  end;
end;

procedure TButtonApply.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    FOwner.Invalidate;
  end;
end;

{ TButtonHelp }

constructor TButtonHelp.Create(AOwner: TasBtnPanel);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TButtonHelp.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    FOwner.Invalidate;
  end;
end;

procedure TButtonHelp.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    FOwner.Invalidate;
  end;
end;

procedure TButtonHelp.SetModalResult(const Value: TModalResult);
begin
  if FModalResult <> Value then
    FModalResult := Value;
end;

procedure TButtonHelp.SetOrder(const Value: Integer);
var
  OldValue: Integer;
begin
  if ((Value > 4) OR (Value < 0)) then exit;
  if FOrder <> Value then
  begin
    OldValue := FOrder;
    FOrder := Value;
    if FOwner.isCreated then
    begin
      if FOwner.ButtonOK.Order = Value then
        FOwner.ButtonOK.Order := OldValue;
      if FOwner.ButtonCancel.Order = Value then
        FOwner.ButtonCancel.Order := OldValue;
      if FOwner.ButtonApply.Order = Value then
        FOwner.ButtonApply.Order := OldValue;
      if FOwner.ButtonClose.Order = Value then
        FOwner.ButtonClose.Order := OldValue;
    end;
    FOwner.Invalidate;
  end;
end;

procedure TButtonHelp.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    FOwner.Invalidate;
  end;
end;

end.
