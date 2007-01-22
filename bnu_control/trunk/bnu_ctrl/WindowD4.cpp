#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowD4 dialog

INT8U dl_D4[] =
{
	0x00,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

GRID_TOP_HEADER th_D4[] =
{
	{20, "№",			CELL_FMT_CENTER, CELL_FMT_RIGHT},
	{60, "Система",		CELL_FMT_CENTER, CELL_FMT_LEFT},
	{40, "Ном/Л",		CELL_FMT_CENTER, CELL_FMT_LEFT},
	{35, "С/Ш",			CELL_FMT_CENTER, CELL_FMT_LEFT},
	{50, "Признак",		CELL_FMT_CENTER, CELL_FMT_CENTER},
	{70, "Дальность",	CELL_FMT_CENTER, CELL_FMT_LEFT},
	{80, "Приращение",	CELL_FMT_CENTER, CELL_FMT_LEFT}
};

GRID_TOP_HEADER th2_D4[] =
{	  
	{255,	0, CELL_FMT_RIGHT, CELL_FMT_RIGHT},
	{100,	0, CELL_FMT_LEFT, CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh2_D4[] =
{
	"Интервал формирования измерений, мс",
	"Тип шкалы времени",
	"Время с начала недели, мс",
	"Номер недели GPS",
	"Расхождение времени GPS и UTC, мс",
	"Количество каналов РПУ c измерениями"
};

INI_VALUE_INFO ivi_D4[] =
{
	{"req_periodic",	INI_TYPE_CHECKBOX,	IDC_D4_PERIODIC, 0},
	{"req_period",		INI_TYPE_EDIT,		IDC_D4_PERIOD, 0}
};

IMPLEMENT_DYNAMIC(CWindowD4, CWindow)
CWindowD4::CWindowD4(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindowD4::~CWindowD4()
{
	bcp->Handler[0xE4] = 0;
	req_free();
}

void gotE4_D4(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowD4*) (mdlg->wnd[WND_D4]) )
#define	BCP_PACKET		0xE4
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;

	// if once then stop catching
	if (dlg->req_if_once())
	{
		dlg->tmr_off();
		bcp->Handler[0xE4] = 0;
	}
	// reset rnpi-checker
	else
		dlg->rnpi_init(0xff, 0);

	if (dlg->isMinimized)
		return;

	// clear unused cells
	/////////////////////

	for (int i = _channels + 1; i<25; i++)
		for (int j=1; j<9; j++)
			dlg->grid.SetItemText(i, j, "");

	CString s;

	// show time info
	/////////////////

	// interval
	dlg->grid2.SetItemTextFmt(0, 1, "%lu", _interval);

	// type
	if (_type >= 0 && _type <= 4)
		s.LoadString(IDS_D4_TYPE_0 + _type);
	else
		s = "?";
	dlg->grid2.SetItemText(1, 1, s);

	// time
	dlg->grid2.SetItemTextFmt(2, 1, "%.1f", _time);

	// week
	dlg->grid2.SetItemTextFmt(3, 1, "%d", _week);

	// time_diff
	dlg->grid2.SetItemTextFmt(4, 1, "%.3f", _time_diff);

	// channels
	dlg->grid2.SetItemTextFmt(5, 1, "%lu", _channels);

	dlg->grid2.Refresh();


	// show channels info
	/////////////////////

	for (int i=0; i < _channels; i++)
	{
		// system
		if (_system(i) >= 0  &&  _system(i) <= 6)
			s.LoadString(IDS_D4_SYSTEM_OFF + _system(i));
		else
			s = "?";
		dlg->grid.SetItemText(i+1, 1, s);

		// num/liter
		s.Format("%d", _num(i));
		if ( !(_system(i) == 1 || _system(i) == 4) )
			s.Format("%d/%d", _num(i), _cm[i].liter);
		dlg->grid.SetItemText(i+1, 2, s);
        
		// s2n_ratio
		dlg->grid.SetItemTextFmt(i+1, 3, "%d", _cm[i].s2n_ratio);

		// state
		if (_cm[i].state >= 0  &&  _cm[i].state <= 3)
			s.LoadString(IDS_D4_CM_STATE_0 + _cm[i].state);
		else
			s = "?";
		dlg->grid.SetItemText(i+1, 4, s);

		// pseudorange
		dlg->grid.SetItemTextFmt(i+1, 5, "%.6f", _cm[i].pseudorange);

		// increment
		dlg->grid.SetItemTextFmt(i+1, 6, "%.4f", _cm[i].increment);
	}

	dlg->grid.Refresh();

#undef	dlg
#include "bcp2packet.h"

}

void CWindowD4::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_D4_GRID, grid);
	DDX_GridControl(pDX, IDC_D4_GRID2, grid2);
}


BEGIN_MESSAGE_MAP(CWindowD4, CWindow)
END_MESSAGE_MAP()


// CWindowD4 message handlers

BOOL CWindowD4::OnInitDialog()
{
	// specify settings
	ini_init(2, ivi_D4);

	// init device selector
	ds_init(dl_D4);

	// init grid
	grid_init(&grid, 16,0, 25,7, 1,1, false, false, th_D4, 0);
	
	// left header
	for (int i=1; i<25; i++)
		grid.SetItemTextFmt(i, 0, "%d", i);

	// init grid2
	grid_init(&grid2, 16,0, 6,2, 0,1, false, false, th2_D4, lh2_D4);

	CWindow::OnInitDialog();

	// init periodic handler
	req_init(IDC_D4_ONCE, IDC_D4_PERIODIC, IDC_D4_PERIOD);

	return TRUE;
}

void CWindowD4::req_periodic(INT8U period)
{
	size = bcp->MakePacket(p, 0xD4, ds_get(), period);
	bcp->Handler[0xE4] = gotE4_D4;
	rnpi_init(0xff, 0);
	sendp();
}

void CWindowD4::req_off()
{
	size = bcp->MakePacket(p, 0xD4, ds_get(), 0x00);
	sendp();
	bcp->Handler[0xE4] = 0;
}

void CWindowD4::req_once()
{
	char *fmtOriginal = bcp->Format[0xD4];
	bcp->Format[0xD4] = "C";

	size = bcp->MakePacket(p, 0xD4, ds_get());
	bcp->Handler[0xE4] = gotE4_D4;
	rnpi_init(0xff, 0);
	sendp();

	bcp->Format[0xD4] = fmtOriginal;
}

void CWindowD4::tmr_do()
{
	bcp->Handler[0xE4] = 0;
}