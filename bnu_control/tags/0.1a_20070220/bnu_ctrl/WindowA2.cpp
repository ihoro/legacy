// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowA2 dialog

GRID_TOP_HEADER th_A2[] =
{
	{56, 0, CELL_FMT_RIGHT, CELL_FMT_RIGHT},
	{80, 0, CELL_FMT_LEFT, CELL_FMT_LEFT},
	{80, 0, CELL_FMT_LEFT, CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_A2[] =
{
	"система",
	"da",
	"df",
	"dX",
	"dY",
	"dZ",
	"Wx",
	"Wy",
	"Wz",
	"m",
	"название"
};

INI_VALUE_INFO ivi_A2[] =
{
	{"v%d", INI_TYPE_GRID_COLUMN, 2, 0}
};

INT8U dl_A2[] =
{
	0x80,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

IMPLEMENT_DYNAMIC(CWindowA2, CWindow)
CWindowA2::CWindowA2(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindowA2::~CWindowA2()
{
	bcp->Handler[0xA3] = 0;
}

void gotA3_A2(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowA2*) (mdlg->wnd[WND_A2]) )
#define	BCP_PACKET		0xA3
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;

	if (!dlg->rnpi_done())
		return;

	// show info
	dlg->grid.SetItemTextFmt(0, 1, "%d", _index);
	for (int i=0; i<9; i++)
		dlg->grid.SetItemTextFmt(i+1, 1, "%.2f", _v[i]);
	_name[6] = 0;
	dlg->grid.SetItemText(10, 1, (LPCTSTR)_name);

	dlg->grid.Refresh();

	dlg->tmr_off();
	dlg->tmr_do();

#undef	dlg
#include "bcp2packet.h"

}

void CWindowA2::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_A2_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindowA2, CWindow)
	ON_BN_CLICKED(IDC_A2_GET, OnBnClickedA2Get)
	ON_BN_CLICKED(IDC_A2_SET, OnBnClickedA2Set)
END_MESSAGE_MAP()


// CWindowA2 message handlers

BOOL CWindowA2::OnInitDialog()
{
	// specify settings
	ivi_A2[0].grid = &grid;
	ini_init(1, ivi_A2);

	// init grid
	grid_init(&grid, 18,0, 11,3, 0,2, true, false, th_A2, lh_A2);

	CWindow::OnInitDialog();

	SetDlgItemText(IDC_A2_GET, TITLE_GET);
	SetDlgItemText(IDC_A2_SET, TITLE_SET);

	// init device selector
	ds_init(dl_A2);

	return TRUE;
}

void CWindowA2::OnBnClickedA2Get()
{
	// get system index
	CString s = grid.GetItemText(0, 2);
	int i = atoi(s);
	if (i < 0) i = 0;
	if (i > 255) i = 255;
	grid.SetItemTextFmt(0, 2, "%d", i);

	// send request
	char *fmtOriginal = bcp->Format[0xA2];
	bcp->Format[0xA2] = "CC";

	size = bcp->MakePacket(p, 0xA2, ds_get(), (INT8U)i);
	bcp->Handler[0xA3] = gotA3_A2;
	tmr_on();
	rnpi_init(0xff, 0);
	sendp();

	bcp->Format[0xA2] = fmtOriginal;

	SwitchInterface(false);
}

void CWindowA2::OnBnClickedA2Set()
{
	CString s;
	BCP_VALUE v[16];

	// get system index
	s = grid.GetItemText(0, 2);
	v[0].C = (INT8U)atoi(s);
	if (v[0].C < 0) v[0].C = 0;
	if (v[0].C > 255) v[0].C = 255;
	grid.SetItemTextFmt(0, 2, "%d", v[0].C);

	// get other values as float
	for (int i=1; i<10; i++)
	{
		s = grid.GetItemText(i, 2);
		FixFloatStr(s.GetBuffer());
		grid.SetItemText(i, 2, s);
		v[i].f = (float)atof(s);
	}

	// get system name
	s = grid.GetItemText(10, 2);
	if (s.GetLength() > 6)
	{
		grid.SetItemText(10, 2, s.Left(6));
		s = grid.GetItemText(10, 2);
	}
	for (int i=0; i < 6; i++)
		if (i < s.GetLength())
			v[10+i].C = s[i];
		else
			v[10+i].C = 0;

	grid.Refresh();

	// send A2h
	size = bcp->MakePacket(p, 0xA2, ds_get(), v[0].C, v[1].L, v[2].L,
						   v[3].L, v[4].L, v[5].L,
						   v[6].L, v[7].L, v[8].L,
						   v[9].L,
						   v[10].C, v[11].C, v[12].C, v[13].C, v[14].C, v[15].C);
	bcp->Handler[0xA3] = gotA3_A2;
	tmr_on();
	rnpi_init(0xff, 0);
	sendp();

	SwitchInterface(false);
}

void CWindowA2::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_A2_GET, OnOff);
	ENABLE_ITEM(IDC_A2_SET, OnOff);
}

void CWindowA2::tmr_do()
{
	bcp->Handler[0xA3] = 0;
	SwitchInterface(true);
}