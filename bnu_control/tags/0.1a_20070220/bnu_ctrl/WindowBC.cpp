// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// WindowBC dialog

GRID_TOP_HEADER th_BC[] =
{
	{120, 0, CELL_FMT_LEFT, CELL_FMT_LEFT},
	{100, "1", CELL_FMT_CENTER, CELL_FMT_LEFT},
	{100, "2", CELL_FMT_CENTER, CELL_FMT_LEFT},
	{100, "3", CELL_FMT_CENTER, CELL_FMT_LEFT},
	{100, "4", CELL_FMT_CENTER, CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_BC[] =
{
	"Номер базовой линии",
	"Время GPS",
	"Проекция X",
	"Проекция Y",
	"Проекция Z",
	"НКА GPS",
	"НКА ГЛОНАСС",
	"Призн. достоверности"
};

INI_VALUE_INFO ivi_BC[] =
{
	{"base_line", INI_TYPE_COMBOBOX, IDC_BC_BASE_LINE, 0}
};

IMPLEMENT_DYNAMIC(CWindowBC, CWindow)

CWindowBC::CWindowBC(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID),
	is_on(false)
{
	Create(IDD, pParent);
}

CWindowBC::~CWindowBC()
{
	bcp->Handler[0xBD] = 0;
	if (is_on)
		OnBnClickedBcOff();
}

void gotBD_BC(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowBC*) (mdlg->wnd[WND_BC]) )
#define	BCP_PACKET		0xBD
#include "bcp2packet.h"

	if (dlg->isMinimized)
		return;
			
	// check base line number
	if (!_base_num)
		return;

	// gps time, projections
	for (int i=0; i<4; i++)
		dlg->grid.SetItemTextFmt(i+1, _base_num, "%.3f", _v[i]);

	// count of gps/gln
	dlg->grid.SetItemTextFmt(5, _base_num, "%d", _gps_num);
	dlg->grid.SetItemTextFmt(6, _base_num, "%d", _gln_num);

	// flag
	dlg->grid.SetItemTextFmt(7, _base_num, "%d", _flag);

	dlg->grid.Refresh();

#undef	dlg
#include "bcp2packet.h"

}

void CWindowBC::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_BC_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindowBC, CWindow)
	ON_BN_CLICKED(IDC_BC_ON, &CWindowBC::OnBnClickedBcOn)
	ON_BN_CLICKED(IDC_BC_OFF, &CWindowBC::OnBnClickedBcOff)
END_MESSAGE_MAP()


// WindowBA message handlers

BOOL CWindowBC::OnInitDialog()
{
	// specify settings
	ini_init(1, ivi_BC);

	// init grid
	grid_init(&grid, 18,0, 8,5, 1,1, false, false, th_BC, lh_BC);

	SetDlgItemText(IDC_BC_ON, TITLE_ON);
	SetDlgItemText(IDC_BC_OFF, TITLE_OFF);

	CWindow::OnInitDialog();

	SwitchInterface();

	return TRUE;
}

void CWindowBC::OnBnClickedBcOn()
{
	// clear cells
	for (int i=1; i<8; i++)
		for (int j=1; j<5; j++)
			grid.SetItemText(i, j, "");
	grid.Refresh();

 	// get base line
	INT8U n = (INT8U)SendDlgItemMessage(IDC_BC_BASE_LINE, CB_GETCURSEL, 0, 0);
	if (n < 4)
		n = 1 << n;
	else
		n = 0x0F;

	// send request
	size = bcp->MakePacket(p, 0xBC, n);
	bcp->Handler[0xBD] = gotBD_BC;
	is_on = true;
	sendp();

	SwitchInterface();
}

void CWindowBC::OnBnClickedBcOff()
{
	size = bcp->MakePacket(p, 0xBC, 0);
	bcp->Handler[0xBD] = 0;
	is_on = false;
	sendp();

	SwitchInterface();
}

void CWindowBC::SwitchInterface()
{
	ENABLE_ITEM(IDC_BC_BASE_LINE, !is_on);
	ENABLE_ITEM(IDC_BC_ON, !is_on);
	ENABLE_ITEM(IDC_BC_OFF, is_on);	
}