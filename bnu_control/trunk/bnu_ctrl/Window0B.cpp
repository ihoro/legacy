#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow0B dialog

INI_VALUE_INFO ivi_0B[] =
{
	{"port",		INI_TYPE_COMBOBOX, IDC_0B_PORT_NEW, 0},
	{"port_speed",	INI_TYPE_COMBOBOX, IDC_0B_SPEED_NEW, 0},
	{"type",		INI_TYPE_COMBOBOX, IDC_0B_TYPE_NEW, 0}
};

IMPLEMENT_DYNAMIC(CWindow0B, CWindow)
CWindow0B::CWindow0B(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow0B::~CWindow0B()
{
	bcp->Handler[0x50] = 0;
}

void got50_0B(INT8U *data_ptr, INT32U data_size)
{

#define dlg			( (CWindow0B*) (mdlg->wnd[WND_0B]) )
#define	BCP_PACKET	0x50
#include "bcp2packet.h"

	// check port number
	if (_port != dlg->get_port())
		return;

	CString s;

	// show port
	s.LoadString(IDS_0B_PORT_0 + dlg->get_index(_port));
	dlg->SetDlgItemText(IDC_0B_PORT, s);

	// show speed
	dlg->SetDlgItemInt(IDC_0B_SPEED, _speed, false);

	// show type
	dlg->SendDlgItemMessage(IDC_0B_TYPE_NEW, CB_GETLBTEXT, _type, (LPARAM)s.GetBufferSetLength(20));
	dlg->SetDlgItemText(IDC_0B_TYPE, s);

	dlg->tmr_off();
	dlg->tmr_do();

#undef	dlg
#include "bcp2packet.h"

}

void CWindow0B::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CWindow0B, CWindow)
	ON_BN_CLICKED(IDC_0B_GET, OnBnClicked0bGet)
	ON_BN_CLICKED(IDC_0B_SET, OnBnClicked0bSet)
END_MESSAGE_MAP()


// CWindow0B message handlers

BOOL CWindow0B::OnInitDialog()
{
	// specify settings
	ini_init(3, ivi_0B);

	SetDlgItemText(IDC_0B_GET, TITLE_GET);
	SetDlgItemText(IDC_0B_SET, TITLE_SET);

	// init port-combobox
	CString s;
	switch (DEVICE)
	{
	case 0: i0 = 0; i1 = 7; break;
	case 1: i0 = 0; i1 = 3; break;
	case 2: i0 = 4; i1 = 4; break;
	case 3: i0 = 5; i1 = 5; break;
	case 4: i0 = 6; i1 = 6; break;
	case 5: i0 = 7; i1 = 7; break;
	}
	for (int i = i0; i <= i1; i++)
	{
		s.LoadString(IDS_0B_PORT_0 + i);
		SendDlgItemMessage(IDC_0B_PORT_NEW, CB_ADDSTRING, 0, (LPARAM)s.GetBuffer());
	}

	CWindow::OnInitDialog();

	return TRUE;
}

void CWindow0B::OnBnClicked0bGet()
{
	char *fmt_original;
	fmt_original = bcp->Format[0x0B];
	bcp->Format[0x0B] = "C";

	size = bcp->MakePacket(p, 0x0B, get_port());
	bcp->Handler[0x50] = got50_0B;
	tmr_on();
	sendp();

	bcp->Format[0x0B] = fmt_original;

	SwitchInterface(false);
}

void CWindow0B::OnBnClicked0bSet()
{
	int type = (int)SendDlgItemMessage(IDC_0B_TYPE_NEW, CB_GETCURSEL, 0, 0);
	if (DEVICE == 0 && get_port() == 1)
		type = 0;

	size = bcp->MakePacket(p, 0x0B,
		get_port(),
		comSpeed[(char)SendDlgItemMessage(IDC_0B_SPEED_NEW, CB_GETCURSEL, 0, 0)],
		(INT8U)type
	);
	bcp->Handler[0x50] = got50_0B;
	tmr_on();
	sendp();

	SwitchInterface(false);
}

void CWindow0B::SwitchInterface(bool OnOff)
{
	for (int i=0; i<5; i++)
		ENABLE_ITEM(IDC_0B_PORT_NEW + i, OnOff);
}

void CWindow0B::tmr_do()
{
	bcp->Handler[0x50] = 0;
	SwitchInterface(true);
}

INT8U CWindow0B::get_port()
{
	int x = i0 + (int)SendDlgItemMessage(IDC_0B_PORT_NEW, CB_GETCURSEL, 0, 0);
	if (x < 4)
		return (INT8U)(x+1);
	else
		return (INT8U)((1 << x) | 1);
}

int CWindow0B::get_index(INT8U x)
{
	if (x & 0xF0)
		switch (x) 
		{
		case 0x11: return 4;
		case 0x21: return 5;
		case 0x41: return 6;
		case 0x81: return 7;
		default: return 0;
		}
	else
		return x-1;
}