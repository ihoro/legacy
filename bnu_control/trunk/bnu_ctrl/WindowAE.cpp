#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowAE dialog

INI_VALUE_INFO ivi_AE[] =
{
	{"dynamic", INI_TYPE_CHECKBOX, IDC_AE_DYNAMIC, 0}
};

IMPLEMENT_DYNAMIC(CWindowAE, CWindow)
CWindowAE::CWindowAE(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID),
	beganStart(false),
	beganCancel(false),
	beganGet(false)
{
	Create(IDD, pParent);
}

CWindowAE::~CWindowAE()
{
	bcp->Handler[0xAF] = 0;
}

void gotAF_AE(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowAE*) (mdlg->wnd[WND_AE]) )
#define	BCP_PACKET		0xAF
#include "bcp2packet.h"

	CString s, s2;

	if ( (dlg->beganGet || dlg->beganStart || dlg->beganCancel) && _type == 3)
	{
		s.LoadString(IDS_AE_NO_CALIB);
		dlg->SetDlgItemText(IDC_AE_INFO, s);

		dlg->tmr_off();
		dlg->tmr_do();
	}

	if (dlg->beganGet)
	{
		if (_type == 0)
		{
			s2.LoadString(IDS_AE_RESULTS);
			s.Format(s2,
					 _v[0], _v[1], _v[2], _v[3], _v[4], _v[5],
					 _v[6], _v[7], _v[8],
					 _v[9], _v[10], _v[11],
					 _v[12], _v[13], _v[14],
					 _v[15], _v[16], _v[17],
					 _v[18], _v[19], _v[20]);
			dlg->SetDlgItemText(IDC_AE_INFO, s);

			dlg->tmr_off();
			dlg->tmr_do();
		}
	}
	else if (dlg->beganStart)
	{
		if (_type == (dlg->dynamic ? 4 : 1))
		{
			dlg->tmr_off();
			dlg->tmr_on(TIMER_DEF_MSG_ID, TIMER_AE_CALIB);

			dlg->beganStart = false;
			dlg->beganGet = true;
			s.LoadString(dlg->dynamic ? IDS_AE_DOING_DYNAMIC : IDS_AE_DOING);
			dlg->SetDlgItemText(IDC_AE_INFO, s);
			s.LoadString(IDS_CANCEL);
			dlg->SetDlgItemText(IDC_AE_START, s);
			dlg->ENABLE_ITEM(IDC_AE_START, true);
		}
	}
	else if (dlg->beganCancel)
	{
		if (_type == 2)
		{
			s.LoadString(IDS_AE_CANCELED);
			dlg->SetDlgItemText(IDC_AE_INFO, s);

			dlg->tmr_off();
			dlg->tmr_do();
		}
	}

#undef	dlg
#include "bcp2packet.h"

}

void CWindowAE::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}

void CWindowAE::SwitchInterface()
{
	ENABLE_ITEM(IDC_AE_RESULTS, !(beganStart | beganCancel | beganGet));
	ENABLE_ITEM(IDC_AE_START, !(beganStart | beganCancel | beganGet));
	ENABLE_ITEM(IDC_AE_DYNAMIC, !(beganStart | beganCancel | beganGet));
}

BEGIN_MESSAGE_MAP(CWindowAE, CWindow)
	ON_BN_CLICKED(IDC_AE_START, OnBnClickedAeStart)
	ON_BN_CLICKED(IDC_AE_RESULTS, OnBnClickedAeResults)
END_MESSAGE_MAP()


// CWindowAE message handlers

BOOL CWindowAE::OnInitDialog()
{
	// specify settings
	ini_init(1, ivi_AE);

	CWindow::OnInitDialog();

	// set font of memo
	SendDlgItemMessage(IDC_AE_INFO, WM_SETFONT, (WPARAM)lfMonospace, 0);

	// set titles
	CString s;
	s.LoadString(IDS_RESULTS);
	SetDlgItemText(IDC_AE_RESULTS, s);
	s.LoadString(IDS_LAUNCH);
	SetDlgItemText(IDC_AE_START, s);

	bcp->Handler[0xAF] = gotAF_AE;

	return TRUE;
}

void CWindowAE::OnBnClickedAeStart()
{
	CString s;
	s.LoadString(IDS_PERFORMING);

	if (beganGet)
	{
		beganGet = false;
		beganCancel = true;
		size = bcp->MakePacket(p, 0xAE, 2);
		tmr_on(IDS_AE_CANCEL_ERR, GET_ONLINE_STATUS_TIMEOUT);
		sendp();
		SetDlgItemText(IDC_AE_START, s);
	}
	else
	{
		beganStart = true;
		size = bcp->MakePacket(p, 0xAE, ( dynamic = IsDlgButtonChecked(IDC_AE_DYNAMIC) > 0 ? 1 : 0 ) ? 4 : 1);  //fucking forcing
		tmr_on(IDS_AE_START_ERR, GET_ONLINE_STATUS_TIMEOUT);
		sendp();
		SetDlgItemText(IDC_AE_START, s);
	}

	SwitchInterface();
}

void CWindowAE::OnBnClickedAeResults()
{
	beganGet = true;

	size = bcp->MakePacket(p, 0xAE, 0);
	tmr_on();
	sendp();

	SwitchInterface();
}

void CWindowAE::tmr_do()
{
	CString s;

	beganGet = beganStart = beganCancel = false;
	s.LoadString(IDS_LAUNCH);
	SetDlgItemText(IDC_AE_START, s);
	SwitchInterface();
}