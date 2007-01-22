#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow25 dialog

INT8U dl_25[] =
{
	0x00,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

GRID_TOP_HEADER th_25[] =
{
	{70, 0, CELL_FMT_RIGHT,	CELL_FMT_RIGHT},
	{90, 0, CELL_FMT_LEFT,	CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_25[] =
{
	"Дата",
	"Время",
	"Отклон. ОГ"
};

GRID_TOP_HEADER th2_25[] =
{
	{130,	0, CELL_FMT_RIGHT,	CELL_FMT_RIGHT},
	{30,	0, CELL_FMT_CENTER,	CELL_FMT_CENTER}
};

GRID_LEFT_HEADER lh2_25[] =
{
	"Решение",
	"2D решение",
	"Исп. дифф. поправок",
	"RAIM",
	"Дифф. режим"
};

IMPLEMENT_DYNAMIC(CWindow25, CWindow)
CWindow25::CWindow25(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID),
	is_on(false)
{
	Create(IDD, pParent);
}

CWindow25::~CWindow25()
{
	bcp->Handler[0x53] = 0;
	if (is_on)
		OnBnClicked25Off();
}

void got53_25(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow25*) (mdlg->wnd[WND_25]) )
#define	BCP_PACKET		0x53
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;

	// get date/time
	BCP_TIME t;
	bcp->DecodeBCPTime(_week, bcp->to64(_time), t);

	// show date
	dlg->grid.SetItemTextFmt(0, 1, "%.2d.%.2d.%.4d", t.day, t.month, t.year);

	// show time
	dlg->grid.SetItemTextFmt(1, 1, "%.2d:%.2d:%.2d", t.hour, t.minute, t.second);

	// show diff_OG
	dlg->grid.SetItemTextFmt(2, 1, "%.2f", _diff_OG);

	// show solution
	dlg->grid2.SetItemTextFmt(0, 1, "%d", _solution);

	// show _2D
	dlg->grid2.SetItemTextFmt(1, 1, "%d", _2D);

	// show diff_use
	dlg->grid2.SetItemTextFmt(2, 1, "%d", _diff_use);

	// show RAIM
	dlg->grid2.SetItemTextFmt(3, 1, "%d", _RAIM);

	// show diff_mode
	dlg->grid2.SetItemTextFmt(4, 1, "%d", _diff_mode);


	dlg->grid.Refresh();
	dlg->grid2.Refresh();

#undef	dlg
#include "bcp2packet.h"

}

void CWindow25::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_25_GRID, grid);
	DDX_Control(pDX, IDC_25_GRID2, grid2);
}


BEGIN_MESSAGE_MAP(CWindow25, CWindow)
	ON_BN_CLICKED(IDC_25_ON, OnBnClicked25On)
	ON_BN_CLICKED(IDC_25_OFF, OnBnClicked25Off)
END_MESSAGE_MAP()


// CWindow25 message handlers

BOOL CWindow25::OnInitDialog()
{
	// init device selector
	ds_init(dl_25);

	CWindow::OnInitDialog();

	SetDlgItemText(IDC_25_ON, TITLE_ON);
	SetDlgItemText(IDC_25_OFF, TITLE_OFF);

	// init grid
	grid_init(&grid, 16,0, 3,2, 0,1, false, false, th_25, lh_25);

	// init grid2
	grid_init(&grid2, 16,0, 5,2, 0,1, false, false, th2_25, lh2_25);


	// defaults
	SwitchInterface();

	return TRUE;
}

void CWindow25::SwitchInterface()
{
	ENABLE_ITEM(IDC_25_ON, !is_on);
	ENABLE_ITEM(IDC_25_OFF, is_on);
}

void CWindow25::OnBnClicked25On()
{
	size = bcp->MakePacket(p, 0x25, ds_get() | 0x01);
	bcp->Handler[0x53] = got53_25;
	rnpi_init(0xff, 0);
	is_on = true;
	sendp();

	SwitchInterface();
}

void CWindow25::OnBnClicked25Off()
{
	size = bcp->MakePacket(p, 0x25, ds_get());
	bcp->Handler[0x53] = 0;
	is_on = false;
	sendp();
	SwitchInterface();
}
