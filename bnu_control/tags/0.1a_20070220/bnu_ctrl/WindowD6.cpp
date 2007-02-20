// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowD6 dialog

INT8U dl_D6[] =
{
	0x80,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

IMPLEMENT_DYNAMIC(CWindowD6, CWindow)
CWindowD6::CWindowD6(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID),
	OnOff(2)
{
	Create(IDD, pParent);
}

CWindowD6::~CWindowD6()
{
	bcp->Handler[0xE6] = 0;
}

void gotE6_D6(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowD6*) (mdlg->wnd[WND_D6]) )
#define	BCP_PACKET		0xE6
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_status))
		return;

	if (dlg->rnpi_done())
	{
		if (dlg->OnOrOff)
			dlg->OnOff = 1;
		else
			dlg->OnOff = 0;

		dlg->Invalidate();
		dlg->tmr_off();
		dlg->tmr_do();
	}

#undef	dlg
#include "bcp2packet.h"

}

void CWindowD6::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CWindowD6, CWindow)
	ON_WM_PAINT()
	ON_BN_CLICKED(IDC_D6_ON, OnBnClickedD6On)
	ON_BN_CLICKED(IDC_D6_OFF, OnBnClickedD6Off)
END_MESSAGE_MAP()

// CWindowD6 message handlers

BOOL CWindowD6::OnInitDialog()					
{
	// init device selector
	ds_init(dl_D6);

	CWindow::OnInitDialog();
	
	LOGFONT lf = {-11,8,0,0,700,0,0,0,-52,1,2,1,34,"MS Sans Serif"};
	fntState.CreateFontIndirect(&lf);

	SetDlgItemText(IDC_D6_ON, TITLE_ON);
	SetDlgItemText(IDC_D6_OFF, TITLE_OFF);

	return TRUE;
}  

void CWindowD6::OnPaint()
{
	CWindow::OnPaint();

	HBRUSH br = ::CreateSolidBrush(0);
	RECT r;
	r.left = 0;
	r.top = 20;
	r.right = 90;
	r.bottom = 110;
	::FillRect(dc, &r, br);
	::DeleteObject(br);

	if (OnOff == 2)
		return;
	
	::SelectObject(dc, fntState.m_hObject);
	
	::SetBkColor(dc, RGB(0,0,0));
	::SetTextColor(dc, OnOff ? RGB(0,255,0) : RGB(255,0,0) );

	if (OnOff)
		::TextOut(dc, 11,22, "Включен", 7);
	else
		::TextOut(dc, 7,22, "Выключен", 8);

	::EndPaint(m_hWnd, &ps);
}

void CWindowD6::OnBnClickedD6On()
{
	size = bcp->MakePacket(p, 0xD6, ds_get() + 1);
	OnOrOff = true;
	rnpi_init(0xff, 1);
	bcp->Handler[0xE6] = gotE6_D6;
	tmr_on();
	sendp();

	SwitchInterface(false);
}

void CWindowD6::OnBnClickedD6Off()
{
	size = bcp->MakePacket(p, 0xD6, ds_get());
	OnOrOff = false;
	rnpi_init(0xff, 0);
	bcp->Handler[0xE6] = gotE6_D6;
	tmr_on();
	sendp();

	SwitchInterface(false);
}

void CWindowD6::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_D6_ON, OnOff);
	ENABLE_ITEM(IDC_D6_OFF, OnOff);
}

void CWindowD6::tmr_do()
{
	bcp->Handler[0xE6] = 0;
	SwitchInterface(true);
}