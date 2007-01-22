#include "stdafx.h"
#include "bnu_ctrl.h"


// grid colors
#define COLOR_BG		GetSysColor(COLOR_WINDOW)
#define COLOR_FG		GetSysColor(COLOR_WINDOWTEXT)


// CWindow12 dialog

INT8U dl_12[] =
{
	0x80,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

IMPLEMENT_DYNAMIC(CWindow12, CWindow)
CWindow12::CWindow12(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow12::~CWindow12()
{
	bcp->Handler[0x47] = 0;
}

void got47_12(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow12*) (mdlg->wnd[WND_12]) )
#define	BCP_PACKET		0x47
#include "bcp2packet.h"

	// check rnpi
	INT8U r;
	if ( !( r = dlg->rnpi_add(_rnpi(0)) ) )
		return;
	
	// update sat_map
	for (int i=0; i < 32+24; i++)
		// if user have not selected this satellite
		if (dlg->sat_map[i] == 0)
		{
			dlg->sat_map[i] = _enabled(i) << 4;		// use this state
			dlg->sat_map[i] |= r;					// remember this rnpi
		}
		// if user have selected this satellite
		else if ( (dlg->sat_map[i] >> 4) == _enabled(i) )
			dlg->sat_map[i] |= r;					// remember this rnpi

	// if it's not a last response
	if (--dlg->response_count)
		return;

	// show info
	for (int i=0; i < 32+24; i++)
		if ( dlg->rnpi_done_as(dlg->sat_map[i] & 0x0F) )		// if all rnpi have been catched for this satellite and have same parameter
		{
			// select state
			COLORREF bg, fg;
			if ( (dlg->sat_map[i] >> 4) == 1)
			{
				bg = COLOR_BG;
				fg = COLOR_FG;
			}
			else
			{
				bg = COLOR_FG;
				fg = COLOR_BG;
			}

			// select grid
			CGridCtrl *grid;
			int row,col;
			if (i < 32)
			{
				grid = &dlg->gps;
				row = i/4;
				col = i%4;
			}
			else
			{
				grid = &dlg->gln;
				row = (i-32)/4;
				col = (i-32)%4;
			}

			// set state
			grid->SetItemBkColour(row, col, bg);
			grid->SetItemFgColour(row, col, fg);
		}

	// update grids
	dlg->gps.Refresh();
	dlg->gln.Refresh();

	// remove selections
	dlg->OnBnClicked12ClearGps();
	dlg->OnBnClicked12ClearGln();

	// turn timer off
	dlg->tmr_off();
	dlg->tmr_do();

#undef	dlg
#include "bcp2packet.h"

}

void CWindow12::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_12_GPS, gps);
	DDX_GridControl(pDX, IDC_12_GLN, gln);
}


BEGIN_MESSAGE_MAP(CWindow12, CWindow)
	ON_BN_CLICKED(IDC_12_SET, OnBnClicked12Set)
	ON_BN_CLICKED(IDC_12_CLEAR_GPS, OnBnClicked12ClearGps)
	ON_BN_CLICKED(IDC_12_CLEAR_GLN, OnBnClicked12ClearGln)
END_MESSAGE_MAP()


// CWindow12 message handlers

BOOL CWindow12::OnInitDialog()
{
	// init device selector
	ds_init(dl_12);

	CWindow::OnInitDialog();

	SetDlgItemText(IDC_12_SET, TITLE_SET);

	////////////////
	// init GPS grid
	////////////////

	grid_init(&gps, 22,25, 8,4, 0,0, false, true, 0, 0);

	// lines color
	gps.SetGridLineColor(COLOR_FG);
	
	// cells
	for (int i=0; i<8; i++)	   
		for (int j=0; j<4; j++)
		{	
			gps.SetItemBkColour(i, j, COLOR_BG);
			gps.SetItemFgColour(i, j, COLOR_FG);
			gps.SetItemFormat(i, j, CELL_FMT_CENTER);
			gps.SetItemTextFmt(i, j, "%d", i*4 + j + 1);
		}

	////////////////
	// init GLN grid
	////////////////

	grid_init(&gln, 22,25, 6,4, 0,0, false, true, 0, 0);

	// lines color
	gln.SetGridLineColor(COLOR_FG);
	
	// cells
	for (int i=0; i<6; i++)	   
		for (int j=0; j<4; j++)
		{	
			gln.SetItemBkColour(i, j, COLOR_BG);
			gln.SetItemFgColour(i, j, COLOR_FG);
			gln.SetItemFormat(i, j, CELL_FMT_CENTER);
			gln.SetItemTextFmt(i, j, "%d", i*4 + j + 1);
		}

	///////////////////
	// get current info
	///////////////////

	char *fmtOriginal = bcp->Format[0x12];
	bcp->Format[0x12] = "C";

	bcp->Handler[0x47] = got47_12;
	rnpi_init(0xff, 0);
	ClearSatMap();
	response_count = (ds_get() == 0x80) ? 4 : 1;
	tmr_on();

	size = bcp->MakePacket(p, 0x12, ds_get() | 0x01);
	sendp();

	bcp->Format[0x12] = fmtOriginal;

	SwitchInterface(false);

	return TRUE;
}

void CWindow12::ClearSatMap()
{
	for (int i=0; i < 32+24; i++)
		sat_map[i] = 0;
}

void CWindow12::OnBnClicked12Set()
{
	// don't touch anything! :)
	///////////////////////////

	SwitchInterface(false);

	// prepare sat_map
	//////////////////

	ClearSatMap();
	response_count = 0;

	// GPS
	for (int i=0; i < 32; i++)
		if (gps.IsCellSelected(i/4, i%4))
		{
			response_count += (ds_get() == 0x80) ? 4 : 1;
			if (gps.GetItemBkColour(i/4, i%4) == COLOR_BG)
				sat_map[i] = 0x20;
			else
				sat_map[i] = 0x10;
		}

	// GLN
	for (int i=0; i < 24; i++)
		if (gln.IsCellSelected(i/4, i%4))
		{
			response_count += (ds_get() == 0x80) ? 4 : 1;
			if (gln.GetItemBkColour(i/4, i%4) == COLOR_BG)
				sat_map[32+i] = 0x20;
			else
				sat_map[32+i] = 0x10;
		}

	// if nothing is selected
	if (!response_count)
	{
		SwitchInterface(true);
		return;
	}

	// prepare catching
	///////////////////

	bcp->Handler[0x47] = got47_12;
	rnpi_init(0xff, 0);
	tmr_on();

	// send all requests
	////////////////////

	// GPS
	for (int i=0; i < 32; i++)
		if (sat_map[i])
		{
			size = bcp->MakePacket(p, 0x12, ds_get() | 0x01, INT8U(i+1), INT8U(sat_map[i] >> 4));
			sendp();
		}

	// GLN
	for (int i=0; i < 24; i++)
		if (sat_map[32+i])
		{
			size = bcp->MakePacket(p, 0x12, ds_get() | 0x02, INT8U(i+1), INT8U(sat_map[32+i] >> 4));
			sendp();
		}
}

void CWindow12::OnBnClicked12ClearGps()
{
	for (int i=0; i<8; i++)
		for (int j=0; j<4; j++)
			if (gps.IsCellSelected(i, j))
				gps.SetItemState(i, j, gps.GetItemState(i, j) ^ GVIS_SELECTED);
	gps.Refresh();
}

void CWindow12::OnBnClicked12ClearGln()
{
	for (int i=0; i<6; i++)
		for (int j=0; j<4; j++)
			if (gln.IsCellSelected(i, j))
				gln.SetItemState(i, j, gln.GetItemState(i, j) ^ GVIS_SELECTED);
	gln.Refresh();
}

void CWindow12::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_12_SET, OnOff);
	ENABLE_ITEM(IDC_12_GPS, OnOff);
	ENABLE_ITEM(IDC_12_GLN, OnOff);
	ENABLE_ITEM(IDC_12_CLEAR_GPS, OnOff);
	ENABLE_ITEM(IDC_12_CLEAR_GLN, OnOff);
}

void CWindow12::tmr_do()
{
	bcp->Handler[0x47] = 0;
	SwitchInterface(true);
}


#undef COLOR_BG
#undef COLOR_FG