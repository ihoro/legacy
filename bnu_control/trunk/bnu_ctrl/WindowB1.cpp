#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowB1 dialog

GRID_TOP_HEADER th_B1[] =
{
	{20,	"№",		CELL_FMT_CENTER, 0},
	{120,	"Интервал",	CELL_FMT_CENTER, 0},
	{90,	"GDOP",		CELL_FMT_CENTER, 0}
};

INI_VALUE_INFO ivi_B1[] =
{
	{"date",		INI_TYPE_EDIT,		IDC_B1_DATE, 0},
	{"time",		INI_TYPE_EDIT,		IDC_B1_TIME, 0},
	{"gdop",		INI_TYPE_EDIT,		IDC_B1_GDOP, 0},
	{"latitude",	INI_TYPE_EDIT,		IDC_B1_LATITUDE, 0},
	{"longitude",	INI_TYPE_EDIT,		IDC_B1_LONGITUDE, 0},
	{"height",		INI_TYPE_EDIT,		IDC_B1_HEIGHT, 0},
	{"system",		INI_TYPE_COMBOBOX,	IDC_B1_SYSTEM, 0},
	{"mask",		INI_TYPE_EDIT,		IDC_B1_MASK, 0}
};

IMPLEMENT_DYNAMIC(CWindowB1, CWindow)
CWindowB1::CWindowB1(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindowB1::~CWindowB1()
{
	bcp->Handler[0xC1] = 0;
}

void gotC1_B1(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowB1*) (mdlg->wnd[WND_B1]) )
#define	BCP_PACKET		0xC1
#include "bcp2packet.h"

	CString s;

	// remove rows
	dlg->grid.DeleteNonFixedRows();

	// fill info
	for (int i=0; i < _intervals; i++)
	{
		// add row
		s.Format("%d", i+1);
		dlg->grid.InsertRow(s);
		dlg->grid.SetItemFormat(i+1, 0, CELL_FMT_RIGHT);
		dlg->grid.SetItemFormat(i+1, 1, CELL_FMT_LEFT);
		dlg->grid.SetItemFormat(i+1, 2, CELL_FMT_LEFT);

		// interval's begin
		int h1 = dlg->hour + _start(i) / 60;		// hours
		h1 -= h1 / 24 * 24;
		int m1 = _start(i) % 60;					// minutes

		// interval's end
		int h2 = dlg->hour + _stop(i) / 60;			// hours
		h2 -= h2 / 24 * 24;
		int m2 = _stop(i) % 60;						// minutes
		
		// show interval
		dlg->grid.SetItemTextFmt(i+1, 1, "%.2d:%.2d:00 - %.2d:%.2d:00", h1, m1, h2, m2);

		// show GDOP
		dlg->grid.SetItemTextFmt(i+1, 2, "%.2f", _gdop(i));
	}

	dlg->grid.Refresh();

	dlg->tmr_off();
	dlg->tmr_do();

#undef	dlg
#include "bcp2packet.h"

}

void CWindowB1::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_B1_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindowB1, CWindow)
	ON_BN_CLICKED(IDC_B1_GET, OnBnClickedB1Get)
END_MESSAGE_MAP()


// CWindowB1 message handlers

BOOL CWindowB1::OnInitDialog()
{
	// specify settings
	ini_init(8, ivi_B1);

	CWindow::OnInitDialog();

	SetDlgItemText(IDC_B1_GET, TITLE_GET);
	SendDlgItemMessage(IDC_B1_TIME, EM_LIMITTEXT, 2, 0);
	SendDlgItemMessage(IDC_B1_MASK, EM_LIMITTEXT, 2, 0);

	// init grid
	grid_init(&grid, 16,0, 1,3, 1,1, false, false, th_B1, 0);

	return TRUE;
}

void CWindowB1::OnBnClickedB1Get()
{
	CString s;

	// get date
	int d, m, y;
	GetDlgItemText(IDC_B1_DATE, s);
	TimeStrToTime(s.GetBuffer(), ".", d, m ,y);
	if ( !(d >= 1 && d <= 31) )
		d = 1;
	if ( !(m >= 1 && m <= 12) )
		m = 1;
	if (y <= 1999)
	{
		y = 1999;
		if (m <= 8)
		{
			m = 8;
			if (d < 22)
				d = 22;
		}
	}
	s.Format("%.2d.%.2d.%.4d", d, m, y);
	SetDlgItemText(IDC_B1_DATE, s);

	// get hour
	hour = (INT8U)GetDlgItemInt(IDC_B1_TIME, 0, 0);
	if (hour > 23)
		hour = 0;
	SetDlgItemInt(IDC_B1_TIME, hour, 0);

	// get GDOP
	GetDlgItemText(IDC_B1_GDOP, s);
	FixFloatStr(s.GetBuffer());
	SetDlgItemText(IDC_B1_GDOP, s);
	BCP_VALUE gdop;
	gdop.f = (float)atof(s);

	// get latitude
	GetDlgItemText(IDC_B1_LATITUDE, s);
	FP64 latitude = CoordStrToRadians(s.GetBuffer(), true);
	RadiansToCoordStr(latitude, true, s.GetBufferSetLength(15));
	SetDlgItemText(IDC_B1_LATITUDE, s);

	// get longitude
	GetDlgItemText(IDC_B1_LONGITUDE, s);
	FP64 longitude = CoordStrToRadians(s.GetBuffer(), false);
	RadiansToCoordStr(longitude, false, s.GetBufferSetLength(15));
	SetDlgItemText(IDC_B1_LONGITUDE, s);

	// get height
	GetDlgItemText(IDC_B1_HEIGHT, s);
	FixFloatStr(s.GetBuffer());
	SetDlgItemText(IDC_B1_HEIGHT, s);
	FP32 height = (float)atof(s);

	// get system
	INT8U system = (INT8U)SendDlgItemMessage(IDC_B1_SYSTEM, CB_GETCURSEL, 0, 0);

	// get mask
	INT8U mask = (INT8U)GetDlgItemInt(IDC_B1_MASK, 0, 0);
	if (mask > 90)
		mask = 0;
	SetDlgItemInt(IDC_B1_MASK, mask, 0);

	// send request
	size = bcp->MakePacket(p, 0xB1, (INT16U)y, (INT8U)m, (INT8U)d, hour, gdop.L, longitude, latitude, height, system, mask);
	tmr_on();
	bcp->Handler[0xC1] = gotC1_B1;
	sendp();

	SwitchInterface(false);
}

void CWindowB1::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_B1_GET, OnOff);
}

void CWindowB1::tmr_do()
{
	bcp->Handler[0xC1] = 0;
	SwitchInterface(true);
}