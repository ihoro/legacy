#include "stdafx.h"
#include "bnu_ctrl.h"


#define info_size	(														\
						((wid & 0x40) == 0)									\
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


// CWindowInfo dialog

IMPLEMENT_DYNAMIC(CWindowInfo, CWindow)
CWindowInfo::CWindowInfo(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	dlg = (CWindow19_20*)pParent;
	
	flat_id = wndID & 0x3F;
	system = (flat_id < 32) ? 1 : 2;
	num = (flat_id < 32) ? flat_id + 1 : flat_id - 31;

	Create(IDD, pParent);
}

CWindowInfo::~CWindowInfo()
{
}

void CWindowInfo::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CWindowInfo, CWindow)
END_MESSAGE_MAP()


// CWindowInfo message handlers

BOOL CWindowInfo::OnInitDialog()
{

#define wx_modifier		+10
#define wy_modifier		+23

	RECT wr, ir;

	switch (((wid & 0x40) >> 6) * 2 + (system - 1))
	{
	case 0:
		ir.right = 360;
		ir.bottom = 303;		
		break;
	case 1:
		ir.right = 335;
		ir.bottom = 187;
		break;
	case 2:
		ir.right = 320;
		ir.bottom = 187;
		break;
	case 3:
		ir.right = 310;
		ir.bottom = 147;
		break;
	}

	GetWindowRect(&wr);
	wr.right = wr.left-1 + ir.right + wx_modifier;
	wr.bottom = wr.top-1 + ir.bottom + wy_modifier;
	MoveWindow(&wr);

	CWnd *iw = GetDlgItem(IDC_INFO_INFO);
	iw->SetWindowPos(0, 0,0, ir.right,ir.bottom, SWP_NOMOVE|SWP_NOZORDER);


	CWindow::OnInitDialog();

	ShowInfo();

	return TRUE;

#undef	wx_modifier
#undef	wy_modifier

}

void CWindowInfo::ShowInfo()
{
	CString s, s2;
	
	char *fmt_original = bcp->Format[ (wid & 0x40) ? 0x20 : 0x19 ];
	BCP_VALUE v[23];

	// if info exist
	if ( dlg->si_ok[flat_id] )
	{
		// prepare pointer
		char *p = dlg->si;
		if (system == 2)
		{
			system = 1;
			p += 32 * info_size;
			system = 2;
		}
		p += (num-1) * info_size;

		// get packets data format
		int id = ((wid & 0x40) >> 6) * 2 + (system - 1);
		bcp->Format[ (wid & 0x40) ? 0x40 : 0x49 ] = bcp->Format4940[id];

		// get values
		bcp->ExpandPacket(p, (wid & 0x40) ? 0x40 : 0x49, v);

		// prepare format
		s2.LoadString(IDS_EPHEMERID_GPS + id);

		// form info
		switch (id)
		{
		case 0:
			s.Format(s2, v[0].f, v[1].f, v[2].d, v[3].f, v[4].d, v[5].f, v[6].d, v[7].d, v[8].f, v[9].d, v[10].f, v[11].d, v[12].f, v[13].d, v[14].d, v[15].d, v[16].f, v[17].d, v[18].f, v[19].f, v[20].f, v[21].S, v[22].S);
			break;
		case 1:
			s.Format(s2, v[0].c, v[1].d, v[2].d, v[3].d, v[4].d, v[5].d, v[6].d, v[7].d, v[8].d, v[9].d, v[10].d, v[11].f, v[12].f, v[13].S);
			break;
		case 2:
			s.Format(s2, v[0].C, v[1].C, v[2].f, v[3].f, v[4].f, v[5].d, v[6].f, v[7].f, v[8].f, v[9].f, v[10].f, v[11].f, v[12].D, v[13].s);
			break;
		case 3:
			s.Format(s2, v[0].C, v[1].C, v[2].f, v[3].f, v[4].f, v[5].f, v[6].f, v[7].f, v[8].d, v[9].f, v[10].s);
			break;
		}
	}
	else
		s.LoadString(IDS_NO_SAT_INFO);

	bcp->Format[ (wid & 0x40) ? 0x40 : 0x49 ] = fmt_original;

	// show info
	SetDlgItemText(IDC_INFO_INFO, s);
}

#undef	info_size