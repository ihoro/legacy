unit GradientImpl;

interface

uses
  Windows, ActiveX, Classes, Controls, Graphics, Menus, Forms, StdCtrls,
  ComServ, StdVCL, AXCtrls, GradientXControl_TLB, Gradient, ExtCtrls;

type
  TGradientX = class(TActiveXControl, IGradientX)
  private
    { Private declarations }
    FDelphiControl: TGradient;
    FEvents: IGradientXEvents;
    procedure CanResizeEvent(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure ClickEvent(Sender: TObject);
    procedure ConstrainedResizeEvent(Sender: TObject; var MinWidth, MinHeight,
      MaxWidth, MaxHeight: Integer);
    procedure DblClickEvent(Sender: TObject);
    procedure ResizeEvent(Sender: TObject);
  protected
    { Protected declarations }
    procedure DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage); override;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    procedure InitializeControl; override;
    function Get_Alignment: TxAlignment; safecall;
    function Get_AutoSize: WordBool; safecall;
    function Get_BevelInner: TxBevelCut; safecall;
    function Get_BevelOuter: TxBevelCut; safecall;
    function Get_BorderStyle: TxBorderStyle; safecall;
    function Get_Caption: WideString; safecall;
    function Get_Color: OLE_COLOR; safecall;
    function Get_Ctl3D: WordBool; safecall;
    function Get_Cursor: Smallint; safecall;
    function Get_DockSite: WordBool; safecall;
    function Get_DoubleBuffered: WordBool; safecall;
    function Get_DragCursor: Smallint; safecall;
    function Get_DragMode: TxDragMode; safecall;
    function Get_Enabled: WordBool; safecall;
    function Get_FirstColor: OLE_COLOR; safecall;
    function Get_Font: IFontDisp; safecall;
    function Get_FullRepaint: WordBool; safecall;
    function Get_GradientStyle: TxGradientStyle; safecall;
    function Get_Locked: WordBool; safecall;
    function Get_ParentColor: WordBool; safecall;
    function Get_ParentCtl3D: WordBool; safecall;
    function Get_SecondColor: OLE_COLOR; safecall;
    function Get_UseDockManager: WordBool; safecall;
    function Get_Visible: WordBool; safecall;
    function Get_VisibleDockClientCount: Integer; safecall;
    procedure AboutBox; safecall;
    procedure Set_Cursor(Value: Smallint); safecall;
    procedure Set_DockSite(Value: WordBool); safecall;
    procedure Set_DoubleBuffered(Value: WordBool); safecall;
    procedure Set_DragCursor(Value: Smallint); safecall;
    procedure Set_DragMode(Value: TxDragMode); safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    procedure Set_FirstColor(Value: OLE_COLOR); safecall;
    procedure Set_GradientStyle(Value: TxGradientStyle); safecall;
    procedure Set_ParentColor(Value: WordBool); safecall;
    procedure Set_ParentCtl3D(Value: WordBool); safecall;
    procedure Set_SecondColor(Value: OLE_COLOR); safecall;
    procedure Set_UseDockManager(Value: WordBool); safecall;
    procedure Set_Visible(Value: WordBool); safecall;
  end;

implementation

uses ComObj, AboutFrm;

{ TGradientX }

procedure TGradientX.DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage);
begin
  {TODO: Define property pages here.  Property pages are defined by calling
    DefinePropertyPage with the class id of the page.  For example,
      DefinePropertyPage(Class_GradientXPage); }
end;

procedure TGradientX.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IGradientXEvents;
end;

procedure TGradientX.InitializeControl;
begin
  FDelphiControl := Control as TGradient;
  {FDelphiControl.OnCanResize := CanResizeEvent;}
  FDelphiControl.OnClick := ClickEvent;
  {FDelphiControl.OnConstrainedResize := ConstrainedResizeEvent;}
  FDelphiControl.OnDblClick := DblClickEvent;
  {FDelphiControl.OnResize := ResizeEvent;}
end;

function TGradientX.Get_Alignment: TxAlignment;
begin
  Result := Ord(FDelphiControl.Alignment);
end;

function TGradientX.Get_AutoSize: WordBool;
begin
  Result := FDelphiControl.AutoSize;
end;

function TGradientX.Get_BevelInner: TxBevelCut;
begin
  Result := Ord(FDelphiControl.BevelInner);
end;

function TGradientX.Get_BevelOuter: TxBevelCut;
begin
  Result := Ord(FDelphiControl.BevelOuter);
end;

function TGradientX.Get_BorderStyle: TxBorderStyle;
begin
  Result := Ord(FDelphiControl.BorderStyle);
end;

function TGradientX.Get_Caption: WideString;
begin
  Result := WideString(FDelphiControl.Caption);
end;

function TGradientX.Get_Color: OLE_COLOR;
begin
  Result := OLE_COLOR(FDelphiControl.Color);
end;

function TGradientX.Get_Ctl3D: WordBool;
begin
  Result := FDelphiControl.Ctl3D;
end;

function TGradientX.Get_Cursor: Smallint;
begin
  Result := Smallint(FDelphiControl.Cursor);
end;

function TGradientX.Get_DockSite: WordBool;
begin
  Result := FDelphiControl.DockSite;
end;

function TGradientX.Get_DoubleBuffered: WordBool;
begin
  Result := FDelphiControl.DoubleBuffered;
end;

function TGradientX.Get_DragCursor: Smallint;
begin
  Result := Smallint(FDelphiControl.DragCursor);
end;

function TGradientX.Get_DragMode: TxDragMode;
begin
  Result := Ord(FDelphiControl.DragMode);
end;

function TGradientX.Get_Enabled: WordBool;
begin
  Result := FDelphiControl.Enabled;
end;

function TGradientX.Get_FirstColor: OLE_COLOR;
begin
  Result := OLE_COLOR(FDelphiControl.FirstColor);
end;

function TGradientX.Get_Font: IFontDisp;
begin
  GetOleFont(FDelphiControl.Font, Result);
end;

function TGradientX.Get_FullRepaint: WordBool;
begin
  Result := FDelphiControl.FullRepaint;
end;

function TGradientX.Get_GradientStyle: TxGradientStyle;
begin
  Result := Ord(FDelphiControl.GradientStyle);
end;

function TGradientX.Get_Locked: WordBool;
begin
  Result := FDelphiControl.Locked;
end;

function TGradientX.Get_ParentColor: WordBool;
begin
  Result := FDelphiControl.ParentColor;
end;

function TGradientX.Get_ParentCtl3D: WordBool;
begin
  Result := FDelphiControl.ParentCtl3D;
end;

function TGradientX.Get_SecondColor: OLE_COLOR;
begin
  Result := OLE_COLOR(FDelphiControl.SecondColor);
end;

function TGradientX.Get_UseDockManager: WordBool;
begin
  Result := FDelphiControl.UseDockManager;
end;

function TGradientX.Get_Visible: WordBool;
begin
  Result := FDelphiControl.Visible;
end;

function TGradientX.Get_VisibleDockClientCount: Integer;
begin
  Result := FDelphiControl.VisibleDockClientCount;
end;

procedure TGradientX.AboutBox;
begin
  ShowGradientXAbout;
end;

procedure TGradientX.CanResizeEvent(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
var
  TempNewSize: Integer;
  TempAccept: WordBool;
begin
  TempNewSize := Integer(NewSize);
  TempAccept := WordBool(Accept);
  if FEvents <> nil then FEvents.OnCanResize(TempNewSize, TempAccept);
  NewSize := Integer(TempNewSize);
  Accept := Boolean(TempAccept);
end;

procedure TGradientX.ClickEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnClick;
end;

procedure TGradientX.ConstrainedResizeEvent(Sender: TObject; var MinWidth,
  MinHeight, MaxWidth, MaxHeight: Integer);
var
  TempMinWidth: Integer;
  TempMinHeight: Integer;
  TempMaxWidth: Integer;
  TempMaxHeight: Integer;
begin
  TempMinWidth := Integer(MinWidth);
  TempMinHeight := Integer(MinHeight);
  TempMaxWidth := Integer(MaxWidth);
  TempMaxHeight := Integer(MaxHeight);
  if FEvents <> nil then FEvents.OnConstrainedResize(TempMinWidth, TempMinHeight, TempMaxWidth, TempMaxHeight);
  MinWidth := Integer(TempMinWidth);
  MinHeight := Integer(TempMinHeight);
  MaxWidth := Integer(TempMaxWidth);
  MaxHeight := Integer(TempMaxHeight);
end;

procedure TGradientX.DblClickEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnDblClick;
end;

procedure TGradientX.ResizeEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnResize;
end;

procedure TGradientX.Set_Cursor(Value: Smallint);
begin
  FDelphiControl.Cursor := TCursor(Value);
end;

procedure TGradientX.Set_DockSite(Value: WordBool);
begin
  FDelphiControl.DockSite := Value;
end;

procedure TGradientX.Set_DoubleBuffered(Value: WordBool);
begin
  FDelphiControl.DoubleBuffered := Value;
end;

procedure TGradientX.Set_DragCursor(Value: Smallint);
begin
  FDelphiControl.DragCursor := TCursor(Value);
end;

procedure TGradientX.Set_DragMode(Value: TxDragMode);
begin
  FDelphiControl.DragMode := TDragMode(Value);
end;

procedure TGradientX.Set_Enabled(Value: WordBool);
begin
  FDelphiControl.Enabled := Value;
end;

procedure TGradientX.Set_FirstColor(Value: OLE_COLOR);
begin
  FDelphiControl.FirstColor := TColor(Value);
end;

procedure TGradientX.Set_GradientStyle(Value: TxGradientStyle);
begin
  FDelphiControl.GradientStyle := TGradientStyle(Value);
end;

procedure TGradientX.Set_ParentColor(Value: WordBool);
begin
  FDelphiControl.ParentColor := Value;
end;

procedure TGradientX.Set_ParentCtl3D(Value: WordBool);
begin
  FDelphiControl.ParentCtl3D := Value;
end;

procedure TGradientX.Set_SecondColor(Value: OLE_COLOR);
begin
  FDelphiControl.SecondColor := TColor(Value);
end;

procedure TGradientX.Set_UseDockManager(Value: WordBool);
begin
  FDelphiControl.UseDockManager := Value;
end;

procedure TGradientX.Set_Visible(Value: WordBool);
begin
  FDelphiControl.Visible := Value;
end;

initialization
  TActiveXControlFactory.Create(
    ComServer,
    TGradientX,
    TGradient,
    Class_GradientX,
    1,
    '',
    OLEMISC_SIMPLEFRAME or OLEMISC_ACTSLIKELABEL,
    tmApartment);
end.
