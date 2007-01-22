#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowAA dialog

GRID_TOP_HEADER th_AA[] =
{
	{110,	0, CELL_FMT_RIGHT, CELL_FMT_RIGHT},
	{107,	0, CELL_FMT_LEFT, CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_AA[] =
{
	"Широта",
	"Долгота",
	"Высота, м",
	"СКО, м",
	"Дата",
	"Время",
	"Скорость по шир.",
	"Скорость по долг.",
	"Скорость по выс."
};

GRID_TOP_HEADER th2_AA[] =
{
	{217-30,0, CELL_FMT_RIGHT,	CELL_FMT_RIGHT},
	{30,	0, CELL_FMT_CENTER,	CELL_FMT_CENTER}
};

GRID_LEFT_HEADER lh2_AA[] =
{
	"Решение",
	"2D решение",
	"Использование дифф. поправок",
	"RAIM",
	"Дифференциальный режим"
};

INI_VALUE_INFO ivi_AA[] =
{
	{"req_periodic",	INI_TYPE_CHECKBOX,	IDC_AA_PERIODIC, 0},
	{"req_period",		INI_TYPE_EDIT,		IDC_AA_PERIOD, 0},
	{"num",				INI_TYPE_EDIT,		IDC_AA_NUM, 0}
};

IMPLEMENT_DYNAMIC(CWindowAA, CWindow)
CWindowAA::CWindowAA(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindowAA::~CWindowAA()
{
	bcp->Handler[0xAB] = 0;
	req_free();
}

void gotAB_AA(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowAA*) (mdlg->wnd[WND_AA]) )
#define	BCP_PACKET		0xAB
#include "bcp2packet.h"

	// check point
	if (_point_num != dlg->point)
		return;

	// if once then stop catching
	if (dlg->req_if_once())
	{
		dlg->tmr_off();
		bcp->Handler[0xAB] = 0;
	}

	if (dlg->isMinimized)
		return;

	// show info
	////////////
	
	int deg;
	double min;
	char c;

	// latitude
	if (_latitude < 0)
	{
		c = 'S';
		_latitude = -_latitude;
	}
	else
		c = 'N';
	deg = (char)(_latitude / (PI/180));
	min = (_latitude / (PI/180) - deg) * 60;
	dlg->grid.SetItemTextFmt(0, 1, "%.2u\xB0%07.4f%c", deg, min, c);

	// longitude
	if (_longitude < 0)
	{
		c = 'W';
		_longitude = -_longitude;
	}
	else
		c = 'E';
	deg = (char)(_longitude / (PI/180));
	min = (_longitude / (PI/180) - deg) * 60;
	dlg->grid.SetItemTextFmt(1, 1, "%.3u\xB0%07.4f%c", deg, min, c);

	// height
	dlg->grid.SetItemTextFmt(2, 1, "%.3f", _height);

	// RMS
	dlg->grid.SetItemTextFmt(3, 1, "%.3f", _RMS);

	// decode time
	BCP_TIME t;
	bcp->DecodeBCPTime(_week, _time, t);

	// date
	dlg->grid.SetItemTextFmt(4, 1, "%.2u.%.2u.%.4u", t.day, t.month, t.year);

	// time
	dlg->grid.SetItemTextFmt(5, 1, "%.2u:%.2u:%.2u", t.hour, t.minute, t.second);

	// speeds
	for (int i=6; i<9; i++)
		dlg->grid.SetItemTextFmt(i, 1, "%.3f", _speed[i-6]);

	// status bits
	dlg->grid2.SetItemTextFmt(0, 1, "%d", _decision);
	dlg->grid2.SetItemTextFmt(1, 1, "%d", _2D);
	dlg->grid2.SetItemTextFmt(2, 1, "%d", _diff);
	dlg->grid2.SetItemTextFmt(3, 1, "%d", _RAIM);
	dlg->grid2.SetItemTextFmt(4, 1, "%d", _diff_mode);

	// update
	dlg->grid.Refresh();
	dlg->grid2.Refresh();

#undef	dlg
#include "bcp2packet.h"

}

void CWindowAA::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_AA_GRID, grid);
	DDX_GridControl(pDX, IDC_AA_GRID2, grid2);
}


BEGIN_MESSAGE_MAP(CWindowAA, CWindow)
	ON_EN_CHANGE(IDC_AA_NUM, OnEnChangeAaNum)
END_MESSAGE_MAP()


// CWindowAA message handlers

BOOL CWindowAA::OnInitDialog()
{
	// specify settings
	ini_init(3, ivi_AA);

	// init grid
	grid_init(&grid, 16,0, 9,2, 0,1, false, false, th_AA, lh_AA);

	// init grid2
	grid_init(&grid2, 16,0, 5,2, 0,1, false, false, th2_AA, lh2_AA);

	CWindow::OnInitDialog();

	// init periodic handler
	req_init(IDC_AA_ONCE, IDC_AA_PERIODIC, IDC_AA_PERIOD);

	return TRUE;
}

void CWindowAA::req_periodic(INT8U period)
{
	size = bcp->MakePacket(p, 0xAA, point, period);
	bcp->Handler[0xAB] = gotAB_AA;
	sendp();
}

void CWindowAA::req_off()
{
	size = bcp->MakePacket(p, 0xAA, point, 0x00);
	sendp();
	bcp->Handler[0xAB] = 0;
}

void CWindowAA::req_once()
{
	char *fmtOriginal = bcp->Format[0xAA];
	bcp->Format[0xAA] = "C";

	size = bcp->MakePacket(p, 0xAA, point);
	bcp->Handler[0xAB] = gotAB_AA;
	sendp();

	bcp->Format[0xAA] = fmtOriginal;
}

void CWindowAA::tmr_do()
{
	bcp->Handler[0xAB] = 0;
}

void CWindowAA::OnEnChangeAaNum()
{
	// check point
	int i = GetDlgItemInt(IDC_AA_NUM, 0, 0);
	if (i > 255)
	{
		i = 255;
		SetDlgItemInt(IDC_AA_NUM, i, 0);
	}

	// cancel current request if it's in periodic mode
	if ( !req_if_once() )
		req_off();

	// set new point
	point = (INT8U)i;

	// send new request if it's in periodic mode
	if ( !req_if_once() )
		req_periodic((INT8U)GetDlgItemInt(IDC_AA_PERIOD, 0, 0));
}
