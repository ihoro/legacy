// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// WindowBA dialog

GRID_TOP_HEADER th_BA[] =
{
	{120, 0, CELL_FMT_LEFT, CELL_FMT_LEFT},
	{100, "1", CELL_FMT_CENTER, CELL_FMT_LEFT},
	{100, "2", CELL_FMT_CENTER, CELL_FMT_LEFT},
	{100, "3", CELL_FMT_CENTER, CELL_FMT_LEFT},
	{100, "4", CELL_FMT_CENTER, CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_BA[] =
{
	"Номер базовой линии",
	"Время GPS",
	"Проекция X",
	"Проекция Y",
	"Проекция Z",
	"Скорость X",
	"Скорость Y",
	"Скорость Z",
	"НКА GPS",
	"НКА ГЛОНАСС",
	"Статистика Фишера",
	"Порог для статистики"
};

INI_VALUE_INFO ivi_BA[] =
{
	{"base_line", INI_TYPE_COMBOBOX, IDC_BA_BASE_LINE, 0}
};

IMPLEMENT_DYNAMIC(CWindowBA, CWindow)

CWindowBA::CWindowBA(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID),
	is_on(false)
{
	Create(IDD, pParent);
}

CWindowBA::~CWindowBA()
{
	bcp->Handler[0xCA] = 0;
	if (is_on)
		OnBnClickedBaOff();
}

void gotCA_BA(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowBA*) (mdlg->wnd[WND_BA]) )
#define	BCP_PACKET		0xCA
#include "bcp2packet.h"

	if (dlg->isMinimized)
		return;
			
	// check base line number
	if (!_base_num)
		return;

	// gps time, projections, speeds
	for (int i=0; i<7; i++)
		dlg->grid.SetItemTextFmt(i+1, _base_num, "%.3f", _v[i]);

	// count of gps/gln
	dlg->grid.SetItemTextFmt(8, _base_num, "%d", _gps_num);
	dlg->grid.SetItemTextFmt(9, _base_num, "%d", _gln_num);

	// fisher
	dlg->grid.SetItemTextFmt(10, _base_num, "%.3f", _fisher_stat);
	dlg->grid.SetItemTextFmt(11, _base_num, "%.3f", _fisher_threshold);

	dlg->grid.Refresh();

#undef	dlg
#include "bcp2packet.h"

}

void CWindowBA::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_BA_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindowBA, CWindow)
	ON_BN_CLICKED(IDC_BA_ON, &CWindowBA::OnBnClickedBaOn)
	ON_BN_CLICKED(IDC_BA_OFF, &CWindowBA::OnBnClickedBaOff)
END_MESSAGE_MAP()


// WindowBA message handlers

BOOL CWindowBA::OnInitDialog()
{
	// specify settings
	ini_init(1, ivi_BA);

	// init grid
	grid_init(&grid, 18,0, 12,5, 1,1, false, false, th_BA, lh_BA);

	SetDlgItemText(IDC_BA_ON, TITLE_ON);
	SetDlgItemText(IDC_BA_OFF, TITLE_OFF);

	CWindow::OnInitDialog();

	SwitchInterface();

	return TRUE;
}

void CWindowBA::OnBnClickedBaOn()
{
	// clear cells
	for (int i=1; i<12; i++)
		for (int j=1; j<5; j++)
			grid.SetItemText(i, j, "");
	grid.Refresh();

 	// get base line
	INT8U n = (INT8U)SendDlgItemMessage(IDC_BA_BASE_LINE, CB_GETCURSEL, 0, 0);
	if (n < 4)
		n = 1 << n;
	else
		n = 0x0F;

	// send request
	size = bcp->MakePacket(p, 0xBA, n);
	bcp->Handler[0xCA] = gotCA_BA;
	is_on = true;
	sendp();

	SwitchInterface();
}

void CWindowBA::OnBnClickedBaOff()
{
	size = bcp->MakePacket(p, 0xBA, 0);
	bcp->Handler[0xCA] = 0;
	is_on = false;
	sendp();

	SwitchInterface();
}

void CWindowBA::SwitchInterface()
{
	ENABLE_ITEM(IDC_BA_BASE_LINE, !is_on);
	ENABLE_ITEM(IDC_BA_ON, !is_on);
	ENABLE_ITEM(IDC_BA_OFF, is_on);	
}