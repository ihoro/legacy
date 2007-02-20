// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow23 dialog

INT8U dl_23[] =
{
	0x00,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

GRID_TOP_HEADER th_23[] =
{
	{105,	0, CELL_FMT_RIGHT,	CELL_FMT_RIGHT},
	{65,	0, CELL_FMT_LEFT,	CELL_FMT_LEFT},
	{65,	0, CELL_FMT_LEFT,	CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_23[] =
{
	"Поправка, часы",
	"Поправка, минуты"
};

IMPLEMENT_DYNAMIC(CWindow23, CWindow)
CWindow23::CWindow23(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow23::~CWindow23()
{
	bcp->Handler[0x46] = 0;
}

void got46_23(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow23*) (mdlg->wnd[WND_23]) )
#define	BCP_PACKET		0x46
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;

	CString s;
	s.Format("Дата: %.2lu.%.2lu.%.4lu", _day, _month, _year);
	dlg->SetDlgItemText(IDC_23_DATE, s);

	dlg->grid.SetItemTextFmt(0, 1, "%d", _hour);
	dlg->grid.SetItemTextFmt(1, 1, "%d", _minute);
	dlg->grid.Refresh();

	dlg->tmr_off();
	dlg->tmr_do();

#undef	dlg
#include "bcp2packet.h"

}

void CWindow23::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_23_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindow23, CWindow)
	ON_BN_CLICKED(IDC_23_GET, OnBnClicked23Get)
	ON_BN_CLICKED(IDC_23_SET, OnBnClicked23Set)
END_MESSAGE_MAP()


// CWindow23 message handlers

BOOL CWindow23::OnInitDialog()
{
	// init device selector
	ds_init(dl_23);

	CWindow::OnInitDialog();

	SetDlgItemText(IDC_23_GET, TITLE_GET);
	SetDlgItemText(IDC_23_SET, TITLE_SET);

	// init grid
	grid_init(&grid, 18,0, 2,3, 0,2, true, false, th_23, lh_23);

	return TRUE;
}

void CWindow23::OnBnClicked23Get()
{
	char *fmtOriginal = bcp->Format[0x23];
	bcp->Format[0x23] = "C";

	size = bcp->MakePacket(p, 0x23, ds_get());
	bcp->Handler[0x46] = got46_23;
	rnpi_init(0xff, 0);
	tmr_on();
	sendp();

	bcp->Format[0x23] = fmtOriginal;

	SwitchInterface(false);
}

void CWindow23::OnBnClicked23Set()
{
	CString s;

	// get hour
	s = grid.GetItemText(0, 2);
	int hour = atoi(s);
	if ( !(hour >= -13 && hour <= 13) )
		hour = 0;
	grid.SetItemTextFmt(0, 2, "%d", hour);

	// get minute
	s = grid.GetItemText(1, 2);
	int minute = (INT8S)atoi(s);
	if ( !(minute >= -59 && minute <= 59) )
		minute = 0;
	grid.SetItemTextFmt(1, 2, "%d", minute);

	grid.Refresh();

	// send request
	size = bcp->MakePacket(p, 0x23, ds_get(), hour, minute);
	bcp->Handler[0x46] = got46_23;
	rnpi_init(0xff, 0);
	tmr_on();
	sendp();

	SwitchInterface(false);
}

void CWindow23::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_23_GET, OnOff);
	ENABLE_ITEM(IDC_23_SET, OnOff);
}

void CWindow23::tmr_do()
{
	bcp->Handler[0x46] = 0;
	SwitchInterface(true);
}