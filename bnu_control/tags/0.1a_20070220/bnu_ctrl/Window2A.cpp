// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow2A dialog

INT8U dl_2A[] =
{
	0x00,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

GRID_TOP_HEADER th_2A[] =
{
	{125, 0, CELL_FMT_LEFT, CELL_FMT_LEFT},
	{120, 0, CELL_FMT_LEFT, CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_2A[] =
{
	"a0, с",
	"a1, с/полуцикл",
	"a2, c/полуцикл^2",
	"a3, с/полуцикл^3",
	"B0, с",
	"В1, с/полуцикл",
	"В2, с/полуцикл^2",
	"В3, с/полуцикл^3",
	"Призн. достоверности"
};

INI_VALUE_INFO ivi_2A[] =
{
	{"req_periodic",	INI_TYPE_CHECKBOX,	IDC_2A_PERIODIC, 0},
	{"req_period",		INI_TYPE_EDIT,		IDC_2A_PERIOD, 0}
};

IMPLEMENT_DYNAMIC(CWindow2A, CWindow)
CWindow2A::CWindow2A(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow2A::~CWindow2A()
{
	bcp->Handler[0x4A] = 0;
	req_free();
}

void got4A_2A(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow2A*) (mdlg->wnd[WND_2A]) )
#define	BCP_PACKET		0x4A
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;

	// if once then stop catching
	if (dlg->req_if_once())
	{
		dlg->tmr_off();
		bcp->Handler[0x4A] = 0;
	}
	// reset rnpi-checker
	else
		dlg->rnpi_init(0xff, 0);

	if (dlg->isMinimized)
		return;

	// float values
	for (int i=0; i<8; i++)
		dlg->grid.SetItemTextFmt(i, 1, "%.6e", _v[i]);

	// flag
	char s[9];
	IntToHEXStr((INT32U)_flag, s);
	s[8] = 0;
	dlg->grid.SetItemText(8, 1, s + 6);

	dlg->grid.Refresh();

#undef	dlg
#include "bcp2packet.h"

}

void CWindow2A::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_2A_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindow2A, CWindow)
END_MESSAGE_MAP()


// CWindow2A message handlers

BOOL CWindow2A::OnInitDialog()
{
	// specify settings
	ini_init(2, ivi_2A);

	// init device selector
	ds_init(dl_2A);

	// init grid
	grid_init(&grid, 16,0, 9,2, 0,1, false, false, th_2A, lh_2A);

	CWindow::OnInitDialog();

	// init periodic handler
	req_init(IDC_2A_ONCE, IDC_2A_PERIODIC, IDC_2A_PERIOD, RESPONSE_PERIOD_IN_SECONDS);

	return TRUE;
}

void CWindow2A::req_periodic(INT8U period)
{
	size = bcp->MakePacket(p, 0x2A, ds_get(), period);
	bcp->Handler[0x4A] = got4A_2A;
	rnpi_init(0xff, 0);
	sendp();
}

void CWindow2A::req_off()
{
	size = bcp->MakePacket(p, 0x2A, ds_get(), 0x00);
	sendp();
	bcp->Handler[0x4A] = 0;
}

void CWindow2A::req_once()
{
	char *fmtOriginal = bcp->Format[0x2A];
	bcp->Format[0x2A] = "C";

	size = bcp->MakePacket(p, 0x2A, ds_get());
	bcp->Handler[0x4A] = got4A_2A;
	rnpi_init(0xff, 0);
	sendp();

	bcp->Format[0x2A] = fmtOriginal;
}

void CWindow2A::tmr_do()
{
	bcp->Handler[0x4A] = 0;
}