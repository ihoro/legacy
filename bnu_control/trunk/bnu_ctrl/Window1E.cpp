// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow1E dialog

INT8U dl_1E[] =
{
	0x00,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

GRID_TOP_HEADER th_1E[] =
{
	{80, 0, CELL_FMT_RIGHT, CELL_FMT_RIGHT},
	{85, 0, CELL_FMT_LEFT,	CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_1E[] =
{
	"GPS-прибор",
	"ГЛН-прибор",
	"GPS-UTC",
	"ГЛН-UTC(SU)",
	"GPS-ГЛН"
};

GRID_TOP_HEADER th2_1E[2] =
{
	{70, 0, CELL_FMT_RIGHT,		CELL_FMT_RIGHT},
	{30, 0, CELL_FMT_CENTER,	CELL_FMT_CENTER}
};

GRID_LEFT_HEADER lh2_1E[4] =
{
	"GPS",
	"ГЛОНАСС",
	"UTC",
	"UTC(SU)"
};

IMPLEMENT_DYNAMIC(CWindow1E, CWindow)
CWindow1E::CWindow1E(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow1E::~CWindow1E()
{
	bcp->Handler[0x74] = 0;
}

void got74_1E(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow1E*) (mdlg->wnd[WND_1E]) )
#define	BCP_PACKET		0x74
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;

	// show diffs
	for (int i=0; i<5; i++)
		dlg->grid.SetItemTextFmt(i, 1, "%.6f", bcp->to64(_v + i*10));
	dlg->grid.Refresh();

	// show stats
	for (int i=0; i<4; i++)
		dlg->grid2.SetItemTextFmt(i, 1, "%d",
									 ( _flag & (1 << i) ) >> i );
	dlg->grid2.Refresh();

	dlg->tmr_off();
	bcp->Handler[0x74] = 0;
	dlg->SwitchInterface(true);

#undef	dlg
#include "bcp2packet.h"

}

void CWindow1E::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_1E_GRID, grid);
	DDX_GridControl(pDX, IDC_1E_GRID2, grid2);
}


BEGIN_MESSAGE_MAP(CWindow1E, CWindow)
END_MESSAGE_MAP()


// CWindow1E message handlers

BOOL CWindow1E::OnInitDialog()
{
	// init device selector
	ds_init(dl_1E);

	CWindow::OnInitDialog();

	SetDlgItemText(IDC_1E_GET, TITLE_GET);

	// init grid
	grid_init(&grid, 18,0, 5,2, 0,1, false, false, th_1E, lh_1E);

	// init grid2
	grid_init(&grid2, 18,0, 4,2, 0,1, false, false, th2_1E, lh2_1E);

	// get info
	size = bcp->MakePacket(p, 0x1E, ds_get());
	rnpi_init(0xff, 0);
	bcp->Handler[0x74] = got74_1E;
	tmr_on();
	sendp();

	return TRUE;
}

void CWindow1E::SwitchInterface(bool OnOff)
{
	SetDlgItemText(IDC_1E_STATUS, OnOff ? "Ответ получен." : "Нет ответа.");
}

void CWindow1E::tmr_do()
{
	bcp->Handler[0x74] = 0;
	SwitchInterface(false);
}