// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowA8 dialog

GRID_TOP_HEADER th_A8[] =
{
	{105,	0, CELL_FMT_RIGHT, CELL_FMT_RIGHT},
	{90,	0, CELL_FMT_LEFT, CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_A8[] =
{
	"Точка, №",
	"Отстояние по X, м",
	"Отстояние по Y, м",
	"Отстояние по Z, м"
};

INI_VALUE_INFO ivi_A8[] =
{
	{"v%d", INI_TYPE_GRID_COLUMN, 1, 0}
};

IMPLEMENT_DYNAMIC(CWindowA8, CWindow)
CWindowA8::CWindowA8(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindowA8::~CWindowA8()
{
	bcp->Handler[0xA9] = 0;
}

void gotA9_A8(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowA8*) (mdlg->wnd[WND_A8]) )
#define	BCP_PACKET		0xA9
#include "bcp2packet.h"

	// point
	dlg->grid.SetItemTextFmt(0, 1, "%lu", _point);

	// other values
	for (int i=0; i<3; i++)
		dlg->grid.SetItemTextFmt(i+1, 1, "%.3f", _v[i]);

	dlg->grid.Refresh();

	dlg->tmr_off();
	dlg->tmr_do();

#undef	dlg
#include "bcp2packet.h"

}

void CWindowA8::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_A8_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindowA8, CWindow)
	ON_BN_CLICKED(IDC_A8_SET, OnBnClickedA8Set)
END_MESSAGE_MAP()


// CWindowA8 message handlers

BOOL CWindowA8::OnInitDialog()
{
	// specify settings
	ivi_A8[0].grid = &grid;
	ini_init(1, ivi_A8);

	// init grid
	grid_init(&grid, 18,0, 4,2, 0,1, true, false, th_A8, lh_A8);

	CWindow::OnInitDialog();

	SetDlgItemText(IDC_A8_SET, TITLE_SET);

	return TRUE;
}

void CWindowA8::OnBnClickedA8Set()
{
	CString s;

	// get point
	s = grid.GetItemText(0, 1);
	int point = atoi(s);
	if (point < 0)
		point = 0;
	if (point > 255)
		point = 255;
	grid.SetItemTextFmt(0, 1, "%d", point);

	// get grid's values as float
	BCP_VALUE v[3];
	for (int i=1; i<4; i++)
	{
		s = grid.GetItemText(i, 1);
		FixFloatStr(s.GetBuffer());
		grid.SetItemText(i, 1, s);
		v[i-1].f = (float)atof(s);
	}

	grid.Refresh();

	// send request
	size = bcp->MakePacket(p, 0xA8, (INT8U)point, v[0].L, v[1].L, v[2].L);
	bcp->Handler[0xA9] = gotA9_A8;
	tmr_on();
	sendp();

	SwitchInterface(false);
}

void CWindowA8::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_A8_SET, OnOff);
	ENABLE_ITEM(IDC_A8_GRID, OnOff);
}

void CWindowA8::tmr_do()
{
	bcp->Handler[0xA9] = 0;
	SwitchInterface(true);
}