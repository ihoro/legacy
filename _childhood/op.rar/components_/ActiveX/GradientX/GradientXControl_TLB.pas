unit GradientXControl_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.88  $
// File generated on 23.12.01 21:18:41 from Type Library described below.

// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
// ************************************************************************ //
// Type Lib: C:\Projects\Components\ActiveX\GradientX\GradientXControl.tlb (1)
// IID\LCID: {14F97B80-F7EA-11D5-8C59-A12510097651}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\SYSTEM\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\SYSTEM\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  GradientXControlMajorVersion = 1;
  GradientXControlMinorVersion = 0;

  LIBID_GradientXControl: TGUID = '{14F97B80-F7EA-11D5-8C59-A12510097651}';

  IID_IGradientX: TGUID = '{14F97B81-F7EA-11D5-8C59-A12510097651}';
  DIID_IGradientXEvents: TGUID = '{14F97B83-F7EA-11D5-8C59-A12510097651}';
  CLASS_GradientX: TGUID = '{14F97B85-F7EA-11D5-8C59-A12510097651}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TxMouseButton
type
  TxMouseButton = TOleEnum;
const
  mbLeft = $00000000;
  mbRight = $00000001;
  mbMiddle = $00000002;

// Constants for enum TxGradientStyle
type
  TxGradientStyle = TOleEnum;
const
  gsVertical = $00000000;
  gsHorizontal = $00000001;
  gsRectangle = $00000002;
  gsLeftToRightDiagonal = $00000003;
  gsRightToLeftDiagonal = $00000004;
  gsCircle = $00000005;

// Constants for enum TxAlignment
type
  TxAlignment = TOleEnum;
const
  taLeftJustify = $00000000;
  taRightJustify = $00000001;
  taCenter = $00000002;

// Constants for enum TxBevelCut
type
  TxBevelCut = TOleEnum;
const
  bvNone = $00000000;
  bvLowered = $00000001;
  bvRaised = $00000002;
  bvSpace = $00000003;

// Constants for enum TxBorderStyle
type
  TxBorderStyle = TOleEnum;
const
  bsNone = $00000000;
  bsSingle = $00000001;

// Constants for enum TxDragMode
type
  TxDragMode = TOleEnum;
const
  dmManual = $00000000;
  dmAutomatic = $00000001;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IGradientX = interface;
  IGradientXDisp = dispinterface;
  IGradientXEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  GradientX = IGradientX;


// *********************************************************************//
// Interface: IGradientX
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {14F97B81-F7EA-11D5-8C59-A12510097651}
// *********************************************************************//
  IGradientX = interface(IDispatch)
    ['{14F97B81-F7EA-11D5-8C59-A12510097651}']
    function  Get_FirstColor: OLE_COLOR; safecall;
    procedure Set_FirstColor(Value: OLE_COLOR); safecall;
    function  Get_SecondColor: OLE_COLOR; safecall;
    procedure Set_SecondColor(Value: OLE_COLOR); safecall;
    function  Get_GradientStyle: TxGradientStyle; safecall;
    procedure Set_GradientStyle(Value: TxGradientStyle); safecall;
    function  Get_Alignment: TxAlignment; safecall;
    function  Get_AutoSize: WordBool; safecall;
    function  Get_BevelInner: TxBevelCut; safecall;
    function  Get_BevelOuter: TxBevelCut; safecall;
    function  Get_BorderStyle: TxBorderStyle; safecall;
    function  Get_Caption: WideString; safecall;
    function  Get_Color: OLE_COLOR; safecall;
    function  Get_Ctl3D: WordBool; safecall;
    function  Get_Font: IFontDisp; safecall;
    function  Get_FullRepaint: WordBool; safecall;
    function  Get_Locked: WordBool; safecall;
    function  Get_UseDockManager: WordBool; safecall;
    procedure Set_UseDockManager(Value: WordBool); safecall;
    function  Get_DockSite: WordBool; safecall;
    procedure Set_DockSite(Value: WordBool); safecall;
    function  Get_DragCursor: Smallint; safecall;
    procedure Set_DragCursor(Value: Smallint); safecall;
    function  Get_DragMode: TxDragMode; safecall;
    procedure Set_DragMode(Value: TxDragMode); safecall;
    function  Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    function  Get_ParentColor: WordBool; safecall;
    procedure Set_ParentColor(Value: WordBool); safecall;
    function  Get_ParentCtl3D: WordBool; safecall;
    procedure Set_ParentCtl3D(Value: WordBool); safecall;
    function  Get_Visible: WordBool; safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function  Get_DoubleBuffered: WordBool; safecall;
    procedure Set_DoubleBuffered(Value: WordBool); safecall;
    function  Get_VisibleDockClientCount: Integer; safecall;
    function  Get_Cursor: Smallint; safecall;
    procedure Set_Cursor(Value: Smallint); safecall;
    procedure AboutBox; safecall;
    property FirstColor: OLE_COLOR read Get_FirstColor write Set_FirstColor;
    property SecondColor: OLE_COLOR read Get_SecondColor write Set_SecondColor;
    property GradientStyle: TxGradientStyle read Get_GradientStyle write Set_GradientStyle;
    property Alignment: TxAlignment read Get_Alignment;
    property AutoSize: WordBool read Get_AutoSize;
    property BevelInner: TxBevelCut read Get_BevelInner;
    property BevelOuter: TxBevelCut read Get_BevelOuter;
    property BorderStyle: TxBorderStyle read Get_BorderStyle;
    property Caption: WideString read Get_Caption;
    property Color: OLE_COLOR read Get_Color;
    property Ctl3D: WordBool read Get_Ctl3D;
    property Font: IFontDisp read Get_Font;
    property FullRepaint: WordBool read Get_FullRepaint;
    property Locked: WordBool read Get_Locked;
    property UseDockManager: WordBool read Get_UseDockManager write Set_UseDockManager;
    property DockSite: WordBool read Get_DockSite write Set_DockSite;
    property DragCursor: Smallint read Get_DragCursor write Set_DragCursor;
    property DragMode: TxDragMode read Get_DragMode write Set_DragMode;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property ParentColor: WordBool read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: WordBool read Get_ParentCtl3D write Set_ParentCtl3D;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property DoubleBuffered: WordBool read Get_DoubleBuffered write Set_DoubleBuffered;
    property VisibleDockClientCount: Integer read Get_VisibleDockClientCount;
    property Cursor: Smallint read Get_Cursor write Set_Cursor;
  end;

// *********************************************************************//
// DispIntf:  IGradientXDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {14F97B81-F7EA-11D5-8C59-A12510097651}
// *********************************************************************//
  IGradientXDisp = dispinterface
    ['{14F97B81-F7EA-11D5-8C59-A12510097651}']
    property FirstColor: OLE_COLOR dispid 2;
    property SecondColor: OLE_COLOR dispid 3;
    property GradientStyle: TxGradientStyle dispid 4;
    property Alignment: TxAlignment readonly dispid 5;
    property AutoSize: WordBool readonly dispid 6;
    property BevelInner: TxBevelCut readonly dispid 7;
    property BevelOuter: TxBevelCut readonly dispid 8;
    property BorderStyle: TxBorderStyle readonly dispid 9;
    property Caption: WideString readonly dispid -518;
    property Color: OLE_COLOR readonly dispid -501;
    property Ctl3D: WordBool readonly dispid 10;
    property Font: IFontDisp readonly dispid -512;
    property FullRepaint: WordBool readonly dispid 11;
    property Locked: WordBool readonly dispid 12;
    property UseDockManager: WordBool dispid 13;
    property DockSite: WordBool dispid 14;
    property DragCursor: Smallint dispid 15;
    property DragMode: TxDragMode dispid 16;
    property Enabled: WordBool dispid -514;
    property ParentColor: WordBool dispid 17;
    property ParentCtl3D: WordBool dispid 18;
    property Visible: WordBool dispid 19;
    property DoubleBuffered: WordBool dispid 20;
    property VisibleDockClientCount: Integer readonly dispid 21;
    property Cursor: Smallint dispid 30;
    procedure AboutBox; dispid -552;
  end;

// *********************************************************************//
// DispIntf:  IGradientXEvents
// Flags:     (0)
// GUID:      {14F97B83-F7EA-11D5-8C59-A12510097651}
// *********************************************************************//
  IGradientXEvents = dispinterface
    ['{14F97B83-F7EA-11D5-8C59-A12510097651}']
    procedure OnClick; dispid 1;
    procedure OnDblClick; dispid 2;
    procedure OnResize; dispid 9;
    procedure OnCanResize(var NewSize: Integer; var Accept: WordBool); dispid 10;
    procedure OnConstrainedResize(var MinWidth: Integer; var MinHeight: Integer; 
                                  var MaxWidth: Integer; var MaxHeight: Integer); dispid 11;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TGradientX
// Help String      : GradientX Control
// Default Interface: IGradientX
// Def. Intf. DISP? : No
// Event   Interface: IGradientXEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TGradientXOnCanResize = procedure(Sender: TObject; var NewSize: Integer; var Accept: WordBool) of object;
  TGradientXOnConstrainedResize = procedure(Sender: TObject; var MinWidth: Integer; 
                                                             var MinHeight: Integer; 
                                                             var MaxWidth: Integer; 
                                                             var MaxHeight: Integer) of object;

  TGradientX = class(TOleControl)
  private
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnResize: TNotifyEvent;
    FOnCanResize: TGradientXOnCanResize;
    FOnConstrainedResize: TGradientXOnConstrainedResize;
    FIntf: IGradientX;
    function  GetControlInterface: IGradientX;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure AboutBox;
    property  ControlInterface: IGradientX read GetControlInterface;
    property  DefaultInterface: IGradientX read GetControlInterface;
    property Alignment: TOleEnum index 5 read GetTOleEnumProp;
    property AutoSize: WordBool index 6 read GetWordBoolProp;
    property BevelInner: TOleEnum index 7 read GetTOleEnumProp;
    property BevelOuter: TOleEnum index 8 read GetTOleEnumProp;
    property BorderStyle: TOleEnum index 9 read GetTOleEnumProp;
    property Caption: WideString index -518 read GetWideStringProp;
    property Color: TColor index -501 read GetTColorProp;
    property Ctl3D: WordBool index 10 read GetWordBoolProp;
    property Font: TFont index -512 read GetTFontProp;
    property FullRepaint: WordBool index 11 read GetWordBoolProp;
    property Locked: WordBool index 12 read GetWordBoolProp;
    property DoubleBuffered: WordBool index 20 read GetWordBoolProp write SetWordBoolProp;
    property VisibleDockClientCount: Integer index 21 read GetIntegerProp;
  published
    property FirstColor: TColor index 2 read GetTColorProp write SetTColorProp stored False;
    property SecondColor: TColor index 3 read GetTColorProp write SetTColorProp stored False;
    property GradientStyle: TOleEnum index 4 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property UseDockManager: WordBool index 13 read GetWordBoolProp write SetWordBoolProp stored False;
    property DockSite: WordBool index 14 read GetWordBoolProp write SetWordBoolProp stored False;
    property DragCursor: Smallint index 15 read GetSmallintProp write SetSmallintProp stored False;
    property DragMode: TOleEnum index 16 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Enabled: WordBool index -514 read GetWordBoolProp write SetWordBoolProp stored False;
    property ParentColor: WordBool index 17 read GetWordBoolProp write SetWordBoolProp stored False;
    property ParentCtl3D: WordBool index 18 read GetWordBoolProp write SetWordBoolProp stored False;
    property Visible: WordBool index 19 read GetWordBoolProp write SetWordBoolProp stored False;
    property Cursor: Smallint index 30 read GetSmallintProp write SetSmallintProp stored False;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
    property OnCanResize: TGradientXOnCanResize read FOnCanResize write FOnCanResize;
    property OnConstrainedResize: TGradientXOnConstrainedResize read FOnConstrainedResize write FOnConstrainedResize;
  end;

procedure Register;

implementation

uses ComObj;

procedure TGradientX.InitControlData;
const
  CEventDispIDs: array [0..4] of DWORD = (
    $00000001, $00000002, $00000009, $0000000A, $0000000B);
  CTFontIDs: array [0..0] of DWORD = (
    $FFFFFE00);
  CControlData: TControlData2 = (
    ClassID: '{14F97B85-F7EA-11D5-8C59-A12510097651}';
    EventIID: '{14F97B83-F7EA-11D5-8C59-A12510097651}';
    EventCount: 5;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80040154*);
    Flags: $0000001D;
    Version: 401;
    FontCount: 1;
    FontIDs: @CTFontIDs);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnClick) - Cardinal(Self);
end;

procedure TGradientX.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IGradientX;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TGradientX.GetControlInterface: IGradientX;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TGradientX.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TGradientX]);
end;

end.
