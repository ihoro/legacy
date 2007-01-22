#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow39 dialog

INT8U dl_39[] =
{
	0x00,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

GRID_TOP_HEADER th_39[] =
{
	{20, "№",			CELL_FMT_CENTER, CELL_FMT_RIGHT},
	{60, "Система",		CELL_FMT_CENTER, CELL_FMT_LEFT},
	{40, "Л/Ном",		CELL_FMT_CENTER, CELL_FMT_LEFT},
	{35, "С/Ш",			CELL_FMT_CENTER, CELL_FMT_LEFT},
	{50, "Статус",		CELL_FMT_CENTER, CELL_FMT_CENTER},
	{40, "Сост.",		CELL_FMT_CENTER, CELL_FMT_CENTER},
	{70, "Дальность",	CELL_FMT_CENTER, CELL_FMT_LEFT},
	{50, "Доплер",		CELL_FMT_CENTER, CELL_FMT_CENTER},
	{65, "Призн. д.",	CELL_FMT_CENTER, CELL_FMT_CENTER}
};

INI_VALUE_INFO ivi_39[] =
{
	{"req_periodic",	INI_TYPE_CHECKBOX,	IDC_39_PERIODIC, 0},
	{"req_period",		INI_TYPE_EDIT,		IDC_39_PERIOD, 0}
};

IMPLEMENT_DYNAMIC(CWindow39, CWindow)
CWindow39::CWindow39(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow39::~CWindow39()
{
	bcp->Handler[0x87] = 0;
	req_free();
}

void got87_39(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow39*) (mdlg->wnd[WND_39]) )
#define	BCP_PACKET		0x87
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;

	// if once then stop catching
	if (dlg->req_if_once())
	{
		dlg->tmr_off();
		bcp->Handler[0x87] = 0;
	}
	// reset rnpi-checker
	else
		dlg->rnpi_init(0xff, 0);

	if (dlg->isMinimized)
		return;
	
	CString s;

	// clear unused cells
	for (int i = _channels + 1; i<25; i++)
		for (int j=1; j<9; j++)
			dlg->grid.SetItemText(i, j, "");

	// show new data
	for (int i=0; i < _channels; i++)
	{
		// system
		if (_ci[i].system >= 1  &&  _ci[i].system <= 6)
			s.LoadString(IDS_39_SYSTEM_GPS + _ci[i].system - 1);
		else
			s = "?";
		dlg->grid.SetItemText(i+1, 1, s);

		// num
		int n = _ci[i].num;
		if (_ci[i].system == 1 || _ci[i].system == 4)
		{
			s = "%lu";
			n = (INT8U)_ci[i].num;
		}
		else
			s = "%d";
		dlg->grid.SetItemTextFmt(i+1, 2, s, n);
		
		// s2n_ratio
		dlg->grid.SetItemTextFmt(i+1, 3, "%d", _ci[i].s2n_ratio);

		// status
		if (_ci[i].status >= 0  &&  _ci[i].status <= 3)
			s.LoadString(IDS_39_STATUS_AUTO + _ci[i].status);
		else
			s = "?";
		dlg->grid.SetItemText(i+1, 4, s);
		
		// state
		IntToHEXStr((int)_ci[i].state, s.GetBufferSetLength(8));
		dlg->grid.SetItemText(i+1, 5, s.GetBuffer() + 4);
		
		// pseudorange
		dlg->grid.SetItemTextFmt(i+1, 6, "%.6f", _ci[i].pseudorange);

		// doplers integral
		dlg->grid.SetItemTextFmt(i+1, 7, "%.1f", _ci[i].dopplers_integral);

		// pseudorange_flag
		if (_ci[i].pseudorange_flag >= -1  &&  _ci[i].pseudorange_flag <= 1)
		{
			s.LoadString(IDS_39_FLAG_NORMAL + _ci[i].pseudorange_flag + 1);			
			dlg->grid.SetItemText(i+1, 8, s);
		}
		else
			dlg->grid.SetItemText(i+1, 8, "?");
	}

	dlg->grid.Refresh();

#undef	dlg
#include "bcp2packet.h"

}

void CWindow39::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_39_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindow39, CWindow)
END_MESSAGE_MAP()


// CWindow39 message handlers

BOOL CWindow39::OnInitDialog()
{
	// specify settings
	ini_init(2, ivi_39);

	// init device selector
	ds_init(dl_39);

	// init grid
	grid_init(&grid, 16,0, 25,9, 1,1, false, false, th_39, 0);

	// left header
	for (int i=1; i<25; i++)
		grid.SetItemTextFmt(i, 0, "%d", i);

	CWindow::OnInitDialog();

	// init periodic handler
	req_init(IDC_39_ONCE, IDC_39_PERIODIC, IDC_39_PERIOD);

	return TRUE;
}

void CWindow39::req_periodic(INT8U period)
{
	size = bcp->MakePacket(p, 0x39, ds_get(), period);
	bcp->Handler[0x87] = got87_39;
	rnpi_init(0xff, 0);
	sendp();
}

void CWindow39::req_off()
{
	size = bcp->MakePacket(p, 0x39, ds_get(), 0x00);
	sendp();
	bcp->Handler[0x87] = 0;
}

void CWindow39::req_once()
{
	char *fmtOriginal = bcp->Format[0x39];
	bcp->Format[0x39] = "C";

	size = bcp->MakePacket(p, 0x39, ds_get());
	bcp->Handler[0x87] = got87_39;
	rnpi_init(0xff, 0);
	sendp();

	bcp->Format[0x39] = fmtOriginal;
}

void CWindow39::tmr_do()
{
	bcp->Handler[0x87] = 0;
}