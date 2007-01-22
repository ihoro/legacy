#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow21 dialog

INT8U dl_21[] =
{
	0,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

GRID_TOP_HEADER th_21[] =
{
	{90, 0,				CELL_FMT_RIGHT, CELL_FMT_RIGHT},
	{87, 0,				CELL_FMT_LEFT, CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_21[] =
{
	"Êîë. GPS",
	"Êîë. ÃËÎÍÀÑÑ",
	"HDOP",
	"VDOP"
};

INI_VALUE_INFO ivi_21[] =
{
	{"req_periodic",	INI_TYPE_CHECKBOX,	IDC_21_PERIODIC, 0},
	{"req_period",		INI_TYPE_EDIT,		IDC_21_PERIOD, 0}
};

IMPLEMENT_DYNAMIC(CWindow21, CWindow)
CWindow21::CWindow21(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID),
	waiting(false)
{
	Create(IDD, pParent);
}

CWindow21::~CWindow21()
{
	waiting = false;
	req_free();	
}

void CWindow21::ShowInfo(INT8U *data_ptr)
{

#define BCP_PACKET		0x60
#include "bcp2packet.h"

	if (!rnpi_add(_rnpi))
		return;

	// if once then stop catching
	if (req_if_once())
	{
		tmr_off();
		waiting = false;
	}
	// reset rnpi-checker
	else
		rnpi_init(0xff, 0);

	if (isMinimized)
		return;

	// show info
	grid.SetItemTextFmt(0, 1, "%lu", _gps);
	grid.SetItemTextFmt(1, 1, "%lu", _gln);
	grid.SetItemTextFmt(2, 1, "%.3f", _hdop);
	grid.SetItemTextFmt(3, 1, "%.3f", _vdop);

	grid.Refresh();

#include "bcp2packet.h"

}

void CWindow21::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_21_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindow21, CWindow)
END_MESSAGE_MAP()


// CWindow21 message handlers

BOOL CWindow21::OnInitDialog()
{
	// specify settings
	ini_init(2, ivi_21);

	// init device selector
	ds_init(dl_21);

	// init grid
	grid_init(&grid, 16,0, 4,2, 0,1, false, false, th_21, lh_21);

	CWindow::OnInitDialog();

	// init periodic handler
	req_init(IDC_21_ONCE, IDC_21_PERIODIC, IDC_21_PERIOD, RESPONSE_PERIOD_IN_SECONDS);

	return TRUE;
}

void CWindow21::req_periodic(INT8U period)
{
	size = bcp->MakePacket(p, 0x21, ds_get(), period);
	rnpi_init(0xff, 0);
	waiting = true;
	sendp();
}

void CWindow21::req_off()
{
	size = bcp->MakePacket(p, 0x21, ds_get(), 0x00);
	waiting = false;
	sendp();
}

void CWindow21::req_once()
{
	char *fmtOriginal = bcp->Format[0x21];
	bcp->Format[0x21] = "C";

	size = bcp->MakePacket(p, 0x21, ds_get());
	rnpi_init(0xff, 0);
	waiting = true;
	sendp();

	bcp->Format[0x21] = fmtOriginal;
}

void CWindow21::tmr_do()
{
	waiting = false;
}