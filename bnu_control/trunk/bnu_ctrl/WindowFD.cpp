#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowFD dialog

GRID_TOP_HEADER th_FD[] =
{
	{140, 0, CELL_FMT_RIGHT, CELL_FMT_RIGHT},
	{90, 0, CELL_FMT_LEFT, CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_FD[] =
{
	"Количество отсчетов",
	"Сумма отсчетов АЦП №1",
	"Сумма отсчетов АЦП №2",
	"Сумма отсчетов АЦП №3",
	"Состояние кан. АЦП №4"
};

INI_VALUE_INFO ivi_FD[] =
{
	{"req_periodic",	INI_TYPE_CHECKBOX,	IDC_FD_PERIODIC, 0},
	{"req_period",		INI_TYPE_EDIT,		IDC_FD_PERIOD, 0}
};

IMPLEMENT_DYNAMIC(CWindowFD, CWindow)
CWindowFD::CWindowFD(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindowFD::~CWindowFD()
{
	bcp->Handler[0xFF] = 0;
	req_free();
}

void gotFF_FD(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowFD*) (mdlg->wnd[WND_FD]) )
#define	BCP_PACKET		0xFF
#include "bcp2packet.h"

	// if once then stop catching
	if (dlg->req_if_once())
	{
		dlg->tmr_off();
		bcp->Handler[0x87] = 0;
	}

	if (dlg->isMinimized)
		return;

	// show info
	dlg->grid.SetItemTextFmt(0, 1, "%lu", _count);
	dlg->grid.SetItemTextFmt(1, 1, "%d", _sum1);
	dlg->grid.SetItemTextFmt(2, 1, "%d", _sum2);
	dlg->grid.SetItemTextFmt(3, 1, "%d", _sum3);
	dlg->grid.SetItemTextFmt(4, 1, "%d", _state);

	dlg->grid.Refresh();

#undef	dlg
#include "bcp2packet.h"

}

void CWindowFD::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_FD_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindowFD, CWindow)
END_MESSAGE_MAP()


// CWindowFD message handlers

BOOL CWindowFD::OnInitDialog()
{
	// specify settings
	ini_init(2, ivi_FD);

	// init grid
	grid_init(&grid, 16,0, 5,2, 0,1, false, false, th_FD, lh_FD);

	CWindow::OnInitDialog();

	// init periodic handler
	req_init(IDC_FD_ONCE, IDC_FD_PERIODIC, IDC_FD_PERIOD, 2, 2);

	return TRUE;
}

void CWindowFD::req_periodic(INT8U period)
{
	size = bcp->MakePacket(p, 0xFD, period);
	bcp->Handler[0xFF] = gotFF_FD;
	sendp();
}

void CWindowFD::req_off()
{
	size = bcp->MakePacket(p, 0xFD, 0x00);
	sendp();
	bcp->Handler[0xFF] = 0;
}

void CWindowFD::req_once()
{
	char *fmtOriginal = bcp->Format[0xFD];
	bcp->Format[0xFD] = "";

	size = bcp->MakePacket(p, 0xFD);
	bcp->Handler[0xFF] = gotFF_FD;
	sendp();

	bcp->Format[0xFD] = fmtOriginal;
}

void CWindowFD::tmr_do()
{
	bcp->Handler[0xFF] = 0;
}