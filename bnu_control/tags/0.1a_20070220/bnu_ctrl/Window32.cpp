// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow32 dialog

INT8U dl_32[] =
{
	0x80,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

GRID_TOP_HEADER th_32[] =
{
	{90,	0, CELL_FMT_RIGHT,	CELL_FMT_RIGHT},
	{100,	0, CELL_FMT_LEFT,	CELL_FMT_LEFT},
	{100,	0, CELL_FMT_LEFT,	CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_32[] =
{
	"Широта",
	"Долгота",
	"Высота",
	"СКО координат",
	"Местное время",
	"Дата",
	"Скор. по шир.",
	"Скор. по долг.",
	"Скор. по выс."
};

INI_VALUE_INFO ivi_32[] =
{
	{"set_time",	INI_TYPE_CHECKBOX,		IDC_32_TIME, 0},
	{"set_speed",	INI_TYPE_CHECKBOX,		IDC_32_SPEED, 0},
	{"v%d",			INI_TYPE_GRID_COLUMN,	2, 0}
};

IMPLEMENT_DYNAMIC(CWindow32, CWindow)
CWindow32::CWindow32(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow32::~CWindow32()
{
	bcp->Handler[0x89] = 0;
}

void got89_32(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow32*) (mdlg->wnd[WND_32]) )
#define	BCP_PACKET		0x89
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;

	CString s;

	if
	(
		!(
			_latitude == dlg->v[0].d			&&
			_longitude == dlg->v[1].d			&&
			_height == dlg->v[2].d				&&
			_RMS == dlg->v[3].f					&&
			bcp->to64(_time) == dlg->v[4].D		&&
			_week == dlg->v[5].s				&&
			_latitude_speed == dlg->v[6].d		&&
			_longitude_speed == dlg->v[7].d		&&
			_height_speed == dlg->v[8].d
		)
		|| dlg->rnpi_done()
	)
	{
		// show latitude
		RadiansToCoordStr(_latitude, true, s.GetBufferSetLength(15));
		dlg->grid.SetItemText(0, 1, s);

		// show longitude
		RadiansToCoordStr(_longitude, false, s.GetBufferSetLength(15));
		dlg->grid.SetItemText(1, 1, s);

		// show height
		dlg->grid.SetItemTextFmt(2, 1, "%.3f", _height);

		// show RMS
		dlg->grid.SetItemTextFmt(3, 1, "%.3f", _RMS);

		if (dlg->req_type > 1)
		{
			// decode BCP time
			BCP_TIME t;
			bcp->DecodeBCPTime(_week, bcp->to64(_time), t);

			// show time
			dlg->grid.SetItemTextFmt(4, 1, "%.2d:%.2d:%.2d", t.hour, t.minute, t.second);

			// show date
			dlg->grid.SetItemTextFmt(5, 1, "%.2d.%.2d.%.4d", t.day, t.month, t.year);
		}
		else
		{
			dlg->grid.SetItemText(4, 1, "");
			dlg->grid.SetItemText(5, 1, "");
		}

		if (dlg->req_type == 4)
		{
			// show latitude speed
			dlg->grid.SetItemTextFmt(6, 1, "%.3f", _latitude_speed);

			// show longitude speed
			dlg->grid.SetItemTextFmt(7, 1, "%.3f", _longitude_speed);

			// show height speed
			dlg->grid.SetItemTextFmt(8, 1, "%.3f", _height_speed);
		}
		else
		{
			dlg->grid.SetItemText(6, 1, "");
			dlg->grid.SetItemText(7, 1, "");
			dlg->grid.SetItemText(8, 1, "");
		}

		dlg->grid.Refresh();
	}

	if (dlg->rnpi_done())
	{
		dlg->tmr_off();
		dlg->tmr_do();
	}

#undef	dlg
#include "bcp2packet.h"

}

void CWindow32::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_32_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindow32, CWindow)
	ON_BN_CLICKED(IDC_32_SET, OnBnClicked32Set)
	ON_BN_CLICKED(IDC_32_TIME, OnBnClicked32Time)
END_MESSAGE_MAP()


BOOL CWindow32::OnInitDialog()
{
	// specify settings
	ivi_32[2].grid = &grid;
	ini_init(3, ivi_32);

	// init device selector
	ds_init(dl_32);

	// init grid
	grid_init(&grid, 18,0, 9,3, 0,2, true, false, th_32, lh_32);

	CWindow::OnInitDialog();

	SetDlgItemText(IDC_32_SET, TITLE_SET);

	// init speed checkbox
	OnBnClicked32Time();

	return TRUE;
}

void CWindow32::OnBnClicked32Set()
{
	CString s;
	BCP_TIME t;
	int d,m,y;

	// get latitude
	s = grid.GetItemText(0, 2);
	v[0].d = CoordStrToRadians(s.GetBuffer(), true);
	RadiansToCoordStr(v[0].d, true, s.GetBufferSetLength(15));
	grid.SetItemText(0, 2, s);

	// get longitude
	s = grid.GetItemText(1, 2);
	v[1].d = CoordStrToRadians(s.GetBuffer(), false);
	RadiansToCoordStr(v[1].d, false, s.GetBufferSetLength(15));
	grid.SetItemText(1, 2, s);

	// get height
	s = grid.GetItemText(2, 2);
	FixFloatStr(s.GetBuffer());
	grid.SetItemText(2, 2, s);
	v[2].d = atof(s);

	// get RMS
	s = grid.GetItemText(3, 2);
	FixFloatStr(s.GetBuffer());
	grid.SetItemText(3, 2, s);
	v[3].f = (float)atof(s);

	// get time
	s = grid.GetItemText(4, 2);
	TimeStrToTime(s.GetBuffer(), ":", d, m, y);
	if ( !(d >= 0 && d <= 23) )
		d = 0;
	if ( !(m >= 0 && m <= 59) )
		m = 0;
	if ( !(y >= 0 && y <= 59) )
		y = 0;
	grid.SetItemTextFmt(4, 2, "%.2d:%.2d:%.2d", d, m, y);
	t.hour = (char)d;
	t.minute = (char)m;
	t.second = (char)y;
	t.millisecond = 0;

	// get date
	s = grid.GetItemText(5, 2);
	TimeStrToTime(s.GetBuffer(), ".", d, m, y);
	if ( !(d >= 1 && d <= 31) )
		d = 1;
	if ( !(m >= 1 && m <= 12) )
		m = 1;
	if (y <= 1999)
	{
		y = 1999;
		if (m <= 8)
		{
			m = 8;
			if (d < 22)
				d = 22;
		}
	}
	grid.SetItemTextFmt(5, 2, "%.2d.%.2d.%.4d", d, m, y);
	t.day = (char)d;
	t.month = (char)m;
	t.year = (short)y;

	// encode BCP time
	bcp->EncodeBCPTime(t, v[5].s, v[4].D);

	// get latitude speed
	s = grid.GetItemText(6, 2);
	FixFloatStr(s.GetBuffer());
	grid.SetItemText(6, 2, s);
	v[6].d = atof(s);

	// get longitude speed
	s = grid.GetItemText(7, 2);
	FixFloatStr(s.GetBuffer());
	grid.SetItemText(7, 2, s);
	v[7].d = atof(s);

	// get height speed
	s = grid.GetItemText(8, 2);
	FixFloatStr(s.GetBuffer());
	grid.SetItemText(8, 2, s);
	v[8].d = atof(s);

	grid.Refresh();

	// make request
	char *fmtOriginal = bcp->Format[0x32];
	if (IsDlgButtonChecked(IDC_32_TIME))
		if (IsDlgButtonChecked(IDC_32_SPEED))
		{
			req_type = 4;
			size = bcp->MakePacket(p, 0x32, ds_get(), v[0].d, v[1].d, v[2].d, v[3].L, v[4].D, v[5].s, v[6].d, v[7].d, v[8].d);
		}
		else
		{
			req_type = 2;
			bcp->Format[0x32] = "CdddfDs";
			size = bcp->MakePacket(p, 0x32, ds_get(), v[0].d, v[1].d, v[2].d, v[3].L, v[4].D, v[5].s);
		}
	else
	{
		req_type = 1;
		bcp->Format[0x32] = "Cdddf";
		size = bcp->MakePacket(p, 0x32, ds_get(), v[0].d, v[1].d, v[2].d, v[3].L);
	}
	bcp->Format[0x32] = fmtOriginal;

	// send request
	bcp->Handler[0x89] = got89_32;
	rnpi_init(0xff, 0);
	tmr_on();
	sendp();

	SwitchInterface(false);
}

void CWindow32::OnBnClicked32Time()
{
	if (IsDlgButtonChecked(IDC_32_TIME))
		ENABLE_ITEM(IDC_32_SPEED, true);
	else
		ENABLE_ITEM(IDC_32_SPEED, false);
}

void CWindow32::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_32_SET, OnOff);
}

void CWindow32::tmr_do()
{
	bcp->Handler[0x89] = 0;
	SwitchInterface(true);
}