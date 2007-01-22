#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow24 dialog

INT8U dl_24[] =
{
	0x00,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

GRID_TOP_HEADER th_24[] =
{
	{20, "№",		CELL_FMT_CENTER, 0},
	{60, "Система",	CELL_FMT_CENTER, 0},
	{40, "Номер",	CELL_FMT_CENTER, 0},
	{36, "Угол",	CELL_FMT_CENTER, 0},
	{50, "Азимут",	CELL_FMT_CENTER, 0},
	{41, "С/Ш",		CELL_FMT_CENTER, 0}
};

INI_VALUE_INFO ivi_24[] =
{
	{"req_periodic",	INI_TYPE_CHECKBOX,	IDC_24_PERIODIC, 0},
	{"req_period",		INI_TYPE_EDIT,		IDC_24_PERIOD, 0}
};

IMPLEMENT_DYNAMIC(CWindow24, CWindow)
CWindow24::CWindow24(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow24::~CWindow24()
{
	bcp->Handler[0x52] = 0;
	req_free();
}

void got52_24(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow24*) (mdlg->wnd[WND_24]) )
#define	BCP_PACKET		0x52
#include "bcp2packet.h"

	if ( !(dlg->rnpi_add(_rnpi) || _satellites == 0) )
		return;

	// if once then stop catching
	if (dlg->req_if_once())
	{
		dlg->tmr_off();
		bcp->Handler[0x52] = 0;
	}
	// reset rnpi-checker
	else
		dlg->rnpi_init(0xff, 0);

	if (dlg->isMinimized)
		return;

	// check if no satellites
	if (!_satellites)
	{
		dlg->grid.DeleteNonFixedRows();
		dlg->grid.Refresh();
		return;
	}

	CString s;

	// clear unused rows or add new ones
	int j = dlg->grid.GetRowCount() - 1;			// current satellites count in table
	if (_satellites != j)
		if (_satellites < j)
			for (int i = j; i > _satellites; i--)
				dlg->grid.DeleteRow(i);
		else
			for (int i = j + 1; i <= _satellites; i++)
			{
				// add row
				s.Format("%d", i);
				dlg->grid.InsertRow(s);

				// set up format of new row
				dlg->grid.SetItemFormat(i, 0, CELL_FMT_RIGHT);
				dlg->grid.SetItemFormat(i, 1, CELL_FMT_LEFT);
				for (int k=2; k<6; k++)
					dlg->grid.SetItemFormat(i, k, CELL_FMT_CENTER);
			}

	// show info
	for (int i = 0; i < _satellites; i++)
	{
		// system
		int sys = _system(i);
		sys--;
		if (sys > 1)
			s = "?";
		else
			if (sys == 0)
				s = "GPS";
			else
				s = "ГЛОНАСС";
		dlg->grid.SetItemText(i+1, 1, s);

		// num
		dlg->grid.SetItemTextFmt(i+1, 2, "%lu", _si[i].num);

		// angle
		dlg->grid.SetItemTextFmt(i+1, 3, "%lu", _si[i].angle);

		// azimuth
		dlg->grid.SetItemTextFmt(i+1, 4, "%lu", _si[i].azimuth);

		// s2n_ratio
		dlg->grid.SetItemTextFmt(i+1, 5, "%lu", _si[i].s2n_ratio);
	}

	dlg->grid.Refresh();

#undef	dlg
#include "bcp2packet.h"

}

void CWindow24::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_24_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindow24, CWindow)
END_MESSAGE_MAP()


// CWindow24 message handlers

BOOL CWindow24::OnInitDialog()
{
	// specify settings
	ini_init(2, ivi_24);

	// init grid
	grid_init(&grid, 16,0, 1,6, 1,1, false, false, th_24, 0);

	// init device selector
	ds_init(dl_24);

	CWindow::OnInitDialog();

	// init periodic handler
	req_init(IDC_24_ONCE, IDC_24_PERIODIC, IDC_24_PERIOD, RESPONSE_PERIOD_IN_SECONDS);

	return TRUE;
}

void CWindow24::req_periodic(INT8U period)
{
	size = bcp->MakePacket(p, 0x24, ds_get(), period);
	bcp->Handler[0x52] = got52_24;
	rnpi_init(0xff, 0);
	sendp();
}

void CWindow24::req_off()
{
	size = bcp->MakePacket(p, 0x24, ds_get(), 0x00);
	sendp();
	bcp->Handler[0x52] = 0;
}

void CWindow24::req_once()
{
	char *fmtOriginal = bcp->Format[0x24];
	bcp->Format[0x24] = "C";

	size = bcp->MakePacket(p, 0x24, ds_get());
	bcp->Handler[0x52] = got52_24;
	rnpi_init(0xff, 0);
	sendp();

	bcp->Format[0x24] = fmtOriginal;
}

void CWindow24::tmr_do()
{
	bcp->Handler[0x52] = 0;
}