// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow22 dialog

INT8U dl_22[] =
{
	0x80,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

GRID_TOP_HEADER th_22[] =
{
	{65, "ÐÍÏÈ",CELL_FMT_RIGHT,	CELL_FMT_RIGHT},
	{29, "1",	CELL_FMT_CENTER, CELL_FMT_CENTER},
	{29, "2",	CELL_FMT_CENTER, CELL_FMT_CENTER},
	{29, "3",	CELL_FMT_CENTER, CELL_FMT_CENTER},
	{29, "4",	CELL_FMT_CENTER, CELL_FMT_CENTER}
};

GRID_LEFT_HEADER lh_22[] =
{
	0,
	"×àñò. ïëàí"
};

INI_VALUE_INFO ivi_22[] =
{
	{"plan", INI_TYPE_COMBOBOX, IDC_22_PLAN, 0}
};

IMPLEMENT_DYNAMIC(CWindow22, CWindow)
CWindow22::CWindow22(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID),
	rnpi_got(0)
{
	Create(IDD, pParent);
}

CWindow22::~CWindow22()
{
	bcp->Handler[0x4C] = 0;
}

void got4C_22(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow22*) (mdlg->wnd[WND_22]) )
#define	BCP_PACKET		0x4C
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;

	// get plan
	CString s;
	if (_plan > 1)
		s = "?";
	else
		s.Format("%d", _plan);

	// show plan
	dlg->grid.SetItemText(1, (_rnpi != 0x40) ? (_rnpi >> 4) + 1 : 4 , s);
	dlg->grid.Refresh();

	if (dlg->rnpi_done())
	{
		dlg->tmr_off();
		dlg->tmr_do();
	}

#undef	dlg
#include "bcp2packet.h"

}

void CWindow22::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_22_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindow22, CWindow)
	ON_BN_CLICKED(IDC_22_GET, OnBnClicked22Get)
	ON_BN_CLICKED(IDC_22_SET, OnBnClicked22Set)
END_MESSAGE_MAP()


// CWindow22 message handlers

BOOL CWindow22::OnInitDialog()
{
	// specify settings
	ini_init(1, ivi_22);

	// init device selector
	ds_init(dl_22);

	SetDlgItemText(IDC_22_GET, TITLE_GET);
	SetDlgItemText(IDC_22_SET, TITLE_SET);

	// init grid
	grid_init(&grid, 19,0, 2,5, 1,1, false, false, th_22, lh_22);

	CWindow::OnInitDialog();

	OnBnClicked22Get();

	return TRUE;
}

void CWindow22::OnBnClicked22Get()
{
	char *fmtOriginal = bcp->Format[0x22];
	bcp->Format[0x22] = "C";

	size = bcp->MakePacket(p, 0x22, ds_get());
	bcp->Handler[0x4C] = got4C_22;
	rnpi_init(0xff, 0);
	tmr_on();
	sendp();

	bcp->Format[0x22] = fmtOriginal;

	SwitchInterface(false);
}

void CWindow22::OnBnClicked22Set()
{
	size = bcp->MakePacket(p, 0x22, ds_get(), (INT8U)SendDlgItemMessage(IDC_22_PLAN, CB_GETCURSEL, 0, 0));
	bcp->Handler[0x4C] = got4C_22;
	rnpi_init(0xff, 0);
	tmr_on();
	sendp();

	SwitchInterface(false);
}

void CWindow22::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_22_GET, OnOff);
	ENABLE_ITEM(IDC_22_SET, OnOff);
}

void CWindow22::tmr_do()
{
	bcp->Handler[0x4C] = 0;
	SwitchInterface(true);
}