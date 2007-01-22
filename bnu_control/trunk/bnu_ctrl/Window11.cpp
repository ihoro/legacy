#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow11 dialog

INT8U ds_11[] =
{
	0x80,
	0x70,
	0x00,
	0x10,
	0x20,
	0x40
};

IMPLEMENT_DYNAMIC(CWindow11, CWindow)
CWindow11::CWindow11(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID),
	beganStart(false),
	beganGet(false)
{
	Create(IDD, pParent);
}

CWindow11::~CWindow11()
{
	bcp->Handler[0x43] = 0;
}

void got43_11(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow11*) (mdlg->wnd[WND_11]) )
#define	BCP_PACKET		0x43
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_type))
		return;

	if (dlg->beganStart)
	{
		if (dlg->rnpi_done())
		{
			dlg->tmr_off();
			dlg->SendDlgItemMessage(IDC_11_INFO, WM_SETTEXT, 0, (LPARAM)"Идет тестирование...");
			dlg->rnpi_my_init(2);
			dlg->beganStart = false;
			dlg->beganGet = true;
			dlg->tmr_on();
			dlg->no_info = true;
		}
	}
	else
	{
		CString s, s2;

		// prepare results of one rnpi test
		if (DEVICE != 1)
		{
			// form common info
			s2.LoadString(IDS_11_RNPI_TEST_RESULTS);
			s.Format(s2, (_type == 0x42) ? 4 : ((_type & 0xF0) >> 4) + 1,
				(_devices & 0x10) ? "ошибка" : "OK",
				(_devices & 0x20) ? "ошибка" : "OK",
				(_devices & 0x40) ? "ошибка" : "OK",
				(_devices & 0x80) ? "ошибка" : "OK");

			// form info about channels
			int j = 0;
			for (int i=0; i<32; i++)
				if (_channels & (1 << i))
				{
					s2.Format("%d", i+1);
					if (j > 0)
						s += "," + s2;
					else
						s += s2;
					j++;
				}
			if (!j)
				s += "OK";

			if (DEVICE == 0)
				s += "\r\n\r\n";
		}

		// prepare results of cpu test
		else
		{
			s2.LoadString(IDS_11_CPU_TEST_RESULTS);
			s.Format(s2,
					 (_devices & 0x01) ? "ошибка" : "OK",
					 (_devices & 0x02) ? "ошибка" : "OK",
					 (_devices & 0x04) ? "ошибка" : "OK",
					 (_devices & 0x08) ? "ошибка" : "OK",
					 (_channels & 0x01) ? "ошибка" : "OK",
					 (_channels & 0x02) ? "ошибка" : "OK",
					 (_channels & 0x04) ? "ошибка" : "OK",
					 (_channels & 0x08) ? "ошибка" : "OK",
					 (_channels & 0x10) ? "ошибка" : "OK"
					 );
		}

		// set/add info
		if (dlg->no_info)
		{
            dlg->SetDlgItemText(IDC_11_INFO, s);
			dlg->no_info = false;
		}
		else
		{
			dlg->GetDlgItemText(IDC_11_INFO, s2);
			s2 += s;
			dlg->SetDlgItemText(IDC_11_INFO, s2);
		}

		// if it's enough
		if (dlg->rnpi_done())
		{
			dlg->tmr_off();
			dlg->tmr_do();
		}
	}

#undef	dlg
#include "bcp2packet.h"

}

void CWindow11::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CWindow11, CWindow)
	ON_BN_CLICKED(IDC_11_BEGIN, OnBnClicked11Begin)
	ON_BN_CLICKED(IDC_11_RESULTS, OnBnClicked11Results)
END_MESSAGE_MAP()


BOOL CWindow11::OnInitDialog()
{
	CWindow::OnInitDialog();

	// set font of memo
	SendDlgItemMessage(IDC_11_INFO, WM_SETFONT, (WPARAM)lfMonospace, 0);

	return TRUE;
}


// CWindow11 message handlers

void CWindow11::OnBnClicked11Begin()
{
	rnpi_my_init(1);

	// send 11h
	size = bcp->MakePacket(p, 0x11, ds_11[DEVICE] + 1);
	beganStart = true;
	tmr_on(IDS_11_ERR_TEST_BEGIN, GET_ONLINE_STATUS_TIMEOUT);
	bcp->Handler[0x43] = got43_11;
	sendp();

	// switch interface
	CString s;
	s.LoadString(IDS_PERFORMING);
	SetDlgItemText(IDC_11_BEGIN, s);
	SwitchInterface();
}

void CWindow11::OnBnClicked11Results()
{
	no_info = true;

	rnpi_my_init(2);

	size = bcp->MakePacket(p, 0x11, ds_11[DEVICE]);
	beganGet = true;
	tmr_on();
	bcp->Handler[0x43] = got43_11;
	sendp();

	SwitchInterface();
}

void CWindow11::SwitchInterface()
{
	ENABLE_ITEM(IDC_11_RESULTS, !(beganStart | beganGet));
	ENABLE_ITEM(IDC_11_BEGIN, !(beganStart | beganGet));
}

void CWindow11::tmr_do()
{
	beganStart = false;
	beganGet = false;
	bcp->Handler[0x43] = 0;

	CString s;
	s.LoadString(IDS_LAUNCH);
	SetDlgItemText(IDC_11_BEGIN, s);
	SwitchInterface();
}

void CWindow11::rnpi_my_init(INT8U mask)
{
	// init internal rnpi checker
	switch (DEVICE)
	{
	case 0: rnpi_init(4, mask); break;
	case 1: rnpi_init(5, 0x80|mask); break;
	case 2: rnpi_init(0, mask); break;
	case 3: rnpi_init(1, mask); break;
	case 4: rnpi_init(2, mask); break;
	case 5: rnpi_init(3, mask); break;
	}
}