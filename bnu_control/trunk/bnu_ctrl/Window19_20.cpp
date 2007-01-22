// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// timer
	#ifndef _DEBUG
#define REQUEST_TIME_OUT	10*1000			// 30 sec
	#else
#define REQUEST_TIME_OUT	3*1000			// 3 sec
	#endif

// ofn
OPENFILENAME ofn[2];	// [0] for 0x19, [1] for 0x20

// sat_info
#define flat_index	( (system - 1)*32 + num - 1 )
#define info_size	(														\
						(wid == WND_19)										\
						?													\
							(system == 1)									\
							?												\
								SIZEOF_EPHEMERID_GPS						\
							:												\
								SIZEOF_EPHEMERID_GLN						\
						:													\
							(system == 1)									\
							?												\
								SIZEOF_ALMANAC_GPS							\
							:												\
								SIZEOF_ALMANAC_GLN							\
					)

// colors
int CELL_BG_COLOR[] =
{
	RGB(192, 192, 192),
	RGB(31, 224, 46),
	RGB(234, 0, 0)
};
#define CELL_FG_COLOR	RGB(0, 0, 0)
#define GRID_LINE_COLOR	RGB(128, 128, 128)


// CWindow19_20 dialog

INT8U dl_19_20[] =
{
	0x00,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

IMPLEMENT_DYNAMIC(CWindow19_20, CWindow)
CWindow19_20::CWindow19_20(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	// init device selector
	ds_init(dl_19_20);

	// what ofn?
	ofn_id = (wid == WND_19) ? 0 : 1;

	// init common ofn params
	ofn[ofn_id].lStructSize = sizeof(OPENFILENAME);
	ofn[ofn_id].hwndOwner = m_hWnd;
	if (wid == WND_19)
	{
		ofn[ofn_id].lpstrFilter = "Ephemerid Info Files (*.eph)\x00*.eph\x00";
		ofn[ofn_id].lpstrDefExt = "eph";
	}
	else
	{
		ofn[ofn_id].lpstrFilter = "Almanac Info Files (*.alm)\x00*.alm\x00";
		ofn[ofn_id].lpstrDefExt = "alm";
	}
	ofn[ofn_id].nMaxFile = FILE_PATH_NAME_MAX_SIZE;
	ofn[ofn_id].lpstrInitialDir = DIR_PROGRAM_ROOT;

	// prepare windows pointers
	for (int i=0; i<IWND_MAX; i++)
		iwnd[i] = 0;

	// prepare memory for si
	si_size =
		(wid == WND_19)
		?
			SIZEOF_EPHEMERID_GPS * 32  +  SIZEOF_EPHEMERID_GLN * 24
		:
			SIZEOF_ALMANAC_GPS * 32  +  SIZEOF_ALMANAC_GLN * 24
		;
	si = (char*)malloc(si_size);


	Create(IDD, pParent);
}

CWindow19_20::~CWindow19_20()
{
	// kill windows
	iwndCloseAll();

	// free memory of si
	free(si);

	// don't catch anything
	if (wid == WND_19)
	{
		bcp->Handler[0x49] = 0;
		size = bcp->MakePacket(p, 0x19, ~(ds_get() >> 4), 0);
		sendp();		
	}
	else
		bcp->Handler[0x40] = 0;
}

void got49_19(INT8U *data_ptr, INT32U data_size)
{

#define dlg			( (CWindow19_20*) (mdlg->wnd[WND_19]) )

	dlg->gotten(data_ptr, data_size);

#undef	dlg

}

void got40_20(INT8U *data_ptr, INT32U data_size)
{

#define dlg			( (CWindow19_20*) (mdlg->wnd[WND_20]) )

	if (dlg->gotten(data_ptr, data_size))
		bcp->Handler[0x40] = 0;			// enough

#undef	dlg
	
}

bool CWindow19_20::gotten(INT8U *data_ptr, INT32U data_size)
{

#define	BCP_PACKET		0x40
#include "bcp2packet.h"

	// check rnpi
	if (!rnpi_add(_rnpi))
		return false;

	INT8U system = _system;
	INT8U num = _num;

	// check system & num
	if
	(
		!
		(
			(system == 1 && num >= 1 && num <= 32) ||
			(system == 2 && num >= 1 && num <= 24)
		)
	)
		return false;

	// if it's new sat_info
	if ( si_ok[flat_index] == 3 )				// if state currently is unknown
		sat_gotten++;

	// set state (0/1)
	si_ok[flat_index] = (data_size > 2) ? 1 : 0;
	if (wid == WND_20 && data_size > 2)
		if (*_info > 0)							// if health > 0
			si_ok[flat_index] = 2;				// bad state (for almanac only)

	// copy info, if it exists
	if (data_size > 2)
	{
		char *p = si;
		if (system == 2)
		{
			system = 1;
			p += 32 * info_size;
			system = 2;
		}
		memcpy(p + (num-1) * info_size, _info, info_size);
	}

	// show it to user
	UpdateSatInfo(system, num);

	// if it's enough
	if (sat_gotten == 56)
	{
		tmr_off();
		tmr_do();
		return true;
	}
    
	return false;

#include "bcp2packet.h"

}

void CWindow19_20::UpdateSatInfo(INT8U system, INT8U num)
{
	CGridCtrl *grid;
	int row, col;	

	// get grid/row/col/
	if (system == 1)
	{
		grid = &gps;
		row = (num-1) / 16;
		col = (num-1) % 16;
	}
	else
	{
		grid = &gln;
		row = (num-1) / 12;
		col = (num-1) % 12;
	}

	// set cell's state
	grid->SetItemBkColour(row, col, CELL_BG_COLOR[ si_ok[flat_index] ]);
	grid->SetItemFgColour(row, col, CELL_FG_COLOR);

	// update cell
	grid->RedrawCell(row, col);

	// update info-window if it's opened
	if (iwnd[flat_index])
		iwnd[flat_index]->ShowInfo();
}

void CWindow19_20::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_19_20_GPS, gps);
	DDX_GridControl(pDX, IDC_19_20_GLN, gln);
}

BEGIN_MESSAGE_MAP(CWindow19_20, CWindow)
	ON_NOTIFY(NM_DBLCLK, IDC_19_20_GPS, OnGpsDblClick)
	ON_NOTIFY(NM_DBLCLK, IDC_19_20_GLN, OnGlnDblClick)
	ON_BN_CLICKED(IDC_19_20_SAVE, OnBnClicked1920Save)
	ON_BN_CLICKED(IDC_19_20_GET, OnBnClicked1920Get)
	ON_WM_TIMER()
	ON_BN_CLICKED(IDC_19_20_SET, OnBnClicked1920Set)
	ON_BN_CLICKED(IDC_19_20_LOAD, OnBnClicked1920Load)
END_MESSAGE_MAP()


// CWindow19_20 message handlers

BOOL CWindow19_20::OnInitDialog()
{
	CWindow::OnInitDialog();

	// init progress bar
	SendDlgItemMessage(IDC_19_20_PROGRESS, PBM_SETBARCOLOR, 0, RGB(10, 181, 245));
	SendDlgItemMessage(IDC_19_20_PROGRESS, PBM_SETRANGE32, 0, REQUEST_TIME_OUT / 1000);

	////////////////
	// init gps-grid
	////////////////

	grid_init(&gps, 18,19, 2,16, 0,0, false, false, 0, 0);
	gps.SetGridLineColor(GRID_LINE_COLOR);
	
	// headers names & format
	for (int i=0; i<2; i++)
		for (int j=0; j<16; j++)
		{
			gps.SetItemTextFmt(i, j, "%d", i*16 + j + 1);
			gps.SetItemFormat(i, j, CELL_FMT_CENTER);
		}

	////////////////
	// init gln-grid
	////////////////

	grid_init(&gln, 18,19, 2,12, 0,0, false, false, 0, 0);
	gln.SetGridLineColor(GRID_LINE_COLOR);
	
	// headers names & format
	for (int i=0; i<2; i++)
		for (int j=0; j<12; j++)
		{
			gln.SetItemTextFmt(i, j, "%d", i*12 + j + 1);
			gln.SetItemFormat(i, j, CELL_FMT_CENTER);
		}


	// reset all cells
	ResetCells();

	return TRUE;
}

void CWindow19_20::ResetCells()
{							  
	// gps
	for (int i=0; i<2; i++)
		for (int j=0; j<16; j++)
		{
			gps.SetItemBkColour(i, j, CELL_BG_COLOR[0]);
			gps.SetItemFgColour(i, j, CELL_FG_COLOR);
		}

	// gln
	for (int i=0; i<2; i++)
		for (int j=0; j<12; j++)
		{
			gln.SetItemBkColour(i, j, CELL_BG_COLOR[0]);
			gln.SetItemFgColour(i, j, CELL_FG_COLOR);
		}
}

bool iprocClose(unsigned char id)
{
	if (id & 0x40)
		return ( (CWindow19_20*) (mdlg->wnd[WND_20]) ) -> iwndClose(id & 0x3F);
	else
		return ( (CWindow19_20*) (mdlg->wnd[WND_19]) ) -> iwndClose(id & 0x3F);
}

bool CWindow19_20::iwndOpen(unsigned char id)
{
	if (iwnd[id])
		return false;		// already opened
	if (id >= IWND_MAX)
		return false;		// wrong window's id

	// create window
	iwnd[id] = new CWindowInfo(this, iprocClose,
							   // full id:
							   (id | 0x80) | ((wid == WND_19) ? 0x00 : 0x40) );

	// show window
	iwnd[id]->ShowWindow(SW_NORMAL);

	return true;
}

bool CWindow19_20::iwndClose(unsigned char id)
{
	if (!iwnd[id])
		return false;		// already closed
	if (id >= IWND_MAX)
		return false;		// wrong window's id
	if (iwnd[id]->isBusy)
		return false;		// window's waiting for message box or something else

	// save settings
	iwnd[id]->ini_save();

	// delete window
	delete iwnd[id];
	iwnd[id] = 0;

	return true;
}

void CWindow19_20::iwndCloseAll()
{
	for (int i=0; i < IWND_MAX; i++)
		iwndClose(i);
}

void CWindow19_20::iwndSwitch(unsigned char id)
{
	if (iwnd[id])
		iwndClose(id);
	else
		iwndOpen(id);
}

void CWindow19_20::OnGpsDblClick(NMHDR *pNotifyStruct, LRESULT* pResult)
{
	iwndSwitch(
		((NM_GRIDVIEW*)pNotifyStruct)->iRow*16 + ((NM_GRIDVIEW*)pNotifyStruct)->iColumn
	);
}

void CWindow19_20::OnGlnDblClick(NMHDR *pNotifyStruct, LRESULT* pResult)
{
	iwndSwitch(
		((NM_GRIDVIEW*)pNotifyStruct)->iRow*12 + ((NM_GRIDVIEW*)pNotifyStruct)->iColumn + 32
	);
}

void CWindow19_20::OnBnClicked1920Save()
{
	char fp[FILE_PATH_NAME_MAX_SIZE];
	
	// init
	ofn[ofn_id].lpstrFile = fp;
	ofn[ofn_id].Flags = OFN_EXPLORER |
						OFN_ENABLESIZING |
						OFN_LONGNAMES |
						OFN_PATHMUSTEXIST |
						OFN_OVERWRITEPROMPT;

	// template name
	CTime t;
	t = t.GetCurrentTime();
	wsprintf(fp,
			 "%.4d.%.2d.%.2d_%.2d-%.2d-%.2d",
			 t.GetYear(), t.GetMonth(), t.GetDay(),
			 t.GetHour(), t.GetMinute(), t.GetSecond());

	// select file & save info
	isBusy = true;
	if (GetSaveFileName(&ofn[ofn_id]))
	{
		HANDLE f;

		if ( (f = CreateFile(fp, GENERIC_WRITE, 0, 0, CREATE_ALWAYS, 0, 0)) != INVALID_HANDLE_VALUE )
		{			
			int cSet;

			// si_ok
			WriteFile(f, si_ok, 56, (LPDWORD)&cSet, 0);
			// si
			WriteFile(f, si, si_size, (LPDWORD)&cSet, 0);

			CloseHandle(f);
		}
		else
		{
			CString s, s2;
			s.LoadString(IDS_FILE_ERR_CREATE);
			s2.LoadString(IDS_ERROR);
			MessageBox(s, s2, MB_OK | MB_ICONERROR);
		}
	}
	isBusy = false;
}

void CWindow19_20::OnBnClicked1920Load()
{
	CString s, s2;
	char fp[FILE_PATH_NAME_MAX_SIZE];
	
	// init
	ofn[ofn_id].lpstrFile = fp;
	fp[0] = 0;
	ofn[ofn_id].Flags = OFN_EXPLORER |
						OFN_ENABLESIZING |
						OFN_HIDEREADONLY |
						OFN_LONGNAMES |
						OFN_PATHMUSTEXIST |
						OFN_FILEMUSTEXIST;

	// select file & load info
	isBusy = true;
	if (GetOpenFileName(&ofn[ofn_id]))
	{
		HANDLE f;

		if ( (f = CreateFile(fp, GENERIC_READ, 0, 0, OPEN_EXISTING, 0, 0)) != INVALID_HANDLE_VALUE )
		{
			// check file size
			if ( GetFileSize(f, 0) != 56 + si_size )
			{
				CloseHandle(f);

				s.LoadString(IDS_FILE_ERR_BAD);
				s2.LoadString(IDS_ERROR);
				MessageBox(s, s2, MB_OK | MB_ICONERROR);

				isBusy = false;
				return;
			}

			int cGot;

			// si_ok
			ReadFile(f, si_ok, 56, (LPDWORD)&cGot, 0);
			// si
			ReadFile(f, si, si_size, (LPDWORD)&cGot, 0);

			CloseHandle(f);

			// update info
			for (int i=0; i<56; i++)
				UpdateSatInfo((i<32) ? 1 : 2, (i<32) ? i+1 : i-31);

			SwitchInterface(true, false);
		}
		else
		{
			s.LoadString(IDS_FILE_ERR_OPEN);
			s2.LoadString(IDS_ERROR);
			MessageBox(s, s2, MB_OK | MB_ICONERROR);
		}
	}
	isBusy = false;
}

void CWindow19_20::ResetSatOk()
{
	for (int i=0; i<56; i++)
		si_ok[i] = 3;				// set unknown state
}

void CWindow19_20::OnBnClicked1920Get()
{
	// init progress bar
	SendDlgItemMessage(IDC_19_20_PROGRESS, PBM_SETPOS, 0, 0);

	// switch interface
	SwitchInterface(false, true);
	ResetCells();

	// progress status timer (every second)
	tmr_counter = 0;
	SetTimer(1, 1000, 0);

	// reset sat_info
	sat_gotten = 0;
	ResetSatOk();

	// time out timer
	tmr_on(0, REQUEST_TIME_OUT);

	rnpi_init(0xff, 0);

	// send request(s)
	if (wid == WND_19)
	{
		bcp->Handler[0x49] = got49_19;
		size = bcp->MakePacket(p, 0x19, ~(ds_get() >> 4), 1);
		sendp();
	}
	else
	{
		bcp->Handler[0x40] = got40_20;

		// gps
		for (int i=1; i<=32; i++)
		{
			size = bcp->MakePacket(p, 0x20, ds_get() | 0x01, (INT8U)i);
			sendp();
		}

		// gln
		for (int i=1; i<=24; i++)
		{
			size = bcp->MakePacket(p, 0x20, ds_get() | 0x02, (INT8U)i);
			sendp();
		}
	}
}

void CWindow19_20::OnBnClicked1920Set()
{
	SwitchInterface(false, false);

	INT8U system;
	char *s = si;

	char *d = (char*)malloc(150);

	for (int i=0; i<56; i++)
	{
		// get system
		system = (i<32) ? 1 : 2;

		// if sat_info exists
		if (si_ok[i])
		{
			// form packet data header
			d[0] = ds_get() | system;					// rnpi & system
			d[1] = (system == 1) ? i+1 : i-31;			// sat_num

			// copy packet data
			memcpy(d+2, s, info_size);

			// fix packet data
			size = bcp->FixPacketData(d, info_size + 2, p+2);
			size += 2;

			// set packet's header/footer
			p[0] = 0x10;
			p[1] = (wid == WND_19) ? 0x19 : 0x20;
			p[size++] = 0x10;
			p[size++] = 0x03;

			// send it
			sendp();
		}

		// shift pointer
		s += info_size;
	}

	free(d);

	SwitchInterface(true, false);
}

void CWindow19_20::SwitchInterface(bool OnOff, bool ProgressBar)
{
	// grids & 4 buttons
	ENABLE_ITEM(IDC_19_20_GPS, OnOff);
	ENABLE_ITEM(IDC_19_20_GLN, OnOff);
	ENABLE_ITEM(IDC_19_20_GET, OnOff);
	ENABLE_ITEM(IDC_19_20_SET, OnOff);
	ENABLE_ITEM(IDC_19_20_SAVE, OnOff);
	ENABLE_ITEM(IDC_19_20_LOAD, OnOff);

	// progress bar
	SHOW_ITEM(IDC_19_20_PROGRESS, ProgressBar);

	// hide/show 4 buttons
	SHOW_ITEM(IDC_19_20_GET, !ProgressBar);
	SHOW_ITEM(IDC_19_20_SET, !ProgressBar);
	SHOW_ITEM(IDC_19_20_SAVE, !ProgressBar);
	SHOW_ITEM(IDC_19_20_LOAD, !ProgressBar);
}

void CWindow19_20::OnTimer(UINT nIDEvent)
{
	SendDlgItemMessage(IDC_19_20_PROGRESS, PBM_SETPOS, ++tmr_counter, 0);

	CWindow::OnTimer(nIDEvent);
}

void CWindow19_20::tmr_do()
{
	KillTimer(1);

	sat_gotten = 0;
	bcp->Handler[0x40] = 0;

	// check unknown state & update cells state and opened window's info
	for (int i=0; i<56; i++)
		if (si_ok[i] == 3)
		{
			si_ok[i] = 0;
			UpdateSatInfo((i<32) ? 1 : 2, (i<32) ? i+1 : i-31);
		}

	SwitchInterface(true, false);
}

#undef	flat_index
#undef	info_size