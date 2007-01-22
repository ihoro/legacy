#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow2B dialog

INT8U dl_2B[] =
{
	0x00,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

GRID_TOP_HEADER th_2B[] =
{
	{115, 0, CELL_FMT_RIGHT, CELL_FMT_RIGHT},
	{90, 0, CELL_FMT_LEFT, CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_2B[] =
{
	"A0, c",
	"A1, c/c",
	"t0t, c",
	"WNt, недели",
	"delta tLS, c",
	"WNLSF, недели",
	"DN, сутки",
	"delta tLSF, c",
	"Достоверность GPS",
	"NA, сутки",
	"tc, c",
	"Достоверность ГЛН"
};

INI_VALUE_INFO ivi_2B[] =
{
	{"req_periodic",	INI_TYPE_CHECKBOX,	IDC_2B_PERIODIC, 0},
	{"req_period",		INI_TYPE_EDIT,		IDC_2B_PERIOD, 0}
};

IMPLEMENT_DYNAMIC(CWindow2B, CWindow)
CWindow2B::CWindow2B(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow2B::~CWindow2B()
{
	bcp->Handler[0x4B] = 0;
	req_free();
}

void got4B_2B(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow2B*) (mdlg->wnd[WND_2B]) )
#define	BCP_PACKET		0x4B
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;

	// if once then stop catching
	if (dlg->req_if_once())
	{
		dlg->tmr_off();
		bcp->Handler[0x4B] = 0;
	}
	// reset rnpi-checker
	else
		dlg->rnpi_init(0xff, 0);

	if (dlg->isMinimized)
		return;

	char s[9];

	// show values
	dlg->grid.SetItemTextFmt(0, 1, "%.3f",	_v1);
	dlg->grid.SetItemTextFmt(1, 1, "%.3f",	_v2);
	dlg->grid.SetItemTextFmt(2, 1, "%lu",	_v3);
	dlg->grid.SetItemTextFmt(3, 1, "%lu",	_v4);
	dlg->grid.SetItemTextFmt(4, 1, "%d",	_v5);
	dlg->grid.SetItemTextFmt(5, 1, "%lu",	_v6);
	dlg->grid.SetItemTextFmt(6, 1, "%lu",	_v7);
	dlg->grid.SetItemTextFmt(7, 1, "%d",	_v8);

	IntToHEXStr((INT32U)_v9, s);
	s[8] = 0;
	dlg->grid.SetItemText(8, 1, s + 6);

	dlg->grid.SetItemTextFmt(9, 1, "%lu", _v10);
	dlg->grid.SetItemTextFmt(10, 1, "%.3f", _v11);

	IntToHEXStr((INT32U)_v12, s);
	s[8] = 0;
	dlg->grid.SetItemText(11, 1, s + 6);


	dlg->grid.Refresh();

#undef	dlg
#include "bcp2packet.h"

}

void CWindow2B::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_2B_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindow2B, CWindow)
END_MESSAGE_MAP()


// CWindow2B message handlers

BOOL CWindow2B::OnInitDialog()
{
	// specify settings
	ini_init(2, ivi_2B);

	// init device selector
	ds_init(dl_2B);

	// init grid
	grid_init(&grid, 16,0, 12,2, 0,1, false, false, th_2B, lh_2B);

	CWindow::OnInitDialog();

	// init periodic handler
	req_init(IDC_2B_ONCE, IDC_2B_PERIODIC, IDC_2B_PERIOD, RESPONSE_PERIOD_IN_SECONDS);

	return TRUE;
}

void CWindow2B::req_periodic(INT8U period)
{
	size = bcp->MakePacket(p, 0x2B, ds_get(), period);
	bcp->Handler[0x4B] = got4B_2B;
	rnpi_init(0xff, 0);
	sendp();
}

void CWindow2B::req_off()
{
	size = bcp->MakePacket(p, 0x2B, ds_get(), 0x00);
	sendp();
	bcp->Handler[0x4B] = 0;
}

void CWindow2B::req_once()
{
	char *fmtOriginal = bcp->Format[0x2B];
	bcp->Format[0x2B] = "C";

	size = bcp->MakePacket(p, 0x2B, ds_get());
	bcp->Handler[0x4B] = got4B_2B;
	rnpi_init(0xff, 0);
	sendp();

	bcp->Format[0x2B] = fmtOriginal;
}

void CWindow2B::tmr_do()
{
	bcp->Handler[0x4B] = 0;
}